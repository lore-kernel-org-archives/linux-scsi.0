Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64041C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 19:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25DFD20675
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 19:39:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X3kh+7rA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgGFTjb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 15:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFTja (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 15:39:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E33C061755
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2020 12:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=+9DU425cN2dJVKSz8+pxN8sx6KNlFI3asjnvfpYYKH4=; b=X3kh+7rApcpxAKfWUwkLoV3KlW
        KpE00sovFt1xb13YDyvhbPiq2KgSCTqC/QfU5jawJdSj7HP1fobQ8+AgkpbXgg3ycMFAcLqDVr/A5
        sAUYQ5Qoi/f2Sy+0T2I7deDf4t3t752sATr9vL4dCRosMMTBJqWoKX0/qgvBof5j3ewPHSxwMXkro
        utr39rd8vMrmjfqZMpRA8q5kg5pC4oA4GDtdWvkjd/ZP/1cdMha9uub/B76Vq7pB3yXtmj/QypnqU
        CZKEzg6c9iCknOBptT+F6QsUqf8GrSTNpzaCaJTMvpC1SjgOK+LMS6RhQSfzxogJR3X42SDi2zwSe
        6DhpgGIQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jsWxY-0001oP-NX; Mon, 06 Jul 2020 19:39:24 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 3/3] scsi: Rename slave_configure to sdev_configure
Date:   Mon,  6 Jul 2020 20:39:20 +0100
Message-Id: <20200706193920.6897-4-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200706193920.6897-1-willy@infradead.org>
References: <20200706193920.6897-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Match sdev_init() and sdev_destroy().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 Documentation/scsi/scsi_mid_low_api.rst   | 30 +++++++++++------------
 drivers/ata/libata-sata.c                 |  6 ++---
 drivers/ata/libata-scsi.c                 |  6 ++---
 drivers/ata/pata_macio.c                  |  6 ++---
 drivers/ata/sata_nv.c                     | 16 ++++++------
 drivers/firewire/sbp2.c                   |  4 +--
 drivers/infiniband/ulp/srp/ib_srp.c       |  4 +--
 drivers/message/fusion/mptfc.c            |  2 +-
 drivers/message/fusion/mptsas.c           |  6 ++---
 drivers/message/fusion/mptscsih.c         |  4 +--
 drivers/message/fusion/mptscsih.h         |  2 +-
 drivers/message/fusion/mptspi.c           |  6 ++---
 drivers/s390/scsi/zfcp_scsi.c             |  4 +--
 drivers/scsi/3w-9xxx.c                    |  6 ++---
 drivers/scsi/3w-sas.c                     |  6 ++---
 drivers/scsi/3w-xxxx.c                    |  8 +++---
 drivers/scsi/53c700.c                     |  6 ++---
 drivers/scsi/BusLogic.c                   |  6 ++---
 drivers/scsi/BusLogic.h                   |  1 -
 drivers/scsi/aacraid/linit.c              |  6 ++---
 drivers/scsi/advansys.c                   | 18 +++++++-------
 drivers/scsi/aic7xxx/aic79xx_osm.c        |  4 +--
 drivers/scsi/aic7xxx/aic7xxx_osm.c        |  4 +--
 drivers/scsi/aic94xx/aic94xx_init.c       |  2 +-
 drivers/scsi/bfa/bfad_im.c                |  6 ++---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c         |  4 +--
 drivers/scsi/csiostor/csio_scsi.c         |  6 ++---
 drivers/scsi/dpt_i2o.c                    |  4 +--
 drivers/scsi/dpti.h                       |  2 +-
 drivers/scsi/esp_scsi.c                   |  6 ++---
 drivers/scsi/gdth.c                       |  4 +--
 drivers/scsi/hisi_sas/hisi_sas.h          |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c     |  6 ++---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c    |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c    |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |  2 +-
 drivers/scsi/hpsa.c                       |  6 ++---
 drivers/scsi/hptiop.c                     |  4 +--
 drivers/scsi/ibmvscsi/ibmvfc.c            |  6 ++---
 drivers/scsi/ibmvscsi/ibmvscsi.c          |  6 ++---
 drivers/scsi/ipr.c                        |  8 +++---
 drivers/scsi/ips.c                        |  6 ++---
 drivers/scsi/ips.h                        |  2 +-
 drivers/scsi/isci/init.c                  |  2 +-
 drivers/scsi/iscsi_tcp.c                  |  4 +--
 drivers/scsi/libsas/sas_scsi_host.c       |  6 ++---
 drivers/scsi/lpfc/lpfc_scsi.c             |  8 +++---
 drivers/scsi/megaraid/megaraid_sas_base.c |  4 +--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |  8 +++---
 drivers/scsi/mvsas/mv_init.c              |  2 +-
 drivers/scsi/mvumi.c                      |  4 +--
 drivers/scsi/myrb.c                       |  4 +--
 drivers/scsi/myrs.c                       |  4 +--
 drivers/scsi/ncr53c8xx.c                  |  4 +--
 drivers/scsi/pm8001/pm8001_init.c         |  2 +-
 drivers/scsi/pmcraid.c                    |  6 ++---
 drivers/scsi/ps3rom.c                     |  4 +--
 drivers/scsi/qedf/qedf_main.c             |  4 +--
 drivers/scsi/qla1280.c                    |  6 ++---
 drivers/scsi/qla2xxx/qla_os.c             |  4 +--
 drivers/scsi/qlogicpti.c                  |  4 +--
 drivers/scsi/scsi_debug.c                 |  6 ++---
 drivers/scsi/scsi_scan.c                  | 10 ++++----
 drivers/scsi/snic/snic_main.c             |  6 ++---
 drivers/scsi/stex.c                       |  4 +--
 drivers/scsi/storvsc_drv.c                |  2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c       |  4 +--
 drivers/scsi/ufs/ufshcd.c                 |  6 ++---
 drivers/scsi/xen-scsifront.c              |  4 +--
 drivers/staging/rts5208/rtsx.c            |  4 +--
 drivers/usb/image/microtek.c              |  4 +--
 drivers/usb/storage/scsiglue.c            |  4 +--
 drivers/usb/storage/uas.c                 |  4 +--
 include/linux/libata.h                    |  6 ++---
 include/scsi/libsas.h                     |  2 +-
 include/scsi/scsi_host.h                  |  8 +++---
 76 files changed, 200 insertions(+), 201 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
index 7798f09ad5d1..1bd016aff43e 100644
--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -150,10 +150,10 @@ scsi devices of which only the first 2 respond::
     scsi_scan_host()  -------+
 			    |
 			sdev_prep()
-			slave_configure() -->  scsi_change_queue_depth()
+			sdev_configure() -->  scsi_change_queue_depth()
 			    |
 			sdev_prep()
-			slave_configure()
+			sdev_configure()
 			    |
 			sdev_prep()   ***
 			sdev_destroy() ***
@@ -163,7 +163,7 @@ scsi devices of which only the first 2 respond::
 	respond, a sdev_prep(), sdev_destroy() pair is called.
 
 If the LLD wants to adjust the default queue settings, it can invoke
-scsi_change_queue_depth() in its slave_configure() routine.
+scsi_change_queue_depth() in its sdev_configure() routine.
 
 When an HBA is being removed it could be as part of an orderly shutdown
 associated with the LLD module being unloaded (e.g. with the "rmmod"
@@ -203,7 +203,7 @@ An LLD can use this sequence to make the mid level aware of a SCSI device::
     scsi_add_device()  ------+
 			    |
 			sdev_prep()
-			slave_configure()   [--> scsi_change_queue_depth()]
+			sdev_configure()   [--> scsi_change_queue_depth()]
 
 In a similar fashion, an LLD may become aware that a SCSI device has been
 removed (unplugged) or the connection to it has been interrupted. Some
@@ -222,7 +222,7 @@ upper layers with this sequence::
 
 It may be useful for an LLD to keep track of struct scsi_device instances
 (a pointer is passed as the parameter to sdev_prep() and
-slave_configure() callbacks). Such instances are "owned" by the mid-level.
+sdev_configure() callbacks). Such instances are "owned" by the mid-level.
 struct scsi_device instances are freed after sdev_destroy().
 
 
@@ -337,7 +337,7 @@ Details::
     *      bus scan when an HBA is added (i.e. scsi_scan_host()). So it
     *      should only be called if the HBA becomes aware of a new scsi
     *      device (lu) after scsi_scan_host() has completed. If successful
-    *      this call can lead to sdev_prep() and slave_configure() callbacks
+    *      this call can lead to sdev_prep() and sdev_configure() callbacks
     *      into the LLD.
     *
     *      Defined in: drivers/scsi/scsi_scan.c
@@ -380,7 +380,7 @@ Details::
     *      Might block: no
     *
     *      Notes: Can be invoked any time on a SCSI device controlled by this
-    *      LLD. [Specifically during and after slave_configure() and prior to
+    *      LLD. [Specifically during and after sdev_configure() and prior to
     *      sdev_destroy().] Can safely be invoked from interrupt code.
     *
     *      Defined in: drivers/scsi/scsi.c [see source code for more notes]
@@ -633,14 +633,14 @@ Interface functions are supplied (defined) by LLDs and their function
 pointers are placed in an instance of struct scsi_host_template which
 is passed to scsi_host_alloc() [or scsi_register() / init_this_scsi_driver()].
 Some are mandatory. Interface functions should be declared static. The
-accepted convention is that driver "xyz" will declare its slave_configure()
+accepted convention is that driver "xyz" will declare its sdev_configure()
 function as::
 
-    static int xyz_slave_configure(struct scsi_device * sdev);
+    static int xyz_sdev_configure(struct scsi_device * sdev);
 
 and so forth for all interface functions listed below.
 
-A pointer to this function should be placed in the 'slave_configure' member
+A pointer to this function should be placed in the 'sdev_configure' member
 of a "struct scsi_host_template" instance. A pointer to such an instance
 should be passed to the mid level's scsi_host_alloc() [or scsi_register() /
 init_this_scsi_driver()].
@@ -664,7 +664,7 @@ Summary:
   - proc_info - supports /proc/scsi/{driver_name}/{host_no}
   - queuecommand - queue scsi command, invoke 'done' on completion
   - sdev_prep - prior to any commands being sent to a new device
-  - slave_configure - driver fine tuning for given device after attach
+  - sdev_configure - driver fine tuning for given device after attach
   - sdev_destroy - given device is about to be shut down
 
 
@@ -981,7 +981,7 @@ Details::
     *      prior to its initial scan. The corresponding scsi device may not
     *      exist but the mid level is just about to scan for it (i.e. send
     *      and INQUIRY command plus ...). If a device is found then
-    *      slave_configure() will be called while if a device is not found
+    *      sdev_configure() will be called while if a device is not found
     *      sdev_destroy() is called.
     *      For more details see the include/scsi/scsi_host.h file.
     *
@@ -991,7 +991,7 @@ Details::
 
 
     /**
-    *      slave_configure - driver fine tuning for given device just after it
+    *      sdev_configure - driver fine tuning for given device just after it
     *                     has been first scanned (i.e. it responded to an
     *                     INQUIRY)
     *      @sdp: device that has just been attached
@@ -1010,7 +1010,7 @@ Details::
     *
     *      Optionally defined in: LLD
     **/
-	int slave_configure(struct scsi_device *sdp)
+	int sdev_configure(struct scsi_device *sdp)
 
 
     /**
@@ -1030,7 +1030,7 @@ Details::
     *      commands will be sent for this sdp instance. [However the device
     *      could be re-attached in the future in which case a new instance
     *      of struct scsi_device would be supplied by future sdev_prep()
-    *      and slave_configure() calls.]
+    *      and sdev_configure() calls.]
     *
     *      Optionally defined in: LLD
     **/
diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index c16423e44525..68ca4de85bbc 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1210,7 +1210,7 @@ void ata_sas_port_destroy(struct ata_port *ap)
 EXPORT_SYMBOL_GPL(ata_sas_port_destroy);
 
 /**
- *	ata_sas_slave_configure - Default slave_config routine for libata devices
+ *	ata_sas_sdev_configure - Default sdev_config routine for libata devices
  *	@sdev: SCSI device to configure
  *	@ap: ATA port to which SCSI device is attached
  *
@@ -1218,13 +1218,13 @@ EXPORT_SYMBOL_GPL(ata_sas_port_destroy);
  *	Zero.
  */
 
-int ata_sas_slave_configure(struct scsi_device *sdev, struct ata_port *ap)
+int ata_sas_sdev_configure(struct scsi_device *sdev, struct ata_port *ap)
 {
 	ata_scsi_sdev_config(sdev);
 	ata_scsi_dev_config(sdev, ap->link.device);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(ata_sas_slave_configure);
+EXPORT_SYMBOL_GPL(ata_sas_sdev_configure);
 
 /**
  *	ata_sas_queuecmd - Issue SCSI cdb to libata-managed device
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bf075f2e4bd8..f5fe60074a8c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1087,7 +1087,7 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
 }
 
 /**
- *	ata_scsi_slave_config - Set SCSI device attributes
+ *	ata_scsi_sdev_config - Set SCSI device attributes
  *	@sdev: SCSI device to examine
  *
  *	This is called before we actually start reading
@@ -1098,7 +1098,7 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
  *	Defined by SCSI layer.  We don't really care.
  */
 
-int ata_scsi_slave_config(struct scsi_device *sdev)
+int ata_scsi_sdev_config(struct scsi_device *sdev)
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *dev = __ata_scsi_find_dev(ap, sdev);
@@ -1111,7 +1111,7 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
 
 	return rc;
 }
-EXPORT_SYMBOL_GPL(ata_scsi_slave_config);
+EXPORT_SYMBOL_GPL(ata_scsi_sdev_config);
 
 /**
  *	ata_scsi_sdev_destroy - SCSI device is about to be destroyed
diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index e47a28271f5b..09490cf02b37 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -796,7 +796,7 @@ static void pata_macio_reset_hw(struct pata_macio_priv *priv, int resume)
 /* Hook the standard slave config to fixup some HW related alignment
  * restrictions
  */
-static int pata_macio_slave_config(struct scsi_device *sdev)
+static int pata_macio_sdev_config(struct scsi_device *sdev)
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct pata_macio_priv *priv = ap->private_data;
@@ -805,7 +805,7 @@ static int pata_macio_slave_config(struct scsi_device *sdev)
 	int rc;
 
 	/* First call original */
-	rc = ata_scsi_slave_config(sdev);
+	rc = ata_scsi_sdev_config(sdev);
 	if (rc)
 		return rc;
 
@@ -922,7 +922,7 @@ static struct scsi_host_template pata_macio_sht = {
 	 * use 64K minus 256
 	 */
 	.max_segment_size	= MAX_DBDMA_SEG,
-	.slave_configure	= pata_macio_slave_config,
+	.sdev_configure	= pata_macio_sdev_config,
 };
 
 static struct ata_port_operations pata_macio_ops = {
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index eb9dc14e5147..fc3c13439ecb 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -295,7 +295,7 @@ static void nv_nf2_freeze(struct ata_port *ap);
 static void nv_nf2_thaw(struct ata_port *ap);
 static void nv_ck804_freeze(struct ata_port *ap);
 static void nv_ck804_thaw(struct ata_port *ap);
-static int nv_adma_slave_config(struct scsi_device *sdev);
+static int nv_adma_sdev_config(struct scsi_device *sdev);
 static int nv_adma_check_atapi_dma(struct ata_queued_cmd *qc);
 static enum ata_completion_errors nv_adma_qc_prep(struct ata_queued_cmd *qc);
 static unsigned int nv_adma_qc_issue(struct ata_queued_cmd *qc);
@@ -317,7 +317,7 @@ static void nv_adma_tf_read(struct ata_port *ap, struct ata_taskfile *tf);
 static void nv_mcp55_thaw(struct ata_port *ap);
 static void nv_mcp55_freeze(struct ata_port *ap);
 static void nv_swncq_error_handler(struct ata_port *ap);
-static int nv_swncq_slave_config(struct scsi_device *sdev);
+static int nv_swncq_sdev_config(struct scsi_device *sdev);
 static int nv_swncq_port_start(struct ata_port *ap);
 static enum ata_completion_errors nv_swncq_qc_prep(struct ata_queued_cmd *qc);
 static void nv_swncq_fill_sg(struct ata_queued_cmd *qc);
@@ -379,7 +379,7 @@ static struct scsi_host_template nv_adma_sht = {
 	.can_queue		= NV_ADMA_MAX_CPBS,
 	.sg_tablesize		= NV_ADMA_SGTBL_TOTAL_LEN,
 	.dma_boundary		= NV_ADMA_DMA_BOUNDARY,
-	.slave_configure	= nv_adma_slave_config,
+	.sdev_configure	= nv_adma_sdev_config,
 };
 
 static struct scsi_host_template nv_swncq_sht = {
@@ -387,7 +387,7 @@ static struct scsi_host_template nv_swncq_sht = {
 	.can_queue		= ATA_MAX_QUEUE - 1,
 	.sg_tablesize		= LIBATA_MAX_PRD,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
-	.slave_configure	= nv_swncq_slave_config,
+	.sdev_configure	= nv_swncq_sdev_config,
 };
 
 /*
@@ -654,7 +654,7 @@ static void nv_adma_mode(struct ata_port *ap)
 	pp->flags &= ~NV_ADMA_PORT_REGISTER_MODE;
 }
 
-static int nv_adma_slave_config(struct scsi_device *sdev)
+static int nv_adma_sdev_config(struct scsi_device *sdev)
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct nv_adma_port_priv *pp = ap->private_data;
@@ -666,7 +666,7 @@ static int nv_adma_slave_config(struct scsi_device *sdev)
 	int adma_enable;
 	u32 current_reg, new_reg, config_mask;
 
-	rc = ata_scsi_slave_config(sdev);
+	rc = ata_scsi_sdev_config(sdev);
 
 	if (sdev->id >= ATA_MAX_DEVICES || sdev->channel || sdev->lun)
 		/* Not a proper libata device, ignore */
@@ -1877,7 +1877,7 @@ static void nv_swncq_host_init(struct ata_host *host)
 	writel(~0x0, mmio + NV_INT_STATUS_MCP55);
 }
 
-static int nv_swncq_slave_config(struct scsi_device *sdev)
+static int nv_swncq_sdev_config(struct scsi_device *sdev)
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
@@ -1887,7 +1887,7 @@ static int nv_swncq_slave_config(struct scsi_device *sdev)
 	u8 check_maxtor = 0;
 	unsigned char model_num[ATA_ID_PROD_LEN + 1];
 
-	rc = ata_scsi_slave_config(sdev);
+	rc = ata_scsi_sdev_config(sdev);
 	if (sdev->id >= ATA_MAX_DEVICES || sdev->channel || sdev->lun)
 		/* Not a proper libata device, ignore */
 		return rc;
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 5b1cba288550..9afd65a779b0 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1510,7 +1510,7 @@ static int sbp2_scsi_sdev_prep(struct scsi_device *sdev)
 	return 0;
 }
 
-static int sbp2_scsi_slave_configure(struct scsi_device *sdev)
+static int sbp2_scsi_sdev_configure(struct scsi_device *sdev)
 {
 	struct sbp2_logical_unit *lu = sdev->hostdata;
 
@@ -1589,7 +1589,7 @@ static struct scsi_host_template scsi_driver_template = {
 	.proc_name		= "sbp2",
 	.queuecommand		= sbp2_scsi_queuecommand,
 	.sdev_prep		= sbp2_scsi_sdev_prep,
-	.slave_configure	= sbp2_scsi_slave_configure,
+	.sdev_configure	= sbp2_scsi_sdev_configure,
 	.eh_abort_handler	= sbp2_scsi_abort,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index d8fcd21ab472..c90561edba5a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2876,7 +2876,7 @@ static int srp_target_alloc(struct scsi_target *starget)
 	return 0;
 }
 
-static int srp_slave_configure(struct scsi_device *sdev)
+static int srp_sdev_configure(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
 	struct srp_target_port *target = host_to_target(shost);
@@ -3078,7 +3078,7 @@ static struct scsi_host_template srp_template = {
 	.name				= "InfiniBand SRP initiator",
 	.proc_name			= DRV_NAME,
 	.target_alloc			= srp_target_alloc,
-	.slave_configure		= srp_slave_configure,
+	.sdev_configure		= srp_sdev_configure,
 	.info				= srp_target_info,
 	.queuecommand			= srp_queuecommand,
 	.change_queue_depth             = srp_change_queue_depth,
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 5c7556844a76..0a16f1fb1405 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -114,7 +114,7 @@ static struct scsi_host_template mptfc_driver_template = {
 	.queuecommand			= mptfc_qcmd,
 	.target_alloc			= mptfc_target_alloc,
 	.sdev_prep			= mptfc_sdev_prep,
-	.slave_configure		= mptscsih_slave_configure,
+	.sdev_configure		= mptscsih_sdev_configure,
 	.target_destroy			= mptfc_target_destroy,
 	.sdev_destroy			= mptscsih_sdev_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index c393e2ee8373..855366716161 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1682,7 +1682,7 @@ mptsas_firmware_event_work(struct work_struct *work)
 
 
 static int
-mptsas_slave_configure(struct scsi_device *sdev)
+mptsas_sdev_configure(struct scsi_device *sdev)
 {
 	struct Scsi_Host	*host = sdev->host;
 	MPT_SCSI_HOST	*hd = shost_priv(host);
@@ -1708,7 +1708,7 @@ mptsas_slave_configure(struct scsi_device *sdev)
 	mptsas_add_device_component_starget(ioc, scsi_target(sdev));
 
  out:
-	return mptscsih_slave_configure(sdev);
+	return mptscsih_sdev_configure(sdev);
 }
 
 static int
@@ -1978,7 +1978,7 @@ static struct scsi_host_template mptsas_driver_template = {
 	.queuecommand			= mptsas_qcmd,
 	.target_alloc			= mptsas_target_alloc,
 	.sdev_prep			= mptsas_sdev_prep,
-	.slave_configure		= mptsas_slave_configure,
+	.sdev_configure		= mptsas_sdev_configure,
 	.target_destroy			= mptsas_target_destroy,
 	.sdev_destroy			= mptscsih_sdev_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index e7d78e73b236..f2ebef5c9149 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2346,7 +2346,7 @@ mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
  *	Return non-zero if fails.
  */
 int
-mptscsih_slave_configure(struct scsi_device *sdev)
+mptscsih_sdev_configure(struct scsi_device *sdev)
 {
 	struct Scsi_Host	*sh = sdev->host;
 	VirtTarget		*vtarget;
@@ -3244,7 +3244,7 @@ EXPORT_SYMBOL(mptscsih_show_info);
 EXPORT_SYMBOL(mptscsih_info);
 EXPORT_SYMBOL(mptscsih_qcmd);
 EXPORT_SYMBOL(mptscsih_sdev_destroy);
-EXPORT_SYMBOL(mptscsih_slave_configure);
+EXPORT_SYMBOL(mptscsih_sdev_configure);
 EXPORT_SYMBOL(mptscsih_abort);
 EXPORT_SYMBOL(mptscsih_dev_reset);
 EXPORT_SYMBOL(mptscsih_bus_reset);
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 09bab23a9abb..f6c26a71f948 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -117,7 +117,7 @@ extern int mptscsih_qcmd(struct scsi_cmnd *SCpnt);
 extern int mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel,
 	u8 id, u64 lun, int ctx2abort, ulong timeout);
 extern void mptscsih_sdev_destroy(struct scsi_device *device);
-extern int mptscsih_slave_configure(struct scsi_device *device);
+extern int mptscsih_sdev_configure(struct scsi_device *device);
 extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
 extern int mptscsih_dev_reset(struct scsi_cmnd * SCpnt);
 extern int mptscsih_bus_reset(struct scsi_cmnd * SCpnt);
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index ec8a5396661d..afe2dc4603d1 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -746,7 +746,7 @@ static int mptspi_sdev_prep(struct scsi_device *sdev)
 	return 0;
 }
 
-static int mptspi_slave_configure(struct scsi_device *sdev)
+static int mptspi_sdev_configure(struct scsi_device *sdev)
 {
 	struct _MPT_SCSI_HOST *hd = shost_priv(sdev->host);
 	VirtTarget *vtarget = scsi_target(sdev)->hostdata;
@@ -754,7 +754,7 @@ static int mptspi_slave_configure(struct scsi_device *sdev)
 
 	mptspi_initTarget(hd, vtarget, sdev);
 
-	ret = mptscsih_slave_configure(sdev);
+	ret = mptscsih_sdev_configure(sdev);
 
 	if (ret)
 		return ret;
@@ -829,7 +829,7 @@ static struct scsi_host_template mptspi_driver_template = {
 	.queuecommand			= mptspi_qcmd,
 	.target_alloc			= mptspi_target_alloc,
 	.sdev_prep			= mptspi_sdev_prep,
-	.slave_configure		= mptspi_slave_configure,
+	.sdev_configure		= mptspi_sdev_configure,
 	.target_destroy			= mptspi_target_destroy,
 	.sdev_destroy			= mptspi_sdev_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 1f95c38738e3..67bd30d4f4cc 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -49,7 +49,7 @@ static void zfcp_scsi_sdev_destroy(struct scsi_device *sdev)
 	put_device(&zfcp_sdev->port->dev);
 }
 
-static int zfcp_scsi_slave_configure(struct scsi_device *sdp)
+static int zfcp_scsi_sdev_configure(struct scsi_device *sdp)
 {
 	if (sdp->tagged_supported)
 		scsi_change_queue_depth(sdp, default_depth);
@@ -428,7 +428,7 @@ static struct scsi_host_template zfcp_scsi_host_template = {
 	.eh_target_reset_handler = zfcp_scsi_eh_target_reset_handler,
 	.eh_host_reset_handler	 = zfcp_scsi_eh_host_reset_handler,
 	.sdev_prep		 = zfcp_scsi_sdev_prep,
-	.slave_configure	 = zfcp_scsi_slave_configure,
+	.sdev_configure	 = zfcp_scsi_sdev_configure,
 	.sdev_destroy		 = zfcp_scsi_sdev_destroy,
 	.change_queue_depth	 = scsi_change_queue_depth,
 	.host_reset		 = zfcp_scsi_sysfs_host_reset,
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 3337b1e80412..d96af97a6416 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1976,13 +1976,13 @@ static char *twa_string_lookup(twa_message_type *table, unsigned int code)
 } /* End twa_string_lookup() */
 
 /* This function gets called when a disk is coming on-line */
-static int twa_slave_configure(struct scsi_device *sdev)
+static int twa_sdev_configure(struct scsi_device *sdev)
 {
 	/* Force 60 second timeout */
 	blk_queue_rq_timeout(sdev->request_queue, 60 * HZ);
 
 	return 0;
-} /* End twa_slave_configure() */
+} /* End twa_sdev_configure() */
 
 /* scsi_host_template initializer */
 static struct scsi_host_template driver_template = {
@@ -1993,7 +1993,7 @@ static struct scsi_host_template driver_template = {
 	.bios_param		= twa_scsi_biosparam,
 	.change_queue_depth	= scsi_change_queue_depth,
 	.can_queue		= TW_Q_LENGTH-2,
-	.slave_configure	= twa_slave_configure,
+	.sdev_configure	= twa_sdev_configure,
 	.this_id		= -1,
 	.sg_tablesize		= TW_APACHE_MAX_SGL_LENGTH,
 	.max_sectors		= TW_MAX_SECTORS,
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index dda6fa857709..866bcdef6253 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1529,13 +1529,13 @@ static void twl_shutdown(struct pci_dev *pdev)
 } /* End twl_shutdown() */
 
 /* This function configures unit settings when a unit is coming on-line */
-static int twl_slave_configure(struct scsi_device *sdev)
+static int twl_sdev_configure(struct scsi_device *sdev)
 {
 	/* Force 60 second timeout */
 	blk_queue_rq_timeout(sdev->request_queue, 60 * HZ);
 
 	return 0;
-} /* End twl_slave_configure() */
+} /* End twl_sdev_configure() */
 
 /* scsi_host_template initializer */
 static struct scsi_host_template driver_template = {
@@ -1546,7 +1546,7 @@ static struct scsi_host_template driver_template = {
 	.bios_param		= twl_scsi_biosparam,
 	.change_queue_depth	= scsi_change_queue_depth,
 	.can_queue		= TW_Q_LENGTH-2,
-	.slave_configure	= twl_slave_configure,
+	.sdev_configure	= twl_sdev_configure,
 	.this_id		= -1,
 	.sg_tablesize		= TW_LIBERATOR_MAX_SGL_LENGTH,
 	.max_sectors		= TW_MAX_SECTORS,
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index fb6444d0409c..2a98ef686ff4 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -172,7 +172,7 @@
                  Initialize queues correctly when loading with no valid units.
    1.02.00.034 - Fix tw_decode_bits() to handle multiple errors.
                  Add support for user configurable cmd_per_lun.
-                 Add support for sht->slave_configure().
+                 Add support for sht->sdev_configure().
    1.02.00.035 - Improve tw_allocate_memory() memory allocation.
                  Fix tw_chrdev_ioctl() to sleep correctly.
    1.02.00.036 - Increase character ioctl timeout to 60 seconds.
@@ -2224,13 +2224,13 @@ static void tw_shutdown(struct pci_dev *pdev)
 } /* End tw_shutdown() */
 
 /* This function gets called when a disk is coming online */
-static int tw_slave_configure(struct scsi_device *sdev)
+static int tw_sdev_configure(struct scsi_device *sdev)
 {
 	/* Force 60 second timeout */
 	blk_queue_rq_timeout(sdev->request_queue, 60 * HZ);
 
 	return 0;
-} /* End tw_slave_configure() */
+} /* End tw_sdev_configure() */
 
 static struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
@@ -2240,7 +2240,7 @@ static struct scsi_host_template driver_template = {
 	.bios_param		= tw_scsi_biosparam,
 	.change_queue_depth	= scsi_change_queue_depth,
 	.can_queue		= TW_Q_LENGTH-2,
-	.slave_configure	= tw_slave_configure,
+	.sdev_configure	= tw_sdev_configure,
 	.this_id		= -1,
 	.sg_tablesize		= TW_MAX_SGL_LENGTH,
 	.max_sectors		= TW_MAX_SECTORS,
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 95c71fba16a2..cdb7acbca8ce 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -160,7 +160,7 @@ STATIC int NCR_700_host_reset(struct scsi_cmnd * SCpnt);
 STATIC void NCR_700_chip_setup(struct Scsi_Host *host);
 STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
 STATIC int NCR_700_sdev_prep(struct scsi_device *SDpnt);
-STATIC int NCR_700_slave_configure(struct scsi_device *SDpnt);
+STATIC int NCR_700_sdev_configure(struct scsi_device *SDpnt);
 STATIC void NCR_700_sdev_destroy(struct scsi_device *SDpnt);
 static int NCR_700_change_queue_depth(struct scsi_device *SDpnt, int depth);
 
@@ -306,7 +306,7 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	tpnt->can_queue = NCR_700_COMMAND_SLOTS_PER_HOST;
 	tpnt->sg_tablesize = NCR_700_SG_SEGMENTS;
 	tpnt->cmd_per_lun = NCR_700_CMD_PER_LUN;
-	tpnt->slave_configure = NCR_700_slave_configure;
+	tpnt->sdev_configure = NCR_700_sdev_configure;
 	tpnt->sdev_destroy = NCR_700_sdev_destroy;
 	tpnt->sdev_prep = NCR_700_sdev_prep;
 	tpnt->change_queue_depth = NCR_700_change_queue_depth;
@@ -2018,7 +2018,7 @@ NCR_700_sdev_prep(struct scsi_device *SDp)
 }
 
 STATIC int
-NCR_700_slave_configure(struct scsi_device *SDp)
+NCR_700_sdev_configure(struct scsi_device *SDp)
 {
 	struct NCR_700_Host_Parameters *hostdata = 
 		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index bb49d83cadc7..45152740c80e 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2304,14 +2304,14 @@ static void __init blogic_inithoststruct(struct blogic_adapter *adapter,
 }
 
 /*
-  blogic_slaveconfig will actually set the queue depth on individual
+  blogic_sdev_config will actually set the queue depth on individual
   scsi devices as they are permanently added to the device chain.  We
   shamelessly rip off the SelectQueueDepths code to make this work mostly
   like it used to.  Since we don't get called once at the end of the scan
   but instead get called for each device, we have to do things a bit
   differently.
 */
-static int blogic_slaveconfig(struct scsi_device *dev)
+static int blogic_sdev_config(struct scsi_device *dev)
 {
 	struct blogic_adapter *adapter =
 		(struct blogic_adapter *) dev->host->hostdata;
@@ -3845,7 +3845,7 @@ static struct scsi_host_template blogic_template = {
 	.name = "BusLogic",
 	.info = blogic_drvr_info,
 	.queuecommand = blogic_qcmd,
-	.slave_configure = blogic_slaveconfig,
+	.sdev_configure = blogic_sdev_config,
 	.bios_param = blogic_diskparam,
 	.eh_host_reset_handler = blogic_hostreset,
 #if 0
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index 6182cc8a0344..4f1f05da2031 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -1285,7 +1285,6 @@ static inline void blogic_incszbucket(unsigned int *cmdsz_buckets,
 static const char *blogic_drvr_info(struct Scsi_Host *);
 static int blogic_qcmd(struct Scsi_Host *h, struct scsi_cmnd *);
 static int blogic_diskparam(struct scsi_device *, struct block_device *, sector_t, int *);
-static int blogic_slaveconfig(struct scsi_device *);
 static void blogic_qcompleted_ccb(struct blogic_ccb *);
 static irqreturn_t blogic_inthandler(int, void *);
 static int blogic_resetadapter(struct blogic_adapter *, bool hard_reset);
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index a308e86a97f1..f0d2dffb5bea 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -378,7 +378,7 @@ static int aac_biosparm(struct scsi_device *sdev, struct block_device *bdev,
 }
 
 /**
- *	aac_slave_configure		-	compute queue depths
+ *	aac_sdev_configure		-	compute queue depths
  *	@sdev:	SCSI device we are considering
  *
  *	Selects queue depths for each target device based on the host adapter's
@@ -386,7 +386,7 @@ static int aac_biosparm(struct scsi_device *sdev, struct block_device *bdev,
  *	A queue depth of one automatically disables tagged queueing.
  */
 
-static int aac_slave_configure(struct scsi_device *sdev)
+static int aac_sdev_configure(struct scsi_device *sdev)
 {
 	struct aac_dev *aac = (struct aac_dev *)sdev->host->hostdata;
 	int chn, tid;
@@ -1541,7 +1541,7 @@ static struct scsi_host_template aac_driver_template = {
 	.queuecommand			= aac_queuecommand,
 	.bios_param			= aac_biosparm,
 	.shost_attrs			= aac_attrs,
-	.slave_configure		= aac_slave_configure,
+	.sdev_configure		= aac_sdev_configure,
 	.change_queue_depth		= aac_change_queue_depth,
 	.sdev_attrs			= aac_dev_attrs,
 	.eh_abort_handler		= aac_eh_abort,
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index c2c7850ff7b4..6846bbf109aa 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -4545,7 +4545,7 @@ static int AdvInitAsc3550Driver(ADV_DVC_VAR *asc_dvc)
 
 	/*
 	 * Microcode operating variables for WDTR, SDTR, and command tag
-	 * queuing will be set in slave_configure() based on what a
+	 * queuing will be set in sdev_configure() based on what a
 	 * device reports it is capable of in Inquiry byte 7.
 	 *
 	 * If SCSI Bus Resets have been disabled, then directly set
@@ -5062,7 +5062,7 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *asc_dvc)
 
 	/*
 	 * Microcode operating variables for WDTR, SDTR, and command tag
-	 * queuing will be set in slave_configure() based on what a
+	 * queuing will be set in sdev_configure() based on what a
 	 * device reports it is capable of in Inquiry byte 7.
 	 *
 	 * If SCSI Bus Resets have been disabled, then directly set
@@ -5557,7 +5557,7 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
 
 	/*
 	 * Microcode operating variables for WDTR, SDTR, and command tag
-	 * queuing will be set in slave_configure() based on what a
+	 * queuing will be set in sdev_configure() based on what a
 	 * device reports it is capable of in Inquiry byte 7.
 	 *
 	 * If SCSI Bus Resets have been disabled, then directly set
@@ -7305,7 +7305,7 @@ static void AscAsyncFix(ASC_DVC_VAR *asc_dvc, struct scsi_device *sdev)
 }
 
 static void
-advansys_narrow_slave_configure(struct scsi_device *sdev, ASC_DVC_VAR *asc_dvc)
+advansys_narrow_sdev_configure(struct scsi_device *sdev, ASC_DVC_VAR *asc_dvc)
 {
 	ASC_SCSI_BIT_ID_TYPE tid_bit = 1 << sdev->id;
 	ASC_SCSI_BIT_ID_TYPE orig_use_tagged_qng = asc_dvc->use_tagged_qng;
@@ -7431,7 +7431,7 @@ static void advansys_wide_enable_ppr(ADV_DVC_VAR *adv_dvc,
 }
 
 static void
-advansys_wide_slave_configure(struct scsi_device *sdev, ADV_DVC_VAR *adv_dvc)
+advansys_wide_sdev_configure(struct scsi_device *sdev, ADV_DVC_VAR *adv_dvc)
 {
 	AdvPortAddr iop_base = adv_dvc->iop_base;
 	unsigned short tidmask = 1 << sdev->id;
@@ -7477,15 +7477,15 @@ advansys_wide_slave_configure(struct scsi_device *sdev, ADV_DVC_VAR *adv_dvc)
  * Set the number of commands to queue per device for the
  * specified host adapter.
  */
-static int advansys_slave_configure(struct scsi_device *sdev)
+static int advansys_sdev_configure(struct scsi_device *sdev)
 {
 	struct asc_board *boardp = shost_priv(sdev->host);
 
 	if (ASC_NARROW_BOARD(boardp))
-		advansys_narrow_slave_configure(sdev,
+		advansys_narrow_sdev_configure(sdev,
 						&boardp->dvc_var.asc_dvc_var);
 	else
-		advansys_wide_slave_configure(sdev,
+		advansys_wide_sdev_configure(sdev,
 						&boardp->dvc_var.adv_dvc_var);
 
 	return 0;
@@ -10797,7 +10797,7 @@ static struct scsi_host_template advansys_template = {
 	.queuecommand = advansys_queuecommand,
 	.eh_host_reset_handler = advansys_reset,
 	.bios_param = advansys_biosparam,
-	.slave_configure = advansys_slave_configure,
+	.sdev_configure = advansys_sdev_configure,
 	/*
 	 * Because the driver may control an ISA adapter 'unchecked_isa_dma'
 	 * must be set. The flag will be cleared in advansys_board_found
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 5f41d1ec10ee..2dcfdf256ac1 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -698,7 +698,7 @@ ahd_linux_sdev_prep(struct scsi_device *sdev)
 }
 
 static int
-ahd_linux_slave_configure(struct scsi_device *sdev)
+ahd_linux_sdev_configure(struct scsi_device *sdev)
 {
 	struct	ahd_softc *ahd;
 
@@ -914,7 +914,7 @@ struct scsi_host_template aic79xx_driver_template = {
 	.max_sectors		= 8192,
 	.cmd_per_lun		= 2,
 	.sdev_prep		= ahd_linux_sdev_prep,
-	.slave_configure	= ahd_linux_slave_configure,
+	.sdev_configure	= ahd_linux_sdev_configure,
 	.target_alloc		= ahd_linux_target_alloc,
 	.target_destroy		= ahd_linux_target_destroy,
 };
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 4350a941e060..0690dd67b5d5 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -669,7 +669,7 @@ ahc_linux_sdev_prep(struct scsi_device *sdev)
 }
 
 static int
-ahc_linux_slave_configure(struct scsi_device *sdev)
+ahc_linux_sdev_configure(struct scsi_device *sdev)
 {
 	struct	ahc_softc *ahc;
 
@@ -801,7 +801,7 @@ struct scsi_host_template aic7xxx_driver_template = {
 	.max_sectors		= 8192,
 	.cmd_per_lun		= 2,
 	.sdev_prep		= ahc_linux_sdev_prep,
-	.slave_configure	= ahc_linux_slave_configure,
+	.sdev_configure	= ahc_linux_sdev_configure,
 	.target_alloc		= ahc_linux_target_alloc,
 	.target_destroy		= ahc_linux_target_destroy,
 };
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index bef47f38dd0d..18163b13e954 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -42,7 +42,7 @@ static struct scsi_host_template aic94xx_sht = {
 	.queuecommand		= sas_queuecommand,
 	.dma_need_drain		= ata_scsi_dma_need_drain,
 	.target_alloc		= sas_target_alloc,
-	.slave_configure	= sas_slave_configure,
+	.sdev_configure	= sas_sdev_configure,
 	.scan_finished		= asd_scan_finished,
 	.scan_start		= asd_scan_start,
 	.change_queue_depth	= sas_change_queue_depth,
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index d93524ab1a47..32e36e69dc0b 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -786,7 +786,7 @@ bfad_thread_workq(struct bfad_s *bfad)
  * Return non-zero if fails.
  */
 static int
-bfad_im_slave_configure(struct scsi_device *sdev)
+bfad_im_sdev_configure(struct scsi_device *sdev)
 {
 	scsi_change_queue_depth(sdev, bfa_lun_queue_depth);
 	return 0;
@@ -803,7 +803,7 @@ struct scsi_host_template bfad_im_scsi_host_template = {
 	.eh_target_reset_handler = bfad_im_reset_target_handler,
 
 	.sdev_prep = bfad_im_sdev_prep,
-	.slave_configure = bfad_im_slave_configure,
+	.sdev_configure = bfad_im_sdev_configure,
 	.sdev_destroy = bfad_im_sdev_destroy,
 
 	.this_id = -1,
@@ -825,7 +825,7 @@ struct scsi_host_template bfad_im_vport_template = {
 	.eh_target_reset_handler = bfad_im_reset_target_handler,
 
 	.sdev_prep = bfad_im_sdev_prep,
-	.slave_configure = bfad_im_slave_configure,
+	.sdev_configure = bfad_im_sdev_configure,
 	.sdev_destroy = bfad_im_sdev_destroy,
 
 	.this_id = -1,
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 97b022a324fb..4847edd7552a 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2670,7 +2670,7 @@ static int bnx2fc_cpu_offline(unsigned int cpu)
 	return 0;
 }
 
-static int bnx2fc_slave_configure(struct scsi_device *sdev)
+static int bnx2fc_sdev_configure(struct scsi_device *sdev)
 {
 	if (!bnx2fc_queue_depth)
 		return 0;
@@ -2976,7 +2976,7 @@ static struct scsi_host_template bnx2fc_shost_template = {
 	.dma_boundary           = 0x7fff,
 	.max_sectors		= 0x3fbf,
 	.track_queue_depth	= 1,
-	.slave_configure	= bnx2fc_slave_configure,
+	.sdev_configure	= bnx2fc_sdev_configure,
 	.shost_attrs		= bnx2fc_host_attrs,
 };
 
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index cd53c2ed31fb..00c38c9f9619 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2232,7 +2232,7 @@ csio_sdev_prep(struct scsi_device *sdev)
 }
 
 static int
-csio_slave_configure(struct scsi_device *sdev)
+csio_sdev_configure(struct scsi_device *sdev)
 {
 	scsi_change_queue_depth(sdev, csio_lun_qdepth);
 	return 0;
@@ -2271,7 +2271,7 @@ struct scsi_host_template csio_fcoe_shost_template = {
 	.eh_abort_handler	= csio_eh_abort_handler,
 	.eh_device_reset_handler = csio_eh_lun_reset_handler,
 	.sdev_prep		= csio_sdev_prep,
-	.slave_configure	= csio_slave_configure,
+	.sdev_configure	= csio_sdev_configure,
 	.sdev_destroy		= csio_sdev_destroy,
 	.scan_finished		= csio_scan_finished,
 	.this_id		= -1,
@@ -2290,7 +2290,7 @@ struct scsi_host_template csio_fcoe_shost_vport_template = {
 	.eh_abort_handler	= csio_eh_abort_handler,
 	.eh_device_reset_handler = csio_eh_lun_reset_handler,
 	.sdev_prep		= csio_sdev_prep,
-	.slave_configure	= csio_slave_configure,
+	.sdev_configure	= csio_sdev_configure,
 	.sdev_destroy		= csio_sdev_destroy,
 	.scan_finished		= csio_scan_finished,
 	.this_id		= -1,
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 0497ef6a9453..0342524c5aa5 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -405,7 +405,7 @@ static void adpt_inquiry(adpt_hba* pHba)
 }
 
 
-static int adpt_slave_configure(struct scsi_device * device)
+static int adpt_sdev_configure(struct scsi_device * device)
 {
 	struct Scsi_Host *host = device->host;
 	adpt_hba* pHba;
@@ -3507,7 +3507,7 @@ static struct scsi_host_template driver_template = {
 	.eh_bus_reset_handler	= adpt_bus_reset,
 	.eh_host_reset_handler	= adpt_reset,
 	.bios_param		= adpt_bios_param,
-	.slave_configure	= adpt_slave_configure,
+	.sdev_configure	= adpt_sdev_configure,
 	.can_queue		= MAX_TO_IOP_MESSAGES,
 	.this_id		= 7,
 };
diff --git a/drivers/scsi/dpti.h b/drivers/scsi/dpti.h
index 8a079e8d7f65..f91e0d1ff9f6 100644
--- a/drivers/scsi/dpti.h
+++ b/drivers/scsi/dpti.h
@@ -29,7 +29,7 @@ static int adpt_detect(struct scsi_host_template * sht);
 static int adpt_queue(struct Scsi_Host *h, struct scsi_cmnd * cmd);
 static int adpt_abort(struct scsi_cmnd * cmd);
 static int adpt_reset(struct scsi_cmnd* cmd);
-static int adpt_slave_configure(struct scsi_device *);
+static int adpt_sdev_configure(struct scsi_device *);
 
 static const char *adpt_info(struct Scsi_Host *pSHost);
 static int adpt_bios_param(struct scsi_device * sdev, struct block_device *dev,
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 70390b43fd9e..14c8b9cf2a69 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2272,7 +2272,7 @@ static void esp_init_swstate(struct esp *esp)
 	INIT_LIST_HEAD(&esp->active_cmds);
 	INIT_LIST_HEAD(&esp->esp_cmd_pool);
 
-	/* Start with a clear state, domain validation (via ->slave_configure,
+	/* Start with a clear state, domain validation (via ->sdev_configure,
 	 * spi_dv_device()) will attempt to enable SYNC, WIDE, and tagged
 	 * commands.
 	 */
@@ -2474,7 +2474,7 @@ static int esp_sdev_prep(struct scsi_device *dev)
 	return 0;
 }
 
-static int esp_slave_configure(struct scsi_device *dev)
+static int esp_sdev_configure(struct scsi_device *dev)
 {
 	struct esp *esp = shost_priv(dev->host);
 	struct esp_target_data *tp = &esp->target[dev->id];
@@ -2679,7 +2679,7 @@ struct scsi_host_template scsi_esp_template = {
 	.target_alloc		= esp_target_alloc,
 	.target_destroy		= esp_target_destroy,
 	.sdev_prep		= esp_sdev_prep,
-	.slave_configure	= esp_slave_configure,
+	.sdev_configure	= esp_sdev_configure,
 	.sdev_destroy		= esp_sdev_destroy,
 	.eh_abort_handler	= esp_eh_abort_handler,
 	.eh_bus_reset_handler	= esp_eh_bus_reset_handler,
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 7f150d52b4a6..0e58f0636ba2 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4061,7 +4061,7 @@ static void gdth_flush(gdth_ha_str *ha)
 }
 
 /* configure lun */
-static int gdth_slave_configure(struct scsi_device *sdev)
+static int gdth_sdev_configure(struct scsi_device *sdev)
 {
     sdev->skip_ms_page_3f = 1;
     sdev->skip_ms_page_8 = 1;
@@ -4073,7 +4073,7 @@ static struct scsi_host_template gdth_template = {
         .info                   = gdth_info, 
         .queuecommand           = gdth_queuecommand,
         .eh_bus_reset_handler   = gdth_eh_bus_reset,
-        .slave_configure        = gdth_slave_configure,
+        .sdev_configure        = gdth_sdev_configure,
         .bios_param             = gdth_bios_param,
         .show_info              = gdth_show_info,
         .write_info             = gdth_set_info,
diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 2bdd64648ef0..b3622e39c594 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -614,7 +614,7 @@ extern int hisi_sas_probe(struct platform_device *pdev,
 			  const struct hisi_sas_hw *ops);
 extern int hisi_sas_remove(struct platform_device *pdev);
 
-extern int hisi_sas_slave_configure(struct scsi_device *sdev);
+extern int hisi_sas_sdev_configure(struct scsi_device *sdev);
 extern int hisi_sas_scan_finished(struct Scsi_Host *shost, unsigned long time);
 extern void hisi_sas_scan_start(struct Scsi_Host *shost);
 extern int hisi_sas_host_reset(struct Scsi_Host *shost, int reset_type);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 11caa4b0d797..1468649c48d4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -807,10 +807,10 @@ static int hisi_sas_dev_found(struct domain_device *device)
 	return rc;
 }
 
-int hisi_sas_slave_configure(struct scsi_device *sdev)
+int hisi_sas_sdev_configure(struct scsi_device *sdev)
 {
 	struct domain_device *dev = sdev_to_domain_dev(sdev);
-	int ret = sas_slave_configure(sdev);
+	int ret = sas_sdev_configure(sdev);
 
 	if (ret)
 		return ret;
@@ -819,7 +819,7 @@ int hisi_sas_slave_configure(struct scsi_device *sdev)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(hisi_sas_slave_configure);
+EXPORT_SYMBOL_GPL(hisi_sas_sdev_configure);
 
 void hisi_sas_scan_start(struct Scsi_Host *shost)
 {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 09a7669dad4c..2a006cd5dc16 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1758,7 +1758,7 @@ static struct scsi_host_template sht_v1_hw = {
 	.queuecommand		= sas_queuecommand,
 	.dma_need_drain		= ata_scsi_dma_need_drain,
 	.target_alloc		= sas_target_alloc,
-	.slave_configure	= hisi_sas_slave_configure,
+	.sdev_configure	= hisi_sas_sdev_configure,
 	.scan_finished		= hisi_sas_scan_finished,
 	.scan_start		= hisi_sas_scan_start,
 	.change_queue_depth	= sas_change_queue_depth,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 968d38702353..fb355d9466fc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3534,7 +3534,7 @@ static struct scsi_host_template sht_v2_hw = {
 	.queuecommand		= sas_queuecommand,
 	.dma_need_drain		= ata_scsi_dma_need_drain,
 	.target_alloc		= sas_target_alloc,
-	.slave_configure	= hisi_sas_slave_configure,
+	.sdev_configure	= hisi_sas_sdev_configure,
 	.scan_finished		= hisi_sas_scan_finished,
 	.scan_start		= hisi_sas_scan_start,
 	.change_queue_depth	= sas_change_queue_depth,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 55e2321a65bc..f393962a3c06 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3077,7 +3077,7 @@ static struct scsi_host_template sht_v3_hw = {
 	.queuecommand		= sas_queuecommand,
 	.dma_need_drain		= ata_scsi_dma_need_drain,
 	.target_alloc		= sas_target_alloc,
-	.slave_configure	= hisi_sas_slave_configure,
+	.sdev_configure	= hisi_sas_sdev_configure,
 	.scan_finished		= hisi_sas_scan_finished,
 	.scan_start		= hisi_sas_scan_start,
 	.change_queue_depth	= sas_change_queue_depth,
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7278f2a01983..d81a366e1b0d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -284,7 +284,7 @@ static int hpsa_change_queue_depth(struct scsi_device *sdev, int qdepth);
 
 static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd);
 static int hpsa_sdev_prep(struct scsi_device *sdev);
-static int hpsa_slave_configure(struct scsi_device *sdev);
+static int hpsa_sdev_configure(struct scsi_device *sdev);
 static void hpsa_sdev_destroy(struct scsi_device *sdev);
 
 static void hpsa_update_scsi_devices(struct ctlr_info *h);
@@ -975,7 +975,7 @@ static struct scsi_host_template hpsa_driver_template = {
 	.eh_device_reset_handler = hpsa_eh_device_reset_handler,
 	.ioctl			= hpsa_ioctl,
 	.sdev_prep		= hpsa_sdev_prep,
-	.slave_configure	= hpsa_slave_configure,
+	.sdev_configure	= hpsa_sdev_configure,
 	.sdev_destroy		= hpsa_sdev_destroy,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= hpsa_compat_ioctl,
@@ -2134,7 +2134,7 @@ static int hpsa_sdev_prep(struct scsi_device *sdev)
 }
 
 /* configure scsi device based on internal per-device structure */
-static int hpsa_slave_configure(struct scsi_device *sdev)
+static int hpsa_sdev_configure(struct scsi_device *sdev)
 {
 	struct hpsa_scsi_dev_t *sd;
 	int queue_depth;
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 6a2561f26e38..9d6396714753 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1157,7 +1157,7 @@ static struct device_attribute *hptiop_attrs[] = {
 	NULL
 };
 
-static int hptiop_slave_config(struct scsi_device *sdev)
+static int hptiop_sdev_config(struct scsi_device *sdev)
 {
 	if (sdev->type == TYPE_TAPE)
 		blk_queue_max_hw_sectors(sdev->request_queue, 8192);
@@ -1174,7 +1174,7 @@ static struct scsi_host_template driver_template = {
 	.emulated                   = 0,
 	.proc_name                  = driver_name,
 	.shost_attrs                = hptiop_attrs,
-	.slave_configure            = hptiop_slave_config,
+	.sdev_configure            = hptiop_sdev_config,
 	.this_id                    = -1,
 	.change_queue_depth         = hptiop_adjust_disk_queue_depth,
 };
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 1038689057f0..c7bb93ecacbd 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2902,7 +2902,7 @@ static int ibmvfc_target_alloc(struct scsi_target *starget)
 }
 
 /**
- * ibmvfc_slave_configure - Configure the device
+ * ibmvfc_sdev_configure - Configure the device
  * @sdev:	struct scsi_device device to configure
  *
  * Enable allow_restart for a device if it is a disk. Adjust the
@@ -2911,7 +2911,7 @@ static int ibmvfc_target_alloc(struct scsi_target *starget)
  * Returns:
  *	0
  **/
-static int ibmvfc_slave_configure(struct scsi_device *sdev)
+static int ibmvfc_sdev_configure(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
 	unsigned long flags = 0;
@@ -3118,7 +3118,7 @@ static struct scsi_host_template driver_template = {
 	.eh_target_reset_handler = ibmvfc_eh_target_reset_handler,
 	.eh_host_reset_handler = ibmvfc_eh_host_reset_handler,
 	.sdev_prep = ibmvfc_sdev_prep,
-	.slave_configure = ibmvfc_slave_configure,
+	.sdev_configure = ibmvfc_sdev_configure,
 	.target_alloc = ibmvfc_target_alloc,
 	.scan_finished = ibmvfc_scan_finished,
 	.change_queue_depth = ibmvfc_change_queue_depth,
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index b1f3017b6547..7e08c1109720 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1843,14 +1843,14 @@ static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
 }
 
 /**
- * ibmvscsi_slave_configure: Set the "allow_restart" flag for each disk.
+ * ibmvscsi_sdev_configure: Set the "allow_restart" flag for each disk.
  * @sdev:	struct scsi_device device to configure
  *
  * Enable allow_restart for a device if it is a disk.  Adjust the
  * queue_depth here also as is required by the documentation for
  * struct scsi_host_template.
  */
-static int ibmvscsi_slave_configure(struct scsi_device *sdev)
+static int ibmvscsi_sdev_configure(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
 	unsigned long lock_flags = 0;
@@ -2073,7 +2073,7 @@ static struct scsi_host_template driver_template = {
 	.eh_abort_handler = ibmvscsi_eh_abort_handler,
 	.eh_device_reset_handler = ibmvscsi_eh_device_reset_handler,
 	.eh_host_reset_handler = ibmvscsi_eh_host_reset_handler,
-	.slave_configure = ibmvscsi_slave_configure,
+	.sdev_configure = ibmvscsi_sdev_configure,
 	.change_queue_depth = ibmvscsi_change_queue_depth,
 	.host_reset = ibmvscsi_host_reset,
 	.cmd_per_lun = IBMVSCSI_CMDS_PER_LUN_DEFAULT,
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 7d783b5e7b6f..175ee8739d9b 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4918,7 +4918,7 @@ static void ipr_sdev_destroy(struct scsi_device *sdev)
 }
 
 /**
- * ipr_slave_configure - Configure a SCSI device
+ * ipr_sdev_configure - Configure a SCSI device
  * @sdev:	scsi device struct
  *
  * This function configures the specified scsi device.
@@ -4926,7 +4926,7 @@ static void ipr_sdev_destroy(struct scsi_device *sdev)
  * Return value:
  * 	0 on success
  **/
-static int ipr_slave_configure(struct scsi_device *sdev)
+static int ipr_sdev_configure(struct scsi_device *sdev)
 {
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) sdev->host->hostdata;
 	struct ipr_resource_entry *res;
@@ -4956,7 +4956,7 @@ static int ipr_slave_configure(struct scsi_device *sdev)
 
 		if (ap) {
 			scsi_change_queue_depth(sdev, IPR_MAX_CMD_PER_ATA_LUN);
-			ata_sas_slave_configure(sdev, ap);
+			ata_sas_sdev_configure(sdev, ap);
 		}
 
 		if (ioa_cfg->sis64)
@@ -6736,7 +6736,7 @@ static struct scsi_host_template driver_template = {
 	.eh_device_reset_handler = ipr_eh_dev_reset,
 	.eh_host_reset_handler = ipr_eh_host_reset,
 	.sdev_prep = ipr_sdev_prep,
-	.slave_configure = ipr_slave_configure,
+	.sdev_configure = ipr_sdev_configure,
 	.sdev_destroy = ipr_sdev_destroy,
 	.scan_finished = ipr_scan_finished,
 	.target_alloc = ipr_target_alloc,
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index f25672982c5f..a998a355b37f 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -360,7 +360,7 @@ static struct scsi_host_template ips_driver_template = {
 	.proc_name		= "ips",
 	.show_info		= ips_show_info,
 	.write_info		= ips_write_info,
-	.slave_configure	= ips_slave_configure,
+	.sdev_configure	= ips_sdev_configure,
 	.bios_param		= ips_biosparam,
 	.this_id		= -1,
 	.sg_tablesize		= IPS_MAX_SG,
@@ -1180,7 +1180,7 @@ static int ips_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 
 /****************************************************************************/
 /*                                                                          */
-/* Routine Name: ips_slave_configure                                        */
+/* Routine Name: ips_sdev_configure                                        */
 /*                                                                          */
 /* Routine Description:                                                     */
 /*                                                                          */
@@ -1188,7 +1188,7 @@ static int ips_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 /*                                                                          */
 /****************************************************************************/
 static int
-ips_slave_configure(struct scsi_device * SDptr)
+ips_sdev_configure(struct scsi_device * SDptr)
 {
 	ips_ha_t *ha;
 	int min;
diff --git a/drivers/scsi/ips.h b/drivers/scsi/ips.h
index 6c0678fb9a67..d69fe0ce5add 100644
--- a/drivers/scsi/ips.h
+++ b/drivers/scsi/ips.h
@@ -400,7 +400,7 @@
     */
    static int ips_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 		sector_t capacity, int geom[]);
-   static int ips_slave_configure(struct scsi_device *SDptr);
+   static int ips_sdev_configure(struct scsi_device *SDptr);
 
 /*
  * Raid Command Formats
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 085e285f427d..7cc880f078b8 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -155,7 +155,7 @@ static struct scsi_host_template isci_sht = {
 	.queuecommand			= sas_queuecommand,
 	.dma_need_drain			= ata_scsi_dma_need_drain,
 	.target_alloc			= sas_target_alloc,
-	.slave_configure		= sas_slave_configure,
+	.sdev_configure		= sas_sdev_configure,
 	.scan_finished			= isci_host_scan_finished,
 	.scan_start			= isci_host_start,
 	.change_queue_depth		= sas_change_queue_depth,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index b5dd1caae5e9..209d151ca1b4 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -955,7 +955,7 @@ static umode_t iscsi_sw_tcp_attr_is_visible(int param_type, int param)
 	return 0;
 }
 
-static int iscsi_sw_tcp_slave_configure(struct scsi_device *sdev)
+static int iscsi_sw_tcp_sdev_configure(struct scsi_device *sdev)
 {
 	struct iscsi_sw_tcp_host *tcp_sw_host = iscsi_host_priv(sdev->host);
 	struct iscsi_session *session = tcp_sw_host->session;
@@ -982,7 +982,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.eh_device_reset_handler= iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_recover_target,
 	.dma_boundary		= PAGE_SIZE - 1,
-	.slave_configure        = iscsi_sw_tcp_slave_configure,
+	.sdev_configure        = iscsi_sw_tcp_sdev_configure,
 	.target_alloc		= iscsi_target_alloc,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 9e0975e55c27..bbcf959d975f 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -835,14 +835,14 @@ int sas_target_alloc(struct scsi_target *starget)
 
 #define SAS_DEF_QD 256
 
-int sas_slave_configure(struct scsi_device *scsi_dev)
+int sas_sdev_configure(struct scsi_device *scsi_dev)
 {
 	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
 
 	BUG_ON(dev->rphy->identify.device_type != SAS_END_DEVICE);
 
 	if (dev_is_sata(dev)) {
-		ata_sas_slave_configure(scsi_dev, dev->sata_dev.ap);
+		ata_sas_sdev_configure(scsi_dev, dev->sata_dev.ap);
 		return 0;
 	}
 
@@ -950,7 +950,7 @@ EXPORT_SYMBOL_GPL(sas_request_addr);
 
 EXPORT_SYMBOL_GPL(sas_queuecommand);
 EXPORT_SYMBOL_GPL(sas_target_alloc);
-EXPORT_SYMBOL_GPL(sas_slave_configure);
+EXPORT_SYMBOL_GPL(sas_sdev_configure);
 EXPORT_SYMBOL_GPL(sas_change_queue_depth);
 EXPORT_SYMBOL_GPL(sas_bios_param);
 EXPORT_SYMBOL_GPL(sas_task_abort);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index aeabcb3b1df7..2ad59a3cc241 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5609,7 +5609,7 @@ lpfc_sdev_prep(struct scsi_device *sdev)
 }
 
 /**
- * lpfc_slave_configure - scsi_host_template slave_configure entry point
+ * lpfc_sdev_configure - scsi_host_template sdev_configure entry point
  * @sdev: Pointer to scsi_device.
  *
  * This routine configures following items
@@ -5620,7 +5620,7 @@ lpfc_sdev_prep(struct scsi_device *sdev)
  *   0 - Success
  **/
 static int
-lpfc_slave_configure(struct scsi_device *sdev)
+lpfc_sdev_configure(struct scsi_device *sdev)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *) sdev->host->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
@@ -6023,7 +6023,7 @@ struct scsi_host_template lpfc_template_nvme = {
 	.eh_bus_reset_handler	= lpfc_no_handler,
 	.eh_host_reset_handler  = lpfc_no_handler,
 	.sdev_prep		= lpfc_no_sdev,
-	.slave_configure	= lpfc_no_sdev,
+	.sdev_configure		= lpfc_no_sdev,
 	.scan_finished		= lpfc_scan_finished,
 	.this_id		= -1,
 	.sg_tablesize		= 1,
@@ -6047,7 +6047,7 @@ struct scsi_host_template lpfc_template = {
 	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
 	.eh_host_reset_handler  = lpfc_host_reset_handler,
 	.sdev_prep		= lpfc_sdev_prep,
-	.slave_configure	= lpfc_slave_configure,
+	.sdev_configure	= lpfc_sdev_configure,
 	.sdev_destroy		= lpfc_sdev_destroy,
 	.scan_finished		= lpfc_scan_finished,
 	.this_id		= -1,
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 0992869bffd4..9dc4637e7bb3 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2031,7 +2031,7 @@ static void megasas_set_static_target_properties(struct scsi_device *sdev,
 }
 
 
-static int megasas_slave_configure(struct scsi_device *sdev)
+static int megasas_sdev_configure(struct scsi_device *sdev)
 {
 	u16 pd_index = 0;
 	struct megasas_instance *instance;
@@ -3413,7 +3413,7 @@ static struct scsi_host_template megasas_template = {
 	.module = THIS_MODULE,
 	.name = "Avago SAS based MegaRAID driver",
 	.proc_name = "megaraid_sas",
-	.slave_configure = megasas_slave_configure,
+	.sdev_configure = megasas_sdev_configure,
 	.sdev_prep = megasas_sdev_prep,
 	.sdev_destroy = megasas_sdev_destroy,
 	.queuecommand = megasas_queue_command,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 674e72ed1398..05eb532f6afe 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2270,14 +2270,14 @@ _scsih_enable_tlr(struct MPT3SAS_ADAPTER *ioc, struct scsi_device *sdev)
 }
 
 /**
- * scsih_slave_configure - device configure routine.
+ * scsih_sdev_configure - device configure routine.
  * @sdev: scsi device struct
  *
  * Return: 0 if ok. Any other return is assumed to be an error and
  * the device is ignored.
  */
 static int
-scsih_slave_configure(struct scsi_device *sdev)
+scsih_sdev_configure(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
@@ -10428,7 +10428,7 @@ static struct scsi_host_template mpt2sas_driver_template = {
 	.queuecommand			= scsih_qcmd,
 	.target_alloc			= scsih_target_alloc,
 	.sdev_prep			= scsih_sdev_prep,
-	.slave_configure		= scsih_slave_configure,
+	.sdev_configure		= scsih_sdev_configure,
 	.target_destroy			= scsih_target_destroy,
 	.sdev_destroy			= scsih_sdev_destroy,
 	.scan_finished			= scsih_scan_finished,
@@ -10466,7 +10466,7 @@ static struct scsi_host_template mpt3sas_driver_template = {
 	.queuecommand			= scsih_qcmd,
 	.target_alloc			= scsih_target_alloc,
 	.sdev_prep			= scsih_sdev_prep,
-	.slave_configure		= scsih_slave_configure,
+	.sdev_configure		= scsih_sdev_configure,
 	.target_destroy			= scsih_target_destroy,
 	.sdev_destroy			= scsih_sdev_destroy,
 	.scan_finished			= scsih_scan_finished,
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index b0de3bdb01db..6686d3d4cc61 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -35,7 +35,7 @@ static struct scsi_host_template mvs_sht = {
 	.queuecommand		= sas_queuecommand,
 	.dma_need_drain		= ata_scsi_dma_need_drain,
 	.target_alloc		= sas_target_alloc,
-	.slave_configure	= sas_slave_configure,
+	.sdev_configure	= sas_sdev_configure,
 	.scan_finished		= mvs_scan_finished,
 	.scan_start		= mvs_scan_start,
 	.change_queue_depth	= sas_change_queue_depth,
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 8906aceda4c4..0f86214eca4a 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2000,7 +2000,7 @@ static struct mvumi_instance_template mvumi_instance_9580 = {
 	.reset_host = mvumi_reset_host_9580,
 };
 
-static int mvumi_slave_configure(struct scsi_device *sdev)
+static int mvumi_sdev_configure(struct scsi_device *sdev)
 {
 	struct mvumi_hba *mhba;
 	unsigned char bitcount = sizeof(unsigned char) * 8;
@@ -2175,7 +2175,7 @@ static struct scsi_host_template mvumi_template = {
 
 	.module = THIS_MODULE,
 	.name = "Marvell Storage Controller",
-	.slave_configure = mvumi_slave_configure,
+	.sdev_configure = mvumi_sdev_configure,
 	.queuecommand = mvumi_queue_command,
 	.eh_timed_out = mvumi_timed_out,
 	.eh_host_reset_handler = mvumi_host_reset,
diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index d2dfec5c4a3a..50f70d3a3d22 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1743,7 +1743,7 @@ static int myrb_sdev_prep(struct scsi_device *sdev)
 	return myrb_pdev_sdev_prep(sdev);
 }
 
-static int myrb_slave_configure(struct scsi_device *sdev)
+static int myrb_sdev_configure(struct scsi_device *sdev)
 {
 	struct myrb_ldev_info *ldev_info;
 
@@ -2233,7 +2233,7 @@ struct scsi_host_template myrb_template = {
 	.queuecommand		= myrb_queuecommand,
 	.eh_host_reset_handler	= myrb_host_reset,
 	.sdev_prep		= myrb_sdev_prep,
-	.slave_configure	= myrb_slave_configure,
+	.sdev_configure	= myrb_sdev_configure,
 	.sdev_destroy		= myrb_sdev_destroy,
 	.bios_param		= myrb_biosparam,
 	.cmd_size		= sizeof(struct myrb_cmdblk),
diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 1b9f6103096d..991ac289f4dc 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1886,7 +1886,7 @@ static int myrs_sdev_prep(struct scsi_device *sdev)
 	return 0;
 }
 
-static int myrs_slave_configure(struct scsi_device *sdev)
+static int myrs_sdev_configure(struct scsi_device *sdev)
 {
 	struct myrs_hba *cs = shost_priv(sdev->host);
 	struct myrs_ldev_info *ldev_info;
@@ -1926,7 +1926,7 @@ struct scsi_host_template myrs_template = {
 	.queuecommand		= myrs_queuecommand,
 	.eh_host_reset_handler	= myrs_host_reset,
 	.sdev_prep		= myrs_sdev_prep,
-	.slave_configure	= myrs_slave_configure,
+	.sdev_configure	= myrs_sdev_configure,
 	.sdev_destroy		= myrs_sdev_destroy,
 	.cmd_size		= sizeof(struct myrs_cmdblk),
 	.shost_attrs		= myrs_shost_attrs,
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index ee727b1511a1..c3a093dfa932 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -7962,7 +7962,7 @@ static int ncr53c8xx_sdev_prep(struct scsi_device *device)
 	return 0;
 }
 
-static int ncr53c8xx_slave_configure(struct scsi_device *device)
+static int ncr53c8xx_sdev_configure(struct scsi_device *device)
 {
 	struct Scsi_Host *host = device->host;
 	struct ncb *np = ((struct host_data *) host->hostdata)->ncb;
@@ -8298,7 +8298,7 @@ struct Scsi_Host * __init ncr_attach(struct scsi_host_template *tpnt,
 		tpnt->shost_attrs = ncr53c8xx_host_attrs;
 
 	tpnt->queuecommand	= ncr53c8xx_queue_command;
-	tpnt->slave_configure	= ncr53c8xx_slave_configure;
+	tpnt->sdev_configure	= ncr53c8xx_sdev_configure;
 	tpnt->sdev_prep	= ncr53c8xx_sdev_prep;
 	tpnt->eh_bus_reset_handler = ncr53c8xx_bus_reset;
 	tpnt->can_queue		= SCSI_NCR_CAN_QUEUE;
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 9e99262a2b9d..debad0464491 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -89,7 +89,7 @@ static struct scsi_host_template pm8001_sht = {
 	.queuecommand		= sas_queuecommand,
 	.dma_need_drain		= ata_scsi_dma_need_drain,
 	.target_alloc		= sas_target_alloc,
-	.slave_configure	= sas_slave_configure,
+	.sdev_configure	= sas_sdev_configure,
 	.scan_finished		= pm8001_scan_finished,
 	.scan_start		= pm8001_scan_start,
 	.change_queue_depth	= sas_change_queue_depth,
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 0cf4c8d894a4..72f308cfd67f 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -195,7 +195,7 @@ static int pmcraid_sdev_prep(struct scsi_device *scsi_dev)
 }
 
 /**
- * pmcraid_slave_configure - Configures a SCSI device
+ * pmcraid_sdev_configure - Configures a SCSI device
  * @scsi_dev: scsi device struct
  *
  * This function is executed by SCSI mid layer just after a device is first
@@ -207,7 +207,7 @@ static int pmcraid_sdev_prep(struct scsi_device *scsi_dev)
  * Return value:
  *	  0 on success
  */
-static int pmcraid_slave_configure(struct scsi_device *scsi_dev)
+static int pmcraid_sdev_configure(struct scsi_device *scsi_dev)
 {
 	struct pmcraid_resource_entry *res = scsi_dev->hostdata;
 
@@ -4121,7 +4121,7 @@ static struct scsi_host_template pmcraid_host_template = {
 	.eh_host_reset_handler = pmcraid_eh_host_reset_handler,
 
 	.sdev_prep = pmcraid_sdev_prep,
-	.slave_configure = pmcraid_slave_configure,
+	.sdev_configure = pmcraid_sdev_configure,
 	.sdev_destroy = pmcraid_sdev_destroy,
 	.change_queue_depth = pmcraid_change_queue_depth,
 	.can_queue = PMCRAID_MAX_IO_CMD,
diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index f75c0b5cd587..728f5d32285d 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -61,7 +61,7 @@ enum lv1_atapi_in_out {
 };
 
 
-static int ps3rom_slave_configure(struct scsi_device *scsi_dev)
+static int ps3rom_sdev_configure(struct scsi_device *scsi_dev)
 {
 	struct ps3rom_private *priv = shost_priv(scsi_dev->host);
 	struct ps3_storage_device *dev = priv->dev;
@@ -330,7 +330,7 @@ static irqreturn_t ps3rom_interrupt(int irq, void *data)
 
 static struct scsi_host_template ps3rom_host_template = {
 	.name =			DEVICE_NAME,
-	.slave_configure =	ps3rom_slave_configure,
+	.sdev_configure =	ps3rom_sdev_configure,
 	.queuecommand =		ps3rom_queuecommand,
 	.can_queue =		1,
 	.this_id =		7,
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 36b1ca2dadbb..8b8fcf82f5e5 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -939,7 +939,7 @@ static int qedf_eh_host_reset(struct scsi_cmnd *sc_cmd)
 	return SUCCESS;
 }
 
-static int qedf_slave_configure(struct scsi_device *sdev)
+static int qedf_sdev_configure(struct scsi_device *sdev)
 {
 	if (qedf_queue_depth) {
 		scsi_change_queue_depth(sdev, qedf_queue_depth);
@@ -960,7 +960,7 @@ static struct scsi_host_template qedf_host_template = {
 	.eh_device_reset_handler = qedf_eh_device_reset, /* lun reset */
 	.eh_target_reset_handler = qedf_eh_target_reset, /* target reset */
 	.eh_host_reset_handler  = qedf_eh_host_reset,
-	.slave_configure	= qedf_slave_configure,
+	.sdev_configure	= qedf_sdev_configure,
 	.dma_boundary = QED_HW_DMA_BOUNDARY,
 	.sg_tablesize = QEDF_MAX_BDS_PER_CMD,
 	.can_queue = FCOE_PARAMS_NUM_TASKS,
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 441a45349349..c3a1c83d661d 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1167,7 +1167,7 @@ qla1280_set_target_parameters(struct scsi_qla_host *ha, int bus, int target)
 
 
 /**************************************************************************
- *   qla1280_slave_configure
+ *   qla1280_sdev_configure
  *
  * Description:
  *   Determines the queue depth for a given device.  There are two ways
@@ -1178,7 +1178,7 @@ qla1280_set_target_parameters(struct scsi_qla_host *ha, int bus, int target)
  *   default queue depth (dependent on the number of hardware SCBs).
  **************************************************************************/
 static int
-qla1280_slave_configure(struct scsi_device *device)
+qla1280_sdev_configure(struct scsi_device *device)
 {
 	struct scsi_qla_host *ha;
 	int default_depth = 3;
@@ -4140,7 +4140,7 @@ static struct scsi_host_template qla1280_driver_template = {
 	.proc_name		= "qla1280",
 	.name			= "Qlogic ISP 1280/12160",
 	.info			= qla1280_info,
-	.slave_configure	= qla1280_slave_configure,
+	.sdev_configure	= qla1280_sdev_configure,
 	.queuecommand		= qla1280_queuecommand,
 	.eh_abort_handler	= qla1280_eh_abort,
 	.eh_device_reset_handler= qla1280_eh_device_reset,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 18134c2ad835..f51852ab88a1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1851,7 +1851,7 @@ qla2xxx_sdev_prep(struct scsi_device *sdev)
 }
 
 static int
-qla2xxx_slave_configure(struct scsi_device *sdev)
+qla2xxx_sdev_configure(struct scsi_device *sdev)
 {
 	scsi_qla_host_t *vha = shost_priv(sdev->host);
 	struct req_que *req = vha->req;
@@ -7765,7 +7765,7 @@ struct scsi_host_template qla2xxx_driver_template = {
 	.eh_bus_reset_handler	= qla2xxx_eh_bus_reset,
 	.eh_host_reset_handler	= qla2xxx_eh_host_reset,
 
-	.slave_configure	= qla2xxx_slave_configure,
+	.sdev_configure	= qla2xxx_sdev_configure,
 
 	.sdev_prep		= qla2xxx_sdev_prep,
 	.sdev_destroy		= qla2xxx_sdev_destroy,
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 3790e8b70bba..1e8d784add69 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -974,7 +974,7 @@ static inline void update_can_queue(struct Scsi_Host *host, u_int in_ptr, u_int
 	host->sg_tablesize = QLOGICPTI_MAX_SG(num_free);
 }
 
-static int qlogicpti_slave_configure(struct scsi_device *sdev)
+static int qlogicpti_sdev_configure(struct scsi_device *sdev)
 {
 	struct qlogicpti *qpti = shost_priv(sdev->host);
 	int tgt = sdev->id;
@@ -1292,7 +1292,7 @@ static struct scsi_host_template qpti_template = {
 	.name			= "qlogicpti",
 	.info			= qlogicpti_info,
 	.queuecommand		= qlogicpti_queuecommand,
-	.slave_configure	= qlogicpti_slave_configure,
+	.sdev_configure	= qlogicpti_sdev_configure,
 	.eh_abort_handler	= qlogicpti_abort,
 	.eh_host_reset_handler	= qlogicpti_reset,
 	.can_queue		= QLOGICPTI_REQ_QUEUE_LEN,
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 741502da09c4..f4348d674df6 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4977,13 +4977,13 @@ static int scsi_debug_sdev_prep(struct scsi_device *sdp)
 	return 0;
 }
 
-static int scsi_debug_slave_configure(struct scsi_device *sdp)
+static int scsi_debug_sdev_configure(struct scsi_device *sdp)
 {
 	struct sdebug_dev_info *devip =
 			(struct sdebug_dev_info *)sdp->hostdata;
 
 	if (sdebug_verbose)
-		pr_info("slave_configure <%u %u %u %llu>\n",
+		pr_info("sdev_configure <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	if (sdp->host->max_cmd_len != SDEBUG_MAX_CMD_LEN)
 		sdp->host->max_cmd_len = SDEBUG_MAX_CMD_LEN;
@@ -7222,7 +7222,7 @@ static struct scsi_host_template sdebug_driver_template = {
 	.name =			"SCSI DEBUG",
 	.info =			scsi_debug_info,
 	.sdev_prep =		scsi_debug_sdev_prep,
-	.slave_configure =	scsi_debug_slave_configure,
+	.sdev_configure =	scsi_debug_sdev_configure,
 	.sdev_destroy =	scsi_debug_sdev_destroy,
 	.ioctl =		scsi_debug_ioctl,
 	.queuecommand =		scsi_debug_queuecommand,
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ccd9fb11d305..84cc2963015a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -250,7 +250,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	sdev->hostdata = hostdata;
 
 	/* if the device needs this changing, it may do so in the
-	 * slave_configure function */
+	 * sdev_configure function */
 	sdev->max_device_blocked = SCSI_DEFAULT_DEVICE_BLOCKED;
 
 	/*
@@ -924,7 +924,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_NO_RSOC)
 		sdev->no_report_opcodes = 1;
 
-	/* set the device running here so that slave configure
+	/* set the device running here so that sdev_configure
 	 * may do I/O */
 	mutex_lock(&sdev->state_mutex);
 	ret = scsi_device_set_state(sdev, SDEV_RUNNING);
@@ -960,11 +960,11 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 	transport_configure_device(&sdev->sdev_gendev);
 
-	if (sdev->host->hostt->slave_configure) {
-		ret = sdev->host->hostt->slave_configure(sdev);
+	if (sdev->host->hostt->sdev_configure) {
+		ret = sdev->host->hostt->sdev_configure(sdev);
 		if (ret) {
 			/*
-			 * if LLDD reports slave not present, don't clutter
+			 * if LLDD reports sdev not present, don't clutter
 			 * console with alloc failure messages
 			 */
 			if (ret != -ENXIO) {
diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index f74fa7fdbffc..db4f58fbb0a7 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -71,11 +71,11 @@ snic_sdev_prep(struct scsi_device *sdev)
 }
 
 /*
- * snic_slave_configure : callback function to SCSI Mid Layer, called on
+ * snic_sdev_configure : callback function to SCSI Mid Layer, called on
  * scsi device initialization.
  */
 static int
-snic_slave_configure(struct scsi_device *sdev)
+snic_sdev_configure(struct scsi_device *sdev)
 {
 	struct snic *snic = shost_priv(sdev->host);
 	u32 qdepth = 0, max_ios = 0;
@@ -122,7 +122,7 @@ static struct scsi_host_template snic_host_template = {
 	.eh_device_reset_handler = snic_device_reset,
 	.eh_host_reset_handler = snic_host_reset,
 	.sdev_prep = snic_sdev_prep,
-	.slave_configure = snic_slave_configure,
+	.sdev_configure = snic_sdev_configure,
 	.change_queue_depth = snic_change_queue_depth,
 	.this_id = -1,
 	.cmd_per_lun = SNIC_DFLT_QUEUE_DEPTH,
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index d4f10c0d813c..e6741aae3e68 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -584,7 +584,7 @@ static void return_abnormal_state(struct st_hba *hba, int status)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
 static int
-stex_slave_config(struct scsi_device *sdev)
+stex_sdev_config(struct scsi_device *sdev)
 {
 	sdev->use_10_for_rw = 1;
 	sdev->use_10_for_ms = 1;
@@ -1480,7 +1480,7 @@ static struct scsi_host_template driver_template = {
 	.proc_name			= DRV_NAME,
 	.bios_param			= stex_biosparam,
 	.queuecommand			= stex_queuecommand,
-	.slave_configure		= stex_slave_config,
+	.sdev_configure		= stex_sdev_config,
 	.eh_abort_handler		= stex_abort,
 	.eh_host_reset_handler		= stex_reset,
 	.this_id			= -1,
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 5dba63b52e49..54235622fee6 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1770,7 +1770,7 @@ static struct scsi_host_template scsi_driver = {
 	.proc_name =		"storvsc_host",
 	.eh_timed_out =		storvsc_eh_timed_out,
 	.sdev_prep =		storvsc_device_alloc,
-	.slave_configure =	storvsc_device_configure,
+	.sdev_configure =	storvsc_device_configure,
 	.cmd_per_lun =		2048,
 	.this_id =		-1,
 	/* Make sure we dont get a sg segment crosses a page boundary */
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 128e4ad0124d..b138050fbd8f 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -781,7 +781,7 @@ static int sym53c8xx_sdev_prep(struct scsi_device *sdev)
 /*
  * Linux entry point for device queue sizing.
  */
-static int sym53c8xx_slave_configure(struct scsi_device *sdev)
+static int sym53c8xx_sdev_configure(struct scsi_device *sdev)
 {
 	struct sym_hcb *np = sym_get_hcb(sdev->host);
 	struct sym_tcb *tp = &np->target[sdev->id];
@@ -1640,7 +1640,7 @@ static struct scsi_host_template sym2_template = {
 	.info			= sym53c8xx_info, 
 	.queuecommand		= sym53c8xx_queue_command,
 	.sdev_prep		= sym53c8xx_sdev_prep,
-	.slave_configure	= sym53c8xx_slave_configure,
+	.sdev_configure	= sym53c8xx_sdev_configure,
 	.sdev_destroy		= sym53c8xx_sdev_destroy,
 	.eh_abort_handler	= sym53c8xx_eh_abort_handler,
 	.eh_device_reset_handler = sym53c8xx_eh_device_reset_handler,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ca9fc27c4f02..742c0ec2c917 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4657,10 +4657,10 @@ static int ufshcd_change_queue_depth(struct scsi_device *sdev, int depth)
 }
 
 /**
- * ufshcd_slave_configure - adjust SCSI device configurations
+ * ufshcd_sdev_configure - adjust SCSI device configurations
  * @sdev: pointer to SCSI device
  */
-static int ufshcd_slave_configure(struct scsi_device *sdev)
+static int ufshcd_sdev_configure(struct scsi_device *sdev)
 {
 	struct ufs_hba *hba = shost_priv(sdev->host);
 	struct request_queue *q = sdev->request_queue;
@@ -7490,7 +7490,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.proc_name		= UFSHCD,
 	.queuecommand		= ufshcd_queuecommand,
 	.sdev_prep		= ufshcd_sdev_prep,
-	.slave_configure	= ufshcd_slave_configure,
+	.sdev_configure	= ufshcd_sdev_configure,
 	.sdev_destroy		= ufshcd_sdev_destroy,
 	.change_queue_depth	= ufshcd_change_queue_depth,
 	.eh_abort_handler	= ufshcd_abort,
diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 319b8bf68117..c5ef9045b68d 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -689,7 +689,7 @@ static struct scsi_host_template scsifront_sht = {
 	.queuecommand		= scsifront_queuecommand,
 	.eh_abort_handler	= scsifront_eh_abort_handler,
 	.eh_device_reset_handler = scsifront_dev_reset_handler,
-	.slave_configure	= scsifront_sdev_configure,
+	.sdev_configure	= scsifront_sdev_configure,
 	.sdev_destroy		= scsifront_sdev_destroy,
 	.cmd_per_lun		= VSCSIIF_DEFAULT_CMD_PER_LUN,
 	.can_queue		= VSCSIIF_MAX_REQS,
@@ -1000,7 +1000,7 @@ static void scsifront_do_lun_hotplug(struct vscsifrnt_info *info, int op)
 			continue;
 
 		/*
-		 * Front device state path, used in slave_configure called
+		 * Front device state path, used in sdev_configure called
 		 * on successfull scsi_add_device, and in sdev_destroy called
 		 * on remove of a device.
 		 */
diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index 562f1b4bc159..4dcc62e85e34 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -68,7 +68,7 @@ static int sdev_prep(struct scsi_device *sdev)
 	return 0;
 }
 
-static int slave_configure(struct scsi_device *sdev)
+static int sdev_configure(struct scsi_device *sdev)
 {
 	/*
 	 * Scatter-gather buffers (all but the last) must have a length
@@ -218,7 +218,7 @@ static struct scsi_host_template rtsx_host_template = {
 	.this_id =			-1,
 
 	.sdev_prep =			sdev_prep,
-	.slave_configure =		slave_configure,
+	.sdev_configure =		sdev_configure,
 
 	/* lots of sg segments can be handled */
 	.sg_tablesize =			SG_ALL,
diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 4cb6124b4d18..3c19c3e9cd6a 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -324,7 +324,7 @@ static int mts_sdev_prep (struct scsi_device *s)
 	return 0;
 }
 
-static int mts_slave_configure (struct scsi_device *s)
+static int mts_sdev_configure (struct scsi_device *s)
 {
 	blk_queue_dma_alignment(s->request_queue, (512 - 1));
 	return 0;
@@ -629,7 +629,7 @@ static struct scsi_host_template mts_scsi_host_template = {
 	.this_id =		-1,
 	.emulated =		1,
 	.sdev_prep =		mts_sdev_prep,
-	.slave_configure =	mts_slave_configure,
+	.sdev_configure =	mts_sdev_configure,
 	.max_sectors=		256, /* 128 K */
 };
 
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 8bd17467a55e..5254f6d16022 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -89,7 +89,7 @@ static int sdev_prep (struct scsi_device *sdev)
 	return 0;
 }
 
-static int slave_configure(struct scsi_device *sdev)
+static int sdev_configure(struct scsi_device *sdev)
 {
 	struct us_data *us = host_to_us(sdev->host);
 	struct device *dev = us->pusb_dev->bus->sysdev;
@@ -620,7 +620,7 @@ static const struct scsi_host_template usb_stor_host_template = {
 	.this_id =			-1,
 
 	.sdev_prep =			sdev_prep,
-	.slave_configure =		slave_configure,
+	.sdev_configure =		sdev_configure,
 	.target_alloc =			target_alloc,
 
 	/* lots of sg segments can be handled */
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 329d1c26b710..227209c28f4d 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -835,7 +835,7 @@ static int uas_sdev_prep(struct scsi_device *sdev)
 	return 0;
 }
 
-static int uas_slave_configure(struct scsi_device *sdev)
+static int uas_sdev_configure(struct scsi_device *sdev)
 {
 	struct uas_dev_info *devinfo = sdev->hostdata;
 
@@ -893,7 +893,7 @@ static struct scsi_host_template uas_host_template = {
 	.queuecommand = uas_queuecommand,
 	.target_alloc = uas_target_alloc,
 	.sdev_prep = uas_sdev_prep,
-	.slave_configure = uas_slave_configure,
+	.sdev_configure = uas_sdev_configure,
 	.eh_abort_handler = uas_eh_abort_handler,
 	.eh_device_reset_handler = uas_eh_device_reset_handler,
 	.this_id = -1,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index e7153fca9cfc..d32b5ad86011 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1148,7 +1148,7 @@ extern int ata_std_bios_param(struct scsi_device *sdev,
 			      struct block_device *bdev,
 			      sector_t capacity, int geom[]);
 extern void ata_scsi_unlock_native_capacity(struct scsi_device *sdev);
-extern int ata_scsi_slave_config(struct scsi_device *sdev);
+extern int ata_scsi_sdev_config(struct scsi_device *sdev);
 extern void ata_scsi_sdev_destroy(struct scsi_device *sdev);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth);
@@ -1240,7 +1240,7 @@ extern int ata_sas_port_start(struct ata_port *ap);
 extern int ata_sas_tport_add(struct device *parent, struct ata_port *ap);
 extern void ata_sas_tport_delete(struct ata_port *ap);
 extern void ata_sas_port_stop(struct ata_port *ap);
-extern int ata_sas_slave_configure(struct scsi_device *, struct ata_port *);
+extern int ata_sas_sdev_configure(struct scsi_device *, struct ata_port *);
 extern int ata_sas_queuecmd(struct scsi_cmnd *cmd, struct ata_port *ap);
 extern void ata_tf_to_fis(const struct ata_taskfile *tf,
 			  u8 pmp, int is_cmd, u8 *fis);
@@ -1398,7 +1398,7 @@ extern struct device_attribute *ata_common_sdev_attrs[];
 	.this_id		= ATA_SHT_THIS_ID,		\
 	.emulated		= ATA_SHT_EMULATED,		\
 	.proc_name		= drv_name,			\
-	.slave_configure	= ata_scsi_slave_config,	\
+	.sdev_configure		= ata_scsi_sdev_config,		\
 	.sdev_destroy		= ata_scsi_sdev_destroy,	\
 	.bios_param		= ata_std_bios_param,		\
 	.unlock_native_capacity	= ata_scsi_unlock_native_capacity
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 2d6afa200c8b..8368c2063037 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -664,7 +664,7 @@ int sas_set_phy_speed(struct sas_phy *phy, struct sas_phy_linkrates *rates);
 int sas_phy_reset(struct sas_phy *phy, int hard_reset);
 extern int sas_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 extern int sas_target_alloc(struct scsi_target *);
-extern int sas_slave_configure(struct scsi_device *);
+extern int sas_sdev_configure(struct scsi_device *);
 extern int sas_change_queue_depth(struct scsi_device *, int new_depth);
 extern int sas_bios_param(struct scsi_device *, struct block_device *,
 			  sector_t capacity, int *hsc);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 334bb4adadaf..2c2cbb244790 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -149,11 +149,11 @@ struct scsi_host_template {
 	 *
 	 * Deallocation:  If we didn't find any devices at this ID, you will
 	 * get an immediate call to sdev_destroy().  If we find something
-	 * here then you will get a call to slave_configure(), then the
+	 * here then you will get a call to sdev_configure(), then the
 	 * device will be used for however long it is kept around, then when
 	 * the device is removed from the system (or * possibly at reboot
 	 * time), you will then get a call to sdev_destroy().  This is
-	 * assuming you implement slave_configure and sdev_destroy.
+	 * assuming you implement sdev_configure and sdev_destroy.
 	 * However, if you allocate memory and hang it off the device struct,
 	 * then you must implement the sdev_destroy() routine at a minimum
 	 * in order to avoid leaking memory
@@ -192,14 +192,14 @@ struct scsi_host_template {
 	 *
 	 * Status: OPTIONAL
 	 */
-	int (* slave_configure)(struct scsi_device *);
+	int (* sdev_configure)(struct scsi_device *);
 
 	/*
 	 * Immediately prior to deallocating the device and after all activity
 	 * has ceased the mid layer calls this point so that the low level
 	 * driver may completely detach itself from the scsi device and vice
 	 * versa.  The low level driver is responsible for freeing any memory
-	 * it allocated in the sdev_prep or slave_configure calls. 
+	 * it allocated in the sdev_prep or sdev_configure calls. 
 	 *
 	 * Status: OPTIONAL
 	 */
-- 
2.27.0

