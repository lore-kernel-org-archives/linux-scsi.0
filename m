From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] SCSI_AIC94XX must depend on SCSI
Date: Thu, 6 Mar 2008 22:22:46 +0200
Message-ID: <20080306202246.GB5259@cs181133002.pp.htv.fi>
References: <200803062009.20309.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:45092 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573AbYCFUWz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Mar 2008 15:22:55 -0500
Content-Disposition: inline
In-Reply-To: <200803062009.20309.toralf.foerster@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch fixes the following build error reported by Toralf F=C3=B6rs=
ter:

<--  snip  -->

=2E..
  MODPOST 243 modules
ERROR: "sas_bios_param" [drivers/scsi/mvsas.ko] undefined!
ERROR: "sas_change_queue_type" [drivers/scsi/mvsas.ko] undefined!
ERROR: "sas_change_queue_depth" [drivers/scsi/mvsas.ko] undefined!
ERROR: "sas_target_destroy" [drivers/scsi/mvsas.ko] undefined!
ERROR: "sas_target_alloc" [drivers/scsi/mvsas.ko] undefined!
ERROR: "sas_slave_destroy" [drivers/scsi/mvsas.ko] undefined!
ERROR: "sas_slave_configure" [drivers/scsi/mvsas.ko] undefined!
ERROR: "sas_eh_bus_reset_handler" [drivers/scsi/mvsas.ko] undefined!
ERROR: "sas_eh_device_reset_handler" [drivers/scsi/mvsas.ko] undefined!
ERROR: "sas_queuecommand" [drivers/scsi/mvsas.ko] undefined!
ERROR: "sas_ioctl" [drivers/scsi/mvsas.ko] undefined!
ERROR: "sas_register_ha" [drivers/scsi/mvsas.ko] undefined!
ERROR: "sas_domain_attach_transport" [drivers/scsi/mvsas.ko] undefined!
ERROR: "sas_ssp_task_response" [drivers/scsi/mvsas.ko] undefined!
ERROR: "sas_slave_alloc" [drivers/scsi/mvsas.ko] undefined!
ERROR: "sas_unregister_ha" [drivers/scsi/mvsas.ko] undefined!
make[1]: *** [__modpost] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- a/drivers/scsi/aic94xx/Kconfig
+++ b/drivers/scsi/aic94xx/Kconfig
@@ -26,7 +26,7 @@
=20
 config SCSI_AIC94XX
 	tristate "Adaptec AIC94xx SAS/SATA support"
-	depends on PCI
+	depends on SCSI && PCI
 	select SCSI_SAS_LIBSAS
 	select FW_LOADER
 	help

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
