Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49796C4321E
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 18:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 352A661038
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 18:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242788AbhIWS6X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Sep 2021 14:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237134AbhIWS6W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Sep 2021 14:58:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58C4C610C9;
        Thu, 23 Sep 2021 18:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632423410;
        bh=Bpm/CYP/lEq3++No1r2sOE1RToMYXDAriwUUWxEhi9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWN5Dx5u3r85rW1kjnyfJrFWFargaAh7EifXlrH9I1CLuxhvr4SxjEOyYa8gDLR1k
         NGb1EKIU8JHhon8qXP2W8yggoHU8m2WymAsqStO3vRrf5fGtMvyc4Y4uyUD0px269J
         AZKxhVeT5Po/yoW2zzWJJptUt9IakwXlDYswozr+nYKHMnQ3f0t1Uzi8dvSG88DgoW
         wvxdnndu/A4se6rT189yqOTPj7AjPqBFTDYYP9BhxMS/cb3yoDl1Q7Csw7RevFkTiA
         biJ2qiHNmpYUNWsFnJCKz27jff3P9wsaY55469ne5lre1T36sDSqu9jLFOcPtj8fSv
         2LBxHp9m/vecA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Satya Tangirala <satyaprateek2357@gmail.com>, dm-devel@redhat.com,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 2/4] blk-crypto: rename keyslot-manager files to blk-crypto-profile
Date:   Thu, 23 Sep 2021 11:56:27 -0700
Message-Id: <20210923185629.54823-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210923185629.54823-1-ebiggers@kernel.org>
References: <20210923185629.54823-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In preparation for renaming struct blk_keyslot_manager to struct
blk_crypto_profile, rename the keyslot-manager.h and keyslot-manager.c
source files.  Renaming these files separately before making a lot of
changes to their contents makes it easier for git to understand that
they were renamed.

Acked-by: Ulf Hansson <ulf.hansson@linaro.org> # For MMC
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/Makefile                                            | 2 +-
 block/blk-crypto-fallback.c                               | 2 +-
 block/{keyslot-manager.c => blk-crypto-profile.c}         | 2 +-
 block/blk-crypto.c                                        | 2 +-
 drivers/md/dm-core.h                                      | 2 +-
 drivers/md/dm.c                                           | 2 +-
 drivers/mmc/host/cqhci-crypto.c                           | 2 +-
 drivers/scsi/ufs/ufshcd.h                                 | 2 +-
 include/linux/{keyslot-manager.h => blk-crypto-profile.h} | 0
 include/linux/mmc/host.h                                  | 2 +-
 10 files changed, 9 insertions(+), 9 deletions(-)
 rename block/{keyslot-manager.c => blk-crypto-profile.c} (99%)
 rename include/linux/{keyslot-manager.h => blk-crypto-profile.h} (100%)

diff --git a/block/Makefile b/block/Makefile
index 41aa1ba69c900..c245e05b67453 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -36,6 +36,6 @@ obj-$(CONFIG_BLK_DEBUG_FS)	+= blk-mq-debugfs.o
 obj-$(CONFIG_BLK_DEBUG_FS_ZONED)+= blk-mq-debugfs-zoned.o
 obj-$(CONFIG_BLK_SED_OPAL)	+= sed-opal.o
 obj-$(CONFIG_BLK_PM)		+= blk-pm.o
-obj-$(CONFIG_BLK_INLINE_ENCRYPTION)	+= keyslot-manager.o blk-crypto.o
+obj-$(CONFIG_BLK_INLINE_ENCRYPTION)	+= blk-crypto.o blk-crypto-profile.o
 obj-$(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK)	+= blk-crypto-fallback.o
 obj-$(CONFIG_BLOCK_HOLDER_DEPRECATED)	+= holder.o
diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index 82b302597b474..b3920e8efd075 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -12,9 +12,9 @@
 #include <crypto/skcipher.h>
 #include <linux/blk-cgroup.h>
 #include <linux/blk-crypto.h>
+#include <linux/blk-crypto-profile.h>
 #include <linux/blkdev.h>
 #include <linux/crypto.h>
-#include <linux/keyslot-manager.h>
 #include <linux/mempool.h>
 #include <linux/module.h>
 #include <linux/random.h>
diff --git a/block/keyslot-manager.c b/block/blk-crypto-profile.c
similarity index 99%
rename from block/keyslot-manager.c
rename to block/blk-crypto-profile.c
index 2c4a55bea6ca1..a58daf93c9ba6 100644
--- a/block/keyslot-manager.c
+++ b/block/blk-crypto-profile.c
@@ -28,7 +28,7 @@
 
 #define pr_fmt(fmt) "blk-crypto: " fmt
 
-#include <linux/keyslot-manager.h>
+#include <linux/blk-crypto-profile.h>
 #include <linux/device.h>
 #include <linux/atomic.h>
 #include <linux/mutex.h>
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 103c2e2d50d67..9102803d36232 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -11,7 +11,7 @@
 
 #include <linux/bio.h>
 #include <linux/blkdev.h>
-#include <linux/keyslot-manager.h>
+#include <linux/blk-crypto-profile.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 
diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 55dccdfbcb22e..841ed87999e79 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -13,7 +13,7 @@
 #include <linux/ktime.h>
 #include <linux/genhd.h>
 #include <linux/blk-mq.h>
-#include <linux/keyslot-manager.h>
+#include <linux/blk-crypto-profile.h>
 
 #include <trace/events/block.h>
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a011d09cb0fac..249223e20d3d0 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -29,7 +29,7 @@
 #include <linux/refcount.h>
 #include <linux/part_stat.h>
 #include <linux/blk-crypto.h>
-#include <linux/keyslot-manager.h>
+#include <linux/blk-crypto-profile.h>
 
 #define DM_MSG_PREFIX "core"
 
diff --git a/drivers/mmc/host/cqhci-crypto.c b/drivers/mmc/host/cqhci-crypto.c
index 6419cfbb4ab78..628bbfaf83124 100644
--- a/drivers/mmc/host/cqhci-crypto.c
+++ b/drivers/mmc/host/cqhci-crypto.c
@@ -6,7 +6,7 @@
  */
 
 #include <linux/blk-crypto.h>
-#include <linux/keyslot-manager.h>
+#include <linux/blk-crypto-profile.h>
 #include <linux/mmc/host.h>
 
 #include "cqhci-crypto.h"
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 52ea6f350b181..0f9cbe74642fe 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -32,7 +32,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/bitfield.h>
 #include <linux/devfreq.h>
-#include <linux/keyslot-manager.h>
+#include <linux/blk-crypto-profile.h>
 #include "unipro.h"
 
 #include <asm/irq.h>
diff --git a/include/linux/keyslot-manager.h b/include/linux/blk-crypto-profile.h
similarity index 100%
rename from include/linux/keyslot-manager.h
rename to include/linux/blk-crypto-profile.h
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 0c0c9a0fdf578..725b1de417673 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -15,7 +15,7 @@
 #include <linux/mmc/card.h>
 #include <linux/mmc/pm.h>
 #include <linux/dma-direction.h>
-#include <linux/keyslot-manager.h>
+#include <linux/blk-crypto-profile.h>
 
 struct mmc_ios {
 	unsigned int	clock;			/* clock rate */
-- 
2.33.0

