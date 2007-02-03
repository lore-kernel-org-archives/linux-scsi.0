From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 12/12] sas_ata: Make this a module separate from libsas
Date: Sat, 03 Feb 2007 10:03:12 -0600
Message-ID: <1170518592.3345.38.camel@mulgrave.il.steeleye.com>
References: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
	 <20070130091903.31530.90178.stgit@elm3a70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:41541 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946478AbXBCQDQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Feb 2007 11:03:16 -0500
In-Reply-To: <20070130091903.31530.90178.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, alexisb@us.ibm.com

On Tue, 2007-01-30 at 01:19 -0800, Darrick J. Wong wrote:
> Break out sas_ata as a free-standing module that provides a SATA
> Translation Layer (SATL) for libsas.  This patch requires the libsas
> SATL registration patch; the changes to sas_ata itself are rather
> minor.

Right at the moment, this doesn't work.  The dependency of ATA_AVAILABLE
on SCSI_SAS_SATL forces libsas to require sas_ata if you select it as a
module (i.e. they're not truly independent).

How about this solution to untangle them?

James

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 009fd2b..73a737f 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -46,7 +46,16 @@
 
 
 static DEFINE_SPINLOCK(satl_ops_lock);
-static struct satl_operations *satl_ops;
+static struct satl_operations *satl_ops = NULL;
+
+
+static inline int dev_is_sata(struct domain_device *dev)
+{
+	return (satl_ops
+		&& (dev->rphy->identify.target_port_protocols
+		    & SAS_PROTOCOL_SATA));
+}
+
 
 static void sas_scsi_task_done(struct sas_task *task)
 {
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index f1d90f7..06a9be5 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -49,25 +49,4 @@ struct satl_operations {
 int sas_register_satl(struct satl_operations *satl_ops);
 int sas_unregister_satl(struct satl_operations *satl_ops);
 
-#ifdef CONFIG_SCSI_SAS_SATL_MODULE
-# define SAS_ATA_AVAILABLE
-#endif
-
-#ifdef CONFIG_SCSI_SAS_SATL
-# define SAS_ATA_AVAILABLE
-#endif
-
-#ifdef SAS_ATA_AVAILABLE
-
-static inline int dev_is_sata(struct domain_device *dev)
-{
-	return (dev->rphy->identify.target_port_protocols & SAS_PROTOCOL_SATA);
-}
-
-#else
-
-#define dev_is_sata(x) (0)
-
-#endif /* SAS_ATA_AVAILABLE */
-
 #endif /* _SAS_ATA_H_ */


