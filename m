From: Parshuram Thombare <pthombar@cadence.com>
Subject: [PATCH 2/2] scsi: ufs: add inline crypto support to UFS HCD
Date: Tue, 11 Dec 2018 09:50:27 +0000
Message-ID: <20181211095027.GA3316@lvlogina.cadence.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mchehab+samsung@kernel.org, gregkh@linuxfoundation.org, davem@davemloft.net, akpm@linux-foundation.org, nicolas.ferre@microchip.com, arnd@arndb.de, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: adouglas@cadence.com, jank@cadence.com, rafalc@cadence.com, pthombar@cadence.com
List-Id: linux-scsi@vger.kernel.org

Add real time crypto support to UFS HCD using new device
mapper 'crypto-ufs'. dmsetup tool can be used to enable
real time / inline crypto support using device mapper
'crypt-ufs'.

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 MAINTAINERS                      |    7 +
 block/Kconfig                    |    5 +
 drivers/scsi/ufs/Kconfig         |   12 +
 drivers/scsi/ufs/Makefile        |    1 +
 drivers/scsi/ufs/ufshcd-crypto.c |  453 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-crypto.h |  102 +++++++++
 drivers/scsi/ufs/ufshcd.c        |   27 +++-
 drivers/scsi/ufs/ufshcd.h        |    6 +
 drivers/scsi/ufs/ufshci.h        |    1 +
 9 files changed, 613 insertions(+), 1 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-crypto.c
 create mode 100644 drivers/scsi/ufs/ufshcd-crypto.h

diff --git a/MAINTAINERS b/MAINTAINERS
index f485597..3a68126 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15340,6 +15340,13 @@ S:	Supported
 F:	Documentation/scsi/ufs.txt
 F:	drivers/scsi/ufs/
 
+UNIVERSAL FLASH STORAGE HOST CONTROLLER CRYPTO DRIVER
+M:	Parshuram Thombare <pthombar@cadence.com>
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	drivers/scsi/ufs/ufshcd-crypto.c
+F:	drivers/scsi/ufs/ufshcd-crypto.h
+
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER DWC HOOKS
 M:	Joao Pinto <jpinto@synopsys.com>
 L:	linux-scsi@vger.kernel.org
diff --git a/block/Kconfig b/block/Kconfig
index f7045aa..6afe131 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -224,4 +224,9 @@ config BLK_MQ_RDMA
 config BLK_PM
 	def_bool BLOCK && PM
 
+config BLK_DEV_HW_RT_ENCRYPTION
+	bool
+	depends on SCSI_UFSHCD_RT_ENCRYPTION
+	default n
+
 source block/Kconfig.iosched
diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 2ddbb26..09a3ec0 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -136,3 +136,15 @@ config SCSI_UFS_BSG
 
 	  Select this if you need a bsg device node for your UFS controller.
 	  If unsure, say N.
+
+config SCSI_UFSHCD_RT_ENCRYPTION
+	bool "Universal Flash Storage Controller RT encryption support"
+	depends on SCSI_UFSHCD
+	default n
+	select BLK_DEV_HW_RT_ENCRYPTION if SCSI_UFSHCD_RT_ENCRYPTION
+	select BLK_DEV_DM if SCSI_UFSHCD_RT_ENCRYPTION
+	help
+	Universal Flash Storage Controller RT encryption support
+
+	Select this if you want to enable real time encryption on UFS controller
+	If unsure, say N.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index a3bd70c..6169096 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
 ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
 ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
+ufshcd-core-$(CONFIG_SCSI_UFSHCD_RT_ENCRYPTION) += ufshcd-crypto.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
new file mode 100644
index 0000000..9c95ff3
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd-crypto.c
@@ -0,0 +1,453 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * UFS Host controller crypto driver
+ *
+ * Copyright (C) 2018 Cadence Design Systems, Inc.
+ *
+ * Authors:
+ *	Parshuram Thombare <pthombar@cadence.com>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <crypto/aes.h>
+#include <linux/device-mapper.h>
+#include "ufshcd.h"
+#include "ufshcd-crypto.h"
+#include "scsi/scsi_device.h"
+#include "scsi/scsi_host.h"
+
+struct ufshcd_dm_ctx {
+	struct dm_dev *dev;
+	sector_t start;
+	unsigned short int sector_size;
+	unsigned char sector_shift;
+	int cci;
+	int cap_idx;
+	char key[AES_MAX_KEY_SIZE];
+	struct ufs_hba *hba;
+};
+
+static int dm_registered;
+
+static inline int
+ufshcd_key_id_to_len(int key_id)
+{
+	int key_len = -1;
+
+	switch (key_id) {
+	case UFS_CRYPTO_KEY_ID_128BITS:
+		key_len = AES_KEYSIZE_128;
+		break;
+	case UFS_CRYPTO_KEY_ID_192BITS:
+		key_len = AES_KEYSIZE_192;
+		break;
+	case UFS_CRYPTO_KEY_ID_256BITS:
+		key_len = AES_KEYSIZE_256;
+		break;
+	default:
+		break;
+	}
+	return key_len;
+}
+
+static inline int
+ufshcd_key_len_to_id(int key_len)
+{
+	int key_id = -1;
+
+	switch (key_len) {
+	case AES_KEYSIZE_128:
+		key_id = UFS_CRYPTO_KEY_ID_128BITS;
+		break;
+	case AES_KEYSIZE_192:
+		key_id = UFS_CRYPTO_KEY_ID_192BITS;
+		break;
+	case AES_KEYSIZE_256:
+		key_id = UFS_CRYPTO_KEY_ID_256BITS;
+		break;
+	default:
+		break;
+	}
+	return key_id;
+}
+
+static void
+ufshcd_read_crypto_capabilities(struct ufs_hba *hba)
+{
+	u32 tmp, i;
+	struct ufshcd_crypto_ctx *cctx = hba->cctx;
+
+	for (i = 0; i < cctx->cap_cnt; i++) {
+		tmp = ufshcd_readl(hba, REG_UFS_CRYPTOCAP + i);
+		cctx->ccaps[i].key_id = (tmp & CRYPTO_CAPS_KS_MASK) >>
+						CRYPTO_CAPS_KS_SHIFT;
+		cctx->ccaps[i].sdusb = (tmp & CRYPTO_CAPS_SDUSB_MASK) >>
+						CRYPTO_CAPS_SDUSB_SHIFT;
+		cctx->ccaps[i].alg_id = (tmp & CRYPTO_CAPS_ALG_ID_MASK) >>
+						CRYPTO_CAPS_ALG_ID_SHIFT;
+	}
+}
+
+static inline int
+ufshcd_get_cap_idx(struct ufshcd_crypto_ctx *cctx, int alg_id,
+	int key_id)
+{
+	int cap_idx;
+
+	for (cap_idx = 0; cap_idx < cctx->cap_cnt; cap_idx++) {
+		if (((cctx->ccaps[cap_idx].alg_id == alg_id) &&
+			cctx->ccaps[cap_idx].key_id == key_id))
+			break;
+	}
+	return ((cap_idx < cctx->cap_cnt) ? cap_idx : -1);
+}
+
+static inline int
+ufshcd_get_cci_slot(struct ufshcd_crypto_ctx *cctx)
+{
+	int  cci;
+
+	for (cci = 0; cci < cctx->config_cnt; cci++) {
+		if (!cctx->cconfigs[cci].cfge) {
+			cctx->cconfigs[cci].cfge = 1;
+			break;
+		}
+	}
+	return ((cci < cctx->config_cnt) ? cci : -1);
+}
+
+static void
+ufshcd_aes_ecb_set_key(struct ufshcd_dm_ctx *ctx)
+{
+	int i, key_size;
+	u32 val, cconfig16, crypto_config_addr;
+	struct ufshcd_crypto_ctx *cctx;
+	struct ufshcd_crypto_config *cconfig;
+	struct ufshcd_crypto_cap ccap;
+
+	cctx = ctx->hba->cctx;
+	if (ctx->cci <= 0)
+		ctx->cci = ufshcd_get_cci_slot(cctx);
+	/* If no slot is available, slot 0 is shared */
+	ctx->cci = ctx->cci < 0 ? 0 : ctx->cci;
+	cconfig = &(cctx->cconfigs[ctx->cci]);
+	ccap = cctx->ccaps[ctx->cap_idx];
+	key_size = ufshcd_key_id_to_len(ccap.key_id);
+
+	if ((cconfig->cap_idx != ctx->cap_idx) ||
+		((key_size > 0) &&
+		memcmp(cconfig->key, ctx->key, key_size))) {
+		cconfig->cap_idx = ctx->cap_idx;
+		memcpy(cconfig->key, ctx->key, key_size);
+		crypto_config_addr = cctx->crypto_config_base_addr +
+				ctx->cci * CRYPTO_CONFIG_SIZE;
+		cconfig16 = ccap.sdusb | (1 << CRYPTO_CCONFIG16_CFGE_SHIFT);
+		cconfig16 |= ((ctx->cap_idx << CRYPTO_CCONFIG16_CAP_IDX_SHIFT) &
+				CRYPTO_CCONFIG16_CAP_IDX_MASK);
+		spin_lock(&cctx->crypto_lock);
+		for (i = 0; i < key_size; i += 4) {
+			val = (ctx->key[i] | (ctx->key[i + 1] << 8) |
+				(ctx->key[i + 2] << 16) |
+				(ctx->key[i + 3] << 24));
+			ufshcd_writel(ctx->hba, val, crypto_config_addr + i);
+		}
+		ufshcd_writel(ctx->hba, cpu_to_le32(cconfig16),
+				crypto_config_addr + (4 * 16));
+		spin_unlock(&cctx->crypto_lock);
+		/* Make sure keys are programmed */
+		mb();
+	}
+}
+
+
+/*
+ * ufshcd_prepare_for_crypto - UFS HCD preparation before submitting UTP
+ * transfer request desc. Get crypto config index from block cipher contex
+ * which was set in set_key.
+ * @hba: host bus adapter instance per UFS HC
+ * @lrbp: UFS HCD local reference block
+ */
+void
+ufshcd_prepare_for_crypto(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	struct bio *bio = lrbp->cmd->request->bio;
+	struct ufshcd_dm_ctx *ctx = NULL;
+	struct ufshcd_crypto_ctx *cctx;
+	int alg_id;
+
+#ifdef CONFIG_BLK_DEV_HW_RT_ENCRYPTION
+	if (bio)
+		ctx = (struct ufshcd_dm_ctx *)(bio->bi_crypto_ctx);
+#endif
+	if (unlikely(!bio) || !ctx)
+		return;
+
+	switch (lrbp->cmd->cmnd[0]) {
+	case READ_6:
+	case READ_10:
+	case READ_16:
+	case WRITE_6:
+	case WRITE_10:
+	case WRITE_16:
+		cctx = ctx->hba->cctx;
+		alg_id = cctx->ccaps[ctx->cap_idx].alg_id;
+		switch (alg_id) {
+		case UFS_CRYPTO_ALG_ID_AES_ECB:
+		ufshcd_aes_ecb_set_key(ctx);
+		lrbp->cci = ctx->cci;
+		break;
+		default:
+		break;
+		}
+	break;
+
+	default:
+	break;
+	}
+}
+EXPORT_SYMBOL_GPL(ufshcd_prepare_for_crypto);
+
+static int
+crypt_ctr_cipher(struct dm_target *ti, char *cipher_in, char *key)
+{
+	struct ufshcd_dm_ctx *ctx = ti->private;
+	int alg_id;
+	int ret = 0;
+
+	if (!memcmp(cipher_in, "aes-ecb", 7))
+		alg_id = UFS_CRYPTO_ALG_ID_AES_ECB;
+	else
+		alg_id = -1;
+	ctx->cap_idx = ufshcd_get_cap_idx(ctx->hba->cctx, alg_id,
+			ufshcd_key_len_to_id(strlen(key) >> 1));
+	if (ctx->cap_idx >= 0) {
+		switch (alg_id) {
+		case UFS_CRYPTO_ALG_ID_AES_ECB:
+		ret = hex2bin(ctx->key, key, (strlen(key) >> 1));
+		if (!ret)
+			ufshcd_aes_ecb_set_key(ctx);
+		break;
+		default:
+		ret = -EINVAL;
+		break;
+		}
+	} else
+		ret = -EINVAL;
+	return ret;
+}
+
+static int
+ufshcd_crypt_map(struct dm_target *ti, struct bio *bio)
+{
+	struct ufshcd_dm_ctx *ctx = ti->private;
+
+	/*
+	 * If bio is REQ_PREFLUSH or REQ_OP_DISCARD, just bypass crypt queues.
+	 * - for REQ_PREFLUSH device-mapper core ensures that no IO is in-flight
+	 * - for REQ_OP_DISCARD caller must use flush if IO ordering matters
+	 */
+	if (unlikely(bio->bi_opf & REQ_PREFLUSH ||
+	    bio_op(bio) == REQ_OP_DISCARD)) {
+		bio_set_dev(bio, ctx->dev->bdev);
+		if (bio_sectors(bio))
+			bio->bi_iter.bi_sector = ctx->start +
+				dm_target_offset(ti, bio->bi_iter.bi_sector);
+		return DM_MAPIO_REMAPPED;
+	}
+
+	/*
+	 * Check if bio is too large, split as needed.
+	 */
+	if (unlikely(bio->bi_iter.bi_size > (BIO_MAX_PAGES << PAGE_SHIFT)) &&
+	    (bio_data_dir(bio) == WRITE))
+		dm_accept_partial_bio(bio,
+			((BIO_MAX_PAGES << PAGE_SHIFT) >> SECTOR_SHIFT));
+	/*
+	 * Ensure that bio is a multiple of internal sector encryption size
+	 * and is aligned to this size as defined in IO hints.
+	 */
+	if (unlikely((bio->bi_iter.bi_sector &
+			((ctx->sector_size >> SECTOR_SHIFT) - 1)) != 0))
+		return DM_MAPIO_KILL;
+
+	if (unlikely(bio->bi_iter.bi_size & (ctx->sector_size - 1)))
+		return DM_MAPIO_KILL;
+#ifdef CONFIG_BLK_DEV_HW_RT_ENCRYPTION
+	bio->bi_crypto_ctx = ctx;
+	bio_set_dev(bio, ctx->dev->bdev);
+	if (bio_sectors(bio))
+		bio->bi_iter.bi_sector = ctx->start +
+			dm_target_offset(ti, bio->bi_iter.bi_sector);
+	generic_make_request(bio);
+#endif
+	return DM_MAPIO_SUBMITTED;
+
+}
+
+static int
+ufshcd_crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	struct ufshcd_dm_ctx *ctx;
+	int ret;
+	unsigned long long tmpll;
+	char dummy;
+	struct block_device *bdev = NULL;
+	struct device *device = NULL;
+	struct Scsi_Host *shost = NULL;
+
+	if (argc != 5) {
+		ti->error = "Invalid no of arguments";
+		ret = -EINVAL;
+		goto err1;
+	}
+
+	ctx = kzalloc(sizeof(struct ufshcd_dm_ctx), GFP_KERNEL);
+	if (!ctx) {
+		ti->error = "Cannot allocate encryption context";
+		ret = -ENOMEM;
+		goto err1;
+	}
+	ti->private = ctx;
+
+	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) != 1) {
+		ti->error = "Invalid device sector";
+		ret = -EINVAL;
+		goto err2;
+	}
+	ctx->start = tmpll;
+	ctx->sector_size = (1 << SECTOR_SHIFT);
+	ctx->sector_shift = 0;
+
+	ret = dm_get_device(ti, argv[3],
+		dm_table_get_mode(ti->table), &ctx->dev);
+	if (ret) {
+		ti->error = "Device lookup failed";
+		ret = -ENOMEM;
+		goto err2;
+	}
+	bdev = ctx->dev->bdev;
+	ret = -EINVAL;
+	if (bdev) {
+		device = part_to_dev(bdev->bd_part);
+		if (device) {
+			shost = dev_to_shost(device);
+			if (shost && !memcmp(shost->hostt->name, "ufshcd", 6)) {
+				ctx->hba = shost_priv(shost);
+				ret = crypt_ctr_cipher(ti, argv[0], argv[1]);
+			}
+		}
+	}
+	if (ret)
+		goto err3;
+	return 0;
+err3:
+	dm_put_device(ti, ctx->dev);
+err2:
+	kfree(ctx);
+err1:
+	return ret;
+}
+
+static void
+ufshcd_crypt_dtr(struct dm_target *ti)
+{
+	struct ufshcd_dm_ctx *ctx = ti->private;
+
+	if (ctx) {
+		if (ctx->cci > 0 && ctx->hba)
+			ctx->hba->cctx->cconfigs[ctx->cci].cfge = 0;
+		dm_put_device(ti, ctx->dev);
+		kfree(ctx);
+		ti->private = NULL;
+	}
+}
+
+static struct target_type crypt_target = {
+	.name   = "crypt-ufs",
+	.version = {0, 0, 1},
+	.module = THIS_MODULE,
+	.ctr    = ufshcd_crypt_ctr,
+	.dtr    = ufshcd_crypt_dtr,
+	.map    = ufshcd_crypt_map,
+};
+
+/*
+ * ufshcd_crypto_init - UFS HCD crypto service initialization
+ * @hba: host bus adapter instance per UFS HC
+ */
+int ufshcd_crypto_init(struct ufs_hba *hba)
+{
+	int ret = 0;
+	unsigned int tmp;
+
+	hba->cctx = kzalloc(sizeof(struct ufshcd_crypto_ctx), GFP_KERNEL);
+	if (!hba->cctx) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	tmp = ufshcd_readl(hba, REG_CONTROLLER_ENABLE);
+	ufshcd_writel(hba, CRYPTO_GENERAL_ENABLE | tmp, REG_CONTROLLER_ENABLE);
+	tmp = ufshcd_readl(hba, REG_UFS_CCAP);
+	hba->cctx->crypto_config_base_addr =
+		((tmp & CRYPTO_CFGPTR_MASK) >> CRYPTO_CFGPTR_SHIFT) * 0x100;
+	hba->cctx->config_cnt =
+		(tmp & CRYPTO_CONFIG_CNT_MASK) >> CRYPTO_CONFIG_CNT_SHIFT;
+	hba->cctx->cap_cnt =
+		(tmp & CRYPTO_CAP_CNT_MASK) >> CRYPTO_CAP_CNT_SHIFT;
+	hba->cctx->ccaps = kcalloc(hba->cctx->cap_cnt,
+			sizeof(struct ufshcd_crypto_cap), GFP_KERNEL);
+	if (!hba->cctx->ccaps) {
+		ret = -ENOMEM;
+		goto err2;
+	}
+	hba->cctx->cconfigs = kcalloc(hba->cctx->config_cnt,
+			sizeof(struct ufshcd_crypto_config), GFP_KERNEL);
+	if (!hba->cctx->cconfigs) {
+		ret = -ENOMEM;
+		goto err3;
+	}
+	ufshcd_read_crypto_capabilities(hba);
+	spin_lock_init(&hba->cctx->crypto_lock);
+	if (!dm_registered) {
+		ret = dm_register_target(&crypt_target);
+		if (ret < 0) {
+			dev_err(hba->dev, "UFS DM register failed %d", ret);
+			goto err3;
+		}
+		dm_registered = 1;
+	}
+
+	return 0;
+err3:
+	kfree(hba->cctx->ccaps);
+	hba->cctx->ccaps = NULL;
+err2:
+	kfree(hba->cctx);
+	hba->cctx = NULL;
+err1:
+	dev_err(hba->dev, "AES ECB algo registration failed.\n");
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ufshcd_crypto_init);
+
+/*
+ * ufshcd_crypto_remove - UFS HCD crypto service cleanup
+ * @hba: host bus adapter instance per UFS HC
+ */
+void ufshcd_crypto_remove(struct ufs_hba *hba)
+{
+	dm_unregister_target(&crypt_target);
+	dm_registered = 0;
+	kfree(hba->cctx->ccaps);
+	kfree(hba->cctx->cconfigs);
+	kfree(hba->cctx);
+	hba->cctx = NULL;
+}
+EXPORT_SYMBOL_GPL(ufshcd_crypto_remove);
+
+MODULE_AUTHOR("Parshuram Thombare <pthombar@cadence.com>");
+MODULE_DESCRIPTION("UFS host controller crypto driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/scsi/ufs/ufshcd-crypto.h b/drivers/scsi/ufs/ufshcd-crypto.h
new file mode 100644
index 0000000..35688ac
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd-crypto.h
@@ -0,0 +1,102 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * UFS Host controller crypto driver
+ *
+ * Copyright (C) 2018 Cadence Design Systems, Inc.
+ *
+ * Authors:
+ *	Parshuram Thombare <pthombar@cadence.com>
+ *
+ */
+
+#ifndef _UFSHCD_CRYPTO_H_
+#define _UFSHCD_CRYPTO_H_
+#include "crypto/aes.h"
+
+#define CRYPTO_CFGPTR_MASK 0xff000000
+#define CRYPTO_CFGPTR_SHIFT 24
+#define CRYPTO_CONFIG_CNT_MASK 0xff00
+#define CRYPTO_CONFIG_CNT_SHIFT 8
+#define CRYPTO_CAP_CNT_MASK 0xff
+#define CRYPTO_CAP_CNT_SHIFT 0
+
+#define CRYPTO_CAPS_KS_MASK 0xff0000
+#define CRYPTO_CAPS_KS_SHIFT 16
+#define CRYPTO_CAPS_SDUSB_MASK 0xff00
+#define CRYPTO_CAPS_SDUSB_SHIFT 8
+#define CRYPTO_CAPS_ALG_ID_MASK 0xff
+#define CRYPTO_CAPS_ALG_ID_SHIFT 0
+
+#define CRYPTO_CCONFIG16_CFGE_MASK 0x80000000
+#define CRYPTO_CCONFIG16_CFGE_SHIFT 31
+#define CRYPTO_CCONFIG16_CAP_IDX_MASK 0xff00
+#define CRYPTO_CCONFIG16_CAP_IDX_SHIFT 8
+#define CRYPTO_CONFIG_SIZE 0x80
+
+/* UTP transfer request descriptor DW0 crypto enable */
+#define CRYPTO_UTP_REQ_DESC_DWORD0_CE_MASK 0x800000
+#define CRYPTO_UTP_REQ_DESC_DWORD0_CE_SHIFT 23
+/* UTP transfer request descriptor DW0 crypto config index */
+#define CRYPTO_UTP_REQ_DESC_DWORD0_CCI_MASK 0xff
+#define CRYPTO_UTP_REQ_DESC_DWORD0_CCI_SHIFT 0
+
+enum key_size_e {
+	UFS_CRYPTO_KEY_ID_128BITS = 1,
+	UFS_CRYPTO_KEY_ID_192BITS = 2,
+	UFS_CRYPTO_KEY_ID_256BITS = 3,
+	UFS_CRYPTO_KEY_ID_512BITS = 4,
+};
+
+enum alg_id_e {
+	UFS_CRYPTO_ALG_ID_AES_XTS = 0,
+	UFS_CRYPTO_ALG_ID_BITLOCKER_AES_CBC = 1,
+	UFS_CRYPTO_ALG_ID_AES_ECB = 2,
+	UFS_CRYPTO_ALG_ID_ESSIV_AES_CBC = 3,
+};
+
+/*
+ * ufshcd_crypto_config - UFS HC config
+ * @cap_idx: index in ccaps array of crypto ctx
+ * @cfge: config enable bit
+ * @key: crypto key
+ */
+struct ufshcd_crypto_config {
+	u8 cap_idx;
+	u8 cfge;
+	u8 key[AES_MAX_KEY_SIZE];
+};
+
+/*
+ * ufshcd_crypto_cap - UFS HC capability structure
+ * @alg_id: algo id (alg_id_e) as per UFS spec
+ * @sdusb: Supported Data Unit Size Bitmask
+ * @key_id: key size id (key_size_e) as per UFS spec
+ */
+struct ufshcd_crypto_cap {
+	u8 alg_id;
+	u8 sdusb;
+	u8 key_id;
+};
+
+/*
+ * ufshcd_crypto_ctx - UFSHCD crypto context
+ * @ccaps: UFS HC crypto capabilities array
+ * @cconfigs: UFS HC configs array
+ * @crypto_lock: crypto lock
+ * @crypto_config_base_addr: UFS HC crypto config base address
+ * @config_cnt: supported configuration count
+ * @cap_cnt: supported capabilities count
+ */
+struct ufshcd_crypto_ctx {
+	struct ufshcd_crypto_cap *ccaps;
+	struct ufshcd_crypto_config *cconfigs;
+	spinlock_t crypto_lock;
+	unsigned int crypto_config_base_addr;
+	int config_cnt;
+	int cap_cnt;
+};
+
+int ufshcd_crypto_init(struct ufs_hba *hba);
+void ufshcd_crypto_remove(struct ufs_hba *hba);
+void ufshcd_prepare_for_crypto(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
+#endif
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 86fe114..a96b038 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -47,6 +47,9 @@
 #include "unipro.h"
 #include "ufs-sysfs.h"
 #include "ufs_bsg.h"
+#ifdef CONFIG_SCSI_UFSHCD_RT_ENCRYPTION
+#include "ufshcd-crypto.h"
+#endif
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ufs.h>
@@ -2198,6 +2201,14 @@ static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
 
 	dword_0 = data_direction | (lrbp->command_type
 				<< UPIU_COMMAND_TYPE_OFFSET);
+#ifdef CONFIG_SCSI_UFSHCD_RT_ENCRYPTION
+	if (lrbp->cci >= 0) {
+		dword_0 |= (1 << CRYPTO_UTP_REQ_DESC_DWORD0_CE_SHIFT);
+		dword_0 |= ((lrbp->cci << CRYPTO_UTP_REQ_DESC_DWORD0_CCI_SHIFT)
+				& CRYPTO_UTP_REQ_DESC_DWORD0_CCI_MASK);
+	} else
+		dword_0 &= ~CRYPTO_UTP_REQ_DESC_DWORD0_CE_MASK;
+#endif
 	if (lrbp->intr_cmd)
 		dword_0 |= UTP_REQ_DESC_INT_CMD;
 
@@ -2462,6 +2473,12 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
 	lrbp->req_abort_skip = false;
 
+#ifdef CONFIG_SCSI_UFSHCD_RT_ENCRYPTION
+	lrbp->cci = -1;
+	/* prepare block for crypto */
+	if (hba->capabilities & MASK_CRYPTO_SUPPORT)
+		ufshcd_prepare_for_crypto(hba, lrbp);
+#endif
 	ufshcd_comp_scsi_upiu(hba, lrbp);
 
 	err = ufshcd_map_sg(hba, lrbp);
@@ -8119,6 +8136,11 @@ void ufshcd_remove(struct ufs_hba *hba)
 	ufs_bsg_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
 	scsi_remove_host(hba->host);
+#ifdef CONFIG_SCSI_UFSHCD_RT_ENCRYPTION
+	if (hba->capabilities & MASK_CRYPTO_SUPPORT)
+		ufshcd_crypto_remove(hba);
+#endif
+
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
 	ufshcd_hba_stop(hba, true);
@@ -8346,7 +8368,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		hba->ahit = FIELD_PREP(UFSHCI_AHIBERN8_TIMER_MASK, 150) |
 			    FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, 3);
 	}
-
+#ifdef CONFIG_SCSI_UFSHCD_RT_ENCRYPTION
+	if (hba->capabilities & MASK_CRYPTO_SUPPORT)
+		ufshcd_crypto_init(hba);
+#endif
 	/* Hold auto suspend until async scan completes */
 	pm_runtime_get_sync(dev);
 	atomic_set(&hba->scsi_block_reqs_cnt, 0);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 69ba744..25755c8 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -193,6 +193,9 @@ struct ufshcd_lrb {
 	ktime_t compl_time_stamp;
 
 	bool req_abort_skip;
+#ifdef CONFIG_SCSI_UFSHCD_RT_ENCRYPTION
+	int cci;
+#endif
 };
 
 /**
@@ -706,6 +709,9 @@ struct ufs_hba {
 
 	struct device		bsg_dev;
 	struct request_queue	*bsg_queue;
+#ifdef CONFIG_SCSI_UFSHCD_RT_ENCRYPTION
+	struct ufshcd_crypto_ctx *cctx;
+#endif
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 6fa889d..fe5a92d 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -90,6 +90,7 @@ enum {
 	MASK_64_ADDRESSING_SUPPORT		= 0x01000000,
 	MASK_OUT_OF_ORDER_DATA_DELIVERY_SUPPORT	= 0x02000000,
 	MASK_UIC_DME_TEST_MODE_SUPPORT		= 0x04000000,
+	MASK_CRYPTO_SUPPORT                     = 0x10000000,
 };
 
 #define UFS_MASK(mask, offset)		((mask) << (offset))
-- 
1.7.1
