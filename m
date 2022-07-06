Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A0BC43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:38:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbiGFXiC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234740AbiGFXh5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:37:57 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576E42CCB6;
        Wed,  6 Jul 2022 16:37:57 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 108BCC06E8;
        Wed,  6 Jul 2022 23:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150677; bh=qjumXPSqSC2H/3vK7/X+IjhPPbUDz4xo5sZJBKB2S6k=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=jNXcNU5HsF8YCbRsIBFwgEdK8rAUpoIaiIA1eLHC3JLKKEIMcaRJ8GaSMdS88IL9X
         tTAmiilN80Byim5eKqnPHAwU213mkgHZDv0jXJ1yXorqumF6aFp0Mg3v26XYNUM3eJ
         57Nj7JTE1yTvfYcjD7m8FnCtUjGW8fu3J/Fq5y7PXTT0vwutAovD9aQ1Kbdd7Slg1J
         LPCpQFqZkfGZkSqOT5eHQaVb4KfM2N99i2ku6JfmUm6jB+52766z7AfzvzCHKdZ9zR
         5+ihOjarpGRoJt3d4Bivjkqh5oBnCTiKUw5Gls+sxCK5e3sj00sKdbA4EcwSINUhLK
         lq/OiDs0zGxzg==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id C5451A006F;
        Wed,  6 Jul 2022 23:37:55 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:37:55 -0700
Date:   Wed, 06 Jul 2022 16:37:55 -0700
Message-Id: <6a5487365f0804447d4cbb8911d0719d8b21b601.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 34/36] usb: gadget: f_tcm: Free tags earlier
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

Free up sbitmap index immediately once the command is completed rather
than waiting for kref to call freeing tag. This keeps the sbitmap queue
free quicker.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/gadget/function/f_tcm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index c13aa61d82aa..fa09999adda7 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -570,6 +570,7 @@ static void uasp_status_data_cmpl(struct usb_ep *ep, struct usb_request *req)
 	struct usbg_cmd *cmd = req->context;
 	struct uas_stream *stream = cmd->stream;
 	struct f_uas *fu = cmd->fu;
+	struct se_session *se_sess = cmd->se_cmd.se_sess;
 	int ret;
 
 	if (req->status == -ESHUTDOWN)
@@ -603,6 +604,8 @@ static void uasp_status_data_cmpl(struct usb_ep *ep, struct usb_request *req)
 		break;
 
 	case UASP_QUEUE_COMMAND:
+
+		target_free_tag(se_sess, &cmd->se_cmd);
 		transport_generic_free_cmd(&cmd->se_cmd, 0);
 		usb_ep_queue(fu->ep_cmd, cmd->req, GFP_ATOMIC);
 
@@ -614,6 +617,7 @@ static void uasp_status_data_cmpl(struct usb_ep *ep, struct usb_request *req)
 	return;
 
 cleanup:
+	target_free_tag(se_sess, &cmd->se_cmd);
 	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 
@@ -941,6 +945,7 @@ static void usbg_data_write_cmpl(struct usb_ep *ep, struct usb_request *req)
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 
 	if (req->status == -ESHUTDOWN) {
+		target_free_tag(se_cmd->se_sess, se_cmd);
 		transport_generic_free_cmd(&cmd->se_cmd, 0);
 		return;
 	}
@@ -963,6 +968,7 @@ static void usbg_data_write_cmpl(struct usb_ep *ep, struct usb_request *req)
 cleanup:
 	/* Command was aborted */
 	if (cmd->state == UASP_QUEUE_COMMAND) {
+		target_free_tag(se_cmd->se_sess, se_cmd);
 		transport_generic_free_cmd(se_cmd, 0);
 		return;
 	}
-- 
2.28.0

