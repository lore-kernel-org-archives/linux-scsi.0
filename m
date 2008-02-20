From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [Fwd: [2.6 patch] message/fusion/mptbase.c: fix use-after-free's]
Date: Tue, 19 Feb 2008 20:03:57 -0600
Message-ID: <1203473037.3103.35.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43510 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087AbYBTCEF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2008 21:04:05 -0500
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 5ED339758
	for <linux-scsi@vger.kernel.org>; Tue, 19 Feb 2008 20:03:58 -0600 (CST)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.int.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TzqfKJmPvgxM for <linux-scsi@vger.kernel.org>;
	Tue, 19 Feb 2008 20:03:57 -0600 (CST)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id CB63F970B
	for <linux-scsi@vger.kernel.org>; Tue, 19 Feb 2008 20:03:57 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


-------- Forwarded Message --------
From: Adrian Bunk <bunk@kernel.org>
To: Sathya Prakash <sathya.prakash@lsi.com>, James Bottomley
<James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] message/fusion/mptbase.c: fix use-after-free's
Date: Wed, 20 Feb 2008 02:39:43 +0200

This patch fixes two use-after-free's introduced by
commit e78d5b8f1e73ab82f3fd041d05824cfee7d83a2c and spotted by the 
Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/message/fusion/mptbase.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

901baeee449285d231921d0812b64b0f14d794b8 diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index bfda731..0c303c8 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1481,15 +1481,15 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ioc->bars = pci_select_bars(pdev, IORESOURCE_MEM);
 	if (pci_enable_device_mem(pdev)) {
-		kfree(ioc);
 		printk(MYIOC_s_ERR_FMT "pci_enable_device_mem() "
 		       "failed\n", ioc->name);
+		kfree(ioc);
 		return r;
 	}
 	if (pci_request_selected_regions(pdev, ioc->bars, "mpt")) {
-		kfree(ioc);
 		printk(MYIOC_s_ERR_FMT "pci_request_selected_regions() with "
 		       "MEM failed\n", ioc->name);
+		kfree(ioc);
 		return r;
 	}
 

