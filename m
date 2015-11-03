From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] string_helpers: fix precision loss for some inputs
Date: Tue, 03 Nov 2015 12:33:30 -0800
Message-ID: <1446582810.6440.36.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45020 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932576AbbKCUdc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2015 15:33:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>, "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>, "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>, "keescook@chromium.org" <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>

From: James Bottomley <JBottomley@Odin.com> 

It was noticed that we lose precision in the final calculation for some
inputs.  The most egregious example is size=3000 blk_size=1900 in units of 10
should yield 5.70 MB but in fact yields 3.00 MB (oops). This is because the
current algorithm doesn't correctly account for all the remainders in the
logarithms.  Fix this by doing a correct calculation in the remainders based
on napier's algorithm.  Additionally, now we have the correct result, we have
to account for arithmetic rounding because we're printing 3 digits of
precision.  This means that if the fourth digit is five or greater, we have to
round up, so add a section to ensure correct rounding.  Finally account for
all possible inputs correctly, including zero for block size.

Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: stable@vger.kernel.org	# delay backport by two months for testing
Fixes: b9f28d863594c429e1df35a0474d2663ca28b307
Signed-off-by: James Bottomley <JBottomley@Odin.com>

diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 5939f63..2ac77bf 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -43,37 +43,67 @@ void string_get_size(u64 size, u64 blk_size, const enum string_size_units units,
 		[STRING_UNITS_10] = 1000,
 		[STRING_UNITS_2] = 1024,
 	};
-	int i, j;
-	u32 remainder = 0, sf_cap, exp;
+	static const unsigned int rounding[] = { 500, 50, 5, 0};
+	int i = 0, j;
+	u32 remainder = 0, sf_cap, r1 = 0, r2 = 0;
 	char tmp[8];
 	const char *unit;
 
 	tmp[0] = '\0';
-	i = 0;
-	if (!size)
+
+	if (blk_size == 0)
+		size = 0;
+	if (size == 0)
 		goto out;
 
+	/* This is napier's algorithm.  Reduce the original block size to
+	 *
+	 * co * divisor[units]^i
+	 *
+	 * where co = blk_size + r1/divisor[units];
+	 *
+	 * and the same for size.  We simply add to the exponent i, because
+	 * the final calculation we're looking for is
+	 *
+	 * (co1 * co2) * divisor[units]^(i1 +i2)
+	 */
+
+
 	while (blk_size >= divisor[units]) {
-		remainder = do_div(blk_size, divisor[units]);
+		r1 = do_div(blk_size, divisor[units]);
 		i++;
 	}
 
-	exp = divisor[units] / (u32)blk_size;
-	/*
-	 * size must be strictly greater than exp here to ensure that remainder
-	 * is greater than divisor[units] coming out of the if below.
-	 */
-	if (size > exp) {
-		remainder = do_div(size, divisor[units]);
-		remainder *= blk_size;
+	while (size >= divisor[units]) {
+		r2 = do_div(size, divisor[units]);
 		i++;
-	} else {
-		remainder *= size;
 	}
 
-	size *= blk_size;
-	size += remainder / divisor[units];
-	remainder %= divisor[units];
+	/*
+	 * We've already added the exponents in i, now multiply the
+	 * coefficients:
+	 *
+	 * co1*co2 = (blk_size + r1/divisor[units])*(size + r2/divisor[units])
+	 *
+	 * therefore
+	 *
+	 * co1*co2 = blk_size*size
+	 *           + (r1*size + r2*size)/divisor[units]
+	 *           + r1*r2/divisor[units]/divisor[units]
+	 *
+	 * reduce the exponent by 2 (it can now go negative) to perform this
+	 * calculation without divisions (64 bit divisions are very painful on
+	 * 32 bit architectures), then redo the logarithm adjustment to bring
+	 * us back to the correct coefficient and exponent.  This calculation
+	 * can still not overflow because the largest term must be less than
+	 * divisor[units]^4, which is 40 bits
+	 *
+	 */
+
+	i -= 2;
+	size = size * blk_size * divisor[units] * divisor[units]
+	  + (r1 * size + r2 * blk_size) * divisor[units]
+	  + r1*r2;
 
 	while (size >= divisor[units]) {
 		remainder = do_div(size, divisor[units]);
@@ -84,9 +114,20 @@ void string_get_size(u64 size, u64 blk_size, const enum string_size_units units,
 	for (j = 0; sf_cap*10 < 1000; j++)
 		sf_cap *= 10;
 
+	/* express the remainder as a decimal (it's currently the numerator of
+	 * a fraction whose denominator is divisor[units]) */
+	remainder *= 1000;
+	remainder /= divisor[units];
+
+	/* add a 5 to the digit below what will be printed to ensure
+	 * an arithmetical round up and carry it through to size */
+	remainder += rounding[j];
+	if (remainder >= 1000) {
+		remainder -= 1000;
+		size += 1;
+	}
+
 	if (j) {
-		remainder *= 1000;
-		remainder /= divisor[units];
 		snprintf(tmp, sizeof(tmp), ".%03u", remainder);
 		tmp[j+1] = '\0';
 	}


