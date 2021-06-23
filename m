Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D0FC48BC2
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 10:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2502160BD3
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 10:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhFWK3w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 06:29:52 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48202 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229833AbhFWK3u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Jun 2021 06:29:50 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15NABr8m008281
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2021 03:27:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=ZpdyekyFIOPkW4RuWDp4l35C2Y92uDWL6mQPXAaASho=;
 b=A+MRYEFRw8gHucS3kft/gBLMomYaW+3tss5V5eX2LCy1yNGHAmRotEOPHVNDWIH9wnvH
 4St/hI5FrHA6MVmRxoXgIGjPoWjuhmxbuLweeveBIBKxLk4RTu31nhsmT/ibxn9vTg0r
 S5wZLdlYL492unSTepgJxDKY4YFumJuOivE+E2Likg5idIJCxTo9Bq6SIUZr4ScSRufH
 Ea8mr6L2RqiEsq0vPBH12L28FarrPJidBO3PXyMmBU5aoMsV7+CIeBER0cmNKTMEe3cw
 5rLaWzuNzFCcoEslkCZ13l2d667/MBGPeXupNPx4+6MwMDAoIQiFwJsAFPlZ4+SgOD1Z Yg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 39bx5j940p-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2021 03:27:30 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 23 Jun
 2021 03:27:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 23 Jun 2021 03:27:24 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3FF3E5B6937;
        Wed, 23 Jun 2021 03:27:24 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 15NAROUj003688;
        Wed, 23 Jun 2021 03:27:24 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 15NAROrq003687;
        Wed, 23 Jun 2021 03:27:24 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 02/11] qla2xxx: Add getfcinfo and statistic bsg's
Date:   Wed, 23 Jun 2021 03:26:02 -0700
Message-ID: <20210623102611.3637-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210623102611.3637-1-njavali@marvell.com>
References: <20210623102611.3637-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: RCOIX5Qp-xx-AgHTMQc6L3DSpC1eJDbj
X-Proofpoint-GUID: RCOIX5Qp-xx-AgHTMQc6L3DSpC1eJDbj
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_03:2021-06-23,2021-06-23 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Latest FC adapter from Marvell has the ability to encrypt
data in flight (EDIF) feature. This feature require an
application (ex: ipsec, etc) to act as an authenticator.

This patch add 2 new BSG calls:
QL_VND_SC_GET_FCINFO: Application from time to time can request
for a list of all FC ports or a single device that support
secure connection. If driver sees a new or old device has
came onto the switch, this call is used to check for the WWPN.

QL_VND_SC_GET_STATS: Application request for various statistic
count of each FC port.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Larry Wisneski <Larry.Wisneski@marvell.com>
Signed-off-by: Duane Grigsby <duane.grigsby@marvell.com>
Signed-off-by: Rick Hicksted Jr <rhicksted@marvell.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |   3 +-
 drivers/scsi/qla2xxx/qla_edif.c | 188 ++++++++++++++++++++++++++++++++
 2 files changed, 190 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 0d28328722b2..ec28023b738f 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2576,10 +2576,11 @@ typedef struct fc_port {
 		uint32_t	app_sess_online:1;
 		uint32_t	tx_rekey_cnt;
 		uint32_t	rx_rekey_cnt;
-		/* delayed rx delete data structure list */
 		uint64_t	tx_bytes;
 		uint64_t	rx_bytes;
 		uint8_t		non_secured_login;
+		uint8_t		auth_state;
+		uint16_t	rekey_cnt;
 	} edif;
 } fc_port_t;
 
diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index b0194ea1a32d..165c910c1b81 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -264,6 +264,188 @@ qla_edif_app_stop(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	return rval;
 }
 
+/**
+ * qla_edif_app_getfcinfo - app would like to read session info (wwpn, nportid,
+ *   [initiator|target] mode.  It can specific session with specific nport id or
+ *   all sessions.
+ * @vha: host adapter pointer
+ * @bsg_job: user request pointer
+ */
+static int
+qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
+{
+	int32_t			rval = 0;
+	int32_t			num_cnt = 1;
+	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
+	struct app_pinfo_req	app_req;
+	struct app_pinfo_reply	*app_reply;
+	port_id_t		tdid;
+
+	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app get fcinfo\n", __func__);
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, &app_req,
+	    sizeof(struct app_pinfo_req));
+
+	num_cnt = app_req.num_ports;	/* num of ports alloc'd by app */
+
+	app_reply = kzalloc((sizeof(struct app_pinfo_reply) +
+	    sizeof(struct app_pinfo) * num_cnt), GFP_KERNEL);
+	if (!app_reply) {
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		rval = -1;
+	} else {
+		struct fc_port	*fcport = NULL, *tf;
+		uint32_t	pcnt = 0;
+
+		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
+			if (!(fcport->flags & FCF_FCSP_DEVICE))
+				continue;
+
+			tdid = app_req.remote_pid;
+
+			ql_dbg(ql_dbg_edif, vha, 0x2058,
+			    "APP request entry - portid=%06x.\n",
+			    tdid.b24);
+
+			/* Ran out of space */
+			if (pcnt > app_req.num_ports)
+				break;
+
+			if (tdid.b24 != 0 && tdid.b24 != fcport->d_id.b24)
+				continue;
+
+			app_reply->ports[pcnt].remote_type =
+				VND_CMD_RTYPE_UNKNOWN;
+			if (fcport->port_type & (FCT_NVME_TARGET | FCT_TARGET))
+				app_reply->ports[pcnt].remote_type |=
+					VND_CMD_RTYPE_TARGET;
+			if (fcport->port_type & (FCT_NVME_INITIATOR | FCT_INITIATOR))
+				app_reply->ports[pcnt].remote_type |=
+					VND_CMD_RTYPE_INITIATOR;
+
+			app_reply->ports[pcnt].remote_pid = fcport->d_id;
+
+			ql_dbg(ql_dbg_edif, vha, 0x2058,
+			    "Found FC_SP fcport - nn %8phN pn %8phN pcnt %d portid=%02x%02x%02x.\n",
+			    fcport->node_name, fcport->port_name, pcnt,
+			    fcport->d_id.b.domain, fcport->d_id.b.area,
+			    fcport->d_id.b.al_pa);
+
+			switch (fcport->edif.auth_state) {
+			case VND_CMD_AUTH_STATE_ELS_RCVD:
+				if (fcport->disc_state == DSC_LOGIN_AUTH_PEND) {
+					fcport->edif.auth_state = VND_CMD_AUTH_STATE_NEEDED;
+					app_reply->ports[pcnt].auth_state =
+						VND_CMD_AUTH_STATE_NEEDED;
+				} else {
+					app_reply->ports[pcnt].auth_state =
+						VND_CMD_AUTH_STATE_ELS_RCVD;
+				}
+				break;
+			default:
+				app_reply->ports[pcnt].auth_state = fcport->edif.auth_state;
+				break;
+			}
+
+			memcpy(app_reply->ports[pcnt].remote_wwpn,
+			    fcport->port_name, 8);
+
+			app_reply->ports[pcnt].remote_state =
+				(atomic_read(&fcport->state) ==
+				    FCS_ONLINE ? 1 : 0);
+
+			pcnt++;
+
+			if (tdid.b24 != 0)
+				break;
+		}
+		app_reply->port_count = pcnt;
+		SET_DID_STATUS(bsg_reply->result, DID_OK);
+	}
+
+	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+	    bsg_job->reply_payload.sg_cnt, app_reply,
+	    sizeof(struct app_pinfo_reply) + sizeof(struct app_pinfo) * num_cnt);
+
+	kfree(app_reply);
+
+	return rval;
+}
+
+/**
+ * qla_edif_app_getstats - app would like to read various statistics info
+ * @vha: host adapter pointer
+ * @bsg_job: user request
+ */
+static int32_t
+qla_edif_app_getstats(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
+{
+	int32_t			rval = 0;
+	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
+	uint32_t ret_size, size;
+
+	struct app_sinfo_req	app_req;
+	struct app_stats_reply	*app_reply;
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, &app_req,
+	    sizeof(struct app_sinfo_req));
+	if (app_req.num_ports == 0) {
+		ql_dbg(ql_dbg_async, vha, 0x911d,
+		   "%s app did not indicate number of ports to return\n",
+		    __func__);
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		rval = -1;
+	}
+
+	size = sizeof(struct app_stats_reply) +
+	    (sizeof(struct app_sinfo) * app_req.num_ports);
+
+	if (size > bsg_job->reply_payload.payload_len)
+		ret_size = bsg_job->reply_payload.payload_len;
+	else
+		ret_size = size;
+
+	app_reply = kzalloc(size, GFP_KERNEL);
+	if (!app_reply) {
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		rval = -1;
+	} else {
+		struct fc_port	*fcport = NULL, *tf;
+		uint32_t	pcnt = 0;
+
+		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
+			if (fcport->edif.enable) {
+				if (pcnt > app_req.num_ports)
+					break;
+
+				app_reply->elem[pcnt].rekey_count =
+				    fcport->edif.rekey_cnt;
+				app_reply->elem[pcnt].tx_bytes =
+				    fcport->edif.tx_bytes;
+				app_reply->elem[pcnt].rx_bytes =
+				    fcport->edif.rx_bytes;
+
+				memcpy(app_reply->elem[pcnt].remote_wwpn,
+				    fcport->port_name, 8);
+
+				pcnt++;
+			}
+		}
+		app_reply->elem_count = pcnt;
+		SET_DID_STATUS(bsg_reply->result, DID_OK);
+	}
+
+	bsg_reply->reply_payload_rcv_len =
+	    sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+	       bsg_job->reply_payload.sg_cnt, app_reply, ret_size);
+
+	kfree(app_reply);
+
+	return rval;
+}
+
 int32_t
 qla_edif_app_mgmt(struct bsg_job *bsg_job)
 {
@@ -310,6 +492,12 @@ qla_edif_app_mgmt(struct bsg_job *bsg_job)
 	case QL_VND_SC_APP_STOP:
 		rval = qla_edif_app_stop(vha, bsg_job);
 		break;
+	case QL_VND_SC_GET_FCINFO:
+		rval = qla_edif_app_getfcinfo(vha, bsg_job);
+		break;
+	case QL_VND_SC_GET_STATS:
+		rval = qla_edif_app_getstats(vha, bsg_job);
+		break;
 	default:
 		ql_dbg(ql_dbg_edif, vha, 0x911d, "%s unknown cmd=%x\n",
 		    __func__,
-- 
2.19.0.rc0

