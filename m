From: Michal Suchanek <msuchanek@suse.de>
Subject: [PATCH resend 1/6] delay: add poll_event_interruptible
Date: Fri, 26 Jan 2018 17:58:35 +0100
Message-ID: <a26ef20e6ff686573a0af16435f20aba186746af.1516985620.git.msuchanek@suse.de>
References: <cover.1513263482.git.msuchanek@suse.de>
 <cover.1516985620.git.msuchanek@suse.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <cover.1516985620.git.msuchanek@suse.de>
In-Reply-To: <cover.1516985620.git.msuchanek@suse.de>
References: <cover.1516985620.git.msuchanek@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Borislav Petkov <bp@alien8.de>, Tim Waugh <tim@cyberelk.net>, "David S. Miller" <davem@davemloft.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michal Suchanek <msuchanek@suse.de>, Kees Cook <keescook@chromium.org>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add convenience macro for polling an event that does not have a
waitqueue.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 include/linux/delay.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/delay.h b/include/linux/delay.h
index b78bab4395d8..3ae9fa395628 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -64,4 +64,16 @@ static inline void ssleep(unsigned int seconds)
 	msleep(seconds * 1000);
 }
 
+#define poll_event_interruptible(event, interval) ({ \
+	int ret = 0; \
+	while (!(event)) { \
+		if (signal_pending(current)) { \
+			ret = -ERESTARTSYS; \
+			break; \
+		} \
+		msleep_interruptible(interval); \
+	} \
+	ret; \
+})
+
 #endif /* defined(_LINUX_DELAY_H) */
-- 
2.13.6

