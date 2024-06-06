Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59332376E1;
	Thu,  6 Jun 2024 19:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717700640; cv=none; b=Y8Cnv1ZlsFX8txh9jBS//oEO/na5JNZ1TkVYXMJXMk96ZTC1mjtfluVvjqs+OS9i4HiJy85llmAIGuDJVL07YPSWKWaAr7zOgz2WvNUs0aL87giceM4LX/ozmYUrgZ2Dp2c+p5NeVLogvig/Ihuw+RjO/d0lUD/7ab557jEYU6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717700640; c=relaxed/simple;
	bh=sM2fruqe2GVCx9QWiEjFs8vSme9xyR0nkxfLy6JT6D4=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=MMUpKvSQn6QJaP/NygR8jlsrijWtjGZ+UdS7aqYRPPUVGe8/SWU3HnV5Yz1nAQIPxQ67W89MUVPZMNjOVUjqc9OqR1ZDR8iIhDzZjchnbnWcA0l7/jughG8D+VneFUIBXwjHi5YWjwMw/mig/YUpUcZamRNT2c4NBBScEQYJP84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=O2sgle/t; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=O2sgle/t; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="O2sgle/t";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="O2sgle/t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1717700635;
	bh=sM2fruqe2GVCx9QWiEjFs8vSme9xyR0nkxfLy6JT6D4=;
	h=Message-ID:Subject:From:To:Date:From;
	b=O2sgle/tEDZXEjX3Mw5wcJ4JKNt0NjRWMlV7gM4pnbZWW8/1EvOLEzRmOdkNiGHJ/
	 dihYQ2vu608S2IRg7siIgQYN492q9GmmoNJbk6MdJ5/pkyuvm60Usktjnn2kGA734w
	 DpNOZdAX6oyc/5ONgOG2UQQ/sCImI5LXtl2t9L0w=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 630801287BCB;
	Thu, 06 Jun 2024 15:03:55 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id SZFy_fLqlUTU; Thu,  6 Jun 2024 15:03:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1717700635;
	bh=sM2fruqe2GVCx9QWiEjFs8vSme9xyR0nkxfLy6JT6D4=;
	h=Message-ID:Subject:From:To:Date:From;
	b=O2sgle/tEDZXEjX3Mw5wcJ4JKNt0NjRWMlV7gM4pnbZWW8/1EvOLEzRmOdkNiGHJ/
	 dihYQ2vu608S2IRg7siIgQYN492q9GmmoNJbk6MdJ5/pkyuvm60Usktjnn2kGA734w
	 DpNOZdAX6oyc/5ONgOG2UQQ/sCImI5LXtl2t9L0w=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id B62CF1287BC7;
	Thu, 06 Jun 2024 15:03:54 -0400 (EDT)
Message-ID: <f91727d00e7d2c0084c71022bb0884442fd1e13e.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.10-rc2
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Thu, 06 Jun 2024 15:03:50 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

The core change is to detect unusually large number of VPD pages
(caused by device manufacturers having an endiannes issue) and reject
them rather than trying to parse a huge non-existent array.  The
remaining fixes are in drivers the most user visible of which is the
ALUA state transition recognition (leads to intermittent I/O errors in
some situations otherwise).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Chanwoo Lee (1):
      scsi: ufs: mcq: Fix error output and clean up ufshcd_mcq_abort()

Deming Wang (1):
      scsi: mpt3sas: Add missing kerneldoc parameter descriptions

Justin Stitt (1):
      scsi: sr: Fix unintentional arithmetic wraparound

Martin K. Petersen (1):
      scsi: core: Handle devices which return an unusually large VPD page count

Martin Wilck (1):
      scsi: core: alua: I/O errors for ALUA state transitions

Nathan Chancellor (1):
      scsi: mpi3mr: Use proper format specifier in mpi3mr_sas_port_add()

Saurav Kashyap (3):
      scsi: qedf: Set qed_slowpath_params to zero before use
      scsi: qedf: Wait for stag work during unload
      scsi: qedf: Don't process stag work during unload and recovery

And the diffstat:

 Documentation/cdrom/cdrom-standard.rst     |  4 +--
 drivers/scsi/device_handler/scsi_dh_alua.c | 31 ++++++++++++++------
 drivers/scsi/mpi3mr/mpi3mr_transport.c     |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c       |  4 +--
 drivers/scsi/qedf/qedf.h                   |  1 +
 drivers/scsi/qedf/qedf_main.c              | 47 ++++++++++++++++++++++++++++--
 drivers/scsi/scsi.c                        |  7 +++++
 drivers/scsi/sr.h                          |  2 +-
 drivers/scsi/sr_ioctl.c                    |  5 +++-
 drivers/ufs/core/ufs-mcq.c                 | 17 +++++------
 include/linux/cdrom.h                      |  2 +-
 11 files changed, 93 insertions(+), 29 deletions(-)

With full diff below

James

---

diff --git a/Documentation/cdrom/cdrom-standard.rst b/Documentation/cdrom/cdrom-standard.rst
index 7964fe134277..6c1303cff159 100644
--- a/Documentation/cdrom/cdrom-standard.rst
+++ b/Documentation/cdrom/cdrom-standard.rst
@@ -217,7 +217,7 @@ current *struct* is::
 		int (*media_changed)(struct cdrom_device_info *, int);
 		int (*tray_move)(struct cdrom_device_info *, int);
 		int (*lock_door)(struct cdrom_device_info *, int);
-		int (*select_speed)(struct cdrom_device_info *, int);
+		int (*select_speed)(struct cdrom_device_info *, unsigned long);
 		int (*get_last_session) (struct cdrom_device_info *,
 					 struct cdrom_multisession *);
 		int (*get_mcn)(struct cdrom_device_info *, struct cdrom_mcn *);
@@ -396,7 +396,7 @@ action need be taken, and the return value should be 0.
 
 ::
 
-	int select_speed(struct cdrom_device_info *cdi, int speed)
+	int select_speed(struct cdrom_device_info *cdi, unsigned long speed)
 
 Some CD-ROM drives are capable of changing their head-speed. There
 are several reasons for changing the speed of a CD-ROM drive. Badly
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index a226dc1b65d7..4eb0837298d4 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -414,28 +414,40 @@ static char print_alua_state(unsigned char state)
 	}
 }
 
-static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
-					      struct scsi_sense_hdr *sense_hdr)
+static void alua_handle_state_transition(struct scsi_device *sdev)
 {
 	struct alua_dh_data *h = sdev->handler_data;
 	struct alua_port_group *pg;
 
+	rcu_read_lock();
+	pg = rcu_dereference(h->pg);
+	if (pg)
+		pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
+	rcu_read_unlock();
+	alua_check(sdev, false);
+}
+
+static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
+					      struct scsi_sense_hdr *sense_hdr)
+{
 	switch (sense_hdr->sense_key) {
 	case NOT_READY:
 		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
 			/*
 			 * LUN Not Accessible - ALUA state transition
 			 */
-			rcu_read_lock();
-			pg = rcu_dereference(h->pg);
-			if (pg)
-				pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
-			rcu_read_unlock();
-			alua_check(sdev, false);
+			alua_handle_state_transition(sdev);
 			return NEEDS_RETRY;
 		}
 		break;
 	case UNIT_ATTENTION:
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
+			/*
+			 * LUN Not Accessible - ALUA state transition
+			 */
+			alua_handle_state_transition(sdev);
+			return NEEDS_RETRY;
+		}
 		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) {
 			/*
 			 * Power On, Reset, or Bus Device Reset.
@@ -502,7 +514,8 @@ static int alua_tur(struct scsi_device *sdev)
 
 	retval = scsi_test_unit_ready(sdev, ALUA_FAILOVER_TIMEOUT * HZ,
 				      ALUA_FAILOVER_RETRIES, &sense_hdr);
-	if (sense_hdr.sense_key == NOT_READY &&
+	if ((sense_hdr.sense_key == NOT_READY ||
+	     sense_hdr.sense_key == UNIT_ATTENTION) &&
 	    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
 		return SCSI_DH_RETRY;
 	else if (retval)
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 329cc6ec3b58..82aa4e418c5a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1364,7 +1364,7 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 			continue;
 
 		if (i > sizeof(mr_sas_port->phy_mask) * 8) {
-			ioc_warn(mrioc, "skipping port %u, max allowed value is %lu\n",
+			ioc_warn(mrioc, "skipping port %u, max allowed value is %zu\n",
 			    i, sizeof(mr_sas_port->phy_mask) * 8);
 			goto out_fail;
 		}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 89ef43a5ef86..12d08d8ba538 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -302,8 +302,8 @@ struct _scsi_io_transfer {
 
 /**
  * _scsih_set_debug_level - global setting of ioc->logging_level.
- * @val: ?
- * @kp: ?
+ * @val: value of the parameter to be set
+ * @kp: pointer to kernel_param structure
  *
  * Note: The logging levels are defined in mpt3sas_debug.h.
  */
diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index 5058e01b65a2..98afdfe63600 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -363,6 +363,7 @@ struct qedf_ctx {
 #define QEDF_IN_RECOVERY		5
 #define QEDF_DBG_STOP_IO		6
 #define QEDF_PROBING			8
+#define QEDF_STAG_IN_PROGRESS		9
 	unsigned long flags; /* Miscellaneous state flags */
 	int fipvlan_retries;
 	u8 num_queues;
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index fd12439cbaab..49adddf978cc 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -318,11 +318,18 @@ static struct fc_seq *qedf_elsct_send(struct fc_lport *lport, u32 did,
 	 */
 	if (resp == fc_lport_flogi_resp) {
 		qedf->flogi_cnt++;
+		qedf->flogi_pending++;
+
+		if (test_bit(QEDF_UNLOADING, &qedf->flags)) {
+			QEDF_ERR(&qedf->dbg_ctx, "Driver unloading\n");
+			qedf->flogi_pending = 0;
+		}
+
 		if (qedf->flogi_pending >= QEDF_FLOGI_RETRY_CNT) {
 			schedule_delayed_work(&qedf->stag_work, 2);
 			return NULL;
 		}
-		qedf->flogi_pending++;
+
 		return fc_elsct_send(lport, did, fp, op, qedf_flogi_resp,
 		    arg, timeout);
 	}
@@ -912,13 +919,14 @@ void qedf_ctx_soft_reset(struct fc_lport *lport)
 	struct qedf_ctx *qedf;
 	struct qed_link_output if_link;
 
+	qedf = lport_priv(lport);
+
 	if (lport->vport) {
+		clear_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags);
 		printk_ratelimited("Cannot issue host reset on NPIV port.\n");
 		return;
 	}
 
-	qedf = lport_priv(lport);
-
 	qedf->flogi_pending = 0;
 	/* For host reset, essentially do a soft link up/down */
 	atomic_set(&qedf->link_state, QEDF_LINK_DOWN);
@@ -938,6 +946,7 @@ void qedf_ctx_soft_reset(struct fc_lport *lport)
 	if (!if_link.link_up) {
 		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
 			  "Physical link is not up.\n");
+		clear_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags);
 		return;
 	}
 	/* Flush and wait to make sure link down is processed */
@@ -950,6 +959,7 @@ void qedf_ctx_soft_reset(struct fc_lport *lport)
 		  "Queue link up work.\n");
 	queue_delayed_work(qedf->link_update_wq, &qedf->link_update,
 	    0);
+	clear_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags);
 }
 
 /* Reset the host by gracefully logging out and then logging back in */
@@ -3463,6 +3473,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 
 	/* Start the Slowpath-process */
+	memset(&slowpath_params, 0, sizeof(struct qed_slowpath_params));
 	slowpath_params.int_mode = QED_INT_MODE_MSIX;
 	slowpath_params.drv_major = QEDF_DRIVER_MAJOR_VER;
 	slowpath_params.drv_minor = QEDF_DRIVER_MINOR_VER;
@@ -3721,6 +3732,7 @@ static void __qedf_remove(struct pci_dev *pdev, int mode)
 {
 	struct qedf_ctx *qedf;
 	int rc;
+	int cnt = 0;
 
 	if (!pdev) {
 		QEDF_ERR(NULL, "pdev is NULL.\n");
@@ -3738,6 +3750,17 @@ static void __qedf_remove(struct pci_dev *pdev, int mode)
 		return;
 	}
 
+stag_in_prog:
+	if (test_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags)) {
+		QEDF_ERR(&qedf->dbg_ctx, "Stag in progress, cnt=%d.\n", cnt);
+		cnt++;
+
+		if (cnt < 5) {
+			msleep(500);
+			goto stag_in_prog;
+		}
+	}
+
 	if (mode != QEDF_MODE_RECOVERY)
 		set_bit(QEDF_UNLOADING, &qedf->flags);
 
@@ -3997,6 +4020,24 @@ void qedf_stag_change_work(struct work_struct *work)
 	struct qedf_ctx *qedf =
 	    container_of(work, struct qedf_ctx, stag_work.work);
 
+	if (!qedf) {
+		QEDF_ERR(&qedf->dbg_ctx, "qedf is NULL");
+		return;
+	}
+
+	if (test_bit(QEDF_IN_RECOVERY, &qedf->flags)) {
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "Already is in recovery, hence not calling software context reset.\n");
+		return;
+	}
+
+	if (test_bit(QEDF_UNLOADING, &qedf->flags)) {
+		QEDF_ERR(&qedf->dbg_ctx, "Driver unloading\n");
+		return;
+	}
+
+	set_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags);
+
 	printk_ratelimited("[%s]:[%s:%d]:%d: Performing software context reset.",
 			dev_name(&qedf->pdev->dev), __func__, __LINE__,
 			qedf->dbg_ctx.host_no);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 3e0c0381277a..f0464db3f9de 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -350,6 +350,13 @@ static int scsi_get_vpd_size(struct scsi_device *sdev, u8 page)
 		if (result < SCSI_VPD_HEADER_SIZE)
 			return 0;
 
+		if (result > sizeof(vpd)) {
+			dev_warn_once(&sdev->sdev_gendev,
+				      "%s: long VPD page 0 length: %d bytes\n",
+				      __func__, result);
+			result = sizeof(vpd);
+		}
+
 		result -= SCSI_VPD_HEADER_SIZE;
 		if (!memchr(&vpd[SCSI_VPD_HEADER_SIZE], page, result))
 			return 0;
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 1175f2e213b5..dc899277b3a4 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -65,7 +65,7 @@ int sr_disk_status(struct cdrom_device_info *);
 int sr_get_last_session(struct cdrom_device_info *, struct cdrom_multisession *);
 int sr_get_mcn(struct cdrom_device_info *, struct cdrom_mcn *);
 int sr_reset(struct cdrom_device_info *);
-int sr_select_speed(struct cdrom_device_info *cdi, int speed);
+int sr_select_speed(struct cdrom_device_info *cdi, unsigned long speed);
 int sr_audio_ioctl(struct cdrom_device_info *, unsigned int, void *);
 
 int sr_is_xa(Scsi_CD *);
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 5b0b35e60e61..a0d2556a27bb 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -425,11 +425,14 @@ int sr_reset(struct cdrom_device_info *cdi)
 	return 0;
 }
 
-int sr_select_speed(struct cdrom_device_info *cdi, int speed)
+int sr_select_speed(struct cdrom_device_info *cdi, unsigned long speed)
 {
 	Scsi_CD *cd = cdi->handle;
 	struct packet_command cgc;
 
+	/* avoid exceeding the max speed or overflowing integer bounds */
+	speed = clamp(0, speed, 0xffff / 177);
+
 	if (speed == 0)
 		speed = 0xffff;	/* set to max */
 	else
diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 005d63ab1f44..8944548c30fa 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -634,20 +634,20 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	struct ufs_hw_queue *hwq;
 	unsigned long flags;
-	int err = FAILED;
+	int err;
 
 	if (!ufshcd_cmd_inflight(lrbp->cmd)) {
 		dev_err(hba->dev,
 			"%s: skip abort. cmd at tag %d already completed.\n",
 			__func__, tag);
-		goto out;
+		return FAILED;
 	}
 
 	/* Skip task abort in case previous aborts failed and report failure */
 	if (lrbp->req_abort_skip) {
 		dev_err(hba->dev, "%s: skip abort. tag %d failed earlier\n",
 			__func__, tag);
-		goto out;
+		return FAILED;
 	}
 
 	hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
@@ -659,7 +659,7 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 		 */
 		dev_err(hba->dev, "%s: cmd found in sq. hwq=%d, tag=%d\n",
 			__func__, hwq->id, tag);
-		goto out;
+		return FAILED;
 	}
 
 	/*
@@ -667,18 +667,17 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 	 * in the completion queue either. Query the device to see if
 	 * the command is being processed in the device.
 	 */
-	if (ufshcd_try_to_abort_task(hba, tag)) {
+	err = ufshcd_try_to_abort_task(hba, tag);
+	if (err) {
 		dev_err(hba->dev, "%s: device abort failed %d\n", __func__, err);
 		lrbp->req_abort_skip = true;
-		goto out;
+		return FAILED;
 	}
 
-	err = SUCCESS;
 	spin_lock_irqsave(&hwq->cq_lock, flags);
 	if (ufshcd_cmd_inflight(lrbp->cmd))
 		ufshcd_release_scsi_cmd(hba, lrbp);
 	spin_unlock_irqrestore(&hwq->cq_lock, flags);
 
-out:
-	return err;
+	return SUCCESS;
 }
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index 98c6fd0b39b6..fdfb61ccf55a 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -77,7 +77,7 @@ struct cdrom_device_ops {
 				      unsigned int clearing, int slot);
 	int (*tray_move) (struct cdrom_device_info *, int);
 	int (*lock_door) (struct cdrom_device_info *, int);
-	int (*select_speed) (struct cdrom_device_info *, int);
+	int (*select_speed) (struct cdrom_device_info *, unsigned long);
 	int (*get_last_session) (struct cdrom_device_info *,
 				 struct cdrom_multisession *);
 	int (*get_mcn) (struct cdrom_device_info *,

