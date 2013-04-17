From: vikas.chaudhary@qlogic.com
Subject: [PATCH 4/5] qla4xxx: Assign values using correct datatype
Date: Wed, 17 Apr 2013 05:15:29 -0400
Message-ID: <1366190130-16556-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1366190130-16556-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:18175 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754420Ab3DQJjO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Apr 2013 05:39:14 -0400
In-Reply-To: <1366190130-16556-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Assign values using correct datatype in function qla4xxx_copy_to_fwddb_param()

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 7f13caa..d777332 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2216,14 +2216,14 @@ static int qla4xxx_copy_to_fwddb_param(struct iscsi_bus_flash_session *sess,
 	fw_ddb_entry->iscsi_def_time2retain = cpu_to_le16(sess->time2retain);
 	fw_ddb_entry->tgt_portal_grp = cpu_to_le16(sess->tpgt);
 	fw_ddb_entry->mss = cpu_to_le16(conn->max_segment_size);
-	fw_ddb_entry->tcp_xmt_wsf = cpu_to_le16(conn->tcp_xmit_wsf);
-	fw_ddb_entry->tcp_rcv_wsf = cpu_to_le16(conn->tcp_recv_wsf);
+	fw_ddb_entry->tcp_xmt_wsf = (uint8_t) cpu_to_le32(conn->tcp_xmit_wsf);
+	fw_ddb_entry->tcp_rcv_wsf = (uint8_t) cpu_to_le32(conn->tcp_recv_wsf);
 	fw_ddb_entry->ipv4_tos = conn->ipv4_tos;
 	fw_ddb_entry->ipv6_flow_lbl = cpu_to_le16(conn->ipv6_flow_label);
 	fw_ddb_entry->ka_timeout = cpu_to_le16(conn->keepalive_timeout);
 	fw_ddb_entry->lcl_port = cpu_to_le16(conn->local_port);
-	fw_ddb_entry->stat_sn = cpu_to_le16(conn->statsn);
-	fw_ddb_entry->exp_stat_sn = cpu_to_le16(conn->exp_statsn);
+	fw_ddb_entry->stat_sn = cpu_to_le32(conn->statsn);
+	fw_ddb_entry->exp_stat_sn = cpu_to_le32(conn->exp_statsn);
 	fw_ddb_entry->ddb_link = cpu_to_le16(sess->discovery_parent_type);
 	fw_ddb_entry->chap_tbl_idx = cpu_to_le16(sess->chap_out_idx);
 	fw_ddb_entry->tsid = cpu_to_le16(sess->tsid);
-- 
1.8.2.GIT

