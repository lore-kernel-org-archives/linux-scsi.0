From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Subject: [PATCH] utilities: add helper functions for safe 64-bit integer
 operations as 32-bit halves
Date: Fri, 20 Apr 2007 20:55:49 -0400 (EDT)
Message-ID: <alpine.DEB.0.98.0704202040150.16687@sigma.j-a-k-j.com>
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
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hammerhead.shentel.net ([204.111.1.228]:58446 "EHLO
	hammerhead.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbXDUA5O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Apr 2007 20:57:14 -0400
In-Reply-To: <alpine.DEB.0.98.0704201732240.11655@sigma.j-a-k-j.com>
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
assumed to be zero for integers with fewer than 64 of them.

Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

---

Using these functions with signed quantities is an error, especially if 
you read a 32-bit quantity from disk that happens to have the high bit set 
into an int on a 32-bit machine, then use it with a function taking a u64 
which screws your data. When switching to using these functions, it's a 
good opportunity to check for these signedness errors. (Haven't we learned 
anything over the past decades of computing about assuming that one little 
bit doesn't matter?)

Not sure exactly whom the maintainer is for this, so I added 
trivial@kernel.org. It's certainly not limited to one subsystem anymore, 
and converting the whole kernel to this could be a good step for 
readability and correctness across architectures of any word size.

--- linux-2.6.21-rc7-git4.orig/include/linux/kernel.h	2007-04-20 20:22:13.000000000 -0400
+++ linux-2.6.21-rc7-git4.mod/include/linux/kernel.h	2007-04-20 20:37:41.000000000 -0400
@@ -40,6 +40,23 @@ extern const char linux_proc_banner[];
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
+ */
+#define upper_32_bits(n) (sizeof(n) == 8 ? (u64)(n) >> 32 : 0)
+#define lower_32_bits(n) (sizeof(n) == 8 ? (u32)(n) : (n))
+
 #define	KERN_EMERG	"<0>"	/* system is unusable			*/
 #define	KERN_ALERT	"<1>"	/* action must be taken immediately	*/
 #define	KERN_CRIT	"<2>"	/* critical conditions			*/
