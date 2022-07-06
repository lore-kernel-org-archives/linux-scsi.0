Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 408DBC43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiGFXgl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234635AbiGFXgh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:36:37 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFDC2CDD2;
        Wed,  6 Jul 2022 16:36:35 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6A31940CAF;
        Wed,  6 Jul 2022 23:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150595; bh=b0z6oYvD/qo8jaCPnFSickuF7051V1qJDrAqeJZJ2cw=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=jFedgQEH1E/yjsAnkPHWe4oz77TXUSmQ+mD5lr5F5xIrXiU6KPEYZHixddkuuy8qR
         s5ygmfDxoSeRqTIhOD6zDCWjg7kLLBQvn+95Z+yQjrIASDGg/ES4N/O+aXOWjHt7pK
         HeHex5kq1WD/lcBwEhEx7YToS7NK4a1QEZY5r2yDJ5wTIB36pqPLN3dGHlY4chwLDE
         5rMS56HFnc2FsfxC+dGV9Kp0dzkVS4fePKAKsnNGLrNxJnZ9DdXapYSKjliOKMJ86L
         U4ThST9E7KUaP8LVDmsrzYiqJuPQUaFS2X1vCwfixl+wgiJkq5ag7wtal/DLBp2J7v
         QFQN1dp7qBAzg==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 41932A0063;
        Wed,  6 Jul 2022 23:36:34 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:36:34 -0700
Date:   Wed, 06 Jul 2022 16:36:34 -0700
Message-Id: <6f7b66be0db84fc5a362293dbff6674f19a5b311.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 21/36] usb: gadget: f_tcm: Handle multiple commands in parallel
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

Resubmit command on completion to fetch more commands and service them
in parallel. Increase the number of work in a queue. Each work will be
for each command allowing them to be processed concurrently. Also, set
them to be unbounded by cpu to improve performance.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/gadget/function/f_tcm.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 6e0b54985932..91d853682468 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -728,21 +728,16 @@ static int usbg_submit_command(struct f_uas *, struct usb_request *);
 static void uasp_cmd_complete(struct usb_ep *ep, struct usb_request *req)
 {
 	struct f_uas *fu = req->context;
-	int ret;
 
-	if (req->status < 0)
+	if (req->status == -ESHUTDOWN)
 		return;
 
-	ret = usbg_submit_command(fu, req);
-	/*
-	 * Once we tune for performance enqueue the command req here again so
-	 * we can receive a second command while we processing this one. Pay
-	 * attention to properly sync STAUS endpoint with DATA IN + OUT so you
-	 * don't break HS.
-	 */
-	if (!ret)
+	if (req->status < 0) {
+		usb_ep_queue(fu->ep_cmd, req, GFP_ATOMIC);
 		return;
-	usb_ep_queue(fu->ep_cmd, req, GFP_ATOMIC);
+	}
+
+	usbg_submit_command(fu, req);
 }
 
 static int uasp_alloc_stream_res(struct f_uas *fu, struct uas_stream *stream)
@@ -1357,7 +1352,8 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
 		goto unref_dep;
 	mutex_init(&tpg->tpg_mutex);
 	atomic_set(&tpg->tpg_port_count, 0);
-	tpg->workqueue = alloc_workqueue("tcm_usb_gadget", 0, 1);
+	tpg->workqueue = alloc_workqueue("tcm_usb_gadget",
+					 WQ_UNBOUND, WQ_UNBOUND_MAX_ACTIVE);
 	if (!tpg->workqueue)
 		goto free_tpg;
 
-- 
2.28.0

