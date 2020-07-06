Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AFA8C433E2
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 19:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 156F9206F5
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 19:39:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pbCM9zZG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgGFTjf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 15:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFTjf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 15:39:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A804CC061755
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2020 12:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Jk+yv6QaYw2+fGXxuoHte5i1Rdyfr/ajUjQKMT6zTL4=; b=pbCM9zZG/UT44NaOXh6PwRihUK
        UXLjwG2nSaWvzD2hur1qJYpViq+vkQ/zBlElsL71ZsAKv4LdInW2RwGEJEzTNXPrkXMDxK5I/QnVa
        EjzfSZMUXWKHCA1OTIqk8U3fSdt4+mhiMKIooaM+0SkVKEGNuH7TT0QXZPHNpvf2gE5iqrYuyfoZi
        /tExhtWla2XONN3K8SXNjV5OQdvPO+zGyRehzQlm+36aiH2xu8pQH5wF1/32nXqnY8wXcp1a5iCRC
        DiBbqkefQzDfRP1rP8f/MX/tAXybmlG3cZacy8p6EWM+40WWVCYIzJtEnymyg0/lT6a5Qt2ompU5B
        FMle/irg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jsWxY-0001oG-4u; Mon, 06 Jul 2020 19:39:24 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 1/3] scsi: Rename slave_alloc to sdev_prep
Date:   Mon,  6 Jul 2020 20:39:18 +0100
Message-Id: <20200706193920.6897-2-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200706193920.6897-1-willy@infradead.org>
References: <20200706193920.6897-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

slave_alloc is badly named because it doesn't actually do the allocation.
It's a notification to the driver that it should prepare its internal
data structures for this device so it is ready to handle commands.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 Documentation/scsi/scsi_mid_low_api.rst       | 26 +++++++++----------
 drivers/firewire/sbp2.c                       |  4 +--
 drivers/message/fusion/mptfc.c                | 10 +++----
 drivers/message/fusion/mptsas.c               |  6 ++---
 drivers/message/fusion/mptspi.c               |  6 ++---
 drivers/s390/scsi/zfcp_scsi.c                 |  6 ++---
 drivers/s390/scsi/zfcp_sysfs.c                |  2 +-
 drivers/s390/scsi/zfcp_unit.c                 |  2 +-
 drivers/scsi/53c700.c                         |  6 ++---
 drivers/scsi/aha152x.c                        |  2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c            |  4 +--
 drivers/scsi/aic7xxx/aic7xxx_osm.c            |  4 +--
 drivers/scsi/bfa/bfad_im.c                    | 12 ++++-----
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c             |  2 +-
 drivers/scsi/csiostor/csio_scsi.c             |  6 ++---
 drivers/scsi/dc395x.c                         |  6 ++---
 drivers/scsi/esp_scsi.c                       |  4 +--
 drivers/scsi/fcoe/fcoe.c                      |  2 +-
 drivers/scsi/fnic/fnic_main.c                 |  4 +--
 drivers/scsi/hpsa.c                           |  6 ++---
 drivers/scsi/ibmvscsi/ibmvfc.c                |  6 ++---
 drivers/scsi/imm.c                            |  2 +-
 drivers/scsi/ipr.c                            | 12 ++++-----
 drivers/scsi/libfc/fc_fcp.c                   |  6 ++---
 drivers/scsi/lpfc/lpfc_scsi.c                 | 12 ++++-----
 drivers/scsi/megaraid/megaraid_sas_base.c     |  4 +--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c          |  8 +++---
 drivers/scsi/myrb.c                           | 12 ++++-----
 drivers/scsi/myrs.c                           |  4 +--
 drivers/scsi/ncr53c8xx.c                      |  4 +--
 drivers/scsi/pmcraid.c                        |  8 +++---
 drivers/scsi/ppa.c                            |  2 +-
 drivers/scsi/qla2xxx/qla_os.c                 |  4 +--
 drivers/scsi/qla4xxx/ql4_os.c                 |  6 ++---
 drivers/scsi/scsi_debug.c                     |  6 ++---
 drivers/scsi/scsi_scan.c                      | 10 +++----
 drivers/scsi/smartpqi/smartpqi_init.c         |  4 +--
 drivers/scsi/snic/snic_main.c                 |  6 ++---
 drivers/scsi/storvsc_drv.c                    |  2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c           |  6 ++---
 drivers/scsi/ufs/ufshcd.c                     |  6 ++---
 drivers/scsi/virtio_scsi.c                    |  2 +-
 drivers/staging/rts5208/rtsx.c                |  4 +--
 .../staging/unisys/visorhba/visorhba_main.c   |  6 ++---
 drivers/usb/image/microtek.c                  |  4 +--
 drivers/usb/storage/scsiglue.c                |  6 ++---
 drivers/usb/storage/uas.c                     |  4 +--
 include/scsi/libfc.h                          |  2 +-
 include/scsi/libsas.h                         |  2 +-
 include/scsi/scsi_device.h                    |  4 +--
 include/scsi/scsi_host.h                      |  4 +--
 51 files changed, 144 insertions(+), 144 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
index 5358bc10689e..246495f11da5 100644
--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -112,9 +112,9 @@ Those usages in group c) should be handled with care, especially in a
 that are shared with the mid level and other layers.
 
 All functions defined within an LLD and all data defined at file scope
-should be static. For example the slave_alloc() function in an LLD
+should be static. For example the sdev_prep() function in an LLD
 called "xxx" could be defined as
-``static int xxx_slave_alloc(struct scsi_device * sdev) { /* code */ }``
+``static int xxx_sdev_prep(struct scsi_device * sdev) { /* code */ }``
 
 .. [#] the scsi_host_alloc() function is a replacement for the rather vaguely
        named scsi_register() function in most situations.
@@ -149,18 +149,18 @@ scsi devices of which only the first 2 respond::
     scsi_add_host()  ---->
     scsi_scan_host()  -------+
 			    |
-			slave_alloc()
+			sdev_prep()
 			slave_configure() -->  scsi_change_queue_depth()
 			    |
-			slave_alloc()
+			sdev_prep()
 			slave_configure()
 			    |
-			slave_alloc()   ***
+			sdev_prep()   ***
 			slave_destroy() ***
 
 
     *** For scsi devices that the mid level tries to scan but do not
-	respond, a slave_alloc(), slave_destroy() pair is called.
+	respond, a sdev_prep(), slave_destroy() pair is called.
 
 If the LLD wants to adjust the default queue settings, it can invoke
 scsi_change_queue_depth() in its slave_configure() routine.
@@ -202,7 +202,7 @@ An LLD can use this sequence to make the mid level aware of a SCSI device::
     ===-------------------=========--------------------===------
     scsi_add_device()  ------+
 			    |
-			slave_alloc()
+			sdev_prep()
 			slave_configure()   [--> scsi_change_queue_depth()]
 
 In a similar fashion, an LLD may become aware that a SCSI device has been
@@ -221,7 +221,7 @@ upper layers with this sequence::
 			slave_destroy()
 
 It may be useful for an LLD to keep track of struct scsi_device instances
-(a pointer is passed as the parameter to slave_alloc() and
+(a pointer is passed as the parameter to sdev_prep() and
 slave_configure() callbacks). Such instances are "owned" by the mid-level.
 struct scsi_device instances are freed after slave_destroy().
 
@@ -337,7 +337,7 @@ Details::
     *      bus scan when an HBA is added (i.e. scsi_scan_host()). So it
     *      should only be called if the HBA becomes aware of a new scsi
     *      device (lu) after scsi_scan_host() has completed. If successful
-    *      this call can lead to slave_alloc() and slave_configure() callbacks
+    *      this call can lead to sdev_prep() and slave_configure() callbacks
     *      into the LLD.
     *
     *      Defined in: drivers/scsi/scsi_scan.c
@@ -663,7 +663,7 @@ Summary:
   - ioctl - driver can respond to ioctls
   - proc_info - supports /proc/scsi/{driver_name}/{host_no}
   - queuecommand - queue scsi command, invoke 'done' on completion
-  - slave_alloc - prior to any commands being sent to a new device
+  - sdev_prep - prior to any commands being sent to a new device
   - slave_configure - driver fine tuning for given device after attach
   - slave_destroy - given device is about to be shut down
 
@@ -966,7 +966,7 @@ Details::
 
 
     /**
-    *      slave_alloc -   prior to any commands being sent to a new device
+    *      sdev_prep -   prior to any commands being sent to a new device
     *                      (i.e. just prior to scan) this call is made
     *      @sdp: pointer to new device (about to be scanned)
     *
@@ -987,7 +987,7 @@ Details::
     *
     *      Optionally defined in: LLD
     **/
-	int slave_alloc(struct scsi_device *sdp)
+	int sdev_prep(struct scsi_device *sdp)
 
 
     /**
@@ -1029,7 +1029,7 @@ Details::
     *      by this driver for given device should be freed now. No further
     *      commands will be sent for this sdp instance. [However the device
     *      could be re-attached in the future in which case a new instance
-    *      of struct scsi_device would be supplied by future slave_alloc()
+    *      of struct scsi_device would be supplied by future sdev_prep()
     *      and slave_configure() calls.]
     *
     *      Optionally defined in: LLD
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 4d5054211550..5b1cba288550 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1488,7 +1488,7 @@ static int sbp2_scsi_queuecommand(struct Scsi_Host *shost,
 	return retval;
 }
 
-static int sbp2_scsi_slave_alloc(struct scsi_device *sdev)
+static int sbp2_scsi_sdev_prep(struct scsi_device *sdev)
 {
 	struct sbp2_logical_unit *lu = sdev->hostdata;
 
@@ -1588,7 +1588,7 @@ static struct scsi_host_template scsi_driver_template = {
 	.name			= "SBP-2 IEEE-1394",
 	.proc_name		= "sbp2",
 	.queuecommand		= sbp2_scsi_queuecommand,
-	.slave_alloc		= sbp2_scsi_slave_alloc,
+	.sdev_prep		= sbp2_scsi_sdev_prep,
 	.slave_configure	= sbp2_scsi_slave_configure,
 	.eh_abort_handler	= sbp2_scsi_abort,
 	.this_id		= -1,
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 4314a3352b96..2717d65931ad 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -96,7 +96,7 @@ static u8	mptfcTaskCtx = MPT_MAX_PROTOCOL_DRIVERS;
 static u8	mptfcInternalCtx = MPT_MAX_PROTOCOL_DRIVERS;
 
 static int mptfc_target_alloc(struct scsi_target *starget);
-static int mptfc_slave_alloc(struct scsi_device *sdev);
+static int mptfc_sdev_prep(struct scsi_device *sdev);
 static int mptfc_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt);
 static void mptfc_target_destroy(struct scsi_target *starget);
 static void mptfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout);
@@ -113,7 +113,7 @@ static struct scsi_host_template mptfc_driver_template = {
 	.info				= mptscsih_info,
 	.queuecommand			= mptfc_qcmd,
 	.target_alloc			= mptfc_target_alloc,
-	.slave_alloc			= mptfc_slave_alloc,
+	.sdev_prep			= mptfc_sdev_prep,
 	.slave_configure		= mptscsih_slave_configure,
 	.target_destroy			= mptfc_target_destroy,
 	.slave_destroy			= mptscsih_slave_destroy,
@@ -466,7 +466,7 @@ mptfc_register_dev(MPT_ADAPTER *ioc, int channel, FCDevicePage0_t *pg0)
 			/*
 			 * if already mapped, remap here.  If not mapped,
 			 * target_alloc will allocate vtarget and map,
-			 * slave_alloc will fill in vdevice from vtarget.
+			 * sdev_prep will fill in vdevice from vtarget.
 			 */
 			if (ri->starget) {
 				vtarget = ri->starget->hostdata;
@@ -594,7 +594,7 @@ mptfc_dump_lun_info(MPT_ADAPTER *ioc, struct fc_rport *rport, struct scsi_device
  *	Init memory once per LUN.
  */
 static int
-mptfc_slave_alloc(struct scsi_device *sdev)
+mptfc_sdev_prep(struct scsi_device *sdev)
 {
 	MPT_SCSI_HOST		*hd;
 	VirtTarget		*vtarget;
@@ -614,7 +614,7 @@ mptfc_slave_alloc(struct scsi_device *sdev)
 
 	vdevice = kzalloc(sizeof(VirtDevice), GFP_KERNEL);
 	if (!vdevice) {
-		printk(MYIOC_s_ERR_FMT "slave_alloc kmalloc(%zd) FAILED!\n",
+		printk(MYIOC_s_ERR_FMT "sdev_prep kmalloc(%zd) FAILED!\n",
 				ioc->name, sizeof(VirtDevice));
 		return -ENOMEM;
 	}
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 6a79cd0ebe2b..d6f27c90878d 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1839,7 +1839,7 @@ mptsas_target_destroy(struct scsi_target *starget)
 
 
 static int
-mptsas_slave_alloc(struct scsi_device *sdev)
+mptsas_sdev_prep(struct scsi_device *sdev)
 {
 	struct Scsi_Host	*host = sdev->host;
 	MPT_SCSI_HOST		*hd = shost_priv(host);
@@ -1852,7 +1852,7 @@ mptsas_slave_alloc(struct scsi_device *sdev)
 
 	vdevice = kzalloc(sizeof(VirtDevice), GFP_KERNEL);
 	if (!vdevice) {
-		printk(MYIOC_s_ERR_FMT "slave_alloc kzalloc(%zd) FAILED!\n",
+		printk(MYIOC_s_ERR_FMT "sdev_prep kzalloc(%zd) FAILED!\n",
 				ioc->name, sizeof(VirtDevice));
 		return -ENOMEM;
 	}
@@ -1977,7 +1977,7 @@ static struct scsi_host_template mptsas_driver_template = {
 	.info				= mptscsih_info,
 	.queuecommand			= mptsas_qcmd,
 	.target_alloc			= mptsas_target_alloc,
-	.slave_alloc			= mptsas_slave_alloc,
+	.sdev_prep			= mptsas_sdev_prep,
 	.slave_configure		= mptsas_slave_configure,
 	.target_destroy			= mptsas_target_destroy,
 	.slave_destroy			= mptscsih_slave_destroy,
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index eabc4de5816c..633858a445ce 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -713,7 +713,7 @@ static void mptspi_dv_device(struct _MPT_SCSI_HOST *hd,
 	mptspi_read_parameters(sdev->sdev_target);
 }
 
-static int mptspi_slave_alloc(struct scsi_device *sdev)
+static int mptspi_sdev_prep(struct scsi_device *sdev)
 {
 	MPT_SCSI_HOST *hd = shost_priv(sdev->host);
 	VirtTarget		*vtarget;
@@ -727,7 +727,7 @@ static int mptspi_slave_alloc(struct scsi_device *sdev)
 
 	vdevice = kzalloc(sizeof(VirtDevice), GFP_KERNEL);
 	if (!vdevice) {
-		printk(MYIOC_s_ERR_FMT "slave_alloc kmalloc(%zd) FAILED!\n",
+		printk(MYIOC_s_ERR_FMT "sdev_prep kmalloc(%zd) FAILED!\n",
 				ioc->name, sizeof(VirtDevice));
 		return -ENOMEM;
 	}
@@ -828,7 +828,7 @@ static struct scsi_host_template mptspi_driver_template = {
 	.info				= mptscsih_info,
 	.queuecommand			= mptspi_qcmd,
 	.target_alloc			= mptspi_target_alloc,
-	.slave_alloc			= mptspi_slave_alloc,
+	.sdev_prep			= mptspi_sdev_prep,
 	.slave_configure		= mptspi_slave_configure,
 	.target_destroy			= mptspi_target_destroy,
 	.slave_destroy			= mptspi_slave_destroy,
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index d58bf79892f2..a603bdd7b7c5 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -41,7 +41,7 @@ static void zfcp_scsi_slave_destroy(struct scsi_device *sdev)
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 
-	/* if previous slave_alloc returned early, there is nothing to do */
+	/* if previous sdev_prep returned early, there is nothing to do */
 	if (!zfcp_sdev->port)
 		return;
 
@@ -110,7 +110,7 @@ int zfcp_scsi_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scpnt)
 	return ret;
 }
 
-static int zfcp_scsi_slave_alloc(struct scsi_device *sdev)
+static int zfcp_scsi_sdev_prep(struct scsi_device *sdev)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	struct zfcp_adapter *adapter =
@@ -427,7 +427,7 @@ static struct scsi_host_template zfcp_scsi_host_template = {
 	.eh_device_reset_handler = zfcp_scsi_eh_device_reset_handler,
 	.eh_target_reset_handler = zfcp_scsi_eh_target_reset_handler,
 	.eh_host_reset_handler	 = zfcp_scsi_eh_host_reset_handler,
-	.slave_alloc		 = zfcp_scsi_slave_alloc,
+	.sdev_prep		 = zfcp_scsi_sdev_prep,
 	.slave_configure	 = zfcp_scsi_slave_configure,
 	.slave_destroy		 = zfcp_scsi_slave_destroy,
 	.change_queue_depth	 = scsi_change_queue_depth,
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 8d9662e8b717..790321919146 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -284,7 +284,7 @@ static bool zfcp_sysfs_port_in_use(struct zfcp_port *const port)
 		goto unlock_host_lock;
 	}
 
-	/* port is about to be removed, so no more unit_add or slave_alloc */
+	/* port is about to be removed, so no more unit_add or sdev_prep */
 	zfcp_sysfs_port_set_removing(port);
 	in_use = false;
 
diff --git a/drivers/s390/scsi/zfcp_unit.c b/drivers/s390/scsi/zfcp_unit.c
index e67bf7388cae..008b483eb10e 100644
--- a/drivers/s390/scsi/zfcp_unit.c
+++ b/drivers/s390/scsi/zfcp_unit.c
@@ -170,7 +170,7 @@ int zfcp_unit_add(struct zfcp_port *port, u64 fcp_lun)
 	write_unlock_irq(&port->unit_list_lock);
 	/*
 	 * lock order: shost->scan_mutex before zfcp_sysfs_port_units_mutex
-	 * due to      zfcp_unit_scsi_scan() => zfcp_scsi_slave_alloc()
+	 * due to      zfcp_unit_scsi_scan() => zfcp_scsi_sdev_prep()
 	 */
 	mutex_unlock(&zfcp_sysfs_port_units_mutex);
 
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 461b3babb601..9410a7a3873a 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -159,7 +159,7 @@ STATIC int NCR_700_abort(struct scsi_cmnd * SCpnt);
 STATIC int NCR_700_host_reset(struct scsi_cmnd * SCpnt);
 STATIC void NCR_700_chip_setup(struct Scsi_Host *host);
 STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
-STATIC int NCR_700_slave_alloc(struct scsi_device *SDpnt);
+STATIC int NCR_700_sdev_prep(struct scsi_device *SDpnt);
 STATIC int NCR_700_slave_configure(struct scsi_device *SDpnt);
 STATIC void NCR_700_slave_destroy(struct scsi_device *SDpnt);
 static int NCR_700_change_queue_depth(struct scsi_device *SDpnt, int depth);
@@ -308,7 +308,7 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	tpnt->cmd_per_lun = NCR_700_CMD_PER_LUN;
 	tpnt->slave_configure = NCR_700_slave_configure;
 	tpnt->slave_destroy = NCR_700_slave_destroy;
-	tpnt->slave_alloc = NCR_700_slave_alloc;
+	tpnt->sdev_prep = NCR_700_sdev_prep;
 	tpnt->change_queue_depth = NCR_700_change_queue_depth;
 
 	if(tpnt->name == NULL)
@@ -2006,7 +2006,7 @@ NCR_700_set_offset(struct scsi_target *STp, int offset)
 }
 
 STATIC int
-NCR_700_slave_alloc(struct scsi_device *SDp)
+NCR_700_sdev_prep(struct scsi_device *SDp)
 {
 	SDp->hostdata = kzalloc(sizeof(struct NCR_700_Device_Parameters),
 				GFP_KERNEL);
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 90f97df1c42a..df29b8167c03 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -2910,7 +2910,7 @@ static struct scsi_host_template aha152x_driver_template = {
 	.this_id			= 7,
 	.sg_tablesize			= SG_ALL,
 	.dma_boundary			= PAGE_SIZE - 1,
-	.slave_alloc			= aha152x_adjust_queue,
+	.sdev_prep			= aha152x_adjust_queue,
 };
 
 #if !defined(AHA152X_PCMCIA)
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index dc4fe334efd0..5f41d1ec10ee 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -669,7 +669,7 @@ ahd_linux_target_destroy(struct scsi_target *starget)
 }
 
 static int
-ahd_linux_slave_alloc(struct scsi_device *sdev)
+ahd_linux_sdev_prep(struct scsi_device *sdev)
 {
 	struct	ahd_softc *ahd =
 		*((struct ahd_softc **)sdev->host->hostdata);
@@ -913,7 +913,7 @@ struct scsi_host_template aic79xx_driver_template = {
 	.this_id		= -1,
 	.max_sectors		= 8192,
 	.cmd_per_lun		= 2,
-	.slave_alloc		= ahd_linux_slave_alloc,
+	.sdev_prep		= ahd_linux_sdev_prep,
 	.slave_configure	= ahd_linux_slave_configure,
 	.target_alloc		= ahd_linux_target_alloc,
 	.target_destroy		= ahd_linux_target_destroy,
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 2edfa0594f18..4350a941e060 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -637,7 +637,7 @@ ahc_linux_target_destroy(struct scsi_target *starget)
 }
 
 static int
-ahc_linux_slave_alloc(struct scsi_device *sdev)
+ahc_linux_sdev_prep(struct scsi_device *sdev)
 {
 	struct	ahc_softc *ahc =
 		*((struct ahc_softc **)sdev->host->hostdata);
@@ -800,7 +800,7 @@ struct scsi_host_template aic7xxx_driver_template = {
 	.this_id		= -1,
 	.max_sectors		= 8192,
 	.cmd_per_lun		= 2,
-	.slave_alloc		= ahc_linux_slave_alloc,
+	.sdev_prep		= ahc_linux_sdev_prep,
 	.slave_configure	= ahc_linux_slave_configure,
 	.target_alloc		= ahc_linux_target_alloc,
 	.target_destroy		= ahc_linux_target_destroy,
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 22f06be2606f..bd860b6b8d46 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -25,7 +25,7 @@ struct scsi_transport_template *bfad_im_scsi_transport_template;
 struct scsi_transport_template *bfad_im_scsi_vport_transport_template;
 static void bfad_im_itnim_work_handler(struct work_struct *work);
 static int bfad_im_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *cmnd);
-static int bfad_im_slave_alloc(struct scsi_device *sdev);
+static int bfad_im_sdev_prep(struct scsi_device *sdev);
 static void bfad_im_fc_rport_add(struct bfad_im_port_s  *im_port,
 				struct bfad_itnim_s *itnim);
 
@@ -802,7 +802,7 @@ struct scsi_host_template bfad_im_scsi_host_template = {
 	.eh_device_reset_handler = bfad_im_reset_lun_handler,
 	.eh_target_reset_handler = bfad_im_reset_target_handler,
 
-	.slave_alloc = bfad_im_slave_alloc,
+	.sdev_prep = bfad_im_sdev_prep,
 	.slave_configure = bfad_im_slave_configure,
 	.slave_destroy = bfad_im_slave_destroy,
 
@@ -824,7 +824,7 @@ struct scsi_host_template bfad_im_vport_template = {
 	.eh_device_reset_handler = bfad_im_reset_lun_handler,
 	.eh_target_reset_handler = bfad_im_reset_target_handler,
 
-	.slave_alloc = bfad_im_slave_alloc,
+	.sdev_prep = bfad_im_sdev_prep,
 	.slave_configure = bfad_im_slave_configure,
 	.slave_destroy = bfad_im_slave_destroy,
 
@@ -916,7 +916,7 @@ bfad_get_itnim(struct bfad_im_port_s *im_port, int id)
 }
 
 /*
- * Function is invoked from the SCSI Host Template slave_alloc() entry point.
+ * Function is invoked from the SCSI Host Template sdev_prep() entry point.
  * Has the logic to query the LUN Mask database to check if this LUN needs to
  * be made visible to the SCSI mid-layer or not.
  *
@@ -947,10 +947,10 @@ bfad_im_check_if_make_lun_visible(struct scsi_device *sdev,
 }
 
 /*
- * Scsi_Host template entry slave_alloc
+ * Scsi_Host template entry sdev_prep
  */
 static int
-bfad_im_slave_alloc(struct scsi_device *sdev)
+bfad_im_sdev_prep(struct scsi_device *sdev)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	struct bfad_itnim_data_s *itnim_data;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 0e33324e16f5..97b022a324fb 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2968,7 +2968,7 @@ static struct scsi_host_template bnx2fc_shost_template = {
 	.eh_device_reset_handler = bnx2fc_eh_device_reset, /* lun reset */
 	.eh_target_reset_handler = bnx2fc_eh_target_reset, /* tgt reset */
 	.eh_host_reset_handler	= fc_eh_host_reset,
-	.slave_alloc		= fc_slave_alloc,
+	.sdev_prep		= fc_sdev_prep,
 	.change_queue_depth	= scsi_change_queue_depth,
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 00cf33573136..0ee7d39bde93 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2219,7 +2219,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 }
 
 static int
-csio_slave_alloc(struct scsi_device *sdev)
+csio_sdev_prep(struct scsi_device *sdev)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 
@@ -2270,7 +2270,7 @@ struct scsi_host_template csio_fcoe_shost_template = {
 	.eh_timed_out		= fc_eh_timed_out,
 	.eh_abort_handler	= csio_eh_abort_handler,
 	.eh_device_reset_handler = csio_eh_lun_reset_handler,
-	.slave_alloc		= csio_slave_alloc,
+	.sdev_prep		= csio_sdev_prep,
 	.slave_configure	= csio_slave_configure,
 	.slave_destroy		= csio_slave_destroy,
 	.scan_finished		= csio_scan_finished,
@@ -2289,7 +2289,7 @@ struct scsi_host_template csio_fcoe_shost_vport_template = {
 	.eh_timed_out		= fc_eh_timed_out,
 	.eh_abort_handler	= csio_eh_abort_handler,
 	.eh_device_reset_handler = csio_eh_lun_reset_handler,
-	.slave_alloc		= csio_slave_alloc,
+	.sdev_prep		= csio_sdev_prep,
 	.slave_configure	= csio_slave_configure,
 	.slave_destroy		= csio_slave_destroy,
 	.scan_finished		= csio_scan_finished,
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index e95f5b3bef4d..6b22777c123f 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3752,13 +3752,13 @@ static void adapter_remove_and_free_all_devices(struct AdapterCtlBlk* acb)
 
 
 /**
- * dc395x_slave_alloc - Called by the scsi mid layer to tell us about a new
+ * dc395x_sdev_prep - Called by the scsi mid layer to tell us about a new
  * scsi device that we need to deal with. We allocate a new device and then
  * insert that device into the adapters device list.
  *
  * @scsi_device: The new scsi device that we need to handle.
  **/
-static int dc395x_slave_alloc(struct scsi_device *scsi_device)
+static int dc395x_sdev_prep(struct scsi_device *scsi_device)
 {
 	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)scsi_device->host->hostdata;
 	struct DeviceCtlBlk *dcb;
@@ -4589,7 +4589,7 @@ static struct scsi_host_template dc395x_driver_template = {
 	.show_info              = dc395x_show_info,
 	.name                   = DC395X_BANNER " " DC395X_VERSION,
 	.queuecommand           = dc395x_queue_command,
-	.slave_alloc            = dc395x_slave_alloc,
+	.sdev_prep            = dc395x_sdev_prep,
 	.slave_destroy          = dc395x_slave_destroy,
 	.can_queue              = DC395x_MAX_CAN_QUEUE,
 	.this_id                = 7,
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 89afa31e33cb..37471f82921a 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2452,7 +2452,7 @@ static void esp_target_destroy(struct scsi_target *starget)
 	tp->starget = NULL;
 }
 
-static int esp_slave_alloc(struct scsi_device *dev)
+static int esp_sdev_prep(struct scsi_device *dev)
 {
 	struct esp *esp = shost_priv(dev->host);
 	struct esp_target_data *tp = &esp->target[dev->id];
@@ -2678,7 +2678,7 @@ struct scsi_host_template scsi_esp_template = {
 	.queuecommand		= esp_queuecommand,
 	.target_alloc		= esp_target_alloc,
 	.target_destroy		= esp_target_destroy,
-	.slave_alloc		= esp_slave_alloc,
+	.sdev_prep		= esp_sdev_prep,
 	.slave_configure	= esp_slave_configure,
 	.slave_destroy		= esp_slave_destroy,
 	.eh_abort_handler	= esp_eh_abort_handler,
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index cb41d166e0c0..4a9622738526 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -269,7 +269,7 @@ static struct scsi_host_template fcoe_shost_template = {
 	.eh_abort_handler = fc_eh_abort,
 	.eh_device_reset_handler = fc_eh_device_reset,
 	.eh_host_reset_handler = fc_eh_host_reset,
-	.slave_alloc = fc_slave_alloc,
+	.sdev_prep = fc_sdev_prep,
 	.change_queue_depth = scsi_change_queue_depth,
 	.this_id = -1,
 	.cmd_per_lun = 3,
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 7910b573bacb..8dffb152e718 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -96,7 +96,7 @@ static struct libfc_function_template fnic_transport_template = {
 	.exch_mgr_reset = fnic_exch_mgr_reset
 };
 
-static int fnic_slave_alloc(struct scsi_device *sdev)
+static int fnic_sdev_prep(struct scsi_device *sdev)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 
@@ -115,7 +115,7 @@ static struct scsi_host_template fnic_host_template = {
 	.eh_abort_handler = fnic_abort_cmd,
 	.eh_device_reset_handler = fnic_device_reset,
 	.eh_host_reset_handler = fnic_host_reset,
-	.slave_alloc = fnic_slave_alloc,
+	.sdev_prep = fnic_sdev_prep,
 	.change_queue_depth = scsi_change_queue_depth,
 	.this_id = -1,
 	.cmd_per_lun = 3,
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 81d0414e2117..4e4d3045da7a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -283,7 +283,7 @@ static int hpsa_scan_finished(struct Scsi_Host *sh,
 static int hpsa_change_queue_depth(struct scsi_device *sdev, int qdepth);
 
 static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd);
-static int hpsa_slave_alloc(struct scsi_device *sdev);
+static int hpsa_sdev_prep(struct scsi_device *sdev);
 static int hpsa_slave_configure(struct scsi_device *sdev);
 static void hpsa_slave_destroy(struct scsi_device *sdev);
 
@@ -974,7 +974,7 @@ static struct scsi_host_template hpsa_driver_template = {
 	.this_id		= -1,
 	.eh_device_reset_handler = hpsa_eh_device_reset_handler,
 	.ioctl			= hpsa_ioctl,
-	.slave_alloc		= hpsa_slave_alloc,
+	.sdev_prep		= hpsa_sdev_prep,
 	.slave_configure	= hpsa_slave_configure,
 	.slave_destroy		= hpsa_slave_destroy,
 #ifdef CONFIG_COMPAT
@@ -2100,7 +2100,7 @@ static struct hpsa_scsi_dev_t *lookup_hpsa_scsi_dev(struct ctlr_info *h,
 	return NULL;
 }
 
-static int hpsa_slave_alloc(struct scsi_device *sdev)
+static int hpsa_sdev_prep(struct scsi_device *sdev)
 {
 	struct hpsa_scsi_dev_t *sd = NULL;
 	unsigned long flags;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 77f4d37d5bd6..1038689057f0 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2854,7 +2854,7 @@ static int ibmvfc_scan_finished(struct Scsi_Host *shost, unsigned long time)
 }
 
 /**
- * ibmvfc_slave_alloc - Setup the device's task set value
+ * ibmvfc_sdev_prep - Setup the device's task set value
  * @sdev:	struct scsi_device device to configure
  *
  * Set the device's task set value so that error handling works as
@@ -2863,7 +2863,7 @@ static int ibmvfc_scan_finished(struct Scsi_Host *shost, unsigned long time)
  * Returns:
  *	0 on success / -ENXIO if device does not exist
  **/
-static int ibmvfc_slave_alloc(struct scsi_device *sdev)
+static int ibmvfc_sdev_prep(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
@@ -3117,7 +3117,7 @@ static struct scsi_host_template driver_template = {
 	.eh_device_reset_handler = ibmvfc_eh_device_reset_handler,
 	.eh_target_reset_handler = ibmvfc_eh_target_reset_handler,
 	.eh_host_reset_handler = ibmvfc_eh_host_reset_handler,
-	.slave_alloc = ibmvfc_slave_alloc,
+	.sdev_prep = ibmvfc_sdev_prep,
 	.slave_configure = ibmvfc_slave_configure,
 	.target_alloc = ibmvfc_target_alloc,
 	.scan_finished = ibmvfc_scan_finished,
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 2519fb7aee51..9839b23c684b 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -1113,7 +1113,7 @@ static struct scsi_host_template imm_template = {
 	.this_id		= 7,
 	.sg_tablesize		= SG_ALL,
 	.can_queue		= 1,
-	.slave_alloc		= imm_adjust_queue,
+	.sdev_prep		= imm_adjust_queue,
 };
 
 /***************************************************************************
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 7d86f4ca266c..2920b4c48896 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4970,7 +4970,7 @@ static int ipr_slave_configure(struct scsi_device *sdev)
 }
 
 /**
- * ipr_ata_slave_alloc - Prepare for commands to a SATA device
+ * ipr_ata_sdev_prep - Prepare for commands to a SATA device
  * @sdev:	scsi device struct
  *
  * This function initializes an ATA port so that future commands
@@ -4979,7 +4979,7 @@ static int ipr_slave_configure(struct scsi_device *sdev)
  * Return value:
  * 	0 on success
  **/
-static int ipr_ata_slave_alloc(struct scsi_device *sdev)
+static int ipr_ata_sdev_prep(struct scsi_device *sdev)
 {
 	struct ipr_sata_port *sata_port = NULL;
 	int rc = -ENXIO;
@@ -5001,7 +5001,7 @@ static int ipr_ata_slave_alloc(struct scsi_device *sdev)
 }
 
 /**
- * ipr_slave_alloc - Prepare for commands to a device.
+ * ipr_sdev_prep - Prepare for commands to a device.
  * @sdev:	scsi device struct
  *
  * This function saves a pointer to the resource entry
@@ -5012,7 +5012,7 @@ static int ipr_ata_slave_alloc(struct scsi_device *sdev)
  * Return value:
  * 	0 on success / -ENXIO if device does not exist
  **/
-static int ipr_slave_alloc(struct scsi_device *sdev)
+static int ipr_sdev_prep(struct scsi_device *sdev)
 {
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) sdev->host->hostdata;
 	struct ipr_resource_entry *res;
@@ -5034,7 +5034,7 @@ static int ipr_slave_alloc(struct scsi_device *sdev)
 		rc = 0;
 		if (ipr_is_gata(res)) {
 			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-			return ipr_ata_slave_alloc(sdev);
+			return ipr_ata_sdev_prep(sdev);
 		}
 	}
 
@@ -6735,7 +6735,7 @@ static struct scsi_host_template driver_template = {
 	.eh_abort_handler = ipr_eh_abort,
 	.eh_device_reset_handler = ipr_eh_dev_reset,
 	.eh_host_reset_handler = ipr_eh_host_reset,
-	.slave_alloc = ipr_slave_alloc,
+	.sdev_prep = ipr_sdev_prep,
 	.slave_configure = ipr_slave_configure,
 	.slave_destroy = ipr_slave_destroy,
 	.scan_finished = ipr_scan_finished,
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index bf2cc9656e19..85ff7e18aa0c 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2226,13 +2226,13 @@ int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
 EXPORT_SYMBOL(fc_eh_host_reset);
 
 /**
- * fc_slave_alloc() - Configure the queue depth of a Scsi_Host
+ * fc_sdev_prep() - Configure the queue depth of a Scsi_Host
  * @sdev: The SCSI device that identifies the SCSI host
  *
  * Configures queue depth based on host's cmd_per_len. If not set
  * then we use the libfc default.
  */
-int fc_slave_alloc(struct scsi_device *sdev)
+int fc_sdev_prep(struct scsi_device *sdev)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 
@@ -2242,7 +2242,7 @@ int fc_slave_alloc(struct scsi_device *sdev)
 	scsi_change_queue_depth(sdev, FC_FCP_DFLT_QUEUE_DEPTH);
 	return 0;
 }
-EXPORT_SYMBOL(fc_slave_alloc);
+EXPORT_SYMBOL(fc_sdev_prep);
 
 /**
  * fc_fcp_destory() - Tear down the FCP layer for a given local port
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 5e802c8b22a9..6974665f5ade 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5493,7 +5493,7 @@ lpfc_host_reset_handler(struct scsi_cmnd *cmnd)
 }
 
 /**
- * lpfc_slave_alloc - scsi_host_template slave_alloc entry point
+ * lpfc_sdev_prep - scsi_host_template sdev_prep entry point
  * @sdev: Pointer to scsi_device.
  *
  * This routine populates the cmds_per_lun count + 2 scsi_bufs into  this host's
@@ -5506,7 +5506,7 @@ lpfc_host_reset_handler(struct scsi_cmnd *cmnd)
  *   0 - Success
  **/
 static int
-lpfc_slave_alloc(struct scsi_device *sdev)
+lpfc_sdev_prep(struct scsi_device *sdev)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *) sdev->host->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
@@ -6006,7 +6006,7 @@ lpfc_no_handler(struct scsi_cmnd *cmnd)
 }
 
 static int
-lpfc_no_slave(struct scsi_device *sdev)
+lpfc_no_sdev(struct scsi_device *sdev)
 {
 	return -ENODEV;
 }
@@ -6022,8 +6022,8 @@ struct scsi_host_template lpfc_template_nvme = {
 	.eh_target_reset_handler = lpfc_no_handler,
 	.eh_bus_reset_handler	= lpfc_no_handler,
 	.eh_host_reset_handler  = lpfc_no_handler,
-	.slave_alloc		= lpfc_no_slave,
-	.slave_configure	= lpfc_no_slave,
+	.sdev_prep		= lpfc_no_sdev,
+	.slave_configure	= lpfc_no_sdev,
 	.scan_finished		= lpfc_scan_finished,
 	.this_id		= -1,
 	.sg_tablesize		= 1,
@@ -6046,7 +6046,7 @@ struct scsi_host_template lpfc_template = {
 	.eh_target_reset_handler = lpfc_target_reset_handler,
 	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
 	.eh_host_reset_handler  = lpfc_host_reset_handler,
-	.slave_alloc		= lpfc_slave_alloc,
+	.sdev_prep		= lpfc_sdev_prep,
 	.slave_configure	= lpfc_slave_configure,
 	.slave_destroy		= lpfc_slave_destroy,
 	.scan_finished		= lpfc_scan_finished,
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 00668335c2af..7f0f058c4a80 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2071,7 +2071,7 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
-static int megasas_slave_alloc(struct scsi_device *sdev)
+static int megasas_sdev_prep(struct scsi_device *sdev)
 {
 	u16 pd_index = 0;
 	struct megasas_instance *instance ;
@@ -3414,7 +3414,7 @@ static struct scsi_host_template megasas_template = {
 	.name = "Avago SAS based MegaRAID driver",
 	.proc_name = "megaraid_sas",
 	.slave_configure = megasas_slave_configure,
-	.slave_alloc = megasas_slave_alloc,
+	.sdev_prep = megasas_sdev_prep,
 	.slave_destroy = megasas_slave_destroy,
 	.queuecommand = megasas_queue_command,
 	.eh_target_reset_handler = megasas_reset_target,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 08fc4b381056..b46a5d6c3f7e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1799,14 +1799,14 @@ scsih_target_destroy(struct scsi_target *starget)
 }
 
 /**
- * scsih_slave_alloc - device add routine
+ * scsih_sdev_prep - device add routine
  * @sdev: scsi device struct
  *
  * Return: 0 if ok. Any other return is assumed to be an error and
  * the device is ignored.
  */
 static int
-scsih_slave_alloc(struct scsi_device *sdev)
+scsih_sdev_prep(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost;
 	struct MPT3SAS_ADAPTER *ioc;
@@ -10427,7 +10427,7 @@ static struct scsi_host_template mpt2sas_driver_template = {
 	.proc_name			= MPT2SAS_DRIVER_NAME,
 	.queuecommand			= scsih_qcmd,
 	.target_alloc			= scsih_target_alloc,
-	.slave_alloc			= scsih_slave_alloc,
+	.sdev_prep			= scsih_sdev_prep,
 	.slave_configure		= scsih_slave_configure,
 	.target_destroy			= scsih_target_destroy,
 	.slave_destroy			= scsih_slave_destroy,
@@ -10465,7 +10465,7 @@ static struct scsi_host_template mpt3sas_driver_template = {
 	.proc_name			= MPT3SAS_DRIVER_NAME,
 	.queuecommand			= scsih_qcmd,
 	.target_alloc			= scsih_target_alloc,
-	.slave_alloc			= scsih_slave_alloc,
+	.sdev_prep			= scsih_sdev_prep,
 	.slave_configure		= scsih_slave_configure,
 	.target_destroy			= scsih_target_destroy,
 	.slave_destroy			= scsih_slave_destroy,
diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index d4bd31a75b9d..2d3ffd79076a 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1647,7 +1647,7 @@ static int myrb_queuecommand(struct Scsi_Host *shost,
 	return myrb_pthru_queuecommand(shost, scmd);
 }
 
-static int myrb_ldev_slave_alloc(struct scsi_device *sdev)
+static int myrb_ldev_sdev_prep(struct scsi_device *sdev)
 {
 	struct myrb_hba *cb = shost_priv(sdev->host);
 	struct myrb_ldev_info *ldev_info;
@@ -1693,7 +1693,7 @@ static int myrb_ldev_slave_alloc(struct scsi_device *sdev)
 	return 0;
 }
 
-static int myrb_pdev_slave_alloc(struct scsi_device *sdev)
+static int myrb_pdev_sdev_prep(struct scsi_device *sdev)
 {
 	struct myrb_hba *cb = shost_priv(sdev->host);
 	struct myrb_pdev_state *pdev_info;
@@ -1729,7 +1729,7 @@ static int myrb_pdev_slave_alloc(struct scsi_device *sdev)
 	return 0;
 }
 
-static int myrb_slave_alloc(struct scsi_device *sdev)
+static int myrb_sdev_prep(struct scsi_device *sdev)
 {
 	if (sdev->channel > myrb_logical_channel(sdev->host))
 		return -ENXIO;
@@ -1738,9 +1738,9 @@ static int myrb_slave_alloc(struct scsi_device *sdev)
 		return -ENXIO;
 
 	if (sdev->channel == myrb_logical_channel(sdev->host))
-		return myrb_ldev_slave_alloc(sdev);
+		return myrb_ldev_sdev_prep(sdev);
 
-	return myrb_pdev_slave_alloc(sdev);
+	return myrb_pdev_sdev_prep(sdev);
 }
 
 static int myrb_slave_configure(struct scsi_device *sdev)
@@ -2232,7 +2232,7 @@ struct scsi_host_template myrb_template = {
 	.proc_name		= "myrb",
 	.queuecommand		= myrb_queuecommand,
 	.eh_host_reset_handler	= myrb_host_reset,
-	.slave_alloc		= myrb_slave_alloc,
+	.sdev_prep		= myrb_sdev_prep,
 	.slave_configure	= myrb_slave_configure,
 	.slave_destroy		= myrb_slave_destroy,
 	.bios_param		= myrb_biosparam,
diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 5c5666491c2e..6e8882bda8b8 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1790,7 +1790,7 @@ static unsigned short myrs_translate_ldev(struct myrs_hba *cs,
 	return ldev_num;
 }
 
-static int myrs_slave_alloc(struct scsi_device *sdev)
+static int myrs_sdev_prep(struct scsi_device *sdev)
 {
 	struct myrs_hba *cs = shost_priv(sdev->host);
 	unsigned char status;
@@ -1925,7 +1925,7 @@ struct scsi_host_template myrs_template = {
 	.proc_name		= "myrs",
 	.queuecommand		= myrs_queuecommand,
 	.eh_host_reset_handler	= myrs_host_reset,
-	.slave_alloc		= myrs_slave_alloc,
+	.sdev_prep		= myrs_sdev_prep,
 	.slave_configure	= myrs_slave_configure,
 	.slave_destroy		= myrs_slave_destroy,
 	.cmd_size		= sizeof(struct myrs_cmdblk),
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index f88adab3f913..ee727b1511a1 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -7952,7 +7952,7 @@ static void __init ncr_getclock (struct ncb *np, int mult)
 
 /*===================== LINUX ENTRY POINTS SECTION ==========================*/
 
-static int ncr53c8xx_slave_alloc(struct scsi_device *device)
+static int ncr53c8xx_sdev_prep(struct scsi_device *device)
 {
 	struct Scsi_Host *host = device->host;
 	struct ncb *np = ((struct host_data *) host->hostdata)->ncb;
@@ -8299,7 +8299,7 @@ struct Scsi_Host * __init ncr_attach(struct scsi_host_template *tpnt,
 
 	tpnt->queuecommand	= ncr53c8xx_queue_command;
 	tpnt->slave_configure	= ncr53c8xx_slave_configure;
-	tpnt->slave_alloc	= ncr53c8xx_slave_alloc;
+	tpnt->sdev_prep	= ncr53c8xx_sdev_prep;
 	tpnt->eh_bus_reset_handler = ncr53c8xx_bus_reset;
 	tpnt->can_queue		= SCSI_NCR_CAN_QUEUE;
 	tpnt->this_id		= 7;
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index aa9ae2ae8579..e160c128d3e8 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -123,7 +123,7 @@ MODULE_DEVICE_TABLE(pci, pmcraid_pci_table);
 
 
 /**
- * pmcraid_slave_alloc - Prepare for commands to a device
+ * pmcraid_sdev_prep - Prepare for commands to a device
  * @scsi_dev: scsi device struct
  *
  * This function is called by mid-layer prior to sending any command to the new
@@ -134,7 +134,7 @@ MODULE_DEVICE_TABLE(pci, pmcraid_pci_table);
  * Return value:
  *	  0 on success / -ENXIO if device does not exist
  */
-static int pmcraid_slave_alloc(struct scsi_device *scsi_dev)
+static int pmcraid_sdev_prep(struct scsi_device *scsi_dev)
 {
 	struct pmcraid_resource_entry *temp, *res = NULL;
 	struct pmcraid_instance *pinstance;
@@ -250,7 +250,7 @@ static int pmcraid_slave_configure(struct scsi_device *scsi_dev)
  * @scsi_dev: scsi device struct
  *
  * This is called by mid-layer before removing a device. Pointer assignments
- * done in pmcraid_slave_alloc will be reset to NULL here.
+ * done in pmcraid_sdev_prep will be reset to NULL here.
  *
  * Return value
  *   none
@@ -4120,7 +4120,7 @@ static struct scsi_host_template pmcraid_host_template = {
 	.eh_device_reset_handler = pmcraid_eh_device_reset_handler,
 	.eh_host_reset_handler = pmcraid_eh_host_reset_handler,
 
-	.slave_alloc = pmcraid_slave_alloc,
+	.sdev_prep = pmcraid_sdev_prep,
 	.slave_configure = pmcraid_slave_configure,
 	.slave_destroy = pmcraid_slave_destroy,
 	.change_queue_depth = pmcraid_change_queue_depth,
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index a406cc825426..fabcb71a17aa 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -980,7 +980,7 @@ static struct scsi_host_template ppa_template = {
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.can_queue		= 1,
-	.slave_alloc		= ppa_adjust_queue,
+	.sdev_prep		= ppa_adjust_queue,
 };
 
 /***************************************************************************
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9b59f032a569..807db94cf148 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1838,7 +1838,7 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 }
 
 static int
-qla2xxx_slave_alloc(struct scsi_device *sdev)
+qla2xxx_sdev_prep(struct scsi_device *sdev)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 
@@ -7767,7 +7767,7 @@ struct scsi_host_template qla2xxx_driver_template = {
 
 	.slave_configure	= qla2xxx_slave_configure,
 
-	.slave_alloc		= qla2xxx_slave_alloc,
+	.sdev_prep		= qla2xxx_sdev_prep,
 	.slave_destroy		= qla2xxx_slave_destroy,
 	.scan_finished		= qla2xxx_scan_finished,
 	.scan_start		= qla2xxx_scan_start,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 5dc697ce8b5d..c4d2b8f3700d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -161,7 +161,7 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd);
-static int qla4xxx_slave_alloc(struct scsi_device *device);
+static int qla4xxx_sdev_prep(struct scsi_device *device);
 static umode_t qla4_attr_is_visible(int param_type, int param);
 static int qla4xxx_host_reset(struct Scsi_Host *shost, int reset_type);
 
@@ -200,7 +200,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.eh_host_reset_handler	= qla4xxx_eh_host_reset,
 	.eh_timed_out		= qla4xxx_eh_cmd_timed_out,
 
-	.slave_alloc		= qla4xxx_slave_alloc,
+	.sdev_prep		= qla4xxx_sdev_prep,
 	.change_queue_depth	= scsi_change_queue_depth,
 
 	.this_id		= -1,
@@ -9030,7 +9030,7 @@ static void qla4xxx_config_dma_addressing(struct scsi_qla_host *ha)
 	}
 }
 
-static int qla4xxx_slave_alloc(struct scsi_device *sdev)
+static int qla4xxx_sdev_prep(struct scsi_device *sdev)
 {
 	struct iscsi_cls_session *cls_sess;
 	struct iscsi_session *sess;
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 4692f5b6ad13..bb914e2e7554 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4969,10 +4969,10 @@ static struct sdebug_dev_info *find_build_dev_info(struct scsi_device *sdev)
 	return open_devip;
 }
 
-static int scsi_debug_slave_alloc(struct scsi_device *sdp)
+static int scsi_debug_sdev_prep(struct scsi_device *sdp)
 {
 	if (sdebug_verbose)
-		pr_info("slave_alloc <%u %u %u %llu>\n",
+		pr_info("sdev_prep <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	return 0;
 }
@@ -7221,7 +7221,7 @@ static struct scsi_host_template sdebug_driver_template = {
 	.proc_name =		sdebug_proc_name,
 	.name =			"SCSI DEBUG",
 	.info =			scsi_debug_info,
-	.slave_alloc =		scsi_debug_slave_alloc,
+	.sdev_prep =		scsi_debug_sdev_prep,
 	.slave_configure =	scsi_debug_slave_configure,
 	.slave_destroy =	scsi_debug_slave_destroy,
 	.ioctl =		scsi_debug_ioctl,
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f2437a7570ce..ccd9fb11d305 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -202,7 +202,7 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
  * scsi_alloc_sdev - allocate and setup a scsi_Device
  * @starget: which target to allocate a &scsi_device for
  * @lun: which lun
- * @hostdata: usually NULL and set by ->slave_alloc instead
+ * @hostdata: usually NULL and set by ->sdev_prep instead
  *
  * Description:
  *     Allocate, initialize for io, and return a pointer to a scsi_Device.
@@ -246,7 +246,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	sdev->sdev_gendev.parent = get_device(&starget->dev);
 	sdev->sdev_target = starget;
 
-	/* usually NULL and set by ->slave_alloc instead */
+	/* usually NULL and set by ->sdev_prep instead */
 	sdev->hostdata = hostdata;
 
 	/* if the device needs this changing, it may do so in the
@@ -281,11 +281,11 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 
 	scsi_sysfs_device_initialize(sdev);
 
-	if (shost->hostt->slave_alloc) {
-		ret = shost->hostt->slave_alloc(sdev);
+	if (shost->hostt->sdev_prep) {
+		ret = shost->hostt->sdev_prep(sdev);
 		if (ret) {
 			/*
-			 * if LLDD reports slave not present, don't clutter
+			 * if LLDD reports sdev not present, don't clutter
 			 * console with alloc failure messages
 			 */
 			if (ret == -ENXIO)
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index cd157f11eb22..ec3bf36b874d 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5778,7 +5778,7 @@ static int pqi_eh_device_reset_handler(struct scsi_cmnd *scmd)
 	return rc;
 }
 
-static int pqi_slave_alloc(struct scsi_device *sdev)
+static int pqi_sdev_prep(struct scsi_device *sdev)
 {
 	struct pqi_scsi_dev *device;
 	unsigned long flags;
@@ -6500,7 +6500,7 @@ static struct scsi_host_template pqi_driver_template = {
 	.this_id = -1,
 	.eh_device_reset_handler = pqi_eh_device_reset_handler,
 	.ioctl = pqi_ioctl,
-	.slave_alloc = pqi_slave_alloc,
+	.sdev_prep = pqi_sdev_prep,
 	.map_queues = pqi_map_queues,
 	.sdev_attrs = pqi_sdev_attrs,
 	.shost_attrs = pqi_shost_attrs,
diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index 14f4ce665e58..f74fa7fdbffc 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -56,11 +56,11 @@ module_param(snic_max_qdepth, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(snic_max_qdepth, "Queue depth to report for each LUN");
 
 /*
- * snic_slave_alloc : callback function to SCSI Mid Layer, called on
+ * snic_sdev_prep : callback function to SCSI Mid Layer, called on
  * scsi device initialization.
  */
 static int
-snic_slave_alloc(struct scsi_device *sdev)
+snic_sdev_prep(struct scsi_device *sdev)
 {
 	struct snic_tgt *tgt = starget_to_tgt(scsi_target(sdev));
 
@@ -121,7 +121,7 @@ static struct scsi_host_template snic_host_template = {
 	.eh_abort_handler = snic_abort_cmd,
 	.eh_device_reset_handler = snic_device_reset,
 	.eh_host_reset_handler = snic_host_reset,
-	.slave_alloc = snic_slave_alloc,
+	.sdev_prep = snic_sdev_prep,
 	.slave_configure = snic_slave_configure,
 	.change_queue_depth = snic_change_queue_depth,
 	.this_id = -1,
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 7b686268ad19..5dba63b52e49 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1769,7 +1769,7 @@ static struct scsi_host_template scsi_driver = {
 	.eh_host_reset_handler =	storvsc_host_reset_handler,
 	.proc_name =		"storvsc_host",
 	.eh_timed_out =		storvsc_eh_timed_out,
-	.slave_alloc =		storvsc_device_alloc,
+	.sdev_prep =		storvsc_device_alloc,
 	.slave_configure =	storvsc_device_configure,
 	.cmd_per_lun =		2048,
 	.this_id =		-1,
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 2ca018ce796f..4d59783ed465 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -721,7 +721,7 @@ static void sym_tune_dev_queuing(struct sym_tcb *tp, int lun, u_short reqtags)
 	}
 }
 
-static int sym53c8xx_slave_alloc(struct scsi_device *sdev)
+static int sym53c8xx_sdev_prep(struct scsi_device *sdev)
 {
 	struct sym_hcb *np = sym_get_hcb(sdev->host);
 	struct sym_tcb *tp = &np->target[sdev->id];
@@ -824,7 +824,7 @@ static void sym53c8xx_slave_destroy(struct scsi_device *sdev)
 	struct sym_lcb *lp = sym_lp(tp, sdev->lun);
 	unsigned long flags;
 
-	/* if slave_alloc returned before allocating a sym_lcb, return */
+	/* if sdev_prep returned before allocating a sym_lcb, return */
 	if (!lp)
 		return;
 
@@ -1639,7 +1639,7 @@ static struct scsi_host_template sym2_template = {
 	.name			= "sym53c8xx",
 	.info			= sym53c8xx_info, 
 	.queuecommand		= sym53c8xx_queue_command,
-	.slave_alloc		= sym53c8xx_slave_alloc,
+	.sdev_prep		= sym53c8xx_sdev_prep,
 	.slave_configure	= sym53c8xx_slave_configure,
 	.slave_destroy		= sym53c8xx_slave_destroy,
 	.eh_abort_handler	= sym53c8xx_eh_abort_handler,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 59358bb75014..58cd8a609b31 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4607,12 +4607,12 @@ static inline void ufshcd_get_lu_power_on_wp_status(struct ufs_hba *hba,
 }
 
 /**
- * ufshcd_slave_alloc - handle initial SCSI device configurations
+ * ufshcd_sdev_prep - handle initial SCSI device configurations
  * @sdev: pointer to SCSI device
  *
  * Returns success
  */
-static int ufshcd_slave_alloc(struct scsi_device *sdev)
+static int ufshcd_sdev_prep(struct scsi_device *sdev)
 {
 	struct ufs_hba *hba;
 
@@ -7489,7 +7489,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.name			= UFSHCD,
 	.proc_name		= UFSHCD,
 	.queuecommand		= ufshcd_queuecommand,
-	.slave_alloc		= ufshcd_slave_alloc,
+	.sdev_prep		= ufshcd_sdev_prep,
 	.slave_configure	= ufshcd_slave_configure,
 	.slave_destroy		= ufshcd_slave_destroy,
 	.change_queue_depth	= ufshcd_change_queue_depth,
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 0e0910c5b942..fecc7bd5299a 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -737,7 +737,7 @@ static struct scsi_host_template virtscsi_host_template = {
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
 	.eh_timed_out = virtscsi_eh_timed_out,
-	.slave_alloc = virtscsi_device_alloc,
+	.sdev_prep = virtscsi_device_alloc,
 
 	.dma_boundary = UINT_MAX,
 	.map_queues = virtscsi_map_queues,
diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index be0053c795b7..562f1b4bc159 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -57,7 +57,7 @@ static const char *host_info(struct Scsi_Host *host)
 	return "SCSI emulation for PCI-Express Mass Storage devices";
 }
 
-static int slave_alloc(struct scsi_device *sdev)
+static int sdev_prep(struct scsi_device *sdev)
 {
 	/*
 	 * Set the INQUIRY transfer length to 36.  We don't use any of
@@ -217,7 +217,7 @@ static struct scsi_host_template rtsx_host_template = {
 	/* unknown initiator id */
 	.this_id =			-1,
 
-	.slave_alloc =			slave_alloc,
+	.sdev_prep =			sdev_prep,
 	.slave_configure =		slave_configure,
 
 	/* lots of sg segments can be handled */
diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c b/drivers/staging/unisys/visorhba/visorhba_main.c
index 99c57ceeb357..b6023fcc7908 100644
--- a/drivers/staging/unisys/visorhba/visorhba_main.c
+++ b/drivers/staging/unisys/visorhba/visorhba_main.c
@@ -579,7 +579,7 @@ static DEF_SCSI_QCMD(visorhba_queue_command)
 #endif
 
 /*
- * visorhba_slave_alloc - Called when new disk is discovered
+ * visorhba_sdev_prep - Called when new disk is discovered
  * @scsidev: New disk
  *
  * Create a new visordisk_info structure and add it to our
@@ -587,7 +587,7 @@ static DEF_SCSI_QCMD(visorhba_queue_command)
  *
  * Return: 0 on success, -ENOMEM on failure.
  */
-static int visorhba_slave_alloc(struct scsi_device *scsidev)
+static int visorhba_sdev_prep(struct scsi_device *scsidev)
 {
 	/* this is called by the midlayer before scan for new devices --
 	 * LLD can alloc any struct & do init if needed.
@@ -643,7 +643,7 @@ static struct scsi_host_template visorhba_driver_template = {
 	.can_queue = visorhba_MAX_CMNDS,
 	.sg_tablesize = 64,
 	.this_id = -1,
-	.slave_alloc = visorhba_slave_alloc,
+	.sdev_prep = visorhba_sdev_prep,
 	.slave_destroy = visorhba_slave_destroy,
 };
 
diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 360416680e82..4cb6124b4d18 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -318,7 +318,7 @@ static inline void mts_urb_abort(struct mts_desc* desc) {
 	usb_kill_urb( desc->urb );
 }
 
-static int mts_slave_alloc (struct scsi_device *s)
+static int mts_sdev_prep (struct scsi_device *s)
 {
 	s->inquiry_len = 0x24;
 	return 0;
@@ -628,7 +628,7 @@ static struct scsi_host_template mts_scsi_host_template = {
 	.can_queue =		1,
 	.this_id =		-1,
 	.emulated =		1,
-	.slave_alloc =		mts_slave_alloc,
+	.sdev_prep =		mts_sdev_prep,
 	.slave_configure =	mts_slave_configure,
 	.max_sectors=		256, /* 128 K */
 };
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index f4c2359abb1b..8bd17467a55e 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -65,7 +65,7 @@ static const char* host_info(struct Scsi_Host *host)
 	return us->scsi_name;
 }
 
-static int slave_alloc (struct scsi_device *sdev)
+static int sdev_prep (struct scsi_device *sdev)
 {
 	struct us_data *us = host_to_us(sdev->host);
 
@@ -140,7 +140,7 @@ static int slave_configure(struct scsi_device *sdev)
 		blk_queue_bounce_limit(sdev->request_queue, BLK_BOUNCE_HIGH);
 
 	/*
-	 * We can't put these settings in slave_alloc() because that gets
+	 * We can't put these settings in sdev_prep() because that gets
 	 * called before the device type is known.  Consequently these
 	 * settings can't be overridden via the scsi devinfo mechanism.
 	 */
@@ -619,7 +619,7 @@ static const struct scsi_host_template usb_stor_host_template = {
 	/* unknown initiator id */
 	.this_id =			-1,
 
-	.slave_alloc =			slave_alloc,
+	.sdev_prep =			sdev_prep,
 	.slave_configure =		slave_configure,
 	.target_alloc =			target_alloc,
 
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index d592071119ba..329d1c26b710 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -813,7 +813,7 @@ static int uas_target_alloc(struct scsi_target *starget)
 	return 0;
 }
 
-static int uas_slave_alloc(struct scsi_device *sdev)
+static int uas_sdev_prep(struct scsi_device *sdev)
 {
 	struct uas_dev_info *devinfo =
 		(struct uas_dev_info *)sdev->host->hostdata;
@@ -892,7 +892,7 @@ static struct scsi_host_template uas_host_template = {
 	.name = "uas",
 	.queuecommand = uas_queuecommand,
 	.target_alloc = uas_target_alloc,
-	.slave_alloc = uas_slave_alloc,
+	.sdev_prep = uas_sdev_prep,
 	.slave_configure = uas_slave_configure,
 	.eh_abort_handler = uas_eh_abort_handler,
 	.eh_device_reset_handler = uas_eh_device_reset_handler,
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 9b87e1a1c646..e50ddc7a2210 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -942,7 +942,7 @@ int fc_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int fc_eh_abort(struct scsi_cmnd *);
 int fc_eh_device_reset(struct scsi_cmnd *);
 int fc_eh_host_reset(struct scsi_cmnd *);
-int fc_slave_alloc(struct scsi_device *);
+int fc_sdev_prep(struct scsi_device *);
 
 /*
  * ELS/CT interface
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 4e2d61e8fb1e..2d6afa200c8b 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -695,7 +695,7 @@ int sas_eh_device_reset_handler(struct scsi_cmnd *cmd);
 int sas_eh_target_reset_handler(struct scsi_cmnd *cmd);
 
 extern void sas_target_destroy(struct scsi_target *);
-extern int sas_slave_alloc(struct scsi_device *);
+extern int sas_sdev_prep(struct scsi_device *);
 extern int sas_ioctl(struct scsi_device *sdev, unsigned int cmd,
 		     void __user *arg);
 extern int sas_drain_work(struct sas_ha_struct *ha);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index bc5909033d13..0db2506c8d0d 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -148,7 +148,7 @@ struct scsi_device {
 
 	blist_flags_t		sdev_bflags; /* black/white flags as also found in
 				 * scsi_devinfo.[hc]. For now used only to
-				 * pass settings from slave_alloc to scsi
+				 * pass settings from sdev_prep to scsi
 				 * core. */
 	unsigned int eh_timeout; /* Error handling timeout */
 	unsigned removable:1;
@@ -310,7 +310,7 @@ struct scsi_target {
 	atomic_t		target_blocked;
 
 	/*
-	 * LLDs should set this in the slave_alloc host template callout.
+	 * LLDs should set this in the sdev_prep host template callout.
 	 * If set to zero then there is not limit.
 	 */
 	unsigned int		can_queue;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 46ef8cccc982..8e44d61b6f47 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -161,7 +161,7 @@ struct scsi_host_template {
 	 *
 	 * Status: OPTIONAL
 	 */
-	int (* slave_alloc)(struct scsi_device *);
+	int (* sdev_prep)(struct scsi_device *);
 
 	/*
 	 * Once the device has responded to an INQUIRY and we know the
@@ -199,7 +199,7 @@ struct scsi_host_template {
 	 * has ceased the mid layer calls this point so that the low level
 	 * driver may completely detach itself from the scsi device and vice
 	 * versa.  The low level driver is responsible for freeing any memory
-	 * it allocated in the slave_alloc or slave_configure calls. 
+	 * it allocated in the sdev_prep or slave_configure calls. 
 	 *
 	 * Status: OPTIONAL
 	 */
-- 
2.27.0

