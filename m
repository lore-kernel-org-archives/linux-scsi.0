From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [2/15] qla2xxx:  Track DSDs used by an SRB
Date: Sun, 14 Mar 2004 00:24:14 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314082414.GA3395@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:61882 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263314AbUCNIVp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 03:21:45 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

ChangeSet
  1.1658 04/02/28 21:34:23 andrew.vasquez@qlogic.com +3 -0
  Track the number of DSDs and request entries required for an
  SRB in case of a request-entry or command-slot shortage.

  drivers/scsi/qla2xxx/qla_os.c
    1.8 04/02/28 21:34:17 andrew.vasquez@qlogic.com +1 -0
    Clear an SRB's request-entry count.

  drivers/scsi/qla2xxx/qla_iocb.c
    1.4 04/02/28 21:34:17 andrew.vasquez@qlogic.com +20 -20
    Track the number of DSDs and request entries required in case
    of a request-entry or command-slot shortage.

  drivers/scsi/qla2xxx/qla_def.h
    1.7 04/02/28 21:34:17 andrew.vasquez@qlogic.com +4 -0
    Add counts to track total number of DSDs and request entries
    required to issue an SRB.

 drivers/scsi/qla2xxx/qla_def.h  |    4 ++++
 drivers/scsi/qla2xxx/qla_iocb.c |   40 ++++++++++++++++++++--------------------
 drivers/scsi/qla2xxx/qla_os.c   |    1 +
 3 files changed, 25 insertions(+), 20 deletions(-)

ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b11k/11_track_dsds.patch

diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	Fri Mar 12 17:06:29 2004
+++ b/drivers/scsi/qla2xxx/qla_def.h	Fri Mar 12 17:06:29 2004
@@ -266,6 +266,10 @@
 	uint8_t	fo_retry_cnt;		/* Retry count this request */
 	uint8_t	err_id;			/* error id */
 
+	/* Segment/entries counts */
+	uint16_t	req_cnt;	/* !0 indicates counts determined */
+	uint16_t	tot_dsds;
+
 	/* SRB magic number */
 	uint16_t magic;
 #define SRB_MAGIC       0x10CB
diff -Nru a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
--- a/drivers/scsi/qla2xxx/qla_iocb.c	Fri Mar 12 17:06:29 2004
+++ b/drivers/scsi/qla2xxx/qla_iocb.c	Fri Mar 12 17:06:29 2004
@@ -350,7 +350,7 @@
 	uint32_t	*clr_ptr;
 	uint32_t        index;
 	uint32_t	handle;
-	uint16_t	cnt, tot_dsds, req_cnt;
+	uint16_t	cnt;
 	cmd_entry_t	*cmd_pkt;
 	uint32_t        timeout;
 	struct scatterlist *sg;
@@ -372,21 +372,23 @@
 		ha->marker_needed = 0;
 	}
 
-	/* Calculate number of segments and entries required */
-	tot_dsds = 0;
-	if (cmd->use_sg) {
-		sg = (struct scatterlist *) cmd->request_buffer;
-		tot_dsds = pci_map_sg(ha->pdev, sg, cmd->use_sg,
-		    cmd->sc_data_direction);
-	} else if (cmd->request_bufflen) {   /* Single segment transfer */
-		tot_dsds++;
+	/* Calculate number of segments and entries required. */
+	if (sp->req_cnt == 0) {
+		sp->tot_dsds = 0;
+		if (cmd->use_sg) {
+			sg = (struct scatterlist *) cmd->request_buffer;
+			sp->tot_dsds = pci_map_sg(ha->pdev, sg, cmd->use_sg,
+			    cmd->sc_data_direction);
+		} else if (cmd->request_bufflen) {
+		    sp->tot_dsds++;
+		}
+		sp->req_cnt = (ha->calc_request_entries)(sp->tot_dsds);
 	}
-	req_cnt = (ha->calc_request_entries)(tot_dsds);
 
 	/* Acquire ring specific lock */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
-	if (ha->req_q_cnt < (req_cnt + 2)) {
+	if (ha->req_q_cnt < (sp->req_cnt + 2)) {
 		/* Calculate number of free request entries */
 		cnt = RD_REG_WORD(ISP_REQ_Q_OUT(ha, reg));
 		if (ha->req_ring_index < cnt)
@@ -397,10 +399,11 @@
 	}
 
 	/* If no room for request in request ring */
-	if (ha->req_q_cnt < (req_cnt + 2)) {
+	if (ha->req_q_cnt < (sp->req_cnt + 2)) {
 		DEBUG5(printk("scsi(%ld): in-ptr=%x req_q_cnt=%x "
 		    "tot_dsds=%x.\n",
-		    ha->host_no, ha->req_ring_index, ha->req_q_cnt, tot_dsds));
+		    ha->host_no, ha->req_ring_index, ha->req_q_cnt,
+		    sp->tot_dsds));
 
 		goto queuing_error;
 	}
@@ -427,14 +430,14 @@
 	ha->outstanding_cmds[handle] = sp;
 	sp->ha = ha;
 	sp->cmd->host_scribble = (unsigned char *)(unsigned long)handle;
-	ha->req_q_cnt -= req_cnt;
+	ha->req_q_cnt -= sp->req_cnt;
 
 	cmd_pkt = (cmd_entry_t *)ha->request_ring_ptr;
 	cmd_pkt->handle = handle;
 	/* Zero out remaining portion of packet. */
 	clr_ptr = (uint32_t *)cmd_pkt + 2;
 	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
-	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
+	cmd_pkt->dseg_count = cpu_to_le16(sp->tot_dsds);
 
 	/* Set target ID */
 	SET_TARGET_ID(ha, cmd_pkt->target, fclun->fcport->loop_id);
@@ -474,10 +477,10 @@
 	cmd_pkt->byte_count = cpu_to_le32((uint32_t)cmd->request_bufflen);
 
 	/* Build IOCB segments */
-	(ha->build_scsi_iocbs)(sp, cmd_pkt, tot_dsds);
+	(ha->build_scsi_iocbs)(sp, cmd_pkt, sp->tot_dsds);
 
 	/* Set total data segment count. */
-	cmd_pkt->entry_count = (uint8_t)req_cnt;
+	cmd_pkt->entry_count = (uint8_t)sp->req_cnt;
 
 	/* Adjust ring index. */
 	ha->req_ring_index++;
@@ -503,9 +506,6 @@
 
 queuing_error:
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-	if (cmd->use_sg)
-		pci_unmap_sg(ha->pdev, sg, cmd->use_sg, cmd->sc_data_direction);
 
 	return (QLA_FUNCTION_FAILED);
 }
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Fri Mar 12 17:06:29 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Fri Mar 12 17:06:29 2004
@@ -3593,6 +3593,7 @@
 	sp = mempool_alloc(ha->srb_mempool, GFP_KERNEL);
 	if (sp) {
 		atomic_set(&sp->ref_count, 1);
+		sp->req_cnt = 0;
 	}
 	return (sp);
 }
