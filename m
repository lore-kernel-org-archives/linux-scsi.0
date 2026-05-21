Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F70A3812F1;
	Thu, 21 May 2026 03:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779333267; cv=none; b=YfadEtnnV1KWFZGJYLqwLY5HiSx5Znfzg3LSNqhMQP2GbqfnsqRt3SOR/zo2XnObEem2NDGavZTrNk8DxqLxM1lBLjf+z6VriZk/9Q+7A1FEmI3tfx0sfF8EC5+YsQt192ad4Q+MBHTSv5L1vDm9w2ZsN9fRlXk6I/n4E/XIbdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779333267; c=relaxed/simple;
	bh=NuPs5Wt3ZXqO3yJXgL3HNrnkWKVI9WtDHzWN1jQ9VOE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Qrwc5WRTLui0npN13ZQx3mgADGznaNBQsbrOd3ZZKcfC0P18MIq+OZiZPG7MFwUzWY2RnkeGZlqby4+oICy7WbdJeqjIQ3IArry4pG2yrDmPL01ZeHxOg+GJoL5rHVQsDj+vurs63eASjc6TxcHiYXF89I4IN08vHTa9xdq1KUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=PDeKYE0l; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="PDeKYE0l"
Received: from DESKTOP-SUEFNF9.taila7e912.ts.net (unknown [221.228.238.82])
	by smtp.qiye.163.com (Hmail) with ESMTP id 3f3d06375;
	Thu, 21 May 2026 11:09:01 +0800 (GMT+08:00)
From: Dawei Feng <dawei.feng@seu.edu.cn>
To: kashyap.desai@broadcom.com
Cc: sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	stable@vger.kernel.org,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [RESEND PATCH] scsi: megaraid_sas: Fix double free on cmd_list alloc failure
Date: Thu, 21 May 2026 11:08:46 +0800
Message-Id: <20260521030846.3067149-1-dawei.feng@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e488206e503a2kunm04e4424122c53
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCTRhOVh5CH0xJSUNMTh9OTVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUpVSUlDVUlIQ1VDSVlXWRYaDxIVHRRZQVlPS0hVSktJSE
	5DQ1VKS0tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=PDeKYE0lOHg7wI58h9Ty0u867osWZQlKqY8vgoUwDqi4uXwgZsewqHtlpJKtV97qvnqVCcS/Vla/f8sAECGKf5r7lYh7+jqKv3TQ3udb7y8FawB3iATKnhu2Nkq8LSphyUg42WrI6WcooIdWNsbIswucPIRpjpaIdtf4QcN+9iI=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=gQG8YxIFPoXUmJi+jY2+teNIFslv94KOg4udG+pQUwo=;
	h=date:mime-version:subject:message-id:from;

If one of the per-command allocations in
megasas_alloc_cmdlist_fusion() fails, megasas_alloc_cmdlist_fusion()
frees the previously allocated command objects and the cmd_list array
before returning an error. megasas_alloc_cmds_fusion() then goes to
fail_exit and calls megasas_free_cmds_fusion(), which tries to free
the same cmd_list resources again.

Set fusion->cmd_list to NULL after local cleanup in
megasas_alloc_cmdlist_fusion() so the outer cleanup path skips the
already freed array and only releases the remaining resources.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1-rc3.

Runtime validation was not performed because reproducing this path
requires a MegaRAID controller and fault injection for command-list
allocation failure during controller initialization.

Fixes: e97e673ca63b ("scsi: megaraid_sas: Retry with reduced queue depth when alloc fails for higher QD")
Cc: stable@vger.kernel.org
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
---
Resending to LKML as I had a typo in the domain name earlier. No code changes.
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 2699e4e09b5b..a68e08132a61 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -611,6 +611,7 @@ megasas_alloc_cmdlist_fusion(struct megasas_instance *instance)
 			for (j = 0; j < i; j++)
 				kfree(fusion->cmd_list[j]);
 			kfree(fusion->cmd_list);
+			fusion->cmd_list = NULL;
 			dev_err(&instance->pdev->dev,
 				"Failed from %s %d\n",  __func__, __LINE__);
 			return -ENOMEM;
-- 
2.34.1

