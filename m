Received: from rcdn-iport-6.cisco.com (rcdn-iport-6.cisco.com [173.37.86.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55632136E28;
	Fri, 27 Sep 2024 18:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727463134; cv=none; b=LaC0NRrsNJdk0OZ4dZfGZ3UudIsiJpS3bTPyDPBvlme696z1blMOxP/Bzhgd+eoQgC5/JCfTdi65mEvdorqVszpjeU3mtUXHOJNvl4SId0DA/u36PjWI0Ly7Q7VhJQGDIB34f5d/jjaOrdFtS0lvPZ2UB17Z0JkhkHP+Vb/ICcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727463134; c=relaxed/simple;
	bh=US4dD1Dh8L8/ImwjifP1Xq95qFtG4pgc5FXNGIlSq8E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ef/zENat6p/jNvEOIb9br4DIVyMgJt2rxngATo324JA0QMGMovpQEDFBx09PMx4/m9JmNGpNWnGKI4sK/WOHHFAkaIEPb32ocmgjwSCLoSNK3hezJuBWluzhm2Tmurb5yY6SVkd5NcqBgz8W3TTST8OK1vXpjOkzgFxSssgXUpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=KlIZU0Wi; arc=none smtp.client-ip=173.37.86.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="KlIZU0Wi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=51190; q=dns/txt;
  s=iport; t=1727463131; x=1728672731;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f/RaCdZhD7VYhyPpRPwG3ScR2VKipIVWAdA06NG6uvw=;
  b=KlIZU0WiZz12s9V9l6uAb288W80Ofz5nhBoeqN54MA5iKVRwsiB2K3Wl
   h+MzNrY4scLR/jOOzFtUW7JPrzyOQoAwBvZDUe27fNz/iJejt2NvsD/iY
   lgSx07zP1esZQ0/N5ANWS4kWJTlgxeE5W+PlpRWPy9fXtbxo/8pBVSb9B
   U=;
X-CSE-ConnectionGUID: Bgn3EJvnQX+sLkVbIALguQ==
X-CSE-MsgGUID: P52/WUN/TAuxMO0gnPj+5Q==
X-IronPort-AV: E=Sophos;i="6.11,159,1725321600"; 
   d="scan'208";a="267255980"
Received: from rcdn-core-5.cisco.com ([173.37.93.156])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2024 18:52:10 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by rcdn-core-5.cisco.com (8.15.2/8.15.2) with ESMTPSA id 48RIkQaq022754
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 27 Sep 2024 18:52:09 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v3 09/14] scsi: fnic: Modify IO path to use FDLS
Date: Fri, 27 Sep 2024 11:46:08 -0700
Message-Id: <20240927184613.52172-10-kartilak@cisco.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240927184613.52172-1-kartilak@cisco.com>
References: <20240927184613.52172-1-kartilak@cisco.com>
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

Modify IO path to use FDLS.
Add helper functions to process IOs.
Remove unused template functions.
Cleanup obsolete code.
Refactor old function definitions.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
Changes between v2 and v3:
    Replace fnic->host with fnic->lport->host to prevent compilation
    errors.

Changes between v1 and v2:
    Replace pr_err with printk.
    Incorporate review comments by Hannes:
	Restore usage of tagset iterators.
---
 drivers/scsi/fnic/fnic.h       |  20 +-
 drivers/scsi/fnic/fnic_io.h    |   3 +
 drivers/scsi/fnic/fnic_main.c  |   5 +-
 drivers/scsi/fnic/fnic_scsi.c  | 846 +++++++++++++++++++--------------
 drivers/scsi/fnic/fnic_stats.h |   2 -
 5 files changed, 513 insertions(+), 363 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 4f38cbae1994..c6fe9eec9a0c 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -40,6 +40,7 @@
 #define FNIC_DFLT_IO_REQ        256 /* Default scsi_cmnd tag map entries */
 #define FNIC_DFLT_QUEUE_DEPTH	256
 #define	FNIC_STATS_RATE_LIMIT	4 /* limit rate at which stats are pulled up */
+#define LUN0_DELAY_TIME			9
 
 /*
  * Tag bits used for special requests.
@@ -472,7 +473,6 @@ int fnic_set_intr_mode_msix(struct fnic *fnic);
 void fnic_free_intr(struct fnic *fnic);
 int fnic_request_intr(struct fnic *fnic);
 
-int fnic_send(struct fc_lport *, struct fc_frame *);
 void fnic_free_wq_buf(struct vnic_wq *wq, struct vnic_wq_buf *buf);
 void fnic_handle_frame(struct work_struct *work);
 void fnic_tport_event_handler(struct work_struct *work);
@@ -489,11 +489,9 @@ int fnic_abort_cmd(struct scsi_cmnd *);
 int fnic_device_reset(struct scsi_cmnd *);
 int fnic_eh_host_reset_handler(struct scsi_cmnd *sc);
 int fnic_host_reset(struct Scsi_Host *shost);
-int fnic_reset(struct Scsi_Host *);
-void fnic_scsi_cleanup(struct fc_lport *);
-void fnic_scsi_abort_io(struct fc_lport *);
-void fnic_empty_scsi_cleanup(struct fc_lport *);
-void fnic_exch_mgr_reset(struct fc_lport *, u32, u32);
+void fnic_reset(struct Scsi_Host *shost);
+int fnic_issue_fc_host_lip(struct Scsi_Host *shost);
+void fnic_scsi_fcpio_reset(struct fnic *fnic);
 int fnic_wq_copy_cmpl_handler(struct fnic *fnic, int copy_work_to_do, unsigned int cq_index);
 int fnic_wq_cmpl_handler(struct fnic *fnic, int);
 int fnic_flogi_reg_handler(struct fnic *fnic, u32);
@@ -505,7 +503,8 @@ const char *fnic_state_to_str(unsigned int state);
 void fnic_mq_map_queues_cpus(struct Scsi_Host *host);
 void fnic_log_q_error(struct fnic *fnic);
 void fnic_handle_link_event(struct fnic *fnic);
-
+void fnic_stats_debugfs_init(struct fnic *fnic);
+void fnic_stats_debugfs_remove(struct fnic *fnic);
 int fnic_is_abts_pending(struct fnic *, struct scsi_cmnd *);
 
 void fnic_handle_fip_frame(struct work_struct *work);
@@ -526,5 +525,12 @@ int fnic_get_desc_by_devid(struct pci_dev *pdev, char **desc,
 void fnic_fdls_link_status_change(struct fnic *fnic, int linkup);
 void fnic_delete_fcp_tports(struct fnic *fnic);
 void fnic_flush_tport_event_list(struct fnic *fnic);
+int fnic_count_ioreqs_wq(struct fnic *fnic, u32 hwq, u32 portid);
+unsigned int fnic_count_ioreqs(struct fnic *fnic, u32 portid);
+unsigned int fnic_count_all_ioreqs(struct fnic *fnic);
+unsigned int fnic_count_lun_ioreqs_wq(struct fnic *fnic, u32 hwq,
+						  struct scsi_device *device);
+unsigned int fnic_count_lun_ioreqs(struct fnic *fnic,
+					   struct scsi_device *device);
 
 #endif /* _FNIC_H_ */
diff --git a/drivers/scsi/fnic/fnic_io.h b/drivers/scsi/fnic/fnic_io.h
index 6fe642cb387b..0d974e040ab7 100644
--- a/drivers/scsi/fnic/fnic_io.h
+++ b/drivers/scsi/fnic/fnic_io.h
@@ -7,6 +7,7 @@
 #define _FNIC_IO_H_
 
 #include <scsi/fc/fc_fcp.h>
+#include "fnic_fdls.h"
 
 #define FNIC_DFLT_SG_DESC_CNT  32
 #define FNIC_MAX_SG_DESC_CNT        256     /* Maximum descriptors per sgl */
@@ -41,6 +42,8 @@ enum fnic_ioreq_state {
 };
 
 struct fnic_io_req {
+	struct fnic_iport_s *iport;
+	struct fnic_tport_s *tport;
 	struct host_sg_desc *sgl_list; /* sgl list */
 	void *sgl_list_alloc; /* sgl list address used for free */
 	dma_addr_t sense_buf_pa; /* dma address for sense buffer*/
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 24772d6a1cd0..4729edbba18c 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -85,9 +85,6 @@ module_param(fnic_max_qdepth, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(fnic_max_qdepth, "Queue depth to report for each LUN");
 
 static struct libfc_function_template fnic_transport_template = {
-	.fcp_abort_io = fnic_empty_scsi_cleanup,
-	.fcp_cleanup = fnic_empty_scsi_cleanup,
-	.exch_mgr_reset = fnic_exch_mgr_reset
 };
 
 struct workqueue_struct *fnic_fip_queue;
@@ -162,7 +159,7 @@ static struct fc_function_template fnic_fc_functions = {
 	.show_starget_port_id = 1,
 	.show_rport_dev_loss_tmo = 1,
 	.set_rport_dev_loss_tmo = fnic_set_rport_dev_loss_tmo,
-	.issue_fc_host_lip = fnic_reset,
+	.issue_fc_host_lip = fnic_issue_fc_host_lip,
 	.get_fc_host_stats = fnic_get_stats,
 	.reset_fc_host_stats = fnic_reset_host_stats,
 	.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 5d5d1205e984..97b2535cc100 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -25,9 +25,12 @@
 #include <scsi/fc/fc_fcoe.h>
 #include <scsi/libfc.h>
 #include <scsi/fc_frame.h>
+#include <scsi/scsi_transport_fc.h>
 #include "fnic_io.h"
 #include "fnic.h"
 
+static void fnic_cleanup_io(struct fnic *fnic, int exclude_id);
+
 const char *fnic_state_str[] = {
 	[FNIC_IN_FC_MODE] =           "FNIC_IN_FC_MODE",
 	[FNIC_IN_FC_TRANS_ETH_MODE] = "FNIC_IN_FC_TRANS_ETH_MODE",
@@ -65,6 +68,18 @@ static const char *fcpio_status_str[] =  {
 	[FCPIO_LUNMAP_CHNG_PEND] = "FCPIO_LUNHMAP_CHNG_PEND",
 };
 
+enum terminate_io_return {
+	TERM_SUCCESS = 0,
+	TERM_NO_SC = 1,
+	TERM_IO_REQ_NOT_FOUND,
+	TERM_ANOTHER_PORT,
+	TERM_GSTATE,
+	TERM_IO_BLOCKED,
+	TERM_OUT_OF_WQ_DESC,
+	TERM_TIMED_OUT,
+	TERM_MISC,
+};
+
 const char *fnic_state_to_str(unsigned int state)
 {
 	if (state >= ARRAY_SIZE(fnic_state_str) || !fnic_state_str[state])
@@ -90,8 +105,6 @@ static const char *fnic_fcpio_status_to_str(unsigned int status)
 	return fcpio_status_str[status];
 }
 
-static void fnic_cleanup_io(struct fnic *fnic);
-
 /*
  * Unmap the data buffer and sense buffer for an io_req,
  * also unmap and free the device-private scatter/gather list.
@@ -114,6 +127,80 @@ static void fnic_release_ioreq_buf(struct fnic *fnic,
 				 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 }
 
+int fnic_count_ioreqs_wq(struct fnic *fnic, u32 hwq, u32 portid)
+{
+	unsigned long flags = 0;
+	int i = 0, count = 0;
+
+	spin_lock_irqsave(&fnic->wq_copy_lock[hwq], flags);
+	for (i = 0; i != fnic->sw_copy_wq[hwq].ioreq_table_size; ++i) {
+		if (fnic->sw_copy_wq[hwq].io_req_table[i] != NULL &&
+			(!portid
+			 || fnic->sw_copy_wq[hwq].io_req_table[i]->port_id == portid))
+			count++;
+	}
+	spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
+
+	return count;
+}
+
+unsigned int fnic_count_ioreqs(struct fnic *fnic, u32 portid)
+{
+	int i;
+	unsigned int count = 0;
+
+	for (i = 0; i < fnic->wq_copy_count; i++)
+		count += fnic_count_ioreqs_wq(fnic, i, portid);
+
+	return count;
+}
+
+unsigned int fnic_count_all_ioreqs(struct fnic *fnic)
+{
+	return fnic_count_ioreqs(fnic, 0);
+}
+
+unsigned int fnic_count_lun_ioreqs_wq(struct fnic *fnic, u32 hwq,
+						  struct scsi_device *device)
+{
+	struct fnic_io_req *io_req;
+	int i;
+	unsigned int count = 0;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&fnic->wq_copy_lock[hwq], flags);
+	for (i = 0; i != fnic->sw_copy_wq[hwq].ioreq_table_size; ++i) {
+		io_req = fnic->sw_copy_wq[hwq].io_req_table[i];
+
+		if (io_req != NULL) {
+			struct scsi_cmnd *sc =
+				scsi_host_find_tag(fnic->lport->host, io_req->tag);
+
+			if (!sc)
+				continue;
+
+			if (sc->device == device)
+				count++;
+		}
+	}
+	spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
+
+	return count;
+}
+
+unsigned int fnic_count_lun_ioreqs(struct fnic *fnic,
+								   struct scsi_device *device)
+{
+	int hwq;
+	unsigned int count = 0;
+
+	/*count if any pending IOs on this lun */
+	for (hwq = 0; hwq < fnic->wq_copy_count; hwq++)
+		count += fnic_count_lun_ioreqs_wq(fnic, hwq, device);
+
+	return count;
+}
+
 /* Free up Copy Wq descriptors. Called with copy_wq lock held */
 static int free_wq_copy_descs(struct fnic *fnic, struct vnic_wq_copy *wq, unsigned int hwq)
 {
@@ -179,12 +266,11 @@ int fnic_fw_reset_handler(struct fnic *fnic)
 	struct vnic_wq_copy *wq = &fnic->hw_copy_wq[0];
 	int ret = 0;
 	unsigned long flags;
+	unsigned int ioreq_count;
 
 	/* indicate fwreset to io path */
 	fnic_set_state_flags(fnic, FNIC_FLAGS_FWRESET);
-
-	fnic_free_txq(&fnic->frame_queue);
-	fnic_free_txq(&fnic->tx_queue);
+	ioreq_count = fnic_count_all_ioreqs(fnic);
 
 	/* wait for io cmpl */
 	while (atomic_read(&fnic->in_flight))
@@ -231,10 +317,10 @@ int fnic_flogi_reg_handler(struct fnic *fnic, u32 fc_id)
 {
 	struct vnic_wq_copy *wq = &fnic->hw_copy_wq[0];
 	enum fcpio_flogi_reg_format_type format;
-	struct fc_lport *lp = fnic->lport;
 	u8 gw_mac[ETH_ALEN];
 	int ret = 0;
 	unsigned long flags;
+	struct fnic_iport_s *iport = &fnic->iport;
 
 	spin_lock_irqsave(&fnic->wq_copy_lock[0], flags);
 
@@ -246,28 +332,23 @@ int fnic_flogi_reg_handler(struct fnic *fnic, u32 fc_id)
 		goto flogi_reg_ioreq_end;
 	}
 
-	if (fnic->ctlr.map_dest) {
-		eth_broadcast_addr(gw_mac);
-		format = FCPIO_FLOGI_REG_DEF_DEST;
-	} else {
-		memcpy(gw_mac, fnic->ctlr.dest_addr, ETH_ALEN);
-		format = FCPIO_FLOGI_REG_GW_DEST;
-	}
+	memcpy(gw_mac, fnic->iport.fcfmac, ETH_ALEN);
+	format = FCPIO_FLOGI_REG_GW_DEST;
 
-	if ((fnic->config.flags & VFCF_FIP_CAPABLE) && !fnic->ctlr.map_dest) {
+	if (fnic->config.flags & VFCF_FIP_CAPABLE) {
 		fnic_queue_wq_copy_desc_fip_reg(wq, SCSI_NO_TAG,
 						fc_id, gw_mac,
-						fnic->data_src_addr,
-						lp->r_a_tov, lp->e_d_tov);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
-			      "FLOGI FIP reg issued fcid %x src %pM dest %pM\n",
-			      fc_id, fnic->data_src_addr, gw_mac);
+						fnic->iport.fpma,
+						iport->r_a_tov, iport->e_d_tov);
+		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			      "FLOGI FIP reg issued fcid: 0x%x src %p dest %p\n",
+				  fc_id, fnic->iport.fpma, gw_mac);
 	} else {
 		fnic_queue_wq_copy_desc_flogi_reg(wq, SCSI_NO_TAG,
 						  format, fc_id, gw_mac);
 		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
-			"FLOGI reg issued fcid 0x%x map %d dest 0x%p\n",
-			fc_id, fnic->ctlr.map_dest, gw_mac);
+			"FLOGI reg issued fcid 0x%x dest %p\n",
+			fc_id, gw_mac);
 	}
 
 	atomic64_inc(&fnic->fnic_stats.fw_stats.active_fw_reqs);
@@ -295,13 +376,17 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 {
 	struct scatterlist *sg;
 	struct fc_rport *rport = starget_to_rport(scsi_target(sc->device));
-	struct fc_rport_libfc_priv *rp = rport->dd_data;
 	struct host_sg_desc *desc;
 	struct misc_stats *misc_stats = &fnic->fnic_stats.misc_stats;
 	unsigned int i;
 	int flags;
 	u8 exch_flags;
 	struct scsi_lun fc_lun;
+	struct fnic_tport_s *tport;
+	struct rport_dd_data_s *rdd_data;
+
+	rdd_data = rport->dd_data;
+	tport = rdd_data->tport;
 
 	if (sg_count) {
 		/* For each SGE, create a device desc entry */
@@ -356,7 +441,7 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 
 	exch_flags = 0;
 	if ((fnic->config.flags & VFCF_FCP_SEQ_LVL_ERR) &&
-	    (rp->flags & FC_RP_FLAGS_RETRY))
+		(tport->tgt_flags & FDLS_FC_RP_FLAGS_RETRY))
 		exch_flags |= FCPIO_ICMND_SRFLAG_RETRY;
 
 	fnic_queue_wq_copy_desc_icmnd_16(wq, mqtag,
@@ -371,8 +456,8 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 					 sc->cmnd, sc->cmd_len,
 					 scsi_bufflen(sc),
 					 fc_lun.scsi_lun, io_req->port_id,
-					 rport->maxframe_size, rp->r_a_tov,
-					 rp->e_d_tov);
+					 tport->max_payload_size,
+					 tport->r_a_tov, tport->e_d_tov);
 
 	atomic64_inc(&fnic->fnic_stats.fw_stats.active_fw_reqs);
 	if (atomic64_read(&fnic->fnic_stats.fw_stats.active_fw_reqs) >
@@ -388,10 +473,10 @@ int fnic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 	struct request *const rq = scsi_cmd_to_rq(sc);
 	uint32_t mqtag = 0;
 	void (*done)(struct scsi_cmnd *) = scsi_done;
-	struct fc_lport *lp = shost_priv(sc->device->host);
 	struct fc_rport *rport;
 	struct fnic_io_req *io_req = NULL;
-	struct fnic *fnic = lport_priv(lp);
+	struct fnic *fnic = *((struct fnic **) shost_priv(sc->device->host));
+	struct fnic_iport_s *iport = NULL;
 	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 	struct vnic_wq_copy *wq;
 	int ret = 1;
@@ -400,32 +485,14 @@ int fnic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 	unsigned long flags = 0;
 	unsigned long ptr;
 	int io_lock_acquired = 0;
-	struct fc_rport_libfc_priv *rp;
 	uint16_t hwq = 0;
-
-	mqtag = blk_mq_unique_tag(rq);
-	spin_lock_irqsave(&fnic->fnic_lock, flags);
-
-	if (unlikely(fnic_chk_state_flags_locked(fnic, FNIC_FLAGS_IO_BLOCKED))) {
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
-			"fnic IO blocked flags: 0x%lx. Returning SCSI_MLQUEUE_HOST_BUSY\n",
-			fnic->state_flags);
-		return SCSI_MLQUEUE_HOST_BUSY;
-	}
-
-	if (unlikely(fnic_chk_state_flags_locked(fnic, FNIC_FLAGS_FWRESET))) {
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
-			"fnic flags: 0x%lx. Returning SCSI_MLQUEUE_HOST_BUSY\n",
-			fnic->state_flags);
-		return SCSI_MLQUEUE_HOST_BUSY;
-	}
+	struct fnic_tport_s *tport = NULL;
+	struct rport_dd_data_s *rdd_data;
+	uint16_t lun0_delay = 0;
 
 	rport = starget_to_rport(scsi_target(sc->device));
 	if (!rport) {
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
 				"returning DID_NO_CONNECT for IO as rport is NULL\n");
 		sc->result = DID_NO_CONNECT << 16;
 		done(sc);
@@ -434,50 +501,95 @@ int fnic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 
 	ret = fc_remote_port_chkready(rport);
 	if (ret) {
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
 				"rport is not ready\n");
-		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
 		sc->result = ret;
 		done(sc);
 		return 0;
 	}
 
-	rp = rport->dd_data;
-	if (!rp || rp->rp_state == RPORT_ST_DELETE) {
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
-			"rport 0x%x removed, returning DID_NO_CONNECT\n",
-			rport->port_id);
+	mqtag = blk_mq_unique_tag(rq);
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	iport = &fnic->iport;
 
-		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
-		sc->result = DID_NO_CONNECT<<16;
+	if (iport->state != FNIC_IPORT_STATE_READY) {
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+					  "returning DID_NO_CONNECT for IO as iport state: %d\n",
+					  iport->state);
+		sc->result = DID_NO_CONNECT << 16;
 		done(sc);
 		return 0;
 	}
 
-	if (rp->rp_state != RPORT_ST_READY) {
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
-			"rport 0x%x in state 0x%x, returning DID_IMM_RETRY\n",
-			rport->port_id, rp->rp_state);
+	/* fc_remote_port_add() may have added the tport to
+	 * fc_transport but dd_data not yet set
+	 */
+	rdd_data = rport->dd_data;
+	tport = rdd_data->tport;
+	if (!tport || (rdd_data->iport != iport)) {
+		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+					  "dd_data not yet set in SCSI for rport portid: 0x%x\n",
+					  rport->port_id);
+		tport = fnic_find_tport_by_fcid(iport, rport->port_id);
+		if (!tport) {
+			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+			FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+						  "returning DID_BUS_BUSY for IO as tport not found for: 0x%x\n",
+						  rport->port_id);
+			sc->result = DID_BUS_BUSY << 16;
+			done(sc);
+			return 0;
+		}
+
+		/* Re-assign same params as in fnic_fdls_add_tport */
+		rport->maxframe_size = FNIC_FC_MAX_PAYLOAD_LEN;
+		rport->supported_classes =
+			FC_COS_CLASS3 | FC_RPORT_ROLE_FCP_TARGET;
+		/* the dd_data is allocated by fctransport of size dd_fcrport_size */
+		rdd_data = rport->dd_data;
+		rdd_data->tport = tport;
+		rdd_data->iport = iport;
+		tport->rport = rport;
+		tport->flags |= FNIC_FDLS_SCSI_REGISTERED;
+	}
 
-		sc->result = DID_IMM_RETRY << 16;
+	if ((tport->state != FDLS_TGT_STATE_READY)
+		&& (tport->state != FDLS_TGT_STATE_ADISC)) {
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+					  "returning DID_NO_CONNECT for IO as tport state: %d\n",
+					  tport->state);
+		sc->result = DID_NO_CONNECT << 16;
 		done(sc);
 		return 0;
 	}
 
-	if (lp->state != LPORT_ST_READY || !(lp->link_up)) {
+	atomic_inc(&fnic->in_flight);
+	atomic_inc(&tport->in_flight);
+
+	if (unlikely(fnic_chk_state_flags_locked(fnic, FNIC_FLAGS_IO_BLOCKED))) {
+		atomic_dec(&fnic->in_flight);
+		atomic_dec(&tport->in_flight);
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
+	if (unlikely(fnic_chk_state_flags_locked(fnic, FNIC_FLAGS_FWRESET))) {
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
-			"state not ready: %d/link not up: %d Returning HOST_BUSY\n",
-			lp->state, lp->link_up);
+		  "fnic flags FW reset: 0x%lx. Returning SCSI_MLQUEUE_HOST_BUSY\n",
+		  fnic->state_flags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
-	atomic_inc(&fnic->in_flight);
+	if (!tport->lun0_delay) {
+		lun0_delay = 1;
+		tport->lun0_delay++;
+	}
 
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+
 	fnic_priv(sc)->state = FNIC_IOREQ_NOT_INITED;
 	fnic_priv(sc)->flags = FNIC_NO_FLAGS;
 
@@ -499,6 +611,7 @@ int fnic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 		goto out;
 	}
 
+	io_req->tport = tport;
 	/* Determine the type of scatter/gather list we need */
 	io_req->sgl_cnt = sg_count;
 	io_req->sgl_type = FNIC_SGL_CACHE_DFLT;
@@ -575,6 +688,7 @@ int fnic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 			mempool_free(io_req, fnic->io_req_pool);
 		}
 		atomic_dec(&fnic->in_flight);
+		atomic_dec(&tport->in_flight);
 		return ret;
 	} else {
 		atomic64_inc(&fnic_stats->io_stats.active_ios);
@@ -602,6 +716,14 @@ int fnic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 
 	atomic_dec(&fnic->in_flight);
+	atomic_dec(&tport->in_flight);
+
+	if (lun0_delay) {
+		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					  "LUN0 delay\n");
+		mdelay(LUN0_DELAY_TIME);
+	}
+
 	return ret;
 }
 
@@ -625,7 +747,7 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
 	atomic64_inc(&reset_stats->fw_reset_completions);
 
 	/* Clean up all outstanding io requests */
-	fnic_cleanup_io(fnic);
+	fnic_cleanup_io(fnic, SCSI_NO_TAG);
 
 	atomic64_set(&fnic->fnic_stats.fw_stats.active_fw_reqs, 0);
 	atomic64_set(&fnic->fnic_stats.io_stats.active_ios, 0);
@@ -646,12 +768,6 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
 				"reset failed with header status: %s\n",
 				fnic_fcpio_status_to_str(hdr_status));
 
-			/*
-			 * Unable to change to eth mode, cannot send out flogi
-			 * Change state to fc mode, so that subsequent Flogi
-			 * requests from libFC will cause more attempts to
-			 * reset the firmware. Free the cached flogi
-			 */
 			fnic->state = FNIC_IN_FC_MODE;
 			atomic64_inc(&reset_stats->fw_reset_failures);
 			ret = -1;
@@ -664,15 +780,14 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
 		ret = -1;
 	}
 
-	/* Thread removing device blocks till firmware reset is complete */
-	if (fnic->remove_wait)
-		complete(fnic->remove_wait);
+	if (fnic->fw_reset_done)
+		complete(fnic->fw_reset_done);
 
 	/*
 	 * If fnic is being removed, or fw reset failed
 	 * free the flogi frame. Else, send it out
 	 */
-	if (fnic->remove_wait || ret) {
+	if (ret) {
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		fnic_free_txq(&fnic->tx_queue);
 		goto reset_cmpl_handler_end;
@@ -711,12 +826,12 @@ static int fnic_fcpio_flogi_reg_cmpl_handler(struct fnic *fnic,
 		/* Check flogi registration completion status */
 		if (!hdr_status) {
 			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
-				      "flog reg succeeded\n");
+				      "FLOGI reg succeeded\n");
 			fnic->state = FNIC_IN_FC_MODE;
 		} else {
 			FNIC_SCSI_DBG(KERN_DEBUG,
 				      fnic->lport->host, fnic->fnic_num,
-				      "fnic flogi reg :failed %s\n",
+				      "fnic flogi reg failed: %s\n",
 				      fnic_fcpio_status_to_str(hdr_status));
 			fnic->state = FNIC_IN_ETH_MODE;
 			ret = -1;
@@ -1023,15 +1138,6 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic, unsigned int cq_ind
 		  jiffies_to_msecs(jiffies - start_time)),
 		  desc, cmd_trace, fnic_flags_and_state(sc));
 
-	if (sc->sc_data_direction == DMA_FROM_DEVICE) {
-		fnic->lport->host_stats.fcp_input_requests++;
-		fnic->fcp_input_bytes += xfer_len;
-	} else if (sc->sc_data_direction == DMA_TO_DEVICE) {
-		fnic->lport->host_stats.fcp_output_requests++;
-		fnic->fcp_output_bytes += xfer_len;
-	} else
-		fnic->lport->host_stats.fcp_control_requests++;
-
 	/* Call SCSI completion function to complete the IO */
 	scsi_done(sc);
 
@@ -1414,8 +1520,8 @@ static bool fnic_cleanup_io_iter(struct scsi_cmnd *sc, void *data)
 	struct request *const rq = scsi_cmd_to_rq(sc);
 	struct fnic *fnic = data;
 	struct fnic_io_req *io_req;
-	unsigned long flags = 0;
 	unsigned long start_time = 0;
+	unsigned long flags;
 	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 	uint16_t hwq = 0;
 	int tag;
@@ -1439,7 +1545,7 @@ static bool fnic_cleanup_io_iter(struct scsi_cmnd *sc, void *data)
 	}
 
 	if ((fnic_priv(sc)->flags & FNIC_DEVICE_RESET) &&
-	    !(fnic_priv(sc)->flags & FNIC_DEV_RST_DONE)) {
+		!(fnic_priv(sc)->flags & FNIC_DEV_RST_DONE)) {
 		/*
 		 * We will be here only when FW completes reset
 		 * without sending completions for outstanding ios.
@@ -1449,6 +1555,7 @@ static bool fnic_cleanup_io_iter(struct scsi_cmnd *sc, void *data)
 			complete(io_req->dr_done);
 		else if (io_req && io_req->abts_done)
 			complete(io_req->abts_done);
+
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 		return true;
 	} else if (fnic_priv(sc)->flags & FNIC_DEVICE_RESET) {
@@ -1458,19 +1565,19 @@ static bool fnic_cleanup_io_iter(struct scsi_cmnd *sc, void *data)
 
 	fnic_priv(sc)->io_req = NULL;
 	io_req->sc = NULL;
+	start_time = io_req->start_time;
 	spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 
 	/*
 	 * If there is a scsi_cmnd associated with this io_req, then
 	 * free the corresponding state
 	 */
-	start_time = io_req->start_time;
 	fnic_release_ioreq_buf(fnic, io_req, sc);
 	mempool_free(io_req, fnic->io_req_pool);
 
 	sc->result = DID_TRANSPORT_DISRUPTED << 16;
 	FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
-		"mqtag:0x%x tag: 0x%x sc:0x%p duration = %lu DID_TRANSPORT_DISRUPTED\n",
+	"mqtag: 0x%x tag: 0x%x sc: 0x%p duration = %lu DID_TRANSPORT_DISRUPTED\n",
 		mqtag, tag, sc, (jiffies - start_time));
 
 	if (atomic64_read(&fnic->io_cmpl_skip))
@@ -1479,23 +1586,60 @@ static bool fnic_cleanup_io_iter(struct scsi_cmnd *sc, void *data)
 		atomic64_inc(&fnic_stats->io_stats.io_completions);
 
 	FNIC_TRACE(fnic_cleanup_io,
-		   sc->device->host->host_no, tag, sc,
-		   jiffies_to_msecs(jiffies - start_time),
-		   0, ((u64)sc->cmnd[0] << 32 |
-		       (u64)sc->cmnd[2] << 24 |
-		       (u64)sc->cmnd[3] << 16 |
-		       (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
-		   fnic_flags_and_state(sc));
-
+			   sc->device->host->host_no, tag, sc,
+			   jiffies_to_msecs(jiffies - start_time),
+			   0, ((u64) sc->cmnd[0] << 32 |
+				   (u64) sc->cmnd[2] << 24 |
+				   (u64) sc->cmnd[3] << 16 |
+				   (u64) sc->cmnd[4] << 8 | sc->cmnd[5]),
+			   (((u64) fnic_priv(sc)->flags << 32) | fnic_priv(sc)->
+				state));
+
+	/* Complete the command to SCSI */
 	scsi_done(sc);
-
 	return true;
 }
 
-static void fnic_cleanup_io(struct fnic *fnic)
+static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
 {
+	unsigned int io_count = 0;
+	unsigned long flags;
+	struct fnic_io_req *io_req = NULL;
+	struct scsi_cmnd *sc = NULL;
+
+	io_count = fnic_count_all_ioreqs(fnic);
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+				  "Outstanding ioreq count: %d active io count: %lld Waiting\n",
+				  io_count,
+				  atomic64_read(&fnic->fnic_stats.io_stats.active_ios));
+
 	scsi_host_busy_iter(fnic->lport->host,
-			    fnic_cleanup_io_iter, fnic);
+						fnic_cleanup_io_iter, fnic);
+
+	/* with sg3utils device reset, SC needs to be retrieved from ioreq */
+	spin_lock_irqsave(&fnic->wq_copy_lock[0], flags);
+	io_req = fnic->sw_copy_wq[0].io_req_table[fnic->fnic_max_tag_id];
+	if (io_req) {
+		sc = io_req->sc;
+		if (sc) {
+			if ((fnic_priv(sc)->flags & FNIC_DEVICE_RESET)
+				&& !(fnic_priv(sc)->flags & FNIC_DEV_RST_DONE)) {
+				fnic_priv(sc)->flags |= FNIC_DEV_RST_DONE;
+				if (io_req && io_req->dr_done)
+					complete(io_req->dr_done);
+			}
+		}
+	}
+	spin_unlock_irqrestore(&fnic->wq_copy_lock[0], flags);
+
+	while ((io_count = fnic_count_all_ioreqs(fnic))) {
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+		  "Outstanding ioreq count: %d active io count: %lld Waiting\n",
+		  io_count,
+		  atomic64_read(&fnic->fnic_stats.io_stats.active_ios));
+
+		schedule_timeout(msecs_to_jiffies(100));
+	}
 }
 
 void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
@@ -1567,10 +1711,13 @@ static inline int fnic_queue_abort_io_req(struct fnic *fnic, int tag,
 	struct vnic_wq_copy *wq = &fnic->hw_copy_wq[hwq];
 	struct misc_stats *misc_stats = &fnic->fnic_stats.misc_stats;
 	unsigned long flags;
+	struct fnic_tport_s *tport = io_req->tport;
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	if (unlikely(fnic_chk_state_flags_locked(fnic,
 						FNIC_FLAGS_IO_BLOCKED))) {
+		atomic_dec(&fnic->in_flight);
+		atomic_dec(&tport->in_flight);
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		return 1;
 	} else
@@ -1585,6 +1732,7 @@ static inline int fnic_queue_abort_io_req(struct fnic *fnic, int tag,
 	if (!vnic_wq_copy_desc_avail(wq)) {
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 		atomic_dec(&fnic->in_flight);
+		atomic_dec(&tport->in_flight);
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
 			"fnic_queue_abort_io_req: failure: no descriptors\n");
 		atomic64_inc(&misc_stats->abts_cpwq_alloc_failures);
@@ -1619,20 +1767,24 @@ static bool fnic_rport_abort_io_iter(struct scsi_cmnd *sc, void *data)
 	struct fnic *fnic = iter_data->fnic;
 	int abt_tag = 0;
 	struct fnic_io_req *io_req;
-	unsigned long flags;
 	struct reset_stats *reset_stats = &fnic->fnic_stats.reset_stats;
 	struct terminate_stats *term_stats = &fnic->fnic_stats.term_stats;
 	struct scsi_lun fc_lun;
 	enum fnic_ioreq_state old_ioreq_state;
 	uint16_t hwq = 0;
+	unsigned long flags;
 
 	abt_tag = blk_mq_unique_tag(rq);
 	hwq = blk_mq_unique_tag_to_hwq(abt_tag);
 
-	spin_lock_irqsave(&fnic->wq_copy_lock[hwq], flags);
+	if (!sc) {
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+					  "sc is NULL abt_tag: 0x%x hwq: %d\n", abt_tag, hwq);
+		return true;
+	}
 
+	spin_lock_irqsave(&fnic->wq_copy_lock[hwq], flags);
 	io_req = fnic_priv(sc)->io_req;
-
 	if (!io_req || io_req->port_id != iter_data->port_id) {
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 		return true;
@@ -1655,37 +1807,38 @@ static bool fnic_rport_abort_io_iter(struct scsi_cmnd *sc, void *data)
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 		return true;
 	}
+
 	if (io_req->abts_done) {
 		shost_printk(KERN_ERR, fnic->lport->host,
-			"fnic_rport_exch_reset: io_req->abts_done is set "
-			"state is %s\n",
+			"fnic_rport_exch_reset: io_req->abts_done is set state is %s\n",
 			fnic_ioreq_state_to_str(fnic_priv(sc)->state));
 	}
 
 	if (!(fnic_priv(sc)->flags & FNIC_IO_ISSUED)) {
 		shost_printk(KERN_ERR, fnic->lport->host,
-			     "rport_exch_reset "
-			     "IO not yet issued %p tag 0x%x flags "
-			     "%x state %d\n",
-			     sc, abt_tag, fnic_priv(sc)->flags, fnic_priv(sc)->state);
+			"rport_exch_reset IO not yet issued %p abt_tag 0x%x",
+			sc, abt_tag);
+		shost_printk(KERN_ERR, fnic->lport->host,
+			"flags %x state %d\n", fnic_priv(sc)->flags,
+			fnic_priv(sc)->state);
 	}
 	old_ioreq_state = fnic_priv(sc)->state;
 	fnic_priv(sc)->state = FNIC_IOREQ_ABTS_PENDING;
 	fnic_priv(sc)->abts_status = FCPIO_INVALID_CODE;
+
 	if (fnic_priv(sc)->flags & FNIC_DEVICE_RESET) {
 		atomic64_inc(&reset_stats->device_reset_terminates);
 		abt_tag |= FNIC_TAG_DEV_RST;
 	}
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
-		      "fnic_rport_exch_reset dev rst sc 0x%p\n", sc);
-	BUG_ON(io_req->abts_done);
-
+		      "fnic_rport_exch_reset: dev rst sc 0x%p\n", sc);
+	WARN_ON_ONCE(io_req->abts_done);
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
 		      "fnic_rport_reset_exch: Issuing abts\n");
 
 	spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 
-	/* Now queue the abort command to firmware */
+	/* Queue the abort command to firmware */
 	int_to_scsilun(sc->device->lun, &fc_lun);
 
 	if (fnic_queue_abort_io_req(fnic, abt_tag,
@@ -1714,11 +1867,14 @@ static bool fnic_rport_abort_io_iter(struct scsi_cmnd *sc, void *data)
 		atomic64_inc(&term_stats->terminates);
 		iter_data->term_cnt++;
 	}
+
 	return true;
 }
 
 void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 {
+	unsigned int io_count = 0;
+	unsigned long flags;
 	struct terminate_stats *term_stats = &fnic->fnic_stats.term_stats;
 	struct fnic_rport_abort_io_iter_data iter_data = {
 		.fnic = fnic,
@@ -1726,53 +1882,75 @@ void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 		.term_cnt = 0,
 	};
 
-	FNIC_SCSI_DBG(KERN_DEBUG,
-		      fnic->lport->host, fnic->fnic_num,
-		      "fnic_rport_exch_reset called portid 0x%06x\n",
-		      port_id);
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+				  "fnic rport exchange reset for tport: 0x%06x\n",
+				  port_id);
 
 	if (fnic->in_remove)
 		return;
 
+	io_count = fnic_count_ioreqs(fnic, port_id);
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+				  "Starting terminates: rport:0x%x  portid-io-count: %d active-io-count: %lld\n",
+				  port_id, io_count,
+				  atomic64_read(&fnic->fnic_stats.io_stats.active_ios));
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	atomic_inc(&fnic->in_flight);
+	if (unlikely(fnic_chk_state_flags_locked(fnic, FNIC_FLAGS_IO_BLOCKED))) {
+		atomic_dec(&fnic->in_flight);
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+
 	scsi_host_busy_iter(fnic->lport->host, fnic_rport_abort_io_iter,
 			    &iter_data);
+
 	if (iter_data.term_cnt > atomic64_read(&term_stats->max_terminates))
 		atomic64_set(&term_stats->max_terminates, iter_data.term_cnt);
 
+	atomic_dec(&fnic->in_flight);
+
+	while ((io_count = fnic_count_ioreqs(fnic, port_id)))
+		schedule_timeout(msecs_to_jiffies(1000));
+
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+				  "rport: 0x%x remaining portid-io-count: %d ",
+				  port_id, io_count);
 }
 
 void fnic_terminate_rport_io(struct fc_rport *rport)
 {
-	struct fc_rport_libfc_priv *rdata;
-	struct fc_lport *lport;
-	struct fnic *fnic;
+	struct fnic_tport_s *tport;
+	struct rport_dd_data_s *rdd_data;
+	struct fnic_iport_s *iport = NULL;
+	struct fnic *fnic = NULL;
 
 	if (!rport) {
-		printk(KERN_ERR "fnic_terminate_rport_io: rport is NULL\n");
+		pr_err("rport is NULL\n");
 		return;
 	}
-	rdata = rport->dd_data;
 
-	if (!rdata) {
-		printk(KERN_ERR "fnic_terminate_rport_io: rdata is NULL\n");
-		return;
-	}
-	lport = rdata->local_port;
-
-	if (!lport) {
-		printk(KERN_ERR "fnic_terminate_rport_io: lport is NULL\n");
-		return;
+	rdd_data = rport->dd_data;
+	if (rdd_data) {
+		tport = rdd_data->tport;
+		if (!tport) {
+			pr_err(
+			"term rport io called after tport is deleted. Returning 0x%8x\n",
+		   rport->port_id);
+		} else {
+			pr_err(
+			   "term rport io called after tport is set 0x%8x\n",
+			   rport->port_id);
+			pr_err(
+			   "tport maybe rediscovered\n");
+
+			iport = (struct fnic_iport_s *) tport->iport;
+			fnic = iport->fnic;
+			fnic_rport_exch_reset(fnic, rport->port_id);
+		}
 	}
-	fnic = lport_priv(lport);
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
-		      "wwpn 0x%llx, wwnn0x%llx, rport 0x%p, portid 0x%06x\n",
-		      rport->port_name, rport->node_name, rport,
-		      rport->port_id);
-
-	if (fnic->in_remove)
-		return;
-
-	fnic_rport_exch_reset(fnic, rport->port_id);
 }
 
 /*
@@ -1783,10 +1961,12 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
 int fnic_abort_cmd(struct scsi_cmnd *sc)
 {
 	struct request *const rq = scsi_cmd_to_rq(sc);
-	struct fc_lport *lp;
+	struct fnic_iport_s *iport;
+	struct fnic_tport_s *tport;
 	struct fnic *fnic;
 	struct fnic_io_req *io_req = NULL;
 	struct fc_rport *rport;
+	struct rport_dd_data_s *rdd_data;
 	unsigned long flags;
 	unsigned long start_time = 0;
 	int ret = SUCCESS;
@@ -1806,11 +1986,11 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	fc_block_scsi_eh(sc);
 
 	/* Get local-port, check ready and link up */
-	lp = shost_priv(sc->device->host);
-
-	fnic = lport_priv(lp);
+	fnic = *((struct fnic **) shost_priv(sc->device->host));
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	iport = &fnic->iport;
+
 	fnic_stats = &fnic->fnic_stats;
 	abts_stats = &fnic->fnic_stats.abts_stats;
 	term_stats = &fnic->fnic_stats.term_stats;
@@ -1821,7 +2001,43 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 
 	fnic_priv(sc)->flags = FNIC_NO_FLAGS;
 
-	if (lp->state != LPORT_ST_READY || !(lp->link_up)) {
+	rdd_data = rport->dd_data;
+	tport = rdd_data->tport;
+
+	if (!tport) {
+		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			  "Abort cmd called after tport delete! rport fcid: 0x%x",
+			  rport->port_id);
+		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			  "lun: %llu hwq: 0x%x mqtag: 0x%x Op: 0x%x flags: 0x%x\n",
+			  sc->device->lun, hwq, mqtag,
+			  sc->cmnd[0], fnic_priv(sc)->flags);
+		ret = FAILED;
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		goto fnic_abort_cmd_end;
+	}
+
+	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	  "Abort cmd called rport fcid: 0x%x lun: %llu hwq: 0x%x mqtag: 0x%x",
+	  rport->port_id, sc->device->lun, hwq, mqtag);
+
+	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				  "Op: 0x%x flags: 0x%x\n",
+				  sc->cmnd[0],
+				  fnic_priv(sc)->flags);
+
+	if (iport->state != FNIC_IPORT_STATE_READY) {
+		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					  "iport NOT in READY state");
+		ret = FAILED;
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		goto fnic_abort_cmd_end;
+	}
+
+	if ((tport->state != FDLS_TGT_STATE_READY) &&
+		(tport->state != FDLS_TGT_STATE_ADISC)) {
+		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+					  "tport state: %d\n", tport->state);
 		ret = FAILED;
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		goto fnic_abort_cmd_end;
@@ -1843,6 +2059,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	spin_lock_irqsave(&fnic->wq_copy_lock[hwq], flags);
 	io_req = fnic_priv(sc)->io_req;
 	if (!io_req) {
+		ret = FAILED;
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 		goto fnic_abort_cmd_end;
 	}
@@ -1893,7 +2110,6 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	if (fc_remote_port_chkready(rport) == 0)
 		task_req = FCPIO_ITMF_ABT_TASK;
 	else {
-		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
 		task_req = FCPIO_ITMF_ABT_TASK_TERM;
 	}
 
@@ -2027,6 +2243,7 @@ static inline int fnic_queue_dr_io_req(struct fnic *fnic,
 	unsigned long flags;
 	uint16_t hwq = 0;
 	uint32_t tag = 0;
+	struct fnic_tport_s *tport = io_req->tport;
 
 	tag = io_req->tag;
 	hwq = blk_mq_unique_tag_to_hwq(tag);
@@ -2037,8 +2254,10 @@ static inline int fnic_queue_dr_io_req(struct fnic *fnic,
 						FNIC_FLAGS_IO_BLOCKED))) {
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		return FAILED;
-	} else
+	} else {
 		atomic_inc(&fnic->in_flight);
+		atomic_inc(&tport->in_flight);
+	}
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
 	spin_lock_irqsave(&fnic->wq_copy_lock[hwq], flags);
@@ -2072,6 +2291,7 @@ static inline int fnic_queue_dr_io_req(struct fnic *fnic,
 lr_io_req_end:
 	spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 	atomic_dec(&fnic->in_flight);
+	atomic_inc(&tport->in_flight);
 
 	return ret;
 }
@@ -2274,11 +2494,11 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 int fnic_device_reset(struct scsi_cmnd *sc)
 {
 	struct request *rq = scsi_cmd_to_rq(sc);
-	struct fc_lport *lp;
 	struct fnic *fnic;
 	struct fnic_io_req *io_req = NULL;
 	struct fc_rport *rport;
 	int status;
+	int count = 0;
 	int ret = FAILED;
 	unsigned long flags;
 	unsigned long start_time = 0;
@@ -2289,31 +2509,61 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 	bool new_sc = 0;
 	uint16_t hwq = 0;
+	struct fnic_iport_s *iport = NULL;
+	struct rport_dd_data_s *rdd_data;
+	struct fnic_tport_s *tport;
+	u32 old_soft_reset_count;
+	u32 old_link_down_cnt;
+	int exit_dr = 0;
 
 	/* Wait for rport to unblock */
 	fc_block_scsi_eh(sc);
 
 	/* Get local-port, check ready and link up */
-	lp = shost_priv(sc->device->host);
+	fnic = *((struct fnic **) shost_priv(sc->device->host));
+	iport = &fnic->iport;
 
-	fnic = lport_priv(lp);
 	fnic_stats = &fnic->fnic_stats;
 	reset_stats = &fnic->fnic_stats.reset_stats;
 
 	atomic64_inc(&reset_stats->device_resets);
 
 	rport = starget_to_rport(scsi_target(sc->device));
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
-		"fcid: 0x%x lun: 0x%llx hwq: %d mqtag: 0x%x flags: 0x%x Device reset\n",
+		"fcid: 0x%x lun: %llu hwq: %d mqtag: 0x%x flags: 0x%x Device reset\n",
 		rport->port_id, sc->device->lun, hwq, mqtag,
 		fnic_priv(sc)->flags);
 
-	if (lp->state != LPORT_ST_READY || !(lp->link_up))
+	rdd_data = rport->dd_data;
+	tport = rdd_data->tport;
+	if (!tport) {
+		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		  "Dev rst called after tport delete! rport fcid: 0x%x lun: %llu\n",
+		  rport->port_id, sc->device->lun);
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		goto fnic_device_reset_end;
+	}
+
+	if (iport->state != FNIC_IPORT_STATE_READY) {
+		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					  "iport NOT in READY state");
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		goto fnic_device_reset_end;
+	}
+
+	if ((tport->state != FDLS_TGT_STATE_READY) &&
+		(tport->state != FDLS_TGT_STATE_ADISC)) {
+		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+					  "tport state: %d\n", tport->state);
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		goto fnic_device_reset_end;
+	}
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
 	/* Check if remote port up */
 	if (fc_remote_port_chkready(rport)) {
-		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
 		goto fnic_device_reset_end;
 	}
 
@@ -2352,6 +2602,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		io_req->port_id = rport->port_id;
 		io_req->tag = mqtag;
 		fnic_priv(sc)->io_req = io_req;
+		io_req->tport = tport;
 		io_req->sc = sc;
 
 		if (fnic->sw_copy_wq[hwq].io_req_table[blk_mq_unique_tag_to_tag(mqtag)] != NULL)
@@ -2383,6 +2634,11 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	fnic_priv(sc)->flags |= FNIC_DEV_RST_ISSUED;
 	spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	old_link_down_cnt = iport->fnic->link_down_cnt;
+	old_soft_reset_count = fnic->soft_reset_count;
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+
 	/*
 	 * Wait on the local completion for LUN reset.  The io_req may be
 	 * freed while we wait since we hold no lock.
@@ -2390,6 +2646,24 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	wait_for_completion_timeout(&tm_done,
 				    msecs_to_jiffies(FNIC_LUN_RESET_TIMEOUT));
 
+	/*
+	 * Wake up can be due to the following reasons:
+	 * 1) The device reset completed from target.
+	 * 2) Device reset timed out.
+	 * 3) A link-down/host_reset may have happened in between.
+	 * 4) The device reset was aborted and io_req->dr_done was called.
+	 */
+
+	exit_dr = 0;
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	if ((old_link_down_cnt != fnic->link_down_cnt) ||
+		(fnic->reset_in_progress) ||
+		(fnic->soft_reset_count != old_soft_reset_count) ||
+		(iport->state != FNIC_IPORT_STATE_READY))
+		exit_dr = 1;
+
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+
 	spin_lock_irqsave(&fnic->wq_copy_lock[hwq], flags);
 	io_req = fnic_priv(sc)->io_req;
 	if (!io_req) {
@@ -2398,6 +2672,13 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 				"io_req is null mqtag 0x%x sc 0x%p\n", mqtag, sc);
 		goto fnic_device_reset_end;
 	}
+
+	if (exit_dr) {
+		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+					  "Host reset called for fnic. Exit device reset\n");
+		io_req->dr_done = NULL;
+		goto fnic_device_reset_clean;
+	}
 	io_req->dr_done = NULL;
 
 	status = fnic_priv(sc)->lr_status;
@@ -2411,50 +2692,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
 			      "Device reset timed out\n");
 		fnic_priv(sc)->flags |= FNIC_DEV_RST_TIMED_OUT;
-		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 		int_to_scsilun(sc->device->lun, &fc_lun);
-		/*
-		 * Issue abort and terminate on device reset request.
-		 * If q'ing of terminate fails, retry it after a delay.
-		 */
-		while (1) {
-			spin_lock_irqsave(&fnic->wq_copy_lock[hwq], flags);
-			if (fnic_priv(sc)->flags & FNIC_DEV_RST_TERM_ISSUED) {
-				spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
-				break;
-			}
-			spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
-			if (fnic_queue_abort_io_req(fnic,
-				mqtag | FNIC_TAG_DEV_RST,
-				FCPIO_ITMF_ABT_TASK_TERM,
-				fc_lun.scsi_lun, io_req, hwq)) {
-				wait_for_completion_timeout(&tm_done,
-				msecs_to_jiffies(FNIC_ABT_TERM_DELAY_TIMEOUT));
-			} else {
-				spin_lock_irqsave(&fnic->wq_copy_lock[hwq], flags);
-				fnic_priv(sc)->flags |= FNIC_DEV_RST_TERM_ISSUED;
-				fnic_priv(sc)->state = FNIC_IOREQ_ABTS_PENDING;
-				io_req->abts_done = &tm_done;
-				spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
-				FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
-				"Abort and terminate issued on Device reset mqtag 0x%x sc 0x%p\n",
-				mqtag, sc);
-				break;
-			}
-		}
-		while (1) {
-			spin_lock_irqsave(&fnic->wq_copy_lock[hwq], flags);
-			if (!(fnic_priv(sc)->flags & FNIC_DEV_RST_DONE)) {
-				spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
-				wait_for_completion_timeout(&tm_done,
-				msecs_to_jiffies(FNIC_LUN_RESET_TIMEOUT));
-				break;
-			} else {
-				io_req = fnic_priv(sc)->io_req;
-				io_req->abts_done = NULL;
-				goto fnic_device_reset_clean;
-			}
-		}
+		goto fnic_device_reset_clean;
 	} else {
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 	}
@@ -2480,8 +2719,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		spin_lock_irqsave(&fnic->wq_copy_lock[hwq], flags);
 		io_req = fnic_priv(sc)->io_req;
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
-			      "Device reset failed"
-			      " since could not abort all IOs\n");
+					  "Device reset failed: Cannot abort all IOs\n");
 		goto fnic_device_reset_clean;
 	}
 
@@ -2507,6 +2745,15 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		mempool_free(io_req, fnic->io_req_pool);
 	}
 
+	/*
+	 * If link-event is seen while LUN reset is issued we need
+	 * to complete the LUN reset here
+	 */
+	if (!new_sc) {
+		sc->result = DID_RESET << 16;
+		scsi_done(sc);
+	}
+
 fnic_device_reset_end:
 	FNIC_TRACE(fnic_device_reset, sc->device->host->host_no, rq->tag, sc,
 		  jiffies_to_msecs(jiffies - start_time),
@@ -2520,6 +2767,17 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		mutex_unlock(&fnic->sgreset_mutex);
 	}
 
+	while ((ret == SUCCESS) && fnic_count_lun_ioreqs(fnic, sc->device)) {
+		if (count >= 2) {
+			ret = FAILED;
+			break;
+		}
+		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+					  "Cannot clean up all IOs for the LUN\n");
+		schedule_timeout(msecs_to_jiffies(1000));
+		count++;
+	}
+
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
 		      "Returning from device reset %s\n",
 		      (ret == SUCCESS) ?
@@ -2531,50 +2789,54 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	return ret;
 }
 
-/* Clean up all IOs, clean up libFC local port */
-int fnic_reset(struct Scsi_Host *shost)
+static void fnic_post_flogo_linkflap(struct fnic *fnic)
+{
+	unsigned long flags;
+
+	fnic_fdls_link_status_change(fnic, 0);
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+
+	if (fnic->link_status) {
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		fnic_fdls_link_status_change(fnic, 1);
+		return;
+	}
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+}
+
+/* Logout from all the targets and simulate link flap */
+void fnic_reset(struct Scsi_Host *shost)
 {
-	struct fc_lport *lp;
 	struct fnic *fnic;
-	int ret = 0;
 	struct reset_stats *reset_stats;
 
-	lp = shost_priv(shost);
-	fnic = lport_priv(lp);
+	fnic = *((struct fnic **) shost_priv(shost));
 	reset_stats = &fnic->fnic_stats.reset_stats;
 
 	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
-			"Issuing fnic reset\n");
+				  "Issuing fnic reset\n");
 
 	atomic64_inc(&reset_stats->fnic_resets);
-
-	/*
-	 * Reset local port, this will clean up libFC exchanges,
-	 * reset remote port sessions, and if link is up, begin flogi
-	 */
-	ret = fc_lport_reset(lp);
+	fnic_post_flogo_linkflap(fnic);
 
 	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
-		"Returning from fnic reset with: %s\n",
-		(ret == 0) ? "SUCCESS" : "FAILED");
+				  "Returning from fnic reset");
 
-	if (ret == 0)
-		atomic64_inc(&reset_stats->fnic_reset_completions);
-	else
-		atomic64_inc(&reset_stats->fnic_reset_failures);
+	atomic64_inc(&reset_stats->fnic_reset_completions);
+}
+
+int fnic_issue_fc_host_lip(struct Scsi_Host *shost)
+{
+	int ret = 0;
+	struct fnic *fnic = *((struct fnic **) shost_priv(shost));
+
+	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				  "FC host lip issued");
 
+	ret = fnic_host_reset(shost);
 	return ret;
 }
 
-/*
- * SCSI Error handling calls driver's eh_host_reset if all prior
- * error handling levels return FAILED. If host reset completes
- * successfully, and if link is up, then Fabric login begins.
- *
- * Host Reset is the highest level of error recovery. If this fails, then
- * host is offlined by SCSI.
- *
- */
 int fnic_host_reset(struct Scsi_Host *shost)
 {
 	int ret;
@@ -2637,122 +2899,6 @@ int fnic_host_reset(struct Scsi_Host *shost)
 	return ret;
 }
 
-/*
- * This fxn is called from libFC when host is removed
- */
-void fnic_scsi_abort_io(struct fc_lport *lp)
-{
-	int err = 0;
-	unsigned long flags;
-	enum fnic_state old_state;
-	struct fnic *fnic = lport_priv(lp);
-	DECLARE_COMPLETION_ONSTACK(remove_wait);
-
-	/* Issue firmware reset for fnic, wait for reset to complete */
-retry_fw_reset:
-	spin_lock_irqsave(&fnic->fnic_lock, flags);
-	if (unlikely(fnic->state == FNIC_IN_FC_TRANS_ETH_MODE) &&
-		     fnic->link_events) {
-		/* fw reset is in progress, poll for its completion */
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		schedule_timeout(msecs_to_jiffies(100));
-		goto retry_fw_reset;
-	}
-
-	fnic->remove_wait = &remove_wait;
-	old_state = fnic->state;
-	fnic->state = FNIC_IN_FC_TRANS_ETH_MODE;
-	fnic_update_mac_locked(fnic, fnic->ctlr.ctl_src_addr);
-	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-
-	err = fnic_fw_reset_handler(fnic);
-	if (err) {
-		spin_lock_irqsave(&fnic->fnic_lock, flags);
-		if (fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)
-			fnic->state = old_state;
-		fnic->remove_wait = NULL;
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		return;
-	}
-
-	/* Wait for firmware reset to complete */
-	wait_for_completion_timeout(&remove_wait,
-				    msecs_to_jiffies(FNIC_RMDEVICE_TIMEOUT));
-
-	spin_lock_irqsave(&fnic->fnic_lock, flags);
-	fnic->remove_wait = NULL;
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
-		      "fnic_scsi_abort_io %s\n",
-		      (fnic->state == FNIC_IN_ETH_MODE) ?
-		      "SUCCESS" : "FAILED");
-	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-
-}
-
-/*
- * This fxn called from libFC to clean up driver IO state on link down
- */
-void fnic_scsi_cleanup(struct fc_lport *lp)
-{
-	unsigned long flags;
-	enum fnic_state old_state;
-	struct fnic *fnic = lport_priv(lp);
-
-	/* issue fw reset */
-retry_fw_reset:
-	spin_lock_irqsave(&fnic->fnic_lock, flags);
-	if (unlikely(fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)) {
-		/* fw reset is in progress, poll for its completion */
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		schedule_timeout(msecs_to_jiffies(100));
-		goto retry_fw_reset;
-	}
-	old_state = fnic->state;
-	fnic->state = FNIC_IN_FC_TRANS_ETH_MODE;
-	fnic_update_mac_locked(fnic, fnic->ctlr.ctl_src_addr);
-	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-
-	if (fnic_fw_reset_handler(fnic)) {
-		spin_lock_irqsave(&fnic->fnic_lock, flags);
-		if (fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)
-			fnic->state = old_state;
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-	}
-
-}
-
-void fnic_empty_scsi_cleanup(struct fc_lport *lp)
-{
-}
-
-void fnic_exch_mgr_reset(struct fc_lport *lp, u32 sid, u32 did)
-{
-	struct fnic *fnic = lport_priv(lp);
-
-	/* Non-zero sid, nothing to do */
-	if (sid)
-		goto call_fc_exch_mgr_reset;
-
-	if (did) {
-		fnic_rport_exch_reset(fnic, did);
-		goto call_fc_exch_mgr_reset;
-	}
-
-	/*
-	 * sid = 0, did = 0
-	 * link down or device being removed
-	 */
-	if (!fnic->in_remove)
-		fnic_scsi_cleanup(lp);
-	else
-		fnic_scsi_abort_io(lp);
-
-	/* call libFC exch mgr reset to reset its exchanges */
-call_fc_exch_mgr_reset:
-	fc_exch_mgr_reset(lp, sid, did);
-
-}
-
 static bool fnic_abts_pending_iter(struct scsi_cmnd *sc, void *data)
 {
 	struct request *const rq = scsi_cmd_to_rq(sc);
diff --git a/drivers/scsi/fnic/fnic_stats.h b/drivers/scsi/fnic/fnic_stats.h
index 9d7f98c452dd..1f1a1ec90a23 100644
--- a/drivers/scsi/fnic/fnic_stats.h
+++ b/drivers/scsi/fnic/fnic_stats.h
@@ -127,6 +127,4 @@ struct stats_debug_info {
 };
 
 int fnic_get_stats_data(struct stats_debug_info *, struct fnic_stats *);
-void fnic_stats_debugfs_init(struct fnic *);
-void fnic_stats_debugfs_remove(struct fnic *);
 #endif /* _FNIC_STATS_H_ */
-- 
2.31.1

