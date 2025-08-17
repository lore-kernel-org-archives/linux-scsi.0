Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E69B1922FA;
	Sun, 17 Aug 2025 09:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755421418; cv=none; b=oMQFhEiotJfaqFjEfAqvglztxyjO7nc1LzM7l7+mSui1Yx9F4T9rJiaqgRw4Rl/Yc5H69V1/lv6N6CeSHQSi4o6rDRVtG+cqWbp2TItnkMZ/8r3Hkx6Y4Knp5DBx6N01rncqvpw0U1J5lpH9xAQwDq4Fmlcfkj9TeHTTEXikRtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755421418; c=relaxed/simple;
	bh=oWbHlvhNrCUi01ZmpVUNOz/rsyeSjcW2QtSKuvit2fs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=p8aydrkyAHIqclgEJAZT3f+nBAROZWQdhXxF2f9krYhErucr2IJtlaPR3svS0heAaDZIzIIhTmN9rKOAlfauq0E5xXoDQfMr2NljCnDraPo99w096LDqvfle1LVOaqZx/pHWQJ+a4SBACyan64u4gkrI+OHPLmZ5JV6TflUAJLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=FPWO+6VE; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="FPWO+6VE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=d+
	r7VvRvyaGmunmyhrAQ6EiZWjRh6kAGY25XOgYsC1w=; b=FPWO+6VE4tKEbA0qb8
	sXiUTD5smHJsmeoJE5l3tmYxAT1AJU/szHWVTANfTeNT/liE+pPpnoP0SDOaZDt+
	Iwtmu/RmguzVtI4I6PWP0WKn9YlajFwf6lKdL0Hh7O+G5/gAqLb2Vm/D6WB+YunL
	SmWcYO8BnG4xyiWbMEfuvABrU=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgDnzpXemqFoQwYSAg--.12870S2;
	Sun, 17 Aug 2025 17:03:26 +0800 (CST)
From: Yang Xiuwei <yangxiuwei2025@163.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH] scsi: target: use IS_ERR_OR_NULL() to simplify error checking
Date: Sun, 17 Aug 2025 17:03:24 +0800
Message-Id: <20250817090324.2333676-1-yangxiuwei2025@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgDnzpXemqFoQwYSAg--.12870S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZF1DGFW8XFy7AFW3tF13Jwb_yoW8Xw1xpF
	W5Arn0g343JFWqg3y8Ca4Fqry8Jas7KFWFkFs3GF1rJ3y3ZrWUGF92q3W7A3WfGF95Kry3
	GFWkAr1qy3y8ZFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jNManUUUUU=
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbBDh2skGihkvF+MwABsJ

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

Replace the combination of IS_ERR() and NULL checks with the more
concise IS_ERR_OR_NULL() macro in fabric_configfs functions:
- target_fabric_make_np()
- target_fabric_make_tpg()
- target_fabric_make_wwn()

This change improves code readability without altering functionality.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 7156a4dc1ca7..1448a7ab0491 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -479,7 +479,7 @@ static struct config_group *target_fabric_make_np(
 	}
 
 	se_tpg_np = tf->tf_ops->fabric_make_np(se_tpg, group, name);
-	if (!se_tpg_np || IS_ERR(se_tpg_np))
+	if (IS_ERR_OR_NULL(se_tpg_np))
 		return ERR_PTR(-EINVAL);
 
 	se_tpg_np->tpg_np_parent = se_tpg;
@@ -937,7 +937,7 @@ static struct config_group *target_fabric_make_tpg(
 	}
 
 	se_tpg = tf->tf_ops->fabric_make_tpg(wwn, name);
-	if (!se_tpg || IS_ERR(se_tpg))
+	if (IS_ERR_OR_NULL(se_tpg))
 		return ERR_PTR(-EINVAL);
 
 	config_group_init_type_name(&se_tpg->tpg_group, name,
@@ -1112,7 +1112,7 @@ static struct config_group *target_fabric_make_wwn(
 	}
 
 	wwn = tf->tf_ops->fabric_make_wwn(tf, group, name);
-	if (!wwn || IS_ERR(wwn))
+	if (IS_ERR_OR_NULL(wwn))
 		return ERR_PTR(-EINVAL);
 
 	wwn->cmd_compl_affinity = SE_COMPL_AFFINITY_CPUID;
-- 
2.25.1

