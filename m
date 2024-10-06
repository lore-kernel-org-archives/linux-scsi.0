Received: from gw.red-soft.ru (red-soft.ru [188.246.186.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F3D74C08;
	Sun,  6 Oct 2024 21:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.246.186.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728249200; cv=none; b=kgAxg6Ayzt4OaazdXQ2bICJ+SksoHRIjJ6DHPqVQordjcRRLCUuVYlEYXeDK0r9pbitIj1Q199hI4WO8y0ULwlRtsktzcYOMnE5tnY/o7KxgSF2tcDggJPN2TksbExcvidNWbKF8j+WP0iTzzaaKDt0dh7gnx0I1q0DDhNFoK1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728249200; c=relaxed/simple;
	bh=PNd5cfZ7xDAfJce/2j1HH3jL8umWvU/IXHHPvR5WoIY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dYgq2bfrkHZHY9notQ0jDo3KGUd7Wt6x5s5qhMjyl6iQG3PDxJ5Y5072770LX1t0JsC+kuz1v2v5Eq28zu1HhagPCOebBUlqFJ+PjmG0DWzefYeOshNggVtGp5ya54XbaASdpBvRHHuPpwO5HPQOioAxTvI2xAT9/FXoyAXIl3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=red-soft.ru; spf=pass smtp.mailfrom=red-soft.ru; arc=none smtp.client-ip=188.246.186.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=red-soft.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=red-soft.ru
Received: from localhost.biz (unknown [10.81.100.48])
	by gw.red-soft.ru (Postfix) with ESMTPA id 052823E1AB8;
	Mon,  7 Oct 2024 00:03:46 +0300 (MSK)
From: Artem Chernyshev <artem.chernyshev@red-soft.ru>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH] net: pktgen: Avoid out-of-range in get_imix_entries
Date: Mon,  7 Oct 2024 00:03:38 +0300
Message-ID: <20241006210340.3627827-1-artem.chernyshev@red-soft.ru>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 188241 [Oct 06 2024]
X-KLMS-AntiSpam-Version: 6.1.0.4
X-KLMS-AntiSpam-Envelope-From: artem.chernyshev@red-soft.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 39 0.3.39 e168d0b3ce73b485ab2648dd465313add1404cce, {Tracking_from_domain_doesnt_match_to}, localhost.biz:7.1.1;red-soft.ru:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2024/10/06 20:37:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2024/10/06 20:00:00 #26711832
X-KLMS-AntiVirus-Status: Clean, skipped

In get_imit_enries() pkt_dev->n_imix_entries = MAX_IMIX_ENTRIES 
leads to oob for pkt_dev->imix_entries array.
```
UBSAN: array-index-out-of-bounds in net/core/pktgen.c:874:24
index 20 is out of range for type 'imix_pkt [20]'
CPU: 2 PID: 1210 Comm: bash Not tainted 6.10.0-rc1 #121
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
Call Trace:
<TASK>
dump_stack_lvl lib/dump_stack.c:117
__ubsan_handle_out_of_bounds lib/ubsan.c:429
get_imix_entries net/core/pktgen.c:874
pktgen_if_write net/core/pktgen.c:1063
pde_write fs/proc/inode.c:334
proc_reg_write fs/proc/inode.c:346
vfs_write fs/read_write.c:593
ksys_write fs/read_write.c:644
do_syscall_64 arch/x86/entry/common.c:83
entry_SYSCALL_64_after_hwframe arch/x86/entry/entry_64.S:130
RIP: 0033:0x7f148408b240
```

Fixes: 52a62f8603f9 ("pktgen: Parse internet mix (imix) input")

Found by Linux Verification Center (linuxtesting.org) with SVACE.
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
---
 net/core/pktgen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 34f68ef74b8f..97cf5c797a22 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -881,7 +881,7 @@ static ssize_t get_imix_entries(const char __user *buffer,
 		i++;
 		pkt_dev->n_imix_entries++;
 
-		if (pkt_dev->n_imix_entries > MAX_IMIX_ENTRIES)
+		if (pkt_dev->n_imix_entries >= MAX_IMIX_ENTRIES)
 			return -E2BIG;
 	} while (c == ' ');
 
-- 
2.44.0

