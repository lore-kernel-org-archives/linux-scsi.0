Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303A6C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbiGFXhH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234650AbiGFXg4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:36:56 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F642CDE8;
        Wed,  6 Jul 2022 16:36:54 -0700 (PDT)
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id DA29BC06E7;
        Wed,  6 Jul 2022 23:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150613; bh=H1Y0fI12pHBObx79yeAmuO8D3fEdIGn4JCaPf1w581c=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=PGyfh1X1xudkrfbqvnGhZY7LHelRIZoHhmA1thcm/EIQAaD+/ipAQtptShmUk3mJL
         FxM+9k7aVeMXlUtnxxG3Q0vOFv2fKWYB0++mCzSIsZYToCgzLdgVrFAod6CKZ1iaxU
         OLQOQbsZmntkh+G3xux/0bNvbUweTOX5dtNLPIlU4ewKrAXLIPz/a0lgEkuBQw2Io0
         0P26dX27N09/FJVdtzrQGZelJoUGs/ZGJSY7v+aV7HtQ73LEVUcbwP/vAu1HT1hR2a
         aKNzLSXQQ1SuSHg9ufCJSU6wRk1VqRXzrFxeeULtWEeF2MvyvXk/yimgnDekQeOJiA
         X5UfXM4pFjd/w==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 9D37CA0096;
        Wed,  6 Jul 2022 23:36:52 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:36:52 -0700
Date:   Wed, 06 Jul 2022 16:36:52 -0700
Message-Id: <8dc7362e3493da40caa3a6b6029701fcdfa765f6.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 24/36] usb: gadget: f_tcm: Execute command on write completion
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

Don't just wait for the data write completion and execute the target
command. We need to verify if the request completed successfully and not
just sending invalid data. The verification is done in the write request
completion routine, so we can just run target_execute_cmd() there. The
wait for the data write is not needed.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/gadget/function/f_tcm.c | 8 +-------
 drivers/usb/gadget/function/tcm.h   | 1 -
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 6fea80afe2d7..ec83f2f9a858 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -248,7 +248,6 @@ static int bot_send_write_request(struct usbg_cmd *cmd)
 	struct usb_gadget *gadget = fuas_to_gadget(fu);
 	int ret;
 
-	init_completion(&cmd->write_complete);
 	cmd->fu = fu;
 
 	if (!cmd->data_len) {
@@ -279,8 +278,6 @@ static int bot_send_write_request(struct usbg_cmd *cmd)
 	if (ret)
 		pr_err("%s(%d)\n", __func__, __LINE__);
 
-	wait_for_completion(&cmd->write_complete);
-	target_execute_cmd(se_cmd);
 cleanup:
 	return ret;
 }
@@ -685,7 +682,6 @@ static int uasp_send_write_request(struct usbg_cmd *cmd)
 	struct sense_iu *iu = &cmd->sense_iu;
 	int ret;
 
-	init_completion(&cmd->write_complete);
 	cmd->fu = fu;
 
 	iu->tag = cpu_to_be16(cmd->tag);
@@ -717,8 +713,6 @@ static int uasp_send_write_request(struct usbg_cmd *cmd)
 			pr_err("%s(%d)\n", __func__, __LINE__);
 	}
 
-	wait_for_completion(&cmd->write_complete);
-	target_execute_cmd(se_cmd);
 cleanup:
 	return ret;
 }
@@ -955,7 +949,7 @@ static void usbg_data_write_cmpl(struct usb_ep *ep, struct usb_request *req)
 				se_cmd->data_length);
 	}
 
-	complete(&cmd->write_complete);
+	target_execute_cmd(se_cmd);
 	return;
 
 cleanup:
diff --git a/drivers/usb/gadget/function/tcm.h b/drivers/usb/gadget/function/tcm.h
index c7e6d36afd3a..5157af1b166b 100644
--- a/drivers/usb/gadget/function/tcm.h
+++ b/drivers/usb/gadget/function/tcm.h
@@ -74,7 +74,6 @@ struct usbg_cmd {
 	struct se_cmd se_cmd;
 	void *data_buf; /* used if no sg support available */
 	struct f_uas *fu;
-	struct completion write_complete;
 	struct kref ref;
 
 	struct usb_request *req;
-- 
2.28.0

