Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A70413BAC3
	for <linux-scsi@vger.kernel.org>; Sat, 10 Aug 2024 04:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723264028; cv=none; b=SvtNzklS7H4XqHvRksWVq69xqhU9hpsft5XIeE0OR2cvmg5xSwJfMFjzzoDYrDDByiWr2W5+V3kh/blFHNY57BhMWdrdDawGEVncFmSb1CpRHjnmvW7I3OFHpIOzo6ocHzCIqaMBnAP3Qe6PdfpaPaEGgYrpMD2KALYPcD7v/kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723264028; c=relaxed/simple;
	bh=VVSPRUsc7Mto2Ak2yGAbQpK8kbQmxKtQVAJuvlYTbg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4R7or6EEkN8XBVdGKPqKw+4/xof64m5zY4KdgCKqkDq96ju7Fv7uIkQitYi1DrAgxsWg7JFX1Tb3FseLW3ylmM/QDK4Lu7lAnnrvcZjyZAQZzf0mr/wrl2eJNx9mPH/53fjbSQk0LCRME/OltPxI7+oBRXsnnXfSQ3hOC/lzVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UNRmB+UB; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UNRmB+UB"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1723264026; x=1754800026;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VVSPRUsc7Mto2Ak2yGAbQpK8kbQmxKtQVAJuvlYTbg0=;
  b=UNRmB+UB7ljCSuNQVQ2xOrsP6TozkiTavD5hEwjqcweSiboUxO5+WN8B
   Zzjxs5FzQnJc2IueEgYHlczhJn0QCF42LDuhkFafV1WH0EPkA+QQiGlcP
   RJ+h9S1uVwYvD/Au7tBI65furUaJq9Gt+5X3oJeZTKsOsJjl/FsKaY4n8
   SitGgDKfTISZ8X0Ws70Nh3fiivN8D9WowOIV76450smwScWIEOb1t4+zM
   ANWlDOT2fazXjZy6nhcTTfzhWKIDPi+yEVYL5s6JwOTlnleeR9d6wxKtc
   X8a+OeHKXTkvfB4mszaQ/lU+bUPQEU8abWSyqgLSuEDEY6bXF6Da64uAD
   A==;
X-CSE-ConnectionGUID: aAs2P32ZSTCEBid7PI853Q==
X-CSE-MsgGUID: 5niHlOP0S5ulrdQub10UJw==
X-IronPort-AV: E=Sophos;i="6.09,278,1716220800"; 
   d="scan'208";a="23359483"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Aug 2024 12:27:06 +0800
IronPort-SDR: 66b6df70_Bi0WgFmsVEAhThHY7f7hSxpH1paLL3FiawBCb++g8bTfTPL
 cC9g2eBPfRoz9OAjx1g13ecb0po8MizrdIu4skA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Aug 2024 20:33:05 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 09 Aug 2024 21:27:05 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: linux-scsi@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/2] scsi: mpi3mr: Avoid MAX_PARE_ORDER WARNING for buffer allocations
Date: Sat, 10 Aug 2024 13:27:01 +0900
Message-ID: <20240810042701.661841-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240810042701.661841-1-shinichiro.kawasaki@wdc.com>
References: <20240810042701.661841-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit fc4444941140 ("scsi: mpi3mr: HDB allocation and posting for
hardware and firmware buffers") added mpi3mr_alloc_diag_bufs() which
calls dma_alloc_coherent() to allocate the trace buffer and the firmware
buffer. mpi3mr_alloc_diag_bufs() decides the buffer sizes from the
driver configuration. In my environment, the sizes are 8MB. With the
sizes, dma_alloc_coherent() fails and report this WARNING:

    WARNING: CPU: 4 PID: 438 at mm/page_alloc.c:4676 __alloc_pages_noprof+0x52f/0x640

The WARNING indicates that the order of the allocation size is larger
than MAX_PAGE_ORDER. After this failure, mpi3mr_alloc_diag_bufs()
reduces the buffer sizes and retries dma_alloc_coherent(). In the end,
the buffer allocations succeed with 4MB size in my environment, which
corresponds to MAX_PAGE_ORDER=10. Though the allocations succeed, the
WARNING message is misleading and should be avoided.

To avoid the WARNING, check the orders of the buffer allocation sizes
before calling dma_alloc_coherent(). If the orders are larger than
MAX_PAGE_ORDER, fall back to the retry path.

Fixes: fc4444941140 ("scsi: mpi3mr: HDB allocation and posting for hardware and firmware buffers")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 8b0eded6ef36..01f035f9330e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -100,7 +100,8 @@ void mpi3mr_alloc_diag_bufs(struct mpi3mr_ioc *mrioc)
 			dprint_init(mrioc,
 			    "trying to allocate trace diag buffer of size = %dKB\n",
 			    trace_size / 1024);
-		if (mpi3mr_alloc_trace_buffer(mrioc, trace_size)) {
+		if (get_order(trace_size) > MAX_PAGE_ORDER ||
+		    mpi3mr_alloc_trace_buffer(mrioc, trace_size)) {
 			retry = true;
 			trace_size -= trace_dec_size;
 			dprint_init(mrioc, "trace diag buffer allocation failed\n"
@@ -118,8 +119,12 @@ void mpi3mr_alloc_diag_bufs(struct mpi3mr_ioc *mrioc)
 	diag_buffer->type = MPI3_DIAG_BUFFER_TYPE_FW;
 	diag_buffer->status = MPI3MR_HDB_BUFSTATUS_NOT_ALLOCATED;
 	if ((mrioc->facts.diag_fw_sz < fw_size) && (fw_size >= fw_min_size)) {
-		diag_buffer->addr = dma_alloc_coherent(&mrioc->pdev->dev,
-		    fw_size, &diag_buffer->dma_addr, GFP_KERNEL);
+		if (get_order(fw_size) <= MAX_PAGE_ORDER) {
+			diag_buffer->addr
+				= dma_alloc_coherent(&mrioc->pdev->dev, fw_size,
+						     &diag_buffer->dma_addr,
+						     GFP_KERNEL);
+		}
 		if (!retry)
 			dprint_init(mrioc,
 			    "%s:trying to allocate firmware diag buffer of size = %dKB\n",
-- 
2.45.2

