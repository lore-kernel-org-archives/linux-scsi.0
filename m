Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CC4B237186;
	Mon, 17 Mar 2025 11:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.226.244.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742209339; cv=none; b=VUBeksUd7bb1c7f8L1FrYl0sM3uG90bcg17GvSRSKnePKRHcLlrd5BkzIWrvlUuBLGZgKFGWCftQZE8nTTu8WsViUXxHAU41DK7OcXxUmOu6zrla/OVjIi1QGeksaxNmT3KnaX2GD6RbokgfgMKQnF+lK2/Ow/UdGGIZ8jecOU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742209339; c=relaxed/simple;
	bh=bL3QYx2aczuym377nt5RPmYoIq4HQYGZcGFcYcU+28E=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=twMJ78oRK8GefcirWTgNT2kRc0GRBP+rZzG9t+kp1vvdXpML2J8+V9WFsJiKeGtDJ+umH2KlMChPj5Cg7SYRDhz6s3D552QdJIGYgofDR2Ytevk4px3KP5ArmvPqOzlv3nOvL6b9l9QyfGt2ayCjMn4T29dU7PAFDA4jnfQVCYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com; spf=pass smtp.mailfrom=xiaomi.com; arc=none smtp.client-ip=207.226.244.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaomi.com
X-CSE-ConnectionGUID: 6Gr2zm80SOq+e15xjO8xsQ==
X-CSE-MsgGUID: qplW48dPR9KNkhLa0AG+1A==
X-IronPort-AV: E=Sophos;i="6.14,253,1736784000"; 
   d="scan'208";a="134714987"
From: ZhangHui <zhanghui31@xiaomi.com>
To: <bvanassche@acm.org>, <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <ebiggers@google.co>, <peter.griffin@linaro.org>, <zhanghui31@xiaomi.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ufs: crypto: add host_sem lock in ufshcd_program_key
Date: Mon, 17 Mar 2025 19:01:01 +0800
Message-ID: <20250317110101.347636-1-zhanghui31@xiaomi.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BJ-MBX05.mioffice.cn (10.237.8.125) To YZ-MBX07.mioffice.cn
 (10.237.88.127)

From: zhanghui <zhanghui31@xiaomi.com>

On Android devices, we found that there is a probability that
the ufs has been shut down but the thread is still deleting the
key, which will cause the bus error.

We checked the Android reboot process and found that it is indeed
possible that some threads have not been killed before the device
shutdown, because the Android reboot process will not wait until
all threads are killed before continuing to execute.

The call stack is as follows:

__blk_crypto_evict_key+0x148/0x1c4
blk_crypto_evict_key+0x38/0x9c
dm_keyslot_evict_callback+0x18/0x2c
default_key_iterate_devices+0x40/0x50
dm_keyslot_evict+0xac/0xfc
__blk_crypto_evict_key+0xf4/0x1c4
blk_crypto_evict_key+0x38/0x9c
fscrypt_destroy_inline_crypt_key+0xb8/0x10c
fscrypt_destroy_prepared_key+0x30/0x48
fscrypt_put_master_key_activeref+0xc4/0x308
fscrypt_destroy_keyring+0xb0/0xfc
generic_shutdown_super+0x60/0x12c
kill_block_super+0x1c/0x48
kill_f2fs_super+0xc4/0x1a8
deactivate_locked_super+0x98/0x144
deactivate_super+0x78/0x8c
cleanup_mnt+0x110/0x148
__cleanup_mnt+0x14/0x20
task_work_run+0xc4/0xec
get_signal+0x6c/0x8d8
do_notify_resume+0x128/0x828
el0_svc+0x6c/0x70
el0t_64_sync_handler+0x68/0xbc
el0t_64_sync+0x1a8/0x1ac

Let's fixed this issue by adding a lock in program_key flow.

Signed-off-by: zhanghui <zhanghui31@xiaomi.com>
---
 drivers/ufs/core/ufshcd-crypto.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
index 694ff7578fc1..f3260a072c0c 100644
--- a/drivers/ufs/core/ufshcd-crypto.c
+++ b/drivers/ufs/core/ufshcd-crypto.c
@@ -5,6 +5,7 @@
 
 #include <ufs/ufshcd.h>
 #include "ufshcd-crypto.h"
+#include "ufshcd-priv.h"
 
 /* Blk-crypto modes supported by UFS crypto */
 static const struct ufs_crypto_alg_entry {
@@ -17,12 +18,18 @@ static const struct ufs_crypto_alg_entry {
 	},
 };
 
-static void ufshcd_program_key(struct ufs_hba *hba,
+static int ufshcd_program_key(struct ufs_hba *hba,
 			       const union ufs_crypto_cfg_entry *cfg, int slot)
 {
 	int i;
 	u32 slot_offset = hba->crypto_cfg_register + slot * sizeof(*cfg);
 
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		up(&hba->host_sem);
+		return -EBUSY;
+	}
+
 	ufshcd_hold(hba);
 
 	/* Ensure that CFGE is cleared before programming the key */
@@ -38,6 +45,9 @@ static void ufshcd_program_key(struct ufs_hba *hba,
 	ufshcd_writel(hba, le32_to_cpu(cfg->reg_val[16]),
 		      slot_offset + 16 * sizeof(cfg->reg_val[0]));
 	ufshcd_release(hba);
+
+	up(&hba->host_sem);
+	return 0;
 }
 
 static int ufshcd_crypto_keyslot_program(struct blk_crypto_profile *profile,
@@ -52,6 +62,7 @@ static int ufshcd_crypto_keyslot_program(struct blk_crypto_profile *profile,
 	int i;
 	int cap_idx = -1;
 	union ufs_crypto_cfg_entry cfg = {};
+	int err;
 
 	BUILD_BUG_ON(UFS_CRYPTO_KEY_SIZE_INVALID != 0);
 	for (i = 0; i < hba->crypto_capabilities.num_crypto_cap; i++) {
@@ -79,10 +90,10 @@ static int ufshcd_crypto_keyslot_program(struct blk_crypto_profile *profile,
 		memcpy(cfg.crypto_key, key->raw, key->size);
 	}
 
-	ufshcd_program_key(hba, &cfg, slot);
+	err = ufshcd_program_key(hba, &cfg, slot);
 
 	memzero_explicit(&cfg, sizeof(cfg));
-	return 0;
+	return err;
 }
 
 static int ufshcd_crypto_keyslot_evict(struct blk_crypto_profile *profile,
@@ -96,8 +107,7 @@ static int ufshcd_crypto_keyslot_evict(struct blk_crypto_profile *profile,
 	 */
 	union ufs_crypto_cfg_entry cfg = {};
 
-	ufshcd_program_key(hba, &cfg, slot);
-	return 0;
+	return ufshcd_program_key(hba, &cfg, slot);
 }
 
 /*
-- 
2.43.0

