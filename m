From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2] scsi: esas2r: fix potential format string flaw
Date: Wed, 18 Dec 2013 10:00:54 -0800
Message-ID: <20131218180054.GA5739@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Bradley Grove <linuxdrivers@attotech.com>, Joe Perches <joe@perches.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This makes sure format strings cannot leak into the printk call via the
constructed buffer.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Bradley Grove <bgrove@attotech.com>
---
v2:
 - add newline via printk instead.
---
 drivers/scsi/esas2r/esas2r_log.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_log.c b/drivers/scsi/esas2r/esas2r_log.c
index 9bf285df58dd..a82030aa8577 100644
--- a/drivers/scsi/esas2r/esas2r_log.c
+++ b/drivers/scsi/esas2r/esas2r_log.c
@@ -165,13 +165,9 @@ static int esas2r_log_master(const long level,
 
 		/*
 		 * Put a line break at the end of the formatted string so that
-		 * we don't wind up with run-on messages.  only append if there
-		 * is enough space in the buffer.
+		 * we don't wind up with run-on messages.
 		 */
-		if (strlen(event_buffer) < buflen)
-			strcat(buffer, "\n");
-
-		printk(event_buffer);
+		printk("%s\n", event_buffer);
 
 		spin_unlock_irqrestore(&event_buffer_lock, flags);
 	}
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
