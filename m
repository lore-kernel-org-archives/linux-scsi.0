Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058BE379ED4;
	Tue, 18 Aug 2026 04:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787027260; cv=none; b=JPbviPVzK7w9ipXaYObTrQv66yUYlnf7tFMepJmpH0ZynTwlMl6+20qAUFgJRoK5ag554W90sKv11SobXhm84+cyX3k7/YZQCxZeRVwSSXImUMONOCzUildjGiXJx2MPHY8dc1cASXa/kVixucPW44mhjHmj58umMVX5n8GRPig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787027260; c=relaxed/simple;
	bh=4FEAs/0DLTDub6Cax+qu2wup/MihohBeeoK64o6r+R4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ezEYkXrJ5ylbLWGlajG97i+HmDuSciiC2FVh14THKhoe/fL6yzR1ndar7/ogtkqj0F66SqbBsKDOjlfwyEe4R4y1b4m7ICc+BDREbb82JP7h/A3l/DxZ6A2IXrtGifUZlhftgTt99IEEn545LbB0HQL4Ukk0Zm6bkjTbh7TSLhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=bEDFnZoD; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="bEDFnZoD"
Received: from PC-202605011814.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4a5b5664d;
	Tue, 18 Aug 2026 12:27:28 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
	Lee Duncan <lduncan@suse.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH] scsi: target: reject configfs db_root for ALUA metadata
Date: Tue, 18 Aug 2026 12:27:20 +0800
Message-Id: <20260818042720.1511778-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0131fd5a203a1kunmf87a4c31ff45b
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCH04eVhgfGhlDT0oZTU9KTVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSEpPSE
	xVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=bEDFnZoDeYOttk8GDpu7Xfji40sUT9AfgYbPGqTvQHu5/uDdIyzkQ6RR4cnKG64XzuUFFzHoocMWR2ZlnGNG21vLyn1tbrnRTpRPxKnXFCPsemGnQKPO4VdAqkjSnvHJdTYcgMgSCr5nAiSLlZKYXpxvrwjy7LVxqCWTi9ZA7d0=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=kFZji1UczirQvsTexDxdPp1mViiA9VfHBDfa3zLAh1Q=;
	h=date:mime-version:subject:message-id:from;

The db_root configfs attribute only validates that the supplied path
resolves to a directory. Later ALUA metadata writes build file names
under db_root and open them with filp_open().

If db_root itself points at a configfs mount, an ALUA transition that
updates metadata can re-enter configfs through that filp_open() path
while configfs is still servicing the original store. That makes the
metadata path recurse back into the same frag_sem.

Reject configfs-backed db_root values in target_core_item_dbroot_store()
so later metadata users keep running on a normal filesystem instead of
re-entering configfs.

Fixes: a96e9783e058 ("target: make target db location configurable")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/target/target_core_configfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index a2bd2e8..5ee6f9c 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -138,8 +138,16 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 			pr_err("db_root: not a directory: %s\n", db_root_stage);
 		goto unlock;
 	}
+	if (!strcmp(path.dentry->d_sb->s_type->name, "configfs")) {
+		pr_err("db_root: configfs is not a valid target database root: %s\n",
+		       db_root_stage);
+		r = -EINVAL;
+	}
 	path_put(&path);

+	if (r)
+		goto unlock;
+
 	strscpy(db_root, db_root_stage);
 	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);

-- 
2.34.1
