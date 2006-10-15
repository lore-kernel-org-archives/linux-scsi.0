From: Sergey Kononenko <sergk@sergk.org.ua>
Subject: [PATCH] aic94xx: Supermicro motherboards support (fixed patches)
Date: Sun, 15 Oct 2006 03:12:08 +0300
Message-ID: <20061015031208.6671cb31@manowar.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.hqhost.net ([80.77.80.130]:36021 "EHLO mail2.hqhost.net")
	by vger.kernel.org with ESMTP id S1752303AbWJOAMM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Oct 2006 20:12:12 -0400
Received: from manowar.localnet (ukrtel-nat.ua-online.net [213.179.225.5])
	(authenticated bits=0)
	by mail2.hqhost.net (8.13.8/8.13.8/Debian-2) with ESMTP id k9F0CQQZ021061
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 15 Oct 2006 00:12:30 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Sorry, patches in previous messages was with broken tabs,
this ones would be correct:

Add PCI id.

Signed-off-by: Sergey Kononenko <sergk@sergk.org.ua>

diff -urN linux-2.6.19-rc2/drivers/scsi/aic94xx/aic94xx_hwi.h \
	linux-2.6.19-rc2.patched/drivers/scsi/aic94xx/aic94xx_hwi.h
--- linux-2.6.19-rc2/drivers/scsi/aic94xx/aic94xx_hwi.h	2006-10-14 \
	21:11:59.000000000 +0000
+++ linux-2.6.19-rc2.patched/drivers/scsi/aic94xx/aic94xx_hwi.h	\
	2006-10-14 02:15:16.000000000 +0000
@@ -46,6 +46,7 @@
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR10 0x410
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR12 0x412
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR1E 0x41E
+#define PCI_DEVICE_ID_ADAPTEC2_RAZOR1F 0x41F
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR30 0x430
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR32 0x432
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR3E 0x43E
diff -urN linux-2.6.19-rc2/drivers/scsi/aic94xx/aic94xx_init.c \
	linux-2.6.19-rc2.patched/drivers/scsi/aic94xx/aic94xx_init.c
--- linux-2.6.19-rc2/drivers/scsi/aic94xx/aic94xx_init.c 2006-10-14 \
	21:11:59.000000000 +0000
+++ linux-2.6.19-rc2.patched/drivers/scsi/aic94xx/aic94xx_init.c 2006-10-14 \
	02:15:16.000000000 +0000
@@ -814,6 +814,8 @@
 	 0, 0, 1},
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR1E),
 	 0, 0, 1},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR1F),
+	 0, 0, 1},
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR30),
 	 0, 0, 2},
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR32),

--
Remove FLASHEX check.

Signed-off-by: Sergey Kononenko <sergk@sergk.org.ua>

diff -urN linux-2.6.19-rc2/drivers/scsi/aic94xx/aic94xx_sds.c \
	linux-2.6.19-rc2.patched/drivers/scsi/aic94xx/aic94xx_sds.c
--- linux-2.6.19-rc2/drivers/scsi/aic94xx/aic94xx_sds.c	2006-10-14 \
	21:11:59.000000000 +0000
+++ linux-2.6.19-rc2.patched/drivers/scsi/aic94xx/aic94xx_sds.c	\
	2006-10-14 02:16:08.000000000 +0000
@@ -630,10 +630,6 @@
 
 	reg = asd_read_reg_dword(asd_ha, EXSICNFGR);
 
-	if (!(reg & FLASHEX)) {
-		ASD_DPRINTK("flash doesn't exist\n");
-		return -ENOENT;
-	}
 	if (pci_read_config_dword(asd_ha->pcidev, PCI_CONF_FLSH_BAR,
 				  &asd_ha->hw_prof.flash.bar)) {
 		asd_printk("couldn't read PCI_CONF_FLSH_BAR of %s\n",

--
Sergey Kononenko
