From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v4] string_helpers: fix precision loss for some inputs
Date: Fri, 06 Nov 2015 16:50:52 -0800
Message-ID: <1446857452.2166.25.camel@HansenPartnership.com>
References: <1446582810.6440.36.camel@HansenPartnership.com>
	 <1446585708.6440.47.camel@HansenPartnership.com>
	 <1446592360.6440.54.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446592360.6440.54.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>, "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>, "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>, "keescook@chromium.org" <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

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

---

v2: updated with a recommendation from Rasmus Villemoes to truncate the
initial precision at just under 32 bits

v3: put back the missing do_divs

v4: use explicit top bit checking in logarithmic reductions.  Only adjust
remainder precision where necessary

diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 5939f63..5c88204 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -43,50 +43,73 @@ void string_get_size(u64 size, u64 blk_size, const enum string_size_units units,
 		[STRING_UNITS_10] = 1000,
 		[STRING_UNITS_2] = 1024,
 	};
-	int i, j;
-	u32 remainder = 0, sf_cap, exp;
+	static const unsigned int rounding[] = { 500, 50, 5 };
+	int i = 0, j;
+	u32 remainder = 0, sf_cap;
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
 
-	while (blk_size >= divisor[units]) {
-		remainder = do_div(blk_size, divisor[units]);
+	/* This is Napier's algorithm.  Reduce the original block size to
+	 *
+	 * coefficient * divisor[units]^i
+	 *
+	 * we do the reduction so both coefficients are just under 32 bits so
+	 * that multiplying them together won't overflow 64 bits and we keep
+	 * as much precision as possible in the numbers.
+	 *
+	 * Note: it's safe to throw away the remainders here because all the
+	 * precision is in the coefficients.
+	 */
+	while (blk_size >> 32) {
+		do_div(blk_size, divisor[units]);
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
+	while (size >> 32) {
+		do_div(size, divisor[units]);
 		i++;
-	} else {
-		remainder *= size;
 	}
 
+	/* now perform the actual multiplication keeping i as the sum of the
+	 * two logarithms */
 	size *= blk_size;
-	size += remainder / divisor[units];
-	remainder %= divisor[units];
 
+	/* and logarithmically reduce it until it's just under the divisor */
 	while (size >= divisor[units]) {
 		remainder = do_div(size, divisor[units]);
 		i++;
 	}
 
+	/* work out in j how many digits of precision we need from the
+	 * remainder */
 	sf_cap = size;
 	for (j = 0; sf_cap*10 < 1000; j++)
 		sf_cap *= 10;
 
-	if (j) {
+	if (units == STRING_UNITS_2) {
+		/* express the remainder as a decimal.  It's currently the
+		 * numerator of a fraction whose denominator is
+		 * divisor[units], which is 1 << 10 for STRING_UNITS_2 */
 		remainder *= 1000;
-		remainder /= divisor[units];
+		remainder >>= 10;
+	}
+
+	/* add a 5 to the digit below what will be printed to ensure
+	 * an arithmetical round up and carry it through to size */
+	remainder += rounding[j];
+	if (remainder >= 1000) {
+		remainder -= 1000;
+		size += 1;
+	}
+
+	if (j) {
 		snprintf(tmp, sizeof(tmp), ".%03u", remainder);
 		tmp[j+1] = '\0';
 	}
