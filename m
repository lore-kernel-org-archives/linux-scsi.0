Received: from mx2.usergate.com (mx2.usergate.com [46.229.79.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA398257425;
	Mon, 21 Apr 2025 08:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.229.79.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745225202; cv=none; b=kYuSwTB2UjLlHVgv7NqQMCZgWH3wNcL6L5avooFPuTmgT4MV76ZxsM2BJCmIbLl0PDfji3/1sPLyLNxt4xSpeszQEMeqN0oNE6tLFaJba8nQYKQQ6QS3W85SSMIpztYsL0x3wR70yIMO3chZNFLhs3PaQWThXYWtb2My2f4GHAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745225202; c=relaxed/simple;
	bh=Vy7lMI3QpzhSSwfIganKjPx2uqxZ5Rte3oBnrxAhQlM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SBN6jungU7h4eSVyOB/NkMSq1zfNkgj24qoZGiMOSMhciuxgEUtYfNmLTTmoNKhSv+scnQR5/ajNmzUEKUY1Zg/uZmQTAiKm/wFublbU8C9r/vYPsgLOUaKQvfQSzUDZ9okHYjah1kcJAsHyJjGC+MDoAFL6rYnh7DhflurgYow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usergate.com; spf=pass smtp.mailfrom=usergate.com; arc=none smtp.client-ip=46.229.79.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usergate.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=usergate.com
Received: from mail.usergate.com[192.168.90.36] by mx2.usergate.com with ESMTP id
	 1317EAD2087F4F1C85F9615EEB5A8BD7; Mon, 21 Apr 2025 15:16:11 +0700
From: Boris Belyavtsev <bbelyavtsev@usergate.com>
To: <hare@suse.com>
CC: <linux-scsi@vger.kernel.org>,<linux-kernel@vger.kernel.org>,<lvc-project@linuxtesting.org>,Boris Belyavtsev <bbelyavtsev@usergate.com>
Subject: [PATCH 6.1 v2 2/3] scsi: aic79xx: check for non-NULL scb in
	 ahd_handle_pkt_busfree
Date: Mon, 21 Apr 2025 15:16:03 +0700
Message-ID: <20250421081604.655282-3-bbelyavtsev@usergate.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250421081604.655282-1-bbelyavtsev@usergate.com>
References: <20250421081604.655282-1-bbelyavtsev@usergate.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ESLSRV-EXCH-01.esafeline.com (192.168.90.36) To
 nsk02-mbx01.esafeline.com (10.10.1.35)
X-Message-Id: 821604E1185E43DB921980A26855BC42
X-MailFileId: FB071A900D1F4C5CA2FF70B3A6138F35

If hardware returns invalid scbid scb could be NULL.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Boris Belyavtsev <bbelyavtsev@usergate.com>
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index a4d5376123d3..3595a1e35a69 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -2998,6 +2998,10 @@ ahd_handle_pkt_busfree(struct ahd_softc *ahd, u_int busfreetime)
 		ahd_print_path(ahd, scb);
 		printk("Unexpected PKT busfree condition\n");
 		ahd_dump_card_state(ahd);
+		if (scb == NULL) {
+			printk("scb pointer is NULL\n");
+			return (1);
+		}
 		ahd_abort_scbs(ahd, SCB_GET_TARGET(ahd, scb), 'A',
 			       SCB_GET_LUN(scb), SCB_GET_TAG(scb),
 			       ROLE_INITIATOR, CAM_UNEXP_BUSFREE);
-- 
2.43.0

