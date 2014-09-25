From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 02/17] qla2xxx: fix kernel NULL pointer access
Date: Thu, 25 Sep 2014 06:14:44 -0400
Message-ID: <1411640099-7856-3-git-send-email-saurav.kashyap@qlogic.com>
References: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:58131 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595AbaIYKs6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 06:48:58 -0400
In-Reply-To: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
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
index aebe62c..43f9177 100644
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

