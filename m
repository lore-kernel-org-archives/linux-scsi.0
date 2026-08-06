Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C753D4123;
	Thu,  6 Aug 2026 20:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786047833; cv=pass; b=ccPUGVWFz0Ro1yQlS4gQy7RLaXsQapKvhrX3KG6qemtajPS0tC1Nu/PXn7/6l4qHHQA3qKgFqnLE/o257WHNQT5B0RMA/ED8DR3VYNz46iEn6vKVJz0szDU5uWQAOZshr2ncFDjpIEZHB3HudkphKmveDXSeG+KLG79xvzj0VH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786047833; c=relaxed/simple;
	bh=mPiOuN91rK3XCdzE7LwpgNEWAFRw/M29CjFNw+wLpWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gumOoWuotf5FdnBeC5LgoCX84mvBmRkHyz1p+6WcYxt2OzzgTb7lqoRZoHxko3D9ROtOpBjFTr4ftMJlgCMOLw+DpY2Ok/dqQBdYEgl2o6imah7Z9DiUEKoGbXu3F7XzjS0wiJ+idx1/fAq2ceQfP/1dqWaH+JmP9/z0jdzfmyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com; spf=pass smtp.mailfrom=iusegentoo.com; dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b=fWCvoUSc; arc=pass smtp.client-ip=136.143.169.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b="fWCvoUSc"
ARC-Seal: i=1; a=rsa-sha256; t=1786047822; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=TFUBkzT7jAKXuaNz1V7BLvuHKNu2izjbmiBzTbO9kthCNRpbZYBao6kvgLSkgK65Lfvm6qSyZ84wMbhGRSCg5XXl6t/YDK3lqG4DDzClRAXIWtbYfLMsi5yZZT/UI1bJ8Rg372yRPXFlN86OtnV5JWhV4cKPlVjoOpcaXqMD7Vk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1786047822; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=qwA2JEJ7YTCewECkp2iVhinHMow8YkUY4BQcVqUpXXI=; 
	b=aWUAxUlM2oerazmol99zrtZv2TrgYgxQtATHGMSqzgKuBh/yVRXVPHbqKlSqNwmy3qOnh58EYCF1KnDSW6s6cXNAxyrXgj04dzAnUOTeBDBj/s1Tzaw4J+2gVNUE+XAfHMAVgAUlcCkLeg1Dj4V7tv0sqzRO9bGiaKGmgZ+szuo=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=iusegentoo.com;
	spf=pass  smtp.mailfrom=ali@iusegentoo.com;
	dmarc=pass header.from=<ali@iusegentoo.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1786047821;
	s=zmail; d=iusegentoo.com; i=ali@iusegentoo.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=qwA2JEJ7YTCewECkp2iVhinHMow8YkUY4BQcVqUpXXI=;
	b=fWCvoUScNfe9RGJkWb3eAayuL2OXvKKlMFlAFNo7Poxia4/ygjp0k346CBjdl+Md
	GdcxfMJh8guN7dAILMl25acQgiH1IxgyqjsZC8XTbaic8xh8yDvsHztiGWvhaEwsnoy
	hchGiGyj/RgPcoEkpQiuI/RzB8OSIIMk44yfzi7g=
Received: by mx.zoho.eu with SMTPS id 1786047818479756.1027164714634;
	Thu, 6 Aug 2026 22:23:38 +0200 (CEST)
From: Ali Ahmet Memis <ali@iusegentoo.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] scsi: elx: efct: free the request tag when the send frame WQE fails
Date: Thu,  6 Aug 2026 20:22:03 +0000
Message-ID: <20260806202205.345326-4-ali@iusegentoo.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260806192345.328621-1-ali@iusegentoo.com>
References: <20260806192345.328621-1-ali@iusegentoo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

efct_hw_send_frame() takes a request tag from the pool and then builds the
WQE. When sli_send_frame_wqe() fails it returns without giving the tag
back:

	ctx->wqcb = efct_hw_reqtag_alloc(hw, callback, arg);
	if (!ctx->wqcb) {
		efc_log_err(hw->os, "can't allocate request tag\n");
		return -ENOSPC;
	}
	...
	if (rc) {
		efc_log_err(hw->os, "sli_send_frame_wqe failed: %d\n", rc);
		return -EIO;
	}

Nothing is submitted, so the completion that would call
efct_hw_reqtag_free() never runs and the tag stays out of the pool. The
pool is bounded by the number of request tags allocated at init, so
repeated failures leave send frame without any.

Free the tag on that path. The efct_hw_wq_write() failure below is left
alone: it can return an error while this request is still queued on
wq->pending_list, and the tag is what a later completion would look the
context up by.

Fixes: dd53d333aadb ("scsi: elx: efct: Hardware I/O submission routines")
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
---
 drivers/scsi/elx/efct/efct_hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 6cc48fa3e656..db68516e8075 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -3009,6 +3009,7 @@ efct_hw_send_frame(struct efct_hw *hw, struct fc_frame_header *hdr,
 				ctx->wqcb->instance_index);
 	if (rc) {
 		efc_log_err(hw->os, "sli_send_frame_wqe failed: %d\n", rc);
+		efct_hw_reqtag_free(hw, ctx->wqcb);
 		return -EIO;
 	}
 
-- 
2.55.0

