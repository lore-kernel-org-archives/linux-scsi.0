From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 8/9] libata-scsi: Move sense buffers onto stack
Date: Tue, 31 Jul 2018 12:51:53 -0700
Message-ID: <20180731195155.46664-9-keescook@chromium.org>
References: <20180731195155.46664-1-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180731195155.46664-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <keescook@chromium.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Thomas Gleixner <tglx@linutronix.de>, Philippe Ombredanne <pombredanne@nexb.com>, Stephen Boyd <sboyd@codeaurora.org>, Cyrille Pitchen <cyrille.pitchen@free-electrons.com>, Juergen Gross <jgross@suse.com>, Viresh Kumar <viresh.kumar@linaro.org>, =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pen>
List-Id: linux-scsi@vger.kernel.org

To support future compile-time sizeof() checks that will be able to
validate the length of sense buffers, this removes the only dynamically
allocated sense buffers in the tree by putting the 96 byte sense buffers
on the stack.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/ata/libata-scsi.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 89a9d4a2efc8..3a43d3a1ce2d 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -597,8 +597,9 @@ static int ata_get_identity(struct ata_port *ap, struct scsi_device *sdev,
 int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 {
 	int rc = 0;
+	u8 sensebuf[SCSI_SENSE_BUFFERSIZE];
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
-	u8 args[4], *argbuf = NULL, *sensebuf = NULL;
+	u8 args[4], *argbuf = NULL;
 	int argsize = 0;
 	enum dma_data_direction data_dir;
 	struct scsi_sense_hdr sshdr;
@@ -610,10 +611,7 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	if (copy_from_user(args, arg, sizeof(args)))
 		return -EFAULT;
 
-	sensebuf = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
-	if (!sensebuf)
-		return -ENOMEM;
-
+	memset(sensebuf, 0, sizeof(sensebuf));
 	memset(scsi_cmd, 0, sizeof(scsi_cmd));
 
 	if (args[3]) {
@@ -685,7 +683,6 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	 && copy_to_user(arg + sizeof(args), argbuf, argsize))
 		rc = -EFAULT;
 error:
-	kfree(sensebuf);
 	kfree(argbuf);
 	return rc;
 }
@@ -704,8 +701,9 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 {
 	int rc = 0;
+	u8 sensebuf[SCSI_SENSE_BUFFERSIZE];
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
-	u8 args[7], *sensebuf = NULL;
+	u8 args[7];
 	struct scsi_sense_hdr sshdr;
 	int cmd_result;
 
@@ -715,10 +713,7 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	if (copy_from_user(args, arg, sizeof(args)))
 		return -EFAULT;
 
-	sensebuf = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
-	if (!sensebuf)
-		return -ENOMEM;
-
+	memset(sensebuf, 0, sizeof(sensebuf));
 	memset(scsi_cmd, 0, sizeof(scsi_cmd));
 	scsi_cmd[0]  = ATA_16;
 	scsi_cmd[1]  = (3 << 1); /* Non-data */
@@ -769,7 +764,6 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	}
 
  error:
-	kfree(sensebuf);
 	return rc;
 }
 
-- 
2.17.1
