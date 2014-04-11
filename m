From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 04/42] qla2xxx: Allow ISP83XX and ISP27XX both to write req_q_out register.
Date: Fri, 11 Apr 2014 16:54:09 -0400
Message-ID: <1397249687-32666-5-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:15649 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755143AbaDKVcI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:08 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 2528709..9570597 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3697,7 +3697,7 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	if (!(req->options & BIT_0)) {
 		WRT_REG_DWORD(req->req_q_in, 0);
-		if (!IS_QLA83XX(ha) || !IS_QLA27XX(ha))
+		if (!IS_QLA83XX(ha) && !IS_QLA27XX(ha))
 			WRT_REG_DWORD(req->req_q_out, 0);
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-- 
1.7.7

