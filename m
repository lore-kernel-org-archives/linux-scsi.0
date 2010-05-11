From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 2/7][RFC] iscsi_transport: ping support via BSG
Date: Tue, 11 May 2010 13:26:18 +0530
Message-ID: <20100511075618.GA30486@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:46158
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751225Ab0EKIAT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 May 2010 04:00:19 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 include/scsi/scsi_bsg_iscsi.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/scsi/scsi_bsg_iscsi.h b/include/scsi/scsi_bsg_iscsi.h
index 3f5119a..4b3821f 100644
--- a/include/scsi/scsi_bsg_iscsi.h
+++ b/include/scsi/scsi_bsg_iscsi.h
@@ -46,6 +46,7 @@
 
 	/* iscsi host Message Codes */
 #define	ISCSI_BSG_HST_NET_CONFIG	(ISCSI_BSG_HST_MASK | 0x00000001)
+#define ISCSI_BSG_HST_PING		(ISCSI_BSG_HST_MASK | 0x00000002)
 #define ISCSI_BSG_HST_VENDOR		(ISCSI_BSG_HST_MASK | 0x000000FF)
 
 #define ISCSI_SET_IP_ADDR		1
@@ -57,6 +58,15 @@
 #define ISCSI_GET_IF_INFO		7
 #define ISCSI_GET_DEFAULT_GATEWAY	8
 
+struct iscsi_bsg_host_ping {
+	int32_t ip_type; /* IPv4 or IPv6 */
+#define ISCSI_PING_IPV4	0x00000000
+#define ISCSI_PING_IPV6	0x00000001
+	int32_t ip_address[4];
+	int32_t payload_size;
+	int8_t  payload[0];
+};
+
 /*
  * iSCSI Host Messages
  */
@@ -222,6 +232,7 @@ struct iscsi_bsg_request {
 	uint32_t msgcode;
 	union {
 		struct iscsi_bsg_host_net_config	h_netconfig;
+		struct iscsi_bsg_host_ping		h_ping;
 		struct iscsi_bsg_host_vendor		h_vendor;
 	} rqst_data;
 } __attribute__((packed));
-- 
1.7.0.5

