Received: from rcdn-iport-1.cisco.com (rcdn-iport-1.cisco.com [173.37.86.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D883BBF6;
	Fri,  9 Aug 2024 16:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723222143; cv=none; b=MG3KzrJHIfKh2vz5vnpBni54UsOVBp6siu6uAc4s7/YkfrC9e2hZJzQVY5ei+SEbe1Sfpzu8pkl32YqRO1B/W4Nt6AuDq6nbglZgNw4323UZdurG/+RwkDEvdoqhav4SkzXOR6ht4kN12XPyvaaJchzx7VyJDbDW6dR4+QVvrkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723222143; c=relaxed/simple;
	bh=VSSmXlfe6PyWR9/LO92NlvIIJJA85IHCcU611DbrczA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CMhULgARP1ZNarmOXDvyx5/Wc2asVf3hJ6V9kD0pJFPVi2KIUw7sbnlCst5S5aD5dqZHK4GBkUerroa2XY27lZxjB4/ZCczYQbRpulRx3Dr0LdP0n6amFYu61Cqsi1joAeuWzOLn52OUhnbi6tLYFDXh7qSF6/e/cVkz7aMYLlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=Am3svQu7; arc=none smtp.client-ip=173.37.86.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="Am3svQu7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=38507; q=dns/txt;
  s=iport; t=1723222140; x=1724431740;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xkkl5We3gdy5bGPbvMRORgTzXEc4S6l5HQZkPQjCvtE=;
  b=Am3svQu7UzOBy5q2ejWCuglDhhkZUhZ5Hu8P2tqbGcV1EdPSQUuQm5cW
   PDdCLxy7gS9vFAZRXXJ9RWequxB/1ItBKSOzF7RcErqt8/DkFW3moKC0x
   ZD897mJPWB2w3OVuCbZHiWYO/QViBe2yNp3zX8AUvjkjEU7kvzkQRl+aR
   s=;
X-CSE-ConnectionGUID: KGd8xABKTICCYGkHLC7OzQ==
X-CSE-MsgGUID: kUg59P8CSVa24eE/onZ1Eg==
X-IronPort-AV: E=Sophos;i="6.09,276,1716249600"; 
   d="scan'208";a="239124437"
Received: from rcdn-core-5.cisco.com ([173.37.93.156])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 16:47:51 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by rcdn-core-5.cisco.com (8.15.2/8.15.2) with ESMTPSA id 479Ggo2d031305
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 9 Aug 2024 16:47:51 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v2 08/14] scsi: fnic: Add functionality in fnic to support FDLS
Date: Fri,  9 Aug 2024 09:42:34 -0700
Message-Id: <20240809164240.47561-9-kartilak@cisco.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240809164240.47561-1-kartilak@cisco.com>
References: <20240809164240.47561-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.193.101.253, [10.193.101.253]
X-Outbound-Node: rcdn-core-5.cisco.com

Add interfaces in fnic to use FDLS services.
Modify link up and link down functionality to use FDLS.
Replace existing interfaces to handle new functionality
provided by FDLS.
Modify data types of some data members to handle new
functionality.
Add processing of tports and handling of tports.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
Changes between v1 and v2:
    Incorporate review comments from Hannes:
	Replace fnic_del_tport_timer_sync macro calls with function
	calls.
---
 drivers/scsi/fnic/fdls_disc.c |  74 +++++
 drivers/scsi/fnic/fip.c       |  27 +-
 drivers/scsi/fnic/fnic.h      |  20 +-
 drivers/scsi/fnic/fnic_fcs.c  | 498 ++++++++++++++++++++++++----------
 drivers/scsi/fnic/fnic_main.c |  10 +-
 drivers/scsi/fnic/fnic_scsi.c | 127 +++++++--
 6 files changed, 587 insertions(+), 169 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index e841fd21b7a0..a9da58e06065 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -258,6 +258,11 @@ static void fdls_start_fabric_timer(struct fnic_iport_s *iport,
 			int timeout);
 static void fdls_tport_timer_callback(struct timer_list *t);
 
+void fdls_init_tgt_oxid_pool(struct fnic_iport_s *iport)
+{
+	memset(iport->tgt_oxid_pool, 0, FDLS_TGT_OXID_POOL_SZ);
+}
+
 static uint16_t fdls_alloc_tgt_oxid(struct fnic_iport_s *iport,
 									uint16_t base)
 {
@@ -2499,6 +2504,12 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 
 		fnic_fdls_learn_fcoe_macs(iport, rx_frame, fcid);
 
+		if (fnic_fdls_register_portid(iport, iport->fcid, rx_frame) != 0) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "0x%x: FLOGI registration failed", iport->fcid);
+			break;
+		}
+
 		memcpy(&fcmac[3], fcid, 3);
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 			 "Adding vNIC device MAC addr: %02x:%02x:%02x:%02x:%02x:%02x",
@@ -3369,6 +3380,29 @@ fdls_process_rscn(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 	fdls_send_rscn_resp(iport, fchdr);
 }
 
+void fnic_fdls_disc_start(struct fnic_iport_s *iport)
+{
+	struct fnic *fnic = iport->fnic;
+
+	if (IS_FNIC_FCP_INITIATOR(fnic)) {
+		fc_host_fabric_name(iport->fnic->lport->host) = 0;
+		fc_host_post_event(iport->fnic->lport->host, fc_get_event_number(),
+						   FCH_EVT_LIPRESET, 0);
+	}
+
+	if (!iport->usefip) {
+		if (iport->flags & FNIC_FIRST_LINK_UP) {
+			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+			fnic_scsi_fcpio_reset(iport->fnic);
+			spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+
+			iport->flags &= ~FNIC_FIRST_LINK_UP;
+		}
+		fnic_fdls_start_flogi(iport);
+	} else
+		fnic_fdls_start_plogi(iport);
+}
+
 static void
 fdls_process_adisc_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 {
@@ -3768,3 +3802,43 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 	}
 }
 
+
+void fnic_fdls_disc_init(struct fnic_iport_s *iport)
+{
+	fdls_init_tgt_oxid_pool(iport);
+	fdls_set_state((&iport->fabric), FDLS_STATE_INIT);
+}
+
+void fnic_fdls_link_down(struct fnic_iport_s *iport)
+{
+	struct fnic_tport_s *tport, *next;
+	struct fnic *fnic = iport->fnic;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "0x%x: FDLS processing link down", iport->fcid);
+
+	fdls_set_state((&iport->fabric), FDLS_STATE_LINKDOWN);
+	iport->fabric.flags = 0;
+
+	if (IS_FNIC_FCP_INITIATOR(fnic)) {
+		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+		fnic_scsi_fcpio_reset(iport->fnic);
+		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+		fdls_init_tgt_oxid_pool(iport);
+
+		list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "removing rport: 0x%x", tport->fcid);
+			fdls_delete_tport(iport, tport);
+		}
+	}
+
+	if ((fnic_fdmi_support == 1) && (iport->fabric.fdmi_pending > 0)) {
+		del_timer_sync(&iport->fabric.fdmi_timer);
+		iport->fabric.fdmi_pending = 0;
+	}
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "0x%x: FDLS finish processing link down", iport->fcid);
+}
+
diff --git a/drivers/scsi/fnic/fip.c b/drivers/scsi/fnic/fip.c
index 650761c830e5..22898b037cd6 100644
--- a/drivers/scsi/fnic/fip.c
+++ b/drivers/scsi/fnic/fip.c
@@ -426,6 +426,7 @@ void fnic_fcoe_process_flogi_resp(struct fnic *fnic,
 			iport->state = FNIC_IPORT_STATE_FABRIC_DISC;
 			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 						 "iport->state:%d\n", iport->state);
+			fnic_fdls_disc_start(iport);
 			if (!((iport->selected_fcf.ka_disabled)
 				  || (iport->selected_fcf.fka_adv_period == 0))) {
 				u64 tov;
@@ -504,6 +505,7 @@ void fnic_fcoe_process_cvl(struct fnic *fnic, struct fip_header_s *fiph)
 	struct fip_cvl_s *cvl_msg = (struct fip_cvl_s *) fiph;
 	int i;
 	int found = false;
+	int max_count = 0;
 
 	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 				 "fnic 0x%p clear virtual link handler\n", fnic);
@@ -541,6 +543,26 @@ void fnic_fcoe_process_cvl(struct fnic *fnic, struct fip_header_s *fiph)
 			return;
 		fnic_common_fip_cleanup(fnic);
 
+		while (fnic->reset_in_progress == IN_PROGRESS) {
+			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+			wait_for_completion_timeout(&fnic->reset_completion_wait,
+							msecs_to_jiffies(5000));
+			spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+			max_count++;
+			if (max_count >= FIP_FNIC_RESET_WAIT_COUNT) {
+				FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "Rthr waited too long. Skipping handle link event %p\n",
+					 fnic);
+				return;
+			}
+			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "fnic reset in progress. Link event needs to wait %p",
+				 fnic);
+		}
+		fnic->reset_in_progress = IN_PROGRESS;
+		fnic_fdls_link_down(iport);
+		fnic->reset_in_progress = NOT_IN_PROGRESS;
+		complete(&fnic->reset_completion_wait);
 		fnic_fcoe_send_vlan_req(fnic);
 	}
 }
@@ -594,8 +616,10 @@ void fnic_work_on_fip_timer(struct work_struct *work)
 					 "FCF Discovery timeout\n");
 		if (memcmp(iport->selected_fcf.fcf_mac, zmac, ETH_ALEN) != 0) {
 
-			if (iport->flags & FNIC_FIRST_LINK_UP)
+			if (iport->flags & FNIC_FIRST_LINK_UP) {
+				fnic_scsi_fcpio_reset(iport->fnic);
 				iport->flags &= ~FNIC_FIRST_LINK_UP;
+			}
 
 			fnic_fcoe_start_flogi(fnic);
 			if (!((iport->selected_fcf.ka_disabled)
@@ -794,6 +818,7 @@ void fnic_work_on_fcs_ka_timer(struct work_struct *work)
 
 	fnic_common_fip_cleanup(fnic);
 	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+	fnic_fdls_link_down(iport);
 	iport->state = FNIC_IPORT_STATE_FIP;
 	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 45bee896153e..4f38cbae1994 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -79,6 +79,7 @@
 
 #define IS_FNIC_FCP_INITIATOR(fnic) (fnic->role == FNIC_ROLE_FCP_INITIATOR)
 
+#define FNIC_FW_RESET_TIMEOUT        60000	/* mSec   */
 /* Retry supported by rport (returned by PRLI service parameters) */
 #define FNIC_FC_RP_FLAGS_RETRY            0x1
 
@@ -200,6 +201,12 @@ static inline u64 fnic_flags_and_state(struct scsi_cmnd *cmd)
 #define fnic_clear_state_flags(fnicp, st_flags)  \
 	__fnic_set_state_flags(fnicp, st_flags, 1)
 
+enum reset_states {
+	NOT_IN_PROGRESS = 0,
+	IN_PROGRESS,
+	RESET_ERROR
+};
+
 extern unsigned int fnic_fdmi_support;
 extern unsigned int fnic_log_level;
 extern unsigned int io_completions;
@@ -352,6 +359,7 @@ struct fnic {
 	unsigned int wq_count;
 	unsigned int cq_count;
 
+	struct completion reset_completion_wait;
 	struct mutex sgreset_mutex;
 	spinlock_t sgreset_lock; /* lock for sgreset */
 	struct scsi_cmnd *sgreset_sc;
@@ -369,6 +377,8 @@ struct fnic {
 
 	struct completion *remove_wait; /* device remove thread blocks */
 
+	struct completion *fw_reset_done;
+	u32 reset_in_progress;
 	atomic_t in_flight;		/* io counter */
 	bool internal_reset_inprogress;
 	u32 _reserved;			/* fill hole */
@@ -382,6 +392,7 @@ struct fnic {
 	u64 fcp_input_bytes;		/* internal statistic */
 	u64 fcp_output_bytes;		/* internal statistic */
 	u32 link_down_cnt;
+	u32 soft_reset_count;
 	int link_status;
 
 	struct list_head list;
@@ -404,7 +415,7 @@ struct fnic {
 	struct work_struct link_work;
 	struct work_struct frame_work;
 	struct work_struct flush_work;
-	struct sk_buff_head frame_queue;
+	struct list_head frame_queue;
 	struct list_head tx_queue;
 	struct work_struct tport_work;
 	struct list_head tport_event_list;
@@ -464,6 +475,7 @@ int fnic_request_intr(struct fnic *fnic);
 int fnic_send(struct fc_lport *, struct fc_frame *);
 void fnic_free_wq_buf(struct vnic_wq *wq, struct vnic_wq_buf *buf);
 void fnic_handle_frame(struct work_struct *work);
+void fnic_tport_event_handler(struct work_struct *work);
 void fnic_handle_link(struct work_struct *work);
 void fnic_handle_event(struct work_struct *work);
 int fnic_rq_cmpl_handler(struct fnic *fnic, int);
@@ -475,7 +487,8 @@ void fnic_update_mac_locked(struct fnic *, u8 *new);
 int fnic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int fnic_abort_cmd(struct scsi_cmnd *);
 int fnic_device_reset(struct scsi_cmnd *);
-int fnic_host_reset(struct scsi_cmnd *);
+int fnic_eh_host_reset_handler(struct scsi_cmnd *sc);
+int fnic_host_reset(struct Scsi_Host *shost);
 int fnic_reset(struct Scsi_Host *);
 void fnic_scsi_cleanup(struct fc_lport *);
 void fnic_scsi_abort_io(struct fc_lport *);
@@ -510,5 +523,8 @@ void fnic_dump_fchost_stats(struct Scsi_Host *, struct fc_host_statistics *);
 void fnic_free_txq(struct list_head *head);
 int fnic_get_desc_by_devid(struct pci_dev *pdev, char **desc,
 						   char **subsys_desc);
+void fnic_fdls_link_status_change(struct fnic *fnic, int linkup);
+void fnic_delete_fcp_tports(struct fnic *fnic);
+void fnic_flush_tport_event_list(struct fnic *fnic);
 
 #endif /* _FNIC_H_ */
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index af63a43e1c51..0bc2099d0113 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -25,6 +25,8 @@
 #include "cq_enet_desc.h"
 #include "cq_exch_desc.h"
 
+#define MAX_RESET_WAIT_COUNT    64
+
 extern struct workqueue_struct *fnic_fip_queue;
 struct workqueue_struct *fnic_event_queue;
 
@@ -78,6 +80,39 @@ static inline  void fnic_fdls_set_fcoe_dstmac(struct fnic *fnic,
 	memcpy(fnic->iport.fcfmac, dst_mac, 6);
 }
 
+void fnic_fdls_link_status_change(struct fnic *fnic, int linkup)
+{
+	struct fnic_iport_s *iport = &fnic->iport;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "link up: %d, usefip: %d", linkup, iport->usefip);
+
+	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+
+	if (linkup) {
+		if (iport->usefip) {
+			iport->state = FNIC_IPORT_STATE_FIP;
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "link up: %d, usefip: %d", linkup, iport->usefip);
+			fnic_fcoe_send_vlan_req(fnic);
+		} else {
+			iport->state = FNIC_IPORT_STATE_FABRIC_DISC;
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "iport->state: %d", iport->state);
+			fnic_fdls_disc_start(iport);
+		}
+	} else {
+		iport->state = FNIC_IPORT_STATE_LINK_WAIT;
+		if (!is_zero_ether_addr(iport->fpma))
+			vnic_dev_del_addr(fnic->vdev, iport->fpma);
+		fnic_common_fip_cleanup(fnic);
+		fnic_fdls_link_down(iport);
+
+	}
+	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+}
+
+
 /*
  * FPMA can be either taken from ethhdr(dst_mac) or flogi resp
  * or derive from FC_MAP and FCID combination. While it should be
@@ -107,147 +142,144 @@ void fnic_fdls_learn_fcoe_macs(struct fnic_iport_s *iport, void *rx_frame,
 	fnic_fdls_set_fcoe_dstmac(fnic, ethhdr->src_mac);
 }
 
+void fnic_fdls_init(struct fnic *fnic, int usefip)
+{
+	struct fnic_iport_s *iport = &fnic->iport;
+
+	/* Initialize iPort structure */
+	iport->state = FNIC_IPORT_STATE_INIT;
+	iport->fnic = fnic;
+	iport->usefip = usefip;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "iportsrcmac: %02x:%02x:%02x:%02x:%02x:%02x",
+				 iport->hwmac[0], iport->hwmac[1], iport->hwmac[2],
+				 iport->hwmac[3], iport->hwmac[4], iport->hwmac[5]);
+
+	INIT_LIST_HEAD(&iport->tport_list);
+	INIT_LIST_HEAD(&iport->tport_list_pending_del);
+
+	fnic_fdls_disc_init(iport);
+}
+
 void fnic_handle_link(struct work_struct *work)
 {
 	struct fnic *fnic = container_of(work, struct fnic, link_work);
-	unsigned long flags;
 	int old_link_status;
 	u32 old_link_down_cnt;
-	u64 old_port_speed, new_port_speed;
+	int max_count = 0;
 
-	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	if (vnic_dev_get_intr_mode(fnic->vdev) != VNIC_DEV_INTR_MODE_MSI)
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "Interrupt mode is not MSI\n");
 
-	fnic->link_events = 1;      /* less work to just set everytime*/
+	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 
 	if (fnic->stop_rx_link_events) {
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "Stop link rx events\n");
+		return;
+	}
+
+	/* Do not process if the fnic is already in transitional state */
+	if ((fnic->state != FNIC_IN_ETH_MODE)
+		&& (fnic->state != FNIC_IN_FC_MODE)) {
+		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "fnic in transitional state: %d. link up: %d ignored",
+			 fnic->state, vnic_dev_link_status(fnic->vdev));
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Current link status: %d iport state: %d\n",
+			 fnic->link_status, fnic->iport.state);
 		return;
 	}
 
 	old_link_down_cnt = fnic->link_down_cnt;
 	old_link_status = fnic->link_status;
-	old_port_speed = atomic64_read(
-			&fnic->fnic_stats.misc_stats.current_port_speed);
-
 	fnic->link_status = vnic_dev_link_status(fnic->vdev);
 	fnic->link_down_cnt = vnic_dev_link_down_cnt(fnic->vdev);
 
-	new_port_speed = vnic_dev_port_speed(fnic->vdev);
-	atomic64_set(&fnic->fnic_stats.misc_stats.current_port_speed,
-			new_port_speed);
-	if (old_port_speed != new_port_speed)
+	while (fnic->reset_in_progress == IN_PROGRESS) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "fnic reset in progress. Link event needs to wait\n");
+
+		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
-				"Current vnic speed set to: %llu\n",
-				new_port_speed);
-
-	switch (vnic_dev_port_speed(fnic->vdev)) {
-	case DCEM_PORTSPEED_10G:
-		fc_host_speed(fnic->lport->host)   = FC_PORTSPEED_10GBIT;
-		fnic->lport->link_supported_speeds = FC_PORTSPEED_10GBIT;
-		break;
-	case DCEM_PORTSPEED_20G:
-		fc_host_speed(fnic->lport->host)   = FC_PORTSPEED_20GBIT;
-		fnic->lport->link_supported_speeds = FC_PORTSPEED_20GBIT;
-		break;
-	case DCEM_PORTSPEED_25G:
-		fc_host_speed(fnic->lport->host)   = FC_PORTSPEED_25GBIT;
-		fnic->lport->link_supported_speeds = FC_PORTSPEED_25GBIT;
-		break;
-	case DCEM_PORTSPEED_40G:
-	case DCEM_PORTSPEED_4x10G:
-		fc_host_speed(fnic->lport->host)   = FC_PORTSPEED_40GBIT;
-		fnic->lport->link_supported_speeds = FC_PORTSPEED_40GBIT;
-		break;
-	case DCEM_PORTSPEED_100G:
-		fc_host_speed(fnic->lport->host)   = FC_PORTSPEED_100GBIT;
-		fnic->lport->link_supported_speeds = FC_PORTSPEED_100GBIT;
-		break;
-	default:
-		fc_host_speed(fnic->lport->host)   = FC_PORTSPEED_UNKNOWN;
-		fnic->lport->link_supported_speeds = FC_PORTSPEED_UNKNOWN;
-		break;
+					 "waiting for reset completion\n");
+		wait_for_completion_timeout(&fnic->reset_completion_wait,
+									msecs_to_jiffies(5000));
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "woken up from reset completion wait\n");
+		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+
+		max_count++;
+		if (max_count >= MAX_RESET_WAIT_COUNT) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Rstth waited for too long. Skipping handle link event\n");
+			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+			return;
+		}
+	}
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Marking fnic reset in progress\n");
+	fnic->reset_in_progress = IN_PROGRESS;
+
+	if ((vnic_dev_get_intr_mode(fnic->vdev) != VNIC_DEV_INTR_MODE_MSI) ||
+		(fnic->link_status != old_link_status)) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "old link status: %d link status: %d\n",
+					 old_link_status, (int) fnic->link_status);
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "old down count %d down count: %d\n",
+					 old_link_down_cnt, (int) fnic->link_down_cnt);
 	}
 
 	if (old_link_status == fnic->link_status) {
 		if (!fnic->link_status) {
 			/* DOWN -> DOWN */
-			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-			fnic_fc_trace_set_data(fnic->lport->host->host_no,
-				FNIC_FC_LE, "Link Status: DOWN->DOWN",
-				strlen("Link Status: DOWN->DOWN"));
+			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
-					"down->down\n");
+						 "down->down\n");
 		} else {
 			if (old_link_down_cnt != fnic->link_down_cnt) {
 				/* UP -> DOWN -> UP */
-				fnic->lport->host_stats.link_failure_count++;
-				spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-				fnic_fc_trace_set_data(
-					fnic->lport->host->host_no,
-					FNIC_FC_LE,
-					"Link Status:UP_DOWN_UP",
-					strlen("Link_Status:UP_DOWN_UP")
-					);
-				FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
-					     "link down\n");
-				fcoe_ctlr_link_down(&fnic->ctlr);
-				if (fnic->config.flags & VFCF_FIP_CAPABLE) {
-					/* start FCoE VLAN discovery */
-					fnic_fc_trace_set_data(
-						fnic->lport->host->host_no,
-						FNIC_FC_LE,
-						"Link Status: UP_DOWN_UP_VLAN",
-						strlen(
-						"Link Status: UP_DOWN_UP_VLAN")
-						);
-					fnic_fcoe_send_vlan_req(fnic);
-					return;
-				}
+				spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+							 "up->down. Link down\n");
+				fnic_fdls_link_status_change(fnic, 0);
+
 				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
-						"up->down->up: Link up\n");
-				fcoe_ctlr_link_up(&fnic->ctlr);
+							 "down->up. Link up\n");
+				fnic_fdls_link_status_change(fnic, 1);
 			} else {
 				/* UP -> UP */
-				spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-				fnic_fc_trace_set_data(
-					fnic->lport->host->host_no, FNIC_FC_LE,
-					"Link Status: UP_UP",
-					strlen("Link Status: UP_UP"));
+				spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
-						"up->up\n");
+							 "up->up\n");
 			}
 		}
 	} else if (fnic->link_status) {
 		/* DOWN -> UP */
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		if (fnic->config.flags & VFCF_FIP_CAPABLE) {
-			/* start FCoE VLAN discovery */
-			fnic_fc_trace_set_data(fnic->lport->host->host_no,
-					       FNIC_FC_LE, "Link Status: DOWN_UP_VLAN",
-					       strlen("Link Status: DOWN_UP_VLAN"));
-			fnic_fcoe_send_vlan_req(fnic);
-
-			return;
-		}
-
+		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
-				"down->up: Link up\n");
-		fnic_fc_trace_set_data(fnic->lport->host->host_no, FNIC_FC_LE,
-				       "Link Status: DOWN_UP", strlen("Link Status: DOWN_UP"));
-		fcoe_ctlr_link_up(&fnic->ctlr);
+					 "down->up. Link up\n");
+		fnic_fdls_link_status_change(fnic, 1);
 	} else {
 		/* UP -> DOWN */
-		fnic->lport->host_stats.link_failure_count++;
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
-				"up->down: Link down\n");
-		fnic_fc_trace_set_data(
-			fnic->lport->host->host_no, FNIC_FC_LE,
-			"Link Status: UP_DOWN",
-			strlen("Link Status: UP_DOWN"));
-		fcoe_ctlr_link_down(&fnic->ctlr);
+					 "up->down. Link down\n");
+		fnic_fdls_link_status_change(fnic, 0);
 	}
 
+	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+	fnic->reset_in_progress = NOT_IN_PROGRESS;
+	complete(&fnic->reset_completion_wait);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Marking fnic reset completion\n");
+	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 }
 
 /*
@@ -256,35 +288,47 @@ void fnic_handle_link(struct work_struct *work)
 void fnic_handle_frame(struct work_struct *work)
 {
 	struct fnic *fnic = container_of(work, struct fnic, frame_work);
-	struct fc_lport *lp = fnic->lport;
-	unsigned long flags;
-	struct sk_buff *skb;
-	struct fc_frame *fp;
-
-	while ((skb = skb_dequeue(&fnic->frame_queue))) {
+	struct fnic_frame_list *cur_frame, *next;
+	int fchdr_offset = 0;
+	struct fc_hdr_s *fchdr;
 
-		spin_lock_irqsave(&fnic->fnic_lock, flags);
+	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+	list_for_each_entry_safe(cur_frame, next, &fnic->frame_queue, links) {
 		if (fnic->stop_rx_link_events) {
-			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-			dev_kfree_skb(skb);
+			list_del(&cur_frame->links);
+			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+			kfree(cur_frame->fp);
+			kfree(cur_frame);
 			return;
 		}
-		fp = (struct fc_frame *)skb;
 
 		/*
 		 * If we're in a transitional state, just re-queue and return.
 		 * The queue will be serviced when we get to a stable state.
 		 */
 		if (fnic->state != FNIC_IN_FC_MODE &&
-		    fnic->state != FNIC_IN_ETH_MODE) {
-			skb_queue_head(&fnic->frame_queue, skb);
-			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+			fnic->state != FNIC_IN_ETH_MODE) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Cannot process frame in transitional state\n");
+			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 			return;
 		}
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
-		fc_exch_recv(lp, fp);
+		list_del(&cur_frame->links);
+
+		/* Frames from FCP_RQ will have ethhdrs stripped off */
+		fchdr_offset = (cur_frame->rx_ethhdr_stripped) ?
+			0 : FNIC_FCOE_FCHDR_OFFSET;
+		fchdr =
+			(struct fc_hdr_s *) ((uint8_t *) cur_frame->fp + fchdr_offset);
+
+		fnic_fdls_recv_frame(&fnic->iport, cur_frame->fp,
+							 cur_frame->frame_len, fchdr_offset);
+
+		kfree(cur_frame->fp);
+		kfree(cur_frame);
 	}
+	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 }
 
 void fnic_handle_fip_frame(struct work_struct *work)
@@ -498,6 +542,10 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 	frame_elem->rx_ethhdr_stripped = ethhdr_stripped;
 	frame_elem->frame_len = bytes_written;
 
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	list_add_tail(&frame_elem->links, &fnic->frame_queue);
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+
 	queue_work(fnic_event_queue, &fnic->frame_work);
 	return;
 
@@ -528,7 +576,7 @@ int fnic_rq_cmpl_handler(struct fnic *fnic, int rq_work_to_do)
 		cur_work_done = vnic_cq_service(&fnic->cq[i], rq_work_to_do,
 						fnic_rq_cmpl_handler_cont,
 						NULL);
-		if (cur_work_done) {
+		if (cur_work_done && fnic->stop_rx_link_events != 1) {
 			err = vnic_rq_fill(&fnic->rq[i], fnic_alloc_rq_frame);
 			if (err)
 				shost_printk(KERN_ERR, fnic->lport->host,
@@ -549,46 +597,43 @@ int fnic_rq_cmpl_handler(struct fnic *fnic, int rq_work_to_do)
 int fnic_alloc_rq_frame(struct vnic_rq *rq)
 {
 	struct fnic *fnic = vnic_dev_priv(rq->vdev);
-	struct sk_buff *skb;
+	void *buf;
 	u16 len;
 	dma_addr_t pa;
-	int r;
+	int ret;
 
-	len = FC_FRAME_HEADROOM + FC_MAX_FRAME + FC_FRAME_TAILROOM;
-	skb = dev_alloc_skb(len);
-	if (!skb) {
-		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
-			     "Unable to allocate RQ sk_buff\n");
+	len = FNIC_FRAME_HT_ROOM;
+	buf = kmalloc(len, GFP_ATOMIC);
+	if (!buf) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "Unable to allocate RQ buffer of size: %d\n", len);
 		return -ENOMEM;
 	}
-	skb_reset_mac_header(skb);
-	skb_reset_transport_header(skb);
-	skb_reset_network_header(skb);
-	skb_put(skb, len);
-	pa = dma_map_single(&fnic->pdev->dev, skb->data, len, DMA_FROM_DEVICE);
+
+	pa = dma_map_single(&fnic->pdev->dev, buf, len, DMA_FROM_DEVICE);
 	if (dma_mapping_error(&fnic->pdev->dev, pa)) {
-		r = -ENOMEM;
-		printk(KERN_ERR "PCI mapping failed with error %d\n", r);
-		goto free_skb;
+		ret = -ENOMEM;
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "PCI mapping failed with error %d\n", ret);
+		goto free_buf;
 	}
 
-	fnic_queue_rq_desc(rq, skb, pa, len);
+	fnic_queue_rq_desc(rq, buf, pa, len);
 	return 0;
-
-free_skb:
-	kfree_skb(skb);
-	return r;
+free_buf:
+	kfree(buf);
+	return ret;
 }
 
 void fnic_free_rq_buf(struct vnic_rq *rq, struct vnic_rq_buf *buf)
 {
-	struct fc_frame *fp = buf->os_buf;
+	void *rq_buf = buf->os_buf;
 	struct fnic *fnic = vnic_dev_priv(rq->vdev);
 
 	dma_unmap_single(&fnic->pdev->dev, buf->dma_addr, buf->len,
 			 DMA_FROM_DEVICE);
 
-	dev_kfree_skb(fp_skb(fp));
+	kfree(rq_buf);
 	buf->os_buf = NULL;
 }
 
@@ -829,13 +874,11 @@ static void fnic_wq_complete_frame_send(struct vnic_wq *wq,
 					struct cq_desc *cq_desc,
 					struct vnic_wq_buf *buf, void *opaque)
 {
-	struct sk_buff *skb = buf->os_buf;
-	struct fc_frame *fp = (struct fc_frame *)skb;
 	struct fnic *fnic = vnic_dev_priv(wq->vdev);
 
 	dma_unmap_single(&fnic->pdev->dev, buf->dma_addr, buf->len,
 			 DMA_TO_DEVICE);
-	dev_kfree_skb_irq(fp_skb(fp));
+	kfree(buf->os_buf);
 	buf->os_buf = NULL;
 }
 
@@ -873,13 +916,182 @@ int fnic_wq_cmpl_handler(struct fnic *fnic, int work_to_do)
 
 void fnic_free_wq_buf(struct vnic_wq *wq, struct vnic_wq_buf *buf)
 {
-	struct fc_frame *fp = buf->os_buf;
 	struct fnic *fnic = vnic_dev_priv(wq->vdev);
 
 	dma_unmap_single(&fnic->pdev->dev, buf->dma_addr, buf->len,
 			 DMA_TO_DEVICE);
 
-	dev_kfree_skb(fp_skb(fp));
+	kfree(buf->os_buf);
 	buf->os_buf = NULL;
 }
 
+void
+fnic_fdls_add_tport(struct fnic_iport_s *iport, struct fnic_tport_s *tport,
+					unsigned long flags)
+{
+	struct fnic *fnic = iport->fnic;
+	struct fc_rport *rport;
+	struct fc_rport_identifiers ids;
+	struct rport_dd_data_s *rdd_data;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Adding rport fcid: 0x%x", tport->fcid);
+
+	ids.node_name = tport->wwnn;
+	ids.port_name = tport->wwpn;
+	ids.port_id = tport->fcid;
+	ids.roles = FC_RPORT_ROLE_FCP_TARGET;
+
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+	rport = fc_remote_port_add(fnic->lport->host, 0, &ids);
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	if (!rport) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "Failed to add rport for tport: 0x%x", tport->fcid);
+		return;
+	}
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Added rport fcid: 0x%x", tport->fcid);
+
+	/* Mimic these assignments in queuecommand to avoid timing issues */
+	rport->maxframe_size = FNIC_FC_MAX_PAYLOAD_LEN;
+	rport->supported_classes = FC_COS_CLASS3 | FC_RPORT_ROLE_FCP_TARGET;
+	rdd_data = rport->dd_data;
+	rdd_data->tport = tport;
+	rdd_data->iport = iport;
+	tport->rport = rport;
+	tport->flags |= FNIC_FDLS_SCSI_REGISTERED;
+}
+
+void
+fnic_fdls_remove_tport(struct fnic_iport_s *iport,
+					   struct fnic_tport_s *tport, unsigned long flags)
+{
+	struct fnic *fnic = iport->fnic;
+	struct rport_dd_data_s *rdd_data;
+
+	struct fc_rport *rport;
+
+	if (!tport)
+		return;
+
+	fdls_set_tport_state(tport, FDLS_TGT_STATE_OFFLINE);
+	rport = tport->rport;
+
+	if (rport) {
+		/* tport resource release will be done
+		 * after fnic_terminate_rport_io()
+		 */
+		tport->flags |= FNIC_FDLS_TPORT_DELETED;
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+
+		/* Interface to scsi_fc_transport  */
+		fc_remote_port_delete(rport);
+
+		spin_lock_irqsave(&fnic->fnic_lock, flags);
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		 "Deregistered and freed tport fcid: 0x%x from scsi transport fc",
+		 tport->fcid);
+
+		/*
+		 * the dd_data is allocated by fc transport
+		 * of size dd_fcrport_size
+		 */
+		rdd_data = rport->dd_data;
+		rdd_data->tport = NULL;
+		rdd_data->iport = NULL;
+		list_del(&tport->links);
+		kfree(tport);
+	} else {
+		fnic_del_tport_timer_sync(fnic, tport);
+		list_del(&tport->links);
+		kfree(tport);
+	}
+}
+
+void fnic_delete_fcp_tports(struct fnic *fnic)
+{
+	struct fnic_tport_s *tport, *next;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	list_for_each_entry_safe(tport, next, &fnic->iport.tport_list, links) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "removing fcp rport fcid: 0x%x", tport->fcid);
+		fdls_set_tport_state(tport, FDLS_TGT_STATE_OFFLINING);
+		fnic_fdls_remove_tport(&fnic->iport, tport, flags);
+		fnic_del_tport_timer_sync(fnic, tport);
+	}
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+}
+
+/**
+ * fnic_tport_work() - Handler for remote port events in the tport_event_queue
+ * @work: Handle to the remote port being dequeued
+ */
+void fnic_tport_event_handler(struct work_struct *work)
+{
+	struct fnic *fnic = container_of(work, struct fnic, tport_work);
+	struct fnic_tport_event_s *cur_evt, *next;
+	unsigned long flags;
+	struct fnic_tport_s *tport;
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	list_for_each_entry_safe(cur_evt, next, &fnic->tport_event_list, links) {
+		tport = cur_evt->arg1;
+		switch (cur_evt->event) {
+		case TGT_EV_RPORT_ADD:
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "Add rport event");
+			if (tport->state == FDLS_TGT_STATE_READY) {
+				fnic_fdls_add_tport(&fnic->iport,
+					(struct fnic_tport_s *) cur_evt->arg1, flags);
+			} else {
+				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "Target not ready. Add rport event dropped: 0x%x",
+					 tport->fcid);
+			}
+			break;
+		case TGT_EV_RPORT_DEL:
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "Remove rport event");
+			if (tport->state == FDLS_TGT_STATE_OFFLINING) {
+				fnic_fdls_remove_tport(&fnic->iport,
+					   (struct fnic_tport_s *) cur_evt->arg1, flags);
+			} else {
+				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+							 "remove rport event dropped tport fcid: 0x%x",
+							 tport->fcid);
+			}
+			break;
+		case TGT_EV_TPORT_DELETE:
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "Delete tport event");
+			fdls_delete_tport(tport->iport, tport);
+			break;
+		default:
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "Unknown tport event");
+			break;
+		}
+		list_del(&cur_evt->links);
+		kfree(cur_evt);
+	}
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+}
+
+void fnic_flush_tport_event_list(struct fnic *fnic)
+{
+	struct fnic_tport_event_s *cur_evt, *next;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	list_for_each_entry_safe(cur_evt, next, &fnic->tport_event_list, links) {
+		list_del(&cur_evt->links);
+		kfree(cur_evt);
+	}
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+}
+
+
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 1e3cdc2758fd..24772d6a1cd0 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -110,7 +110,7 @@ static const struct scsi_host_template fnic_host_template = {
 	.eh_timed_out = fc_eh_timed_out,
 	.eh_abort_handler = fnic_abort_cmd,
 	.eh_device_reset_handler = fnic_device_reset,
-	.eh_host_reset_handler = fnic_host_reset,
+	.eh_host_reset_handler = fnic_eh_host_reset_handler,
 	.slave_alloc = fnic_slave_alloc,
 	.change_queue_depth = scsi_change_queue_depth,
 	.this_id = -1,
@@ -923,8 +923,10 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	INIT_WORK(&fnic->link_work, fnic_handle_link);
 	INIT_WORK(&fnic->frame_work, fnic_handle_frame);
-	skb_queue_head_init(&fnic->frame_queue);
+	INIT_WORK(&fnic->tport_work, fnic_tport_event_handler);
+	INIT_LIST_HEAD(&fnic->frame_queue);
 	INIT_LIST_HEAD(&fnic->tx_queue);
+	INIT_LIST_HEAD(&fnic->tport_event_list);
 
 	fc_fabric_login(lp);
 
@@ -1006,7 +1008,7 @@ static void fnic_remove(struct pci_dev *pdev)
 	 * be no event queued for this fnic device in the workqueue
 	 */
 	flush_workqueue(fnic_event_queue);
-	skb_queue_purge(&fnic->frame_queue);
+	fnic_free_txq(&fnic->frame_queue);
 	fnic_free_txq(&fnic->tx_queue);
 
 	if (fnic->config.flags & VFCF_FIP_CAPABLE) {
@@ -1044,8 +1046,6 @@ static void fnic_remove(struct pci_dev *pdev)
 	 */
 	fnic_cleanup(fnic);
 
-	BUG_ON(!skb_queue_empty(&fnic->frame_queue));
-
 	spin_lock_irqsave(&fnic_list_lock, flags);
 	list_del(&fnic->list);
 	spin_unlock_irqrestore(&fnic_list_lock, flags);
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 295dcda4ec16..5d5d1205e984 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -183,7 +183,7 @@ int fnic_fw_reset_handler(struct fnic *fnic)
 	/* indicate fwreset to io path */
 	fnic_set_state_flags(fnic, FNIC_FLAGS_FWRESET);
 
-	skb_queue_purge(&fnic->frame_queue);
+	fnic_free_txq(&fnic->frame_queue);
 	fnic_free_txq(&fnic->tx_queue);
 
 	/* wait for io cmpl */
@@ -2575,23 +2575,30 @@ int fnic_reset(struct Scsi_Host *shost)
  * host is offlined by SCSI.
  *
  */
-int fnic_host_reset(struct scsi_cmnd *sc)
+int fnic_host_reset(struct Scsi_Host *shost)
 {
 	int ret;
 	unsigned long wait_host_tmo;
-	struct Scsi_Host *shost = sc->device->host;
-	struct fc_lport *lp = shost_priv(shost);
-	struct fnic *fnic = lport_priv(lp);
+	struct fnic *fnic = *((struct fnic **) shost_priv(shost));
 	unsigned long flags;
+	struct fnic_iport_s *iport = &fnic->iport;
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
-	if (!fnic->internal_reset_inprogress) {
-		fnic->internal_reset_inprogress = true;
+	if (fnic->reset_in_progress == NOT_IN_PROGRESS) {
+		fnic->reset_in_progress = IN_PROGRESS;
 	} else {
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
-			"host reset in progress skipping another host reset\n");
-		return SUCCESS;
+		wait_for_completion_timeout(&fnic->reset_completion_wait,
+									msecs_to_jiffies(10000));
+
+		spin_lock_irqsave(&fnic->fnic_lock, flags);
+		if (fnic->reset_in_progress == IN_PROGRESS) {
+			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+			FNIC_SCSI_DBG(KERN_WARNING, fnic->lport->host, fnic->fnic_num,
+			  "Firmware reset in progress. Skipping another host reset\n");
+			return SUCCESS;
+		}
+		fnic->reset_in_progress = IN_PROGRESS;
 	}
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
@@ -2600,23 +2607,33 @@ int fnic_host_reset(struct scsi_cmnd *sc)
 	 * scsi-ml tries to send a TUR to every device if host reset is
 	 * successful, so before returning to scsi, fabric should be up
 	 */
-	ret = (fnic_reset(shost) == 0) ? SUCCESS : FAILED;
-	if (ret == SUCCESS) {
+	fnic_reset(shost);
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	fnic->reset_in_progress = NOT_IN_PROGRESS;
+	complete(&fnic->reset_completion_wait);
+	fnic->soft_reset_count++;
+
+	/* wait till the link is up */
+	if (fnic->link_status) {
 		wait_host_tmo = jiffies + FNIC_HOST_RESET_SETTLE_TIME * HZ;
 		ret = FAILED;
 		while (time_before(jiffies, wait_host_tmo)) {
-			if ((lp->state == LPORT_ST_READY) &&
-			    (lp->link_up)) {
+			if (iport->state != FNIC_IPORT_STATE_READY
+				&& fnic->link_status) {
+				spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+				ssleep(1);
+				spin_lock_irqsave(&fnic->fnic_lock, flags);
+			} else {
 				ret = SUCCESS;
 				break;
 			}
-			ssleep(1);
 		}
 	}
-
-	spin_lock_irqsave(&fnic->fnic_lock, flags);
-	fnic->internal_reset_inprogress = false;
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+
+	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				  "host reset return status: %d\n", ret);
 	return ret;
 }
 
@@ -2809,3 +2826,77 @@ int fnic_is_abts_pending(struct fnic *fnic, struct scsi_cmnd *lr_sc)
 
 	return iter_data.ret;
 }
+
+/*
+ * SCSI Error handling calls driver's eh_host_reset if all prior
+ * error handling levels return FAILED. If host reset completes
+ * successfully, and if link is up, then Fabric login begins.
+ *
+ * Host Reset is the highest level of error recovery. If this fails, then
+ * host is offlined by SCSI.
+ *
+ */
+int fnic_eh_host_reset_handler(struct scsi_cmnd *sc)
+{
+	int ret = 0;
+	struct Scsi_Host *shost = sc->device->host;
+	struct fnic *fnic = *((struct fnic **) shost_priv(shost));
+
+	FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+				  "SCSI error handling: fnic host reset");
+
+	ret = fnic_host_reset(shost);
+	return ret;
+}
+
+
+void fnic_scsi_fcpio_reset(struct fnic *fnic)
+{
+	unsigned long flags;
+	enum fnic_state old_state;
+	struct fnic_iport_s *iport = &fnic->iport;
+	DECLARE_COMPLETION_ONSTACK(fw_reset_done);
+	int time_remain;
+
+	/* issue fw reset */
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	if (unlikely(fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)) {
+		/* fw reset is in progress, poll for its completion */
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			  "fnic is in unexpected state: %d for fw_reset\n",
+			  fnic->state);
+		return;
+	}
+
+	old_state = fnic->state;
+	fnic->state = FNIC_IN_FC_TRANS_ETH_MODE;
+
+	fnic_update_mac_locked(fnic, iport->hwmac);
+	fnic->fw_reset_done = &fw_reset_done;
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+
+	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				  "Issuing fw reset\n");
+	if (fnic_fw_reset_handler(fnic)) {
+		spin_lock_irqsave(&fnic->fnic_lock, flags);
+		if (fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)
+			fnic->state = old_state;
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+	} else {
+		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					  "Waiting for fw completion\n");
+		time_remain = wait_for_completion_timeout(&fw_reset_done,
+						  msecs_to_jiffies(FNIC_FW_RESET_TIMEOUT));
+		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					  "Woken up after fw completion timeout\n");
+		if (time_remain == 0) {
+			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				  "FW reset completion timed out after %d ms)\n",
+				  FNIC_FW_RESET_TIMEOUT);
+		}
+	}
+	fnic->fw_reset_done = NULL;
+}
+
+
-- 
2.31.1

