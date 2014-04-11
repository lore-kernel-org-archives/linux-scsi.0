From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 07/42] qla2xxx: Issue abort command for outstanding commands during cleanup when only firmware is alive.
Date: Fri, 11 Apr 2014 16:54:12 -0400
Message-ID: <1397249687-32666-8-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:42526 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755128AbaDKVcH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:07 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 5511e24..81388e9 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3682,8 +3682,10 @@ qla82xx_chip_reset_cleanup(scsi_qla_host_t *vha)
 			for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
 				sp = req->outstanding_cmds[cnt];
 				if (sp) {
-					if (!sp->u.scmd.ctx ||
-					    (sp->flags & SRB_FCP_CMND_DMA_VALID)) {
+					if ((!sp->u.scmd.ctx ||
+					    (sp->flags &
+						SRB_FCP_CMND_DMA_VALID)) &&
+						!ha->flags.isp82xx_fw_hung) {
 						spin_unlock_irqrestore(
 						    &ha->hardware_lock, flags);
 						if (ha->isp_ops->abort_command(sp)) {
-- 
1.7.7

