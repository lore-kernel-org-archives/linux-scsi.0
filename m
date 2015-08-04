From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH  02/14] qla2xxx: Handle AEN8014 incoming port logout.
Date: Tue, 4 Aug 2015 13:37:52 -0400
Message-ID: <1438709884-623-3-git-send-email-himanshu.madhani@qlogic.com>
References: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:17934 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753494AbbHDSXy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2015 14:23:54 -0400
In-Reply-To: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

When we get logged out, mark the port lost and set dpc flag for relogin.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c |   35 ++++++++++++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 8b011ae..cd188cc 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -26,7 +26,7 @@
  * |                              |                    | 0x3036,0x3038  |
  * |                              |                    | 0x303a		|
  * | DPC Thread                   |       0x4023       | 0x4002,0x4013  |
- * | Async Events                 |       0x5087       | 0x502b-0x502f  |
+ * | Async Events                 |       0x508a       | 0x502b-0x502f  |
  * |                              |                    | 0x5047		|
  * |                              |                    | 0x5084,0x5075	|
  * |                              |                    | 0x503d,0x5044  |
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5559d5e..de0d9d8 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -560,6 +560,17 @@ qla2x00_is_a_vp_did(scsi_qla_host_t *vha, uint32_t rscn_entry)
 	return ret;
 }
 
+static inline fc_port_t *
+qla2x00_find_fcport_by_loopid(scsi_qla_host_t *vha, uint16_t loop_id)
+{
+	fc_port_t *fcport;
+
+	list_for_each_entry(fcport, &vha->vp_fcports, list)
+		if (fcport->loop_id == loop_id)
+			return fcport;
+	return NULL;
+}
+
 /**
  * qla2x00_async_event() - Process aynchronous events.
  * @ha: SCSI driver HA context
@@ -897,11 +908,29 @@ skip_rio:
 			(mb[1] != 0xffff)) && vha->vp_idx != (mb[3] & 0xff))
 			break;
 
-		/* Global event -- port logout or port unavailable. */
-		if (mb[1] == 0xffff && mb[2] == 0x7) {
+		if (mb[2] == 0x7) {
 			ql_dbg(ql_dbg_async, vha, 0x5010,
-			    "Port unavailable %04x %04x %04x.\n",
+			    "Port %s %04x %04x %04x.\n",
+			    mb[1] == 0xffff ? "unavailable" : "logout",
 			    mb[1], mb[2], mb[3]);
+
+			if (mb[1] == 0xffff)
+				goto global_port_update;
+
+			/* Port logout */
+			fcport = qla2x00_find_fcport_by_loopid(vha, mb[1]);
+			if (!fcport)
+				break;
+			if (atomic_read(&fcport->state) != FCS_ONLINE)
+				break;
+			ql_dbg(ql_dbg_async, vha, 0x508a,
+			    "Marking port lost loopid=%04x portid=%06x.\n",
+			    fcport->loop_id, fcport->d_id.b24);
+			qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
+			break;
+
+global_port_update:
+			/* Port unavailable. */
 			ql_log(ql_log_warn, vha, 0x505e,
 			    "Link is offline.\n");
 
-- 
1.7.7

