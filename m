From: Paul Burton <paul.burton@imgtec.com>
Subject: [PATCH 2/2] scsi: sg: Use mult_frac, drop MULDIV macro
Date: Fri, 19 Aug 2016 17:43:57 +0100
Message-ID: <20160819164357.26121-2-paul.burton@imgtec.com>
References: <20160819164357.26121-1-paul.burton@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:18233 "EHLO
        mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755284AbcHSQov (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Aug 2016 12:44:51 -0400
In-Reply-To: <20160819164357.26121-1-paul.burton@imgtec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Doug Gilbert <dgilbert@interlog.com>
Cc: Paul Burton <paul.burton@imgtec.com>

The MULDIV macro is essentially a duplicate of the more standard
mult_frac macro. Replace use of MULDIV with mult_frac & drop the
duplication.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
---
 drivers/scsi/sg.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index bb5ec2d..070332e 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -79,18 +79,7 @@ static void sg_proc_cleanup(void);
  */
 #define SG_MAX_CDB_SIZE 252
 
-/*
- * Suppose you want to calculate the formula muldiv(x,m,d)=int(x * m / d)
- * Then when using 32 bit integers x * m may overflow during the calculation.
- * Replacing muldiv(x) by muldiv(x)=((x % d) * m) / d + int(x / d) * m
- * calculates the same, but prevents the overflow when both m and d
- * are "small" numbers (like HZ and USER_HZ).
- * Of course an overflow is inavoidable if the result of muldiv doesn't fit
- * in 32 bits.
- */
-#define MULDIV(X,MUL,DIV) ((((X % DIV) * MUL) / DIV) + ((X / DIV) * MUL))
-
-#define SG_DEFAULT_TIMEOUT MULDIV(SG_DEFAULT_TIMEOUT_USER, HZ, USER_HZ)
+#define SG_DEFAULT_TIMEOUT mult_frac(SG_DEFAULT_TIMEOUT_USER, HZ, USER_HZ)
 
 int sg_big_buff = SG_DEF_RESERVED_SIZE;
 /* N.B. This variable is readable and writeable via
@@ -884,11 +873,11 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 			return result;
 		if (val < 0)
 			return -EIO;
-		if (val >= MULDIV((s64)INT_MAX, USER_HZ, HZ))
-			val = min_t(s64, MULDIV((s64)INT_MAX, USER_HZ, HZ),
+		if (val >= mult_frac((s64)INT_MAX, USER_HZ, HZ))
+			val = min_t(s64, mult_frac((s64)INT_MAX, USER_HZ, HZ),
 				    INT_MAX);
 		sfp->timeout_user = val;
-		sfp->timeout = MULDIV (val, HZ, USER_HZ);
+		sfp->timeout = mult_frac(val, HZ, USER_HZ);
 
 		return 0;
 	case SG_GET_TIMEOUT:	/* N.B. User receives timeout as return value */
-- 
2.9.3

