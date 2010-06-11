From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 14/15] iscsi_transport: ping support via BSG
Date: Fri, 11 Jun 2010 13:19:15 +0530
Message-ID: <20100611074915.GA27836@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:49174
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753432Ab0FKHvW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 03:51:22 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 include/scsi/scsi_bsg_iscsi.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/scsi/scsi_bsg_iscsi.h b/include/scsi/scsi_bsg_iscsi.h
index f454eca..93a80a3 100644
--- a/include/scsi/scsi_bsg_iscsi.h
+++ b/include/scsi/scsi_bsg_iscsi.h
@@ -46,6 +46,7 @@
 
        /* iscsi host Message Codes */
 #define ISCSI_BSG_HST_NET_CONFIG	(ISCSI_BSG_HST_MASK | 0x00000001)
+#define ISCSI_BSG_HST_PING		(ISCSI_BSG_HST_MASK | 0x00000002)
 #define ISCSI_BSG_HST_VENDOR		(ISCSI_BSG_HST_MASK | 0x000000FF)
 
 #define ISCSI_SET_IP_ADDR              1
@@ -61,6 +62,15 @@
  * iSCSI Host Messages
  */
 
+struct iscsi_bsg_host_ping {
+	uint32_t	ip_type; /* IPv4 or IPv6 */
+#define ISCSI_PING_IPV4		0x00000000
+#define ISCSI_PING_IPV6		0x00000001
+	uint32_t	ip_address[4];
+	uint32_t	payload_size;
+	uint8_t		payload[0];
+};
+
 struct ip_address_subnet_format {
 	u16 sizeofstructure;
 	u8  iptype;
@@ -220,6 +230,7 @@ struct iscsi_bsg_request {
 	uint32_t msgcode;
 	union {
 		struct iscsi_bsg_host_net_config        h_netconfig;
+		struct iscsi_bsg_host_ping		h_ping;
 		struct iscsi_bsg_host_vendor            h_vendor;
 	} rqst_data;
 } __attribute__((packed));
-- 
1.7.0.5

