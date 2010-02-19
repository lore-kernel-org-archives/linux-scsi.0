From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] hopefully final SCSI fixes for 2.6.33-rc8
Date: Fri, 19 Feb 2010 15:40:51 -0600
Message-ID: <1266615651.11245.6.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is just a few minor fixes (well one more major one in the megaraid
SAS compat ioctls to prevent deref of a wrong userspace pointer).

The patch is available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Bhanu Prakash Gollapudi (1):
      libfcoe: Send port LKA every FIP_VN_KA_PERIOD secs.

Hugh Daschbach (2):
      libfc: Don't assume response request present.
      libfc: Fix e_d_tov ns -> ms scaling factor in PLOGI response.

Mike Christie (1):
      iscsi_tcp regression: remove bogus warn on in write path

Rob Love (1):
      fcoe: Only rmmod fcoe.ko if there are no active connections

Tomas Henzl (1):
      megaraid_sas: fix for 32bit apps

Vasu Dev (1):
      libfc: call ddp setup for only FCP reads to avoid accessing junk fsp pointer

And the diffstat:

 drivers/scsi/fcoe/fcoe.c             |   18 ++++++++++++++++--
 drivers/scsi/fcoe/libfcoe.c          |    2 +-
 drivers/scsi/libfc/fc_exch.c         |    2 +-
 drivers/scsi/libfc/fc_fcp.c          |    3 ---
 drivers/scsi/libfc/fc_lport.c        |    3 ++-
 drivers/scsi/libfc/fc_rport.c        |    2 +-
 drivers/scsi/libiscsi_tcp.c          |    8 +++-----
 drivers/scsi/megaraid/megaraid_sas.c |   18 ++++++++++++++++--
 8 files changed, 40 insertions(+), 16 deletions(-)

The full diff is below.

James

---

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 10be9f3..2f47ae7 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2009,6 +2009,8 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 	fcoe_interface_cleanup(fcoe);
 	rtnl_unlock();
 	fcoe_if_destroy(fcoe->ctlr.lp);
+	module_put(THIS_MODULE);
+
 out_putdev:
 	dev_put(netdev);
 out_nodev:
@@ -2059,6 +2061,11 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 	}
 #endif
 
+	if (!try_module_get(THIS_MODULE)) {
+		rc = -EINVAL;
+		goto out_nomod;
+	}
+
 	rtnl_lock();
 	netdev = fcoe_if_to_netdev(buffer);
 	if (!netdev) {
@@ -2099,17 +2106,24 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 	if (!fcoe_link_ok(lport))
 		fcoe_ctlr_link_up(&fcoe->ctlr);
 
-	rc = 0;
-out_free:
 	/*
 	 * Release from init in fcoe_interface_create(), on success lport
 	 * should be holding a reference taken in fcoe_if_create().
 	 */
 	fcoe_interface_put(fcoe);
+	dev_put(netdev);
+	rtnl_unlock();
+	mutex_unlock(&fcoe_config_mutex);
+
+	return 0;
+out_free:
+	fcoe_interface_put(fcoe);
 out_putdev:
 	dev_put(netdev);
 out_nodev:
 	rtnl_unlock();
+	module_put(THIS_MODULE);
+out_nomod:
 	mutex_unlock(&fcoe_config_mutex);
 	return rc;
 }
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 9823291..511cb6b 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -1187,7 +1187,7 @@ static void fcoe_ctlr_timeout(unsigned long arg)
 			next_timer = fip->ctlr_ka_time;
 
 		if (time_after_eq(jiffies, fip->port_ka_time)) {
-			fip->port_ka_time += jiffies +
+			fip->port_ka_time = jiffies +
 				msecs_to_jiffies(FIP_VN_KA_PERIOD);
 			fip->send_port_ka = 1;
 		}
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 19d711c..7f43647 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1890,7 +1890,7 @@ static struct fc_seq *fc_exch_seq_send(struct fc_lport *lport,
 	fc_exch_setup_hdr(ep, fp, ep->f_ctl);
 	sp->cnt++;
 
-	if (ep->xid <= lport->lro_xid)
+	if (ep->xid <= lport->lro_xid && fh->fh_r_ctl == FC_RCTL_DD_UNSOL_CMD)
 		fc_fcp_ddp_setup(fr_fsp(fp), ep->xid);
 
 	if (unlikely(lport->tt.frame_send(lport, fp)))
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 881d5df..6fde2fa 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -298,9 +298,6 @@ void fc_fcp_ddp_setup(struct fc_fcp_pkt *fsp, u16 xid)
 {
 	struct fc_lport *lport;
 
-	if (!fsp)
-		return;
-
 	lport = fsp->lp;
 	if ((fsp->req_flags & FC_SRB_READ) &&
 	    (lport->lro_enabled) && (lport->tt.ddp_setup)) {
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 0b16502..7ec8ce7 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1800,7 +1800,8 @@ int fc_lport_bsg_request(struct fc_bsg_job *job)
 	u32 did;
 
 	job->reply->reply_payload_rcv_len = 0;
-	rsp->resid_len = job->reply_payload.payload_len;
+	if (rsp)
+		rsp->resid_len = job->reply_payload.payload_len;
 
 	mutex_lock(&lport->lp_mutex);
 
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 0230052..97923bb 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -623,7 +623,7 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 		tov = ntohl(plp->fl_csp.sp_e_d_tov);
 		if (ntohs(plp->fl_csp.sp_features) & FC_SP_FT_EDTR)
-			tov /= 1000;
+			tov /= 1000000;
 		if (tov > rdata->e_d_tov)
 			rdata->e_d_tov = tov;
 		csp_seq = ntohs(plp->fl_csp.sp_tot_seq);
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index db6856c..4ad87fd 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -992,12 +992,10 @@ static struct iscsi_r2t_info *iscsi_tcp_get_curr_r2t(struct iscsi_task *task)
 		if (r2t == NULL) {
 			if (kfifo_out(&tcp_task->r2tqueue,
 			    (void *)&tcp_task->r2t, sizeof(void *)) !=
-			    sizeof(void *)) {
-				WARN_ONCE(1, "unexpected fifo state");
+			    sizeof(void *))
 				r2t = NULL;
-			}
-
-			r2t = tcp_task->r2t;
+			else
+				r2t = tcp_task->r2t;
 		}
 		spin_unlock_bh(&session->lock);
 	}
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index 708ea31..d9b8ca5 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -3781,6 +3781,7 @@ static int megasas_mgmt_compat_ioctl_fw(struct file *file, unsigned long arg)
 	    compat_alloc_user_space(sizeof(struct megasas_iocpacket));
 	int i;
 	int error = 0;
+	compat_uptr_t ptr;
 
 	if (clear_user(ioc, sizeof(*ioc)))
 		return -EFAULT;
@@ -3793,9 +3794,22 @@ static int megasas_mgmt_compat_ioctl_fw(struct file *file, unsigned long arg)
 	    copy_in_user(&ioc->sge_count, &cioc->sge_count, sizeof(u32)))
 		return -EFAULT;
 
-	for (i = 0; i < MAX_IOCTL_SGE; i++) {
-		compat_uptr_t ptr;
+	/*
+	 * The sense_ptr is used in megasas_mgmt_fw_ioctl only when
+	 * sense_len is not null, so prepare the 64bit value under
+	 * the same condition.
+	 */
+	if (ioc->sense_len) {
+		void __user **sense_ioc_ptr =
+			(void __user **)(ioc->frame.raw + ioc->sense_off);
+		compat_uptr_t *sense_cioc_ptr =
+			(compat_uptr_t *)(cioc->frame.raw + cioc->sense_off);
+		if (get_user(ptr, sense_cioc_ptr) ||
+		    put_user(compat_ptr(ptr), sense_ioc_ptr))
+			return -EFAULT;
+	}
 
+	for (i = 0; i < MAX_IOCTL_SGE; i++) {
 		if (get_user(ptr, &cioc->sgl[i].iov_base) ||
 		    put_user(compat_ptr(ptr), &ioc->sgl[i].iov_base) ||
 		    copy_in_user(&ioc->sgl[i].iov_len,
