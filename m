From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.15-rc3
Date: Fri, 15 Dec 2017 09:08:34 -0800
Message-ID: <1513357714.3950.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33210 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755562AbdLORIg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Dec 2017 12:08:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

The most important one is the bfa fix because it's easy to oops the
kernel with this driver (this includes the commit that corrects the
compiler warning in the original), a regression in the new timespec
conversion in aacraid and a regression in the Fibre Channel ELS
handling patch.  The other three are a theoretical problem with
termination in the vendor/host matching code and a use after free in
lpfc.

The additional patches are a fix for an I/O hang in the mq code under
certain circumstances and a rare oops in some debugging code.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Arnd Bergmann (2):
      scsi: bfa: fix type conversion warning
      scsi: aacraid: address UBSAN warning regression

Bart Van Assche (1):
      scsi: core: Fix a scsi_show_rq() NULL pointer dereference

Dan Carpenter (1):
      scsi: lpfc: Use after free in lpfc_rq_buf_free()

Jason Yan (1):
      scsi: libsas: fix length error in sas_smp_handler()

Johannes Thumshirn (2):
      scsi: MAINTAINERS: change FCoE list to linux-scsi
      scsi: bfa: fix access to bfad_im_port_s

Martin Wilck (3):
      scsi: scsi_devinfo: cleanly zero-pad devinfo strings
      scsi: scsi_devinfo: handle non-terminated strings
      scsi: libfc: fix ELS request handling

Ming Lei (1):
      scsi: core: run queue if SCSI device queue isn't ready and queue is idle

And the diffstat:

 MAINTAINERS                        |  2 +-
 drivers/scsi/aacraid/commsup.c     |  8 ++++++--
 drivers/scsi/bfa/bfad_bsg.c        |  6 ++++--
 drivers/scsi/bfa/bfad_im.c         |  6 ++++--
 drivers/scsi/bfa/bfad_im.h         | 10 ++++++++++
 drivers/scsi/libfc/fc_lport.c      |  4 ++++
 drivers/scsi/libsas/sas_expander.c | 10 +++++-----
 drivers/scsi/lpfc/lpfc_mem.c       |  2 +-
 drivers/scsi/scsi_debugfs.c        |  6 ++++--
 drivers/scsi/scsi_devinfo.c        | 27 ++++++++++-----------------
 drivers/scsi/scsi_lib.c            |  2 ++
 drivers/scsi/sd.c                  |  4 +++-
 12 files changed, 54 insertions(+), 33 deletions(-)

With full diff below.

James

---

diff --git a/MAINTAINERS b/MAINTAINERS
index cd7e12dc6af4..37841b52a5b6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5352,7 +5352,7 @@ F:	drivers/media/tuners/fc2580*
 
 FCOE SUBSYSTEM (libfc, libfcoe, fcoe)
 M:	Johannes Thumshirn <jth@kernel.org>
-L:	fcoe-devel@open-fcoe.org
+L:	linux-scsi@vger.kernel.org
 W:	www.Open-FCoE.org
 S:	Supported
 F:	drivers/scsi/libfc/
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index bec9f3193f60..80a8cb26cdea 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -2482,8 +2482,8 @@ int aac_command_thread(void *data)
 			/* Synchronize our watches */
 			if (((NSEC_PER_SEC - (NSEC_PER_SEC / HZ)) > now.tv_nsec)
 			 && (now.tv_nsec > (NSEC_PER_SEC / HZ)))
-				difference = (((NSEC_PER_SEC - now.tv_nsec) * HZ)
-				  + NSEC_PER_SEC / 2) / NSEC_PER_SEC;
+				difference = HZ + HZ / 2 -
+					     now.tv_nsec / (NSEC_PER_SEC / HZ);
 			else {
 				if (now.tv_nsec > NSEC_PER_SEC / 2)
 					++now.tv_sec;
@@ -2507,6 +2507,10 @@ int aac_command_thread(void *data)
 		if (kthread_should_stop())
 			break;
 
+		/*
+		 * we probably want usleep_range() here instead of the
+		 * jiffies computation
+		 */
 		schedule_timeout(difference);
 
 		if (kthread_should_stop())
diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 72ca2a2e08e2..b2fa195adc7a 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3135,7 +3135,8 @@ bfad_im_bsg_vendor_request(struct bsg_job *job)
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
 	uint32_t vendor_cmd = bsg_request->rqst_data.h_vendor.vendor_cmd[0];
-	struct bfad_im_port_s *im_port = shost_priv(fc_bsg_to_shost(job));
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
+	struct bfad_im_port_s *im_port = bfad_get_im_port(shost);
 	struct bfad_s *bfad = im_port->bfad;
 	void *payload_kbuf;
 	int rc = -EINVAL;
@@ -3350,7 +3351,8 @@ int
 bfad_im_bsg_els_ct_request(struct bsg_job *job)
 {
 	struct bfa_bsg_data *bsg_data;
-	struct bfad_im_port_s *im_port = shost_priv(fc_bsg_to_shost(job));
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
+	struct bfad_im_port_s *im_port = bfad_get_im_port(shost);
 	struct bfad_s *bfad = im_port->bfad;
 	bfa_bsg_fcpt_t *bsg_fcpt;
 	struct bfad_fcxp    *drv_fcxp;
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 24e657a4ec80..c05d6e91e4bd 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -546,6 +546,7 @@ int
 bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port,
 			struct device *dev)
 {
+	struct bfad_im_port_pointer *im_portp;
 	int error = 1;
 
 	mutex_lock(&bfad_mutex);
@@ -564,7 +565,8 @@ bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port,
 		goto out_free_idr;
 	}
 
-	im_port->shost->hostdata[0] = (unsigned long)im_port;
+	im_portp = shost_priv(im_port->shost);
+	im_portp->p = im_port;
 	im_port->shost->unique_id = im_port->idr_id;
 	im_port->shost->this_id = -1;
 	im_port->shost->max_id = MAX_FCP_TARGET;
@@ -748,7 +750,7 @@ bfad_scsi_host_alloc(struct bfad_im_port_s *im_port, struct bfad_s *bfad)
 
 	sht->sg_tablesize = bfad->cfg_data.io_max_sge;
 
-	return scsi_host_alloc(sht, sizeof(unsigned long));
+	return scsi_host_alloc(sht, sizeof(struct bfad_im_port_pointer));
 }
 
 void
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index c81ec2a77ef5..06ce4ba2b7bc 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -69,6 +69,16 @@ struct bfad_im_port_s {
 	struct fc_vport *fc_vport;
 };
 
+struct bfad_im_port_pointer {
+	struct bfad_im_port_s *p;
+};
+
+static inline struct bfad_im_port_s *bfad_get_im_port(struct Scsi_Host *host)
+{
+	struct bfad_im_port_pointer *im_portp = shost_priv(host);
+	return im_portp->p;
+}
+
 enum bfad_itnim_state {
 	ITNIM_STATE_NONE,
 	ITNIM_STATE_ONLINE,
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 5da46052e179..21be672679fb 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -904,10 +904,14 @@ static void fc_lport_recv_els_req(struct fc_lport *lport,
 		case ELS_FLOGI:
 			if (!lport->point_to_multipoint)
 				fc_lport_recv_flogi_req(lport, fp);
+			else
+				fc_rport_recv_req(lport, fp);
 			break;
 		case ELS_LOGO:
 			if (fc_frame_sid(fp) == FC_FID_FLOGI)
 				fc_lport_recv_logo_req(lport, fp);
+			else
+				fc_rport_recv_req(lport, fp);
 			break;
 		case ELS_RSCN:
 			lport->tt.disc_recv_req(lport, fp);
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 174e5eff6155..c7f21661b3cd 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2145,7 +2145,7 @@ void sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 		struct sas_rphy *rphy)
 {
 	struct domain_device *dev;
-	unsigned int reslen = 0;
+	unsigned int rcvlen = 0;
 	int ret = -EINVAL;
 
 	/* no rphy means no smp target support (ie aic94xx host) */
@@ -2179,12 +2179,12 @@ void sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 
 	ret = smp_execute_task_sg(dev, job->request_payload.sg_list,
 			job->reply_payload.sg_list);
-	if (ret > 0) {
-		/* positive number is the untransferred residual */
-		reslen = ret;
+	if (ret >= 0) {
+		/* bsg_job_done() requires the length received  */
+		rcvlen = job->reply_payload.payload_len - ret;
 		ret = 0;
 	}
 
 out:
-	bsg_job_done(job, ret, reslen);
+	bsg_job_done(job, ret, rcvlen);
 }
diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 56faeb049b4a..87c08ff37ddd 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -753,12 +753,12 @@ lpfc_rq_buf_free(struct lpfc_hba *phba, struct lpfc_dmabuf *mp)
 	drqe.address_hi = putPaddrHigh(rqb_entry->dbuf.phys);
 	rc = lpfc_sli4_rq_put(rqb_entry->hrq, rqb_entry->drq, &hrqe, &drqe);
 	if (rc < 0) {
-		(rqbp->rqb_free_buffer)(phba, rqb_entry);
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"6409 Cannot post to RQ %d: %x %x\n",
 				rqb_entry->hrq->queue_id,
 				rqb_entry->hrq->host_index,
 				rqb_entry->hrq->hba_index);
+		(rqbp->rqb_free_buffer)(phba, rqb_entry);
 	} else {
 		list_add_tail(&rqb_entry->hbuf.list, &rqbp->rqb_buffer_list);
 		rqbp->buffer_count++;
diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
index 01f08c03f2c1..c3765d29fd3f 100644
--- a/drivers/scsi/scsi_debugfs.c
+++ b/drivers/scsi/scsi_debugfs.c
@@ -8,9 +8,11 @@ void scsi_show_rq(struct seq_file *m, struct request *rq)
 {
 	struct scsi_cmnd *cmd = container_of(scsi_req(rq), typeof(*cmd), req);
 	int msecs = jiffies_to_msecs(jiffies - cmd->jiffies_at_alloc);
-	char buf[80];
+	const u8 *const cdb = READ_ONCE(cmd->cmnd);
+	char buf[80] = "(?)";
 
-	__scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd->cmd_len);
+	if (cdb)
+		__scsi_format_command(buf, sizeof(buf), cdb, cmd->cmd_len);
 	seq_printf(m, ", .cmd=%s, .retries=%d, allocated %d.%03d s ago", buf,
 		   cmd->retries, msecs / 1000, msecs % 1000);
 }
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 78d4aa8df675..449ef5adbb2b 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -34,7 +34,6 @@ struct scsi_dev_info_list_table {
 };
 
 
-static const char spaces[] = "                "; /* 16 of them */
 static blist_flags_t scsi_default_dev_flags;
 static LIST_HEAD(scsi_dev_info_list);
 static char scsi_dev_flags[256];
@@ -298,20 +297,13 @@ static void scsi_strcpy_devinfo(char *name, char *to, size_t to_length,
 	size_t from_length;
 
 	from_length = strlen(from);
-	strncpy(to, from, min(to_length, from_length));
-	if (from_length < to_length) {
-		if (compatible) {
-			/*
-			 * NUL terminate the string if it is short.
-			 */
-			to[from_length] = '\0';
-		} else {
-			/*
-			 * space pad the string if it is short.
-			 */
-			strncpy(&to[from_length], spaces,
-				to_length - from_length);
-		}
+	/* This zero-pads the destination */
+	strncpy(to, from, to_length);
+	if (from_length < to_length && !compatible) {
+		/*
+		 * space pad the string if it is short.
+		 */
+		memset(&to[from_length], ' ', to_length - from_length);
 	}
 	if (from_length > to_length)
 		 printk(KERN_WARNING "%s: %s string '%s' is too long\n",
@@ -458,7 +450,8 @@ static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
 			/*
 			 * vendor strings must be an exact match
 			 */
-			if (vmax != strlen(devinfo->vendor) ||
+			if (vmax != strnlen(devinfo->vendor,
+					    sizeof(devinfo->vendor)) ||
 			    memcmp(devinfo->vendor, vskip, vmax))
 				continue;
 
@@ -466,7 +459,7 @@ static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
 			 * @model specifies the full string, and
 			 * must be larger or equal to devinfo->model
 			 */
-			mlen = strlen(devinfo->model);
+			mlen = strnlen(devinfo->model, sizeof(devinfo->model));
 			if (mmax < mlen || memcmp(devinfo->model, mskip, mlen))
 				continue;
 			return devinfo;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 00742c50cd44..d9ca1dfab154 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1967,6 +1967,8 @@ static bool scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
 out_put_device:
 	put_device(&sdev->sdev_gendev);
 out:
+	if (atomic_read(&sdev->device_busy) == 0 && !scsi_device_blocked(sdev))
+		blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
 	return false;
 }
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 24fe68522716..a028ab3322a9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1312,6 +1312,7 @@ static int sd_init_command(struct scsi_cmnd *cmd)
 static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 {
 	struct request *rq = SCpnt->request;
+	u8 *cmnd;
 
 	if (SCpnt->flags & SCMD_ZONE_WRITE_LOCK)
 		sd_zbc_write_unlock_zone(SCpnt);
@@ -1320,9 +1321,10 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 		__free_page(rq->special_vec.bv_page);
 
 	if (SCpnt->cmnd != scsi_req(rq)->cmd) {
-		mempool_free(SCpnt->cmnd, sd_cdb_pool);
+		cmnd = SCpnt->cmnd;
 		SCpnt->cmnd = NULL;
 		SCpnt->cmd_len = 0;
+		mempool_free(cmnd, sd_cdb_pool);
 	}
 }
 
