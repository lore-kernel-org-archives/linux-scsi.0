From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] SMP request handlers need to update resid
Date: Thu, 20 Dec 2007 11:44:36 +0900
Message-ID: <20071220114436Z.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:45169 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbXLTCpH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Dec 2007 21:45:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: dougg@torque.net, Eric.Moore@lsi.com, linux-scsi@vger.kernel.org, tomof@acm.org

Doug pointed out that SMP passthrough support via bsg doesn't update
din_resid or dout_resid. It's confusing for user-space tools like
smp_utils.

This patch fixes mptsas_smp_handler (for sas fusion) and libsas'
sas_smp_handler to update both din_resid or dout_resid on success.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/message/fusion/mptsas.c    |    2 ++
 drivers/scsi/libsas/sas_expander.c |    5 +++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index e4c94f9..f77b329 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1343,6 +1343,8 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
 		memcpy(req->sense, smprep, sizeof(*smprep));
 		req->sense_len = sizeof(*smprep);
+		req->data_len = 0;
+		rsp->data_len -= smprep->ResponseDataLength;
 	} else {
 		printk(MYIOC_s_ERR_FMT "%s: smp passthru reply failed to be returned\n",
 		    ioc->name, __FUNCTION__);
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 27674fe..491a470 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1926,6 +1926,11 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 
 	ret = smp_execute_task(dev, bio_data(req->bio), req->data_len,
 			       bio_data(rsp->bio), rsp->data_len);
+	if (!ret) {
+		struct smp_resp *srsp = (struct smp_resp *)bio_data(rsp->bio);
+		if (srsp->result == SMP_RESP_FUNC_ACC)
+			req->data_len = rsp->data_len = 0;
+	}
 
 	return ret;
 }
-- 
1.5.3.4

