Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45713EE1C5;
	Sun, 13 Sep 2026 12:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789303907; cv=none; b=CFeUPnuMiUF8t6pNVBUbSIhbIxyZAnwn1w6CC8ZLDw9hsd/CxwWtrn45kXsSWvZt8kKvzH5gbGs6oWplbbxF+OD2VFxJ/tT/PXZCwnglE9F2T0HmfXquJG4yNx6WemwgeRQGhMmL5znAPZ5WAV3+8wwN2vZuEZHzoOEMGawunw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789303907; c=relaxed/simple;
	bh=RIGfJLuDyUhtqviC2ztxlyWAQvGXm6TATimY6/j1jNA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=q56qcflrC7yd7IsGSL7/9E3LH6GAq0JKHojgHnw08M5q6b9v/bHjpS63om5b34y7BVNi1QOcaHV9NcvNkdOvEq73py1GK85rWi99FfLBZu0Lev/GoZ9LXKLiCWFnEq/nnlNVAGtPazfwF4ORo02RXLlYsKpvv4bl75gFWPArV1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=gxmuQfRn; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="gxmuQfRn"
Received: from seu.edu.cn (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4d907a3da;
	Sun, 13 Sep 2026 20:51:40 +0800 (GMT+08:00)
From: Slavin Liu <bolin.liu@seu.edu.cn>
To: james.bottomley@hansenpartnership.com,
	mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bolin.liu@seu.edu.cn
Subject: [PATCH] scsi: rdac: preserve controller allocation errors
Date: Sun, 13 Sep 2026 20:51:38 +0800
Message-Id: <20260913125138.109871-1-bolin.liu@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa09ad2c7be03a1kunm4c1caf0125117a
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaQhkdVhgfHh8YHUoaSEhOHlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSUhOQ0
	NVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=gxmuQfRnoVIvfWcHdxYeq79VhdghPKewxmUwZiDrwLLRrG/XYMnp/iRIwFlE2QML1q7uvbsI6XPaNmX1E8/Xp0aUs2820qiobo3UL7gi5J7N3XbffeCtWt46VBgkkfozbSp7JFH/jbY3ljOHm89Zbn7y0YDu1eziAcY/WnAYZmQ=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=FgIeEaZY4PNpJ3bCCt0tn14B6EgIp3YKOW2SEr+S+QM=;
	h=date:mime-version:subject:message-id:from;

initialize_controller() overwrites its allocation failure with
SCSI_DH_OK. Only set success after obtaining and linking a controller,
so the caller cannot reach ownership checks or cleanup with NULL ctlr.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 327825574132 ("scsi_dh_rdac: switch to scsi_execute_req_flags()")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 88c8e36b221e..ed02e1737bd7 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -455,9 +455,9 @@ static int initialize_controller(struct scsi_device *sdev,
 		else {
 			h->sdev = sdev;
 			list_add_rcu(&h->node, &h->ctlr->dh_list);
+			err = SCSI_DH_OK;
 		}
 		spin_unlock(&list_lock);
-		err = SCSI_DH_OK;
 	}
 	return err;
 }
