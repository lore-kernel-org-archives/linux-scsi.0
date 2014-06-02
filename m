From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 3/4] mpt3sas: fix possible memory leak in mpt3sas_send_trigger_data_event
Date: Mon, 2 Jun 2014 10:37:26 -0400
Message-ID: <1401719846-18446-1-git-send-email-joe.lawrence@stratus.com>
References: <1401719672-18352-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o144.mxlogic.net ([208.65.145.77]:33970 "EHLO
	p02c12o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbaFBOho (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 10:37:44 -0400
In-Reply-To: <1401719672-18352-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, Joe Lawrence <joe.lawrence@stratus.com>

If mpt3sas_send_trigger_data_event exits early without inserting a
fw_event, be sure to undo any prior allocations.

This fixes the following smatch warning:

  drivers/scsi/mpt3sas/mpt3sas_scsih.c:2522
    mpt3sas_send_trigger_data_event() warn: possible memory leak of
    'fw_event'

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index e6f0720..25e3a22 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2520,8 +2520,10 @@ mpt3sas_send_trigger_data_event(struct MPT3SAS_ADAPTER *ioc,
 	if (!fw_event)
 		return;
 	fw_event->event_data = kzalloc(sizeof(*event_data), GFP_ATOMIC);
-	if (!fw_event->event_data)
+	if (!fw_event->event_data) {
+		kfree(fw_event);
 		return;
+	}
 	fw_event->event = MPT3SAS_PROCESS_TRIGGER_DIAG;
 	fw_event->ioc = ioc;
 	memcpy(fw_event->event_data, event_data, sizeof(*event_data));
-- 
1.7.10.4

