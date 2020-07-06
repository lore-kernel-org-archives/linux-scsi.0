Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472D3C433E1
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 19:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10DA920675
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 19:39:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jSJpGFj6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgGFTjd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 15:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFTjb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 15:39:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7520EC061755
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2020 12:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=O259ohneVYLUXsebPck069zSzAgapbcAaKchfVpytFI=; b=jSJpGFj6AWT7Icvo9t27j20Mgs
        Q23BSCxOJt8wzUyEk/XMaLnWJLrmWdNi71uToWSjx032JfTFMDIXVu8zDBLskznRvDW7slv88+e4n
        qnfKJa0WYcmodO1mSNLnPDIsoX2WqBcKT59r3TFQHO4qq4OXLBXQjVj5vFFhq++cTvwHl3GzMZKl0
        3b/Fjkyvqb2fDe/WDsMK4hKXxDG2ygQWeUyrg0LvYZVBhuU1Y+WzypfWGOUUjZkbuZKjyGbrEZS95
        /7nHOvZe5i7K/EQ+cU2Ag4iQqjEwIrEEFebAaUP4sOvYYK+Kkhbym0G8VT4mGRqD2SP+kvHbWYtWX
        ySF1ZuLg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jsWxY-0001oK-D9; Mon, 06 Jul 2020 19:39:24 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 2/3] scsi: Rename slave_destroy to sdev_destroy
Date:   Mon,  6 Jul 2020 20:39:19 +0100
Message-Id: <20200706193920.6897-3-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200706193920.6897-1-willy@infradead.org>
References: <20200706193920.6897-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make the function match sdev_prep().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 Documentation/scsi/scsi_mid_low_api.rst       | 26 +++++++++----------
 drivers/ata/libata-scsi.c                     |  6 ++---
 drivers/message/fusion/mptfc.c                |  2 +-
 drivers/message/fusion/mptsas.c               |  2 +-
 drivers/message/fusion/mptscsih.c             |  6 ++---
 drivers/message/fusion/mptscsih.h             |  2 +-
 drivers/message/fusion/mptspi.c               |  6 ++---
 drivers/net/ethernet/mellanox/mlx4/main.c     | 12 ++++-----
 drivers/s390/scsi/zfcp_scsi.c                 |  4 +--
 drivers/scsi/53c700.c                         |  6 ++---
 drivers/scsi/bfa/bfad_im.c                    |  8 +++---
 drivers/scsi/csiostor/csio_scsi.c             |  6 ++---
 drivers/scsi/dc395x.c                         |  6 ++---
 drivers/scsi/esp_scsi.c                       |  4 +--
 drivers/scsi/hpsa.c                           |  6 ++---
 drivers/scsi/ipr.c                            |  8 +++---
 drivers/scsi/lpfc/lpfc_scsi.c                 |  6 ++---
 drivers/scsi/megaraid/megaraid_sas_base.c     |  4 +--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c          |  8 +++---
 drivers/scsi/myrb.c                           |  4 +--
 drivers/scsi/myrs.c                           |  4 +--
 drivers/scsi/pmcraid.c                        |  6 ++---
 drivers/scsi/qla2xxx/qla_os.c                 |  4 +--
 drivers/scsi/scsi_debug.c                     |  6 ++---
 drivers/scsi/scsi_sysfs.c                     |  4 +--
 drivers/scsi/sym53c8xx_2/sym_glue.c           |  4 +--
 drivers/scsi/ufs/ufshcd.c                     |  6 ++---
 drivers/scsi/xen-scsifront.c                  |  4 +--
 .../staging/unisys/visorhba/visorhba_main.c   |  6 ++---
 include/linux/libata.h                        |  4 +--
 include/scsi/scsi_host.h                      | 12 ++++-----
 net/dsa/dsa2.c                                |  2 +-
 net/dsa/dsa_priv.h                            |  2 +-
 net/dsa/slave.c                               |  2 +-
 34 files changed, 99 insertions(+), 99 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
index 246495f11da5..7798f09ad5d1 100644
--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -156,11 +156,11 @@ scsi devices of which only the first 2 respond::
 			slave_configure()
 			    |
 			sdev_prep()   ***
-			slave_destroy() ***
+			sdev_destroy() ***
 
 
     *** For scsi devices that the mid level tries to scan but do not
-	respond, a sdev_prep(), slave_destroy() pair is called.
+	respond, a sdev_prep(), sdev_destroy() pair is called.
 
 If the LLD wants to adjust the default queue settings, it can invoke
 scsi_change_queue_depth() in its slave_configure() routine.
@@ -176,8 +176,8 @@ same::
     ===----------------------=========-----------------===------
     scsi_remove_host() ---------+
 				|
-			slave_destroy()
-			slave_destroy()
+			sdev_destroy()
+			sdev_destroy()
     scsi_host_put()
 
 It may be useful for a LLD to keep track of struct Scsi_Host instances
@@ -218,12 +218,12 @@ upper layers with this sequence::
     ===----------------------=========-----------------===------
     scsi_remove_device() -------+
 				|
-			slave_destroy()
+			sdev_destroy()
 
 It may be useful for an LLD to keep track of struct scsi_device instances
 (a pointer is passed as the parameter to sdev_prep() and
 slave_configure() callbacks). Such instances are "owned" by the mid-level.
-struct scsi_device instances are freed after slave_destroy().
+struct scsi_device instances are freed after sdev_destroy().
 
 
 Reference Counting
@@ -381,7 +381,7 @@ Details::
     *
     *      Notes: Can be invoked any time on a SCSI device controlled by this
     *      LLD. [Specifically during and after slave_configure() and prior to
-    *      slave_destroy().] Can safely be invoked from interrupt code.
+    *      sdev_destroy().] Can safely be invoked from interrupt code.
     *
     *      Defined in: drivers/scsi/scsi.c [see source code for more notes]
     *
@@ -512,7 +512,7 @@ Details::
     *      Notes: If an LLD becomes aware that a scsi device (lu) has
     *      been removed but its host is still present then it can request
     *      the removal of that scsi device. If successful this call will
-    *      lead to the slave_destroy() callback being invoked. sdev is an
+    *      lead to the sdev_destroy() callback being invoked. sdev is an
     *      invalid pointer after this call.
     *
     *      Defined in: drivers/scsi/scsi_sysfs.c .
@@ -665,7 +665,7 @@ Summary:
   - queuecommand - queue scsi command, invoke 'done' on completion
   - sdev_prep - prior to any commands being sent to a new device
   - slave_configure - driver fine tuning for given device after attach
-  - slave_destroy - given device is about to be shut down
+  - sdev_destroy - given device is about to be shut down
 
 
 Details::
@@ -982,7 +982,7 @@ Details::
     *      exist but the mid level is just about to scan for it (i.e. send
     *      and INQUIRY command plus ...). If a device is found then
     *      slave_configure() will be called while if a device is not found
-    *      slave_destroy() is called.
+    *      sdev_destroy() is called.
     *      For more details see the include/scsi/scsi_host.h file.
     *
     *      Optionally defined in: LLD
@@ -998,7 +998,7 @@ Details::
     *
     *      Returns 0 if ok. Any other return is assumed to be an error and
     *      the device is taken offline. [offline devices will _not_ have
-    *      slave_destroy() called on them so clean up resources.]
+    *      sdev_destroy() called on them so clean up resources.]
     *
     *      Locks: none
     *
@@ -1014,7 +1014,7 @@ Details::
 
 
     /**
-    *      slave_destroy - given device is about to be shut down. All
+    *      sdev_destroy - given device is about to be shut down. All
     *                      activity has ceased on this device.
     *      @sdp: device that is about to be shut down
     *
@@ -1034,7 +1034,7 @@ Details::
     *
     *      Optionally defined in: LLD
     **/
-	void slave_destroy(struct scsi_device *sdp)
+	void sdev_destroy(struct scsi_device *sdp)
 
 
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 435781a16875..bf075f2e4bd8 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1114,7 +1114,7 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
 EXPORT_SYMBOL_GPL(ata_scsi_slave_config);
 
 /**
- *	ata_scsi_slave_destroy - SCSI device is about to be destroyed
+ *	ata_scsi_sdev_destroy - SCSI device is about to be destroyed
  *	@sdev: SCSI device to be destroyed
  *
  *	@sdev is about to be destroyed for hot/warm unplugging.  If
@@ -1127,7 +1127,7 @@ EXPORT_SYMBOL_GPL(ata_scsi_slave_config);
  *	LOCKING:
  *	Defined by SCSI layer.  We don't really care.
  */
-void ata_scsi_slave_destroy(struct scsi_device *sdev)
+void ata_scsi_sdev_destroy(struct scsi_device *sdev)
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	unsigned long flags;
@@ -1148,7 +1148,7 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
 
 	kfree(sdev->dma_drain_buf);
 }
-EXPORT_SYMBOL_GPL(ata_scsi_slave_destroy);
+EXPORT_SYMBOL_GPL(ata_scsi_sdev_destroy);
 
 /**
  *	ata_scsi_start_stop_xlat - Translate SCSI START STOP UNIT command
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 2717d65931ad..5c7556844a76 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -116,7 +116,7 @@ static struct scsi_host_template mptfc_driver_template = {
 	.sdev_prep			= mptfc_sdev_prep,
 	.slave_configure		= mptscsih_slave_configure,
 	.target_destroy			= mptfc_target_destroy,
-	.slave_destroy			= mptscsih_slave_destroy,
+	.sdev_destroy			= mptscsih_sdev_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_timed_out			= fc_eh_timed_out,
 	.eh_abort_handler		= mptfc_abort,
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index d6f27c90878d..c393e2ee8373 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1980,7 +1980,7 @@ static struct scsi_host_template mptsas_driver_template = {
 	.sdev_prep			= mptsas_sdev_prep,
 	.slave_configure		= mptsas_slave_configure,
 	.target_destroy			= mptsas_target_destroy,
-	.slave_destroy			= mptscsih_slave_destroy,
+	.sdev_destroy			= mptscsih_sdev_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_timed_out			= mptsas_eh_timed_out,
 	.eh_abort_handler		= mptscsih_abort,
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 1491561d2e5c..e7d78e73b236 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1071,7 +1071,7 @@ EXPORT_SYMBOL(mptscsih_flush_running_cmds);
  *
  *	Returns: None.
  *
- *	Called from slave_destroy.
+ *	Called from sdev_destroy.
  */
 static void
 mptscsih_search_running_cmds(MPT_SCSI_HOST *hd, VirtDevice *vdevice)
@@ -2278,7 +2278,7 @@ EXPORT_SYMBOL(mptscsih_raid_id_to_num);
  *	Called if no device present or device being unloaded
  */
 void
-mptscsih_slave_destroy(struct scsi_device *sdev)
+mptscsih_sdev_destroy(struct scsi_device *sdev)
 {
 	struct Scsi_Host	*host = sdev->host;
 	MPT_SCSI_HOST		*hd = shost_priv(host);
@@ -3243,7 +3243,7 @@ EXPORT_SYMBOL(mptscsih_resume);
 EXPORT_SYMBOL(mptscsih_show_info);
 EXPORT_SYMBOL(mptscsih_info);
 EXPORT_SYMBOL(mptscsih_qcmd);
-EXPORT_SYMBOL(mptscsih_slave_destroy);
+EXPORT_SYMBOL(mptscsih_sdev_destroy);
 EXPORT_SYMBOL(mptscsih_slave_configure);
 EXPORT_SYMBOL(mptscsih_abort);
 EXPORT_SYMBOL(mptscsih_dev_reset);
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 2baeefd9be7a..09bab23a9abb 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -116,7 +116,7 @@ extern const char * mptscsih_info(struct Scsi_Host *SChost);
 extern int mptscsih_qcmd(struct scsi_cmnd *SCpnt);
 extern int mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel,
 	u8 id, u64 lun, int ctx2abort, ulong timeout);
-extern void mptscsih_slave_destroy(struct scsi_device *device);
+extern void mptscsih_sdev_destroy(struct scsi_device *device);
 extern int mptscsih_slave_configure(struct scsi_device *device);
 extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
 extern int mptscsih_dev_reset(struct scsi_cmnd * SCpnt);
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 633858a445ce..ec8a5396661d 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -799,7 +799,7 @@ mptspi_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
 	return mptscsih_qcmd(SCpnt);
 }
 
-static void mptspi_slave_destroy(struct scsi_device *sdev)
+static void mptspi_sdev_destroy(struct scsi_device *sdev)
 {
 	struct scsi_target *starget = scsi_target(sdev);
 	VirtTarget *vtarget = starget->hostdata;
@@ -817,7 +817,7 @@ static void mptspi_slave_destroy(struct scsi_device *sdev)
 		mptspi_write_spi_device_pg1(starget, &pg1);
 	}
 
-	mptscsih_slave_destroy(sdev);
+	mptscsih_sdev_destroy(sdev);
 }
 
 static struct scsi_host_template mptspi_driver_template = {
@@ -831,7 +831,7 @@ static struct scsi_host_template mptspi_driver_template = {
 	.sdev_prep			= mptspi_sdev_prep,
 	.slave_configure		= mptspi_slave_configure,
 	.target_destroy			= mptspi_target_destroy,
-	.slave_destroy			= mptspi_slave_destroy,
+	.sdev_destroy			= mptspi_sdev_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_abort_handler		= mptscsih_abort,
 	.eh_device_reset_handler	= mptscsih_dev_reset,
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 3d9aa7da95e9..3e2fd145cb4e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -855,7 +855,7 @@ static void slave_adjust_steering_mode(struct mlx4_dev *dev,
 		 mlx4_steering_mode_str(dev->caps.steering_mode));
 }
 
-static void mlx4_slave_destroy_special_qp_cap(struct mlx4_dev *dev)
+static void mlx4_sdev_destroy_special_qp_cap(struct mlx4_dev *dev)
 {
 	kfree(dev->caps.spec_qps);
 	dev->caps.spec_qps = NULL;
@@ -898,7 +898,7 @@ static int mlx4_slave_special_qp_cap(struct mlx4_dev *dev)
 
 err_mem:
 	if (err)
-		mlx4_slave_destroy_special_qp_cap(dev);
+		mlx4_sdev_destroy_special_qp_cap(dev);
 	kfree(func_cap);
 	return err;
 }
@@ -1082,7 +1082,7 @@ static int mlx4_slave_cap(struct mlx4_dev *dev)
 
 err_mem:
 	if (err)
-		mlx4_slave_destroy_special_qp_cap(dev);
+		mlx4_sdev_destroy_special_qp_cap(dev);
 free_mem:
 	kfree(hca_param);
 	kfree(func_cap);
@@ -2476,7 +2476,7 @@ static int mlx4_init_hca(struct mlx4_dev *dev)
 	unmap_bf_area(dev);
 
 	if (mlx4_is_slave(dev))
-		mlx4_slave_destroy_special_qp_cap(dev);
+		mlx4_sdev_destroy_special_qp_cap(dev);
 
 err_close:
 	if (mlx4_is_slave(dev))
@@ -3673,7 +3673,7 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 	}
 
 	if (mlx4_is_slave(dev))
-		mlx4_slave_destroy_special_qp_cap(dev);
+		mlx4_sdev_destroy_special_qp_cap(dev);
 
 err_close:
 	mlx4_close_hca(dev);
@@ -4110,7 +4110,7 @@ static void mlx4_unload_one(struct pci_dev *pdev)
 	if (!mlx4_is_slave(dev))
 		mlx4_free_ownership(dev);
 
-	mlx4_slave_destroy_special_qp_cap(dev);
+	mlx4_sdev_destroy_special_qp_cap(dev);
 	kfree(dev->dev_vfs);
 
 	mlx4_clean_dev(dev);
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index a603bdd7b7c5..1f95c38738e3 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -37,7 +37,7 @@ static bool allow_lun_scan = true;
 module_param(allow_lun_scan, bool, 0600);
 MODULE_PARM_DESC(allow_lun_scan, "For NPIV, scan and attach all storage LUNs");
 
-static void zfcp_scsi_slave_destroy(struct scsi_device *sdev)
+static void zfcp_scsi_sdev_destroy(struct scsi_device *sdev)
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 
@@ -429,7 +429,7 @@ static struct scsi_host_template zfcp_scsi_host_template = {
 	.eh_host_reset_handler	 = zfcp_scsi_eh_host_reset_handler,
 	.sdev_prep		 = zfcp_scsi_sdev_prep,
 	.slave_configure	 = zfcp_scsi_slave_configure,
-	.slave_destroy		 = zfcp_scsi_slave_destroy,
+	.sdev_destroy		 = zfcp_scsi_sdev_destroy,
 	.change_queue_depth	 = scsi_change_queue_depth,
 	.host_reset		 = zfcp_scsi_sysfs_host_reset,
 	.proc_name		 = "zfcp",
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 9410a7a3873a..95c71fba16a2 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -161,7 +161,7 @@ STATIC void NCR_700_chip_setup(struct Scsi_Host *host);
 STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
 STATIC int NCR_700_sdev_prep(struct scsi_device *SDpnt);
 STATIC int NCR_700_slave_configure(struct scsi_device *SDpnt);
-STATIC void NCR_700_slave_destroy(struct scsi_device *SDpnt);
+STATIC void NCR_700_sdev_destroy(struct scsi_device *SDpnt);
 static int NCR_700_change_queue_depth(struct scsi_device *SDpnt, int depth);
 
 STATIC struct device_attribute *NCR_700_dev_attrs[];
@@ -307,7 +307,7 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	tpnt->sg_tablesize = NCR_700_SG_SEGMENTS;
 	tpnt->cmd_per_lun = NCR_700_CMD_PER_LUN;
 	tpnt->slave_configure = NCR_700_slave_configure;
-	tpnt->slave_destroy = NCR_700_slave_destroy;
+	tpnt->sdev_destroy = NCR_700_sdev_destroy;
 	tpnt->sdev_prep = NCR_700_sdev_prep;
 	tpnt->change_queue_depth = NCR_700_change_queue_depth;
 
@@ -2041,7 +2041,7 @@ NCR_700_slave_configure(struct scsi_device *SDp)
 }
 
 STATIC void
-NCR_700_slave_destroy(struct scsi_device *SDp)
+NCR_700_sdev_destroy(struct scsi_device *SDp)
 {
 	kfree(SDp->hostdata);
 	SDp->hostdata = NULL;
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index bd860b6b8d46..d93524ab1a47 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -405,10 +405,10 @@ bfad_im_reset_target_handler(struct scsi_cmnd *cmnd)
 }
 
 /*
- * Scsi_Host template entry slave_destroy.
+ * Scsi_Host template entry sdev_destroy.
  */
 static void
-bfad_im_slave_destroy(struct scsi_device *sdev)
+bfad_im_sdev_destroy(struct scsi_device *sdev)
 {
 	sdev->hostdata = NULL;
 	return;
@@ -804,7 +804,7 @@ struct scsi_host_template bfad_im_scsi_host_template = {
 
 	.sdev_prep = bfad_im_sdev_prep,
 	.slave_configure = bfad_im_slave_configure,
-	.slave_destroy = bfad_im_slave_destroy,
+	.sdev_destroy = bfad_im_sdev_destroy,
 
 	.this_id = -1,
 	.sg_tablesize = BFAD_IO_MAX_SGE,
@@ -826,7 +826,7 @@ struct scsi_host_template bfad_im_vport_template = {
 
 	.sdev_prep = bfad_im_sdev_prep,
 	.slave_configure = bfad_im_slave_configure,
-	.slave_destroy = bfad_im_slave_destroy,
+	.sdev_destroy = bfad_im_sdev_destroy,
 
 	.this_id = -1,
 	.sg_tablesize = BFAD_IO_MAX_SGE,
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 0ee7d39bde93..cd53c2ed31fb 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2239,7 +2239,7 @@ csio_slave_configure(struct scsi_device *sdev)
 }
 
 static void
-csio_slave_destroy(struct scsi_device *sdev)
+csio_sdev_destroy(struct scsi_device *sdev)
 {
 	sdev->hostdata = NULL;
 }
@@ -2272,7 +2272,7 @@ struct scsi_host_template csio_fcoe_shost_template = {
 	.eh_device_reset_handler = csio_eh_lun_reset_handler,
 	.sdev_prep		= csio_sdev_prep,
 	.slave_configure	= csio_slave_configure,
-	.slave_destroy		= csio_slave_destroy,
+	.sdev_destroy		= csio_sdev_destroy,
 	.scan_finished		= csio_scan_finished,
 	.this_id		= -1,
 	.sg_tablesize		= CSIO_SCSI_MAX_SGE,
@@ -2291,7 +2291,7 @@ struct scsi_host_template csio_fcoe_shost_vport_template = {
 	.eh_device_reset_handler = csio_eh_lun_reset_handler,
 	.sdev_prep		= csio_sdev_prep,
 	.slave_configure	= csio_slave_configure,
-	.slave_destroy		= csio_slave_destroy,
+	.sdev_destroy		= csio_sdev_destroy,
 	.scan_finished		= csio_scan_finished,
 	.this_id		= -1,
 	.sg_tablesize		= CSIO_SCSI_MAX_SGE,
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 6b22777c123f..77d5c894b5ea 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3773,12 +3773,12 @@ static int dc395x_sdev_prep(struct scsi_device *scsi_device)
 
 
 /**
- * dc395x_slave_destroy - Called by the scsi mid layer to tell us about a
+ * dc395x_sdev_destroy - Called by the scsi mid layer to tell us about a
  * device that is going away.
  *
  * @scsi_device: The new scsi device that we need to handle.
  **/
-static void dc395x_slave_destroy(struct scsi_device *scsi_device)
+static void dc395x_sdev_destroy(struct scsi_device *scsi_device)
 {
 	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)scsi_device->host->hostdata;
 	struct DeviceCtlBlk *dcb = find_dcb(acb, scsi_device->id, scsi_device->lun);
@@ -4590,7 +4590,7 @@ static struct scsi_host_template dc395x_driver_template = {
 	.name                   = DC395X_BANNER " " DC395X_VERSION,
 	.queuecommand           = dc395x_queue_command,
 	.sdev_prep            = dc395x_sdev_prep,
-	.slave_destroy          = dc395x_slave_destroy,
+	.sdev_destroy          = dc395x_sdev_destroy,
 	.can_queue              = DC395x_MAX_CAN_QUEUE,
 	.this_id                = 7,
 	.sg_tablesize           = DC395x_MAX_SG_TABLESIZE,
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 37471f82921a..70390b43fd9e 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2490,7 +2490,7 @@ static int esp_slave_configure(struct scsi_device *dev)
 	return 0;
 }
 
-static void esp_slave_destroy(struct scsi_device *dev)
+static void esp_sdev_destroy(struct scsi_device *dev)
 {
 	struct esp_lun_data *lp = dev->hostdata;
 
@@ -2680,7 +2680,7 @@ struct scsi_host_template scsi_esp_template = {
 	.target_destroy		= esp_target_destroy,
 	.sdev_prep		= esp_sdev_prep,
 	.slave_configure	= esp_slave_configure,
-	.slave_destroy		= esp_slave_destroy,
+	.sdev_destroy		= esp_sdev_destroy,
 	.eh_abort_handler	= esp_eh_abort_handler,
 	.eh_bus_reset_handler	= esp_eh_bus_reset_handler,
 	.eh_host_reset_handler	= esp_eh_host_reset_handler,
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 4e4d3045da7a..7278f2a01983 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -285,7 +285,7 @@ static int hpsa_change_queue_depth(struct scsi_device *sdev, int qdepth);
 static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd);
 static int hpsa_sdev_prep(struct scsi_device *sdev);
 static int hpsa_slave_configure(struct scsi_device *sdev);
-static void hpsa_slave_destroy(struct scsi_device *sdev);
+static void hpsa_sdev_destroy(struct scsi_device *sdev);
 
 static void hpsa_update_scsi_devices(struct ctlr_info *h);
 static int check_for_unit_attention(struct ctlr_info *h,
@@ -976,7 +976,7 @@ static struct scsi_host_template hpsa_driver_template = {
 	.ioctl			= hpsa_ioctl,
 	.sdev_prep		= hpsa_sdev_prep,
 	.slave_configure	= hpsa_slave_configure,
-	.slave_destroy		= hpsa_slave_destroy,
+	.sdev_destroy		= hpsa_sdev_destroy,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= hpsa_compat_ioctl,
 #endif
@@ -2161,7 +2161,7 @@ static int hpsa_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
-static void hpsa_slave_destroy(struct scsi_device *sdev)
+static void hpsa_sdev_destroy(struct scsi_device *sdev)
 {
 	struct hpsa_scsi_dev_t *hdev = NULL;
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 2920b4c48896..7d783b5e7b6f 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4891,13 +4891,13 @@ static struct ipr_resource_entry *ipr_find_sdev(struct scsi_device *sdev)
 }
 
 /**
- * ipr_slave_destroy - Unconfigure a SCSI device
+ * ipr_sdev_destroy - Unconfigure a SCSI device
  * @sdev:	scsi device struct
  *
  * Return value:
  * 	nothing
  **/
-static void ipr_slave_destroy(struct scsi_device *sdev)
+static void ipr_sdev_destroy(struct scsi_device *sdev)
 {
 	struct ipr_resource_entry *res;
 	struct ipr_ioa_cfg *ioa_cfg;
@@ -4994,7 +4994,7 @@ static int ipr_ata_sdev_prep(struct scsi_device *sdev)
 	}
 
 	if (rc)
-		ipr_slave_destroy(sdev);
+		ipr_sdev_destroy(sdev);
 
 	LEAVE;
 	return rc;
@@ -6737,7 +6737,7 @@ static struct scsi_host_template driver_template = {
 	.eh_host_reset_handler = ipr_eh_host_reset,
 	.sdev_prep = ipr_sdev_prep,
 	.slave_configure = ipr_slave_configure,
-	.slave_destroy = ipr_slave_destroy,
+	.sdev_destroy = ipr_sdev_destroy,
 	.scan_finished = ipr_scan_finished,
 	.target_alloc = ipr_target_alloc,
 	.target_destroy = ipr_target_destroy,
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 6974665f5ade..aeabcb3b1df7 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5638,13 +5638,13 @@ lpfc_slave_configure(struct scsi_device *sdev)
 }
 
 /**
- * lpfc_slave_destroy - slave_destroy entry point of SHT data structure
+ * lpfc_sdev_destroy - sdev_destroy entry point of SHT data structure
  * @sdev: Pointer to scsi_device.
  *
  * This routine sets @sdev hostatdata filed to null.
  **/
 static void
-lpfc_slave_destroy(struct scsi_device *sdev)
+lpfc_sdev_destroy(struct scsi_device *sdev)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *) sdev->host->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
@@ -6048,7 +6048,7 @@ struct scsi_host_template lpfc_template = {
 	.eh_host_reset_handler  = lpfc_host_reset_handler,
 	.sdev_prep		= lpfc_sdev_prep,
 	.slave_configure	= lpfc_slave_configure,
-	.slave_destroy		= lpfc_slave_destroy,
+	.sdev_destroy		= lpfc_sdev_destroy,
 	.scan_finished		= lpfc_scan_finished,
 	.this_id		= -1,
 	.sg_tablesize		= LPFC_DEFAULT_SG_SEG_CNT,
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 7f0f058c4a80..0992869bffd4 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2105,7 +2105,7 @@ static int megasas_sdev_prep(struct scsi_device *sdev)
 	return 0;
 }
 
-static void megasas_slave_destroy(struct scsi_device *sdev)
+static void megasas_sdev_destroy(struct scsi_device *sdev)
 {
 	kfree(sdev->hostdata);
 	sdev->hostdata = NULL;
@@ -3415,7 +3415,7 @@ static struct scsi_host_template megasas_template = {
 	.proc_name = "megaraid_sas",
 	.slave_configure = megasas_slave_configure,
 	.sdev_prep = megasas_sdev_prep,
-	.slave_destroy = megasas_slave_destroy,
+	.sdev_destroy = megasas_sdev_destroy,
 	.queuecommand = megasas_queue_command,
 	.eh_target_reset_handler = megasas_reset_target,
 	.eh_abort_handler = megasas_task_abort,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index b46a5d6c3f7e..674e72ed1398 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1880,11 +1880,11 @@ scsih_sdev_prep(struct scsi_device *sdev)
 }
 
 /**
- * scsih_slave_destroy - device destroy routine
+ * scsih_sdev_destroy - device destroy routine
  * @sdev: scsi device struct
  */
 static void
-scsih_slave_destroy(struct scsi_device *sdev)
+scsih_sdev_destroy(struct scsi_device *sdev)
 {
 	struct MPT3SAS_TARGET *sas_target_priv_data;
 	struct scsi_target *starget;
@@ -10430,7 +10430,7 @@ static struct scsi_host_template mpt2sas_driver_template = {
 	.sdev_prep			= scsih_sdev_prep,
 	.slave_configure		= scsih_slave_configure,
 	.target_destroy			= scsih_target_destroy,
-	.slave_destroy			= scsih_slave_destroy,
+	.sdev_destroy			= scsih_sdev_destroy,
 	.scan_finished			= scsih_scan_finished,
 	.scan_start			= scsih_scan_start,
 	.change_queue_depth		= scsih_change_queue_depth,
@@ -10468,7 +10468,7 @@ static struct scsi_host_template mpt3sas_driver_template = {
 	.sdev_prep			= scsih_sdev_prep,
 	.slave_configure		= scsih_slave_configure,
 	.target_destroy			= scsih_target_destroy,
-	.slave_destroy			= scsih_slave_destroy,
+	.sdev_destroy			= scsih_sdev_destroy,
 	.scan_finished			= scsih_scan_finished,
 	.scan_start			= scsih_scan_start,
 	.change_queue_depth		= scsih_change_queue_depth,
diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 2d3ffd79076a..d2dfec5c4a3a 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1769,7 +1769,7 @@ static int myrb_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
-static void myrb_slave_destroy(struct scsi_device *sdev)
+static void myrb_sdev_destroy(struct scsi_device *sdev)
 {
 	kfree(sdev->hostdata);
 }
@@ -2234,7 +2234,7 @@ struct scsi_host_template myrb_template = {
 	.eh_host_reset_handler	= myrb_host_reset,
 	.sdev_prep		= myrb_sdev_prep,
 	.slave_configure	= myrb_slave_configure,
-	.slave_destroy		= myrb_slave_destroy,
+	.sdev_destroy		= myrb_sdev_destroy,
 	.bios_param		= myrb_biosparam,
 	.cmd_size		= sizeof(struct myrb_cmdblk),
 	.shost_attrs		= myrb_shost_attrs,
diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 6e8882bda8b8..1b9f6103096d 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1914,7 +1914,7 @@ static int myrs_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
-static void myrs_slave_destroy(struct scsi_device *sdev)
+static void myrs_sdev_destroy(struct scsi_device *sdev)
 {
 	kfree(sdev->hostdata);
 }
@@ -1927,7 +1927,7 @@ struct scsi_host_template myrs_template = {
 	.eh_host_reset_handler	= myrs_host_reset,
 	.sdev_prep		= myrs_sdev_prep,
 	.slave_configure	= myrs_slave_configure,
-	.slave_destroy		= myrs_slave_destroy,
+	.sdev_destroy		= myrs_sdev_destroy,
 	.cmd_size		= sizeof(struct myrs_cmdblk),
 	.shost_attrs		= myrs_shost_attrs,
 	.sdev_attrs		= myrs_sdev_attrs,
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index e160c128d3e8..0cf4c8d894a4 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -245,7 +245,7 @@ static int pmcraid_slave_configure(struct scsi_device *scsi_dev)
 }
 
 /**
- * pmcraid_slave_destroy - Unconfigure a SCSI device before removing it
+ * pmcraid_sdev_destroy - Unconfigure a SCSI device before removing it
  *
  * @scsi_dev: scsi device struct
  *
@@ -255,7 +255,7 @@ static int pmcraid_slave_configure(struct scsi_device *scsi_dev)
  * Return value
  *   none
  */
-static void pmcraid_slave_destroy(struct scsi_device *scsi_dev)
+static void pmcraid_sdev_destroy(struct scsi_device *scsi_dev)
 {
 	struct pmcraid_resource_entry *res;
 
@@ -4122,7 +4122,7 @@ static struct scsi_host_template pmcraid_host_template = {
 
 	.sdev_prep = pmcraid_sdev_prep,
 	.slave_configure = pmcraid_slave_configure,
-	.slave_destroy = pmcraid_slave_destroy,
+	.sdev_destroy = pmcraid_sdev_destroy,
 	.change_queue_depth = pmcraid_change_queue_depth,
 	.can_queue = PMCRAID_MAX_IO_CMD,
 	.this_id = -1,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 807db94cf148..18134c2ad835 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1864,7 +1864,7 @@ qla2xxx_slave_configure(struct scsi_device *sdev)
 }
 
 static void
-qla2xxx_slave_destroy(struct scsi_device *sdev)
+qla2xxx_sdev_destroy(struct scsi_device *sdev)
 {
 	sdev->hostdata = NULL;
 }
@@ -7768,7 +7768,7 @@ struct scsi_host_template qla2xxx_driver_template = {
 	.slave_configure	= qla2xxx_slave_configure,
 
 	.sdev_prep		= qla2xxx_sdev_prep,
-	.slave_destroy		= qla2xxx_slave_destroy,
+	.sdev_destroy		= qla2xxx_sdev_destroy,
 	.scan_finished		= qla2xxx_scan_finished,
 	.scan_start		= qla2xxx_scan_start,
 	.change_queue_depth	= scsi_change_queue_depth,
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index bb914e2e7554..741502da09c4 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4999,13 +4999,13 @@ static int scsi_debug_slave_configure(struct scsi_device *sdp)
 	return 0;
 }
 
-static void scsi_debug_slave_destroy(struct scsi_device *sdp)
+static void scsi_debug_sdev_destroy(struct scsi_device *sdp)
 {
 	struct sdebug_dev_info *devip =
 		(struct sdebug_dev_info *)sdp->hostdata;
 
 	if (sdebug_verbose)
-		pr_info("slave_destroy <%u %u %u %llu>\n",
+		pr_info("sdev_destroy <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	if (devip) {
 		/* make this slot available for re-use */
@@ -7223,7 +7223,7 @@ static struct scsi_host_template sdebug_driver_template = {
 	.info =			scsi_debug_info,
 	.sdev_prep =		scsi_debug_sdev_prep,
 	.slave_configure =	scsi_debug_slave_configure,
-	.slave_destroy =	scsi_debug_slave_destroy,
+	.sdev_destroy =	scsi_debug_sdev_destroy,
 	.ioctl =		scsi_debug_ioctl,
 	.queuecommand =		scsi_debug_queuecommand,
 	.change_queue_depth =	sdebug_change_qdepth,
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 163dbcb741c1..b27f83e5e6fd 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1441,8 +1441,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	blk_cleanup_queue(sdev->request_queue);
 	cancel_work_sync(&sdev->requeue_work);
 
-	if (sdev->host->hostt->slave_destroy)
-		sdev->host->hostt->slave_destroy(sdev);
+	if (sdev->host->hostt->sdev_destroy)
+		sdev->host->hostt->sdev_destroy(sdev);
 	transport_destroy_device(dev);
 
 	/*
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 4d59783ed465..128e4ad0124d 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -817,7 +817,7 @@ static int sym53c8xx_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
-static void sym53c8xx_slave_destroy(struct scsi_device *sdev)
+static void sym53c8xx_sdev_destroy(struct scsi_device *sdev)
 {
 	struct sym_hcb *np = sym_get_hcb(sdev->host);
 	struct sym_tcb *tp = &np->target[sdev->id];
@@ -1641,7 +1641,7 @@ static struct scsi_host_template sym2_template = {
 	.queuecommand		= sym53c8xx_queue_command,
 	.sdev_prep		= sym53c8xx_sdev_prep,
 	.slave_configure	= sym53c8xx_slave_configure,
-	.slave_destroy		= sym53c8xx_slave_destroy,
+	.sdev_destroy		= sym53c8xx_sdev_destroy,
 	.eh_abort_handler	= sym53c8xx_eh_abort_handler,
 	.eh_device_reset_handler = sym53c8xx_eh_device_reset_handler,
 	.eh_bus_reset_handler	= sym53c8xx_eh_bus_reset_handler,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 58cd8a609b31..ca9fc27c4f02 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4674,10 +4674,10 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 }
 
 /**
- * ufshcd_slave_destroy - remove SCSI device configurations
+ * ufshcd_sdev_destroy - remove SCSI device configurations
  * @sdev: pointer to SCSI device
  */
-static void ufshcd_slave_destroy(struct scsi_device *sdev)
+static void ufshcd_sdev_destroy(struct scsi_device *sdev)
 {
 	struct ufs_hba *hba;
 
@@ -7491,7 +7491,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.queuecommand		= ufshcd_queuecommand,
 	.sdev_prep		= ufshcd_sdev_prep,
 	.slave_configure	= ufshcd_slave_configure,
-	.slave_destroy		= ufshcd_slave_destroy,
+	.sdev_destroy		= ufshcd_sdev_destroy,
 	.change_queue_depth	= ufshcd_change_queue_depth,
 	.eh_abort_handler	= ufshcd_abort,
 	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index f0068e96a177..319b8bf68117 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -690,7 +690,7 @@ static struct scsi_host_template scsifront_sht = {
 	.eh_abort_handler	= scsifront_eh_abort_handler,
 	.eh_device_reset_handler = scsifront_dev_reset_handler,
 	.slave_configure	= scsifront_sdev_configure,
-	.slave_destroy		= scsifront_sdev_destroy,
+	.sdev_destroy		= scsifront_sdev_destroy,
 	.cmd_per_lun		= VSCSIIF_DEFAULT_CMD_PER_LUN,
 	.can_queue		= VSCSIIF_MAX_REQS,
 	.this_id		= -1,
@@ -1001,7 +1001,7 @@ static void scsifront_do_lun_hotplug(struct vscsifrnt_info *info, int op)
 
 		/*
 		 * Front device state path, used in slave_configure called
-		 * on successfull scsi_add_device, and in slave_destroy called
+		 * on successfull scsi_add_device, and in sdev_destroy called
 		 * on remove of a device.
 		 */
 		snprintf(info->dev_state_path, sizeof(info->dev_state_path),
diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c b/drivers/staging/unisys/visorhba/visorhba_main.c
index b6023fcc7908..0a7211d600f7 100644
--- a/drivers/staging/unisys/visorhba/visorhba_main.c
+++ b/drivers/staging/unisys/visorhba/visorhba_main.c
@@ -615,10 +615,10 @@ static int visorhba_sdev_prep(struct scsi_device *scsidev)
 }
 
 /*
- * visorhba_slave_destroy - Disk is going away, clean up resources.
+ * visorhba_sdev_destroy - Disk is going away, clean up resources.
  * @scsidev: Scsi device to destroy
  */
-static void visorhba_slave_destroy(struct scsi_device *scsidev)
+static void visorhba_sdev_destroy(struct scsi_device *scsidev)
 {
 	/* midlevel calls this after device has been quiesced and
 	 * before it is to be deleted.
@@ -644,7 +644,7 @@ static struct scsi_host_template visorhba_driver_template = {
 	.sg_tablesize = 64,
 	.this_id = -1,
 	.sdev_prep = visorhba_sdev_prep,
-	.slave_destroy = visorhba_slave_destroy,
+	.sdev_destroy = visorhba_sdev_destroy,
 };
 
 /*
diff --git a/include/linux/libata.h b/include/linux/libata.h
index c57bf6749681..e7153fca9cfc 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1149,7 +1149,7 @@ extern int ata_std_bios_param(struct scsi_device *sdev,
 			      sector_t capacity, int geom[]);
 extern void ata_scsi_unlock_native_capacity(struct scsi_device *sdev);
 extern int ata_scsi_slave_config(struct scsi_device *sdev);
-extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
+extern void ata_scsi_sdev_destroy(struct scsi_device *sdev);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth);
 extern int __ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
@@ -1399,7 +1399,7 @@ extern struct device_attribute *ata_common_sdev_attrs[];
 	.emulated		= ATA_SHT_EMULATED,		\
 	.proc_name		= drv_name,			\
 	.slave_configure	= ata_scsi_slave_config,	\
-	.slave_destroy		= ata_scsi_slave_destroy,	\
+	.sdev_destroy		= ata_scsi_sdev_destroy,	\
 	.bios_param		= ata_std_bios_param,		\
 	.unlock_native_capacity	= ata_scsi_unlock_native_capacity
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 8e44d61b6f47..334bb4adadaf 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -148,14 +148,14 @@ struct scsi_host_template {
 	 * Return values: 0 on success, non-0 on failure
 	 *
 	 * Deallocation:  If we didn't find any devices at this ID, you will
-	 * get an immediate call to slave_destroy().  If we find something
+	 * get an immediate call to sdev_destroy().  If we find something
 	 * here then you will get a call to slave_configure(), then the
 	 * device will be used for however long it is kept around, then when
 	 * the device is removed from the system (or * possibly at reboot
-	 * time), you will then get a call to slave_destroy().  This is
-	 * assuming you implement slave_configure and slave_destroy.
+	 * time), you will then get a call to sdev_destroy().  This is
+	 * assuming you implement slave_configure and sdev_destroy.
 	 * However, if you allocate memory and hang it off the device struct,
-	 * then you must implement the slave_destroy() routine at a minimum
+	 * then you must implement the sdev_destroy() routine at a minimum
 	 * in order to avoid leaking memory
 	 * each time a device is tore down.
 	 *
@@ -186,7 +186,7 @@ struct scsi_host_template {
 	 *     specific setup basis...
 	 * 6.  Return 0 on success, non-0 on error.  The device will be marked
 	 *     as offline on error so that no access will occur.  If you return
-	 *     non-0, your slave_destroy routine will never get called for this
+	 *     non-0, your sdev_destroy routine will never get called for this
 	 *     device, so don't leave any loose memory hanging around, clean
 	 *     up after yourself before returning non-0
 	 *
@@ -203,7 +203,7 @@ struct scsi_host_template {
 	 *
 	 * Status: OPTIONAL
 	 */
-	void (* slave_destroy)(struct scsi_device *);
+	void (* sdev_destroy)(struct scsi_device *);
 
 	/*
 	 * Before the mid layer attempts to scan for a new device attached
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 076908fdd29b..6baef2a81943 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -368,7 +368,7 @@ static void dsa_port_teardown(struct dsa_port *dp)
 	case DSA_PORT_TYPE_USER:
 		devlink_port_unregister(dlp);
 		if (dp->slave) {
-			dsa_slave_destroy(dp->slave);
+			dsa_sdev_destroy(dp->slave);
 			dp->slave = NULL;
 		}
 		break;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index adecf73bd608..b34ea3df9637 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -174,7 +174,7 @@ extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
 extern const struct dsa_device_ops notag_netdev_ops;
 void dsa_slave_mii_bus_init(struct dsa_switch *ds);
 int dsa_slave_create(struct dsa_port *dp);
-void dsa_slave_destroy(struct net_device *slave_dev);
+void dsa_sdev_destroy(struct net_device *slave_dev);
 bool dsa_slave_dev_check(const struct net_device *dev);
 int dsa_slave_suspend(struct net_device *slave_dev);
 int dsa_slave_resume(struct net_device *slave_dev);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4c7f086a047b..4591c6245783 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1824,7 +1824,7 @@ int dsa_slave_create(struct dsa_port *port)
 	return ret;
 }
 
-void dsa_slave_destroy(struct net_device *slave_dev)
+void dsa_sdev_destroy(struct net_device *slave_dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(slave_dev);
 	struct dsa_slave_priv *p = netdev_priv(slave_dev);
-- 
2.27.0

