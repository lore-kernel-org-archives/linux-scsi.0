Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323743B6BF7;
	Thu, 30 Jul 2026 08:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785399942; cv=none; b=JsvEXPtlhzU9iDXC93I3igbyeymjuWRw4aatKrF3+KSCaOFsxprKRlJH4+hpGzNtS/sDLpGC8IzzrIN9ALXOeolJr7D1RcQ9bMbjcPX02n6KLtBritUwnrJGTohGo00G/TAPhTkQ9d97gnc1RkFnvK80gGDzPuZyS2bYsU4MUpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785399942; c=relaxed/simple;
	bh=FE71ITZwYkcaT+9iaqVL+Bbcra0EkDJuhwAQyzdxypg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UMBBDBsH71MeLWIw+FRk2j3Tv/YHnaL3He5kopibspERKaQTw+qTiBnFeHh9975qIri4Bj7DaNYaktm/bBQz6ipINFHV/AN0BLr4Np5NhK1KuA534kunt8QWEy9AYr8G//X5/VOLoteCnLPy+rcllpz8GeOqS2rJEzbZhwVCrQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=U2Nf/qKG; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="U2Nf/qKG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=jT
	2sfFZkTOJ7LIV04JP2J2S+oQxl4QILYuaiiHThMZA=; b=U2Nf/qKGCuOx923pcD
	g6pFMyZuFBP/wOVFzzsHJs/VuGWlLorVW6E3mibDXDShsMHRp3kAA7imi17b+r/p
	1qRqP4Tpfrl4P8YLmZ7OEMvj+J/ezZgCJt2vYkksWCku+jUwiZS24aZ0n2+ZpeA4
	eQls0dAIBb684GwcUWuM1UyX4=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wA33thjCmtq6UMzMw--.44879S2;
	Thu, 30 Jul 2026 16:25:09 +0800 (CST)
From: kensanya@163.com
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	TanZheng <tanzheng@kylinos.cn>,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH] scsi: target: Fix NULL deref when clearing alua_lu_gp twice
Date: Thu, 30 Jul 2026 16:24:58 +0800
Message-Id: <20260730082458.663015-1-kensanya@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wA33thjCmtq6UMzMw--.44879S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxArW3uryDWw48Zr4kGr4UArb_yoW5uF1kpr
	42yr1kCF4vqFWUta1UWay2grnrtws7CF1UJF97Gw1rua15J34Yyr98u3y2qr1DJFs8Xry7
	Gr4qv3WkKrnFvaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jOPEfUUUUU=
X-CM-SenderInfo: 5nhq2txq1dqiywtou0bp/xtbCwgYR7GprCmZCdQAA3j

From: TanZheng <tanzheng@kylinos.cn>

Writing "NULL" to the alua_lu_gp configuration file attribute will
clear the LU group association of the device. This early return
path is only executed when lu_gp has been set. If the device has
been unassociated (for example, after the second write of "NULL"),
the storage operation will jump to  __core_alua_attach_lu_gp_mem(),
at which point lu_gp_new is NULL and a kernel crash occurs when
obtaining spin_lock(&lu_gp->lu_gp_lock).

Crash information is as follows:
[  850.069209][ T2984] BUG: kernel NULL pointer dereference, address: 0000000000000010
[  850.070015][ T2984] #PF: supervisor write access in kernel mode
[  850.070654][ T2984] #PF: error_code(0x0002) - not-present page
[  850.071284][ T2984] PGD 14d4c2067 P4D 0
[  850.071715][ T2984] Oops: Oops: 0002 [#1] SMP KASAN NOPTI
...
[  850.077945][ T2984] RSP: 0018:ff1100010a0877f8 EFLAGS: 00010297
[  850.078578][ T2984] RAX: 0000000000000000 RBX: 0000000000000010 RCX: ffffffff86b17884
[  850.079402][ T2984] RDX: 0000000000000001 RSI: 0000000000000004 RDI: ff1100010a087818
[  850.080237][ T2984] RBP: 1fe2200021410eff R08: 0000000000000001 R09: ffe21c0021410f03
[  850.081065][ T2984] R10: 0000000000000003 R11: 6e696c6261736944 R12: ff11000113c16788
[  850.081897][ T2984] R13: ff11000113c16780 R14: 0000000000000010 R15: 0000000000000000
[  850.082721][ T2984] FS:  00007fc9a84d6740(0000) GS:ff11000388fe1000(0000) knlGS:0000000000000000
[  850.083649][ T2984] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  850.084342][ T2984] CR2: 0000000000000010 CR3: 0000000154a24004 CR4: 0000000000773ef0
[  850.085172][ T2984] PKRU: 55555554
[  850.085546][ T2984] Call Trace:
[  850.085897][ T2984]  <TASK>
[  850.086208][ T2984]  ? __pfx__raw_spin_lock+0x10/0x10
[  850.086755][ T2984]  ? configfs_write_iter+0x362/0x550
[  850.087309][ T2984]  ? _raw_spin_lock+0x84/0xe0
[  850.087807][ T2984]  ? __pfx__raw_spin_lock+0x10/0x10
[  850.088345][ T2984]  __core_alua_attach_lu_gp_mem+0x29/0x1f0 [target_core_mod]
[  850.089162][ T2984]  target_dev_alua_lu_gp_store+0x1a8/0x520 [target_core_mod]
[  850.089975][ T2984]  ? __pfx_target_dev_alua_lu_gp_store+0x10/0x10 [target_core_mod]
...

When both the current group and the requested group are NULL,
an early return occurs.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260730031917.72750-1-kensanya@163.com?part=1
Signed-off-by: TanZheng <tanzheng@kylinos.cn>
---
 drivers/target/target_core_configfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 0e50987e6dbe..292730f98db4 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2572,6 +2572,12 @@ static ssize_t target_dev_alua_lu_gp_store(struct config_item *item,
 		__core_alua_drop_lu_gp_mem(lu_gp_mem, lu_gp);
 		move = 1;
 	}
+
+	if (!lu_gp_new) {
+		spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
+		return count;
+	}
+
 	/*
 	 * Associate lu_gp_mem with lu_gp_new.
 	 */
-- 
2.25.1

