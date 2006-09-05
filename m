From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH] aic94xx: Widens the Range of Recognized FLASH Manufactures
Date: Tue, 05 Sep 2006 09:20:28 -0700
Message-ID: <1157473228.7906.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:21696 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S965175AbWIEQUb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Sep 2006 12:20:31 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k85GKUtK006964
	for <linux-scsi@vger.kernel.org>; Tue, 5 Sep 2006 12:20:30 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k85GKUcR226754
	for <linux-scsi@vger.kernel.org>; Tue, 5 Sep 2006 10:20:30 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k85GKTON011711
	for <linux-scsi@vger.kernel.org>; Tue, 5 Sep 2006 10:20:29 -0600
Received: from alexis.beaverton.ibm.com (alexis.beaverton.ibm.com [9.47.17.62])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k85GKTOv011673
	for <linux-scsi@vger.kernel.org>; Tue, 5 Sep 2006 10:20:29 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The 94xx controller is now being shipped with a wider range of FLASH
chip manufactures, this patch simply allows the aic94xx driver to
recognize the new manufacturers ids.


--Alexis



Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>

----

diff -aNurp linux-2.6.18-rc5-aic94xx-orig/drivers/scsi/aic94xx/aic94xx_sds.c linux-2.6.18-rc5-aic94xx-new/drivers/scsi/aic94xx/aic94xx_sds.c
--- linux-2.6.18-rc5-aic94xx-orig/drivers/scsi/aic94xx/aic94xx_sds.c	2006-08-28 14:29:30.000000000 -0700
+++ linux-2.6.18-rc5-aic94xx-new/drivers/scsi/aic94xx/aic94xx_sds.c	2006-09-05 09:11:34.000000000 -0700
@@ -376,7 +376,10 @@ out:
 /* ---------- FLASH stuff ---------- */
 
 #define FLASH_RESET			0xF0
-#define FLASH_MANUF_AMD                 1
+#define FLASH_MANUF_AMD			0x01
+#define FLASH_MANUF_ST			0x20
+#define FLASH_MANUF_FUJITSU		0x04
+#define FLASH_MANUF_MACRONIX		0xC2
 
 #define FLASH_SIZE                      0x200000
 #define FLASH_DIR_COOKIE                "*** ADAPTEC FLASH DIRECTORY *** "
@@ -663,7 +666,11 @@ static int asd_flash_getid(struct asd_ha
 	/* Get out of autoselect mode. */
 	err = asd_reset_flash(asd_ha);
 
-	if (asd_ha->hw_prof.flash.manuf == FLASH_MANUF_AMD) {
+	switch(asd_ha->hw_prof.flash.manuf) {
+	case FLASH_MANUF_AMD:
+	case FLASH_MANUF_ST:
+	case FLASH_MANUF_FUJITSU:
+	case FLASH_MANUF_MACRONIX:
 		ASD_DPRINTK("0Found FLASH(%d) manuf:%d, dev_id:0x%x, "
 			    "sec_prot:%d\n",
 			    asd_ha->hw_prof.flash.wide ? 16 : 8,
@@ -671,6 +678,9 @@ static int asd_flash_getid(struct asd_ha
 			    asd_ha->hw_prof.flash.dev_id,
 			    asd_ha->hw_prof.flash.sec_prot);
 		return 0;
+	default:
+		break;
+
 	}
 
 	/* Ok, try the sequence for byte mode of 160B and 800D.
@@ -684,7 +694,11 @@ static int asd_flash_getid(struct asd_ha
 	asd_ha->hw_prof.flash.sec_prot = asd_read_reg_byte(asd_ha, reg + 4);
 	err = asd_reset_flash(asd_ha);
 
-	if (asd_ha->hw_prof.flash.manuf == FLASH_MANUF_AMD) {
+	switch(asd_ha->hw_prof.flash.manuf) {
+	case FLASH_MANUF_AMD:
+	case FLASH_MANUF_ST:
+	case FLASH_MANUF_FUJITSU:
+	case FLASH_MANUF_MACRONIX:
 		ASD_DPRINTK("1Found FLASH(%d) manuf:%d, dev_id:0x%x, "
 			    "sec_prot:%d\n",
 			    asd_ha->hw_prof.flash.wide ? 16 : 8,
@@ -692,8 +706,12 @@ static int asd_flash_getid(struct asd_ha
 			    asd_ha->hw_prof.flash.dev_id,
 			    asd_ha->hw_prof.flash.sec_prot);
 		return 0;
+	default:
+		break;
+
 	}
 
+
 	return -ENOENT;
 }
 


