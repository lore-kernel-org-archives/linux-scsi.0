From: Paul Burton <paul.burton@imgtec.com>
Subject: [PATCH 1/2] scsi: sg: Avoid overflow when USER_HZ > HZ
Date: Fri, 19 Aug 2016 17:43:56 +0100
Message-ID: <20160819164357.26121-1-paul.burton@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:11807 "EHLO
        mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753745AbcHSQoh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Aug 2016 12:44:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Doug Gilbert <dgilbert@interlog.com>
Cc: Paul Burton <paul.burton@imgtec.com>

Calculating the maximum timeout that a user can set via the
SG_SET_TIMEOUT ioctl involves multiplying INT_MAX by USER_HZ/HZ. If
USER_HZ is larger than HZ then this results in an overflow when
performed as a 32 bit integer calculation, resulting in compiler
warnings such as the following:

  drivers/scsi/sg.c: In function 'sg_ioctl':
  drivers/scsi/sg.c:91:67: warning: integer overflow in expression [-Woverflow]
   #define MULDIV(X,MUL,DIV) ((((X % DIV) * MUL) / DIV) + ((X / DIV) * MUL))
                                                                     ^
  drivers/scsi/sg.c:887:14: note: in expansion of macro 'MULDIV'
     if (val >= MULDIV (INT_MAX, USER_HZ, HZ))
                ^
  drivers/scsi/sg.c:91:67: warning: integer overflow in expression [-Woverflow]
   #define MULDIV(X,MUL,DIV) ((((X % DIV) * MUL) / DIV) + ((X / DIV) * MUL))
                                                                     ^
  drivers/scsi/sg.c:888:13: note: in expansion of macro 'MULDIV'
         val = MULDIV (INT_MAX, USER_HZ, HZ);
               ^

Avoid this overflow by performing the (constant) arithmetic on 64 bit
integers, which ensures that overflow from multiplying the 32 bit values
cannot occur. When converting the result back to a 32 bit integer use
min_t to ensure that we don't simply truncate a value beyond INT_MAX to
a 32 bit integer, but instead use INT_MAX where the result was larger
than it. As the values are all compile time constant the 64 bit
arithmetic should have no runtime cost.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
---
 drivers/scsi/sg.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ae7d9bd..bb5ec2d 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -884,8 +884,9 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 			return result;
 		if (val < 0)
 			return -EIO;
-		if (val >= MULDIV (INT_MAX, USER_HZ, HZ))
-		    val = MULDIV (INT_MAX, USER_HZ, HZ);
+		if (val >= MULDIV((s64)INT_MAX, USER_HZ, HZ))
+			val = min_t(s64, MULDIV((s64)INT_MAX, USER_HZ, HZ),
+				    INT_MAX);
 		sfp->timeout_user = val;
 		sfp->timeout = MULDIV (val, HZ, USER_HZ);
 
-- 
2.9.3

