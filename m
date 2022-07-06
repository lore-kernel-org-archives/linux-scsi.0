Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFCFCCA47C
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbiGFXhK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234622AbiGFXhA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:37:00 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449F92CCBD;
        Wed,  6 Jul 2022 16:37:00 -0700 (PDT)
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 01458C06E7;
        Wed,  6 Jul 2022 23:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150620; bh=JnxikKbjvXzJXotPBzekngWry19ktZFxoUadaalhjvA=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=YrdmeYZ2qdtKsSuWdnUD2J5x2ZgJveuo+UkF/tpPxtV/ulTW1eZt2cMc839EKiZxi
         v3vE23StHpda5nIJ7eQxCCqWwWrIc666K0HHnr8CReXnFfJxcufFAmrQdZjrQfxlSx
         VGhSHaVU1xtwzg0MvigiqGCKRSaIvL3EylwFt5BI8h9p/CDxY1BlOn75mbiAV5xX2f
         ImOYJewrIlqTRI2nyM79lWjPoFNNdvuAO6WuUoo+6SPQ8o4LVU8UBKMcuFKFgQR44M
         yZQv3FMnXOYRN2ck8tBfsIoCwcMGK8SSHQrRPxxoG9rQEtlECbdWSdz7tPNpQSpIQy
         BWY5Ytrs375mQ==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id BA318A0096;
        Wed,  6 Jul 2022 23:36:58 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:36:58 -0700
Date:   Wed, 06 Jul 2022 16:36:58 -0700
Message-Id: <c4bbf10978a91b2bd1d0b52affb7204725445c76.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 25/36] usb: gadget: f_tcm: Minor cleanup redundant code
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

The status request preparation is done in uasp_prepare_status(). Remove
duplicate code. No functional change here.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/gadget/function/f_tcm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index ec83f2f9a858..53b178ad4f90 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -624,8 +624,6 @@ static int uasp_send_status_response(struct usbg_cmd *cmd)
 	struct sense_iu *iu = &cmd->sense_iu;
 
 	iu->tag = cpu_to_be16(cmd->tag);
-	stream->req_status->complete = uasp_status_data_cmpl;
-	stream->req_status->context = cmd;
 	cmd->fu = fu;
 	uasp_prepare_status(cmd);
 	return usb_ep_queue(fu->ep_status, stream->req_status, GFP_ATOMIC);
-- 
2.28.0

