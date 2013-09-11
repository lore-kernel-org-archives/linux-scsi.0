From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi: esas2r: fix potential format string flaw
Date: Tue, 10 Sep 2013 21:38:48 -0700
Message-ID: <20130911043848.GA17221@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Bradley Grove <linuxdrivers@attotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This makes sure format strings cannot leak into the printk call via the
constructed buffer.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/esas2r/esas2r_log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/esas2r/esas2r_log.c b/drivers/scsi/esas2r/esas2r_log.c
index 9bf285d..61fc19d 100644
--- a/drivers/scsi/esas2r/esas2r_log.c
+++ b/drivers/scsi/esas2r/esas2r_log.c
@@ -171,7 +171,7 @@ static int esas2r_log_master(const long level,
 		if (strlen(event_buffer) < buflen)
 			strcat(buffer, "\n");
 
-		printk(event_buffer);
+		printk("%s", event_buffer);
 
 		spin_unlock_irqrestore(&event_buffer_lock, flags);
 	}
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
