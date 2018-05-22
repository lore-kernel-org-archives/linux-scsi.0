From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 2/6] scsi: cxlflash: Drop unused sense buffers
Date: Tue, 22 May 2018 11:15:08 -0700
Message-ID: <20180522181512.39316-3-keescook@chromium.org>
References: <20180522181512.39316-1-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180522181512.39316-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <keescook@chromium.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This removes the unused sense buffer in read_cap16() and write_same16().

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/cxlflash/superpipe.c | 8 ++------
 drivers/scsi/cxlflash/vlun.c      | 7 ++-----
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 2fe79df5c73c..59b9f2023748 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -324,7 +324,6 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	struct scsi_sense_hdr sshdr;
 	u8 *cmd_buf = NULL;
 	u8 *scsi_cmd = NULL;
-	u8 *sense_buf = NULL;
 	int rc = 0;
 	int result = 0;
 	int retry_cnt = 0;
@@ -333,8 +332,7 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 retry:
 	cmd_buf = kzalloc(CMD_BUFSIZE, GFP_KERNEL);
 	scsi_cmd = kzalloc(MAX_COMMAND_SIZE, GFP_KERNEL);
-	sense_buf = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
-	if (unlikely(!cmd_buf || !scsi_cmd || !sense_buf)) {
+	if (unlikely(!cmd_buf || !scsi_cmd)) {
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -349,7 +347,7 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	/* Drop the ioctl read semahpore across lengthy call */
 	up_read(&cfg->ioctl_rwsem);
 	result = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
-			      CMD_BUFSIZE, sense_buf, &sshdr, to, CMD_RETRIES,
+			      CMD_BUFSIZE, NULL, &sshdr, to, CMD_RETRIES,
 			      0, 0, NULL);
 	down_read(&cfg->ioctl_rwsem);
 	rc = check_state(cfg);
@@ -380,7 +378,6 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 					if (retry_cnt++ < 1) {
 						kfree(cmd_buf);
 						kfree(scsi_cmd);
-						kfree(sense_buf);
 						goto retry;
 					}
 				}
@@ -411,7 +408,6 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 out:
 	kfree(cmd_buf);
 	kfree(scsi_cmd);
-	kfree(sense_buf);
 
 	dev_dbg(dev, "%s: maxlba=%lld blklen=%d rc=%d\n",
 		__func__, gli->max_lba, gli->blk_len, rc);
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 5deef57a7834..e7e9b2f2ad21 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -425,7 +425,6 @@ static int write_same16(struct scsi_device *sdev,
 {
 	u8 *cmd_buf = NULL;
 	u8 *scsi_cmd = NULL;
-	u8 *sense_buf = NULL;
 	int rc = 0;
 	int result = 0;
 	u64 offset = lba;
@@ -439,8 +438,7 @@ static int write_same16(struct scsi_device *sdev,
 
 	cmd_buf = kzalloc(CMD_BUFSIZE, GFP_KERNEL);
 	scsi_cmd = kzalloc(MAX_COMMAND_SIZE, GFP_KERNEL);
-	sense_buf = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
-	if (unlikely(!cmd_buf || !scsi_cmd || !sense_buf)) {
+	if (unlikely(!cmd_buf || !scsi_cmd)) {
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -456,7 +454,7 @@ static int write_same16(struct scsi_device *sdev,
 		/* Drop the ioctl read semahpore across lengthy call */
 		up_read(&cfg->ioctl_rwsem);
 		result = scsi_execute(sdev, scsi_cmd, DMA_TO_DEVICE, cmd_buf,
-				      CMD_BUFSIZE, sense_buf, NULL, to,
+				      CMD_BUFSIZE, NULL, NULL, to,
 				      CMD_RETRIES, 0, 0, NULL);
 		down_read(&cfg->ioctl_rwsem);
 		rc = check_state(cfg);
@@ -481,7 +479,6 @@ static int write_same16(struct scsi_device *sdev,
 out:
 	kfree(cmd_buf);
 	kfree(scsi_cmd);
-	kfree(sense_buf);
 	dev_dbg(dev, "%s: returning rc=%d\n", __func__, rc);
 	return rc;
 }
-- 
2.17.0
