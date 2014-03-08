From: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3/4] sr: Add a missing KERN_INFO
Date: Sat,  8 Mar 2014 10:58:14 -0800
Message-ID: <a59d550e4e551746dffd710257ec3a5362001cd3.1394304585.git.luto@amacapital.net>
References: <cover.1394304585.git.luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1394304585.git.luto@amacapital.net>
In-Reply-To: <cover.1394304585.git.luto@amacapital.net>
References: <cover.1394304585.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The existence if scsi3-mmc capabilities is not an error.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/scsi/sr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 40d8592..67baf7f 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -887,7 +887,8 @@ static void get_capabilities(struct scsi_cd *cd)
 	cd->readcd_known = 1;
 	cd->readcd_cdda = buffer[n + 5] & 0x01;
 	/* print some capability bits */
-	printk("%s: scsi3-mmc drive: %dx/%dx %s%s%s%s%s%s\n", cd->cdi.name,
+	printk(KERN_INFO "%s: scsi3-mmc drive: %dx/%dx %s%s%s%s%s%s\n",
+	       cd->cdi.name,
 	       ((buffer[n + 14] << 8) + buffer[n + 15]) / 176,
 	       cd->cdi.speed,
 	       buffer[n + 3] & 0x01 ? "writer " : "", /* CD Writer */
-- 
1.8.5.3
