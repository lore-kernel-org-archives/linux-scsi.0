From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH] ses: Fix SAS device detection in enclosure
Date: Mon,  9 Jan 2017 16:33:36 -0500
Message-ID: <1483997616-18900-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35220 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932800AbdAIVdi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 9 Jan 2017 16:33:38 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 99A7531B31F
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2017 21:33:38 +0000 (UTC)
Received: from emilne.csb (dhcp-25-104.bos.redhat.com [10.18.25.104])
        by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v09LXc1w007745
        for <linux-scsi@vger.kernel.org>; Mon, 9 Jan 2017 16:33:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

The call to scsi_is_sas_rphy() needs to be made on the
SAS end_device, not on the SCSI device.

Fixes: 835831c57e9b ("ses: use scsi_is_sas_rphy instead of is_sas_attached")
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/ses.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 8c9a35c..50adabb 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -587,7 +587,7 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 
 	ses_enclosure_data_process(edev, to_scsi_device(edev->edev.parent), 0);
 
-	if (scsi_is_sas_rphy(&sdev->sdev_gendev))
+	if (scsi_is_sas_rphy(sdev->sdev_target->dev.parent))
 		efd.addr = sas_get_address(sdev);
 
 	if (efd.addr) {
-- 
1.8.3.1

