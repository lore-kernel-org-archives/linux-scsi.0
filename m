From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH v4 06/10] scsi: Move schedule_work() call to be outside lock
Date: Thu,  1 Aug 2013 16:57:35 -0400
Message-ID: <1375390659-12495-7-git-send-email-emilne@redhat.com>
References: <1375390659-12495-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757239Ab3HAU5q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Aug 2013 16:57:46 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r71Kvk8D014955
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 1 Aug 2013 16:57:46 -0400
Received: from emilne.csb ([10.18.25.104])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r71Kvgvf031004
	for <linux-scsi@vger.kernel.org>; Thu, 1 Aug 2013 16:57:45 -0400
In-Reply-To: <1375390659-12495-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

The call to schedule_work() in sdev_evt_send() should
not be made while the sdev->list_lock is held.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 97699a5..f871ecf 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2255,8 +2255,8 @@ void sdev_evt_send(struct scsi_device *sdev, struct scsi_event *evt)
 
 	spin_lock_irqsave(&sdev->list_lock, flags);
 	list_add_tail(&evt->node, &sdev->event_list);
-	schedule_work(&sdev->event_work);
 	spin_unlock_irqrestore(&sdev->list_lock, flags);
+	schedule_work(&sdev->event_work);
 }
 EXPORT_SYMBOL_GPL(sdev_evt_send);
 
-- 
1.7.11.7

