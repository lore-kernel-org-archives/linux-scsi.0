From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 15/16] qla2xxx: Remove an unused variable from qla2x00_remove_one().
Date: Tue, 25 Jun 2013 11:27:30 -0400
Message-ID: <1372174051-4211-16-git-send-email-saurav.kashyap@qlogic.com>
References: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:4009 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752285Ab3FYPyB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jun 2013 11:54:01 -0400
Received: from mail11-co9 (localhost [127.0.0.1])	by mail11-co9-R.bigfish.com
 (Postfix) with ESMTP id 1B9EA42029B	for <linux-scsi@vger.kernel.org>; Tue, 25
 Jun 2013 15:54:01 +0000 (UTC)
Received: from CO9EHSMHS026.bigfish.com (unknown [10.236.132.232])	by
 mail11-co9.bigfish.com (Postfix) with ESMTP id 23B924E0197	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:52 +0000 (UTC)
In-Reply-To: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6df5223..3e21e9f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2979,14 +2979,12 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	set_bit(UNLOADING, &base_vha->dpc_flags);
 	mutex_lock(&ha->vport_lock);
 	while (ha->cur_vport_count) {
-		struct Scsi_Host *scsi_host;
-
 		spin_lock_irqsave(&ha->vport_slock, flags);
 
 		BUG_ON(base_vha->list.next == &ha->vp_list);
 		/* This assumes first entry in ha->vp_list is always base vha */
 		vha = list_first_entry(&base_vha->list, scsi_qla_host_t, list);
-		scsi_host = scsi_host_get(vha->host);
+		scsi_host_get(vha->host);
 
 		spin_unlock_irqrestore(&ha->vport_slock, flags);
 		mutex_unlock(&ha->vport_lock);
-- 
1.7.7


