Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0CD3C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbiGFXho (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234729AbiGFXhk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:37:40 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB18F2CDED;
        Wed,  6 Jul 2022 16:37:38 -0700 (PDT)
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 838C140CB0;
        Wed,  6 Jul 2022 23:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150658; bh=JiYHnhrRXvLBGRy/eKUbd/upiMBoGhP32EnyJ2uIdwk=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=dZfQ2S5ATvrRt8ejPx26UfoXcgG+i4gC/KDm8K9zddJTBsSGG5zMdvbad9sYzMFLs
         sqkrDxkQEfYTGQyDKI7Zva1Yb+vfgrW+RcjUSoWaHXB7yVt3jL4idPL1QdoM3widex
         2egRIZOaUotbrDy+9yjOC6YY5jcxnu354koLHfT21IaSMvz8p0WH/LGEkvPTmo4RjQ
         ciH/y73kJMp3+0y+sq8Z5IZCipu3GFveOdGbUZH+96U24vVTrqzhMB1r2vtCN88ERz
         HLNidov4Oxv6+G9xshBlBktWIiNEQ1JJX+Y+BsMvSixU7FkUQSkZdGfUJvLhLCPLUD
         /2aBhxbdzJKBw==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 5EFF5A0096;
        Wed,  6 Jul 2022 23:37:37 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:37:37 -0700
Date:   Wed, 06 Jul 2022 16:37:37 -0700
Message-Id: <d6cdc41ddf645b63a9c5ef662a83e08c9aa668ed.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 31/36] usb: gadget: f_tcm: Cleanup requests on ep disable
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

If the endpoint is disabled, then free the command. Normally we don't
free a command until it's completed its UASP status (failure or not).

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/gadget/function/f_tcm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index d15008b14beb..7162be5fdf2f 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -572,7 +572,7 @@ static void uasp_status_data_cmpl(struct usb_ep *ep, struct usb_request *req)
 	struct f_uas *fu = cmd->fu;
 	int ret;
 
-	if (req->status < 0)
+	if (req->status == -ESHUTDOWN)
 		goto cleanup;
 
 	switch (cmd->state) {
@@ -934,7 +934,12 @@ static void usbg_data_write_cmpl(struct usb_ep *ep, struct usb_request *req)
 	struct usbg_cmd *cmd = req->context;
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 
-	if (req->status < 0) {
+	if (req->status == -ESHUTDOWN) {
+		transport_generic_free_cmd(&cmd->se_cmd, 0);
+		return;
+	}
+
+	if (req->status) {
 		pr_err("%s() state %d transfer failed\n", __func__, cmd->state);
 		goto cleanup;
 	}
-- 
2.28.0

