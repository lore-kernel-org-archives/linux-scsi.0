From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH] aic94xx: disable split completion timer/setting by default
Date: Fri, 30 Jun 2006 14:17:10 -0700
Message-ID: <1151702230.16075.61.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:6122 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S932399AbWF3VSR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jun 2006 17:18:17 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k5ULIGH1023359
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jun 2006 17:18:16 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k5ULIYk4094350
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jun 2006 15:18:34 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k5ULIFsi026789
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jun 2006 15:18:15 -0600
Received: from alexis.beaverton.ibm.com (alexis.beaverton.ibm.com [9.47.17.62])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k5ULIFEC026764
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jun 2006 15:18:15 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The aic94xx driver will lock up under heavy load with a split completion
error.  There is a split completion timer/setting which should be
disabled by default but is not.  This patch fixes this problem.

Signed-off-by: Adaptec
Acked-by: Alexis Bruemmer <alexisb@us.ibm.com>

----------

Index: aic94xx-sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_hwi.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/aic94xx/aic94xx_hwi.c	2006-06-23 11:12:01.000000000 -0700
+++ aic94xx-sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_hwi.c	2006-06-29 12:10:08.000000000 -0700
@@ -604,11 +604,26 @@
 int asd_init_hw(struct asd_ha_struct *asd_ha)
 {
 	int err;
+	u32 v;
 
 	err = asd_init_sw(asd_ha);
 	if (err)
 		return err;
 
+	err = pci_read_config_dword(asd_ha->pcidev, PCIC_HSTPCIX_CNTRL, &v);
+	if (err) {
+		asd_printk("couldn't read PCIC_HSTPCIX_CNTRL of %s\n",
+			   pci_name(asd_ha->pcidev));
+		return err;
+	}
+	pci_write_config_dword(asd_ha->pcidev, PCIC_HSTPCIX_CNTRL,
+					v | SC_TMR_DIS);
+	if (err) {
+		asd_printk("couldn't disable split completion timer of %s\n",
+			   pci_name(asd_ha->pcidev));
+		return err;
+	}
+
 	err = asd_read_ocm(asd_ha);
 	if (err) {
 		asd_printk("couldn't read ocm(%d)\n", err);
Index: aic94xx-sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_reg_def.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/aic94xx/aic94xx_reg_def.h	2006-06-23 11:12:01.000000000 -0700
+++ aic94xx-sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_reg_def.h	2006-06-29 11:57:49.000000000 -0700
@@ -1787,6 +1787,7 @@
 #define PCIC_HSTPCIX_CNTRL	0xA0
 
 #define 	REWIND_DIS		0x0800
+#define		SC_TMR_DIS		0x04000000
 
 #define PCIC_MBAR0_MASK	0xA8
 #define		PCIC_MBAR0_SIZE_MASK 	0x1FFFE000


