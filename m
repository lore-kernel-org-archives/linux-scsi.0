From: Scott Wood <scottwood@freescale.com>
Subject: [PATCH 17/22] esp_scsi: %pF is only for function pointers
Date: Wed, 11 Mar 2015 22:13:52 -0500
Message-ID: <1426130037-17956-17-git-send-email-scottwood@freescale.com>
References: <1426130037-17956-1-git-send-email-scottwood@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426130037-17956-1-git-send-email-scottwood@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: Scott Wood <scottwood@freescale.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Use %pS for actual addresses, otherwise you'll get bad output
on arches like ppc64 where %pF expects a function descriptor.

Signed-off-by: Scott Wood <scottwood@freescale.com>
Cc: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/esp_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 065b25d..dba5f10 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -1034,7 +1034,7 @@ static int esp_check_spur_intr(struct esp *esp)
 
 static void esp_schedule_reset(struct esp *esp)
 {
-	esp_log_reset("esp_schedule_reset() from %pf\n",
+	esp_log_reset("esp_schedule_reset() from %ps\n",
 		      __builtin_return_address(0));
 	esp->flags |= ESP_FLAG_RESETTING;
 	esp_event(esp, ESP_EVENT_RESET);
-- 
2.1.0
