Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6E6F9E7
	for <linux-scsi@vger.kernel.org>; Tue, 19 Dec 2023 05:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="hvLl2Cn+"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BILKWal029878;
	Mon, 18 Dec 2023 21:55:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding:content-type; s=pfpt0220; bh=Z2OjX8Lt
	KiZjqGeAtdjdh3X7uvu3WMltKn0IoZSTjqw=; b=hvLl2Cn+wO5XUHo6xw3NGJ1O
	2RIThOG/lnqr9kyFmUM+I6cBjl6VB9hsXfjCwU+R7oKcG5lcGuOzfLoXeG1CdHEF
	4niBzp9boF7Uh5crO8yy4argiYxorYY/nfFh8EZ4PuPaONU3PN/BDrEfNyerQQLz
	l1mTnR77HnvJ8aMtfUxxO9wCA6Hk/9WsYCsIcPE9Y55oGUeeLqeDC2INQWP+R/6g
	rBlmiU03PzUyHOY32mlOiIHOXEs9I4fSlKrRzEZQdPw2yo8lgMzed39lWbxYYn2u
	UXp9ZqblENT08h33Xjprkyvh4u7EwRDGs1exJ3j+PglUievSqxmqgMGepU6NlA==
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3v1c9ks7jt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Mon, 18 Dec 2023 21:55:28 -0800 (PST)
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 18 Dec
 2023 21:55:26 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Mon, 18 Dec 2023 21:55:26 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 88A9E3F708C;
	Mon, 18 Dec 2023 21:55:24 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>, <lduncan@suse.com>, <cleech@redhat.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH] cnic: change __GFP_COMP allocation method
Date: Tue, 19 Dec 2023 11:25:14 +0530
Message-ID: <20231219055514.12324-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: SxB2BllTwzYBWsVP1t2i_fe_JxN3P7Ls
X-Proofpoint-GUID: SxB2BllTwzYBWsVP1t2i_fe_JxN3P7Ls
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-09_02,2023-12-07_01,2023-05-22_02

A system crash observed resulting from iscsiuio page reference counting issue,

 kernel: BUG: Bad page map in process iscsiuio  pte:8000000877bed027 pmd:8579c3067
 kernel: page:00000000d2c88757 refcount:0 mapcount:-128 mapping:0000000000000000 index:0x0 pfn:0x877bed
 kernel: flags: 0x57ffffc0000004(referenced|node=1|zone=2|lastcpupid=0x1fffff)
 kernel: page_type: 0xffffff7f(buddy)
 kernel: raw: 0057ffffc0000004 ffff88881ffb8618 ffffea0021ba6f48 0000000000000000
 kernel: raw: 0000000000000000 0000000000000000 00000000ffffff7f 0000000000000000
 kernel: page dumped because: bad pte
 kernel: addr:00007f14f4b35000 vm_flags:0c0400fb anon_vma:0000000000000000 mapping:ffff888885004888 index:4
 kernel: file:uio0 fault:uio_vma_fault [uio] mmap:uio_mmap [uio] read_folio:0x0
 kernel: CPU: 23 PID: 3227 Comm: iscsiuio Kdump: loaded Not tainted 6.6.0-rc1+ #6
 kernel: Hardware name: HPE Synergy 480 Gen10/Synergy 480 Gen10 Compute Module, BIOS I42 09/21/2023
 kernel: Call Trace:
 kernel: <TASK>
 kernel: dump_stack_lvl+0x33/0x50
 kernel: print_bad_pte+0x1b6/0x280
 kernel: ? page_remove_rmap+0xd1/0x220
 kernel: zap_pte_range+0x35e/0x8c0
 kernel: zap_pmd_range.isra.0+0xf9/0x230
 kernel: unmap_page_range+0x2d4/0x4a0
 kernel: unmap_vmas+0xac/0x140
 kernel: exit_mmap+0xdf/0x350
 kernel: __mmput+0x43/0x120
 kernel: exit_mm+0xb3/0x120
 kernel: do_exit+0x276/0x4f0
 kernel: do_group_exit+0x2d/0x80
 kernel: __x64_sys_exit_group+0x14/0x20
 kernel: do_syscall_64+0x59/0x90
 kernel: ? syscall_exit_work+0x103/0x130
 kernel: ? syscall_exit_to_user_mode+0x22/0x40
 kernel: ? do_syscall_64+0x69/0x90
 kernel: ? exc_page_fault+0x65/0x150
 kernel: entry_SYSCALL_64_after_hwframe+0x6e/0xd8
 kernel: RIP: 0033:0x7f14f4918a7d
 kernel: Code: Unable to access opcode bytes at 0x7f14f4918a53.
 kernel: RSP: 002b:00007ffe91cfb698 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
 kernel: RAX: ffffffffffffffda RBX: 00007f14f49f69e0 RCX: 00007f14f4918a7d
 kernel: RDX: 00000000000000e7 RSI: fffffffffffffee8 RDI: 0000000000000000
 kernel: RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
 kernel: R10: 00007ffe91cfb4c0 R11: 0000000000000246 R12: 00007f14f49f69e0
 kernel: R13: 00007f14f49fbf00 R14: 0000000000000002 R15: 00007f14f49fbee8
 kernel: </TASK>
 kernel: Disabling lock debugging due to kernel taint

The dma_alloc_coherent no more provide __GFP_COMP allocation as per commit,
dma-mapping: reject __GFP_COMP in dma_alloc_attrs, and hence
instead use __get_free_pages for __GFP_COMP allocation along with
dma_map_single to get dma address in order to fix page reference counting
issue caused in iscsiuio mmap.

Fixes: bb73955c0b1d ("cnic: don't pass bogus GFP_ flags to dma_alloc_coherent")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/net/ethernet/broadcom/cnic.c | 42 ++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/cnic.c b/drivers/net/ethernet/broadcom/cnic.c
index 7926aaef8f0c..28bfb39a3c0f 100644
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -840,14 +840,20 @@ static void cnic_free_context(struct cnic_dev *dev)
 static void __cnic_free_uio_rings(struct cnic_uio_dev *udev)
 {
 	if (udev->l2_buf) {
-		dma_free_coherent(&udev->pdev->dev, udev->l2_buf_size,
-				  udev->l2_buf, udev->l2_buf_map);
+		if (udev->l2_buf_map)
+			dma_unmap_single(&udev->pdev->dev, udev->l2_buf_map,
+					 udev->l2_buf_size, DMA_BIDIRECTIONAL);
+		free_pages((unsigned long)udev->l2_buf,
+			   get_order(udev->l2_buf_size));
 		udev->l2_buf = NULL;
 	}
 
 	if (udev->l2_ring) {
-		dma_free_coherent(&udev->pdev->dev, udev->l2_ring_size,
-				  udev->l2_ring, udev->l2_ring_map);
+		if (udev->l2_ring_map)
+			dma_unmap_single(&udev->pdev->dev, udev->l2_ring_map,
+					 udev->l2_ring_size, DMA_BIDIRECTIONAL);
+		free_pages((unsigned long)udev->l2_ring,
+			   get_order(udev->l2_ring_size));
 		udev->l2_ring = NULL;
 	}
 
@@ -1026,20 +1032,40 @@ static int __cnic_alloc_uio_rings(struct cnic_uio_dev *udev, int pages)
 		return 0;
 
 	udev->l2_ring_size = pages * CNIC_PAGE_SIZE;
-	udev->l2_ring = dma_alloc_coherent(&udev->pdev->dev, udev->l2_ring_size,
-					   &udev->l2_ring_map, GFP_KERNEL);
+	udev->l2_ring = (void *)__get_free_pages(GFP_KERNEL | __GFP_COMP |
+						 __GFP_ZERO,
+						 get_order(udev->l2_ring_size));
 	if (!udev->l2_ring)
 		return -ENOMEM;
 
+	udev->l2_ring_map = dma_map_single(&udev->pdev->dev, udev->l2_ring,
+					   udev->l2_ring_size,
+					   DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(&udev->pdev->dev, udev->l2_ring_map))) {
+		pr_err("unable to map L2 ring memory %d\n", udev->l2_ring_size);
+		__cnic_free_uio_rings(udev);
+		return -ENOMEM;
+	}
+
 	udev->l2_buf_size = (cp->l2_rx_ring_size + 1) * cp->l2_single_buf_size;
 	udev->l2_buf_size = CNIC_PAGE_ALIGN(udev->l2_buf_size);
-	udev->l2_buf = dma_alloc_coherent(&udev->pdev->dev, udev->l2_buf_size,
-					  &udev->l2_buf_map, GFP_KERNEL);
+	udev->l2_buf = (void *)__get_free_pages(GFP_KERNEL | __GFP_COMP |
+						__GFP_ZERO,
+						get_order(udev->l2_buf_size));
 	if (!udev->l2_buf) {
 		__cnic_free_uio_rings(udev);
 		return -ENOMEM;
 	}
 
+	udev->l2_buf_map = dma_map_single(&udev->pdev->dev, udev->l2_buf,
+					  udev->l2_buf_size,
+					  DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(&udev->pdev->dev, udev->l2_buf_map))) {
+		pr_err("unable to map L2 buf memory %d\n", udev->l2_buf_size);
+		__cnic_free_uio_rings(udev);
+		return -ENOMEM;
+	}
+
 	return 0;
 
 }
-- 
2.23.1

