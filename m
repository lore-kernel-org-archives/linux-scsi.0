From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v2 8/8] scsi: ufs: connect to RPMB subsystem
Date: Mon,  4 Apr 2016 14:11:24 +0300
Message-ID: <1459768284-26997-9-git-send-email-tomas.winkler@intel.com>
References: <1459768284-26997-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459768284-26997-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Joao Pinto <Joao.Pinto@synopsys.com>, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>, Alexander Usyskin <alexander.usyskin@intel.com>
List-Id: linux-scsi@vger.kernel.org

Register UFS RPMB LUN with the RPMB subsystem and provide
implementation for the RPMB access operations. RPMB partition is
accessed via a sequence of security protocol in and security protocol
out commands with UFS specific parameters. This multi step process is
abstracted into 4 basic RPMB commands.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2: resend
 drivers/scsi/ufs/ufshcd.c | 219 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h |   2 +
 2 files changed, 221 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f8fa72c31a9d..c087e9713db3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -37,10 +37,13 @@
  * license terms, and distributes only under these terms.
  */
 
+#include <asm/unaligned.h>
 #include <linux/async.h>
 #include <linux/devfreq.h>
 #include <linux/nls.h>
 #include <linux/of.h>
+#include <linux/rpmb.h>
+
 #include "ufshcd.h"
 #include "ufs_quirks.h"
 #include "unipro.h"
@@ -4744,6 +4747,214 @@ static void ufshcd_init_icc_levels(struct ufs_hba *hba)
 
 }
 
+#define SEC_PROTOCOL_UFS  0xEC
+#define   SEC_SPECIFIC_UFS_RPMB 0x0001
+
+#define SEC_PROTOCOL_CMD_SIZE 12
+#define SEC_PROTOCOL_RETRIES 3
+#define SEC_PROTOCOL_RETRIES_ON_RESET 10
+#define SEC_PROTOCOL_TIMEOUT msecs_to_jiffies(1000)
+
+static int
+ufshcd_rpmb_security_out(struct scsi_device *sdev,
+			 struct rpmb_frame *frames, u32 cnt)
+{
+	struct scsi_sense_hdr sshdr;
+	u32 trans_len = cnt * sizeof(struct rpmb_frame);
+	int reset_retries = SEC_PROTOCOL_RETRIES_ON_RESET;
+	int ret;
+	u8 cmd[SEC_PROTOCOL_CMD_SIZE];
+
+retry:
+	memset(cmd, 0, SEC_PROTOCOL_CMD_SIZE);
+	cmd[0] = SECURITY_PROTOCOL_OUT;
+	cmd[1] = SEC_PROTOCOL_UFS;
+	put_unaligned_be16(SEC_SPECIFIC_UFS_RPMB, cmd + 2);
+	cmd[4] = 0;                              /* inc_512 bit 7 set to 0 */
+	put_unaligned_be32(trans_len, cmd + 6);  /* transfer length */
+
+	ret = scsi_execute_req_flags(sdev, cmd, DMA_TO_DEVICE,
+				     frames, trans_len, &sshdr,
+				     SEC_PROTOCOL_TIMEOUT, SEC_PROTOCOL_RETRIES,
+				     NULL, 0);
+	if (ret && scsi_sense_valid(&sshdr) &&
+	    sshdr.sense_key == UNIT_ATTENTION &&
+	    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
+		/* Device reset might occur several times,
+		 * give it one more chance
+		 */
+		if (--reset_retries > 0)
+			goto retry;
+
+	if (ret)
+		pr_err("%s: failed with err %0x\n", __func__, ret);
+
+	if (driver_byte(ret) & DRIVER_SENSE)
+		scsi_print_sense_hdr(sdev, "rpmb: security out", &sshdr);
+
+	return ret;
+}
+
+static int
+ufshcd_rpmb_security_in(struct scsi_device *sdev,
+			struct rpmb_frame *frames, u32 cnt)
+{
+	struct scsi_sense_hdr sshdr;
+	u32 alloc_len = cnt * sizeof(struct rpmb_frame);
+	int reset_retries = SEC_PROTOCOL_RETRIES_ON_RESET;
+	int ret;
+	u8 cmd[SEC_PROTOCOL_CMD_SIZE];
+
+retry:
+	memset(cmd, 0, SEC_PROTOCOL_CMD_SIZE);
+	cmd[0] = SECURITY_PROTOCOL_IN;
+	cmd[1] = SEC_PROTOCOL_UFS;
+	put_unaligned_be16(SEC_SPECIFIC_UFS_RPMB, cmd + 2);
+	cmd[4] = 0;                             /* inc_512 bit 7 set to 0 */
+	put_unaligned_be32(alloc_len, cmd + 6); /* allocation length */
+
+	ret = scsi_execute_req_flags(sdev, cmd, DMA_FROM_DEVICE,
+				     frames, alloc_len, &sshdr,
+				     SEC_PROTOCOL_TIMEOUT, SEC_PROTOCOL_RETRIES,
+				     NULL, 0);
+	if (ret && scsi_sense_valid(&sshdr) &&
+	    sshdr.sense_key == UNIT_ATTENTION &&
+	    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
+		/* Device reset might occur several times,
+		 * give it one more chance
+		 */
+		if (--reset_retries > 0)
+			goto retry;
+
+	if (ret)
+		pr_err("%s: failed with err %0x\n", __func__, ret);
+
+	if (driver_byte(ret) & DRIVER_SENSE)
+		scsi_print_sense_hdr(sdev, "rpmb: security in", &sshdr);
+
+	return ret;
+}
+
+
+static int ufshcd_rpmb_send_req(struct device *dev, struct rpmb_data *rpmbd)
+{
+	unsigned long flags;
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct scsi_device *sdev;
+	struct rpmb_frame *in_frames, *out_frames;
+	u16 blks;
+	u16 type;
+	int ret;
+
+	in_frames = rpmbd->in_frames;
+	out_frames = rpmbd->out_frames;
+
+	type = rpmbd->req_type;
+	blks = be16_to_cpu(in_frames[0].block_count);
+
+	dev_dbg(hba->dev, "RPMB : type = %d, blocks = %d\n", type, blks);
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	sdev = hba->sdev_ufs_rpmb;
+	if (sdev) {
+		ret = scsi_device_get(sdev);
+		if (!ret && !scsi_device_online(sdev)) {
+			ret = -ENODEV;
+			scsi_device_put(sdev);
+		}
+	} else {
+		ret = -ENODEV;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	if (ret)
+		return ret;
+
+	switch (type) {
+	case RPMB_PROGRAM_KEY:
+		blks = 1;
+		/* fall through */
+	case RPMB_WRITE_DATA:
+		/* STEP 1: send request to RPMB partition */
+		ret = ufshcd_rpmb_security_out(sdev, in_frames, blks);
+		if (ret)
+			break;
+
+		/* STEP 2: check write result (reuse out_frames) */
+		memset(out_frames, 0, 512);
+		out_frames[0].req_resp = cpu_to_be16(RPMB_RESULT_READ);
+		ret = ufshcd_rpmb_security_out(sdev, out_frames, 1);
+		if (ret)
+			break;
+
+		/* STEP 3: get response from RPMB partition */
+		ret = ufshcd_rpmb_security_in(sdev, out_frames, 1);
+		if (ret)
+			break;
+
+		break;
+	case RPMB_GET_WRITE_COUNTER:
+		blks = 1;
+		/* fall through */
+	case RPMB_READ_DATA:
+		/* STEP 1: send request to RPMB partition */
+		ret = ufshcd_rpmb_security_out(sdev, in_frames, 1);
+		if (ret)
+			break;
+		/* STEP 2: get response from RPMB partition */
+		ret = ufshcd_rpmb_security_in(sdev, out_frames, blks);
+		if (ret)
+			break;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	scsi_device_put(sdev);
+	return ret;
+}
+
+static struct rpmb_ops ufshcd_rpmb_dev_ops = {
+	.send_rpmb_req = ufshcd_rpmb_send_req,
+	.type = RPMB_TYPE_UFS,
+};
+
+static inline void ufshcd_rpmb_add(struct ufs_hba *hba)
+{
+	struct rpmb_dev *rdev;
+
+	scsi_device_get(hba->sdev_ufs_rpmb);
+	rdev = rpmb_dev_register(hba->dev, &ufshcd_rpmb_dev_ops);
+	if (IS_ERR(rdev)) {
+		dev_warn(hba->dev, "%s: cannot register to rpmb %ld\n",
+			 dev_name(hba->dev), PTR_ERR(rdev));
+		goto out_put_dev;
+	}
+
+	return;
+
+out_put_dev:
+	scsi_device_put(hba->sdev_ufs_rpmb);
+	hba->sdev_ufs_rpmb = NULL;
+}
+
+static inline void ufshcd_rpmb_remove(struct ufs_hba *hba)
+{
+	unsigned long flags;
+
+	if (!hba->sdev_ufs_rpmb)
+		return;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+
+	rpmb_dev_unregister(hba->dev);
+	scsi_device_put(hba->sdev_ufs_rpmb);
+	hba->sdev_ufs_rpmb = NULL;
+
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+}
+
+
 /**
  * ufshcd_scsi_add_wlus - Adds required W-LUs
  * @hba: per-adapter instance
@@ -4799,7 +5010,11 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 		ret = PTR_ERR(sdev_rpmb);
 		goto remove_sdev_boot;
 	}
+	hba->sdev_ufs_rpmb = sdev_rpmb;
+
+	ufshcd_rpmb_add(hba);
 	scsi_device_put(sdev_rpmb);
+
 	goto out;
 
 remove_sdev_boot:
@@ -6168,6 +6383,8 @@ int ufshcd_shutdown(struct ufs_hba *hba)
 			goto out;
 	}
 
+	ufshcd_rpmb_remove(hba);
+
 	ret = ufshcd_suspend(hba, UFS_SHUTDOWN_PM);
 out:
 	if (ret)
@@ -6184,6 +6401,8 @@ EXPORT_SYMBOL(ufshcd_shutdown);
  */
 void ufshcd_remove(struct ufs_hba *hba)
 {
+	ufshcd_rpmb_remove(hba);
+
 	scsi_remove_host(hba->host);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 4bb65669f052..92bfddf80ae8 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -346,6 +346,7 @@ struct ufs_init_prefetch {
  * @utmrdl_dma_addr: UTMRDL DMA address
  * @host: Scsi_Host instance of the driver
  * @dev: device handle
+ * @sdev_ufs_rpmb: reference to RPMB device W-LU
  * @lrb: local reference block
  * @lrb_in_use: lrb in use
  * @outstanding_tasks: Bits representing outstanding task requests
@@ -408,6 +409,7 @@ struct ufs_hba {
 	 * "UFS device" W-LU.
 	 */
 	struct scsi_device *sdev_ufs_device;
+	struct scsi_device *sdev_ufs_rpmb;
 
 	enum ufs_dev_pwr_mode curr_dev_pwr_mode;
 	enum uic_link_state uic_link_state;
-- 
2.4.3
