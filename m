From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 08/14] qla2xxx: Display IPE error message for ISP82xx.
Date: Fri, 18 Nov 2011 09:02:16 -0800
Message-ID: <1321635742-16426-9-git-send-email-chad.dupuis@qlogic.com>
References: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:25618
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758195Ab1KRRP2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:15:28 -0500
In-Reply-To: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index d2005c3..d025582 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3858,6 +3858,11 @@ void qla82xx_watchdog(scsi_qla_host_t *vha)
 					    QLA82XX_CRB_PEG_NET_3 + 0x3c),
 				    qla82xx_rd_32(ha,
 					    QLA82XX_CRB_PEG_NET_4 + 0x3c));
+				if(LSW(MSB(halt_status)) == 0x67)
+					ql_log(ql_log_warn, vha, 0xb052,
+					    "Firmware aborted with "
+					    "error code 0x00006700. Device is "
+					    "being reset.\n");
 				if (halt_status & HALT_STATUS_UNRECOVERABLE) {
 					set_bit(ISP_UNRECOVERABLE,
 					    &vha->dpc_flags);
-- 
1.6.0.2


