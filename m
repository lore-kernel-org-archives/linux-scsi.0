From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 13/14] qla2xxx: Restore physical port WWPN only, when port down detected for FA-WWPN port.
Date: Thu, 9 Apr 2015 15:00:07 -0400
Message-ID: <1428606008-14976-14-git-send-email-himanshu.madhani@qlogic.com>
References: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:55784 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933205AbbDITl3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2015 15:41:29 -0400
In-Reply-To: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@qlogic.com>

For FA-WWPN is enabled port, if NPIV created on that port and,
if port link is brought down, then WWPN was restored from flash for both
physical and NPIV port. This will result in NPIV port and physical port
sharing same WWPN. Any application refreshing ports information  will
not be able to scan NPIV port because of this behavior. So while restoring WWPN,
only restore physical port WWPN.

Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 72dfbc1..6dc14cd 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -756,14 +756,23 @@ skip_rio:
 			/*
 			 * In case of loop down, restore WWPN from
 			 * NVRAM in case of FA-WWPN capable ISP
+			 * Restore for Physical Port only
 			 */
-			if (ha->flags.fawwpn_enabled) {
-				void *wwpn = ha->init_cb->port_name;
+			if (!vha->vp_idx) {
+				if (ha->flags.fawwpn_enabled) {
+					void *wwpn = ha->init_cb->port_name;
+					memcpy(vha->port_name, wwpn, WWN_SIZE);
+					fc_host_port_name(vha->host) =
+					    wwn_to_u64(vha->port_name);
+					ql_dbg(ql_dbg_init + ql_dbg_verbose,
+					    vha, 0x0144, "LOOP DOWN detected,"
+					    "restore WWPN %016llx\n",
+					    wwn_to_u64(vha->port_name));
+				}
 
-				memcpy(vha->port_name, wwpn, WWN_SIZE);
+				clear_bit(VP_CONFIG_OK, &vha->vp_flags);
 			}
 
-			clear_bit(VP_CONFIG_OK, &vha->vp_flags);
 			vha->device_flags |= DFLG_NO_CABLE;
 			qla2x00_mark_all_devices_lost(vha, 1);
 		}
-- 
1.7.7

