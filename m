From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH 4/4] aic94xx: nmi timeout fix
Date: Thu, 09 Nov 2006 12:04:20 -0800
Message-ID: <1163102660.6521.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:30087 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S965546AbWKIUF6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2006 15:05:58 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kA9K5qwW027704
	for <linux-scsi@vger.kernel.org>; Thu, 9 Nov 2006 15:05:52 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kA9K5NJr067696
	for <linux-scsi@vger.kernel.org>; Thu, 9 Nov 2006 15:05:27 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kA9K4Mt4027818
	for <linux-scsi@vger.kernel.org>; Thu, 9 Nov 2006 15:04:23 -0500
Received: from [9.48.54.0] ([9.48.54.0])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id kA9K4L5m027638
	for <linux-scsi@vger.kernel.org>; Thu, 9 Nov 2006 15:04:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Few of us have seen the AIC94XX driver get stuck reading the
ATOMICSTATCTL register in a loop for ever. The possible immortal loop
in asd_ddbsite_update_word() is made mortal now! Retry worked just
fine!

Signed-off-by: Malahal Naineni <malahal@us.ibm.com>

---

diff -r 5f7a0e8a8265 drivers/scsi/aic94xx/aic94xx_reg.h
--- a/drivers/scsi/aic94xx/aic94xx_reg.h	Wed Oct 25 13:28:35 2006 -0700
+++ b/drivers/scsi/aic94xx/aic94xx_reg.h	Fri Oct 27 10:22:59 2006 -0700
@@ -226,20 +226,30 @@ static inline int asd_ddbsite_update_wor
 					  u16 oldval, u16 newval)
 {
 	u8  done;
+	int retries = 100;
+	int i;
+
 	u16 oval = asd_ddbsite_read_word(asd_ha, ddb_site_no, offs);
 	if (oval != oldval)
 		return -EAGAIN;
 	asd_write_reg_word(asd_ha, AOLDDATA, oldval);
 	asd_write_reg_word(asd_ha, ANEWDATA, newval);
-	do {
+	for (i = 0; i < retries; i++) {
 		done = asd_read_reg_byte(asd_ha, ATOMICSTATCTL);
-	} while (!(done & ATOMICDONE));
-	if (done & ATOMICERR)
-		return -EFAULT;	  /* parity error */
-	else if (done & ATOMICWIN)
-		return 0;	  /* success */
-	else
-		return -EAGAIN;	  /* oldval different than current value */
+		if (done & ATOMICDONE) {
+			if (done & ATOMICERR)
+				return -EFAULT;	  /* parity error */
+			else if (done & ATOMICWIN)
+				return 0;	  /* success */
+			else
+				/* oldval different than current value */
+				return -EAGAIN;
+		}
+	}
+
+	/* ATOMICDONE is not set after repeated retries! Broken chip? */
+	WARN_ON(1);
+	return -EAGAIN;
 }
 
 static inline int asd_ddbsite_update_byte(struct asd_ha_struct *asd_ha,

