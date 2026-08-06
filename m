Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291E73DA7C8;
	Thu,  6 Aug 2026 21:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786050432; cv=pass; b=HAeFtANtR/eNpsZ/qNVjQKrMRJaTwPDfOtMygutG02EQavcCn6sfSTpv7B6My2XfXTEidE1sVwL39Kbi3c625NDIl/8cQlGK+idVC3GWjOg5OU3KFQZAbRnxFY3RPDhJ8QV5WnEMis1PX/WBKMpTD8SxXrTyase39y4JmGjviU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786050432; c=relaxed/simple;
	bh=8f06+zsj7520UiSjeBQZhCl23RqfsDPKxx5pTXd2XoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEob2q+kdZ40h8tac6W5LzmB06UJVEN7jM3NaQp+RDLTPnye0FSCb+Gs6Wpvj+smrAHjoAgtBA8apdAEAJQ32FRgJkumN0NXMYMb76h63XnoSBy7jSpwJOWpb3dsdOTFxvIPeKV9iJDI1chrt/r6LYMLADthc2lTohWIHlBPNns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com; spf=pass smtp.mailfrom=iusegentoo.com; dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b=lmtj+xl/; arc=pass smtp.client-ip=136.143.169.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b="lmtj+xl/"
ARC-Seal: i=1; a=rsa-sha256; t=1786050422; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=g5LFWZejkNqScZ+6phOaBb2eEYrrDaVdhL180B587xDtZ3U5od2wUPWReH6qLh66gtSvMIjr1G1+PcxcGtUct0FHLu1/4KycCX+o6gG8HkxGUufip4we4mXJtxmTN2R/SE1LV9HC6REzzcWogGWg8d5xfZjy1FWwXnj9MAuxtj0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1786050422; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=w7TQA3l+8+ahbtxiMgtKqEuaerlZ9HqD8/3KqW/iB6g=; 
	b=HsdA5jXv97dNQqLDa95WhUwsUGLx3wuMX3htqDkD/LzAwhM1mIv715V3XO7vmA57vAUuBhSFEPwpe+Sv5jfoTMd+FHU5zrmJdSY7rfMWN8bU9AI0WPvlZNlfF/p1z/KtnwMbEZH3ED7+fGlDag/916XWOJJKX+qNol01QuxwGhc=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=iusegentoo.com;
	spf=pass  smtp.mailfrom=ali@iusegentoo.com;
	dmarc=pass header.from=<ali@iusegentoo.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1786050422;
	s=zmail; d=iusegentoo.com; i=ali@iusegentoo.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=w7TQA3l+8+ahbtxiMgtKqEuaerlZ9HqD8/3KqW/iB6g=;
	b=lmtj+xl/d69J/iDp1xK2jwwpbegq8mG2b682Ct0WgMIj71ztQNxYp+8KtrmjWrTw
	2cDVzIp086KB013wdL578FiunXM3eNzbR3pdUqG9f7Pl9WVxGzbZqp6vfGd/PMRcRi6
	uFPtZXB1OsfUe0G9roNzBx8NfxJOzSI+znSxdnV0=
Received: by mx.zoho.eu with SMTPS id 1786050420868376.48577423499034;
	Thu, 6 Aug 2026 23:07:00 +0200 (CEST)
From: Ali Ahmet Memis <ali@iusegentoo.com>
To: Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] scsi: elx: efct: free the RQ buffers already allocated when one fails
Date: Thu,  6 Aug 2026 21:06:26 +0000
Message-ID: <20260806210631.357456-2-ali@iusegentoo.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260806210631.357456-1-ali@iusegentoo.com>
References: <20260806210631.357456-1-ali@iusegentoo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

efct_hw_rx_buffer_alloc() allocates an array of descriptors and then a
coherent DMA buffer for each entry. When one of those allocations fails it
frees the array and returns NULL, leaving every buffer allocated before it
mapped:

	if (!prq->dma.virt) {
		efc_log_err(hw->os, "DMA allocation failed\n");
		kfree(rq_buf);
		return NULL;
	}

The caller only sees NULL and the array that held the addresses is gone,
so nothing can free them afterwards. efct_hw_rx_free() cannot help either,
it walks rq->hdr_buf and rq->payload_buf, which are only assigned once this
function succeeds.

Use efct_hw_rx_buffer_free() for the entries that were filled in. It
unmaps those buffers and frees the array, and it is defined below
efct_hw_rx_buffer_alloc(), so add a forward declaration.

Fixes: 580c0255e4ef ("scsi: elx: efct: RQ buffer, memory pool allocation and deallocation APIs")
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
---
 drivers/scsi/elx/efct/efct_hw.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index b79c6a7ea791..cc600220168a 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -1170,6 +1170,10 @@ efct_get_wwpn(struct efct_hw *hw)
 	return get_unaligned_be64(p);
 }
 
+static void
+efct_hw_rx_buffer_free(struct efct_hw *hw, struct efc_hw_rq_buffer *rq_buf,
+		       u32 count);
+
 static struct efc_hw_rq_buffer *
 efct_hw_rx_buffer_alloc(struct efct_hw *hw, u32 rqindex, u32 count,
 			u32 size)
@@ -1196,7 +1200,7 @@ efct_hw_rx_buffer_alloc(struct efct_hw *hw, u32 rqindex, u32 count,
 						   GFP_KERNEL);
 		if (!prq->dma.virt) {
 			efc_log_err(hw->os, "DMA allocation failed\n");
-			kfree(rq_buf);
+			efct_hw_rx_buffer_free(hw, rq_buf, i);
 			return NULL;
 		}
 	}
-- 
2.55.0

