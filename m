From: Sergey Kononenko <sergk@sergk.org.ua>
Subject: [PATCH 2/2] aic94xx: Supermicro motherboards support (remove
 FLASHEX check)
Date: Sun, 15 Oct 2006 02:37:28 +0300
Message-ID: <20061015023728.6209e5be@manowar.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.hqhost.net ([80.77.80.130]:32403 "EHLO mail2.hqhost.net")
	by vger.kernel.org with ESMTP id S1752239AbWJNXhc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Oct 2006 19:37:32 -0400
Received: from manowar.localnet (ukrtel-nat.ua-online.net [213.179.225.5])
	(authenticated bits=0)
	by mail2.hqhost.net (8.13.8/8.13.8/Debian-2) with ESMTP id k9ENbkq2004209
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sat, 14 Oct 2006 23:37:49 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove FLASHEX check.

Signed-off-by: Sergey Kononenko <sergk@sergk.org.ua>

diff -urN linux-2.6.19-rc2/drivers/scsi/aic94xx/aic94xx_sds.c \
        linux-2.6.19-rc2.patched/drivers/scsi/aic94xx/aic94xx_sds.c
--- linux-2.6.19-rc2/drivers/scsi/aic94xx/aic94xx_sds.c 2006-10-14 \
        21:11:59.000000000 +0000
+++ linux-2.6.19-rc2.patched/drivers/scsi/aic94xx/aic94xx_sds.c \
        2006-10-14 02:16:08.000000000 +0000
@@ -630,10 +630,6 @@
 
        reg = asd_read_reg_dword(asd_ha, EXSICNFGR);
 
-       if (!(reg & FLASHEX)) {
-               ASD_DPRINTK("flash doesn't exist\n");
-               return -ENOENT;
-       }
        if (pci_read_config_dword(asd_ha->pcidev, PCI_CONF_FLSH_BAR,
                                  &asd_ha->hw_prof.flash.bar)) {
                asd_printk("couldn't read PCI_CONF_FLSH_BAR of %s\n",

--
Sergey Kononenko
