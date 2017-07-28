From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: [PATCH 16/22] zfcp: use endianness conversions with common FC(P) struct fields
Date: Fri, 28 Jul 2017 12:31:02 +0200
Message-ID: <ad4cb361e66f1407194ad3597861f54bab67d6d9.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48397 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751936AbdG1KbP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Jul 2017 06:31:15 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6SASgqf084308
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:15 -0400
Received: from e06smtp15.uk.ibm.com (e06smtp15.uk.ibm.com [195.75.94.111])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2c01p4dj9r-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:15 -0400
Received: from localhost
        by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Fri, 28 Jul 2017 11:31:13 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v6SAVAfn37486842
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 10:31:10 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A21FE420B7
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:19 +0100 (BST)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89A16420BB
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:19 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.213])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:19 +0100 (BST)
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

From: Steffen Maier <maier@linux.vnet.ibm.com>

Just to silence sparse. Since zfcp only exists for s390 and
s390 is big endian, this has been working correctly without conversions
and all the new conversions are NOPs so no performance impact.

Nonetheless, use the conversion on the constant expression where possible.

NB: N_Port-IDs have always been handled with hton24 or ntoh24 conversions
because they also convert to / from character array.

Affected common code structs and .fields are:

HOT I/O PATH:
fcp_cmnd .fc_dl
   FCP command: regular SCSI I/O, including DIX case

SEMI-HOT I/O PATH:
fcp_cmnd .fc_dl
   recovery FCP command: task management function (LUN / target reset)
fcp_resp_ext
   FCP response having FCP_SNS_LEN_VAL with .fr_rsp_len .fr_sns_len
   FCP response having FCP_RESID_UNDER with .fr_resid

RECOVERY / DISCOVERY PATHS:
fc_ct_hdr .ct_cmd .ct_mr_size
   zfcp auto port scan [GPN_FT] with fc_gpn_ft_resp.fp_wwpn,
   recovery for returned port [GID_PN] with fc_ns_gid_pn.fn_wwpn,
   get symbolic port name [GSPN],
   register symbolic port name [RSPN] (NPIV only).
fc_els_rscn .rscn_plen
   incoming ELS (RSCN).
fc_els_flogi .fl_wwpn .fl_wwnn
   incoming ELS (PLOGI),
   port open response with .fl_csp.sp_bb_data .fl_cssp[0..3].cp_class,
   FCP channel physical port,
   point-to-point peer (P2P only).
fc_els_logo .fl_n_port_wwn
   incoming ELS (LOGO).
fc_els_adisc .adisc_wwnn .adisc_wwpn
   path test after RSCN for gone target port.

Since v4.10 commit 05de97003c77 ("linux/types.h: enable endian checks for
all sparse builds"), below sparse endianness reports appear by default.
Previously, one needed to pass argument CF="-D__CHECK_ENDIAN__" to make
as in: $ make C=1 CF="-D__CHECK_ENDIAN__" M=drivers/s390/scsi.

Silenced sparse warnings and one error:

$ make C=1 M=drivers/s390/scsi
...
  CHECK   drivers/s390/scsi/zfcp_dbf.c
drivers/s390/scsi/zfcp_dbf.c:463:22: warning: restricted __be16 degrades to integer
drivers/s390/scsi/zfcp_dbf.c:476:28: warning: restricted __be16 degrades to integer
  CC      drivers/s390/scsi/zfcp_dbf.o
...
  CHECK   drivers/s390/scsi/zfcp_fc.c
drivers/s390/scsi/zfcp_fc.c:263:26: warning: restricted __be16 degrades to integer
drivers/s390/scsi/zfcp_fc.c:299:41: warning: incorrect type in argument 2 (different base types)
drivers/s390/scsi/zfcp_fc.c:299:41:    expected unsigned long long [unsigned] [usertype] wwpn
drivers/s390/scsi/zfcp_fc.c:299:41:    got restricted __be64 [usertype] fl_wwpn
drivers/s390/scsi/zfcp_fc.c:309:40: warning: incorrect type in argument 2 (different base types)
drivers/s390/scsi/zfcp_fc.c:309:40:    expected unsigned long long [unsigned] [usertype] wwpn
drivers/s390/scsi/zfcp_fc.c:309:40:    got restricted __be64 [usertype] fl_n_port_wwn
drivers/s390/scsi/zfcp_fc.c:338:31: warning: restricted __be16 degrades to integer
drivers/s390/scsi/zfcp_fc.c:355:24: warning: incorrect type in assignment (different base types)
drivers/s390/scsi/zfcp_fc.c:355:24:    expected restricted __be16 [usertype] ct_cmd
drivers/s390/scsi/zfcp_fc.c:355:24:    got unsigned short [unsigned] [usertype] cmd
drivers/s390/scsi/zfcp_fc.c:356:28: warning: incorrect type in assignment (different base types)
drivers/s390/scsi/zfcp_fc.c:356:28:    expected restricted __be16 [usertype] ct_mr_size
drivers/s390/scsi/zfcp_fc.c:356:28:    got int
drivers/s390/scsi/zfcp_fc.c:379:36: warning: incorrect type in assignment (different base types)
drivers/s390/scsi/zfcp_fc.c:379:36:    expected restricted __be64 [usertype] fn_wwpn
drivers/s390/scsi/zfcp_fc.c:379:36:    got unsigned long long [unsigned] [usertype] wwpn
drivers/s390/scsi/zfcp_fc.c:463:18: warning: restricted __be64 degrades to integer
drivers/s390/scsi/zfcp_fc.c:465:17: warning: cast from restricted __be64
drivers/s390/scsi/zfcp_fc.c:473:20: warning: incorrect type in assignment (different base types)
drivers/s390/scsi/zfcp_fc.c:473:20:    expected unsigned long long [unsigned] [usertype] wwnn
drivers/s390/scsi/zfcp_fc.c:473:20:    got restricted __be64 [usertype] fl_wwnn
drivers/s390/scsi/zfcp_fc.c:474:29: warning: incorrect type in assignment (different base types)
drivers/s390/scsi/zfcp_fc.c:474:29:    expected unsigned int [unsigned] [usertype] maxframe_size
drivers/s390/scsi/zfcp_fc.c:474:29:    got restricted __be16 [usertype] sp_bb_data
drivers/s390/scsi/zfcp_fc.c:476:30: warning: restricted __be16 degrades to integer
drivers/s390/scsi/zfcp_fc.c:478:30: warning: restricted __be16 degrades to integer
drivers/s390/scsi/zfcp_fc.c:480:30: warning: restricted __be16 degrades to integer
drivers/s390/scsi/zfcp_fc.c:482:30: warning: restricted __be16 degrades to integer
drivers/s390/scsi/zfcp_fc.c:500:28: warning: incorrect type in assignment (different base types)
drivers/s390/scsi/zfcp_fc.c:500:28:    expected unsigned long long [unsigned] [usertype] wwnn
drivers/s390/scsi/zfcp_fc.c:500:28:    got restricted __be64 [usertype] adisc_wwnn
drivers/s390/scsi/zfcp_fc.c:502:38: warning: restricted __be64 degrades to integer
drivers/s390/scsi/zfcp_fc.c:541:40: warning: incorrect type in assignment (different base types)
drivers/s390/scsi/zfcp_fc.c:541:40:    expected restricted __be64 [usertype] adisc_wwpn
drivers/s390/scsi/zfcp_fc.c:541:40:    got unsigned long long [unsigned] [usertype] port_name
drivers/s390/scsi/zfcp_fc.c:542:40: warning: incorrect type in assignment (different base types)
drivers/s390/scsi/zfcp_fc.c:542:40:    expected restricted __be64 [usertype] adisc_wwnn
drivers/s390/scsi/zfcp_fc.c:542:40:    got unsigned long long [unsigned] [usertype] node_name
drivers/s390/scsi/zfcp_fc.c:669:16: warning: restricted __be16 degrades to integer
drivers/s390/scsi/zfcp_fc.c:696:24: warning: restricted __be64 degrades to integer
drivers/s390/scsi/zfcp_fc.c:699:54: warning: incorrect type in argument 2 (different base types)
drivers/s390/scsi/zfcp_fc.c:699:54:    expected unsigned long long [unsigned] [usertype] <noident>
drivers/s390/scsi/zfcp_fc.c:699:54:    got restricted __be64 [usertype] fp_wwpn
  CC      drivers/s390/scsi/zfcp_fc.o
  CHECK   drivers/s390/scsi/zfcp_fsf.c
drivers/s390/scsi/zfcp_fsf.c:479:34: warning: incorrect type in assignment (different base types)
drivers/s390/scsi/zfcp_fsf.c:479:34:    expected unsigned long long [unsigned] [usertype] port_name
drivers/s390/scsi/zfcp_fsf.c:479:34:    got restricted __be64 [usertype] fl_wwpn
drivers/s390/scsi/zfcp_fsf.c:480:34: warning: incorrect type in assignment (different base types)
drivers/s390/scsi/zfcp_fsf.c:480:34:    expected unsigned long long [unsigned] [usertype] node_name
drivers/s390/scsi/zfcp_fsf.c:480:34:    got restricted __be64 [usertype] fl_wwnn
drivers/s390/scsi/zfcp_fsf.c:506:36: warning: incorrect type in assignment (different base types)
drivers/s390/scsi/zfcp_fsf.c:506:36:    expected unsigned long long [unsigned] [usertype] peer_wwpn
drivers/s390/scsi/zfcp_fsf.c:506:36:    got restricted __be64 [usertype] fl_wwpn
drivers/s390/scsi/zfcp_fsf.c:507:36: warning: incorrect type in assignment (different base types)
drivers/s390/scsi/zfcp_fsf.c:507:36:    expected unsigned long long [unsigned] [usertype] peer_wwnn
drivers/s390/scsi/zfcp_fsf.c:507:36:    got restricted __be64 [usertype] fl_wwnn
drivers/s390/scsi/zfcp_fc.h:269:46: warning: restricted __be32 degrades to integer
drivers/s390/scsi/zfcp_fc.h:270:29: error: incompatible types in comparison expression (different base types)

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |  5 +++--
 drivers/s390/scsi/zfcp_fc.c  | 46 +++++++++++++++++++++++---------------------
 drivers/s390/scsi/zfcp_fc.h  | 19 +++++++++++-------
 drivers/s390/scsi/zfcp_fsf.c |  8 ++++----
 4 files changed, 43 insertions(+), 35 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 225e60d5d3fc..484da0b2d678 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -461,7 +461,7 @@ static u16 zfcp_dbf_san_res_cap_len_if_gpn_ft(char *tag,
 	      && reqh->ct_fs_subtype == FC_NS_SUBTYPE
 	      && reqh->ct_options == 0
 	      && reqh->_ct_resvd1 == 0
-	      && reqh->ct_cmd == FC_NS_GPN_FT
+	      && reqh->ct_cmd == cpu_to_be16(FC_NS_GPN_FT)
 	      /* reqh->ct_mr_size can vary so do not match but read below */
 	      && reqh->_ct_resvd2 == 0
 	      && reqh->ct_reason == 0
@@ -481,7 +481,8 @@ static u16 zfcp_dbf_san_res_cap_len_if_gpn_ft(char *tag,
 	    (resph->ct_cmd != cpu_to_be16(FC_FS_ACC)))
 		return max(FC_CT_HDR_LEN, ZFCP_DBF_SAN_MAX_PAYLOAD);
 
-	max_entries = (reqh->ct_mr_size * 4 / sizeof(struct fc_gpn_ft_resp))
+	max_entries = (be16_to_cpu(reqh->ct_mr_size) * 4 /
+		       sizeof(struct fc_gpn_ft_resp))
 		+ 1 /* zfcp_fc_scan_ports: bytes correct, entries off-by-one
 		     * to account for header as 1st pseudo "entry" */;
 
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index cc3f378782b2..3e715597b739 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -260,7 +260,8 @@ static void zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req)
 	page = (struct fc_els_rscn_page *) head;
 
 	/* see FC-FS */
-	no_entries = head->rscn_plen / sizeof(struct fc_els_rscn_page);
+	no_entries = be16_to_cpu(head->rscn_plen) /
+		sizeof(struct fc_els_rscn_page);
 
 	for (i = 1; i < no_entries; i++) {
 		/* skip head and start with 1st element */
@@ -296,7 +297,7 @@ static void zfcp_fc_incoming_plogi(struct zfcp_fsf_req *req)
 
 	status_buffer = (struct fsf_status_read_buffer *) req->data;
 	plogi = (struct fc_els_flogi *) status_buffer->payload.data;
-	zfcp_fc_incoming_wwpn(req, plogi->fl_wwpn);
+	zfcp_fc_incoming_wwpn(req, be64_to_cpu(plogi->fl_wwpn));
 }
 
 static void zfcp_fc_incoming_logo(struct zfcp_fsf_req *req)
@@ -306,7 +307,7 @@ static void zfcp_fc_incoming_logo(struct zfcp_fsf_req *req)
 	struct fc_els_logo *logo =
 		(struct fc_els_logo *) status_buffer->payload.data;
 
-	zfcp_fc_incoming_wwpn(req, logo->fl_n_port_wwn);
+	zfcp_fc_incoming_wwpn(req, be64_to_cpu(logo->fl_n_port_wwn));
 }
 
 /**
@@ -335,7 +336,7 @@ static void zfcp_fc_ns_gid_pn_eval(struct zfcp_fc_req *fc_req)
 
 	if (ct_els->status)
 		return;
-	if (gid_pn_rsp->ct_hdr.ct_cmd != FC_FS_ACC)
+	if (gid_pn_rsp->ct_hdr.ct_cmd != cpu_to_be16(FC_FS_ACC))
 		return;
 
 	/* looks like a valid d_id */
@@ -352,8 +353,8 @@ static void zfcp_fc_ct_ns_init(struct fc_ct_hdr *ct_hdr, u16 cmd, u16 mr_size)
 	ct_hdr->ct_rev = FC_CT_REV;
 	ct_hdr->ct_fs_type = FC_FST_DIR;
 	ct_hdr->ct_fs_subtype = FC_NS_SUBTYPE;
-	ct_hdr->ct_cmd = cmd;
-	ct_hdr->ct_mr_size = mr_size / 4;
+	ct_hdr->ct_cmd = cpu_to_be16(cmd);
+	ct_hdr->ct_mr_size = cpu_to_be16(mr_size / 4);
 }
 
 static int zfcp_fc_ns_gid_pn_request(struct zfcp_port *port,
@@ -376,7 +377,7 @@ static int zfcp_fc_ns_gid_pn_request(struct zfcp_port *port,
 
 	zfcp_fc_ct_ns_init(&gid_pn_req->ct_hdr,
 			   FC_NS_GID_PN, ZFCP_FC_CT_SIZE_PAGE);
-	gid_pn_req->gid_pn.fn_wwpn = port->wwpn;
+	gid_pn_req->gid_pn.fn_wwpn = cpu_to_be64(port->wwpn);
 
 	ret = zfcp_fsf_send_ct(&adapter->gs->ds, &fc_req->ct_els,
 			       adapter->pool.gid_pn_req,
@@ -460,26 +461,26 @@ void zfcp_fc_trigger_did_lookup(struct zfcp_port *port)
  */
 void zfcp_fc_plogi_evaluate(struct zfcp_port *port, struct fc_els_flogi *plogi)
 {
-	if (plogi->fl_wwpn != port->wwpn) {
+	if (be64_to_cpu(plogi->fl_wwpn) != port->wwpn) {
 		port->d_id = 0;
 		dev_warn(&port->adapter->ccw_device->dev,
 			 "A port opened with WWPN 0x%016Lx returned data that "
 			 "identifies it as WWPN 0x%016Lx\n",
 			 (unsigned long long) port->wwpn,
-			 (unsigned long long) plogi->fl_wwpn);
+			 (unsigned long long) be64_to_cpu(plogi->fl_wwpn));
 		return;
 	}
 
-	port->wwnn = plogi->fl_wwnn;
-	port->maxframe_size = plogi->fl_csp.sp_bb_data;
+	port->wwnn = be64_to_cpu(plogi->fl_wwnn);
+	port->maxframe_size = be16_to_cpu(plogi->fl_csp.sp_bb_data);
 
-	if (plogi->fl_cssp[0].cp_class & FC_CPC_VALID)
+	if (plogi->fl_cssp[0].cp_class & cpu_to_be16(FC_CPC_VALID))
 		port->supported_classes |= FC_COS_CLASS1;
-	if (plogi->fl_cssp[1].cp_class & FC_CPC_VALID)
+	if (plogi->fl_cssp[1].cp_class & cpu_to_be16(FC_CPC_VALID))
 		port->supported_classes |= FC_COS_CLASS2;
-	if (plogi->fl_cssp[2].cp_class & FC_CPC_VALID)
+	if (plogi->fl_cssp[2].cp_class & cpu_to_be16(FC_CPC_VALID))
 		port->supported_classes |= FC_COS_CLASS3;
-	if (plogi->fl_cssp[3].cp_class & FC_CPC_VALID)
+	if (plogi->fl_cssp[3].cp_class & cpu_to_be16(FC_CPC_VALID))
 		port->supported_classes |= FC_COS_CLASS4;
 }
 
@@ -497,9 +498,9 @@ static void zfcp_fc_adisc_handler(void *data)
 	}
 
 	if (!port->wwnn)
-		port->wwnn = adisc_resp->adisc_wwnn;
+		port->wwnn = be64_to_cpu(adisc_resp->adisc_wwnn);
 
-	if ((port->wwpn != adisc_resp->adisc_wwpn) ||
+	if ((port->wwpn != be64_to_cpu(adisc_resp->adisc_wwpn)) ||
 	    !(atomic_read(&port->status) & ZFCP_STATUS_COMMON_OPEN)) {
 		zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED,
 				     "fcadh_2");
@@ -538,8 +539,8 @@ static int zfcp_fc_adisc(struct zfcp_port *port)
 
 	/* acc. to FC-FS, hard_nport_id in ADISC should not be set for ports
 	   without FC-AL-2 capability, so we don't set it */
-	fc_req->u.adisc.req.adisc_wwpn = fc_host_port_name(shost);
-	fc_req->u.adisc.req.adisc_wwnn = fc_host_node_name(shost);
+	fc_req->u.adisc.req.adisc_wwpn = cpu_to_be64(fc_host_port_name(shost));
+	fc_req->u.adisc.req.adisc_wwnn = cpu_to_be64(fc_host_node_name(shost));
 	fc_req->u.adisc.req.adisc_cmd = ELS_ADISC;
 	hton24(fc_req->u.adisc.req.adisc_port_id, fc_host_port_id(shost));
 
@@ -666,7 +667,7 @@ static int zfcp_fc_eval_gpn_ft(struct zfcp_fc_req *fc_req,
 	if (ct_els->status)
 		return -EIO;
 
-	if (hdr->ct_cmd != FC_FS_ACC) {
+	if (hdr->ct_cmd != cpu_to_be16(FC_FS_ACC)) {
 		if (hdr->ct_reason == FC_FS_RJT_UNABL)
 			return -EAGAIN; /* might be a temporary condition */
 		return -EIO;
@@ -693,10 +694,11 @@ static int zfcp_fc_eval_gpn_ft(struct zfcp_fc_req *fc_req,
 		if (d_id >= FC_FID_WELL_KNOWN_BASE)
 			continue;
 		/* skip the adapter's port and known remote ports */
-		if (acc->fp_wwpn == fc_host_port_name(adapter->scsi_host))
+		if (be64_to_cpu(acc->fp_wwpn) ==
+		    fc_host_port_name(adapter->scsi_host))
 			continue;
 
-		port = zfcp_port_enqueue(adapter, acc->fp_wwpn,
+		port = zfcp_port_enqueue(adapter, be64_to_cpu(acc->fp_wwpn),
 					 ZFCP_STATUS_COMMON_NOESC, d_id);
 		if (!IS_ERR(port))
 			zfcp_erp_port_reopen(port, 0, "fcegpf1");
diff --git a/drivers/s390/scsi/zfcp_fc.h b/drivers/s390/scsi/zfcp_fc.h
index a2275825186f..41f22d3dc6d1 100644
--- a/drivers/s390/scsi/zfcp_fc.h
+++ b/drivers/s390/scsi/zfcp_fc.h
@@ -212,6 +212,8 @@ static inline
 void zfcp_fc_scsi_to_fcp(struct fcp_cmnd *fcp, struct scsi_cmnd *scsi,
 			 u8 tm_flags)
 {
+	u32 datalen;
+
 	int_to_scsilun(scsi->device->lun, (struct scsi_lun *) &fcp->fc_lun);
 
 	if (unlikely(tm_flags)) {
@@ -228,10 +230,13 @@ void zfcp_fc_scsi_to_fcp(struct fcp_cmnd *fcp, struct scsi_cmnd *scsi,
 
 	memcpy(fcp->fc_cdb, scsi->cmnd, scsi->cmd_len);
 
-	fcp->fc_dl = scsi_bufflen(scsi);
+	datalen = scsi_bufflen(scsi);
+	fcp->fc_dl = cpu_to_be32(datalen);
 
-	if (scsi_get_prot_type(scsi) == SCSI_PROT_DIF_TYPE1)
-		fcp->fc_dl += fcp->fc_dl / scsi->device->sector_size * 8;
+	if (scsi_get_prot_type(scsi) == SCSI_PROT_DIF_TYPE1) {
+		datalen += datalen / scsi->device->sector_size * 8;
+		fcp->fc_dl = cpu_to_be32(datalen);
+	}
 }
 
 /**
@@ -266,14 +271,14 @@ void zfcp_fc_eval_fcp_rsp(struct fcp_resp_with_ext *fcp_rsp,
 	if (unlikely(rsp_flags & FCP_SNS_LEN_VAL)) {
 		sense = (char *) &fcp_rsp[1];
 		if (rsp_flags & FCP_RSP_LEN_VAL)
-			sense += fcp_rsp->ext.fr_rsp_len;
-		sense_len = min(fcp_rsp->ext.fr_sns_len,
-				(u32) SCSI_SENSE_BUFFERSIZE);
+			sense += be32_to_cpu(fcp_rsp->ext.fr_rsp_len);
+		sense_len = min_t(u32, be32_to_cpu(fcp_rsp->ext.fr_sns_len),
+				  SCSI_SENSE_BUFFERSIZE);
 		memcpy(scsi->sense_buffer, sense, sense_len);
 	}
 
 	if (unlikely(rsp_flags & FCP_RESID_UNDER)) {
-		resid = fcp_rsp->ext.fr_resid;
+		resid = be32_to_cpu(fcp_rsp->ext.fr_resid);
 		scsi_set_resid(scsi, resid);
 		if (scsi_bufflen(scsi) - resid < scsi->underflow &&
 		     !(rsp_flags & FCP_SNS_LEN_VAL) &&
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 6ddaee5f3701..cc923c71a0fa 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -476,8 +476,8 @@ static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 	if (req->data)
 		memcpy(req->data, bottom, sizeof(*bottom));
 
-	fc_host_port_name(shost) = nsp->fl_wwpn;
-	fc_host_node_name(shost) = nsp->fl_wwnn;
+	fc_host_port_name(shost) = be64_to_cpu(nsp->fl_wwpn);
+	fc_host_node_name(shost) = be64_to_cpu(nsp->fl_wwnn);
 	fc_host_supported_classes(shost) = FC_COS_CLASS2 | FC_COS_CLASS3;
 
 	adapter->timer_ticks = bottom->timer_interval & ZFCP_FSF_TIMER_INT_MASK;
@@ -503,8 +503,8 @@ static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 	switch (bottom->fc_topology) {
 	case FSF_TOPO_P2P:
 		adapter->peer_d_id = ntoh24(bottom->peer_d_id);
-		adapter->peer_wwpn = plogi->fl_wwpn;
-		adapter->peer_wwnn = plogi->fl_wwnn;
+		adapter->peer_wwpn = be64_to_cpu(plogi->fl_wwpn);
+		adapter->peer_wwnn = be64_to_cpu(plogi->fl_wwnn);
 		fc_host_port_type(shost) = FC_PORTTYPE_PTP;
 		break;
 	case FSF_TOPO_FABRIC:
-- 
2.11.2
