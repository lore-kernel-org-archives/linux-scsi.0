Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C342C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234702AbiGFXhb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234701AbiGFXh3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:37:29 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21082CDDE;
        Wed,  6 Jul 2022 16:37:26 -0700 (PDT)
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 5DE04C06E7;
        Wed,  6 Jul 2022 23:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150646; bh=oa6xu0ObsRu520otSO2oJVyaSj320UHpAKlVmc3OV9k=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=YQ9FJAlx2Im0RjRPqXBtUfkPLlFE9h/3eJHOaP7IvQpKEXjG5gzBAaAxYVLk4XWa+
         +xzdBuk6DwWK+WUHXYCln1p9h4dsJcTqRtmGvkNBkE6Tsyvh7+Mxcsgjncw5m5k66J
         H92fuoovAsUHDoPolYNn1a+Qa1z2MowKw+HCqTKDr6+Dd9K7nwQST+7TjmwZ3LFFXz
         QioR/FA6bwCaPJuOxx4wKnoEHF5Jf2EutwzzoEmCfdB3hy2xHjrc+fXKkqr2GMNZbb
         cH6UJYtsDK2tKeZKuhJkP+ABi3fNERd1ubs2vwVDKDxhTtEJWM6SCZseorsI2+q4Yn
         xjymDBobOJaiw==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 1FB49A0096;
        Wed,  6 Jul 2022 23:37:25 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:37:25 -0700
Date:   Wed, 06 Jul 2022 16:37:25 -0700
Message-Id: <3b9f369c245b9029ce225cc7e1bdf3815ab78542.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 29/36] usb: gadget: f_tcm: Update state on data write
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

When preparing request for data write state, the next state is
UASP_SEND_STATUS.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/gadget/function/f_tcm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 1e7d29f8aecb..c7f64d0eba0f 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -976,6 +976,8 @@ static int usbg_prepare_w_request(struct usbg_cmd *cmd, struct usb_request *req)
 	req->complete = usbg_data_write_cmpl;
 	req->length = se_cmd->data_length;
 	req->context = cmd;
+
+	cmd->state = UASP_SEND_STATUS;
 	return 0;
 }
 
-- 
2.28.0

