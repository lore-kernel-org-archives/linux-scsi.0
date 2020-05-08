Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E70AC38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76DA1218AC
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgEHRXs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 13:23:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48972 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726843AbgEHRXr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 13:23:47 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 048H31rc115308;
        Fri, 8 May 2020 13:23:44 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30wa86tsk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 13:23:44 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 048H4rEC032591;
        Fri, 8 May 2020 17:23:42 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 30s0g5wt5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 17:23:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 048HNd2C56295664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 May 2020 17:23:39 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 492505204F;
        Fri,  8 May 2020 17:23:39 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.54.185])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 33E6E5204E;
        Fri,  8 May 2020 17:23:39 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92.3)
        (envelope-from <bblock@linux.ibm.com>)
        id 1jX6io-002wrU-DP; Fri, 08 May 2020 19:23:38 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 2/8] zfcp: move shost updates during xconfig data handling into fenced function
Date:   Fri,  8 May 2020 19:23:29 +0200
Message-Id: <5fc3f4d38d4334f7aa595497c6f7865fb1102e0f.1588956679.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588956679.git.bblock@linux.ibm.com>
References: <cover.1588956679.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_15:2020-05-08,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 priorityscore=1501 suspectscore=2 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080144
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When executing exchange config data for a FCP device for the first time,
or after an adapter recovery, we update several properties of the scsi
host or fibre channel host object that represent that FCP device.

When moving the scsi host object allocation and registration - and thus
also the fibre channel host object allocation - to after the first
exchange config and exchange port data, this is not possible for the
former case.

Move all these update into separate, and fenced function that first
checks whether the scsi host object already exists or not, before making
the updates.

During the first ever exchange config data in the adapter life cycle
this will make the exchange config data handler skip over this update
step, but we can repeat it later, after we allocated the scsi host
object.

For any further recovery of that adapter the work flow is only changed
slightly because then the scsi host object already exists and we don't
free it until we release the adapter completely at the end of its life
cycle.

Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_ext.h  |  5 +++
 drivers/s390/scsi/zfcp_fsf.c  | 48 +++--------------------
 drivers/s390/scsi/zfcp_scsi.c | 72 ++++++++++++++++++++++++++++++++++-
 3 files changed, 82 insertions(+), 43 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index d67f31b9b859..4c4be754cf6e 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -125,6 +125,7 @@ extern int zfcp_fsf_exchange_config_data_sync(struct zfcp_qdio *,
 extern int zfcp_fsf_exchange_port_data(struct zfcp_erp_action *);
 extern int zfcp_fsf_exchange_port_data_sync(struct zfcp_qdio *,
 					    struct fsf_qtcb_bottom_port *);
+extern u32 zfcp_fsf_convert_portspeed(u32 fsf_speed);
 extern void zfcp_fsf_req_dismiss_all(struct zfcp_adapter *);
 extern int zfcp_fsf_status_read(struct zfcp_qdio *);
 extern int zfcp_status_read_refill(struct zfcp_adapter *adapter);
@@ -171,6 +172,10 @@ extern void zfcp_scsi_schedule_rport_block(struct zfcp_port *);
 extern void zfcp_scsi_schedule_rports_block(struct zfcp_adapter *);
 extern void zfcp_scsi_set_prot(struct zfcp_adapter *);
 extern void zfcp_scsi_dif_sense_error(struct scsi_cmnd *, int);
+extern void zfcp_scsi_shost_update_config_data(
+	struct zfcp_adapter *const adapter,
+	const struct fsf_qtcb_bottom_config *const bottom,
+	const bool bottom_incomplete);
 
 /* zfcp_sysfs.c */
 extern const struct attribute_group *zfcp_unit_attr_groups[];
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 111fe3fc32d7..54edfcbe84ce 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -479,7 +479,7 @@ void zfcp_fsf_req_dismiss_all(struct zfcp_adapter *adapter)
 #define ZFCP_FSF_PORTSPEED_128GBIT	(1 <<  8)
 #define ZFCP_FSF_PORTSPEED_NOT_NEGOTIATED (1 << 15)
 
-static u32 zfcp_fsf_convert_portspeed(u32 fsf_speed)
+u32 zfcp_fsf_convert_portspeed(u32 fsf_speed)
 {
 	u32 fdmi_speed = 0;
 	if (fsf_speed & ZFCP_FSF_PORTSPEED_1GBIT)
@@ -509,64 +509,36 @@ static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 {
 	struct fsf_qtcb_bottom_config *bottom = &req->qtcb->bottom.config;
 	struct zfcp_adapter *adapter = req->adapter;
-	struct Scsi_Host *shost = adapter->scsi_host;
-	struct fc_els_flogi *nsp, *plogi;
+	struct fc_els_flogi *plogi;
 
 	/* adjust pointers for missing command code */
-	nsp = (struct fc_els_flogi *) ((u8 *)&bottom->nport_serv_param
-					- sizeof(u32));
 	plogi = (struct fc_els_flogi *) ((u8 *)&bottom->plogi_payload
 					- sizeof(u32));
 
 	if (req->data)
 		memcpy(req->data, bottom, sizeof(*bottom));
 
-	snprintf(fc_host_manufacturer(shost), FC_SERIAL_NUMBER_SIZE, "%s",
-		 "IBM");
-	fc_host_port_name(shost) = be64_to_cpu(nsp->fl_wwpn);
-	fc_host_node_name(shost) = be64_to_cpu(nsp->fl_wwnn);
-	fc_host_supported_classes(shost) = FC_COS_CLASS2 | FC_COS_CLASS3;
-
 	adapter->timer_ticks = bottom->timer_interval & ZFCP_FSF_TIMER_INT_MASK;
 	adapter->stat_read_buf_num = max(bottom->status_read_buf_num,
 					 (u16)FSF_STATUS_READS_RECOM);
 
-	zfcp_scsi_set_prot(adapter);
-
 	/* no error return above here, otherwise must fix call chains */
 	/* do not evaluate invalid fields */
 	if (req->qtcb->header.fsf_status == FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE)
 		return 0;
 
-	fc_host_port_id(shost) = ntoh24(bottom->s_id);
-	fc_host_speed(shost) =
-		zfcp_fsf_convert_portspeed(bottom->fc_link_speed);
-
 	adapter->hydra_version = bottom->adapter_type;
-	snprintf(fc_host_model(shost), FC_SYMBOLIC_NAME_SIZE, "0x%04x",
-		 bottom->adapter_type);
 
 	switch (bottom->fc_topology) {
 	case FSF_TOPO_P2P:
 		adapter->peer_d_id = ntoh24(bottom->peer_d_id);
 		adapter->peer_wwpn = be64_to_cpu(plogi->fl_wwpn);
 		adapter->peer_wwnn = be64_to_cpu(plogi->fl_wwnn);
-		fc_host_port_type(shost) = FC_PORTTYPE_PTP;
-		fc_host_fabric_name(shost) = 0;
 		break;
 	case FSF_TOPO_FABRIC:
-		fc_host_fabric_name(shost) = be64_to_cpu(plogi->fl_wwnn);
-		if (bottom->connection_features & FSF_FEATURE_NPIV_MODE)
-			fc_host_port_type(shost) = FC_PORTTYPE_NPIV;
-		else
-			fc_host_port_type(shost) = FC_PORTTYPE_NPORT;
 		break;
 	case FSF_TOPO_AL:
-		fc_host_port_type(shost) = FC_PORTTYPE_NLPORT;
-		fc_host_fabric_name(shost) = 0;
-		fallthrough;
 	default:
-		fc_host_fabric_name(shost) = 0;
 		dev_err(&adapter->ccw_device->dev,
 			"Unknown or unsupported arbitrated loop "
 			"fibre channel topology detected\n");
@@ -584,13 +556,10 @@ static void zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *req)
 		&adapter->diagnostics->config_data.header;
 	struct fsf_qtcb *qtcb = req->qtcb;
 	struct fsf_qtcb_bottom_config *bottom = &qtcb->bottom.config;
-	struct Scsi_Host *shost = adapter->scsi_host;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		return;
 
-	snprintf(fc_host_firmware_version(shost), FC_VERSION_STRING_SIZE,
-		 "0x%08x", bottom->lic_version);
 	adapter->fsf_lic_version = bottom->lic_version;
 	adapter->adapter_features = bottom->adapter_features;
 	adapter->connection_features = bottom->connection_features;
@@ -606,6 +575,7 @@ static void zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *req)
 		 */
 		zfcp_diag_update_xdata(diag_hdr, bottom, false);
 
+		zfcp_scsi_shost_update_config_data(adapter, bottom, false);
 		if (zfcp_fsf_exchange_config_evaluate(req))
 			return;
 
@@ -630,6 +600,8 @@ static void zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *req)
 				&adapter->status);
 		zfcp_fsf_link_down_info_eval(req,
 			&qtcb->header.fsf_status_qual.link_down_info);
+
+		zfcp_scsi_shost_update_config_data(adapter, bottom, true);
 		if (zfcp_fsf_exchange_config_evaluate(req))
 			return;
 		break;
@@ -638,16 +610,8 @@ static void zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *req)
 		return;
 	}
 
-	if (adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT) {
+	if (adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT)
 		adapter->hardware_version = bottom->hardware_version;
-		snprintf(fc_host_hardware_version(shost),
-			 FC_VERSION_STRING_SIZE,
-			 "0x%08x", bottom->hardware_version);
-		memcpy(fc_host_serial_number(shost), bottom->serial_number,
-		       min(FC_SERIAL_NUMBER_SIZE, 17));
-		EBCASC(fc_host_serial_number(shost),
-		       min(FC_SERIAL_NUMBER_SIZE, 17));
-	}
 
 	if (FSF_QTCB_CURRENT_VERSION < bottom->low_qtcb_version) {
 		dev_err(&adapter->ccw_device->dev,
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 13d873f806e4..e1281a1ce488 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -4,7 +4,7 @@
  *
  * Interface to Linux SCSI midlayer.
  *
- * Copyright IBM Corp. 2002, 2018
+ * Copyright IBM Corp. 2002, 2020
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -841,6 +841,76 @@ void zfcp_scsi_dif_sense_error(struct scsi_cmnd *scmd, int ascq)
 	set_host_byte(scmd, DID_SOFT_ERROR);
 }
 
+void zfcp_scsi_shost_update_config_data(
+	struct zfcp_adapter *const adapter,
+	const struct fsf_qtcb_bottom_config *const bottom,
+	const bool bottom_incomplete)
+{
+	struct Scsi_Host *const shost = adapter->scsi_host;
+	const struct fc_els_flogi *nsp, *plogi;
+
+	if (shost == NULL)
+		return;
+
+	snprintf(fc_host_firmware_version(shost), FC_VERSION_STRING_SIZE,
+		 "0x%08x", bottom->lic_version);
+
+	if (adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT) {
+		snprintf(fc_host_hardware_version(shost),
+			 FC_VERSION_STRING_SIZE,
+			 "0x%08x", bottom->hardware_version);
+		memcpy(fc_host_serial_number(shost), bottom->serial_number,
+		       min(FC_SERIAL_NUMBER_SIZE, 17));
+		EBCASC(fc_host_serial_number(shost),
+		       min(FC_SERIAL_NUMBER_SIZE, 17));
+	}
+
+	/* adjust pointers for missing command code */
+	nsp = (struct fc_els_flogi *) ((u8 *)&bottom->nport_serv_param
+					- sizeof(u32));
+	plogi = (struct fc_els_flogi *) ((u8 *)&bottom->plogi_payload
+					- sizeof(u32));
+
+	snprintf(fc_host_manufacturer(shost), FC_SERIAL_NUMBER_SIZE, "%s",
+		 "IBM");
+	fc_host_port_name(shost) = be64_to_cpu(nsp->fl_wwpn);
+	fc_host_node_name(shost) = be64_to_cpu(nsp->fl_wwnn);
+	fc_host_supported_classes(shost) = FC_COS_CLASS2 | FC_COS_CLASS3;
+
+	zfcp_scsi_set_prot(adapter);
+
+	/* do not evaluate invalid fields */
+	if (bottom_incomplete)
+		return;
+
+	fc_host_port_id(shost) = ntoh24(bottom->s_id);
+	fc_host_speed(shost) =
+		zfcp_fsf_convert_portspeed(bottom->fc_link_speed);
+
+	snprintf(fc_host_model(shost), FC_SYMBOLIC_NAME_SIZE, "0x%04x",
+		 bottom->adapter_type);
+
+	switch (bottom->fc_topology) {
+	case FSF_TOPO_P2P:
+		fc_host_port_type(shost) = FC_PORTTYPE_PTP;
+		fc_host_fabric_name(shost) = 0;
+		break;
+	case FSF_TOPO_FABRIC:
+		fc_host_fabric_name(shost) = be64_to_cpu(plogi->fl_wwnn);
+		if (bottom->connection_features & FSF_FEATURE_NPIV_MODE)
+			fc_host_port_type(shost) = FC_PORTTYPE_NPIV;
+		else
+			fc_host_port_type(shost) = FC_PORTTYPE_NPORT;
+		break;
+	case FSF_TOPO_AL:
+		fc_host_port_type(shost) = FC_PORTTYPE_NLPORT;
+		fallthrough;
+	default:
+		fc_host_fabric_name(shost) = 0;
+		break;
+	}
+}
+
 struct fc_function_template zfcp_transport_functions = {
 	.show_starget_port_id = 1,
 	.show_starget_port_name = 1,
-- 
2.17.1

