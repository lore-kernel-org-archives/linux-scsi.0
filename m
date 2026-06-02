Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABD63D45E6;
	Tue,  2 Jun 2026 10:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780394971; cv=none; b=h5yvaiZSpUZ6E41r8RWxNAH6dXw3XHiXZHoBduYofg0jEnohs5L0U7v64sb8TGdQe/XBVEP+mbQk3CjXWdtsMy1u4fMspepERYo8uamUK0qr2kv9LADDuzhgwlTAJWESAEn0ijj5ZGc/7gBxBuapxwYNH/8EYC/vz/y1VAdWVnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780394971; c=relaxed/simple;
	bh=haPLL99Qr2k3JXU1FqUj2Jck1sLarML2sWZuV6VaomQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kUtVwmFjueFtUHMe9B6qaHwQOoGoF0Q5gUZbTaUqknGGQFKImsOIhetsA9R4COfbtsp5tSEk1NHxAMftS63os4tdY8WDLx0BNkfjlGcppQIeV6DMYKhNFjpz2tfA0Rm78oNtRN2ft6L7rkqj7OEaKiVtKNmuiJ8A5qeAl9UitFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=goOFGALG; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="goOFGALG"
Received: from DESKTOP-SUEFNF9.taila7e912.ts.net (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 40bec0b23;
	Tue, 2 Jun 2026 18:04:15 +0800 (GMT+08:00)
From: Dawei Feng <dawei.feng@seu.edu.cn>
To: njavali@marvell.com
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	stable@vger.kernel.org,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH] scsi: qla2xxx: Fix memory leak in qla2x00_mem_alloc()
Date: Tue,  2 Jun 2026 18:04:13 +0800
Message-Id: <20260602100413.435225-1-dawei.feng@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e87ca804503a2kunm3d6e343b1b0cb1
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDSEpPVk5CQx8fT04fTEtNQ1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSUhOQ0
	NVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=goOFGALGvQnqGVhjsvHjEMhxfBquNt4Gh6y1RVpp+tLmAl8V1vg4Bqd2QFqTdkGR5gOYfccMHTbH/ENdq4x3I61aoM5N9Bv1RmATABGO3KDCIGl8n52QioXY342rGpZ9MgdYyZD59b8AywYZGfC1ddGpyLCKZWwOwLT0MnIhDa0=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=SA9qfxqt85gDNLTNr9sqi62vysEkejATwW2Rafp6dHM=;
	h=date:mime-version:subject:message-id:from;

In qla2x00_mem_alloc(), if kzalloc_obj() fails during the DIF bundling
buffer pool setup, the code directly returns -ENOMEM. This bypasses the
error unwind path and leaks previously allocated resources.

Fix this memory leak by routing the allocation failure to the
fail_dma_pool label.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1-rc6.

An x86_64 allyesconfig build showed no new warnings. As we do not have a
QLogic qla2xxx adapter configured to exercise the target-mode DIF setup
path, no runtime testing was able to be performed.

Fixes: 50b812755e97 ("scsi: qla2xxx: Fix DMA error when the DIF sg buffer crosses 4GB boundary")
Cc: stable@vger.kernel.org
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
---
 drivers/scsi/qla2xxx/qla_os.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 72b1c28e4dae..8ebd2d0f06d6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4251,7 +4251,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 					ql_dbg_pci(ql_dbg_init, ha->pdev,
 					    0xe0ee, "%s: failed alloc dsd\n",
 					    __func__);
-					return -ENOMEM;
+					goto fail_dma_pool;
 				}
 				ha->dif_bundle_kallocs++;
 
@@ -4536,6 +4536,14 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	if (ql2xenabledif) {
 		struct dsd_dma *dsd, *nxt;
 
+		list_for_each_entry_safe(dsd, nxt, &ha->pool.good.head, list) {
+			list_del(&dsd->list);
+			dma_pool_free(ha->dif_bundl_pool, dsd->dsd_addr, dsd->dsd_list_dma);
+			ha->dif_bundle_dma_allocs--;
+			kfree(dsd);
+			ha->dif_bundle_kallocs--;
+		}
+
 		list_for_each_entry_safe(dsd, nxt, &ha->pool.unusable.head,
 		    list) {
 			list_del(&dsd->list);
-- 
2.34.1

