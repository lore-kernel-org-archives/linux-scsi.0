From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 7/9] cdrom: Use struct scsi_sense_hdr internally
Date: Tue, 31 Jul 2018 12:51:52 -0700
Message-ID: <20180731195155.46664-8-keescook@chromium.org>
References: <20180731195155.46664-1-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180731195155.46664-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <keescook@chromium.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Thomas Gleixner <tglx@linutronix.de>, Philippe Ombredanne <pombredanne@nexb.com>, Stephen Boyd <sboyd@codeaurora.org>, Cyrille Pitchen <cyrille.pitchen@free-electrons.com>, Juergen Gross <jgross@suse.com>, Viresh Kumar <viresh.kumar@linaro.org>, =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pen>
List-Id: linux-scsi@vger.kernel.org

This removes more casts of struct request_sense and uses the standard
struct scsi_sense_hdr instead. This also fixes any possible stale values
since the prior code did not check the sense length.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/block/Kconfig | 2 +-
 drivers/cdrom/cdrom.c | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index ad9b687a236a..d4913516823f 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -74,12 +74,12 @@ config AMIGA_Z2RAM
 
 config CDROM
 	tristate
+	select BLK_SCSI_REQUEST
 
 config GDROM
 	tristate "SEGA Dreamcast GD-ROM drive"
 	depends on SH_DREAMCAST
 	select CDROM
-	select BLK_SCSI_REQUEST # only for the generic cdrom code
 	help
 	  A standard SEGA Dreamcast comes with a modified CD ROM drive called a
 	  "GD-ROM" by SEGA to signify it is capable of reading special disks
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 3522d2cae1b6..e547213239dc 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -282,6 +282,7 @@
 #include <linux/blkdev.h>
 #include <linux/times.h>
 #include <linux/uaccess.h>
+#include <scsi/scsi_common.h>
 #include <scsi/scsi_request.h>
 
 /* used to tell the module to turn on full debugging messages */
@@ -2222,9 +2223,12 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 
 		blk_execute_rq(q, cdi->disk, rq, 0);
 		if (scsi_req(rq)->result) {
-			struct request_sense *s = req->sense;
+			struct scsi_sense_hdr sshdr;
+
 			ret = -EIO;
-			cdi->last_sense = s->sense_key;
+			scsi_normalize_sense(req->sense, req->sense_len,
+					     &sshdr);
+			cdi->last_sense = sshdr.sense_key;
 		}
 
 		if (blk_rq_unmap_user(bio))
-- 
2.17.1
