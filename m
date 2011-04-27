From: Roland Dreier <roland@kernel.org>
Subject: [PATCH][SCSI] target: Fix double test of inquiry_prod
Date: Wed, 27 Apr 2011 09:07:02 -0700
Message-ID: <1303920422-31142-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog102.obsmtp.com ([74.125.245.72]:59921 "HELO
	na3sys010aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750988Ab1D0QPC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2011 12:15:02 -0400
Received: by pwj9 with SMTP id 9so847666pwj.20
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2011 09:15:00 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

The code really intends to make sure that neither inquiry_prod nor
inquiry_rev is NULL.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/target/target_core_transport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9583b23..4a03098 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1725,7 +1725,7 @@ struct se_device *transport_add_device_to_core_hba(
 	 * setup.
 	 */
 	if (TRANSPORT(dev)->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV) {
-		if (!(inquiry_prod) || !(inquiry_prod)) {
+		if (!inquiry_prod || !inquiry_rev) {
 			printk(KERN_ERR "All non TCM/pSCSI plugins require"
 				" INQUIRY consts\n");
 			goto out;
