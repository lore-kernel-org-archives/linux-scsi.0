From: Michal Suchanek <msuchanek@suse.de>
Subject: [PATCH resend 6/6] cdrom: wait for drive to become ready
Date: Fri, 26 Jan 2018 17:58:40 +0100
Message-ID: <42c05eb47f17a2942cb107b5ddb2a6bd402b76e7.1516985620.git.msuchanek@suse.de>
References: <cover.1513263482.git.msuchanek@suse.de>
 <cover.1516985620.git.msuchanek@suse.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <cover.1516985620.git.msuchanek@suse.de>
In-Reply-To: <cover.1516985620.git.msuchanek@suse.de>
References: <cover.1516985620.git.msuchanek@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Borislav Petkov <bp@alien8.de>, Tim Waugh <tim@cyberelk.net>, "David S. Miller" <davem@davemloft.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michal Suchanek <msuchanek@suse.de>, Kees Cook <keescook@chromium.org>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When the drive closes it can take tens of seconds until the disc is
analyzed. Wait for the drive to become ready or report an error.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 drivers/cdrom/cdrom.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 69e85c902373..9994441f5041 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -1087,6 +1087,15 @@ int open_for_common(struct cdrom_device_info *cdi, tracktype *tracks)
 			}
 			cd_dbg(CD_OPEN, "the tray is now closed\n");
 		}
+		/* the door should be closed now, check for the disc */
+		if (ret == CDS_DRIVE_NOT_READY) {
+			int poll_res = poll_event_interruptible(
+				CDS_DRIVE_NOT_READY !=
+				(ret = cdo->drive_status(cdi, CDSL_CURRENT)),
+				500);
+			if (poll_res == -ERESTARTSYS)
+				return poll_res;
+		}
 		if (ret != CDS_DISC_OK)
 			return -ENOMEDIUM;
 	}
-- 
2.13.6

