From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH] aic94xx: Removes Reliance on FLASH Manufacture IDs
Date: Thu, 07 Sep 2006 14:32:16 -0700
Message-ID: <1157664736.7906.52.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:8398 "EHLO e34.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751880AbWIGVcX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Sep 2006 17:32:23 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e34.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k87LWMdF013227
	for <linux-scsi@vger.kernel.org>; Thu, 7 Sep 2006 17:32:22 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k87LWMgK367030
	for <linux-scsi@vger.kernel.org>; Thu, 7 Sep 2006 15:32:22 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k87LWM73015572
	for <linux-scsi@vger.kernel.org>; Thu, 7 Sep 2006 15:32:22 -0600
Received: from alexis.beaverton.ibm.com (alexis.beaverton.ibm.com [9.47.17.62])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k87LWMPh015545
	for <linux-scsi@vger.kernel.org>; Thu, 7 Sep 2006 15:32:22 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch removes the reliance on FLASH Manufacture IDs for validation.

--Alexis


Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>


---

diff -aNurp linux-2.6.18-rc5-aic94xx-orig/drivers/scsi/aic94xx/aic94xx_sds.c linux-2.6.18-rc5-aic94xx-new/drivers/scsi/aic94xx/aic94xx_sds.c
--- linux-2.6.18-rc5-aic94xx-orig/drivers/scsi/aic94xx/aic94xx_sds.c	2006-08-28 14:29:30.000000000 -0700
+++ linux-2.6.18-rc5-aic94xx-new/drivers/scsi/aic94xx/aic94xx_sds.c	2006-09-07 14:30:16.000000000 -0700
@@ -376,7 +376,6 @@ out:
 /* ---------- FLASH stuff ---------- */
 
 #define FLASH_RESET			0xF0
-#define FLASH_MANUF_AMD                 1
 
 #define FLASH_SIZE                      0x200000
 #define FLASH_DIR_COOKIE                "*** ADAPTEC FLASH DIRECTORY *** "
@@ -627,7 +626,7 @@ static int asd_find_flash_dir(struct asd
 static int asd_flash_getid(struct asd_ha_struct *asd_ha)
 {
 	int err = 0;
-	u32 reg, inc;
+	u32 reg;
 
 	reg = asd_read_reg_dword(asd_ha, EXSICNFGR);
 
@@ -648,53 +647,7 @@ static int asd_flash_getid(struct asd_ha
 		ASD_DPRINTK("couldn't reset flash(%d)\n", err);
 		return err;
 	}
-	/* Get flash info. This would most likely be AMD Am29LV family flash.
-	 * First try the sequence for word mode.  It is the same as for
-	 * 008B (byte mode only), 160B (word mode) and 800D (word mode).
-	 */
-	reg = asd_ha->hw_prof.flash.bar;
-	inc = asd_ha->hw_prof.flash.wide ? 2 : 1;
-	asd_write_reg_byte(asd_ha, reg + 0x555, 0xAA);
-	asd_write_reg_byte(asd_ha, reg + 0x2AA, 0x55);
-	asd_write_reg_byte(asd_ha, reg + 0x555, 0x90);
-	asd_ha->hw_prof.flash.manuf = asd_read_reg_byte(asd_ha, reg);
-	asd_ha->hw_prof.flash.dev_id= asd_read_reg_byte(asd_ha,reg+inc);
-	asd_ha->hw_prof.flash.sec_prot = asd_read_reg_byte(asd_ha,reg+inc+inc);
-	/* Get out of autoselect mode. */
-	err = asd_reset_flash(asd_ha);
-
-	if (asd_ha->hw_prof.flash.manuf == FLASH_MANUF_AMD) {
-		ASD_DPRINTK("0Found FLASH(%d) manuf:%d, dev_id:0x%x, "
-			    "sec_prot:%d\n",
-			    asd_ha->hw_prof.flash.wide ? 16 : 8,
-			    asd_ha->hw_prof.flash.manuf,
-			    asd_ha->hw_prof.flash.dev_id,
-			    asd_ha->hw_prof.flash.sec_prot);
-		return 0;
-	}
-
-	/* Ok, try the sequence for byte mode of 160B and 800D.
-	 * We may actually never need this.
-	 */
-	asd_write_reg_byte(asd_ha, reg + 0xAAA, 0xAA);
-	asd_write_reg_byte(asd_ha, reg + 0x555, 0x55);
-	asd_write_reg_byte(asd_ha, reg + 0xAAA, 0x90);
-	asd_ha->hw_prof.flash.manuf = asd_read_reg_byte(asd_ha, reg);
-	asd_ha->hw_prof.flash.dev_id = asd_read_reg_byte(asd_ha, reg + 2);
-	asd_ha->hw_prof.flash.sec_prot = asd_read_reg_byte(asd_ha, reg + 4);
-	err = asd_reset_flash(asd_ha);
-
-	if (asd_ha->hw_prof.flash.manuf == FLASH_MANUF_AMD) {
-		ASD_DPRINTK("1Found FLASH(%d) manuf:%d, dev_id:0x%x, "
-			    "sec_prot:%d\n",
-			    asd_ha->hw_prof.flash.wide ? 16 : 8,
-			    asd_ha->hw_prof.flash.manuf,
-			    asd_ha->hw_prof.flash.dev_id,
-			    asd_ha->hw_prof.flash.sec_prot);
-		return 0;
-	}
-
-	return -ENOENT;
+	return 0;
 }
 
 static u16 asd_calc_flash_chksum(u16 *p, int size)


