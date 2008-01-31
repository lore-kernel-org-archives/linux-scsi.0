From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 08/11] qla2xxx: Correct issue where vport-state was not updated during an ISP_ABORT_NEEDED requst.
Date: Thu, 31 Jan 2008 12:33:51 -0800
Message-ID: <1201811634-19865-8-git-send-email-andrew.vasquez@qlogic.com>
References: <20080131203216.GB19014@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:8353 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761407AbYAaUeI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 15:34:08 -0500
In-Reply-To: <20080131203216.GB19014@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

From: Seokmann Ju <seokmann.ju@qlogic.com>

While running IO simultaneously through physical port and virtual
port, if user changes Data Rate (from scli utility), IO through
virtual port fails.  It failed because the vport had not received
the ISP_ABORT_NEEDED notification.

Signed-Off-by: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4b4c32f..0b52ee7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2220,6 +2220,9 @@ qla2x00_do_dpc(void *data)
 	fc_port_t	*fcport;
 	uint8_t		status;
 	uint16_t	next_loopid;
+	struct scsi_qla_host *vha;
+	int             i;
+
 
 	ha = (scsi_qla_host_t *)data;
 
@@ -2262,6 +2265,18 @@ qla2x00_do_dpc(void *data)
 				}
 				clear_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
 			}
+
+			for_each_mapped_vp_idx(ha, i) {
+				list_for_each_entry(vha, &ha->vp_list,
+				    vp_list) {
+					if (i == vha->vp_idx) {
+						set_bit(ISP_ABORT_NEEDED,
+						    &vha->dpc_flags);
+						break;
+					}
+				}
+			}
+
 			DEBUG(printk("scsi(%ld): dpc: qla2x00_abort_isp end\n",
 			    ha->host_no));
 		}
-- 
1.5.4.rc5.5.gab98

