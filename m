From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] [SCSI] mpt3sas: don't leak 'fw_event' in
 mpt3sas_send_trigger_data_event()
Date: Mon, 30 Sep 2013 22:01:23 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1309302158340.4992@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPTFusionLinux@lsi.com, support@lsi.com, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
List-Id: linux-scsi@vger.kernel.org

If we successfully allocate 'fw_event' but subsequently fail to
allocate 'fw_event->event_data' then we'll return from the function
without properly freeing 'fw_event'.
This patch takes care of that leak.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a961fe1..e90fbf3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2518,8 +2518,10 @@ mpt3sas_send_trigger_data_event(struct MPT3SAS_ADAPTER *ioc,
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
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
