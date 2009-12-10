From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH -3rd repost 1/3] SCSI: aacraid, fix memory leak
Date: Thu, 10 Dec 2009 14:37:02 +0100
Message-ID: <1260452224-31760-1-git-send-email-jslaby@suse.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760651AbZLJNhG@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Stanse found a memory leak on one fail path in aac_send_raw_srb. Add kfree
there.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/aacraid/commctrl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 0391d75..5c9a8be 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -649,6 +649,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				     AAC_OPT_NEW_COMM) ?
 				      (dev->scsi_host_ptr->max_sectors << 9) :
 				      65536) {
+					kfree (usg);
 					rcode = -EINVAL;
 					goto cleanup;
 				}
-- 
1.6.5.5
