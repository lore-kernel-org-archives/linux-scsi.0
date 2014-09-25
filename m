From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 30/35] qla2xxx: Mark port lost when we receive an RSCN for it.
Date: Thu, 25 Sep 2014 05:17:01 -0400
Message-ID: <1411636626-7566-31-git-send-email-saurav.kashyap@qlogic.com>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:62867 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753076AbaIYJvY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:24 -0400
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 696e4a2..a04a1b1 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -575,8 +575,9 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	struct device_reg_24xx __iomem *reg24 = &ha->iobase->isp24;
 	struct device_reg_82xx __iomem *reg82 = &ha->iobase->isp82;
-	uint32_t	rscn_entry, host_pid;
+	uint32_t	rscn_entry, host_pid, tmp_pid;
 	unsigned long	flags;
+	fc_port_t	*fcport = NULL;
 
 	/* Setup to process RIO completion. */
 	handle_cnt = 0;
@@ -979,6 +980,20 @@ skip_rio:
 		if (qla2x00_is_a_vp_did(vha, rscn_entry))
 			break;
 
+		/*
+		 * Search for the rport related to this RSCN entry and mark it
+		 * as lost.
+		 */
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
+			if (atomic_read(&fcport->state) != FCS_ONLINE)
+				continue;
+			tmp_pid = fcport->d_id.b24;
+			if (fcport->d_id.b24 == rscn_entry) {
+				qla2x00_mark_device_lost(vha, fcport, 0, 0);
+				break;
+			}
+		}
+
 		atomic_set(&vha->loop_down_timer, 0);
 		vha->flags.management_server_logged_in = 0;
 
-- 
1.7.7

