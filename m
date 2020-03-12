Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36EBBC10DCE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 17:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 042C3206B1
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 17:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgCLRpj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 13:45:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24266 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726426AbgCLRpj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Mar 2020 13:45:39 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02CHYPGR067022
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 13:45:38 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yqskk8j8w-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 13:45:37 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.ibm.com>;
        Thu, 12 Mar 2020 17:45:33 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Mar 2020 17:45:32 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02CHjVI858130522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 17:45:31 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F00A652059;
        Thu, 12 Mar 2020 17:45:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A80635204E;
        Thu, 12 Mar 2020 17:45:30 +0000 (GMT)
From:   Steffen Maier <maier@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Jens Remus <jremus@linux.ibm.com>
Subject: [PATCH 08/10] zfcp: trace FC Endpoint Security of FCP devices and connections
Date:   Thu, 12 Mar 2020 18:45:03 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200312174505.51294-1-maier@linux.ibm.com>
References: <20200312174505.51294-1-maier@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20031217-0016-0000-0000-000002F00E90
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031217-0017-0000-0000-000033537E0E
Message-Id: <20200312174505.51294-9-maier@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-12_11:2020-03-11,2020-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 spamscore=0 impostorscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 adultscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120089
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jens Remus <jremus@linux.ibm.com>

Trace changes in Fibre Channel Endpoint Security capabilities of FCP
devices as well as changes in Fibre Channel Endpoint Security state of
their connections to FC remote ports as FC Endpoint Security changes
with trace level 3 in HBA DBF.

A change in FC Endpoint Security capabilities of FCP devices is traced
as response to FSF command FSF_QTCB_EXCHANGE_PORT_DATA with a trace tag
of "fsfcesa" and a WWPN of ZFCP_DBF_INVALID_WWPN = 0x0000000000000000
(see FC-FS-4 §18 "Name_Identifier Formats", NAA field).

A change in FC Endpoint Security state of connections between FCP
devices and FC remote ports is traced as response to FSF command
FSF_QTCB_OPEN_PORT_WITH_DID with a trace tag of "fsfcesp".

Example trace record of FC Endpoint Security capability change of
FCP device formatted with zfcpdbf from s390-tools:

Timestamp      : ...
Area           : HBA
Subarea        : 00
Level          : 3
Exception      : -
CPU ID         : ...
Caller         : 0x...
Record ID      : 5                    ZFCP_DBF_HBA_FCES
Tag            : fsfcesa              FSF FC Endpoint Security adapter
Request ID     : 0x...
Request status : 0x00000010
FSF cmnd       : 0x0000000e           FSF_QTCB_EXCHANGE_PORT_DATA
FSF sequence no: 0x...
FSF issued     : ...
FSF stat       : 0x00000000           FSF_GOOD
FSF stat qual  : n/a
Prot stat      : n/a
Prot stat qual : n/a
Port handle    : 0x00000000           none (invalid)
LUN handle     : n/a
WWPN           : 0x0000000000000000   ZFCP_DBF_INVALID_WWPN
FCES old       : 0x00000000           old FC Endpoint Security
FCES new       : 0x00000007           new FC Endpoint Security

Example trace record of FC Endpoint Security change of connection to
FC remote port formatted with zfcpdbf from s390-tools:

Timestamp      : ...
Area           : HBA
Subarea        : 00
Level          : 3
Exception      : -
CPU ID         : ...
Caller         : 0x...
Record ID      : 5                    ZFCP_DBF_HBA_FCES
Tag            : fsfcesp              FSF FC Endpoint Security port
Request ID     : 0x...
Request status : 0x00000010
FSF cmnd       : 0x00000005           FSF_QTCB_OPEN_PORT_WITH_DID
FSF sequence no: 0x...
FSF issued     : ...
FSF stat       : 0x00000000           FSF_GOOD
FSF stat qual  : n/a
Prot stat      : n/a
Prot stat qual : n/a
Port handle    : 0x...
WWPN           : 0x500507630401120c   WWPN
FCES old       : 0x00000000           old FC Endpoint Security
FCES new       : 0x00000004           new FC Endpoint Security

Signed-off-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c | 44 +++++++++++++++++++++++++++++++++++-
 drivers/s390/scsi/zfcp_dbf.h | 32 ++++++++++++++++++++++----
 drivers/s390/scsi/zfcp_def.h |  1 +
 drivers/s390/scsi/zfcp_ext.h |  3 +++
 drivers/s390/scsi/zfcp_fsf.c | 28 ++++++++++++++++++++---
 5 files changed, 100 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 1234294700c4..673e42defb91 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -4,7 +4,7 @@
  *
  * Debug traces for zfcp.
  *
- * Copyright IBM Corp. 2002, 2018
+ * Copyright IBM Corp. 2002, 2020
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -103,6 +103,48 @@ void zfcp_dbf_hba_fsf_res(char *tag, int level, struct zfcp_fsf_req *req)
 	spin_unlock_irqrestore(&dbf->hba_lock, flags);
 }
 
+/**
+ * zfcp_dbf_hba_fsf_fces - trace event for fsf responses related to
+ *			   FC Endpoint Security (FCES)
+ * @tag: tag indicating which kind of FC Endpoint Security event has occurred
+ * @req: request for which a response was received
+ * @wwpn: remote port or ZFCP_DBF_INVALID_WWPN
+ * @fc_security_old: old FC Endpoint Security of FCP device or connection
+ * @fc_security_new: new FC Endpoint Security of FCP device or connection
+ */
+void zfcp_dbf_hba_fsf_fces(char *tag, const struct zfcp_fsf_req *req, u64 wwpn,
+			   u32 fc_security_old, u32 fc_security_new)
+{
+	struct zfcp_dbf *dbf = req->adapter->dbf;
+	struct fsf_qtcb_prefix *q_pref = &req->qtcb->prefix;
+	struct fsf_qtcb_header *q_head = &req->qtcb->header;
+	struct zfcp_dbf_hba *rec = &dbf->hba_buf;
+	static int const level = 3;
+	unsigned long flags;
+
+	if (unlikely(!debug_level_enabled(dbf->hba, level)))
+		return;
+
+	spin_lock_irqsave(&dbf->hba_lock, flags);
+	memset(rec, 0, sizeof(*rec));
+
+	memcpy(rec->tag, tag, ZFCP_DBF_TAG_LEN);
+	rec->id = ZFCP_DBF_HBA_FCES;
+	rec->fsf_req_id = req->req_id;
+	rec->fsf_req_status = req->status;
+	rec->fsf_cmd = q_head->fsf_command;
+	rec->fsf_seq_no = q_pref->req_seq_no;
+	rec->u.fces.req_issued = req->issued;
+	rec->u.fces.fsf_status = q_head->fsf_status;
+	rec->u.fces.port_handle = q_head->port_handle;
+	rec->u.fces.wwpn = wwpn;
+	rec->u.fces.fc_security_old = fc_security_old;
+	rec->u.fces.fc_security_new = fc_security_new;
+
+	debug_event(dbf->hba, level, rec, sizeof(*rec));
+	spin_unlock_irqrestore(&dbf->hba_lock, flags);
+}
+
 /**
  * zfcp_dbf_hba_fsf_uss - trace event for an unsolicited status buffer
  * @tag: tag indicating which kind of unsolicited status has been received
diff --git a/drivers/s390/scsi/zfcp_dbf.h b/drivers/s390/scsi/zfcp_dbf.h
index 900c779cc39b..4d1435c573bc 100644
--- a/drivers/s390/scsi/zfcp_dbf.h
+++ b/drivers/s390/scsi/zfcp_dbf.h
@@ -3,7 +3,7 @@
  * zfcp device driver
  * debug feature declarations
  *
- * Copyright IBM Corp. 2008, 2017
+ * Copyright IBM Corp. 2008, 2020
  */
 
 #ifndef ZFCP_DBF_H
@@ -16,6 +16,7 @@
 
 #define ZFCP_DBF_TAG_LEN       7
 
+#define ZFCP_DBF_INVALID_WWPN	0x0000000000000000ull
 #define ZFCP_DBF_INVALID_LUN	0xFFFFFFFFFFFFFFFFull
 
 enum zfcp_dbf_pseudo_erp_act_type {
@@ -157,18 +158,39 @@ struct zfcp_dbf_hba_uss {
 	u64 queue_designator;
 } __packed;
 
+/**
+ * struct zfcp_dbf_hba_fces - trace record for FC Endpoint Security
+ * @req_issued: timestamp when request was issued
+ * @fsf_status: fsf status
+ * @port_handle: handle for port
+ * @wwpn: remote FC port WWPN
+ * @fc_security_old: old FC Endpoint Security
+ * @fc_security_new: new FC Endpoint Security
+ *
+ */
+struct zfcp_dbf_hba_fces {
+	u64 req_issued;
+	u32 fsf_status;
+	u32 port_handle;
+	u64 wwpn;
+	u32 fc_security_old;
+	u32 fc_security_new;
+} __packed;
+
 /**
  * enum zfcp_dbf_hba_id - HBA trace record identifier
  * @ZFCP_DBF_HBA_RES: response trace record
  * @ZFCP_DBF_HBA_USS: unsolicited status trace record
  * @ZFCP_DBF_HBA_BIT: bit error trace record
  * @ZFCP_DBF_HBA_BASIC: basic adapter event, only trace tag, no other data
+ * @ZFCP_DBF_HBA_FCES: FC Endpoint Security trace record
  */
 enum zfcp_dbf_hba_id {
 	ZFCP_DBF_HBA_RES	= 1,
 	ZFCP_DBF_HBA_USS	= 2,
 	ZFCP_DBF_HBA_BIT	= 3,
 	ZFCP_DBF_HBA_BASIC	= 4,
+	ZFCP_DBF_HBA_FCES	= 5,
 };
 
 /**
@@ -181,9 +203,10 @@ enum zfcp_dbf_hba_id {
  * @fsf_seq_no: fsf sequence number
  * @pl_len: length of payload stored as zfcp_dbf_pay
  * @u: record type specific data
- * @u.res: data for fsf responses
- * @u.uss: data for unsolicited status buffer
- * @u.be:  data for bit error unsolicited status buffer
+ * @u.res:  data for fsf responses
+ * @u.uss:  data for unsolicited status buffer
+ * @u.be:   data for bit error unsolicited status buffer
+ * @u.fces: data for FC Endpoint Security
  */
 struct zfcp_dbf_hba {
 	u8 id;
@@ -197,6 +220,7 @@ struct zfcp_dbf_hba {
 		struct zfcp_dbf_hba_res res;
 		struct zfcp_dbf_hba_uss uss;
 		struct fsf_bit_error_payload be;
+		struct zfcp_dbf_hba_fces fces;
 	} u;
 } __packed;
 
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index b6af4a93681c..da8a5ceb615c 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -159,6 +159,7 @@ struct zfcp_adapter {
 	u32			connection_features; /* host connection features */
         u32			hardware_version;  /* of FCP channel */
 	u32			fc_security_algorithms; /* of FCP channel */
+	u32			fc_security_algorithms_old; /* of FCP channel */
 	u16			timer_ticks;       /* time int for a tick */
 	struct Scsi_Host	*scsi_host;	   /* Pointer to mid-layer */
 	struct list_head	port_list;	   /* remote port list */
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index ee82fb540db3..88294ca0e2ea 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -44,6 +44,9 @@ extern void zfcp_dbf_rec_run_lvl(int level, char *tag,
 extern void zfcp_dbf_rec_run_wka(char *, struct zfcp_fc_wka_port *, u64);
 extern void zfcp_dbf_hba_fsf_uss(char *, struct zfcp_fsf_req *);
 extern void zfcp_dbf_hba_fsf_res(char *, int, struct zfcp_fsf_req *);
+extern void zfcp_dbf_hba_fsf_fces(char *tag, const struct zfcp_fsf_req *req,
+				  u64 wwpn, u32 fc_security_old,
+				  u32 fc_security_new);
 extern void zfcp_dbf_hba_bit_err(char *, struct zfcp_fsf_req *);
 extern void zfcp_dbf_hba_def_err(struct zfcp_adapter *, u64, u16, void **);
 extern void zfcp_dbf_hba_basic(char *, struct zfcp_adapter *);
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 08ce0fa04665..1d3eac12a8c6 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -741,6 +741,22 @@ ssize_t zfcp_fsf_scnprint_fc_security(char *buf, size_t size, u32 fc_security,
 	return len;
 }
 
+static void zfcp_fsf_dbf_adapter_fc_security(struct zfcp_adapter *adapter,
+					     struct zfcp_fsf_req *req)
+{
+	if (adapter->fc_security_algorithms ==
+	    adapter->fc_security_algorithms_old) {
+		/* no change, no trace */
+		return;
+	}
+
+	zfcp_dbf_hba_fsf_fces("fsfcesa", req, ZFCP_DBF_INVALID_WWPN,
+			      adapter->fc_security_algorithms_old,
+			      adapter->fc_security_algorithms);
+
+	adapter->fc_security_algorithms_old = adapter->fc_security_algorithms;
+}
+
 static void zfcp_fsf_exchange_port_evaluate(struct zfcp_fsf_req *req)
 {
 	struct zfcp_adapter *adapter = req->adapter;
@@ -763,6 +779,7 @@ static void zfcp_fsf_exchange_port_evaluate(struct zfcp_fsf_req *req)
 			bottom->fc_security_algorithms;
 	else
 		adapter->fc_security_algorithms = 0;
+	zfcp_fsf_dbf_adapter_fc_security(adapter, req);
 }
 
 static void zfcp_fsf_exchange_port_data_handler(struct zfcp_fsf_req *req)
@@ -1579,16 +1596,21 @@ int zfcp_fsf_exchange_port_data_sync(struct zfcp_qdio *qdio,
 	return retval;
 }
 
-static void zfcp_fsf_log_port_fc_security(struct zfcp_port *port)
+static void zfcp_fsf_log_port_fc_security(struct zfcp_port *port,
+					  struct zfcp_fsf_req *req)
 {
 	char mnemonic_old[ZFCP_FSF_MAX_FC_SECURITY_MNEMONIC_LENGTH];
 	char mnemonic_new[ZFCP_FSF_MAX_FC_SECURITY_MNEMONIC_LENGTH];
 
 	if (port->connection_info == port->connection_info_old) {
-		/* no change, no log */
+		/* no change, no log nor trace */
 		return;
 	}
 
+	zfcp_dbf_hba_fsf_fces("fsfcesp", req, port->wwpn,
+			      port->connection_info_old,
+			      port->connection_info);
+
 	zfcp_fsf_scnprint_fc_security(mnemonic_old, sizeof(mnemonic_old),
 				      port->connection_info_old,
 				      ZFCP_FSF_PRINT_FMT_SINGLEITEM);
@@ -1663,7 +1685,7 @@ static void zfcp_fsf_open_port_handler(struct zfcp_fsf_req *req)
 			port->connection_info = bottom->connection_info;
 		else
 			port->connection_info = 0;
-		zfcp_fsf_log_port_fc_security(port);
+		zfcp_fsf_log_port_fc_security(port, req);
 		atomic_or(ZFCP_STATUS_COMMON_OPEN |
 				ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
 		atomic_andnot(ZFCP_STATUS_COMMON_ACCESS_BOXED,
-- 
2.17.1

