Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68EDC54FD0
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 05:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9652D208E4
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 05:20:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fudan.edu.cn header.i=@fudan.edu.cn header.b="MJ7mOz8f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgDWFU5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 01:20:57 -0400
Received: from mail.fudan.edu.cn ([202.120.224.73]:42323 "EHLO fudan.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726234AbgDWFU5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Apr 2020 01:20:57 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Apr 2020 01:20:55 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=xUU4dAAxBs+VZoReGkejHGQRSZnmR+D3rfNxFKIZ7rw=; b=M
        J7mOz8fDCdwA9Dmk4q9Eb8VVQ8to4KUE0HJ8Pt5GMMy0Ut9v1IYQ1mvfLPdudQtX
        S9dcY7N+ajI3IMDKZTUn0xxTamIWq8LMzABcwKx8e3YxWafWK7fNpgKT2N0zjpmP
        YHOctk0FEX68QOVv8QuR/5lhocq3BSMG5otmxHmJ1Q=
Received: from localhost.localdomain (unknown [120.229.255.80])
        by app2 (Coremail) with SMTP id XQUFCgDX3_88JKFecbVPAA--.17515S3;
        Thu, 23 Apr 2020 13:14:38 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] scsi: mpt3sas: Fix _pcie_device refcnt leak when removing pcie device
Date:   Thu, 23 Apr 2020 13:14:14 +0800
Message-Id: <1587618854-13602-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XQUFCgDX3_88JKFecbVPAA--.17515S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZryxGFy8Ar1fZr1rWF1rWFg_yoW8AF17pr
        WDAa4YkryDWF42gF17uF45Xry7A3Z0k3sYqa1Iga4DWr48Jry5tryrtFW5tayxJ39Yqa4D
        Jr12qr95CayUJrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl
        6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxEwVAFwVW8WwCF04k20xvY0x0EwIxGrw
        CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
        14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
        IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20E
        Y4v20xvaj40_Gr0_Zr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
        AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUBE_NUUUUU=
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

_scsih_pcie_device_remove_by_handle() invokes
__mpt3sas_get_pdev_by_handle(), which returns a reference of the
specified _pcie_device object to "pcie_device" with increased refcnt.

When _scsih_pcie_device_remove_by_handle() returns, local variable
"pcie_device" becomes invalid, so the refcount should be decreased to
keep refcount balanced.

The reference counting issue happens in one normal path of
_scsih_pcie_device_remove_by_handle(). When remove pcie device, the
function forgets to decrease the refcnt increased by
__mpt3sas_get_pdev_by_handle(), causing a refcnt leak.

Fix this issue by calling pcie_device_put() before
_scsih_pcie_device_remove_by_handle() returns.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c597d544eb39..a1e69daffc1b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1159,7 +1159,6 @@ _scsih_pcie_device_remove_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
 	if (was_on_pcie_device_list) {
 		_scsih_pcie_device_remove_from_sml(ioc, pcie_device);
-		pcie_device_put(pcie_device);
 	}
 
 	/*
@@ -1169,6 +1168,8 @@ _scsih_pcie_device_remove_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	 */
 	if (update_latency)
 		_scsih_set_nvme_max_shutdown_latency(ioc);
+	if (pcie_device)
+		pcie_device_put(pcie_device);
 }
 
 /**
-- 
2.7.4

