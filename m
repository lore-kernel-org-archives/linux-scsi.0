From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] aacraid: check pci_alloc_consistent errors
Date: Thu, 23 Oct 2008 17:36:08 +0900
Message-ID: <20081023173626T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:44166 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbYJWIgR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Oct 2008 04:36:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: Mark_Salyzyn@adaptec.com, linux-scsi@vger.kernel.org

We need to check the address that pci_alloc_consistent() returns since
it might fail.

When pci_alloc_consistent() fails, some IOMMUs set the dma_handle
argument to zero. So we can't use fibptr->hw_fib_pa directly here.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/aacraid/commctrl.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index a735526..a5ebf8f 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -90,14 +90,24 @@ static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 	if (size < le16_to_cpu(kfib->header.SenderSize))
 		size = le16_to_cpu(kfib->header.SenderSize);
 	if (size > dev->max_fib_size) {
+		dma_addr_t daddr;
+
 		if (size > 2048) {
 			retval = -EINVAL;
 			goto cleanup;
 		}
+
+		kfib = pci_alloc_consistent(dev->pdev, size, &daddr);
+		if (!kfib) {
+			retval = -ENOMEM;
+			goto cleanup;
+		}
+
 		/* Highjack the hw_fib */
 		hw_fib = fibptr->hw_fib_va;
 		hw_fib_pa = fibptr->hw_fib_pa;
-		fibptr->hw_fib_va = kfib = pci_alloc_consistent(dev->pdev, size, &fibptr->hw_fib_pa);
+		fibptr->hw_fib_va = kfib;
+		fibptr->hw_fib_pa = daddr;
 		memset(((char *)kfib) + dev->max_fib_size, 0, size - dev->max_fib_size);
 		memcpy(kfib, hw_fib, dev->max_fib_size);
 	}
-- 
1.5.5.GIT

