From: Bandan Das <bandan.das@Stratus.com>
Subject: [PATCH] mpt fusion: Cleanup some duplicate calls in mptbase.c
Date: Wed, 16 Jun 2010 13:39:42 -0400
Message-ID: <20100616173942.GE336@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.stratus.com ([134.111.1.17]:42155 "EHLO
	mailhub4.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab0FPSf4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2010 14:35:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, linux-scsi@vger.kernel.org

In mpt_detach, call to pci_set_drvdata is redundant because it 
has already been called in mpt_adapter_disable. In mpt_attach,
ioc->pcidev is set to pdev two times.

Signed-off-by: Bandan Das <bandan.das@stratus.com>
---
 drivers/message/fusion/mptbase.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index a6a5701..2ec2fa7 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1770,7 +1770,6 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc->req_sz = MPT_DEFAULT_FRAME_SIZE;		/* avoid div by zero! */
 	ioc->reply_sz = MPT_REPLY_FRAME_SIZE;
 
-	ioc->pcidev = pdev;
 
 	spin_lock_init(&ioc->taskmgmt_lock);
 	mutex_init(&ioc->internal_cmds.mutex);
@@ -2051,7 +2050,6 @@ mpt_detach(struct pci_dev *pdev)
 
 	mpt_adapter_dispose(ioc);
 
-	pci_set_drvdata(pdev, NULL);
 }
 
 /**************************************************************************
-- 
1.6.6.1

