Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77AD3A0B1C;
	Tue, 24 Feb 2026 14:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771944521; cv=none; b=CTSsii+WMhl621JoBb7YAn2MAvGq0IoTQelfSPNsSgD8CUd0GH4jkbGy0AMrbeCoPhsLCS7bfMta86Q8XOO3Ubbvp3D0M11GayDLiF2qpba4Hx5MKbuKa7EBKRKbsvYDVzzXjoW87P7Kddpe3F273fZbS8mVDVLWmLA/aX0xCEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771944521; c=relaxed/simple;
	bh=Q585uK4JJDD0U3PHw8yVYOplqttVwNp607FKnHC0BRI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UKgZSf66bs8AV9OqfWeLidl7jUH07YU1W5FW/k2P8QmdvKCHHZ92DK+Xy9VkDlFMsbvjo0u580o0MJoK9Li7JunPj0NgCHiLhvebYTDWnkHHFPuFlyAytEmI9SSobnL/FbjeRrv4lx3jypEWFSlKuDtH02YODxPIBKndaL0hBwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d+C7NpyG; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d+C7NpyG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771944518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jL9+oAoqW2TSXE+lBX2iHJoQ1jOBMgp+GuI3U6TbfFY=;
	b=d+C7NpyGdzIc6LYzyiF39sdVdmLOYJ8LszbOxYIHoVXwGPGAjtYG0RfSLi1iNtdXuWHaeM
	HIsD2OB34ir9TwrrJBy4juZqwqNlODEO2sn0JZOXtBvHHfxrgUt2m8hlOmTy+jBhBvDcoC
	byZ3fx/x3aiPFbjIoUpoh0V15h5RSTw=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Khalid Aziz <khalid@gonehiking.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] platform/surface: Replace deprecated strcpy + strcat in blogic_rdconfig
Date: Tue, 24 Feb 2026 15:48:27 +0100
Message-ID: <20260224144828.585577-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

strcpy() is deprecated [1] and using strcat() is discouraged. Replace
them with scnprintf().  No functional changes.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy [1]
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/scsi/BusLogic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index da6599ae3d0d..5304d2febd63 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -1632,8 +1632,8 @@ static bool __init blogic_rdconfig(struct blogic_adapter *adapter)
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

