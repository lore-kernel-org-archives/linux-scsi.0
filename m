From: andrew.vasquez@qlogic.com
Subject: [PATCH 01/15] qla2xxx: Reference proper node/port names in fc_host class.
Date: Fri, 13 Jan 2006 17:04:49 -0800
Message-ID: <11372006843875-git-send-email-andrew.vasquez@qlogic.com>
References: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:35874 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1945916AbWANBEt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 20:04:49 -0500
In-Reply-To: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

The initial-control-block references are not always correct
as the use-node-name qualifier during NVRAM configuration
will cause the firmware to use the portname as a base for
the nodename.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_attr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

5508215832b4d5f6850c6963bd1e3a45089d3e05
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 2efca52..b17ee62 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -541,7 +541,7 @@ struct fc_function_template qla2xxx_tran
 void
 qla2x00_init_host_attr(scsi_qla_host_t *ha)
 {
-	fc_host_node_name(ha->host) = wwn_to_u64(ha->init_cb->node_name);
-	fc_host_port_name(ha->host) = wwn_to_u64(ha->init_cb->port_name);
+	fc_host_node_name(ha->host) = wwn_to_u64(ha->node_name);
+	fc_host_port_name(ha->host) = wwn_to_u64(ha->port_name);
 	fc_host_supported_classes(ha->host) = FC_COS_CLASS3;
 }
-- 
1.1.1-g4c34


