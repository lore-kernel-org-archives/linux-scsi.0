Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A317A9476
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 22:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768257478; cv=none; b=sjXmenl9S/WKwAYU3Ds3Jc71nrABDuP5Wp2V46uVte9xA3XO8yOieM/2AUavT33q/VAZV7OEp3QaZHp5ohIYi6nhAK99yZW3miyNZPDb+RuMEgrbxaaANwSAWv4fW4u0sCM/x+ZEbxVyCjNzYYjS8K5mX8j4E2p2UrhQLEr1loI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768257478; c=relaxed/simple;
	bh=l/pUtO3oIWu1FynHaP7yAsE1GtOc8btYTXaMsnQdrpw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qMfgwIrtkdaqQ68nb1Sfa7WHFhU7aZrVaDXSBqwSLTTtCMa0N4UfdQQOoOzi8YvzHplu5w7Jj0CRjffwNQ50HjO/vnMUxN7c7/+fMT7j9slvP9PDcFC5gitZ316WKrJQ+kVUEBl6GrfL9Y2DlGJccq2MR4EVf+gstNCxjjE+7lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G2CgP/Gm; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G2CgP/Gm"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768257473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=G3UjYWAovGTu8iwIfwhRI2nfSNRo1SEJuqinSNyUMNU=;
	b=G2CgP/Gm4afQw1qAvjBrtW21+P7+YHQyV50T0MhKpDLW2bQ8GBF+6Oo9BBYepoU4pw9NFH
	TeVID/qxLO9iTyGK7YHAHirRv0gmv1zKPwq8VfovVkoGhh3MYLrNs7ZxGW5ztqIP8nZnA/
	F0QD3It9tQoceijgbDHw5l1ycDVVXP0=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Khalid Aziz <khalid@gonehiking.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] platform/surface: Replace deprecated strcpy + strcat in blogic_rdconfig
Date: Mon, 12 Jan 2026 23:37:36 +0100
Message-ID: <20260112223737.787813-1-thorsten.blum@linux.dev>
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
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

