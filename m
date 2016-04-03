From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 7/8] mmc: block: register rpmb partition with the RPMB subsystem
Date: Sun,  3 Apr 2016 12:42:51 +0300
Message-ID: <1459676572-29921-8-git-send-email-tomas.winkler@intel.com>
References: <1459676572-29921-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459676572-29921-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Joao Pinto <Joao.Pinto@synopsys.com>, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>, Alexander Usyskin <alexander.usyskin@intel.com>
List-Id: linux-scsi@vger.kernel.org

Register eMMC rpmb partition with the rpmb subsystem and provide
implementation for the RPMB access operations abstracting
actual multi step process.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/mmc/card/block.c | 289 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 289 insertions(+)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 3bdbe50a363f..441754a7d4cf 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -41,6 +41,7 @@
 #include <linux/mmc/host.h>
 #include <linux/mmc/mmc.h>
 #include <linux/mmc/sd.h>
+#include <linux/rpmb.h>
 
 #include <asm/uaccess.h>
 
@@ -111,6 +112,7 @@ struct mmc_blk_data {
 #define MMC_BLK_WRITE		BIT(1)
 #define MMC_BLK_DISCARD		BIT(2)
 #define MMC_BLK_SECDISCARD	BIT(3)
+#define MMC_BLK_RPMB		BIT(4)
 
 	/*
 	 * Only set in main mmc_blk_data associated
@@ -1138,6 +1140,289 @@ int mmc_access_rpmb(struct mmc_queue *mq)
 	return false;
 }
 
+static int mmc_rpmb_send_cmd(struct mmc_card *card,
+			     u16 rpmb_type, int data_type,
+			     u8 *buf, u16 blks)
+{
+	struct mmc_command sbc = {
+		.opcode = MMC_SET_BLOCK_COUNT,
+		.flags  = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_AC,
+	};
+
+	struct mmc_command cmd = {
+		.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_ADTC,
+	};
+
+	struct mmc_data data = {
+		.blksz = 512,
+	};
+	struct mmc_request mrq = {
+		.sbc    = &sbc,
+		.cmd    = &cmd,
+		.data   = &data,
+		.stop   = NULL,
+	};
+	struct scatterlist sg;
+	bool do_rel_wr;
+
+	/*  set CMD23 */
+	sbc.arg = blks & 0x0000FFFF;
+	do_rel_wr = (rpmb_type == RPMB_WRITE_DATA ||
+		     rpmb_type == RPMB_PROGRAM_KEY);
+
+	if (do_rel_wr)
+		sbc.arg |= MMC_CMD23_ARG_REL_WR;
+
+	/*  set CMD25/18 */
+	cmd.opcode = (data_type == MMC_DATA_WRITE) ?
+		MMC_WRITE_MULTIPLE_BLOCK : MMC_READ_MULTIPLE_BLOCK;
+
+	sg_init_one(&sg, buf, 512 * blks);
+
+	data.blocks = blks;
+	data.sg     = &sg;
+	data.sg_len = 1;
+	data.flags  = data_type;
+	mmc_set_data_timeout(&data, card);
+
+	mmc_wait_for_req(card->host, &mrq);
+
+	if (cmd.error) {
+		pr_err("%s: %s cmd error (%d)\n",
+			mmc_hostname(card->host), __func__, cmd.error);
+		return cmd.error;
+	}
+	if (data.error) {
+		pr_err("%s: %s data error (%d)\n",
+			mmc_hostname(card->host), __func__, data.error);
+		return data.error;
+	}
+	return 0;
+}
+
+static int mmc_blk_rpmb_sequence(struct mmc_card *card,
+			    struct rpmb_data *rpmbd)
+{
+	struct rpmb_frame *in_frames, *out_frames;
+	u8 *in_buf, *out_buf;
+	u16 blks;
+	u16 type;
+	int err;
+
+	in_frames = rpmbd->in_frames;
+	out_frames = rpmbd->out_frames;
+	in_buf = (u8 *)in_frames;
+	out_buf = (u8 *)out_frames;
+
+	type = rpmbd->req_type;
+	blks = be16_to_cpu(in_frames[0].block_count);
+
+	switch (type) {
+	case RPMB_PROGRAM_KEY:
+		blks = 1;
+		/* fall through */
+	case RPMB_WRITE_DATA:
+		/* STEP 1: send request to RPMB partition */
+		err = mmc_rpmb_send_cmd(card, type, MMC_DATA_WRITE,
+					in_buf, blks);
+		if (err) {
+			pr_err("%s: mmc_rpmb_send_cmd failed(%d)\n",
+				mmc_hostname(card->host), err);
+			goto out;
+		}
+
+		/* STEP 2: check write result (reuse out_frames) */
+		memset(out_frames, 0, 512);
+		out_frames[0].req_resp = cpu_to_be16(RPMB_RESULT_READ);
+		err = mmc_rpmb_send_cmd(card,
+			RPMB_RESULT_READ, MMC_DATA_WRITE, out_buf, 1);
+		if (err) {
+			pr_err("%s: mmc_rpmb_send_cmd failed(%d)\n",
+				mmc_hostname(card->host), err);
+			goto out;
+		}
+
+		/* STEP 3: get response from RPMB partition */
+		err = mmc_rpmb_send_cmd(card,
+			RPMB_READ_DATA, MMC_DATA_READ, out_buf, 1);
+
+		if (err) {
+			pr_err("%s: mmc_rpmb_send_cmd failed(%d)\n",
+				mmc_hostname(card->host), err);
+			goto out;
+		}
+		break;
+
+	case RPMB_GET_WRITE_COUNTER:
+		blks = 1;
+		/* fall through */
+	case RPMB_READ_DATA:
+		/* STEP 1: send request to RPMB partition */
+		err = mmc_rpmb_send_cmd(card, type, MMC_DATA_WRITE, in_buf, 1);
+		if (err) {
+			pr_err("%s: mmc_rpmb_send_cmd failed(%d)\n",
+				mmc_hostname(card->host), err);
+			goto out;
+		}
+
+		/* STEP 3: get response from RPMB partition */
+		err = mmc_rpmb_send_cmd(card, type, MMC_DATA_READ,
+					out_buf, blks);
+		if (err) {
+			pr_err("%s: mmc_rpmb_send_cmd failed(%d)\n",
+				mmc_hostname(card->host), err);
+			goto out;
+		}
+		break;
+
+	default:
+		err = -EINVAL;
+		goto out;
+	}
+out:
+	return err;
+}
+
+static int mmc_blk_rpmb_req_process(struct mmc_blk_data *md,
+				    struct rpmb_data *rpmbd)
+{
+	struct mmc_card *card;
+	int ret;
+
+	if (WARN_ON(!md || !rpmbd))
+		return -EINVAL;
+
+	if (!(md->flags & MMC_BLK_CMD23) ||
+	     (md->part_type != EXT_CSD_PART_CONFIG_ACC_RPMB))
+		return -EOPNOTSUPP;
+
+	card = md->queue.card;
+	if (!card || !mmc_card_mmc(card))
+		return -ENODEV;
+
+
+	pr_debug("%s rpmb request type = 0x%1x\n",
+		md->disk->disk_name, rpmbd->req_type);
+
+	mmc_get_card(card);
+
+	/* switch to RPMB partition */
+	ret = mmc_blk_part_switch(card, md);
+	if (ret) {
+		pr_err("%s: Invalid RPMB partition switch (%d)!\n",
+			mmc_hostname(card->host), ret);
+		/*
+		 * In case partition is not in user data area, make
+		 * a force partition switch.
+		 * we need reset eMMC card at here
+		 */
+		ret = mmc_blk_reset(md, card->host, MMC_BLK_RPMB);
+		if (!ret)
+			mmc_blk_reset_success(md, MMC_BLK_RPMB);
+		else
+			pr_err("%s: eMMC card reset failed (%d)\n",
+				mmc_hostname(card->host), ret);
+		goto out;
+	}
+
+	ret = mmc_blk_rpmb_sequence(card, rpmbd);
+	if (ret)
+		pr_err("%s: failed (%d) to handle RPMB request type %d!\n",
+			mmc_hostname(card->host), ret, rpmbd->req_type);
+out:
+	mmc_put_card(card);
+	return ret;
+}
+
+static int mmc_blk_rpmb_send_req(struct device *dev, struct rpmb_data *req)
+{
+	struct mmc_blk_data *md = mmc_blk_get(dev_to_disk(dev));
+	int ret;
+
+	if (!md)
+		return -ENODEV;
+
+	ret = mmc_blk_rpmb_req_process(md, req);
+
+	mmc_blk_put(md);
+
+	return ret;
+}
+
+static struct rpmb_ops mmc_rpmb_dev_ops = {
+	.send_rpmb_req = mmc_blk_rpmb_send_req,
+	.type = RPMB_TYPE_EMMC,
+};
+
+static struct mmc_blk_data *mmc_blk_rpmb_part_get(struct mmc_blk_data *md)
+{
+	struct mmc_blk_data *part_md;
+
+	if (!md)
+		return NULL;
+
+	list_for_each_entry(part_md, &md->part, part) {
+		if (part_md->area_type == MMC_BLK_DATA_AREA_RPMB)
+			return part_md;
+	}
+
+	return NULL;
+}
+
+static void mmc_blk_rpmb_unset_dev_id(struct rpmb_ops *ops)
+{
+	kfree(ops->dev_id);
+	ops->dev_id = NULL;
+}
+
+static int mmc_blk_rpmb_set_dev_id(struct rpmb_ops *ops, struct mmc_card *card)
+{
+	char *id;
+
+	id = kmalloc(sizeof(card->raw_cid), GFP_KERNEL);
+	if (!id)
+		return -ENOMEM;
+
+	memcpy(id, card->raw_cid, sizeof(card->raw_cid));
+	ops->dev_id = id;
+	ops->dev_id_len = sizeof(card->raw_cid);
+
+	return 0;
+}
+
+static void mmc_blk_rpmb_add(struct mmc_card *card)
+{
+	struct mmc_blk_data *md = dev_get_drvdata(&card->dev);
+	struct mmc_blk_data *part_md = mmc_blk_rpmb_part_get(md);
+	struct rpmb_dev *rdev;
+
+	if (!part_md)
+		return;
+
+	mmc_blk_rpmb_set_dev_id(&mmc_rpmb_dev_ops, card);
+
+	/* RPMB blocks are written in half sectors hence '* 2' */
+	mmc_rpmb_dev_ops.reliable_wr_cnt = card->ext_csd.rel_sectors * 2;
+
+	rdev = rpmb_dev_register(disk_to_dev(part_md->disk),
+				  &mmc_rpmb_dev_ops);
+	if (IS_ERR(rdev)) {
+		pr_warn("%s: cannot register to rpmb %ld\n",
+			part_md->disk->disk_name, PTR_ERR(rdev));
+	}
+}
+
+static void mmc_blk_rpmb_remove(struct mmc_card *card)
+{
+	struct mmc_blk_data *md = dev_get_drvdata(&card->dev);
+	struct mmc_blk_data *part_md = mmc_blk_rpmb_part_get(md);
+
+	if (part_md)
+		rpmb_dev_unregister(disk_to_dev(part_md->disk));
+
+	mmc_blk_rpmb_unset_dev_id(&mmc_rpmb_dev_ops);
+}
+
 static int mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
 {
 	struct mmc_blk_data *md = mq->data;
@@ -2586,6 +2871,8 @@ static int mmc_blk_probe(struct mmc_card *card)
 			goto out;
 	}
 
+	mmc_blk_rpmb_add(card);
+
 	pm_runtime_set_autosuspend_delay(&card->dev, 3000);
 	pm_runtime_use_autosuspend(&card->dev);
 
@@ -2610,6 +2897,7 @@ static void mmc_blk_remove(struct mmc_card *card)
 {
 	struct mmc_blk_data *md = dev_get_drvdata(&card->dev);
 
+	mmc_blk_rpmb_remove(card);
 	mmc_blk_remove_parts(card, md);
 	pm_runtime_get_sync(&card->dev);
 	mmc_claim_host(card->host);
@@ -2638,6 +2926,7 @@ static int _mmc_blk_suspend(struct mmc_card *card)
 
 static void mmc_blk_shutdown(struct mmc_card *card)
 {
+	mmc_blk_rpmb_remove(card);
 	_mmc_blk_suspend(card);
 }
 
-- 
2.4.3
