From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH 1/2] bnx2fc: bnx2fc_fcoe.c: match wait_for_completion_timeout return type
Date: Wed,  4 Mar 2015 09:26:56 -0500
Message-ID: <1425479216-11485-1-git-send-email-hofrat@osadl.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:33541 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932461AbbCDObT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Mar 2015 09:31:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>

return type of wait_for_completion_timeout is unsigned long not int. rc
is appropriately renamed, changed to type unsigned long and the
assignments fixed up.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

The was only compile tested with x86_64_defconfig + SCSI_LOWLEVEL
CONFIG_SCSI_FC_ATTRS=m, CONFIG_LIBFC=m, CONFIG_LIBFCOE=m,
CONFIG_SCSI_BNX2X_FCOE=m

Patch is against 4.0-rc2 (localversion-next is -next-20150304)

 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 98d06d1..0082b5c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -635,7 +635,7 @@ static struct fc_host_statistics *bnx2fc_get_host_stats(struct Scsi_Host *shost)
 	struct bnx2fc_interface *interface = port->priv;
 	struct bnx2fc_hba *hba = interface->hba;
 	struct fcoe_statistics_params *fw_stats;
-	int rc = 0;
+	unsigned long time_left;
 
 	fw_stats = (struct fcoe_statistics_params *)hba->stats_buffer;
 	if (!fw_stats)
@@ -646,8 +646,8 @@ static struct fc_host_statistics *bnx2fc_get_host_stats(struct Scsi_Host *shost)
 	init_completion(&hba->stat_req_done);
 	if (bnx2fc_send_stat_req(hba))
 		return bnx2fc_stats;
-	rc = wait_for_completion_timeout(&hba->stat_req_done, (2 * HZ));
-	if (!rc) {
+	time_left = wait_for_completion_timeout(&hba->stat_req_done, (2 * HZ));
+	if (!time_left) {
 		BNX2FC_HBA_DBG(lport, "FW stat req timed out\n");
 		return bnx2fc_stats;
 	}
-- 
1.7.10.4

