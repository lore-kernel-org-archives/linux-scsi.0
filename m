From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 04/16] qla2xxx: Do not query FC statistics during chip reset.
Date: Tue, 25 Jun 2013 11:27:19 -0400
Message-ID: <1372174051-4211-5-git-send-email-saurav.kashyap@qlogic.com>
References: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:19902 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118Ab3FYPx5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jun 2013 11:53:57 -0400
Received: from mail151-tx2 (localhost [127.0.0.1])	by
 mail151-tx2-R.bigfish.com (Postfix) with ESMTP id 70640340185	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:56 +0000 (UTC)
Received: from TX2EHSMHS027.bigfish.com (unknown [10.9.14.226])	by
 mail151-tx2.bigfish.com (Postfix) with ESMTP id 586124E005A	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:49 +0000 (UTC)
In-Reply-To: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

During a chip reset, the mailbox call to get FC statistics from the ISP will
not work resulting in needless mailbox accesses and errors printing out:

qla2xxx [0000:05:00.0]-00af:11: Performing ISP error recovery - ha=ffff881fad044800.
qla2xxx [0000:05:00.0]-1020:11: **** Failed mbx[0]=4001, mb[1]=4953, mb[2]=5020, mb[3]=b100, cmd=6d ****.
qla2xxx [0000:05:00.0]-1020:11: **** Failed mbx[0]=4001, mb[1]=4953, mb[2]=5020, mb[3]=b100, cmd=6d ****.
qla2xxx [0000:05:00.0]-1020:11: **** Failed mbx[0]=4001, mb[1]=4953, mb[2]=5020, mb[3]=b100, cmd=6d ****.
qla2xxx [0000:05:00.0]-1020:11: **** Failed mbx[0]=4001, mb[1]=4953, mb[2]=5020, mb[3]=b100, cmd=6d ****.
qla2xxx [0000:05:00.0]-1020:11: **** Failed mbx[0]=4001, mb[1]=4953, mb[2]=5020, mb[3]=b100, cmd=6d ****.

To prevent this, check for a chip reset when an application queries for FC
stats and return immediately if a chip reset is occurring.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index bf60c63..d7a99ae 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1691,6 +1691,9 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 	if (unlikely(pci_channel_offline(ha->pdev)))
 		goto done;
 
+	if (qla2x00_reset_active(vha))
+		goto done;
+
 	stats = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &stats_dma);
 	if (stats == NULL) {
 		ql_log(ql_log_warn, vha, 0x707d,
@@ -1703,7 +1706,7 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 	if (IS_FWI2_CAPABLE(ha)) {
 		rval = qla24xx_get_isp_stats(base_vha, stats, stats_dma);
 	} else if (atomic_read(&base_vha->loop_state) == LOOP_READY &&
-	    !qla2x00_reset_active(vha) && !ha->dpc_active) {
+	    !ha->dpc_active) {
 		/* Must be in a 'READY' state for statistics retrieval. */
 		rval = qla2x00_get_link_status(base_vha, base_vha->loop_id,
 						stats, stats_dma);
-- 
1.7.7


