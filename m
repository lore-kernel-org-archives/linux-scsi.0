Received: from mx2.usergate.com (mx2.usergate.com [46.229.79.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17364213E7B;
	Mon, 21 Apr 2025 08:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.229.79.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745225217; cv=none; b=J1q7B3AKGxMFmKcLQbDfmeKb9E11u47+lZ2bgEi1aXzJNULtGQ2bfkG8/pw9khLSmRZKUz3FIaBeNAsKmqtaVpHSYpgespHznVJ6QihpzqGaxJ35On+IJhO9Y9LQL49O1Q7jIVwMMm00a2VvIxc+v6bIqJOn2rF5xb1dXGWL838=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745225217; c=relaxed/simple;
	bh=SoJeIQUy1n6bUnB19h8yR/7XX7MWJlNMbKKm5fg8pIk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GiU17ZVNr5O87R4jmnFxFC4HKijoBJ9bNuV2OM4K7muChsez6FeMg8k4fV0usNG25rhfOGUA807mv3JOBdZOxIvamDRNc5jv7yXyMCj7NlwUu9ai1R3WP6JzY7t09LMflh7uUvTM0tbKWLllnMHuH+EDCE27AU59UWYF7nqtEsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usergate.com; spf=pass smtp.mailfrom=usergate.com; arc=none smtp.client-ip=46.229.79.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usergate.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=usergate.com
Received: from mail.usergate.com[192.168.90.36] by mx2.usergate.com with ESMTP id
	 A1860D7338844D3D93CD65BC0D89C5A1; Mon, 21 Apr 2025 15:16:12 +0700
From: Boris Belyavtsev <bbelyavtsev@usergate.com>
To: <hare@suse.com>
CC: <linux-scsi@vger.kernel.org>,<linux-kernel@vger.kernel.org>,<lvc-project@linuxtesting.org>,Boris Belyavtsev <bbelyavtsev@usergate.com>
Subject: [PATCH 6.1 v2 3/3] scsi: aic79xx: check for non-NULL scb in
	 ahd_linux_queue_abort_cmd
Date: Mon, 21 Apr 2025 15:16:04 +0700
Message-ID: <20250421081604.655282-4-bbelyavtsev@usergate.com>
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
X-Message-Id: C194A9C2D7CC43F79E41C138F3D97A56
X-MailFileId: D495EA50165E4907B18C65B67EF3FA0D

possible NULL pointer dereference in case hardware returns invalid scb
index.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 73a254621007 ("[SCSI] aic79xx: update to use scsi_transport_spi")
Signed-off-by: Boris Belyavtsev <bbelyavtsev@usergate.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 17dfc3c72110..f2ae202d2641 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -2265,7 +2265,8 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd)
 		 * and hope that the target responds.
 		 */
 		pending_scb = ahd_lookup_scb(ahd, active_scbptr);
-		pending_scb->flags |= SCB_RECOVERY_SCB|SCB_ABORT;
+		if (pending_scb != NULL)
+			pending_scb->flags |= SCB_RECOVERY_SCB|SCB_ABORT;
 		ahd_outb(ahd, MSG_OUT, HOST_MSG);
 		ahd_outb(ahd, SCSISIGO, last_phase|ATNO);
 		scmd_printk(KERN_INFO, cmd, "Device is active, asserting ATN\n");
-- 
2.43.0

