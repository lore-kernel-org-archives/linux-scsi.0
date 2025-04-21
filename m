Received: from mx2.usergate.com (mx2.usergate.com [46.229.79.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C432561A3;
	Mon, 21 Apr 2025 08:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.229.79.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745225197; cv=none; b=uXsw8Sw+6mXdyik4LMDjmPHEwsOOz9KqD6BWNWPsKur+copG9E64Tf8qAEvBwG5h36EgukoLPnkBO76mNCuw9ad6qVAEV7T9ureF8e4rldNAZv1HkakXBpUHCRBWojezWhLpWR9W+mDR4F5IhraKTMBN2dGiLfoZjBWMbu6Kp0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745225197; c=relaxed/simple;
	bh=fPqmdjETCCWklCCMwOmlRIK5VXLxkCYZqQ3Pvxqd4g0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=esd4kUe1c+3+CFXtW3soeE2+PreW7tcAqlm9RiFUEmgV6u1tnu5HiuQ10z2qvpUFin4QLeQBNIDWc+0vS9sucaFWvJ1tdo84vsj8AVG/ADUQGBNOBgM2c90XJyNfwkkOqJ0DBcuSKdD9a634MTVw8XKxLfmkvh9hnh6xcxwqOA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usergate.com; spf=pass smtp.mailfrom=usergate.com; arc=none smtp.client-ip=46.229.79.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usergate.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=usergate.com
Received: from mail.usergate.com[192.168.90.36] by mx2.usergate.com with ESMTP id
	 39C1A7449E01451F800655EBCDF4548A; Mon, 21 Apr 2025 15:16:11 +0700
From: Boris Belyavtsev <bbelyavtsev@usergate.com>
To: <hare@suse.com>
CC: <linux-scsi@vger.kernel.org>,<linux-kernel@vger.kernel.org>,<lvc-project@linuxtesting.org>,Boris Belyavtsev <bbelyavtsev@usergate.com>
Subject: [PATCH 6.1 v2 1/3] scsi: aic79xx: check for non-NULL scb in
	 ahd_handle_seqint
Date: Mon, 21 Apr 2025 15:16:02 +0700
Message-ID: <20250421081604.655282-2-bbelyavtsev@usergate.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250421081604.655282-1-bbelyavtsev@usergate.com>
References: <20250421081604.655282-1-bbelyavtsev@usergate.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ESLSRV-EXCH-01.esafeline.com (192.168.90.36) To
 nsk02-mbx01.esafeline.com (10.10.1.35)
X-Message-Id: A32569B8126F4F42A80012AA9EDE5AA0
X-MailFileId: F64FAD1BD91046728E5398E8D134C494

NULL pointer dereference is possible when compiled with AHD_DEBUG and
AHD_SHOW_RECOVERY is set if data in SCBPTR и SCBPTR+1 ports is
incorrect.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Boris Belyavtsev <bbelyavtsev@usergate.com>
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index f9372a81cd4e..a4d5376123d3 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -2205,13 +2205,16 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int intstat)
 			ahd_print_path(ahd, scb);
 			printk("data overrun detected %s.  Tag == 0x%x.\n",
 			       ahd_lookup_phase_entry(lastphase)->phasemsg,
-			       SCB_GET_TAG(scb));
+			       scb != NULL ? SCB_GET_TAG(scb) : 0);
 			ahd_print_path(ahd, scb);
 			printk("%s seen Data Phase.  Length = %ld.  "
 			       "NumSGs = %d.\n",
 			       ahd_inb(ahd, SEQ_FLAGS) & DPHASE
 			       ? "Have" : "Haven't",
-			       ahd_get_transfer_length(scb), scb->sg_count);
+			       scb != NULL ? ahd_get_transfer_length(scb) : -1,
+			       scb != NULL ? scb->sg_count : -1);
+			if (scb == NULL)
+				break;
 			ahd_dump_sglist(scb);
 		}
 #endif
-- 
2.43.0

