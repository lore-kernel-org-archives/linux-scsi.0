Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855F7C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbiGFXhe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234523AbiGFXhc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:37:32 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D542CCAF;
        Wed,  6 Jul 2022 16:37:32 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 631C54077F;
        Wed,  6 Jul 2022 23:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150652; bh=4E78Qdi0bMwX8IqwoL/VcWhUlyD+K8rZ+0+hKD0xQAo=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=NPEtaX7Sf9LHnhs+K38YVTjv/IiBkqH1YaS5oRj28v487D2rkV0zFzEL2GZeSpXDV
         TGhtpoXk9/J4SZ6THACjuPQeTf2dr/iBv22GY3/mOMtp0e2KsuDuSVHykhtTgGX6Su
         P06ZYfe1tmSKO6E11Ev6XwDM00p4PWzXCNYHPJC5Zfl0H0+oI35Um4p5oas3i8V9M7
         qpmanIY0jLSMkJOdlc6MRwpirxUh0fomociUSYjsn55PztLYmBLo6vuHFvdThE9PMc
         qfnZEr/WqKW7fQgToy7XNTM8uce0jlBgGVTrkQxPuh7/ss86CbqdWfVZG7ym2Qy+pk
         lMSEN9HXbbKxg==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 3E5B3A006F;
        Wed,  6 Jul 2022 23:37:31 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:37:31 -0700
Date:   Wed, 06 Jul 2022 16:37:31 -0700
Message-Id: <90d31ee68d69cd875c4d4f6e29783b45ebfb1e89.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 30/36] usb: gadget: f_tcm: Handle abort command
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

Implemented aborted_task to cancel outstanding request.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/gadget/function/f_tcm.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index c7f64d0eba0f..d15008b14beb 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1276,6 +1276,22 @@ static void usbg_queue_tm_rsp(struct se_cmd *se_cmd)
 
 static void usbg_aborted_task(struct se_cmd *se_cmd)
 {
+	struct usbg_cmd *cmd = container_of(se_cmd, struct usbg_cmd, se_cmd);
+	struct f_uas *fu = cmd->fu;
+	struct uas_stream *stream = cmd->stream;
+	int ret = 0;
+
+	if (stream->req_out->status == -EINPROGRESS)
+		ret = usb_ep_dequeue(fu->ep_out, stream->req_out);
+	else if (stream->req_in->status == -EINPROGRESS)
+		ret = usb_ep_dequeue(fu->ep_in, stream->req_in);
+	else if (stream->req_status->status == -EINPROGRESS)
+		ret = usb_ep_dequeue(fu->ep_status, stream->req_status);
+
+	if (ret)
+		pr_err("Unable to dequeue se_cmd out %p\n", se_cmd);
+
+	cmd->state = UASP_QUEUE_COMMAND;
 }
 
 static const char *usbg_check_wwn(const char *name)
-- 
2.28.0

