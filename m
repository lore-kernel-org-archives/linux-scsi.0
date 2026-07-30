Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60299368D40;
	Thu, 30 Jul 2026 03:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785381584; cv=none; b=EGvM0emoLSi2D0ruHtrsUhT+V1/8lfk7mxaakK//77h4izaDotj9Ub3BSzbvI3cVFSvvSO21MqhhZSMfxz3GDjWN816YI4DNJtPZpo/sLSmZPaWqvdYwjmjy8qYVocz+uYnfpztzYr0DiIXtcOI1bEzVKkysvxcwRzZiUs1Eiqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785381584; c=relaxed/simple;
	bh=jo7aQSRnqbsxdk1MwZiP0YQB1Ld+o85C/X534OcFph0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=b1ssNUbxzkRebfLbt1LIju7DFFkW0UWqxZZpAAVjNkIN6x2+BuDQpvWNBJcZ/LpcUU8M7bnaEij1T3QGwp4c2ntpgUiVOsxRF6sGTyZIQMYYBv1RzhqoUhoYTYxS/RcQATGTNmDcTzM2Una4n9Ya0CuDAfmQUS/1ZOCWRFRlPuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=PN9ZOdbk; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="PN9ZOdbk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=D+
	gklbUHWhnbM5bmsK8S+h7yVFICuoizJ53thTmyNLI=; b=PN9ZOdbkHf6MFGUFta
	m+NyFAEOegOPWd8blMMHjrr8Ts1xYQLBsnjbFAJtv44PGCG8gZD56SauG6ohJ/lH
	0/ZDgIeBTgkFz1jqk3pi8nfX5k+/LU2lGj6bRSKEMH2/P56/GWM0ELprtBlB1ApS
	4EL76L7EybCfaqQEyTophvp30=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wCXJy25wmpqQd4JLA--.184S2;
	Thu, 30 Jul 2026 11:19:25 +0800 (CST)
From: kensanya@163.com
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	TanZheng <tanzheng@kylinos.cn>
Subject: [PATCH] scsi: target: Fix stack out-of-bounds in ALUA lu_gp and tg_pt_gp store
Date: Thu, 30 Jul 2026 11:19:17 +0800
Message-Id: <20260730031917.72750-1-kensanya@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCXJy25wmpqQd4JLA--.184S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGr4xurWUXw1xJFy3XFWDArb_yoW5Cry3pF
	Wjg34rJFWkWFZ0qay8J3W2gFyDZws8tFy5Ca4xta4ruw4YyrWUtanrA3y2gFn8JFs5Gry2
	9a95Aw18tFZ7XaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UDEfrUUUUU=
X-CM-SenderInfo: 5nhq2txq1dqiywtou0bp/xtbC6R0V8Gpqwr1f6QAA3Y

From: TanZheng <tanzheng@kylinos.cn>

Both alua_lu_gp and alua_tg_pt_gp allow a write of exactly
LU/TG_PT_GROUP_NAME_BUF bytes into a same-sized stack buffer,
then pass it to strstrip() without a trailing NUL. A full-sized
write causes strlen() to read past the end of the array (visible
under KASAN as stack-out-of-bounds).

Enlarge the local buffers by one byte so a full-sized write
remains NUL-terminated.

Signed-off-by: TanZheng <tanzheng@kylinos.cn>
---
Reproduction (before the fix)

modules + configfs
modprobe configfs target_core_mod target_core_rd iscsi_target_mod
mount -t configfs none /sys/kernel/config 2>/dev/null || true
CORE=/sys/kernel/config/target/core
ISCSI=/sys/kernel/config/target/iscsi

# --- case A: alua_lu_gp (core device) ---
mkdir -p $CORE/rd_mcp_0/ram1
echo "rd_pages=16" > $CORE/rd_mcp_0/ram1/control
echo 1 > $CORE/rd_mcp_0/ram1/enable
python3 -c 'open("'"$CORE"'/rd_mcp_0/ram1/alua_lu_gp","wb").write(b"\xff"*256)'

# --- case B: alua_tg_pt_gp (fabric LUN) ---
IQN=iqn.2024-01.local:kasan-alua
mkdir -p $ISCSI/$IQN/tpgt_1/lun/lun_0
ln -sf $CORE/rd_mcp_0/ram1 $ISCSI/$IQN/tpgt_1/lun/lun_0/ram1
echo 1 > $ISCSI/$IQN/tpgt_1/enable
python3 -c 'open("'"$ISCSI"'/'"$IQN"'/tpgt_1/lun/lun_0/alua_tg_pt_gp","wb").write(b"\xff"*256)'

 drivers/target/target_core_alua.c     | 3 +--
 drivers/target/target_core_configfs.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 10250aca5a81..60259417013b 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1904,7 +1904,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 	 */
 	struct se_device *dev = rcu_dereference_raw(lun->lun_se_dev);
 	struct t10_alua_tg_pt_gp *tg_pt_gp = NULL, *tg_pt_gp_new = NULL;
-	unsigned char buf[TG_PT_GROUP_NAME_BUF];
+	unsigned char buf[TG_PT_GROUP_NAME_BUF + 1] = { };
 	int move = 0;
 
 	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA ||
@@ -1915,7 +1915,6 @@ ssize_t core_alua_store_tg_pt_gp_info(
 		pr_err("ALUA Target Port Group alias too large!\n");
 		return -EINVAL;
 	}
-	memset(buf, 0, TG_PT_GROUP_NAME_BUF);
 	memcpy(buf, page, count);
 	/*
 	 * Any ALUA target port group alias besides "NULL" means we will be
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 2b19a956007b..0e50987e6dbe 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2518,7 +2518,7 @@ static ssize_t target_dev_alua_lu_gp_store(struct config_item *item,
 	struct se_hba *hba = dev->se_hba;
 	struct t10_alua_lu_gp *lu_gp = NULL, *lu_gp_new = NULL;
 	struct t10_alua_lu_gp_member *lu_gp_mem;
-	unsigned char buf[LU_GROUP_NAME_BUF] = { };
+	unsigned char buf[LU_GROUP_NAME_BUF + 1] = { };
 	int move = 0;
 
 	lu_gp_mem = dev->dev_alua_lu_gp_mem;
-- 
2.25.1

