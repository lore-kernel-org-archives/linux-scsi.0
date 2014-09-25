From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 02/19] qla2xxx: fix kernel NULL pointer access
Date: Thu, 25 Sep 2014 04:09:55 -0400
Message-ID: <1411632612-7320-3-git-send-email-saurav.kashyap@qlogic.com>
References: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:32706 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbaIYIoM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 04:44:12 -0400
In-Reply-To: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com

From: Himanshu Madhani <himanshu.madhani@qlogic.com>

This patch is to fix regression added by commit id
51a07f84649d2be206c4c2ad9a612956db0c2f8c.

When allocating memory for new session original patch does
not assign vha to op->vha resulting into NULL pointer
access during qlt_create_sess_from_atio().

Cc: <stable@vger.kernel.org>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index e632e14..e44fcb5 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3277,6 +3277,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 			return -ENOMEM;
 
 		memcpy(&op->atio, atio, sizeof(*atio));
+		op->vha = vha;
 		INIT_WORK(&op->work, qlt_create_sess_from_atio);
 		queue_work(qla_tgt_wq, &op->work);
 		return 0;
-- 
1.7.7

