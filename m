From: malahal@us.ibm.com
Subject: [PATCH] AIC94XX: nmi timeout fix
Date: Tue, 31 Oct 2006 17:07:09 -0800
Message-ID: <20061101010709.GA3386@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:4542 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1423903AbWKABHN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Oct 2006 20:07:13 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kA117BB5020868
	for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2006 20:07:11 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kA117Bpu462276
	for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2006 18:07:11 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kA117BKw031685
	for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2006 18:07:11 -0700
Received: from malahal.beaverton.ibm.com (malahal.beaverton.ibm.com [9.47.17.93])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id kA117Bd6031645
	for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2006 18:07:11 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Few of us have seen the AIC94XX driver get stuck reading the
ATOMICSTATCTL register in a loop for ever. The possible immortal loop
in asd_ddbsite_update_word() is made mortal now! Retry worked just
fine!

Signed-off-by: Malahal Naineni <malahal@us.ibm.com>

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
