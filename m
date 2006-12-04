From: akpm@osdl.org
Subject: [patch 1/2] git-sas Kconfig fix
Date: Mon, 04 Dec 2006 15:21:02 -0800
Message-ID: <200612042322.kB4NMBWM009028@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57256 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758404AbWLDXWU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Dec 2006 18:22:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, djwong@us.ibm.com

From: "Darrick J. Wong" <djwong@us.ibm.com>

Andrew Morton wrote:

> WARNING: "ata_sas_slave_configure" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_port_disable" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_sas_port_init" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_sas_port_stop" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_sas_port_start" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_sas_port_alloc" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_noop_qc_prep" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_tf_to_fis" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_noop_dev_select" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_tf_from_fis" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_host_init" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_sas_queuecmd" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_sas_port_destroy" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_scsi_ioctl" [drivers/scsi/libsas/libsas.ko] undefined!
> WARNING: "ata_qc_complete" [drivers/scsi/libsas/libsas.ko] undefined!

The SATA-fortified libsas depends on libata for SATA support.  Kconfig
needs to know about that.  Patch is for aic94xx-sas-2.6 and apparently -mm
as well.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/libsas/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/libsas/Kconfig~git-sas-kconfig-fix drivers/scsi/libsas/Kconfig
--- a/drivers/scsi/libsas/Kconfig~git-sas-kconfig-fix
+++ a/drivers/scsi/libsas/Kconfig
@@ -24,7 +24,7 @@
 
 config SCSI_SAS_LIBSAS
 	tristate "SAS Domain Transport Attributes"
-	depends on SCSI
+	depends on SCSI && ATA
 	select SCSI_SAS_ATTRS
 	help
 	  This provides transport specific helpers for SAS drivers which
_
