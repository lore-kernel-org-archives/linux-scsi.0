Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B39C10DCE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 17:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E07E0206F1
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 17:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgCLRp0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 13:45:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52612 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726328AbgCLRp0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Mar 2020 13:45:26 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02CHhVqt051452
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 13:45:25 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yqsqv0241-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 13:45:24 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.ibm.com>;
        Thu, 12 Mar 2020 17:45:23 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Mar 2020 17:45:21 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02CHjKEP54329542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 17:45:20 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04CFC52050;
        Thu, 12 Mar 2020 17:45:20 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B5AAD5204F;
        Thu, 12 Mar 2020 17:45:19 +0000 (GMT)
From:   Steffen Maier <maier@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH 04/10] zfcp: fix fc_host attributes that should be unknown on local link down
Date:   Thu, 12 Mar 2020 18:44:59 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200312174505.51294-1-maier@linux.ibm.com>
References: <20200312174505.51294-1-maier@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20031217-0028-0000-0000-000003E3C2C4
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031217-0029-0000-0000-000024A90B27
Message-Id: <20200312174505.51294-5-maier@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-12_11:2020-03-11,2020-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 spamscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120090
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When we get an unsolicited notification on local link went down,
zfcp_fsf_status_read_link_down() calls zfcp_fsf_link_down_info_eval().
This only blocks rports, and sets ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED and
ZFCP_STATUS_COMMON_ERP_FAILED. Only the fc_host port_state changes to
"Linkdown", because zfcp_scsi_get_host_port_state() is an active callback
and uses the adapter status.

Other fc_host attributes model, port_id, port_type, speed, fabric_name
(and zfcp device attributes card_version, peer_wwpn, peer_wwnn, peer_d_id)
which depend on a local link, continued to show their last known
"good" value.
Only if something triggered an exchange config data, some values were
updated to their unknown equivalent via case
FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE due to local link down.
Triggers for exchange config data are adapter recovery, or
reading any of the following zfcp-specific scsi host sysfs attributes
"requests", "megabytes", or "seconds_active" in
/sys/devices/css*/*.*.*/*.*.*/host*/scsi_host/host*/.

The other fc_host attributes active_fc4s and permanent_port_name
continued to show their last known "good" value.
Only if something triggered an exchange port data, some values changed.
Active_fc4s became all zeros as unknown equivalent during link down.
Permanent_port_name does not depend on a local link. But for
non-NPIV FCP devices, permanent_port_name erroneously became whatever
value fc_host port_name had at that point in time (see previous paragraph).
Triggers for exchange port data are the zfcp-specific scsi host sysfs
attribute "utilization", or [{reset,get}_fc_host_stats]
write anything into "reset_statistics" or read any of the other attributes
under /sys/devices/css*/*.*.*/*.*.*/host*/fc_host/host*/statistics/.

(cf. v4.9 commit bd77befa5bcf ("zfcp: fix fc_host port_type with NPIV"))

This is particularly confusing when using "lszfcp -b <fcpdevbusid> -Ha"
or dbginfo.sh which read fc_host attributes and also scsi_host attributes.
After link down, the first invocation produces (abbreviated):

Class = "fc_host"
    active_fc4s         = "0x00 0x00 0x01 0x00 ..."
    ...
    fabric_name         = "0x10000027f8e04c49"
    ...
    permanent_port_name = "0xc05076e4588059c1"
    port_id             = "0x244800"
    port_state          = "Linkdown"
    port_type           = "NPort (fabric via point-to-point)"
    ...
    speed               = "16 Gbit"
Class = "scsi_host"
    ...
    megabytes           = "0 0"
    ...
    requests            = "0 0 0"
    seconds_active      = "37"
    ...
    utilization         = "0 0 0"

The second and next invocations produce (abbreviated):

Class = "fc_host"
    active_fc4s         = "0x00 0x00 0x00 0x00 ..."
    ...
    fabric_name         = "0x0"
    ...
    permanent_port_name = "0x0"
    port_id             = "0x000000"
    port_state          = "Linkdown"
    port_type           = "Unknown"
    ...
    speed               = "unknown"
Class = "scsi_host"
    ...
    megabytes           = "0 0"
    ...
    requests            = "0 0 0"
    seconds_active      = "38"
    ...
    utilization         = "0 0 0"

Factor out the resetting of local link dependent fc_host attributes from
zfcp_fsf_exchange_config_data_handler() case
FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE into a new helper function
zfcp_fsf_fc_host_link_down().
All code places that detect local link down (SRB, FSF_PROT_LINK_DOWN,
xconf data/port incomplete) call zfcp_fsf_link_down_info_eval().
Call the new helper from there. This works because
zfcp_fsf_link_down_info_eval() and thus the helper is called before
zfcp_fsf_exchange_{config,port}_evaluate().

Port_name and node_name are always valid, so never reset them.

Get the permanent_port_name from exchange port data unconditionally
as it always has a valid known good value, even during link down.

Note: Rather than hardcode in zfcp_fsf_exchange_config_evaluate(),
fc_host supported_classes could theoretically get its value from
fsf_qtcb_bottom_port.class_of_service in zfcp_fsf_exchange_port_evaluate().

When the link comes back, we get a different notification, perform adapter
recovery, and this triggers an implicit exchange config data followed by
exchange port data filling in the link dependent fc_host attributes with
known good values again.

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c | 39 +++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 31ecbc160482..1fa94277d287 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -120,6 +120,23 @@ static void zfcp_fsf_status_read_port_closed(struct zfcp_fsf_req *req)
 	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 }
 
+static void zfcp_fsf_fc_host_link_down(struct zfcp_adapter *adapter)
+{
+	struct Scsi_Host *shost = adapter->scsi_host;
+
+	fc_host_port_id(shost) = 0;
+	fc_host_fabric_name(shost) = 0;
+	fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
+	fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
+	adapter->hydra_version = 0;
+	snprintf(fc_host_model(shost), FC_SYMBOLIC_NAME_SIZE, "0x%04x", 0);
+	memset(fc_host_active_fc4s(shost), 0, FC_FC4_LIST_SIZE);
+
+	adapter->peer_wwpn = 0;
+	adapter->peer_wwnn = 0;
+	adapter->peer_d_id = 0;
+}
+
 static void zfcp_fsf_link_down_info_eval(struct zfcp_fsf_req *req,
 					 struct fsf_link_down_info *link_down)
 {
@@ -132,6 +149,8 @@ static void zfcp_fsf_link_down_info_eval(struct zfcp_fsf_req *req,
 
 	zfcp_scsi_schedule_rports_block(adapter);
 
+	zfcp_fsf_fc_host_link_down(adapter);
+
 	if (!link_down)
 		goto out;
 
@@ -512,9 +531,6 @@ static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 	adapter->stat_read_buf_num = max(bottom->status_read_buf_num,
 					 (u16)FSF_STATUS_READS_RECOM);
 
-	if (fc_host_permanent_port_name(shost) == -1)
-		fc_host_permanent_port_name(shost) = fc_host_port_name(shost);
-
 	zfcp_scsi_set_prot(adapter);
 
 	/* no error return above here, otherwise must fix call chains */
@@ -608,16 +624,6 @@ static void zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *req)
 		zfcp_diag_update_xdata(diag_hdr, bottom, true);
 		req->status |= ZFCP_STATUS_FSFREQ_XDATAINCOMPLETE;
 
-		fc_host_node_name(shost) = 0;
-		fc_host_port_name(shost) = 0;
-		fc_host_port_id(shost) = 0;
-		fc_host_fabric_name(shost) = 0;
-		fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
-		fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
-		adapter->hydra_version = 0;
-		snprintf(fc_host_model(shost), FC_SYMBOLIC_NAME_SIZE, "0x%04x",
-			 0);
-
 		/* avoids adapter shutdown to be able to recognize
 		 * events such as LINK UP */
 		atomic_or(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
@@ -667,10 +673,7 @@ static void zfcp_fsf_exchange_port_evaluate(struct zfcp_fsf_req *req)
 	if (req->data)
 		memcpy(req->data, bottom, sizeof(*bottom));
 
-	if (adapter->connection_features & FSF_FEATURE_NPIV_MODE) {
-		fc_host_permanent_port_name(shost) = bottom->wwpn;
-	} else
-		fc_host_permanent_port_name(shost) = fc_host_port_name(shost);
+	fc_host_permanent_port_name(shost) = bottom->wwpn;
 	fc_host_maxframe_size(shost) = bottom->maximum_frame_size;
 	fc_host_supported_speeds(shost) =
 		zfcp_fsf_convert_portspeed(bottom->supported_speed);
@@ -704,9 +707,9 @@ static void zfcp_fsf_exchange_port_data_handler(struct zfcp_fsf_req *req)
 		zfcp_diag_update_xdata(diag_hdr, bottom, true);
 		req->status |= ZFCP_STATUS_FSFREQ_XDATAINCOMPLETE;
 
-		zfcp_fsf_exchange_port_evaluate(req);
 		zfcp_fsf_link_down_info_eval(req,
 			&qtcb->header.fsf_status_qual.link_down_info);
+		zfcp_fsf_exchange_port_evaluate(req);
 		break;
 	}
 }
-- 
2.17.1

