From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Subject: Re: [PATCH] utilities: add helper functions for safe 64-bit integer
 operations as 32-bit halves
Date: Sat, 21 Apr 2007 09:06:58 -0400 (EDT)
Message-ID: <alpine.DEB.0.98.0704210847340.3766@sigma.j-a-k-j.com>
References: <6.0.0.20.2.20070418160231.043f23c8@172.19.0.2>
 <226E1C65E4F6164E8EA5FD3CC913AE8CF461DE@G3W0639.americas.hpqcorp.net>
 <1176995934.31764.7.camel@mulgrave.il.steeleye.com>
 <226E1C65E4F6164E8EA5FD3CC913AE8CF462EE@G3W0639.americas.hpqcorp.net>
 <1176999730.31764.15.camel@mulgrave.il.steeleye.com>
 <558F4D473FD7FE419B019232BF2D37B401167D74@G3W0634.americas.hpqcorp.net>
 <20070419222028.d33c7f86.akpm@linux-foundation.org>
 <1177074641.3718.5.camel@mulgrave.il.steeleye.com>
 <20070420114337.12a67141.akpm@linux-foundation.org>
 <1177095007.3718.43.camel@mulgrave.il.steeleye.com>
 <20070420123041.94aac1e1.akpm@linux-foundation.org>
 <1177100459.3718.45.camel@mulgrave.il.steeleye.com>
 <20070420141218.a0222472.akpm@linux-foundation.org>
 <alpine.DEB.0.98.0704201732240.11655@sigma.j-a-k-j.com>
 <alpine.DEB.0.98.0704202040150.16687@sigma.j-a-k-j.com>
 <20070421030825.bed0b8a9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from seahorse.shentel.net ([204.111.1.244]:55347 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030973AbXDUNIY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Apr 2007 09:08:24 -0400
In-Reply-To: <20070421030825.bed0b8a9.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "Cameron, Steve" <Steve.Cameron@hp.com>, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, trivial@kernel.org

From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

Add helper functions "upper_32_bits" and "lower_32_bits" to 
<include/linux/kernel.h> to allow 64-bit integers to be separated into 
their 32-bit upper and lower halves without promoting integers, without 
stretching sign bits, and without generating compiler warnings when used 
with any integer not greater than 64 bits wide. High-order bits are 
assumed to be zero for integers with fewer than 64 of them. Result values 
are always 32-bit unsigned.

Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

---

> > +#define upper_32_bits(n) (sizeof(n) == 8 ? (u64)(n) >> 32 : 0)
> 
> It's very unclear what type this returns, in terms of both size and
> signedness.  Perhaps it always returns a u64, dunno.  If it does, that will
> cause the arithmetic which uses this macro to go 64-bit too.  Casting the
> whole return value to u32 would fix all those doubts up.

If the argument is 64-bit, the return value is 64-bit; otherwise, the 
return value is the same as the size of the argument. This prevents 
integer promotion. I was trying to also not promote,, say, a short int, if 
for some stupid reason somebody was using one. But you're right, a cast is 
clearer, and the functions are clearly intended for 32-bit arithmetic.

> > +#define lower_32_bits(n) (sizeof(n) == 8 ? (u32)(n) : (n))
> 
> n&0xffffffff would be simpler.

I suppose. I'm trying to be careful and account for stupid edge cases, but 
then again, such code is horribly broken so we can instead ignore them? We 
shall assume the mask gets promoted as necessary.

> Do we actually have any call for this?

It enhances readability and prevents compiler warnings without increasing 
code-local complexity. Besides, if we have upper_32_bits, we should have 
lower_32_bits. Two similarly-named function calls is better than a 
function call and a mask.

And it's really nice to be able to write code that is word-size 
independent and also not cluttered. And if any code declares macros like 
this now, they can be eliminated and make a little more utility code 
central.

--- linux-2.6.21-rc7-git4.orig/include/linux/kernel.h	2007-04-20 20:22:13.000000000 -0400
+++ linux-2.6.21-rc7-git4.mod/include/linux/kernel.h	2007-04-21 08:59:01.000000000 -0400
@@ -40,6 +40,24 @@ extern const char linux_proc_banner[];
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
 
+/**
+ * lower_32_bits, upper_32_bits - separate the halves of a 64-bit integer
+ * @n: the integer to separate
+ *
+ * Separate a 64-bit integer into its upper and lower 32-bit halves.
+ * Designed to avoid integer promotions and compiler warnings when used
+ * with smaller integers, in which case the missing bits are assumed to
+ * be zero. Designed to treat integers as unsigned whether or not they
+ * really are. (If you are using these with signed integers, your code
+ * is almost certainly wrong. The cast is good for people too lazy to
+ * type "unsigned" in their code, since breaking things is bad.)
+ *
+ * These assume the integer used is NOT greater than 64 bits wide.
+ * Return values are always 32-bit unsigned integers.
+ */
+#define upper_32_bits(n) ((u32)(sizeof(n) == 8 ? (u64)(n) >> 32 : 0))
+#define lower_32_bits(n) ((u32)(n & ~(u32)0))
+
 #define	KERN_EMERG	"<0>"	/* system is unusable			*/
 #define	KERN_ALERT	"<1>"	/* action must be taken immediately	*/
 #define	KERN_CRIT	"<2>"	/* critical conditions			*/
