Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0F12701DC;
	Mon,  8 Jun 2026 14:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780928239; cv=none; b=eAoISgw4t9AMPexJQU/CS9OlR4moY/5535KKOgrFxO/231yAJbn/IZiv2tm763d6IK494tjI5QDSSdlGz7IT5rZ0iXhs2mDZZIDgtHCAAiNFL0UXdL51FdFtM96NYglhCfvgQIJA3+UplunxFvG/+ZUkQ6pHmgqmDF6lOwfAuq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780928239; c=relaxed/simple;
	bh=6/0z4FKSNACURuhS0+/w8B+qHiQn1ApsHz7WG+cxbzM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ihp9mHXqDUydYkaXAaQy+cQlMOTlxjL8NVAZs2x8uycJFBMzGDlffmjzgT5+podm0ZmUd4tYQnpWFgdW2W9aEZjkJzc6gTGhDqlgdvm/71jzfiqst4hmhS71VQm5WgCH9CNflYvW4XSD/9ZvTBp3vcAa4qvv7Pt/Mw4jBEHcAlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=J2CPqdvl; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="J2CPqdvl"
Received: from DESKTOP-SUEFNF9.taila7e912.ts.net (unknown [223.112.146.162])
	by smtp.qiye.163.com (Hmail) with ESMTP id 41880ec3f;
	Mon, 8 Jun 2026 22:12:04 +0800 (GMT+08:00)
From: Dawei Feng <dawei.feng@seu.edu.cn>
To: ketan.mukadam@broadcom.com
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	stable@vger.kernel.org,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH] scsi: be2iscsi: fix memory leak on beiscsi_init_sliport() error path
Date: Mon,  8 Jun 2026 22:12:05 +0800
Message-Id: <20260608141205.3423660-1-dawei.feng@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ea7938a5603a2kunmdaee8cc6f6166
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaH0tKVkhPSR0dQktKHx8aH1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUhVSkpJVUpPTVVKTUlZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=J2CPqdvlT1uHQTkpSulioXKvL2eOEDBNBrf3A1STZKrnKU6qWOT1fZrY5ThYo4sAtwfnTyLaLhOy4rotYVu3WXgzrzXO0DGXamL/FakVqOPVoia8AZbSO9bvJk9MWtQ14ah1tRd1knN2nE24YQrpIh5Rx4CIgfQupaKLzYNg0Z0=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=N9ohDfFbjDeeT7lmztauOMOcCf/WXKDXsyyE+c62Klw=;
	h=date:mime-version:subject:message-id:from;

In beiscsi_dev_probe(), jumping to free_hba after a beiscsi_init_sliport()
failure skips cleanup for resources allocated by be_ctrl_init().

Fix this by changing the error jump to free_port, ensuring the DMA buffer
and PCI mappings are safely released.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1-rc7.

An x86_64 allyesconfig build showed no new warnings. As we do not have an
Emulex OneConnect 10Gbps iSCSI adapter to test with, no runtime testing
was able to be performed.

Fixes: 4d2ee1e688a26 ("scsi: be2iscsi: Fix POST check and reset sequence")
Cc: stable@vger.kernel.org
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
---
 drivers/scsi/be2iscsi/be_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index fd18d4d3d219..6d69748961b0 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5568,7 +5568,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 
 	ret = beiscsi_init_sliport(phba);
 	if (ret)
-		goto free_hba;
+		goto free_port;
 
 	spin_lock_init(&phba->io_sgl_lock);
 	spin_lock_init(&phba->mgmt_sgl_lock);
-- 
2.34.1

