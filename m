Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7314D2EF8;
	Thu,  6 Aug 2026 19:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786044263; cv=pass; b=SM8t9QSh0KgRe9eZXrqShRTbecyL6vZ+Ad9ILMrZvF3dYRiQyWQhgP4Z1FGKKaD3W/G8aDiCXwXH4Ng7Q9ny1sldqNvda5KFr9bGpXAOybOQrLZSochybH9Wyq1V14GZeL+r2SE0JfUyQGJkTOpYWWVs74Ui/Zvm3faaN03eZjg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786044263; c=relaxed/simple;
	bh=mbBlgjmVN5cUBifkjEgEyu0GUSFJxXbX0rZg7Nb6EF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ni7TJl1DvwchaKJ7+4KHrQjWdSl+LssG91Y8gHfgR7c+JPRlubM9DfSGF6VP5eG2wIgCwRc8uD/hXx8aAEDF1MogNx5SuH3Z/jAAenNUohYn6BKKeoKSi+3vyanTYh3PVXwPYbFoXbzFZqNXCjEzVNx0Su67zqYJSId3iuT1jVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com; spf=pass smtp.mailfrom=iusegentoo.com; dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b=nOoh/FRH; arc=pass smtp.client-ip=136.143.169.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b="nOoh/FRH"
ARC-Seal: i=1; a=rsa-sha256; t=1786044242; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=g7TSQt/d99RtYSBTTEo0AIRSCPHE2NwpsixRhxDTkVTc4BuCw4YZxf3tAJVJAHObRXsb+O3kWa4npUTLki54h/5NoDK3sKtk3ZMohgtgMxpJUsutQrDEMIfNK1+j+c9soSmtvMbmj5lqVZeQYDTdXn8QDSef++K37gMVX4vg2SA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1786044242; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=4sPAix17R1RQ+ZPo4cVzETgK7IB/8stOZkQGjf8f7t8=; 
	b=TQuOiUCGsxTv+5r2WPRM0DTwXUURnoII8GCxV16eNsTqHslPiEkWTxKQnVOVHeZWwiywRgPnyri2wYTW7yJtoWVmA8Clp+l+SFx0ddELLe5IdKC8wXbiO/U4z1wRYvP/EbsQkp0/0h88OyfwhagnlkR5jpRexdY0/3P4PICMboQ=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=iusegentoo.com;
	spf=pass  smtp.mailfrom=ali@iusegentoo.com;
	dmarc=pass header.from=<ali@iusegentoo.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1786044242;
	s=zmail; d=iusegentoo.com; i=ali@iusegentoo.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=4sPAix17R1RQ+ZPo4cVzETgK7IB/8stOZkQGjf8f7t8=;
	b=nOoh/FRH40yygO+/GkBJ3+kt04S/GUXQsfJXOpAdg+k/cS71F3EmL4NbPgkllavJ
	i1MWHxZN+CiNpwaN1p7A+bedT3j9bYjsiH80RaqrNjYNwCY8DcXeMXIZE60H4KChlyQ
	fVKWTcN3Emj6j4aTtcTPkks920vC0QNdt/tIBBHM=
Received: by mx.zoho.eu with SMTPS id 1786044241824628.2237964188298;
	Thu, 6 Aug 2026 21:24:01 +0200 (CEST)
From: Ali Ahmet Memis <ali@iusegentoo.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] scsi: elx: efct: free the RQ buffers already allocated when one fails
Date: Thu,  6 Aug 2026 19:23:44 +0000
Message-ID: <20260806192345.328621-5-ali@iusegentoo.com>
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

Use efct_hw_rx_buffer_free() for the entries that were filled in.

Fixes: 580c0255e4ef ("scsi: elx: efct: RQ buffer, memory pool allocation and deallocation APIs")
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
---
 drivers/scsi/elx/efct/efct_hw.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index db68516e8075..d645ce256b8a 100644
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

