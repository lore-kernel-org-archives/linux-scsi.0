Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA22C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF96C6146D
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384119AbhCDAbj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349119AbhCCN4c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 08:56:32 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BD3C0611C2
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 05:55:07 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id j2so10923312wrx.9
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 05:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HCnjHWCo/Q+bojTy7byBJ3tyq3PAWYgoo0RiPlZgCx8=;
        b=eM6j6sHD8iQR88/l5k52Vjbo6tLW/vfWt4PrURyyXxxIMpNZFM6pTi3/0eWgzDctxk
         x2YL5bv03zGQelKM5mRJvn/U5TWhT4YJSWOHh5Jg3gLhmB5eF18YaQAFbodRKw9S8W7e
         /3KuHpHx0xnb7mVRw4K29Za0CmfY7KY/BNzdJ8pI1cwajO4m6k6JKm+x8gj8g8MOHmpw
         OGfFrzvX3D90S7iBwaR1cXoZwhxJddXZGXKoQU/Eb9POoAU1sXL2cW7F0fgh0kQtmSHs
         C6clHKEF82LkPySj+3ekBr/u014f6wnIcRR81DLCt3ryvIOFFl8sHDQNBrxZvu8rLxdR
         S92A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HCnjHWCo/Q+bojTy7byBJ3tyq3PAWYgoo0RiPlZgCx8=;
        b=nBJzbKIm+LK0O2g7PkTcH6I6PKLNXuVcME4tTvAhyMeNFxKs78rqlgru06gH7jDmdU
         V5N7YFZNyCiDrHNVGm9SKkn+lEKdDn9FfR5wE4bivT5TBCl4XGDw3btnmYnO92CqI+Fb
         sFuzNtSqJHm/yet3bx2NUh07CKw/Es6PUlvW1myH7UyEFaKP80TTn/84J2+7EUJoNXwX
         Ial9Lh21nZcFwFeamMg7HEYZvDOQwD01jT5aVDMgFDg2E2Y5nN0VqedI7wRr9I1B4O6O
         5i2XzHg0jZi4wLRPd89n2eHyMCaT/tqEIVkzbIFGzkz6Ih6CCZCycZe8c1cQtf8hLq/F
         iWHg==
X-Gm-Message-State: AOAM531MlDtbsUshVQQQpErO8JFiWbir2wgiS37Gfdpu2Ypvtw2ZfP1z
        wJTyY0tUDazZ7rHDyutIDO09AA==
X-Google-Smtp-Source: ABdhPJwlAh9tNhxULFZF16PZlGBU2V90owZCRl8FCwlJucyHY5D9KQP00fmYRJZAkLW3VyZkOYFlUQ==
X-Received: by 2002:adf:f587:: with SMTP id f7mr16082253wro.147.1614779706553;
        Wed, 03 Mar 2021 05:55:06 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id a21sm7759875wmb.5.2021.03.03.05.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 05:55:01 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id C5CAC1FF90;
        Wed,  3 Mar 2021 13:55:00 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     linux-kernel@vger.kernel.org
Cc:     maxim.uvarov@linaro.org, joakim.bech@linaro.org,
        ilias.apalodimas@linaro.org, arnd@linaro.org,
        ruchika.gupta@linaro.org, tomas.winkler@intel.com,
        yang.huang@intel.com, bing.zhu@intel.com,
        Matti.Moell@opensynergy.com, hmo@opensynergy.com,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [RFC PATCH  4/5] rpmb: create virtio rpmb frontend driver [WIP]
Date:   Wed,  3 Mar 2021 13:54:59 +0000
Message-Id: <20210303135500.24673-5-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210303135500.24673-1-alex.bennee@linaro.org>
References: <20210303135500.24673-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This implements a virtio rpmb frontend driver for the RPMB subsystem.

[AJB: the principle difference is all the MAC calculation and
validation is now done in the driver]

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Tomas Winkler <tomas.winkler@intel.com>

---
ajb:
  - add include linux/slab.h for kzalloc
  - include standardised VIRTIO_ID_RPMB
  - remove extra frames when sending commands down virtqueue
  - clean up out/in sgs - hopefully more conforming
  - remove cmd_cap code
---
 drivers/char/rpmb/Kconfig        |  10 +
 drivers/char/rpmb/Makefile       |   1 +
 drivers/char/rpmb/virtio_rpmb.c  | 366 +++++++++++++++++++++++++++++++
 include/uapi/linux/virtio_ids.h  |   1 +
 include/uapi/linux/virtio_rpmb.h |  54 +++++
 5 files changed, 432 insertions(+)
 create mode 100644 drivers/char/rpmb/virtio_rpmb.c
 create mode 100644 include/uapi/linux/virtio_rpmb.h

diff --git a/drivers/char/rpmb/Kconfig b/drivers/char/rpmb/Kconfig
index 9068664a399a..845f458452a5 100644
--- a/drivers/char/rpmb/Kconfig
+++ b/drivers/char/rpmb/Kconfig
@@ -16,3 +16,13 @@ config RPMB_INTF_DEV
 	help
 	  Say yes here if you want to access RPMB from user space
 	  via character device interface /dev/rpmb%d
+
+config VIRTIO_RPMB
+	tristate "Virtio RPMB character device interface /dev/vrpmb"
+	default n
+	depends on VIRTIO && KEYS
+	select RPMB
+	help
+	  Say yes here if you want to access virtio RPMB from user space
+	  via character device interface /dev/vrpmb.
+	  This device interface is only for guest/frontend virtio driver.
diff --git a/drivers/char/rpmb/Makefile b/drivers/char/rpmb/Makefile
index f54b3f30514b..4b397b50a42c 100644
--- a/drivers/char/rpmb/Makefile
+++ b/drivers/char/rpmb/Makefile
@@ -4,5 +4,6 @@
 obj-$(CONFIG_RPMB) += rpmb.o
 rpmb-objs += core.o
 rpmb-$(CONFIG_RPMB_INTF_DEV) += cdev.o
+obj-$(CONFIG_VIRTIO_RPMB) += virtio_rpmb.o
 
 ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/char/rpmb/virtio_rpmb.c b/drivers/char/rpmb/virtio_rpmb.c
new file mode 100644
index 000000000000..6ade26874a4e
--- /dev/null
+++ b/drivers/char/rpmb/virtio_rpmb.c
@@ -0,0 +1,366 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Virtio RPMB Front End Driver
+ *
+ * Copyright (c) 2018-2019 Intel Corporation.
+ * Copyright (c) 2021 Linaro Ltd.
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/err.h>
+#include <linux/scatterlist.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/virtio.h>
+#include <linux/module.h>
+#include <linux/virtio_ids.h>
+#include <linux/fs.h>
+#include <linux/virtio_config.h>
+#include <linux/virtio_rpmb.h>
+#include <linux/uaccess.h>
+#include <linux/key.h>
+#include <linux/rpmb.h>
+
+#define RPMB_MAC_SIZE 32
+
+static const char id[] = "RPMB:VIRTIO";
+
+struct virtio_rpmb_info {
+	struct virtqueue *vq;
+	struct mutex lock; /* info lock */
+	wait_queue_head_t have_data;
+	struct rpmb_dev *rdev;
+};
+
+static void virtio_rpmb_recv_done(struct virtqueue *vq)
+{
+	struct virtio_rpmb_info *vi;
+	struct virtio_device *vdev = vq->vdev;
+
+	vi = vq->vdev->priv;
+	if (!vi) {
+		dev_err(&vdev->dev, "Error: no found vi data.\n");
+		return;
+	}
+
+	wake_up(&vi->have_data);
+}
+
+/* static int rpmb_virtio_cmd_seq(struct device *dev, u8 target, */
+/* 			       struct rpmb_cmd *cmds, u32 ncmds) */
+/* { */
+/* 	struct virtio_device *vdev = dev_to_virtio(dev); */
+/* 	struct virtio_rpmb_info *vi = vdev->priv; */
+/* 	unsigned int i; */
+/* 	struct scatterlist out_frames[3]; */
+/* 	struct scatterlist in_frames[3]; */
+/* 	struct scatterlist *sgs[3]; */
+/* 	unsigned int num_out = 0, num_in = 0; */
+/* 	size_t sz; */
+/* 	int ret; */
+/* 	unsigned int len; */
+
+/* 	if (ncmds > RPMB_SEQ_CMD_MAX) */
+/* 		return -EINVAL; */
+
+/* 	mutex_lock(&vi->lock); */
+
+/* 	/\* */
+/* 	 * Process the frames - putting in the appropriate out_frames */
+/* 	 * and in_frames before we build our final ordered sgs[] out */
+/* 	 * array. */
+/* 	 *\/ */
+/* 	for (i = 0; i < ncmds; i++) { */
+/* 		struct rpmb_cmd *cmd = &cmds[i]; */
+/* 		sz = sizeof(struct rpmb_frame_jdec) * (cmd->nframes ?: 1); */
+/* 		if (cmd->flags) { */
+/* 			sg_init_one(&out_frames[num_out++], cmd->frames, sz); */
+/* 		} else { */
+/* 			sg_init_one(&in_frames[num_in++], cmd->frames, sz); */
+/* 		} */
+/* 	} */
+
+/* 	for (i = 0; i < num_out; i++) { */
+/* 		sgs[i] = &out_frames[i]; */
+/* 	} */
+/* 	for (i = 0; i < num_in; i++) { */
+/* 		sgs[num_out + i] = &in_frames[i]; */
+/* 	} */
+
+/* 	dev_warn(dev, "out = %d, in = %d\n", num_out, num_in); */
+
+/* 	virtqueue_add_sgs(vi->vq, sgs, num_out, num_in, vi, GFP_KERNEL); */
+/* 	virtqueue_kick(vi->vq); */
+
+/* 	wait_event(vi->have_data, virtqueue_get_buf(vi->vq, &len)); */
+
+/* 	ret = 0; */
+
+/* 	/\* */
+/* 	 * We can't fail at this point, we assume we got a response */
+/* 	 * buffer back. */
+/* 	 *\/ */
+
+/* 	mutex_unlock(&vi->lock); */
+/* 	return ret; */
+/* } */
+
+static void * rpmb_virtio_get_key(struct device *dev, key_serial_t keyid)
+{
+	key_ref_t keyref;
+	struct key *key;
+	void *ptr = NULL;
+
+	keyref = lookup_user_key(keyid, 0, KEY_NEED_SEARCH);
+	if (IS_ERR(keyref))
+		return NULL;
+
+	key = key_ref_to_ptr(keyref);
+
+	if (key->datalen != RPMB_MAC_SIZE)
+		dev_err(dev, "Invalid key size (%d)", key->datalen);
+	else
+		ptr = key->payload.data[0];
+
+	key_put(key);
+	return ptr;
+}
+
+static int rpmb_virtio_program_key(struct device *dev, u8 target, key_serial_t keyid)
+{
+	struct virtio_device *vdev = dev_to_virtio(dev);
+	struct virtio_rpmb_info *vi = vdev->priv;
+	const void *key = rpmb_virtio_get_key(dev, keyid);
+
+	if (key) {
+		struct scatterlist out_frame;
+		struct scatterlist in_frame;
+		struct scatterlist *sgs[2];
+		unsigned int len;
+		struct virtio_rpmb_frame resp;
+		struct virtio_rpmb_frame cmd = {
+			.req_resp = cpu_to_le16(VIRTIO_RPMB_REQ_PROGRAM_KEY)
+		};
+
+		/* Prepare the command frame & response */
+		memcpy(&cmd.key_mac, key, sizeof(cmd.key_mac));
+
+		mutex_lock(&vi->lock);
+
+		/* Wrap into SG array */
+		sg_init_one(&out_frame, &cmd, sizeof(cmd));
+		sg_init_one(&in_frame, &resp, sizeof(resp));
+		sgs[0] = &out_frame;
+		sgs[1] = &in_frame;
+
+		/* Send it */
+		virtqueue_add_sgs(vi->vq, sgs, 1, 1, vi, GFP_KERNEL);
+		virtqueue_kick(vi->vq);
+		wait_event(vi->have_data, virtqueue_get_buf(vi->vq, &len));
+
+		mutex_unlock(&vi->lock);
+
+		if (le16_to_cpu(resp.req_resp) != VIRTIO_RPMB_RESP_PROGRAM_KEY) {
+			dev_err(dev, "Bad response from device (%x/%x)",
+				le16_to_cpu(resp.req_resp), le16_to_cpu(resp.result));
+			return -EPROTO;
+		}
+
+		/* check the MAC? */
+
+		/* map responses to better errors? */
+		return le16_to_cpu(resp.result) == VIRTIO_RPMB_RES_OK ? 0 : -EIO;
+	} else {
+		return -EINVAL;
+	}
+}
+
+static int rpmb_virtio_get_capacity(struct device *dev, u8 target)
+{
+	struct virtio_device *vdev = dev_to_virtio(dev);
+	u8 capacity;
+
+	virtio_cread(vdev, struct virtio_rpmb_config, capacity, &capacity);
+
+	if (capacity > 0x80) {
+		dev_err(&vdev->dev, "Error: invalid capacity reported.\n");
+		capacity = 0x80;
+	}
+
+	return capacity;
+}
+
+static int rpmb_virtio_get_write_count(struct device *dev, u8 target)
+{
+	struct virtio_device *vdev = dev_to_virtio(dev);
+	struct virtio_rpmb_info *vi = vdev->priv;
+	struct scatterlist out_frame;
+	struct scatterlist in_frame;
+	struct scatterlist *sgs[2];
+	unsigned int len;
+	struct virtio_rpmb_frame resp;
+	struct virtio_rpmb_frame cmd = {
+		.req_resp = cpu_to_le16(VIRTIO_RPMB_REQ_GET_WRITE_COUNTER)
+	};
+
+	mutex_lock(&vi->lock);
+
+	/* Wrap into SG array */
+	sg_init_one(&out_frame, &cmd, sizeof(cmd));
+	sg_init_one(&in_frame, &resp, sizeof(resp));
+	sgs[0] = &out_frame;
+	sgs[1] = &in_frame;
+
+	/* Send it */
+	virtqueue_add_sgs(vi->vq, sgs, 1, 1, vi, GFP_KERNEL);
+	virtqueue_kick(vi->vq);
+	wait_event(vi->have_data, virtqueue_get_buf(vi->vq, &len));
+
+	mutex_unlock(&vi->lock);
+
+	if (le16_to_cpu(resp.req_resp) != VIRTIO_RPMB_RESP_GET_COUNTER) {
+		dev_err(dev, "failed to program key (%x/%x)",
+			le16_to_cpu(resp.req_resp), le16_to_cpu(resp.result));
+		return -EPROTO;
+	}
+
+	return le16_to_cpu(resp.result) == VIRTIO_RPMB_RES_OK ? be32_to_cpu(resp.write_counter) : -EIO;
+}
+
+static struct rpmb_ops rpmb_virtio_ops = {
+	.program_key = rpmb_virtio_program_key,
+	.get_capacity = rpmb_virtio_get_capacity,
+	.get_write_count = rpmb_virtio_get_write_count,
+	/* .write_blocks = rpmb_virtio_write_blocks, */
+	/* .read_blocks = rpmb_virtio_read_blocks, */
+	.auth_method = RPMB_HMAC_ALGO_SHA_256,
+};
+
+static int rpmb_virtio_dev_init(struct virtio_rpmb_info *vi)
+{
+	int ret = 0;
+	struct device *dev = &vi->vq->vdev->dev;
+	struct virtio_device *vdev = dev_to_virtio(dev);
+	u8 max_wr, max_rd;
+
+	virtio_cread(vdev, struct virtio_rpmb_config,
+		     max_wr_cnt, &max_wr);
+	virtio_cread(vdev, struct virtio_rpmb_config,
+		     max_rd_cnt, &max_rd);
+
+	rpmb_virtio_ops.dev_id_len = strlen(id);
+	rpmb_virtio_ops.dev_id = id;
+	rpmb_virtio_ops.wr_cnt_max = max_wr;
+	rpmb_virtio_ops.rd_cnt_max = max_rd;
+	rpmb_virtio_ops.block_size = 1;
+
+	vi->rdev = rpmb_dev_register(dev, 0, &rpmb_virtio_ops);
+	if (IS_ERR(vi->rdev)) {
+		ret = PTR_ERR(vi->rdev);
+		goto err;
+	}
+
+	dev_set_drvdata(dev, vi);
+err:
+	return ret;
+}
+
+static int virtio_rpmb_init(struct virtio_device *vdev)
+{
+	int ret;
+	struct virtio_rpmb_info *vi;
+
+	vi = kzalloc(sizeof(*vi), GFP_KERNEL);
+	if (!vi)
+		return -ENOMEM;
+
+	init_waitqueue_head(&vi->have_data);
+	mutex_init(&vi->lock);
+	vdev->priv = vi;
+
+	/* We expect a single virtqueue. */
+	vi->vq = virtio_find_single_vq(vdev, virtio_rpmb_recv_done, "request");
+	if (IS_ERR(vi->vq)) {
+		dev_err(&vdev->dev, "get single vq failed!\n");
+		ret = PTR_ERR(vi->vq);
+		goto err;
+	}
+
+	/* create vrpmb device. */
+	ret = rpmb_virtio_dev_init(vi);
+	if (ret) {
+		dev_err(&vdev->dev, "create vrpmb device failed.\n");
+		goto err;
+	}
+
+	dev_info(&vdev->dev, "init done!\n");
+
+	return 0;
+
+err:
+	kfree(vi);
+	return ret;
+}
+
+static void virtio_rpmb_remove(struct virtio_device *vdev)
+{
+	struct virtio_rpmb_info *vi;
+
+	vi = vdev->priv;
+	if (!vi)
+		return;
+
+	if (wq_has_sleeper(&vi->have_data))
+		wake_up(&vi->have_data);
+
+	rpmb_dev_unregister(vi->rdev);
+
+	if (vdev->config->reset)
+		vdev->config->reset(vdev);
+
+	if (vdev->config->del_vqs)
+		vdev->config->del_vqs(vdev);
+
+	kfree(vi);
+}
+
+static int virtio_rpmb_probe(struct virtio_device *vdev)
+{
+	return virtio_rpmb_init(vdev);
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int virtio_rpmb_freeze(struct virtio_device *vdev)
+{
+	virtio_rpmb_remove(vdev);
+	return 0;
+}
+
+static int virtio_rpmb_restore(struct virtio_device *vdev)
+{
+	return virtio_rpmb_init(vdev);
+}
+#endif
+
+static struct virtio_device_id id_table[] = {
+	{ VIRTIO_ID_RPMB, VIRTIO_DEV_ANY_ID },
+	{ 0 },
+};
+
+static struct virtio_driver virtio_rpmb_driver = {
+	.driver.name =	KBUILD_MODNAME,
+	.driver.owner =	THIS_MODULE,
+	.id_table =	id_table,
+	.probe =	virtio_rpmb_probe,
+	.remove =	virtio_rpmb_remove,
+#ifdef CONFIG_PM_SLEEP
+	.freeze =	virtio_rpmb_freeze,
+	.restore =	virtio_rpmb_restore,
+#endif
+};
+
+module_virtio_driver(virtio_rpmb_driver);
+MODULE_DEVICE_TABLE(virtio, id_table);
+
+MODULE_DESCRIPTION("Virtio rpmb frontend driver");
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/include/uapi/linux/virtio_ids.h b/include/uapi/linux/virtio_ids.h
index bc1c0621f5ed..934df72714e2 100644
--- a/include/uapi/linux/virtio_ids.h
+++ b/include/uapi/linux/virtio_ids.h
@@ -53,6 +53,7 @@
 #define VIRTIO_ID_MEM			24 /* virtio mem */
 #define VIRTIO_ID_FS			26 /* virtio filesystem */
 #define VIRTIO_ID_PMEM			27 /* virtio pmem */
+#define VIRTIO_ID_RPMB			28 /* virtio RPMB */
 #define VIRTIO_ID_MAC80211_HWSIM	29 /* virtio mac80211-hwsim */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
diff --git a/include/uapi/linux/virtio_rpmb.h b/include/uapi/linux/virtio_rpmb.h
new file mode 100644
index 000000000000..f048cd968210
--- /dev/null
+++ b/include/uapi/linux/virtio_rpmb.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+
+#ifndef _UAPI_LINUX_VIRTIO_RPMB_H
+#define _UAPI_LINUX_VIRTIO_RPMB_H
+
+#include <linux/types.h>
+#include <linux/virtio_ids.h>
+#include <linux/virtio_config.h>
+#include <linux/virtio_types.h>
+
+struct virtio_rpmb_config {
+	__u8 capacity;
+	__u8 max_wr_cnt;
+	__u8 max_rd_cnt;
+} __attribute__((packed));
+
+/* RPMB Request Types (in .req_resp) */
+#define VIRTIO_RPMB_REQ_PROGRAM_KEY        0x0001
+#define VIRTIO_RPMB_REQ_GET_WRITE_COUNTER  0x0002
+#define VIRTIO_RPMB_REQ_DATA_WRITE         0x0003
+#define VIRTIO_RPMB_REQ_DATA_READ          0x0004
+#define VIRTIO_RPMB_REQ_RESULT_READ        0x0005
+
+/* RPMB Response Types (in .req_resp) */
+#define VIRTIO_RPMB_RESP_PROGRAM_KEY       0x0100
+#define VIRTIO_RPMB_RESP_GET_COUNTER       0x0200
+#define VIRTIO_RPMB_RESP_DATA_WRITE        0x0300
+#define VIRTIO_RPMB_RESP_DATA_READ         0x0400
+
+struct virtio_rpmb_frame {
+	__u8 stuff[196];
+	__u8 key_mac[32];
+	__u8 data[256];
+	__u8 nonce[16];
+	__be32 write_counter;
+	__be16 address;
+	__be16 block_count;
+	__be16 result;
+	__be16 req_resp;
+} __attribute__((packed));
+
+/* RPMB Operation Results (in .result) */
+#define VIRTIO_RPMB_RES_OK                     0x0000
+#define VIRTIO_RPMB_RES_GENERAL_FAILURE        0x0001
+#define VIRTIO_RPMB_RES_AUTH_FAILURE           0x0002
+#define VIRTIO_RPMB_RES_COUNT_FAILURE          0x0003
+#define VIRTIO_RPMB_RES_ADDR_FAILURE           0x0004
+#define VIRTIO_RPMB_RES_WRITE_FAILURE          0x0005
+#define VIRTIO_RPMB_RES_READ_FAILURE           0x0006
+#define VIRTIO_RPMB_RES_NO_AUTH_KEY            0x0007
+#define VIRTIO_RPMB_RES_WRITE_COUNTER_EXPIRED  0x0080
+
+
+#endif /* _UAPI_LINUX_VIRTIO_RPMB_H */
-- 
2.20.1

