From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RFC 7/n] HCIL drivers update
Date: Sun, 23 Oct 2005 23:49:22 -0400
Message-ID: <20051024034922.GA28581@havoc.gtf.org>
References: <20051023024104.GA20128@havoc.gtf.org> <20051023195128.GA12102@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:48364 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1750937AbVJXDtX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 23:49:23 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 67EE81C09616
	for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2005 23:49:22 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9O3nMcE028609
	for linux-scsi@vger.kernel.org; Sun, 23 Oct 2005 23:49:22 -0400
Content-Disposition: inline
In-Reply-To: <20051023195128.GA12102@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


More sdev->{command,id,lun} work.  DO NOT APPLY.

 drivers/block/cciss_scsi.c        |   51 ++++++++-----
 drivers/block/cciss_scsi.h        |    3 
 drivers/ieee1394/sbp2.c           |    2 
 drivers/message/fusion/mptsas.c   |    4 -
 drivers/message/fusion/mptscsih.c |  100 +++++++++++++++-----------
 drivers/scsi/53c700.c             |  144 ++++++++++++++++++++------------------
 drivers/scsi/53c700.h             |    6 -
 drivers/scsi/a100u2w.c            |    8 +-
 drivers/scsi/aha152x.c            |   25 +++---
 drivers/scsi/aha1542.c            |   11 +-
 drivers/scsi/aha1740.c            |    4 -
 drivers/scsi/atp870u.c            |   24 +++---
 drivers/scsi/dc395x.c             |   96 +++++++++++++------------
 drivers/scsi/gdth.c               |   31 ++++----
 drivers/scsi/gdth_proc.c          |   12 +--
 drivers/scsi/ibmmca.c             |   54 ++++++++------
 drivers/scsi/ide-scsi.c           |    3 
 drivers/scsi/initio.c             |    8 +-
 drivers/scsi/tmscsim.c            |   12 +--
 drivers/usb/image/microtek.c      |   14 ++-
 20 files changed, 347 insertions(+), 265 deletions(-)

7ead5490dde9e4d85151077566e9f28518d535bf
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index e183a3e..e7a6190 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -330,7 +330,7 @@ print_cmd(CommandList_struct *cp)
 #endif
 
 static int 
-find_bus_target_lun(int ctlr, int *bus, int *target, int *lun)
+find_bus_target_lun(int ctlr, int *bus, int *target, struct scsi_lun *lun)
 {
 	/* finds an unused bus, target, lun for a new device */
 	/* assumes hba[ctlr]->scsi_ctlr->lock is held */ 
@@ -345,7 +345,10 @@ find_bus_target_lun(int ctlr, int *bus, 
 	
 	for (i=0;i<CCISS_MAX_SCSI_DEVS_PER_HBA;i++) {
 		if (!target_taken[i]) {
-			*bus = 0; *target=i; *lun = 0; found=1;
+			*bus = 0;
+			*target=i;
+			int_to_scsilun(0, lun);
+			found=1;
 			break;
 		}
 	}
@@ -375,10 +378,14 @@ cciss_scsi_add_entry(int ctlr, int hostn
 	/* initially, (before registering with scsi layer) we don't 
 	   know our hostno and we don't want to print anything first 
 	   time anyway (the scsi layer's inquiries will show that info) */
-	if (hostno != -1)
-		printk("cciss%d: %s device c%db%dt%dl%d added.\n", 
+	if (hostno != -1) {
+		char lunstr[SCSILUN_STR_LEN];
+
+		printk("cciss%d: %s device c%db%dt%dl%s added.\n", 
 			ctlr, DEVICETYPE(sd->devtype), hostno, 
-			sd->bus, sd->target, sd->lun);
+			sd->bus, sd->target,
+			scsilun_to_str(&sd->lun, lunstr));
+	}
 	return 0;
 }
 
@@ -388,15 +395,17 @@ cciss_scsi_remove_entry(int ctlr, int ho
 	/* assumes hba[ctlr]->scsi_ctlr->lock is held */ 
 	int i;
 	struct cciss_scsi_dev_t sd;
+	char lunstr[SCSILUN_STR_LEN];
 
 	if (entry < 0 || entry >= CCISS_MAX_SCSI_DEVS_PER_HBA) return;
 	sd = ccissscsi[ctlr].dev[entry];
 	for (i=entry;i<ccissscsi[ctlr].ndevices-1;i++)
 		ccissscsi[ctlr].dev[i] = ccissscsi[ctlr].dev[i+1];
 	ccissscsi[ctlr].ndevices--;
-	printk("cciss%d: %s device c%db%dt%dl%d removed.\n",
+	printk("cciss%d: %s device c%db%dt%dl%s removed.\n",
 		ctlr, DEVICETYPE(sd.devtype), hostno, 
-			sd.bus, sd.target, sd.lun);
+			sd.bus, sd.target,
+			scsilun_to_str(&sd.lun, lunstr));
 }
 
 
@@ -452,11 +461,14 @@ adjust_cciss_scsi_table(int ctlr, int ho
 			/* note, i not incremented */
 		} 
 		else if (found == 1) { /* device is different kind */
+			char lunstr[SCSILUN_STR_LEN];
+
 			changes++;
-			printk("cciss%d: device c%db%dt%dl%d type changed "
+			printk("cciss%d: device c%db%dt%dl%s type changed "
 				"(device type now %s).\n",
-				ctlr, hostno, csd->bus, csd->target, csd->lun,
-					DEVICETYPE(csd->devtype));
+				ctlr, hostno, csd->bus, csd->target,
+				scsilun_to_str(&csd->lun, lunstr),
+				DEVICETYPE(csd->devtype));
 			csd->devtype = sd[j].devtype;
 			i++;	/* so just move along. */
 		} else 		/* device is same as it ever was, */
@@ -501,7 +513,8 @@ adjust_cciss_scsi_table(int ctlr, int ho
 }
 
 static int
-lookup_scsi3addr(int ctlr, int bus, int target, int lun, char *scsi3addr)
+lookup_scsi3addr(int ctlr, int bus, int target, const struct scsi_lun *lun,
+		char *scsi3addr)
 {
 	int i;
 	struct cciss_scsi_dev_t *sd;
@@ -512,7 +525,7 @@ lookup_scsi3addr(int ctlr, int bus, int 
 		sd = &ccissscsi[ctlr].dev[i];
 		if (sd->bus == bus &&
 		    sd->target == target &&
-		    sd->lun == lun) {
+		    scsilun_eq(&sd->lun, lun)) {
 			memcpy(scsi3addr, &sd->scsi3addr[0], 8);
 			CPQ_TAPE_UNLOCK(ctlr, flags);
 			return 0;
@@ -1095,7 +1108,7 @@ cciss_update_non_disk_devices(int cntl_n
 			currentsd[ncurrent].devtype = devtype;
 			currentsd[ncurrent].bus = -1;
 			currentsd[ncurrent].target = -1;
-			currentsd[ncurrent].lun = -1;
+			int_to_scsilun(0xffffffff, &currentsd[ncurrent].lun);
 			ncurrent++;
 			break;
 		  default: 
@@ -1167,10 +1180,13 @@ cciss_scsi_proc_info(struct Scsi_Host *s
 		   get them back in sync. */
 
 		for (i=0;i<ccissscsi[cntl_num].ndevices;i++) {
+			char lunstr[SCSILUN_STR_LEN];
+
 			struct cciss_scsi_dev_t *sd = &ccissscsi[cntl_num].dev[i];
-			buflen += sprintf(&buffer[buflen], "c%db%dt%dl%d %02d "
+			buflen += sprintf(&buffer[buflen], "c%db%dt%dl%s %02d "
 				"0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
-				sh->host_no, sd->bus, sd->target, sd->lun,
+				sh->host_no, sd->bus, sd->target,
+				scsilun_to_str(&sd->lun, lunstr),
 				sd->devtype,
 				sd->scsi3addr[0], sd->scsi3addr[1],
 				sd->scsi3addr[2], sd->scsi3addr[3],
@@ -1256,8 +1272,9 @@ cciss_scsi_queue_command (struct scsi_cm
 	c = (ctlr_info_t **) &cmd->device->host->hostdata[0];	
 	ctlr = (*c)->ctlr;
 
-	rc = lookup_scsi3addr(ctlr, cmd->device->channel, cmd->device->id, 
-			cmd->device->lun, scsi3addr);
+	rc = lookup_scsi3addr(ctlr, sdev_channel(cmd->device),
+			sdev_id(cmd->device),
+			&cmd->device->lun, scsi3addr);
 	if (rc != 0) {
 		/* the scsi nexus does not match any that we presented... */
 		/* pretend to mid layer that we got selection timeout */
diff --git a/drivers/block/cciss_scsi.h b/drivers/block/cciss_scsi.h
index 5e7e06c..783217e 100644
--- a/drivers/block/cciss_scsi.h
+++ b/drivers/block/cciss_scsi.h
@@ -64,7 +64,8 @@ driver, I suppose.
 
 struct cciss_scsi_dev_t {
 	int devtype;
-	int bus, target, lun;		/* as presented to the OS */
+	int bus, target;		/* as presented to the OS */
+	struct scsi_lun lun;
 	unsigned char scsi3addr[8];	/* as presented to the HW */
 };
 
diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index 12cec7c..87d381d 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -2513,7 +2513,7 @@ static int sbp2scsi_queuecommand(struct 
 	 * Until we handle multiple luns, just return selection time-out
 	 * to any IO directed at non-zero LUNs
 	 */
-	if (SCpnt->device->lun)
+	if (!scsilun_zero(&SCpnt->device->lun))
 		goto done;
 
 	/*
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 7de19a8..7b45b4c 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -136,7 +136,7 @@ mptsas_slave_alloc(struct scsi_device *d
 	struct sas_rphy		*rphy;
 	struct mptsas_portinfo	*p;
 	VirtDevice		*vdev;
-	uint			target = device->id;
+	uint			target = sdev_id(device);
 	int i;
 
 	if ((vdev = hd->Targets[target]) != NULL)
@@ -161,7 +161,7 @@ mptsas_slave_alloc(struct scsi_device *d
 				vdev->target_id =
 					p->phy_info[i].attached.target;
 				vdev->bus_id = p->phy_info[i].attached.bus;
-				hd->Targets[device->id] = vdev;
+				hd->Targets[sdev_id(device)] = vdev;
 				goto out;
 			}
 		}
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 5cb07eb..d1918ed 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -107,7 +107,7 @@ typedef struct _internal_cmd {
 	u8		cmd;		/* SCSI Op Code */
 	u8		bus;		/* bus number */
 	u8		id;		/* SCSI ID (virtual) */
-	u8		lun;
+	struct scsi_lun	lun;
 	u8		flags;		/* Bit Field - See above */
 	u8		physDiskNum;	/* Phys disk number, -1 else */
 	u8		rsvd2;
@@ -144,13 +144,13 @@ static int	mptscsih_tm_pending_wait(MPT_
 static int	mptscsih_tm_wait_for_completion(MPT_SCSI_HOST * hd, ulong timeout );
 static u32	SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc);
 
-static int	mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout);
-static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout);
+static int	mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, const struct scsi_lun *lun, int ctx2abort, ulong timeout);
+static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, const struct scsi_lun *lun, int ctx2abort, ulong timeout);
 
 int		mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 int		mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 
-static void	mptscsih_initTarget(MPT_SCSI_HOST *hd, int bus_id, int target_id, u8 lun, char *data, int dlen);
+static void	mptscsih_initTarget(MPT_SCSI_HOST *hd, int bus_id, int target_id, const struct scsi_lun *lun, char *data, int dlen);
 static void	mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtDevice *target, char byte56);
 static void	mptscsih_set_dvflags(MPT_SCSI_HOST *hd, SCSIIORequest_t *pReq);
 static void	mptscsih_setDevicePage1Flags (u8 width, u8 factor, u8 offset, int *requestedPtr, int *configurationPtr, u8 flags);
@@ -678,7 +678,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 
 			/* GEM Workaround. */
 			if (ioc->bus_type == SCSI)
-				mptscsih_no_negotiate(hd, sc->device->id);
+				mptscsih_no_negotiate(hd, sdev_id(sc->device));
 			break;
 
 		case MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:	/* 0x0049 */
@@ -901,12 +901,13 @@ mptscsih_flush_running_cmds(MPT_SCSI_HOS
  *	Called from slave_destroy.
  */
 static void
-mptscsih_search_running_cmds(MPT_SCSI_HOST *hd, uint target, uint lun)
+mptscsih_search_running_cmds(MPT_SCSI_HOST *hd, uint target, const struct scsi_lun *slun)
 {
 	SCSIIORequest_t	*mf = NULL;
 	int		 ii;
 	int		 max = hd->ioc->req_depth;
 	struct scsi_cmnd *sc;
+	unsigned int lun = scsilun_to_int(slun);
 
 	dsprintk((KERN_INFO MYNAM ": search_running target %d lun %d max %d\n",
 			target, lun, max));
@@ -974,8 +975,13 @@ mptscsih_report_queue_full(struct scsi_c
 		return;
 
 	if (time - hd->last_queue_full > 10 * HZ) {
-		dprintk((MYIOC_s_WARN_FMT "Device (%d:%d:%d) reported QUEUE_FULL!\n",
-				hd->ioc->name, 0, sc->device->id, sc->device->lun));
+		char lunstr[SCSILUN_STR_LEN];
+
+		(void) lunstr; /* kill unused-var warning, if debug disabled */
+
+		dprintk((MYIOC_s_WARN_FMT "Device (%d:%d:%s) reported QUEUE_FULL!\n",
+				hd->ioc->name, 0, sdev_id(sc->device),
+				scsilun_to_str(&sc->device->lun, lunstr)));
 		hd->last_queue_full = time;
 	}
 }
@@ -1289,7 +1295,7 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 	MPT_FRAME_HDR		*mf;
 	SCSIIORequest_t		*pScsiReq;
 	VirtDevice		*pTarget = SCpnt->device->hostdata;
-	int	 lun;
+	const struct scsi_lun *lun;
 	u32	 datalen;
 	u32	 scsictl;
 	u32	 scsidir;
@@ -1298,7 +1304,7 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 	int	 ii;
 
 	hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata;
-	lun = SCpnt->device->lun;
+	lun = &SCpnt->device->lun;
 	SCpnt->scsi_done = done;
 
 	dmfprintk((MYIOC_s_INFO_FMT "qcmd: SCpnt=%p, done()=%p\n",
@@ -1362,7 +1368,7 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 	pScsiReq->Reserved = 0;
 	pScsiReq->MsgFlags = mpt_msg_flags();
 	pScsiReq->LUN[0] = 0;
-	pScsiReq->LUN[1] = lun;
+	pScsiReq->LUN[1] = scsilun_to_int(lun);
 	pScsiReq->LUN[2] = 0;
 	pScsiReq->LUN[3] = 0;
 	pScsiReq->LUN[4] = 0;
@@ -1535,7 +1541,8 @@ mptscsih_freeChainBuffers(MPT_ADAPTER *i
  *	Returns 0 for SUCCESS or -1 if FAILED.
  */
 static int
-mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout)
+mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target,
+		const struct scsi_lun *lun, int ctx2abort, ulong timeout)
 {
 	MPT_ADAPTER	*ioc;
 	int		 rc = -1;
@@ -1656,7 +1663,8 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
  *	else other non-zero value returned.
  */
 static int
-mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout)
+mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target,
+			const struct scsi_lun *lun, int ctx2abort, ulong timeout)
 {
 	MPT_FRAME_HDR	*mf;
 	SCSITaskMgmt_t	*pScsiTm;
@@ -1690,7 +1698,7 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd
 	for (ii= 0; ii < 8; ii++) {
 		pScsiTm->LUN[ii] = 0;
 	}
-	pScsiTm->LUN[1] = lun;
+	pScsiTm->LUN[1] = scsilun_to_int(lun);
 
 	for (ii=0; ii < 7; ii++)
 		pScsiTm->Reserved2[ii] = 0;
@@ -1793,7 +1801,9 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 	hd->abortSCpnt = SCpnt;
 
 	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
-		SCpnt->device->channel, SCpnt->device->id, SCpnt->device->lun,
+		sdev_channel(SCpnt->device),
+		sdev_id(SCpnt->device),
+		&SCpnt->device->lun,
 		ctx2abort, 2 /* 2 second timeout */);
 
 	printk (KERN_WARNING MYNAM ": %s: task abort: %s (sc=%p)\n",
@@ -1824,6 +1834,7 @@ mptscsih_dev_reset(struct scsi_cmnd * SC
 {
 	MPT_SCSI_HOST	*hd;
 	int		 retval;
+	struct scsi_lun	lun0;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
@@ -1841,9 +1852,10 @@ mptscsih_dev_reset(struct scsi_cmnd * SC
 	       hd->ioc->name, SCpnt);
 	scsi_print_command(SCpnt);
 
+	int_to_scsilun(0, &lun0);
 	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
-		SCpnt->device->channel, SCpnt->device->id,
-		0, 0, 5 /* 5 second timeout */);
+		sdev_channel(SCpnt->device), sdev_id(SCpnt->device),
+		&lun0, 0, 5 /* 5 second timeout */);
 
 	printk (KERN_WARNING MYNAM ": %s: target reset: %s (sc=%p)\n",
 		hd->ioc->name,
@@ -1873,6 +1885,7 @@ mptscsih_bus_reset(struct scsi_cmnd * SC
 {
 	MPT_SCSI_HOST	*hd;
 	int		 retval;
+	struct scsi_lun	lun0;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
@@ -1890,8 +1903,10 @@ mptscsih_bus_reset(struct scsi_cmnd * SC
 	if (hd->timeouts < -1)
 		hd->timeouts++;
 
+	int_to_scsilun(0, &lun0);
 	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
-		SCpnt->device->channel, 0, 0, 0, 5 /* 5 second timeout */);
+		sdev_channel(SCpnt->device), 0, &lun0,
+		0, 5 /* 5 second timeout */);
 
 	printk (KERN_WARNING MYNAM ": %s: bus reset: %s (sc=%p)\n",
 		hd->ioc->name,
@@ -2163,7 +2178,7 @@ mptscsih_slave_alloc(struct scsi_device 
 	struct Scsi_Host	*host = device->host;
 	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
 	VirtDevice		*vdev;
-	uint			target = device->id;
+	uint			target = sdev_id(device);
 
 	if (hd == NULL)
 		return -ENODEV;
@@ -2181,15 +2196,15 @@ mptscsih_slave_alloc(struct scsi_device 
 	memset(vdev, 0, sizeof(VirtDevice));
 	vdev->tflags = MPT_TARGET_FLAGS_Q_YES;
 	vdev->ioc_id = hd->ioc->id;
-	vdev->target_id = device->id;
-	vdev->bus_id = device->channel;
+	vdev->target_id = sdev_id(device);
+	vdev->bus_id = sdev_channel(device);
 	vdev->raidVolume = 0;
-	hd->Targets[device->id] = vdev;
+	hd->Targets[sdev_id(device)] = vdev;
 	if (hd->ioc->bus_type == SCSI) {
-		if (hd->ioc->raid_data.isRaid & (1 << device->id)) {
+		if (hd->ioc->raid_data.isRaid & (1 << sdev_id(device))) {
 			vdev->raidVolume = 1;
 			ddvtprintk((KERN_INFO
-			    "RAID Volume @ id %d\n", device->id));
+			    "RAID Volume @ id %d\n", sdev_id(device)));
 		}
 	} else {
 		vdev->tflags |= MPT_TARGET_FLAGS_VALID_INQUIRY;
@@ -2211,8 +2226,8 @@ mptscsih_slave_destroy(struct scsi_devic
 	struct Scsi_Host	*host = device->host;
 	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
 	VirtDevice		*vdev;
-	uint			target = device->id;
-	uint			lun = device->lun;
+	uint			target = sdev_id(device);
+	const struct scsi_lun	*lun = &device->lun;
 
 	if (hd == NULL)
 		return;
@@ -2220,7 +2235,7 @@ mptscsih_slave_destroy(struct scsi_devic
 	mptscsih_search_running_cmds(hd, target, lun);
 
 	vdev = hd->Targets[target];
-	vdev->luns[0] &= ~(1 << lun);
+	vdev->luns[0] &= ~(1 << scsilun_to_int(lun));
 	if (--vdev->num_luns)
 		return;
 
@@ -2260,7 +2275,7 @@ mptscsih_change_queue_depth(struct scsi_
 
 	if (hd == NULL)
 		return 0;
-	if (!(pTarget = hd->Targets[sdev->id]))
+	if (!(pTarget = hd->Targets[sdev_id(sdev)]))
 		return 0;
 
 	if (hd->ioc->bus_type == SCSI) {
@@ -2315,13 +2330,13 @@ mptscsih_slave_configure(struct scsi_dev
 		hd->ioc->name, device->sdtr, device->wdtr,
 		device->ppr, device->inquiry_len));
 
-	if (device->id > sh->max_id) {
+	if (sdev_id(device) > sh->max_id) {
 		/* error case, should never happen */
 		scsi_adjust_queue_depth(device, 0, 1);
 		goto slave_configure_exit;
 	}
 
-	pTarget = hd->Targets[device->id];
+	pTarget = hd->Targets[sdev_id(device)];
 
 	if (pTarget == NULL) {
 		/* Driver doesn't know about this device.
@@ -2337,7 +2352,8 @@ mptscsih_slave_configure(struct scsi_dev
 		goto slave_configure_exit;
 	}
 
-	mptscsih_initTarget(hd, device->channel, device->id, device->lun,
+	mptscsih_initTarget(hd, sdev_channel(device), sdev_id(device),
+		&device->lun,
 		device->inquiry, device->inquiry_len );
 	mptscsih_change_queue_depth(device, MPT_SCSI_CMD_PER_DEV_HIGH);
 
@@ -2648,12 +2664,14 @@ mptscsih_event_process(MPT_ADAPTER *ioc,
  *
  */
 static void
-mptscsih_initTarget(MPT_SCSI_HOST *hd, int bus_id, int target_id, u8 lun, char *data, int dlen)
+mptscsih_initTarget(MPT_SCSI_HOST *hd, int bus_id, int target_id,
+		const struct scsi_lun *slun, char *data, int dlen)
 {
 	int		indexed_lun, lun_index;
 	VirtDevice	*vdev;
 	SpiCfgData	*pSpi;
 	char		data_56;
+	unsigned int	lun = scsilun_to_int(slun);
 
 	dinitprintk((MYIOC_s_INFO_FMT "initTarget bus=%d id=%d lun=%d hd=%p\n",
 			hd->ioc->name, bus_id, target_id, lun, hd));
@@ -3825,7 +3843,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
 
 	for (ii=0; ii < 8; ii++)
 		pScsiReq->LUN[ii] = 0;
-	pScsiReq->LUN[1] = io->lun;
+	pScsiReq->LUN[1] = scsilun_to_int(&io->lun);
 
 	if (io->flags & MPT_ICFLAG_TAGGED_CMD)
 		pScsiReq->Control = cpu_to_le32(dir | MPI_SCSIIO_CONTROL_SIMPLEQ);
@@ -3927,7 +3945,6 @@ mptscsih_synchronize_cache(MPT_SCSI_HOST
 	ConfigPageHeader_t	 header1;
 	int			 bus = 0;
 	int			 id = 0;
-	int			 lun;
 	int			 indexed_lun, lun_index;
 	int			 hostId = ioc->pfacts[portnum].PortSCSIID;
 	int			 max_id;
@@ -4023,13 +4040,15 @@ mptscsih_synchronize_cache(MPT_SCSI_HOST
 		/* If target Ptr NULL or if this target is NOT a disk, skip.
 		 */
 		if ((pTarget) && (pTarget->inq_data[0] == TYPE_DISK)){
+			unsigned int lun;
+
 			for (lun=0; lun <= MPT_LAST_LUN; lun++) {
 				/* If LUN present, issue the command
 				 */
 				lun_index = (lun >> 5);  /* 32 luns per lun_index */
 				indexed_lun = (lun % 32);
 				if (pTarget->luns[lun_index] & (1<<indexed_lun)) {
-					iocmd.lun = lun;
+					int_to_scsilun(lun, &iocmd.lun);
 					(void) mptscsih_do_cmd(hd, &iocmd);
 				}
 			}
@@ -4308,8 +4327,9 @@ mptscsih_doDv(MPT_SCSI_HOST *hd, int bus
 	char			 firstPass = 1;
 	char			 doFallback = 0;
 	char			 readPage0;
-	char			 bus, lun;
+	char			 bus;
 	char			 inq0 = 0;
+	struct scsi_lun		 lun;
 
 	if (ioc->spi_data.sdp1length == 0)
 		return 0;
@@ -4323,7 +4343,7 @@ mptscsih_doDv(MPT_SCSI_HOST *hd, int bus
 	if (id == ioc->pfacts[0].PortSCSIID)
 		return 0;
 
-	lun = 0;
+	int_to_scsilun(0, &lun);
 	bus = (u8) bus_number;
 	ddvtprintk((MYIOC_s_NOTE_FMT
 			"DV started: bus=%d, id=%d dv @ %p\n",
@@ -4345,7 +4365,7 @@ mptscsih_doDv(MPT_SCSI_HOST *hd, int bus
 	 */
 	iocmd.id = id;
 	iocmd.bus = bus;
-	iocmd.lun = lun;
+	scsilun_cp(&iocmd.lun, &lun);
 	iocmd.flags = 0;
 	iocmd.physDiskNum = -1;
 	iocmd.rsvd = iocmd.rsvd2 = 0;
@@ -4583,7 +4603,7 @@ mptscsih_doDv(MPT_SCSI_HOST *hd, int bus
 			mptscsih_initTarget(hd,
 				bus,
 				id,
-				lun,
+				&lun,
 				pbuf1,
 				sz);
 			goto target_done;
@@ -4696,7 +4716,7 @@ mptscsih_doDv(MPT_SCSI_HOST *hd, int bus
 						mptscsih_initTarget(hd,
 							bus,
 							id,
-							lun,
+							&lun,
 							pbuf1,
 							sz);
 						break;	/* test complete */
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 51f9422..34ba8b1 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -128,6 +128,7 @@
 #include <linux/blkdev.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/device.h>
 #include <asm/dma.h>
 #include <asm/system.h>
 #include <asm/io.h>
@@ -433,11 +434,11 @@ NCR_700_release(struct Scsi_Host *host)
 }
 
 static inline __u8
-NCR_700_identify(int can_disconnect, __u8 lun)
+NCR_700_identify(int can_disconnect, const struct scsi_lun *lun)
 {
 	return IDENTIFY_BASE |
 		((can_disconnect) ? 0x40 : 0) |
-		(lun & NCR_700_LUN_MASK);
+		(scsilun_to_int(lun) & NCR_700_LUN_MASK);
 }
 
 /*
@@ -796,6 +797,12 @@ process_extended_message(struct Scsi_Hos
 			 struct scsi_cmnd *SCp, __u32 dsp, __u32 dsps)
 {
 	__u32 resume_offset = dsp, temp = dsp + 8;
+	__u8 pun = 0xff, lun = 0xff;
+
+	if(SCp != NULL) {
+		pun = sdev_id(SCp->device);
+		lun = scsilun_to_int(&SCp->device->lun);
+	}
 
 	switch(hostdata->msgin[2]) {
 	case A_SDTR_MSG:
@@ -837,8 +844,8 @@ process_extended_message(struct Scsi_Hos
 		break;
 	
 	case A_WDTR_MSG:
-		dev_printk(KERN_INFO, &SCp->device->sdev_gendev,
-			"Unsolicited WDTR after CMD, Rejecting\n");
+		printk(KERN_INFO "scsi%d: (%d:%d), Unsolicited WDTR after CMD, Rejecting\n",
+		       host->host_no, pun, lun);
 		hostdata->msgout[0] = A_REJECT_MSG;
 		dma_cache_sync(hostdata->msgout, 1, DMA_TO_DEVICE);
 		script_patch_16(hostdata->script, MessageCount, 1);
@@ -847,8 +854,8 @@ process_extended_message(struct Scsi_Hos
 		break;
 
 	default:
-		dev_printk(KERN_INFO, &SCp->device->sdev_gendev,
-			"Unexpected message %s: ",
+		printk(KERN_INFO "scsi%d (%d:%d): Unexpected message %s: ",
+		       host->host_no, pun, lun,
 		       NCR_700_phase[(dsps & 0xf00) >> 8]);
 		scsi_print_msg(hostdata->msgin);
 		printk("\n");
@@ -870,10 +877,15 @@ process_message(struct Scsi_Host *host,	
 {
 	/* work out where to return to */
 	__u32 temp = dsp + 8, resume_offset = dsp;
+	__u8 pun = 0xff, lun = 0xff;
+
+	if(SCp != NULL) {
+		pun = sdev_id(SCp->device);
+		lun = scsilun_to_int(&SCp->device->lun);
+	}
 
 #ifdef NCR_700_DEBUG
-	dev_printk(KERN_INFO, &SCp->device->sdev_gendev,
-		"message %s: ",
+	printk("scsi%d (%d:%d): message %s: ", host->host_no, pun, lun,
 	       NCR_700_phase[(dsps & 0xf00) >> 8]);
 	scsi_print_msg(hostdata->msgin);
 	printk("\n");
@@ -895,36 +907,34 @@ process_message(struct Scsi_Host *host,	
 			NCR_700_clear_flag(SCp->device, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION);
 		} else if(SCp != NULL && NCR_700_get_tag_neg_state(SCp->device) == NCR_700_DURING_TAG_NEGOTIATION) {
 			/* rejected our first simple tag message */
-			dev_printk(KERN_WARNING, &SCp->device->sdev_gendev,
-				"Rejected first tag queue attempt, turning off tag queueing\n");
+			printk(KERN_WARNING "scsi%d (%d:%d) Rejected first tag queue attempt, turning off tag queueing\n", host->host_no, pun, lun);
 			/* we're done negotiating */
 			NCR_700_set_tag_neg_state(SCp->device, NCR_700_FINISHED_TAG_NEGOTIATION);
 			hostdata->tag_negotiated &= ~(1<<sdev_id(SCp->device));
 			SCp->device->tagged_supported = 0;
 			scsi_deactivate_tcq(SCp->device, host->cmd_per_lun);
 		} else {
-			dev_printk(KERN_WARNING, &SCp->device->sdev_gendev,
-				"Unexpected REJECT Message %s\n",
+			printk(KERN_WARNING "scsi%d (%d:%d) Unexpected REJECT Message %s\n",
+			       host->host_no, pun, lun,
 			       NCR_700_phase[(dsps & 0xf00) >> 8]);
 			/* however, just ignore it */
 		}
 		break;
 
 	case A_PARITY_ERROR_MSG:
-		dev_printk(KERN_ERR, &SCp->device->sdev_gendev,
-			"Parity Error!\n");
+		printk(KERN_ERR "scsi%d (%d:%d) Parity Error!\n", host->host_no,
+		       pun, lun);
 		NCR_700_internal_bus_reset(host);
 		break;
 	case A_SIMPLE_TAG_MSG:
-		dev_printk(KERN_INFO, &SCp->device->sdev_gendev,
-			"SIMPLE TAG %d %s\n",
-		       hostdata->msgin[1],
+		printk(KERN_INFO "scsi%d (%d:%d) SIMPLE TAG %d %s\n", host->host_no,
+		       pun, lun, hostdata->msgin[1],
 		       NCR_700_phase[(dsps & 0xf00) >> 8]);
 		/* just ignore it */
 		break;
 	default:
-		dev_printk(KERN_INFO, &SCp->device->sdev_gendev,
-			"Unexpected message %s: ",
+		printk(KERN_INFO "scsi%d (%d:%d): Unexpected message %s: ",
+		       host->host_no, pun, lun,
 		       NCR_700_phase[(dsps & 0xf00) >> 8]);
 
 		scsi_print_msg(hostdata->msgin);
@@ -951,6 +961,12 @@ process_script_interrupt(__u32 dsps, __u
 			 struct NCR_700_Host_Parameters *hostdata)
 {
 	__u32 resume_offset = 0;
+	__u8 pun = 0xff, lun=0xff;
+
+	if(SCp != NULL) {
+		pun = sdev_id(SCp->device);
+		lun = scsilun_to_int(&SCp->device->lun);
+	}
 
 	if(dsps == A_GOOD_STATUS_AFTER_STATUS) {
 		DEBUG(("  COMMAND COMPLETE, status=%02x\n",
@@ -968,8 +984,7 @@ process_script_interrupt(__u32 dsps, __u
 			if(SCp->cmnd[0] == REQUEST_SENSE) {
 				/* OOPS: bad device, returning another
 				 * contingent allegiance condition */
-				dev_printk(KERN_ERR, &SCp->device->sdev_gendev,
-					"broken device is looping in contingent allegiance: ignoring\n");
+				printk(KERN_ERR "scsi%d (%d:%d) broken device is looping in contingent allegiance: ignoring\n", host->host_no, pun, lun);
 				NCR_700_scsi_done(hostdata, SCp, hostdata->status[0]);
 			} else {
 #ifdef NCR_DEBUG
@@ -1033,13 +1048,12 @@ process_script_interrupt(__u32 dsps, __u
 			//			    SCp->request_bufflen,
 			//			    DMA_FROM_DEVICE);
 			//	if(((char *)SCp->request_buffer)[7] & 0x02) {
-			//		dev_printk(KERN_INFO, &SCp->device->sdev_gendev,
-			//		"Enabling Tag Command Queuing\n");
-			//		hostdata->tag_negotiated |= (1 << sdev_id(SCp->device));
+			//		printk(KERN_INFO "scsi%d: (%d:%d) Enabling Tag Command Queuing\n", host->host_no, pun, lun);
+			//		hostdata->tag_negotiated |= (1<<sdev_id(SCp->device));
 			//		NCR_700_set_flag(SCp->device, NCR_700_DEV_BEGIN_TAG_QUEUEING);
 			//	} else {
 			//		NCR_700_clear_flag(SCp->device, NCR_700_DEV_BEGIN_TAG_QUEUEING);
-			//		hostdata->tag_negotiated &= ~(1 << sdev_id(SCp->device));
+			//		hostdata->tag_negotiated &= ~(1<<sdev_id(SCp->device));
 			//	}
 			//}
 			NCR_700_scsi_done(hostdata, SCp, hostdata->status[0]);
@@ -1047,8 +1061,8 @@ process_script_interrupt(__u32 dsps, __u
 	} else if((dsps & 0xfffff0f0) == A_UNEXPECTED_PHASE) {
 		__u8 i = (dsps & 0xf00) >> 8;
 
-		dev_printk(KERN_ERR, &SCp->device->sdev_gendev,
-			"UNEXPECTED PHASE %s (%s)\n",
+		printk(KERN_ERR "scsi%d: (%d:%d), UNEXPECTED PHASE %s (%s)\n",
+		       host->host_no, pun, lun,
 		       NCR_700_phase[i],
 		       sbcl_to_string(NCR_700_readb(host, SBCL_REG)));
 		printk(KERN_ERR "         len = %d, cmd =", SCp->cmd_len);
@@ -1058,9 +1072,8 @@ process_script_interrupt(__u32 dsps, __u
 	} else if((dsps & 0xfffff000) == A_FATAL) {
 		int i = (dsps & 0xfff);
 
-		dev_printk(KERN_ERR, &SCp->device->sdev_gendev,
-			"FATAL ERROR: %s\n",
-		       NCR_700_fatal_messages[i]);
+		printk(KERN_ERR "scsi%d: (%d:%d) FATAL ERROR: %s\n",
+		       host->host_no, pun, lun, NCR_700_fatal_messages[i]);
 		if(dsps == A_FATAL_ILLEGAL_MSG_LENGTH) {
 			printk(KERN_ERR "     msg begins %02x %02x\n",
 			       hostdata->msgin[0], hostdata->msgin[1]);
@@ -1070,26 +1083,26 @@ process_script_interrupt(__u32 dsps, __u
 #ifdef NCR_700_DEBUG
 		__u8 i = (dsps & 0xf00) >> 8;
 
-		dev_printk(KERN_DEBUG, &SCp->device->sdev_gendev,
-			"DISCONNECTED (%d) %s\n",
+		printk("scsi%d: (%d:%d), DISCONNECTED (%d) %s\n",
+		       host->host_no, pun, lun,
 		       i, NCR_700_phase[i]);
 #endif
 		save_for_reselection(hostdata, SCp, dsp);
 
 	} else if(dsps == A_RESELECTION_IDENTIFIED) {
+		struct scsi_lun __lun;
 		__u8 lun;
 		struct NCR_700_command_slot *slot;
 		__u8 reselection_id = hostdata->reselection_id;
 		struct scsi_device *SDp;
-		struct scsi_lun __lun;
 
 		lun = hostdata->msgin[0] & 0x1f;
-		int_to_scsilun(lun, &__lun);
 
 		hostdata->reselection_id = 0xff;
 		DEBUG(("scsi%d: (%d:%d) RESELECTED!\n",
 		       host->host_no, reselection_id, lun));
 		/* clear the reselection indicator */
+		int_to_scsilun(lun, &__lun);
 		SDp = __scsi_device_lookup(host, 0, reselection_id, &__lun);
 		if(unlikely(SDp == NULL)) {
 			printk(KERN_ERR "scsi%d: (%d:%d) HAS NO device\n",
@@ -1232,9 +1245,8 @@ process_script_interrupt(__u32 dsps, __u
 						dsp, dsps);
 	} else if((dsps &  0xfffff000) == 0) {
 		__u8 i = (dsps & 0xf0) >> 4, j = (dsps & 0xf00) >> 8;
-		dev_printk(KERN_ERR, &SCp->device->sdev_gendev,
-			"unhandled script condition %s %s at %04x\n",
-		       NCR_700_condition[i],
+		printk(KERN_ERR "scsi%d: (%d:%d), unhandled script condition %s %s at %04x\n",
+		       host->host_no, pun, lun, NCR_700_condition[i],
 		       NCR_700_phase[j], dsp - hostdata->pScript);
 		if(SCp != NULL) {
 			scsi_print_command(SCp);
@@ -1247,14 +1259,12 @@ process_script_interrupt(__u32 dsps, __u
 		}	       
 		NCR_700_internal_bus_reset(host);
 	} else if((dsps & 0xfffff000) == A_DEBUG_INTERRUPT) {
-		dev_printk(KERN_NOTICE, &SCp->device->sdev_gendev,
-			"DEBUG INTERRUPT %d AT %08x[%04x], continuing\n",
-		       dsps & 0xfff, dsp, dsp - hostdata->pScript);
+		printk(KERN_NOTICE "scsi%d (%d:%d) DEBUG INTERRUPT %d AT %08x[%04x], continuing\n",
+		       host->host_no, pun, lun, dsps & 0xfff, dsp, dsp - hostdata->pScript);
 		resume_offset = dsp;
 	} else {
-		dev_printk(KERN_ERR, &SCp->device->sdev_gendev,
-			"unidentified script interrupt 0x%x at %04x\n",
-		       dsps, dsp - hostdata->pScript);
+		printk(KERN_ERR "scsi%d: (%d:%d), unidentified script interrupt 0x%x at %04x\n",
+		       host->host_no, pun, lun, dsps, dsp - hostdata->pScript);
 		NCR_700_internal_bus_reset(host);
 	}
 	return resume_offset;
@@ -1403,7 +1413,7 @@ NCR_700_start_command(struct scsi_cmnd *
 	 * set up so we cannot take a selection interrupt */
 
 	hostdata->msgout[0] = NCR_700_identify(SCp->cmnd[0] != REQUEST_SENSE,
-					       SCp->device->lun);
+					       &SCp->device->lun);
 	/* for INQUIRY or REQUEST_SENSE commands, we cannot be sure
 	 * if the negotiated transfer parameters still hold, so
 	 * always renegotiate them */
@@ -1415,7 +1425,7 @@ NCR_700_start_command(struct scsi_cmnd *
 	 * If a contingent allegiance condition exists, the device
 	 * will refuse all tags, so send the request sense as untagged
 	 * */
-	if((hostdata->tag_negotiated & (1 << sdev_id(SCp->device)))
+	if((hostdata->tag_negotiated & (1<<sdev_id(SCp->device)))
 	   && (slot->tag != SCSI_NO_TAG && SCp->cmnd[0] != REQUEST_SENSE)) {
 		count += scsi_populate_tag_msg(SCp, &hostdata->msgout[count]);
 	}
@@ -1434,7 +1444,7 @@ NCR_700_start_command(struct scsi_cmnd *
 
 
 	script_patch_ID(hostdata->script,
-			Device_ID, 1 << sdev_id(SCp->device));
+			Device_ID, 1<<sdev_id(SCp->device));
 
 	script_patch_32_abs(hostdata->script, CommandAddress, 
 			    slot->pCmd);
@@ -1514,8 +1524,8 @@ NCR_700_intr(int irq, void *dev_id, stru
 		       dsp, dsps));
 
 		if(SCp != NULL) {
-			pun = SCp->device->id;
-			lun = SCp->device->lun;
+			pun = sdev_id(SCp->device);
+			lun = scsilun_to_int(&SCp->device->lun);
 		}
 
 		if(sstat0 & SCSI_RESET_DETECTED) {
@@ -1757,16 +1767,16 @@ NCR_700_queuecommand(struct scsi_cmnd *S
 	 * - The blk layer sent and untagged command
 	 */
 	if(NCR_700_get_depth(SCp->device) != 0
-	   && (!(hostdata->tag_negotiated & (1 << sdev_id(SCp->device)))
+	   && (!(hostdata->tag_negotiated & (1<<sdev_id(SCp->device)))
 	       || !blk_rq_tagged(SCp->request))) {
 		DEBUG((KERN_ERR "scsi%d (%d:%d) has non zero depth %d\n",
-		       SCp->device->host->host_no, SCp->device->id, SCp->device->lun,
+		       SCp->device->host->host_no, sdev_id(SCp->device), SCp->device->lun,
 		       NCR_700_get_depth(SCp->device)));
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 	if(NCR_700_get_depth(SCp->device) >= SCp->device->queue_depth) {
 		DEBUG((KERN_ERR "scsi%d (%d:%d) has max tag depth %d\n",
-		       SCp->device->host->host_no, SCp->device->id, SCp->device->lun,
+		       SCp->device->host->host_no, sdev_id(SCp->device), SCp->device->lun,
 		       NCR_700_get_depth(SCp->device)));
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
@@ -1789,10 +1799,11 @@ NCR_700_queuecommand(struct scsi_cmnd *S
 	scsi_print_command(SCp);
 #endif
 	if(blk_rq_tagged(SCp->request)
-	   && (hostdata->tag_negotiated &(1 << sdev_id(SCp->device))) == 0
+	   && (hostdata->tag_negotiated &(1<<sdev_id(SCp->device))) == 0
 	   && NCR_700_get_tag_neg_state(SCp->device) == NCR_700_START_TAG_NEGOTIATION) {
-		printk(KERN_ERR "scsi%d: (%d:%d) Enabling Tag Command Queuing\n", SCp->device->host->host_no, SCp->device->id, SCp->device->lun);
-		hostdata->tag_negotiated |= (1 << sdev_id(SCp->device));
+		sdev_printk(KERN_ERR, SCp->device,
+			"Enabling Tag Command Queuing\n");
+		hostdata->tag_negotiated |= (1<<sdev_id(SCp->device));
 		NCR_700_set_tag_neg_state(SCp->device, NCR_700_DURING_TAG_NEGOTIATION);
 	}
 
@@ -1803,16 +1814,17 @@ NCR_700_queuecommand(struct scsi_cmnd *S
 	 * FIXME: This will royally screw up on multiple LUN devices
 	 * */
 	if(!blk_rq_tagged(SCp->request)
-	   && (hostdata->tag_negotiated &(1 << sdev_id(SCp->device)))) {
-		printk(KERN_INFO "scsi%d: (%d:%d) Disabling Tag Command Queuing\n", SCp->device->host->host_no, SCp->device->id, SCp->device->lun);
-		hostdata->tag_negotiated &= ~(1 << sdev_id(SCp->device));
+	   && (hostdata->tag_negotiated &(1<<sdev_id(SCp->device)))) {
+		sdev_printk(KERN_INFO, SCp->device,
+			"Disabling Tag Command Queuing\n");
+		hostdata->tag_negotiated &= ~(1<<sdev_id(SCp->device));
 	}
 
-	if((hostdata->tag_negotiated &(1 << sdev_id(SCp->device)))
+	if((hostdata->tag_negotiated &(1<<sdev_id(SCp->device)))
 	   && scsi_get_tag_type(SCp->device)) {
 		slot->tag = SCp->request->tag;
 		DEBUG(("53c700 %d:%d:%d, sending out tag %d, slot %p\n",
-		       SCp->device->host->host_no, SCp->device->id, SCp->device->lun, slot->tag,
+		       SCp->device->host->host_no, sdev_id(SCp->device), SCp->device->lun, slot->tag,
 		       slot));
 	} else {
 		slot->tag = SCSI_NO_TAG;
@@ -1913,8 +1925,8 @@ NCR_700_abort(struct scsi_cmnd * SCp)
 {
 	struct NCR_700_command_slot *slot;
 
-	printk(KERN_INFO "scsi%d (%d:%d) New error handler wants to abort command\n\t",
-	       SCp->device->host->host_no, SCp->device->id, SCp->device->lun);
+	sdev_printk(KERN_INFO, SCp->device,
+		"New error handler wants to abort command\n\t");
 	scsi_print_command(SCp);
 
 	slot = (struct NCR_700_command_slot *)SCp->host_scribble;
@@ -1947,8 +1959,8 @@ NCR_700_bus_reset(struct scsi_cmnd * SCp
 	struct NCR_700_Host_Parameters *hostdata = 
 		(struct NCR_700_Host_Parameters *)SCp->device->host->hostdata[0];
 
-	printk(KERN_INFO "scsi%d (%d:%d) New error handler wants BUS reset, cmd %p\n\t",
-	       SCp->device->host->host_no, SCp->device->id, SCp->device->lun, SCp);
+	sdev_printk(KERN_INFO, SCp->device,
+		"New error handler wants BUS reset, cmd %p\n\t", SCp);
 	scsi_print_command(SCp);
 
 	/* In theory, eh_complete should always be null because the
@@ -1980,8 +1992,8 @@ NCR_700_bus_reset(struct scsi_cmnd * SCp
 STATIC int
 NCR_700_host_reset(struct scsi_cmnd * SCp)
 {
-	printk(KERN_INFO "scsi%d (%d:%d) New error handler wants HOST reset\n\t",
-	       SCp->device->host->host_no, SCp->device->id, SCp->device->lun);
+	sdev_printk(KERN_INFO, SCp->device,
+		"New error handler wants HOST reset\n\t");
 	scsi_print_command(SCp);
 
 	spin_lock_irq(SCp->device->host->host_lock);
@@ -2103,7 +2115,7 @@ static int NCR_700_change_queue_type(str
 		/* shift back to the default unqueued number of commands
 		 * (the user can still raise this) */
 		scsi_deactivate_tcq(SDp, SDp->host->cmd_per_lun);
-		hostdata->tag_negotiated &= ~(1 << SDp->id);
+		hostdata->tag_negotiated &= ~(1 << sdev_id(SDp));
 	} else {
 		/* Here, we cleared the negotiation flag above, so this
 		 * will force the driver to renegotiate */
diff --git a/drivers/scsi/53c700.h b/drivers/scsi/53c700.h
index 07a1ec3..e86012c 100644
--- a/drivers/scsi/53c700.h
+++ b/drivers/scsi/53c700.h
@@ -15,15 +15,15 @@
 
 
 /* Turn on for general debugging---too verbose for normal use */
-#define	NCR_700_DEBUG
+#undef	NCR_700_DEBUG
 /* Debug the tag queues, checking hash queue allocation and deallocation
  * and search for duplicate tags */
 #undef NCR_700_TAG_DEBUG
 
 #ifdef NCR_700_DEBUG
-#define DEBUG(dev,args...)	dev_printk(KERN_DEBUG, (dev), ## args)
+#define DEBUG(x)	printk x
 #else
-#define DEBUG(dev,args...)
+#define DEBUG(x)
 #endif
 
 /* The number of available command slots */
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index c34403c..b24dd8b 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -806,8 +806,8 @@ static void inia100BuildSCB(ORC_HCS * pH
 
 	pSCB->SCB_Opcode = ORC_EXECSCSI;
 	pSCB->SCB_Flags = SCF_NO_DCHK;	/* Clear done bit               */
-	pSCB->SCB_Target = SCpnt->device->id;
-	pSCB->SCB_Lun = SCpnt->device->lun;
+	pSCB->SCB_Target = sdev_id(SCpnt->device);
+	pSCB->SCB_Lun = scsilun_to_int(&SCpnt->device->lun);
 	pSCB->SCB_Reserved0 = 0;
 	pSCB->SCB_Reserved1 = 0;
 	pSCB->SCB_SGLen = 0;
@@ -847,7 +847,7 @@ static void inia100BuildSCB(ORC_HCS * pH
 		printk("max cdb length= %x\b", SCpnt->cmd_len);
 		pSCB->SCB_CDBLen = IMAX_CDB;
 	}
-	pSCB->SCB_Ident = SCpnt->device->lun | DISC_ALLOW;
+	pSCB->SCB_Ident = scsilun_to_int(&SCpnt->device->lun) | DISC_ALLOW;
 	if (SCpnt->device->tagged_supported) {	/* Tag Support                  */
 		pSCB->SCB_TagMsg = SIMPLE_QUEUE_TAG;	/* Do simple tag only   */
 	} else {
@@ -923,7 +923,7 @@ static int inia100_device_reset(struct s
 {				/* I need Host Control Block Information */
 	ORC_HCS *pHCB;
 	pHCB = (ORC_HCS *) SCpnt->device->host->hostdata;
-	return orc_device_reset(pHCB, SCpnt, SCpnt->device->id);
+	return orc_device_reset(pHCB, SCpnt, sdev_id(SCpnt->device));
 
 }
 
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index dda5706..3839cf3 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -315,9 +315,9 @@
 #define ERR_LEAD	KERN_ERR	LEAD
 #define DEBUG_LEAD	KERN_DEBUG	LEAD
 #define CMDINFO(cmd) \
-			(cmd) ? ((cmd)->device->host->host_no) : -1, \
-                        (cmd) ? ((cmd)->device->id & 0x0f) : -1, \
-			(cmd) ? ((cmd)->device->lun & 0x07) : -1
+		(cmd) ? ((cmd)->device->host->host_no) : -1, \
+		(cmd) ? (sdev_id((cmd)->device) & 0x0f) : -1, \
+		(cmd) ? (scsilun_to_int(&(cmd)->device->lun) & 0x07) : -1
 
 #define DELAY_DEFAULT 1000
 
@@ -586,8 +586,8 @@ struct aha152x_scdata {
 
 #define DATA_LEN		(HOSTDATA(shpnt)->data_len)
 
-#define SYNCRATE		(HOSTDATA(shpnt)->syncrate[CURRENT_SC->device->id])
-#define SYNCNEG			(HOSTDATA(shpnt)->syncneg[CURRENT_SC->device->id])
+#define SYNCRATE		(HOSTDATA(shpnt)->syncrate[sdev_id(CURRENT_SC->device)])
+#define SYNCNEG			(HOSTDATA(shpnt)->syncneg[sdev_id(CURRENT_SC->device)])
 
 #define DELAY			(HOSTDATA(shpnt)->delay)
 #define EXT_TRANS		(HOSTDATA(shpnt)->ext_trans)
@@ -712,7 +712,8 @@ static inline Scsi_Cmnd *remove_lun_SC(S
 	Scsi_Cmnd *ptr, *prev;
 
 	for (ptr = *SC, prev = NULL;
-	     ptr && ((ptr->device->id != target) || (ptr->device->lun != lun));
+	     ptr && ((sdev_id(ptr->device) != target) ||
+	     		(scsilun_to_int(&ptr->device->lun) != lun));
 	     prev = ptr, ptr = SCNEXT(ptr))
 	     ;
 
@@ -1660,7 +1661,7 @@ static void busfree_run(struct Scsi_Host
 		/* clear selection timeout */
 		SETPORT(SSTAT1, SELTO);
 
-		SETPORT(SCSIID, (shpnt->this_id << OID_) | CURRENT_SC->device->id);
+		SETPORT(SCSIID, (shpnt->this_id << OID_) | sdev_id(CURRENT_SC->device));
 		SETPORT(SXFRCTL1, (PARITY ? ENSPCHK : 0 ) | ENSTIMER);
 		SETPORT(SCSISEQ, ENSELO | ENAUTOATNO | (DISCONNECTED_SC ? ENRESELI : 0));
 	} else {
@@ -1699,7 +1700,7 @@ static void seldo_run(struct Scsi_Host *
 
 	SETPORT(SSTAT0, CLRSELDO);
 	
-	ADDMSGO(IDENTIFY(RECONNECT, CURRENT_SC->device->lun));
+	ADDMSGO(IDENTIFY(RECONNECT, &CURRENT_SC->device->lun));
 
 	if (CURRENT_SC->SCp.phase & aborting) {
 		ADDMSGO(ABORT);
@@ -2019,7 +2020,7 @@ static void msgo_init(struct Scsi_Host *
 {
 	if(MSGOLEN==0) {
 		if((CURRENT_SC->SCp.phase & syncneg) && SYNCNEG==2 && SYNCRATE==0) {
-			ADDMSGO(IDENTIFY(RECONNECT, CURRENT_SC->device->lun));
+			ADDMSGO(IDENTIFY(RECONNECT, &CURRENT_SC->device->lun));
 		} else {
 			printk(INFO_LEAD "unexpected MESSAGE OUT phase; rejecting\n", CMDINFO(CURRENT_SC));
 			ADDMSGO(MESSAGE_REJECT);
@@ -2990,9 +2991,11 @@ static int get_command(char *pos, Scsi_C
 {
 	char *start = pos;
 	int i;
+	char lunstr[SCSILUN_STR_LEN];
 
-	SPRINTF("0x%08x: target=%d; lun=%d; cmnd=( ",
-		(unsigned int) ptr, ptr->device->id, ptr->device->lun);
+	SPRINTF("0x%08x: target=%d; lun=%s; cmnd=( ",
+		(unsigned int) ptr, sdev_id(ptr->device),
+		scsilun_to_str(&ptr->device->lun, lunstr));
 
 	for (i = 0; i < COMMAND_SIZE(ptr->cmnd[0]); i++)
 		SPRINTF("0x%02x ", ptr->cmnd[i]);
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 9ec4641..1826d6e 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -601,8 +601,8 @@ static int aha1542_queuecommand(Scsi_Cmn
 	unchar ahacmd = CMD_START_SCSI;
 	unchar direction;
 	unchar *cmd = (unchar *) SCpnt->cmnd;
-	unchar target = SCpnt->device->id;
-	unchar lun = SCpnt->device->lun;
+	unchar target = sdev_id(SCpnt->device);
+	unchar lun = scsilun_to_int(&SCpnt->device->lun);
 	unsigned long flags;
 	void *buff = SCpnt->request_buffer;
 	int bufflen = SCpnt->request_bufflen;
@@ -1356,8 +1356,8 @@ static int aha1542_dev_reset(Scsi_Cmnd *
 {
 	unsigned long flags;
 	struct mailbox *mb;
-	unchar target = SCpnt->device->id;
-	unchar lun = SCpnt->device->lun;
+	unchar target = sdev_id(SCpnt->device);
+	unchar lun = scsilun_to_int(&SCpnt->device->lun);
 	int mbo;
 	struct ccb *ccb;
 	unchar ahacmd = CMD_START_SCSI;
@@ -1405,7 +1405,8 @@ static int aha1542_dev_reset(Scsi_Cmnd *
 	 */
 	aha1542_out(SCpnt->device->host->io_port, &ahacmd, 1);
 
-	printk(KERN_WARNING "aha1542.c: Trying device reset for target %d\n", SCpnt->device->id);
+	sdev_printk(KERN_WARNING, SCpnt->device,
+		"aha1542.c: Trying device reset for target\n");
 
 	return SUCCESS;
 
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 73f33e7..21f355c 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -347,7 +347,7 @@ static int aha1740_queuecommand(Scsi_Cmn
 {
 	unchar direction;
 	unchar *cmd = (unchar *) SCpnt->cmnd;
-	unchar target = SCpnt->device->id;
+	unchar target = sdev_id(SCpnt->device);
 	struct aha1740_hostdata *host = HOSTDATA(SCpnt->device->host);
 	unsigned long flags;
 	void *buff = SCpnt->request_buffer;
@@ -455,7 +455,7 @@ static int aha1740_queuecommand(Scsi_Cmn
 						       DMA_BIDIRECTIONAL);
 		host->ecb[ecbno].dataptr = sgptr->buf_dma_addr;
 	}
-	host->ecb[ecbno].lun = SCpnt->device->lun;
+	host->ecb[ecbno].lun = scsilun_to_int(&SCpnt->device->lun);
 	host->ecb[ecbno].ses = 1; /* Suppress underrun errors */
 	host->ecb[ecbno].dir = direction;
 	host->ecb[ecbno].ars = 1; /* Yes, get the sense on an error */
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index a8cfbef..5206771 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -297,7 +297,7 @@ stop_dma:
 			}
 			workreq = dev->id[c][target_id].curr_req;
 #ifdef ED_DBGP			
-			printk(KERN_DEBUG "Channel = %d ID = %d LUN = %d CDB",c,workreq->device->id,workreq->device->lun);
+			printk(KERN_DEBUG "Channel = %d ID = %d LUN = %d CDB",c,sdev_id(workreq->device),workreq->device->lun);
 			for(l=0;l<workreq->cmd_len;l++)
 			{
 				printk(KERN_DEBUG " %x",workreq->cmnd[l]);
@@ -622,10 +622,10 @@ static int atp870u_queuecommand(struct s
 	struct atp_unit *dev;
 	struct Scsi_Host *host;
 
-	c = req_p->device->channel;	
+	c = sdev_channel(req_p->device);
 	req_p->sense_buffer[0]=0;
 	req_p->resid = 0;
-	if (req_p->device->channel > 1) {
+	if (sdev_channel(req_p->device) > 1) {
 		req_p->result = 0x00040000;
 		done(req_p);
 #ifdef ED_DBGP		
@@ -640,7 +640,7 @@ static int atp870u_queuecommand(struct s
 
 		
 	m = 1;
-	m = m << req_p->device->id;
+	m = m << sdev_id(req_p->device);
 
 	/*
 	 *      Fake a timeout for missing targets
@@ -758,9 +758,9 @@ static void send_s870(struct atp_unit *d
 		dev->quhd[c] = 0;
 	}
 	workreq = dev->quereq[c][dev->quhd[c]];
-	if (dev->id[c][workreq->device->id].curr_req == 0) {	
-		dev->id[c][workreq->device->id].curr_req = workreq;
-		dev->last_cmd[c] = workreq->device->id;
+	if (dev->id[c][sdev_id(workreq->device)].curr_req == 0) {	
+		dev->id[c][sdev_id(workreq->device)].curr_req = workreq;
+		dev->last_cmd[c] = sdev_id(workreq->device);
 		goto cmd_subp;
 	}	
 	dev->quhd[c] = j;
@@ -791,12 +791,12 @@ oktosend:
 	for(i=0;i<workreq->cmd_len;i++) {
 		printk(" %x",workreq->cmnd[i]);
 	}
-	printk("\nChannel = %d ID = %d LUN = %d\n",c,workreq->device->id,workreq->device->lun);
+	printk("\nChannel = %d ID = %d LUN = %d\n",c,sdev_id(workreq->device),workreq->device->lun);
 #endif	
 	if (dev->dev_id == ATP885_DEVID) {
 		j = inb(dev->baseport + 0x29) & 0xfe;
 		outb(j, dev->baseport + 0x29);
-		dev->r1f[c][workreq->device->id] = 0;
+		dev->r1f[c][sdev_id(workreq->device)] = 0;
 	}
 	
 	if (workreq->cmnd[0] == READ_CAPACITY) {
@@ -810,7 +810,7 @@ oktosend:
 
 	tmport = workport + 0x1b;
 	j = 0;
-	target_id = workreq->device->id;
+	target_id = sdev_id(workreq->device);
 
 	/*
 	 *	Wide ?
@@ -843,7 +843,7 @@ oktosend:
 		outb(workreq->cmnd[i], tmport++);
 	}
 	tmport = workport + 0x0f;
-	outb(workreq->device->lun, tmport);
+	outb(scsilun_to_int(&workreq->device->lun), tmport);
 	tmport += 0x02;
 	/*
 	 *	Write the target
@@ -3109,7 +3109,7 @@ static int atp870u_abort(struct scsi_cmn
 	host = SCpnt->device->host;
 
 	dev = (struct atp_unit *)&host->hostdata;
-	c=SCpnt->device->channel;
+	c = sdev_channel(SCpnt->device);
 	printk(" atp870u: abort Channel = %x \n", c);
 	printk("working=%x last_cmd=%x ", dev->working[c], dev->last_cmd[c]);
 	printk(" quhdu=%x quendu=%x ", dev->quhd[c], dev->quend[c]);
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 600ba12..412881a 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -949,9 +949,10 @@ static void waiting_timeout(unsigned lon
 
 
 /* Get the DCB for a given ID/LUN combination */
-static struct DeviceCtlBlk *find_dcb(struct AdapterCtlBlk *acb, u8 id, u8 lun)
+static inline struct DeviceCtlBlk *find_dcb(struct AdapterCtlBlk *acb, u8 id,
+					     const struct scsi_lun *lun)
 {
-	return acb->children[id][lun];
+	return acb->children[id][scsilun_to_int(lun)];
 }
 
 
@@ -1100,32 +1101,32 @@ static int dc395x_queue_command(struct s
 	struct ScsiReqBlk *srb;
 	struct AdapterCtlBlk *acb =
 	    (struct AdapterCtlBlk *)cmd->device->host->hostdata;
+	unsigned int lun = scsilun_to_int(&cmd->device->lun);
 	dprintkdbg(DBG_0, "queue_command: (pid#%li) <%02i-%i> cmnd=0x%02x\n",
-		cmd->pid, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+		cmd->pid, sdev_id(cmd->device), lun, cmd->cmnd[0]);
 
 	/* Assume BAD_TARGET; will be cleared later */
 	cmd->result = DID_BAD_TARGET << 16;
 
 	/* ignore invalid targets */
-	if (cmd->device->id >= acb->scsi_host->max_id ||
-	    cmd->device->lun >= acb->scsi_host->max_lun ||
-	    cmd->device->lun >31) {
+	if (sdev_id(cmd->device) >= acb->scsi_host->max_id ||
+	    lun >= acb->scsi_host->max_lun || lun > 31) {
 		goto complete;
 	}
 
 	/* does the specified lun on the specified device exist */
-	if (!(acb->dcb_map[cmd->device->id] & (1 << cmd->device->lun))) {
-		dprintkl(KERN_INFO, "queue_command: Ignore target <%02i-%i>\n",
-			cmd->device->id, cmd->device->lun);
+	if (!(acb->dcb_map[sdev_id(cmd->device)] & (1 << lun))) {
+		sdev_printk(KERN_INFO, cmd->device,
+			"queue_command: Ignore target\n");
 		goto complete;
 	}
 
 	/* do we have a DCB for the device */
-	dcb = find_dcb(acb, cmd->device->id, cmd->device->lun);
+	dcb = find_dcb(acb, sdev_id(cmd->device), &cmd->device->lun);
 	if (!dcb) {
 		/* should never happen */
-		dprintkl(KERN_ERR, "queue_command: No such device <%02i-%i>",
-			cmd->device->id, cmd->device->lun);
+		sdev_printk(KERN_INFO, cmd->device,
+			"queue_command: No such device\n");
 		goto complete;
 	}
 
@@ -1216,11 +1217,11 @@ static void dump_register_info(struct Ad
 			dprintkl(KERN_INFO, "dump: srb=%p cmd=%p OOOPS!\n",
 				srb, srb->cmd);
 		else
-			dprintkl(KERN_INFO, "dump: srb=%p cmd=%p (pid#%li) "
-				 "cmnd=0x%02x <%02i-%i>\n",
+			sdev_printk(KERN_INFO, srb->cmd->device,
+				"dump: srb=%p cmd=%p (pid#%li) "
+				 "cmnd=0x%02x\n",
 			    	srb, srb->cmd, srb->cmd->pid,
-				srb->cmd->cmnd[0], srb->cmd->device->id,
-			       	srb->cmd->device->lun);
+				srb->cmd->cmnd[0]);
 		printk("  sglist=%p cnt=%i idx=%i len=%i\n",
 		       srb->segment_x, srb->sg_count, srb->sg_index,
 		       srb->total_xfer_length);
@@ -1313,9 +1314,8 @@ static int __dc395x_eh_bus_reset(struct 
 {
 	struct AdapterCtlBlk *acb =
 		(struct AdapterCtlBlk *)cmd->device->host->hostdata;
-	dprintkl(KERN_INFO,
-		"eh_bus_reset: (pid#%li) target=<%02i-%i> cmd=%p\n",
-		cmd->pid, cmd->device->id, cmd->device->lun, cmd);
+	sdev_printk(KERN_INFO, cmd->device,
+		"eh_bus_reset: (pid#%li) cmd=%p\n", cmd->pid, cmd);
 
 	if (timer_pending(&acb->waiting_timer))
 		del_timer(&acb->waiting_timer);
@@ -1381,10 +1381,10 @@ static int dc395x_eh_abort(struct scsi_c
 	    (struct AdapterCtlBlk *)cmd->device->host->hostdata;
 	struct DeviceCtlBlk *dcb;
 	struct ScsiReqBlk *srb;
-	dprintkl(KERN_INFO, "eh_abort: (pid#%li) target=<%02i-%i> cmd=%p\n",
-		cmd->pid, cmd->device->id, cmd->device->lun, cmd);
+	sdev_printk(KERN_INFO, cmd->device,
+		"eh_abort: (pid#%li) cmd=%p\n", cmd->pid, cmd);
 
-	dcb = find_dcb(acb, cmd->device->id, cmd->device->lun);
+	dcb = find_dcb(acb, sdev_id(cmd->device), &cmd->device->lun);
 	if (!dcb) {
 		dprintkl(KERN_DEBUG, "eh_abort: No such device\n");
 		return FAILED;
@@ -1616,10 +1616,9 @@ static u8 start_scsi(struct AdapterCtlBl
 			tag_number++;
 		}
 		if (tag_number >= dcb->max_command) {
-			dprintkl(KERN_WARNING, "start_scsi: (pid#%li) "
-				"Out of tags target=<%02i-%i>)\n",
-				srb->cmd->pid, srb->cmd->device->id,
-				srb->cmd->device->lun);
+			sdev_printk(KERN_WARNING, srb->cmd->device,
+				"start_scsi: (pid#%li) "
+				"Out of tags)\n", srb->cmd->pid);
 			srb->state = SRB_READY;
 			DC395x_write16(acb, TRM_S1040_SCSI_CONTROL,
 				       DO_HWRESELECT);
@@ -1637,7 +1636,7 @@ static u8 start_scsi(struct AdapterCtlBl
 /*polling:*/
 	/* Send CDB ..command block ......... */
 	dprintkdbg(DBG_KG, "start_scsi: (pid#%li) <%02i-%i> cmnd=0x%02x tag=%i\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun,
+		srb->cmd->pid, sdev_id(srb->cmd->device), srb->cmd->device->lun,
 		srb->cmd->cmnd[0], srb->tag_number);
 	if (srb->flag & AUTO_REQSENSE) {
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, REQUEST_SENSE);
@@ -2092,7 +2091,7 @@ static void data_out_phase0(struct Adapt
 	u16 scsi_status = *pscsi_status;
 	u32 d_left_counter = 0;
 	dprintkdbg(DBG_0, "data_out_phase0: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->pid, sdev_id(srb->cmd->device), srb->cmd->device->lun);
 
 	/*
 	 * KG: We need to drain the buffers before we draw any conclusions!
@@ -2222,7 +2221,7 @@ static void data_out_phase1(struct Adapt
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "data_out_phase1: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->pid, sdev_id(srb->cmd->device), srb->cmd->device->lun);
 	clear_fifo(acb, "data_out_phase1");
 	/* do prepare before transfer when data out phase */
 	data_io_transfer(acb, srb, XFERDATAOUT);
@@ -2235,7 +2234,7 @@ static void data_in_phase0(struct Adapte
 	u16 scsi_status = *pscsi_status;
 	u32 d_left_counter = 0;
 	dprintkdbg(DBG_0, "data_in_phase0: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->pid, sdev_id(srb->cmd->device), srb->cmd->device->lun);
 
 	/*
 	 * KG: DataIn is much more tricky than DataOut. When the device is finished
@@ -2407,7 +2406,7 @@ static void data_in_phase1(struct Adapte
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "data_in_phase1: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->pid, sdev_id(srb->cmd->device), srb->cmd->device->lun);
 	data_io_transfer(acb, srb, XFERDATAIN);
 }
 
@@ -2419,7 +2418,7 @@ static void data_io_transfer(struct Adap
 	u8 bval;
 	dprintkdbg(DBG_0,
 		"data_io_transfer: (pid#%li) <%02i-%i> %c len=%i, sg=(%i/%i)\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun,
+		srb->cmd->pid, sdev_id(srb->cmd->device), srb->cmd->device->lun,
 		((io_dir & DMACMD_DIR) ? 'r' : 'w'),
 		srb->total_xfer_length, srb->sg_index, srb->sg_count);
 	if (srb == acb->tmp_srb)
@@ -2576,7 +2575,7 @@ static void status_phase0(struct Adapter
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "status_phase0: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->pid, sdev_id(srb->cmd->device), srb->cmd->device->lun);
 	srb->target_status = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 	srb->end_message = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);	/* get message */
 	srb->state = SRB_COMPLETED;
@@ -2590,7 +2589,7 @@ static void status_phase1(struct Adapter
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "status_phase1: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->pid, sdev_id(srb->cmd->device), srb->cmd->device->lun);
 	srb->state = SRB_STATUS;
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
 	DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_COMP);
@@ -3122,6 +3121,7 @@ static void reselect(struct AdapterCtlBl
 	u16 rsel_tar_lun_id;
 	u8 id, lun;
 	u8 arblostflag = 0;
+	struct scsi_lun slun;
 	dprintkdbg(DBG_0, "reselect: acb=%p\n", acb);
 
 	clear_fifo(acb, "reselect");
@@ -3160,7 +3160,9 @@ static void reselect(struct AdapterCtlBl
 			"Got %i!\n", rsel_tar_lun_id);
 	id = rsel_tar_lun_id & 0xff;
 	lun = (rsel_tar_lun_id >> 8) & 7;
-	dcb = find_dcb(acb, id, lun);
+	int_to_scsilun(lun, &slun);
+
+	dcb = find_dcb(acb, id, &slun);
 	if (!dcb) {
 		dprintkl(KERN_ERR, "reselect: From non existent device "
 			"<%02i-%i>\n", id, lun);
@@ -3328,7 +3330,7 @@ static void srb_done(struct AdapterCtlBl
 	}
 
 	dprintkdbg(DBG_1, "srb_done: (pid#%li) <%02i-%i>\n", srb->cmd->pid,
-		srb->cmd->device->id, srb->cmd->device->lun);
+		sdev_id(srb->cmd->device), srb->cmd->device->lun);
 	dprintkdbg(DBG_SG, "srb_done: srb=%p sg=%i(%i/%i) buf=%p addr=%p\n",
 		srb, cmd->use_sg, srb->sg_index, srb->sg_count,
 		cmd->request_buffer, ptr);
@@ -3502,7 +3504,7 @@ static void srb_done(struct AdapterCtlBl
 		if (srb->total_xfer_length)
 			dprintkdbg(DBG_KG, "srb_done: (pid#%li) <%02i-%i> "
 				"cmnd=0x%02x Missed %i bytes\n",
-				cmd->pid, cmd->device->id, cmd->device->lun,
+				cmd->pid, sdev_id(cmd->device), cmd->device->lun,
 				cmd->cmnd[0], srb->total_xfer_length);
 	}
 
@@ -3527,6 +3529,7 @@ static void doing_srb_done(struct Adapte
 		struct scsi_cmnd *cmd, u8 force)
 {
 	struct DeviceCtlBlk *dcb;
+	char lunstr[SCSILUN_STR_LEN];
 	dprintkl(KERN_INFO, "doing_srb_done: pids ");
 
 	list_for_each_entry(dcb, &acb->dcb_list, list) {
@@ -3541,8 +3544,9 @@ static void doing_srb_done(struct Adapte
 			p = srb->cmd;
 			dir = p->sc_data_direction;
 			result = MK_RES(0, did_flag, 0, 0);
-			printk("G:%li(%02i-%i) ", p->pid,
-			       p->device->id, p->device->lun);
+			printk("G:%li(%02i-%s) ", p->pid,
+			       sdev_id(p->device),
+			       scsilun_to_str(&p->device->lun, lunstr));
 			srb_going_remove(dcb, srb);
 			free_tag(dcb, srb);
 			srb_free_insert(acb, srb);
@@ -3571,8 +3575,8 @@ static void doing_srb_done(struct Adapte
 			p = srb->cmd;
 
 			result = MK_RES(0, did_flag, 0, 0);
-			printk("W:%li<%02i-%i>", p->pid, p->device->id,
-			       p->device->lun);
+			printk("W:%li<%02i-%s>", p->pid, sdev_id(p->device),
+			       scsilun_to_str(&p->device->lun, lunstr));
 			srb_waiting_remove(dcb, srb);
 			srb_free_insert(acb, srb);
 			p->result = result;
@@ -3681,7 +3685,7 @@ static void request_sense(struct Adapter
 {
 	struct scsi_cmnd *cmd = srb->cmd;
 	dprintkdbg(DBG_1, "request_sense: (pid#%li) <%02i-%i>\n",
-		cmd->pid, cmd->device->id, cmd->device->lun);
+		cmd->pid, sdev_id(cmd->device), cmd->device->lun);
 
 	srb->flag |= AUTO_REQSENSE;
 	srb->adapter_status = 0;
@@ -3733,7 +3737,7 @@ static void request_sense(struct Adapter
  * Return the new device if succesfull or NULL on failure.
  **/
 static struct DeviceCtlBlk *device_alloc(struct AdapterCtlBlk *acb,
-		u8 target, u8 lun)
+		u8 target, const struct scsi_lun *lun)
 {
 	struct NvRamType *eeprom = &acb->eeprom;
 	u8 period_index = eeprom->target[target].period & 0x07;
@@ -3750,7 +3754,7 @@ static struct DeviceCtlBlk *device_alloc
 	dcb->tag_mask = 0;
 	dcb->max_command = 1;
 	dcb->target_id = target;
-	dcb->target_lun = lun;
+	dcb->target_lun = scsilun_to_int(lun);
 #ifndef DC395x_NO_DISCONNECT
 	dcb->identify_msg =
 	    IDENTIFY(dcb->dev_mode & NTC_DO_DISCONNECT, lun);
@@ -3909,7 +3913,7 @@ static int dc395x_slave_alloc(struct scs
 	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)scsi_device->host->hostdata;
 	struct DeviceCtlBlk *dcb;
 
-	dcb = device_alloc(acb, scsi_device->id, scsi_device->lun);
+	dcb = device_alloc(acb, sdev_id(scsi_device), &scsi_device->lun);
 	if (!dcb)
 		return -ENOMEM;
 	adapter_add_device(acb, dcb);
@@ -3927,7 +3931,7 @@ static int dc395x_slave_alloc(struct scs
 static void dc395x_slave_destroy(struct scsi_device *scsi_device)
 {
 	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)scsi_device->host->hostdata;
-	struct DeviceCtlBlk *dcb = find_dcb(acb, scsi_device->id, scsi_device->lun);
+	struct DeviceCtlBlk *dcb = find_dcb(acb, sdev_id(scsi_device), &scsi_device->lun);
 	if (dcb)
 		adapter_remove_and_free_device(acb, dcb);
 }
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index af68230..f7d3218 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2248,8 +2248,8 @@ static void gdth_putq(int hanum,Scsi_Cmn
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     scp->SCp.this_residual = (int)priority;
-    b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
-    t = scp->device->id;
+    b = virt_ctr ? NUMDATA(scp->device->host)->busnum : sdev_channel(scp->device);
+    t = sdev_id(scp->device);
     if (priority >= DEFAULT_PRI) {
         if ((b != ha->virt_bus && ha->raw[BUS_L2P(ha,b)].lock) ||
             (b == ha->virt_bus && t < MAX_HDRIVES && ha->hdr[t].lock)) {
@@ -2308,9 +2308,9 @@ static void gdth_next(int hanum)
     for (nscp = pscp = ha->req_first; nscp; nscp = (Scsi_Cmnd *)nscp->SCp.ptr) {
         if (nscp != pscp && nscp != (Scsi_Cmnd *)pscp->SCp.ptr)
             pscp = (Scsi_Cmnd *)pscp->SCp.ptr;
-        b = virt_ctr ? NUMDATA(nscp->device->host)->busnum : nscp->device->channel;
-        t = nscp->device->id;
-        l = nscp->device->lun;
+        b = virt_ctr ? NUMDATA(nscp->device->host)->busnum : sdev_channel(nscp->device);
+        t = sdev_id(nscp->device);
+        l = scsilun_to_int(&nscp->device->lun);
         if (nscp->SCp.this_residual >= DEFAULT_PRI) {
             if ((b != ha->virt_bus && ha->raw[BUS_L2P(ha,b)].lock) ||
                 (b == ha->virt_bus && t < MAX_HDRIVES && ha->hdr[t].lock)) 
@@ -2585,7 +2585,7 @@ static int gdth_internal_cache_cmd(int h
     gdth_modep_data mpd;
 
     ha = HADATA(gdth_ctr_tab[hanum]);
-    t  = scp->device->id;
+    t  = sdev_id(scp->device);
     TRACE(("gdth_internal_cache_cmd() cmd 0x%x hdrive %d\n",
            scp->cmnd[0],t));
 
@@ -2900,8 +2900,8 @@ static int gdth_fill_raw_cmd(int hanum,S
     ulong offset;
 
     ha = HADATA(gdth_ctr_tab[hanum]);
-    t = scp->device->id;
-    l = scp->device->lun;
+    t = sdev_id(scp->device);
+    l = scsilun_to_int(&scp->device->lun);
     cmdp = ha->pccb;
     TRACE(("gdth_fill_raw_cmd() cmd 0x%x bus %d ID %d LUN %d\n",
            scp->cmnd[0],b,t,l));
@@ -3620,8 +3620,8 @@ static int gdth_sync_event(int hanum,int
         printk("\n");
 
     } else {
-        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
-        t = scp->device->id;
+        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : sdev_channel(scp->device);
+        t = sdev_id(scp->device);
         if (scp->SCp.sent_command == -1 && b != ha->virt_bus) {
             ha->raw[BUS_L2P(ha,b)].io_cnt[t]--;
         }
@@ -4712,14 +4712,14 @@ static int gdth_eh_bus_reset(Scsi_Cmnd *
     TRACE2(("gdth_eh_bus_reset()\n"));
 
     hanum = NUMDATA(scp->device->host)->hanum;
-    b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
+    b = virt_ctr ? NUMDATA(scp->device->host)->busnum : sdev_channel(scp->device);
     ha    = HADATA(gdth_ctr_tab[hanum]);
 
     /* clear command tab */
     spin_lock_irqsave(&ha->smp_lock, flags);
     for (i = 0; i < GDTH_MAXCMDS; ++i) {
         cmnd = ha->cmd_tab[i].cmnd;
-        if (!SPECIAL_SCP(cmnd) && cmnd->device->channel == b)
+        if (!SPECIAL_SCP(cmnd) && sdev_channel(cmnd->device) == b)
             ha->cmd_tab[i].cmnd = UNUSED_CMND;
     }
     spin_unlock_irqrestore(&ha->smp_lock, flags);
@@ -4775,8 +4775,8 @@ static int gdth_bios_param(Disk *disk,kd
     capacity = disk->capacity;
 #endif
     hanum = NUMDATA(sd->host)->hanum;
-    b = virt_ctr ? NUMDATA(sd->host)->busnum : sd->channel;
-    t = sd->id;
+    b = virt_ctr ? NUMDATA(sd->host)->busnum : sdev_channel(sd);
+    t = sdev_id(sd);
     TRACE2(("gdth_bios_param() ha %d bus %d target %d\n", hanum, b, t)); 
     ha = HADATA(gdth_ctr_tab[hanum]);
 
@@ -5521,7 +5521,8 @@ static int gdth_ioctl(struct inode *inod
             return -ENOMEM;
         scp->cmd_len = 12;
         scp->use_sg = 0;
-        scp->device->channel = virt_ctr ? 0 : res.number;
+	/* FIXME XXX is this right? */
+        scp->device->sdev_target->channel = virt_ctr ? 0 : res.number;
         rval = gdth_eh_bus_reset(scp);
         res.status = (rval == SUCCESS ? S_OK : S_GENERR);
         scsi_put_command(scp);
diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index 1bd02f8..91de4b6 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -951,8 +951,8 @@ static void gdth_wait_completion(int han
     for (i = 0; i < GDTH_MAXCMDS; ++i) {
         scp = ha->cmd_tab[i].cmnd;
 
-        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
-        t = scp->device->id;
+        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : sdev_channel(scp->device);
+        t = sdev_id(scp->device);
         if (!SPECIAL_SCP(scp) && t == (unchar)id && 
             b == (unchar)busnum) {
             scp->SCp.have_data_in = 0;
@@ -976,8 +976,8 @@ static void gdth_stop_timeout(int hanum,
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
-        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
-        t = scp->device->id;
+        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : sdev_channel(scp->device);
+        t = sdev_id(scp->device);
         if (t == (unchar)id && b == (unchar)busnum) {
             TRACE2(("gdth_stop_timeout(): update_timeout()\n"));
             scp->SCp.buffers_residual = gdth_update_timeout(hanum, scp, 0);
@@ -997,8 +997,8 @@ static void gdth_start_timeout(int hanum
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
-        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
-        t = scp->device->id;
+        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : sdev_channel(scp->device);
+        t = sdev_id(scp->device);
         if (t == (unchar)id && b == (unchar)busnum) {
             TRACE2(("gdth_start_timeout(): update_timeout()\n"));
             gdth_update_timeout(hanum, scp, scp->SCp.buffers_residual);
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 19392f6..d8a5aae 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -673,8 +673,9 @@ static irqreturn_t interrupt_handler(int
 	ld(ihost_index)[ldn].cmd = NULL;
 #ifdef IM_DEBUG_TIMEOUT
 	if (cmd) {
-		if ((cmd->target == TIMEOUT_PUN) && (cmd->device->lun == TIMEOUT_LUN)) {
-			printk("IBM MCA SCSI: Ignoring interrupt from pun=%x, lun=%x.\n", cmd->target, cmd->device->lun);
+		if ((cmd->target == TIMEOUT_PUN) && (scsilun_to_int(&cmd->device->lun) == TIMEOUT_LUN)) {
+			sdev_printk(KERN_INFO, cmd->device,
+				"IBM MCA SCSI: Ignoring interrupt\n");
 			return IRQ_HANDLED;
 		}
 	}
@@ -1832,16 +1833,16 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 	}
 	max_pun = subsystem_maxid(host_index);
 	if (ibm_ansi_order) {
-		target = max_pun - 1 - cmd->device->id;
-		if ((target <= subsystem_pun(host_index)) && (cmd->device->id <= subsystem_pun(host_index)))
+		target = max_pun - 1 - sdev_id(cmd->device);
+		if ((target <= subsystem_pun(host_index)) && (sdev_id(cmd->device) <= subsystem_pun(host_index)))
 			target--;
-		else if ((target >= subsystem_pun(host_index)) && (cmd->device->id >= subsystem_pun(host_index)))
+		else if ((target >= subsystem_pun(host_index)) && (sdev_id(cmd->device) >= subsystem_pun(host_index)))
 			target++;
 	} else
-		target = cmd->device->id;
+		target = sdev_id(cmd->device);
 
 	/* if (target,lun) is NO LUN or not existing at all, return error */
-	if ((get_scsi(host_index)[target][cmd->device->lun] == TYPE_NO_LUN) || (get_scsi(host_index)[target][cmd->device->lun] == TYPE_NO_DEVICE)) {
+	if ((get_scsi(host_index)[target][scsilun_to_int(&cmd->device->lun)] == TYPE_NO_LUN) || (get_scsi(host_index)[target][scsilun_to_int(&cmd->device->lun)] == TYPE_NO_DEVICE)) {
 		cmd->result = DID_NO_CONNECT << 16;
 		if (done)
 			done(cmd);
@@ -1849,7 +1850,7 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 	}
 
 	/*if (target,lun) unassigned, do further checks... */
-	ldn = get_ldn(host_index)[target][cmd->device->lun];
+	ldn = get_ldn(host_index)[target][scsilun_to_int(&cmd->device->lun)];
 	if (ldn >= MAX_LOG_DEV) {	/* on invalid ldn do special stuff */
 		if (ldn > MAX_LOG_DEV) {	/* dynamical remapping if ldn unassigned */
 			current_ldn = next_ldn(host_index);	/* stop-value for one circle */
@@ -1860,7 +1861,10 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 					next_ldn(host_index) = 7;
 				if (current_ldn == next_ldn(host_index)) {	/* One circle done ? */
 					/* no non-processing ldn found */
-					printk("IBM MCA SCSI: Cannot assign SCSI-device dynamically!\n" "              On ldn 7-14 SCSI-commands everywhere in progress.\n" "              Reporting DID_NO_CONNECT for device (%d,%d).\n", target, cmd->device->lun);
+					sdev_printk(KERN_WARNING, cmd->device,
+	"IBM MCA SCSI: Cannot assign SCSI-device dynamically!\n"
+	"              On ldn 7-14 SCSI-commands everywhere in progress.\n"
+	"              Reporting DID_NO_CONNECT for device.\n");
 					cmd->result = DID_NO_CONNECT << 16;	/* return no connect */
 					if (done)
 						done(cmd);
@@ -1880,26 +1884,32 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 			/* set reduced interrupt_handler-mode for checking */
 			local_checking_phase_flag(host_index) = 1;
 			/* map found ldn to pun,lun */
-			get_ldn(host_index)[target][cmd->device->lun] = next_ldn(host_index);
+			get_ldn(host_index)[target][scsilun_to_int(&cmd->device->lun)] = next_ldn(host_index);
 			/* change ldn to the right value, that is now next_ldn */
 			ldn = next_ldn(host_index);
 			/* unassign all ldns (pun,lun,ldn does not matter for remove) */
 			immediate_assign(host_index, 0, 0, 0, REMOVE_LDN);
 			/* set only LDN for remapped device */
-			immediate_assign(host_index, target, cmd->device->lun, ldn, SET_LDN);
+			immediate_assign(host_index, target, scsilun_to_int(&cmd->device->lun), ldn, SET_LDN);
 			/* get device information for ld[ldn] */
 			if (device_exists(host_index, ldn, &ld(host_index)[ldn].block_length, &ld(host_index)[ldn].device_type)) {
 				ld(host_index)[ldn].cmd = NULL;	/* To prevent panic set 0, because
 								   devices that were not assigned,
 								   should have nothing in progress. */
-				get_scsi(host_index)[target][cmd->device->lun] = ld(host_index)[ldn].device_type;
+				get_scsi(host_index)[target][scsilun_to_int(&cmd->device->lun)] = ld(host_index)[ldn].device_type;
 				/* increase assignment counters for statistics in /proc */
 				IBM_DS(host_index).dynamical_assignments++;
 				IBM_DS(host_index).ldn_assignments[ldn]++;
-			} else
+			} else {
+				char lunstr[SCSILUN_STR_LEN];
+
 				/* panic here, because a device, found at boottime has
 				   vanished */
-				panic("IBM MCA SCSI: ldn=0x%x, SCSI-device on (%d,%d) vanished!\n", ldn, target, cmd->device->lun);
+				panic("IBM MCA SCSI: ldn=0x%x, SCSI-device on (%d,%s) vanished!\n",
+					ldn, target,
+					scsilun_to_str(&cmd->device->lun, lunstr));
+			}
+
 			/* unassign again all ldns (pun,lun,ldn does not matter for remove) */
 			immediate_assign(host_index, 0, 0, 0, REMOVE_LDN);
 			/* remap all ldns, as written in the pun/lun table */
@@ -1915,7 +1925,8 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 			local_checking_phase_flag(host_index) = 0;
 #ifdef IM_DEBUG_PROBE
 			/* Information on syslog terminal */
-			printk("IBM MCA SCSI: ldn=0x%x dynamically reassigned to (%d,%d).\n", ldn, target, cmd->device->lun);
+			sdev_printk(KERN_INFO, cmd->device,
+				"IBM MCA SCSI: ldn=0x%x dynamically reassigned to device.\n", ldn);
 #endif
 			/* increase next_ldn for next dynamical assignment */
 			next_ldn(host_index)++;
@@ -2153,17 +2164,18 @@ static int __ibmmca_abort(Scsi_Cmnd * cm
 	}
 	max_pun = subsystem_maxid(host_index);
 	if (ibm_ansi_order) {
-		target = max_pun - 1 - cmd->device->id;
-		if ((target <= subsystem_pun(host_index)) && (cmd->device->id <= subsystem_pun(host_index)))
+		target = max_pun - 1 - sdev_id(cmd->device);
+		if ((target <= subsystem_pun(host_index)) && (sdev_id(cmd->device) <= subsystem_pun(host_index)))
 			target--;
-		else if ((target >= subsystem_pun(host_index)) && (cmd->device->id >= subsystem_pun(host_index)))
+		else if ((target >= subsystem_pun(host_index)) && (sdev_id(cmd->device) >= subsystem_pun(host_index)))
 			target++;
 	} else
-		target = cmd->device->id;
+		target = sdev_id(cmd->device);
 
 	/* get logical device number, and disable system interrupts */
-	printk(KERN_WARNING "IBM MCA SCSI: Sending abort to device pun=%d, lun=%d.\n", target, cmd->device->lun);
-	ldn = get_ldn(host_index)[target][cmd->device->lun];
+	sdev_printk(KERN_WARNING, cmd->device,
+		"IBM MCA SCSI: Sending abort to device.\n");
+	ldn = get_ldn(host_index)[target][scsilun_to_int(&cmd->device->lun)];
 
 	/*if cmd for this ldn has already finished, no need to abort */
 	if (!ld(host_index)[ldn].cmd) {
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 3d62c9b..269cfbe 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -893,7 +893,8 @@ static int idescsi_queue (struct scsi_cm
 	idescsi_pc_t *pc = NULL;
 
 	if (!drive) {
-		printk (KERN_ERR "ide-scsi: drive id %d not present\n", cmd->device->id);
+		sdev_printk (KERN_ERR, cmd->device,
+			"ide-scsi: drive not present\n");
 		goto abort;
 	}
 	scsi = drive_to_idescsi(drive);
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index ea6f3c0..3e8e1e1 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2893,9 +2893,9 @@ static void i91uBuildSCB(HCS * pHCB, SCB
 	pSCB->SCB_Srb = SCpnt;
 	pSCB->SCB_Opcode = ExecSCSI;
 	pSCB->SCB_Flags = SCF_POST;	/* After SCSI done, call post routine */
-	pSCB->SCB_Target = SCpnt->device->id;
-	pSCB->SCB_Lun = SCpnt->device->lun;
-	pSCB->SCB_Ident = SCpnt->device->lun | DISC_ALLOW;
+	pSCB->SCB_Target = sdev_id(SCpnt->device);
+	pSCB->SCB_Lun = scsilun_to_int(&SCpnt->device->lun);
+	pSCB->SCB_Ident = scsilun_to_int(&SCpnt->device->lun) | DISC_ALLOW;
 
 	pSCB->SCB_Flags |= SCF_SENSE;	/* Turn on auto request sense   */
 	dma_addr = dma_map_single(&pHCB->pci_dev->dev, SCpnt->sense_buffer,
@@ -3019,7 +3019,7 @@ static int i91u_biosparam(struct scsi_de
 	TCS *pTcb;
 
 	pHcb = (HCS *) sdev->host->base;
-	pTcb = &pHcb->HCS_Tcs[sdev->id];
+	pTcb = &pHcb->HCS_Tcs[sdev_id(sdev)];
 
 	if (pTcb->TCS_DrvHead) {
 		info_array[0] = pTcb->TCS_DrvHead;
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 9589c67..a624127 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -497,6 +497,7 @@ dc390_StartSCSI( struct dc390_acb* pACB,
     struct scsi_device *sdev = scmd->device;
     u8 cmd, disc_allowed, try_sync_nego;
     char tag[2];
+    struct scsi_lun slun;
 
     pSRB->ScsiPhase = SCSI_NOP0;
 
@@ -546,7 +547,8 @@ dc390_StartSCSI( struct dc390_acb* pACB,
 
     pSRB->MsgCnt = 0;
     cmd = SEL_W_ATN;
-    DC390_write8 (ScsiFifo, IDENTIFY(disc_allowed, pDCB->TargetLUN));
+    int_to_scsilun(pDCB->TargetLUN, &slun);
+    DC390_write8 (ScsiFifo, IDENTIFY(disc_allowed, &slun));
     /* Change 99/05/31: Don't use tags when not disconnecting (BUSY) */
     if ((pDCB->SyncMode & EN_TAG_QUEUEING) && disc_allowed && scsi_populate_tag_msg(scmd, tag)) {
 	DC390_write8(ScsiFifo, tag[0]);
@@ -2077,8 +2079,8 @@ static int DC390_abort(struct scsi_cmnd 
 	struct dc390_acb *pACB = (struct dc390_acb*) cmd->device->host->hostdata;
 	struct dc390_dcb *pDCB = (struct dc390_dcb*) cmd->device->hostdata;
 
-	printk("DC390: Abort command (pid %li, Device %02i-%02i)\n",
-	       cmd->pid, cmd->device->id, cmd->device->lun);
+	sdev_printk(KERN_WARNING, cmd->device,
+		"DC390: Abort command (pid %li)\n", cmd->pid);
 
 	/* abort() is too stupid for already sent commands at the moment. 
 	 * If it's called we are in trouble anyway, so let's dump some info 
@@ -2159,8 +2161,8 @@ static int dc390_slave_alloc(struct scsi
 {
 	struct dc390_acb *pACB = (struct dc390_acb*) scsi_device->host->hostdata;
 	struct dc390_dcb *pDCB, *pDCB2 = NULL;
-	uint id = scsi_device->id;
-	uint lun = scsi_device->lun;
+	uint id = sdev_id(scsi_device);
+	uint lun = scsilun_to_int(&scsi_device->lun);
 
 	pDCB = kmalloc(sizeof(struct dc390_dcb), GFP_KERNEL);
 	if (!pDCB)
diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index c84e148..31e27eb 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -583,14 +583,22 @@ int mts_scsi_queuecommand( Scsi_Cmnd *sr
 	struct mts_desc* desc = (struct mts_desc*)(srb->device->host->hostdata[0]);
 	int err = 0;
 	int res;
+	char lunstr[SCSILUN_STR_LEN];
+
+	(void) lunstr; /* kill unused-var warning, when debug disabled */
 
 	MTS_DEBUG_GOT_HERE();
 	mts_show_command(srb);
 	mts_debug_dump(desc);
 
-	if ( srb->device->lun || srb->device->id || srb->device->channel ) {
-
-		MTS_DEBUG("Command to LUN=%d ID=%d CHANNEL=%d from SCSI layer\n",(int)srb->device->lun,(int)srb->device->id, (int)srb->device->channel );
+	if ( !scsilun_zero(&srb->device->lun) ||
+	     sdev_id(srb->device) ||
+	     sdev_channel(srb->device) ) {
+
+		MTS_DEBUG("Command to LUN=%s ID=%d CHANNEL=%d from SCSI layer\n",
+			scsilun_to_str(&srb->device->lun, lunstr),
+			sdev_id(srb->device),
+			sdev_channel(srb->device) );
 
 		MTS_DEBUG("this device doesn't exist\n");
 
