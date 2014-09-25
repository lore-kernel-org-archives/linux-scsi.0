From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 22/35] qla2xxx: Declaration error cause stack corruption.
Date: Thu, 25 Sep 2014 05:16:53 -0400
Message-ID: <1411636626-7566-23-git-send-email-saurav.kashyap@qlogic.com>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:12627 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753001AbaIYJvU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:20 -0400
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@qlogic.com>

Declaration error of mb array in qla2x00_iidma_fcport cause data
to be written beyond the array. This ends up causing stack corruption.

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d5b10ec..ab22ccf 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3192,7 +3192,7 @@ static void
 qla2x00_iidma_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 {
 	int rval;
-	uint16_t mb[4];
+	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_IIDMA_CAPABLE(ha))
-- 
1.7.7

