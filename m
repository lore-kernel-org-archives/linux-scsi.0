From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: [PATCH v2 1/3] sd: [BUGFIX] Use sd_printk instead of printk
Date: Fri, 22 Jul 2011 19:59:46 +0900
Message-ID: <20110722105946.7330.89242.stgit@ltc197.sdl.hitachi.co.jp>
References: <20110722105925.7330.6609.stgit@ltc197.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110722105925.7330.6609.stgit@ltc197.sdl.hitachi.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, kay.sievers@vrfy.org, jcm@redhat.com, coughlan@redhat.com, kzak@redhat.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, greg@kroah.com, dgilbert@interlog.com, stefanr@s5r6.in-berlin.de, hare@suse.de, joe@perches.com, Nao Nishijima <nao.nishijima.xt@hitachi.com>
List-Id: linux-scsi@vger.kernel.org

sd_ioctl still use printk for log output.
It should use sd_printk instead of printk, as well as other sd_*.

All SCSI messages should output via s*_printk instead of printk.

Signed-off-by: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 drivers/scsi/sd.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 953773c..e434e5f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1066,12 +1066,13 @@ static int sd_ioctl(struct block_device *bdev, fmode_t mode,
 		    unsigned int cmd, unsigned long arg)
 {
 	struct gendisk *disk = bdev->bd_disk;
-	struct scsi_device *sdp = scsi_disk(disk)->device;
+	struct scsi_disk *sdkp = scsi_disk(disk);
+	struct scsi_device *sdp = sdkp->device;
 	void __user *p = (void __user *)arg;
 	int error;
     
-	SCSI_LOG_IOCTL(1, printk("sd_ioctl: disk=%s, cmd=0x%x\n",
-						disk->disk_name, cmd));
+	SCSI_LOG_IOCTL(1, sd_printk(KERN_INFO, sdkp, "sd_ioctl: disk=%s,"
+		       " cmd=0x%x\n", disk->disk_name, cmd));
 
 	/*
 	 * If we are in the middle of error recovery, don't let anyone
