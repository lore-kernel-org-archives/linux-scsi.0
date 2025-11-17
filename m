Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D852F8BFC
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2025 17:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763400981; cv=none; b=O+MFWsGNfNdClzSvIwNCwYlr9SHtjMy2+RuU1OVb4+300Fzghc5oWDrrnGlEH2f88WFr8IfAFYjWfz7Gl7Q7Ham252gSGIopWr8e0rwEF1x/FyozmnR6Ss+LEEMVuMYeO3EsKB6FQuf5//jnaQQTn6HHbB4u6O4Ow0J9BS1kvVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763400981; c=relaxed/simple;
	bh=2oBY6yIS+H6mTdVxoh9l8gW7EILCPCRAcKvHy91FEOo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=vGEmQAdOvoCptHt4OBW5DNdXlMm/U2F8fRhgCe1Ahs/CEr4kUU7mDh3t1cEIlr2GUE+Cx/Y7r8sZn5SI8NU8GfTYFFp7edtHQYMY5Z6bdKxJ46ElAkbQj4kTxnzD8nJjKPwzt+9SWRP7NwcEwBHWOV3EOb/N8lOLsK43c9c7Lgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s3dziELc; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s3dziELc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763400974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Fipn2fTgtoK40YfR7n6iln5xTbdL7eQDpi2JCylrbZo=;
	b=s3dziELcqRK98nLRqGoOYCxYr7wKIRHwSyupWGvP6h6SiqeinNwqXKqAvacHucOHnUtwHb
	9nKVa7J3suuVKxHyMp+PYcTBts2DRHPdBiAdkthQFrSnDfLdy576Z7Zv19UIiUdcpO4U9V
	ILXT+5oIMuHO8FjBri5hEqe6fdID2IE=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Khalid Aziz <khalid@gonehiking.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] platform/surface: Replace deprecated strcpy + strcat in blogic_rdconfig
Date: Mon, 17 Nov 2025 18:34:48 +0100
Message-ID: <20251117173448.39525-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

strcpy() is deprecated and using strcat() is discouraged. Replace them
with scnprintf().  No functional changes.

Link: https://github.com/KSPP/linux/issues/88
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/scsi/BusLogic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index a86d780d1ba4..4382dc26bc05 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -1631,8 +1631,8 @@ static bool __init blogic_rdconfig(struct blogic_adapter *adapter)
 	/*
 	   Initialize the Host Adapter Full Model Name from the Model Name.
 	 */
-	strcpy(adapter->full_model, "BusLogic ");
-	strcat(adapter->full_model, adapter->model);
+	scnprintf(adapter->full_model, sizeof(adapter->full_model),
+		  "BusLogic %s", adapter->model);
 	/*
 	   Select an appropriate value for the Tagged Queue Depth either from a
 	   BusLogic Driver Options specification, or based on whether this Host
-- 
2.51.1

