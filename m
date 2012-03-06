From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 1/3] iscsi_transport: Added error status code for ping comp event
Date: Tue, 6 Mar 2012 04:16:04 -0800
Message-ID: <1331036166-19496-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1331036166-19496-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:19666 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030553Ab2CFM3t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Mar 2012 07:29:49 -0500
In-Reply-To: <1331036166-19496-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Defined error codes for ping completion status.

This patch take care of Mike Cristie commets posted here:-
http://marc.info/?l=linux-scsi&m=133100222813192&w=2

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_isr.c |    4 ++--
 include/scsi/iscsi_if.h        |   17 ++++++++++++++++-
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 7c9f28b..fc542a9 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -431,9 +431,9 @@ static void qla4xxx_mbox_status_entry(struct scsi_qla_host *ha,
 				  mbox_sts_entry->out_mbox[6]));
 
 		if (mbox_sts_entry->out_mbox[0] == MBOX_STS_COMMAND_COMPLETE)
-			status = QLA_SUCCESS;
+			status = ISCSI_PING_SUCCESS;
 		else
-			status = QLA_ERROR;
+			status = mbox_sts_entry->out_mbox[6];
 
 		data_size = sizeof(mbox_sts_entry->out_mbox);
 
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 9c23ee8..eab830a 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -261,7 +261,8 @@ struct iscsi_uevent {
 		} host_event;
 		struct msg_ping_comp {
 			uint32_t        host_no;
-			uint32_t        status;
+			uint32_t        status; /* enum
+						 * iscsi_ping_status_code */
 			uint32_t	pid;	/* unique ping id associated
 						   with each ping request */
 			uint32_t        data_size;
@@ -483,6 +484,20 @@ enum iscsi_port_state {
 	ISCSI_PORT_STATE_UP		= 0x2,
 };
 
+/* iSCSI PING status/error code */
+enum iscsi_ping_status_code {
+	ISCSI_PING_SUCCESS			= 0,
+	ISCSI_PING_FW_DISABLED			= 0x1,
+	ISCSI_PING_IPADDR_INVALID		= 0x2,
+	ISCSI_PING_LINKLOCAL_IPV6_ADDR_INVALID	= 0x3,
+	ISCSI_PING_TIMEOUT			= 0x4,
+	ISCSI_PING_INVALID_DEST_ADDR		= 0x5,
+	ISCSI_PING_OVERSIZE_PACKET		= 0x6,
+	ISCSI_PING_ICMP_ERROR			= 0x7,
+	ISCSI_PING_MAX_REQ_EXCEEDED		= 0x8,
+	ISCSI_PING_NO_ARP_RECEIVED		= 0x9,
+};
+
 #define iscsi_ptr(_handle) ((void*)(unsigned long)_handle)
 #define iscsi_handle(_ptr) ((uint64_t)(unsigned long)_ptr)
 
-- 
1.7.9.1.265.gb3a76


