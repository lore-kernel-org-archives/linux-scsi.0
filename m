Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D26C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234576AbiGFXgG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbiGFXgF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:36:05 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084E12CCA5;
        Wed,  6 Jul 2022 16:36:05 -0700 (PDT)
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B6AD0C06E9;
        Wed,  6 Jul 2022 23:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150564; bh=7XZC//FjT8V7YbxDMiaxmHsFWT/vd2SLfx/okdtJIOo=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=TzpISlAhrUptKs9h3pUx6faJ69KLBUE9O5g6HODfywIuwfZMVV/SgR4b1zgXGSUG2
         HIn7ERC3QWqW2CkFRrP5RGWePOV1ymX8mYxTj/wVZtNUrVJVSwbGlZiDcG5nOib5a7
         YPQ3VkIfYLK+3mfY32GRdeWecXYmtD8o6cNreZoAB7DlmyOxHmqq2vbre96F7wWis8
         +0gLSrYvz+JhHfKiPlP+WQqBDbUtaAXB8Bgm0p/MrVd9Hc4Iurz5zyubZWcJdDX+L/
         hA7oDF4yGHUOdgg9v3PExxyt949nGxHr5/XPeu33upRea6VHcSJ5x2DwUvXYTuS9qj
         W7KttD/9H24mw==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 826D8A0096;
        Wed,  6 Jul 2022 23:36:03 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:36:03 -0700
Date:   Wed, 06 Jul 2022 16:36:03 -0700
Message-Id: <fc4e9ca1c2d3989d8f7bf81785372b8ca94f544f.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 16/36] usb: gadget: f_tcm: Increase stream count
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some old builds of Microsoft Windows 10 UASP class driver reject USAP
device with stream count of 2^4. To keep compatibility with both Linux
and Windows, let's increase the stream count to 2^5. Also, internal
tests show that stream count of 2^5 increases performance slightly.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/gadget/function/tcm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/tcm.h b/drivers/usb/gadget/function/tcm.h
index 3cd565794ad7..6cb05dcd19ff 100644
--- a/drivers/usb/gadget/function/tcm.h
+++ b/drivers/usb/gadget/function/tcm.h
@@ -13,7 +13,7 @@
 #define USBG_NAMELEN 32
 
 #define fuas_to_gadget(f)	(f->function.config->cdev->gadget)
-#define UASP_SS_EP_COMP_LOG_STREAMS 4
+#define UASP_SS_EP_COMP_LOG_STREAMS 5
 #define UASP_SS_EP_COMP_NUM_STREAMS (1 << UASP_SS_EP_COMP_LOG_STREAMS)
 
 enum {
-- 
2.28.0

