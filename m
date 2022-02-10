Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBCD5C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 20:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344416AbiBJUnq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 15:43:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344402AbiBJUnn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 15:43:43 -0500
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CAFE10AA;
        Thu, 10 Feb 2022 12:43:43 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.88,359,1635199200"; 
   d="scan'208";a="5603091"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 21:42:34 +0100
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Sathya Prakash <sathya.prakash@broadcom.com>
Cc:     kernel-janitors@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] [SCSI] mptfusion: use GFP_KERNEL
Date:   Thu, 10 Feb 2022 21:42:22 +0100
Message-Id: <20220210204223.104181-9-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220210204223.104181-1-Julia.Lawall@inria.fr>
References: <20220210204223.104181-1-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Pci_driver probe functions aren't called with locks held
and thus don't need GFP_ATOMIC. Use GFP_KERNEL instead.

Problem found with Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/message/fusion/mptspi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index acd4805dcf83..388675cc1765 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1493,7 +1493,7 @@ mptspi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* SCSI needs scsi_cmnd lookup table!
 	 * (with size equal to req_depth*PtrSz!)
 	 */
-	ioc->ScsiLookup = kcalloc(ioc->req_depth, sizeof(void *), GFP_ATOMIC);
+	ioc->ScsiLookup = kcalloc(ioc->req_depth, sizeof(void *), GFP_KERNEL);
 	if (!ioc->ScsiLookup) {
 		error = -ENOMEM;
 		goto out_mptspi_probe;

