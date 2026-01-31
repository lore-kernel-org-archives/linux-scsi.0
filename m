Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7070527AC45;
	Sat, 31 Jan 2026 09:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769852217; cv=none; b=gtdqRRlP6bv7p3r7kgO7X7NjAwXfv7VRBQpf9PERBcnk7Twj6EAkoYovU+bp1F6/q7pFt93BMKeOGcRid2Vq00QJUeBXNRC57Kb250JxTwJILVoN3n2WJK25TZiGN8TCKZ1WySKI3QRrQblmSI/e3Bmgva4gOJSL3qC6LOjcuB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769852217; c=relaxed/simple;
	bh=0AdnMuQX5JVCkk78w/uis4nTZrjlfI8w0JvqND6rQTw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NHWZdlba6G1PR941i1pAofROrvdj0y0qvWZnoci/s2DjJSSAVwUhsEFwEdN4pLtvssfI8sjQFBrX7vpwMsKkSK4vgmKTI2EBo+4mhWXILQZrZE3MZG5+4j3XtqfxXQf55FUkU3Kuq8SUs0rc8fo+fhcWeVG1uMXC5WT2Oljtoi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=LQ2iI/ZE; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="LQ2iI/ZE"
Received: from LAPTOP-N070L597.localdomain (unknown [221.228.238.82])
	by smtp.qiye.163.com (Hmail) with ESMTP id 32a58d328;
	Sat, 31 Jan 2026 17:36:44 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: don.brace@microchip.com
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	scott.teel@microchip.com,
	john.p.donnelly@oracle.com,
	scott.benesh@microchip.com,
	Mike.McGowen@microchip.com,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH] scsi: smartpqi: fix memory leak in pqi_report_phys_luns()
Date: Sat, 31 Jan 2026 09:36:41 +0000
Message-Id: <20260131093641.1008117-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9c1369755c03a1kunme2a66fd5182f78
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCS0xPVk9OHR0YTUkeGklPH1YeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUpVSUlDVUlIQ1VDSVlXWRYaDxIVHRRZQVlPS0hVSktJSE5DQ1VKS0tVS1
	kG
DKIM-Signature: a=rsa-sha256;
	b=LQ2iI/ZEjXADD/kpEJ7mze8b1X88CJSu6xsfuHvyYFpKwBHhJ9Lpqxz9+ZCvoqfljPyqMSJtqnL6/2zZDMHSYCQbJaqhwK/HTcxADt0TKod6ez1JRe6OKYNcJG7N3L3j9x5hYhyDHBoyle+rg6X73lrO6VgsuTx9/3VVNUNrCcU=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=ptFv/pjeZ1h1A9ostGF0CCCZQ9RIs9n1X+TG1LiUbLQ=;
	h=date:mime-version:subject:message-id:from;

pqi_report_phys_luns() fails to release the rpl_list buffer when
encountering an unsupported data format or when the allocation for
rpl_16byte_wwid_list fails. These early returns bypass the cleanup
logic, leading to memory leaks.

Consolidate the error handling by adding an out_free_rpl_list label
and use goto statements to ensure rpl_list is consistently freed
on failure.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: 28ca6d876c5a ("scsi: smartpqi: Add extended report physical LUNs")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index fe549e2b7c94..c829d9590558 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1241,7 +1241,8 @@ static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **b
 			dev_err(&ctrl_info->pci_dev->dev,
 				"RPL returned unsupported data format %u\n",
 				rpl_response_format);
-			return -EINVAL;
+			rc = -EINVAL;
+			goto out_free_rpl_list;
 		} else {
 			dev_warn(&ctrl_info->pci_dev->dev,
 				"RPL returned extended format 2 instead of 4\n");
@@ -1253,8 +1254,10 @@ static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **b
 
 	rpl_16byte_wwid_list = kmalloc(struct_size(rpl_16byte_wwid_list, lun_entries,
 						   num_physicals), GFP_KERNEL);
-	if (!rpl_16byte_wwid_list)
-		return -ENOMEM;
+	if (!rpl_16byte_wwid_list) {
+		rc = -ENOMEM;
+		goto out_free_rpl_list;
+	}
 
 	put_unaligned_be32(num_physicals * sizeof(struct report_phys_lun_16byte_wwid),
 		&rpl_16byte_wwid_list->header.list_length);
@@ -1275,6 +1278,10 @@ static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **b
 	*buffer = rpl_16byte_wwid_list;
 
 	return 0;
+
+out_free_rpl_list:
+	kfree(rpl_list);
+	return rc;
 }
 
 static inline int pqi_report_logical_luns(struct pqi_ctrl_info *ctrl_info, void **buffer)
-- 
2.34.1

