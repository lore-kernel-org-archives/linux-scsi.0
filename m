From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH 3/7] qla4xxx: Set IPv6 traffic class if device type is IPv6.
Date: Mon, 8 Jul 2013 08:33:07 -0400
Message-ID: <1373286791-29659-4-git-send-email-adheer.chandravanshi@qlogic.com>
References: <1373286791-29659-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:6449 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217Ab3GHNAv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jul 2013 09:00:51 -0400
Received: from mail104-co9 (localhost [127.0.0.1])	by
 mail104-co9-R.bigfish.com (Postfix) with ESMTP id BADAF460432	for
 <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2013 13:00:50 +0000 (UTC)
Received: from CO9EHSMHS005.bigfish.com (unknown [10.236.132.234])	by
 mail104-co9.bigfish.com (Postfix) with ESMTP id 4349E20006A	for
 <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2013 13:00:46 +0000 (UTC)
In-Reply-To: <1373286791-29659-1-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 9b25b8c..85762f7 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2256,7 +2256,6 @@ static int qla4xxx_copy_to_fwddb_param(struct iscsi_bus_flash_session *sess,
 	fw_ddb_entry->mss = cpu_to_le16(conn->max_segment_size);
 	fw_ddb_entry->tcp_xmt_wsf = (uint8_t) cpu_to_le32(conn->tcp_xmit_wsf);
 	fw_ddb_entry->tcp_rcv_wsf = (uint8_t) cpu_to_le32(conn->tcp_recv_wsf);
-	fw_ddb_entry->ipv4_tos = conn->ipv4_tos;
 	fw_ddb_entry->ipv6_flow_lbl = cpu_to_le16(conn->ipv6_flow_label);
 	fw_ddb_entry->ka_timeout = cpu_to_le16(conn->keepalive_timeout);
 	fw_ddb_entry->lcl_port = cpu_to_le16(conn->local_port);
@@ -2269,6 +2268,11 @@ static int qla4xxx_copy_to_fwddb_param(struct iscsi_bus_flash_session *sess,
 	fw_ddb_entry->def_timeout =
 				cpu_to_le16(sess->default_taskmgmt_timeout);
 
+	if (!strncmp(sess->portal_type, PORTAL_TYPE_IPV6, 4))
+		fw_ddb_entry->ipv4_tos = conn->ipv6_traffic_class;
+	else
+		fw_ddb_entry->ipv4_tos = conn->ipv4_tos;
+
 	if (conn->ipaddress)
 		memcpy(fw_ddb_entry->ip_addr, conn->ipaddress,
 		       sizeof(fw_ddb_entry->ip_addr));
-- 
1.7.1


