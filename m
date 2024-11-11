Received: from smtp.smtpout.orange.fr (smtp-21.smtpout.orange.fr [80.12.242.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D664E158558;
	Mon, 11 Nov 2024 13:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731330675; cv=none; b=cKdhfNqYwN+MaQ/yesD0vF5rZsp9v8L14Jb+q7JtYi6CQJS5ZjzO1vpi/naOMLg5RqMW+SGnaA/SQNfFQu7IzXNwe18titM5DkiRi6/iLGrHEh76ZnKvVrO651cqYrZz1s+dd2fsOnNpTd3eLhDvJJV2i1/lPkDYW7N7SsSonec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731330675; c=relaxed/simple;
	bh=pcvUj6hiQws2lylwq5PlCi5h3lu5Ev1MrCrkJ29r3H8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XXQ9k26M4NBkl+dX8UEKZbKiMCjlQHkKOb0IKw0Zpe5i990f10RrQPigPFhAro02rXf258czkKjDonZyqn2NyQdCMzEBbKsa3ozNtjv47GajflrSdr0r2tJRSVHzCnD3Wjp2xt02SUDYrtrlKO3hmaxSvsrTfYRsTq+pAGeIpak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=KuO2EG7h; arc=none smtp.client-ip=80.12.242.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="KuO2EG7h"
Received: from localhost.localdomain ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id AUCBtWVCtj1r8AUCCtNM7Z; Mon, 11 Nov 2024 14:11:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1731330668;
	bh=k6+U7vZ/tn1IEQn4DKT3rhNOeOOohqN78QfNcyAx/YQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=KuO2EG7hxR5vLmuSpVztvlr/EJ4dUoRAmCfUZ/KdlWxMyiPuzc0Pp2QtyOVGopIVj
	 H75lqaf4Bx4Cu8dPOeZAVDDtKMB3MPC6btSQFd2Xn3EMeTNUCcbr/3/JOzjunAFoof
	 cOyM6NBZ4g6qakikw2E26yXblZ8pm0OJw4fuuE5hTqQDEILhc3e2NfD8vADEq8ebqG
	 B38T2AFtOYhGYD0uJflxSRHjLhhSvkrppeK1cBJ7Lg8ngRRDLk3f0/dVMBuQVyCCa8
	 bWkUo8ZOqGpRGhg7lmDCBJvV33mTnTFZtC75qGbCMkP5FJPJfJS+LTJNQH18cYHu6j
	 tUJyDvoXyrSeA==
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 11 Nov 2024 14:11:08 +0100
X-ME-IP: 90.11.132.44
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH] scsi: target: tcmu: Constify some structures
Date: Mon, 11 Nov 2024 14:10:56 +0100
Message-ID: <f83cd8469cc17391178e1181e8c26c4c1fb6028f.1731330634.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct nla_policy' and 'struct match_table_t' are not modified in this
driver.

Constifying these structures moves some data to a read-only section, so
increase overall security, especially when the structure holds some
function pointers, which is the case of struct nla_policy.

On a x86_64, with allmodconfig:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  93188	   6933	    338	 100459	  1886b	drivers/target/target_core_user.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  93508	   6581	    338	 100427	  1884b	drivers/target/target_core_user.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only
---
 drivers/target/target_core_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 717931267bda..0f5d820af119 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -361,7 +361,7 @@ static const struct genl_multicast_group tcmu_mcgrps[] = {
 	[TCMU_MCGRP_CONFIG] = { .name = "config", },
 };
 
-static struct nla_policy tcmu_attr_policy[TCMU_ATTR_MAX+1] = {
+static const struct nla_policy tcmu_attr_policy[TCMU_ATTR_MAX + 1] = {
 	[TCMU_ATTR_DEVICE]	= { .type = NLA_STRING },
 	[TCMU_ATTR_MINOR]	= { .type = NLA_U32 },
 	[TCMU_ATTR_CMD_STATUS]	= { .type = NLA_S32 },
@@ -2430,7 +2430,7 @@ enum {
 	Opt_cmd_ring_size_mb, Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_dev_config, "dev_config=%s"},
 	{Opt_dev_size, "dev_size=%s"},
 	{Opt_hw_block_size, "hw_block_size=%d"},
-- 
2.47.0

