From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.15-rc3
Date: Tue, 12 Dec 2017 08:21:26 -0800
Message-ID: <1513095686.3110.9.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The most important one is the bfa fix because it's easy to oops the
kernel with this driver, a regression in the new timespec conversion in
aacraid and a regression in the Fibre Channel ELS handling patch.  The
other three are a theoretical problem with termination in the
vendor/host matching code and a use after free in lpfc.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Arnd Bergmann (1):
      scsi: aacraid: address UBSAN warning regression

Dan Carpenter (1):
      scsi: lpfc: Use after free in lpfc_rq_buf_free()

Johannes Thumshirn (1):
      scsi: bfa: fix access to bfad_im_port_s

Martin Wilck (3):
      scsi: scsi_devinfo: cleanly zero-pad devinfo strings
      scsi: scsi_devinfo: handle non-terminated strings
      scsi: libfc: fix ELS request handling

With the diffstat:

 drivers/scsi/aacraid/commsup.c |  8 ++++++--
 drivers/scsi/bfa/bfad_bsg.c    |  6 ++++--
 drivers/scsi/libfc/fc_lport.c  |  4 ++++
 drivers/scsi/lpfc/lpfc_mem.c   |  2 +-
 drivers/scsi/scsi_devinfo.c    | 27 ++++++++++-----------------
 5 files changed, 25 insertions(+), 22 deletions(-)


And full diff below

James

---

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
index 72ca2a2e08e2..09ef68c8225f 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3135,7 +3135,8 @@ bfad_im_bsg_vendor_request(struct bsg_job *job)
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
 	uint32_t vendor_cmd = bsg_request->rqst_data.h_vendor.vendor_cmd[0];
-	struct bfad_im_port_s *im_port = shost_priv(fc_bsg_to_shost(job));
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
+	struct bfad_im_port_s *im_port = shost->hostdata[0];
 	struct bfad_s *bfad = im_port->bfad;
 	void *payload_kbuf;
 	int rc = -EINVAL;
@@ -3350,7 +3351,8 @@ int
 bfad_im_bsg_els_ct_request(struct bsg_job *job)
 {
 	struct bfa_bsg_data *bsg_data;
-	struct bfad_im_port_s *im_port = shost_priv(fc_bsg_to_shost(job));
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
+	struct bfad_im_port_s *im_port = shost->hostdata[0];
 	struct bfad_s *bfad = im_port->bfad;
 	bfa_bsg_fcpt_t *bsg_fcpt;
 	struct bfad_fcxp    *drv_fcxp;
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
