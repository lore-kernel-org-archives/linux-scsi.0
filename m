Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD5E4C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbiGFXgN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbiGFXgM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:36:12 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3993E2CC96;
        Wed,  6 Jul 2022 16:36:11 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id DF199C06E7;
        Wed,  6 Jul 2022 23:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150571; bh=F3Qoy0QuryBNUqCHx2QWqtDm02xUe/FRghqpjnMdxjw=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=flOP24YJugwaCOZ9Uar56iE4yMYr4U4ZIUtEjdfKmKY+/toHUzXlz3e07fTt5/x2i
         R9sDfEli8pAfDwUvQwBa5cKx6ww/icqA0TJZ3QoxkNTHlD52M6k+n02gC09myu/TSp
         t8piO0d5CNMeK5ij78/u9ejxFYgbcQDprvQHJsgpa0pWFmIVkbIq447AaHuy+Ev03F
         S/bISRQ/5CYbWdG77ipCAFQZSSU67XORYLsB6B3oar3MIC8g8E9wNgVQmoOH86+bpW
         ggqsOdoCLWoGL8HtZq2x9ghH+M8nsib6HcIvrCy5TlWuyzzhCgHFwGUYe77ujr2cPB
         2tEbv5LNDi35A==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 97F43A006F;
        Wed,  6 Jul 2022 23:36:09 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:36:09 -0700
Date:   Wed, 06 Jul 2022 16:36:09 -0700
Message-Id: <333ce15207bc7ef15e3df97280bacc7639937da1.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 17/36] usb: gadget: f_tcm: Increase bMaxBurst
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org, Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently the default bMaxBurst is 0. Set default bMaxBurst to 15 (i.e.
16 bursts) to Data IN and OUT endpoints to improve performance. It
should be fine for a controller that supports less than 16 bursts. It
should be able to negotiate properly with the host at packet level for
the end of burst.

If the controller can't handle a burst of 16, and high performance isn't
important, the user can use BOT protocol from mass_storage gadget driver
instead.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/gadget/function/f_tcm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 8e17ac831be0..270ec631481d 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1774,7 +1774,7 @@ static struct usb_endpoint_descriptor uasp_ss_bi_desc = {
 static struct usb_ss_ep_comp_descriptor uasp_bi_ep_comp_desc = {
 	.bLength =		sizeof(uasp_bi_ep_comp_desc),
 	.bDescriptorType =	USB_DT_SS_ENDPOINT_COMP,
-	.bMaxBurst =		0,
+	.bMaxBurst =		15,
 	.bmAttributes =		UASP_SS_EP_COMP_LOG_STREAMS,
 	.wBytesPerInterval =	0,
 };
@@ -1782,7 +1782,7 @@ static struct usb_ss_ep_comp_descriptor uasp_bi_ep_comp_desc = {
 static struct usb_ss_ep_comp_descriptor bot_bi_ep_comp_desc = {
 	.bLength =		sizeof(bot_bi_ep_comp_desc),
 	.bDescriptorType =	USB_DT_SS_ENDPOINT_COMP,
-	.bMaxBurst =		0,
+	.bMaxBurst =		15,
 };
 
 static struct usb_endpoint_descriptor uasp_bo_desc = {
@@ -1817,12 +1817,14 @@ static struct usb_endpoint_descriptor uasp_ss_bo_desc = {
 static struct usb_ss_ep_comp_descriptor uasp_bo_ep_comp_desc = {
 	.bLength =		sizeof(uasp_bo_ep_comp_desc),
 	.bDescriptorType =	USB_DT_SS_ENDPOINT_COMP,
+	.bMaxBurst =		15,
 	.bmAttributes =		UASP_SS_EP_COMP_LOG_STREAMS,
 };
 
 static struct usb_ss_ep_comp_descriptor bot_bo_ep_comp_desc = {
 	.bLength =		sizeof(bot_bo_ep_comp_desc),
 	.bDescriptorType =	USB_DT_SS_ENDPOINT_COMP,
+	.bMaxBurst =		15,
 };
 
 static struct usb_endpoint_descriptor uasp_status_desc = {
-- 
2.28.0

