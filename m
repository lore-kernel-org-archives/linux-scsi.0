Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93CCFC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 06:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234453AbiBOGct (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Feb 2022 01:32:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbiBOGcr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2022 01:32:47 -0500
Received: from smtp.smtpout.orange.fr (smtp04.smtpout.orange.fr [80.12.242.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13558AF1D6
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 22:32:37 -0800 (PST)
Received: from pop-os.home ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id JrO7noYGWi9Q8JrO7nCM26; Tue, 15 Feb 2022 07:32:36 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Tue, 15 Feb 2022 07:32:36 +0100
X-ME-IP: 90.126.236.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: message: fusion: Use GFP_KERNEL instead of GFP_ATOMIC in non-atomic context
Date:   Tue, 15 Feb 2022 07:32:34 +0100
Message-Id: <eccb2179ce800529851ed4fabc9d3f95fbbf7d7f.1644906731.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Just a few lines below this kzalloc() we have a mutex_lock() which can
sleep.

More over, the only way to call this function is when a delayed work is
schedule. And delayed work can sleep.
  INIT_DELAYED_WORK(&fw_event->work, mptsas_firmware_event_work);
    --> mptsas_firmware_event_work()
      --> mptsas_send_link_status_event()
        --> mptsas_expander_add()

So there is really no good reason to use GFP_ATOMIC here. Change it to
GFP_KERNEL to give more opportunities to the kernel.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/message/fusion/mptsas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 4acd8f9a48e1..34901bcd1ce8 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -3680,7 +3680,7 @@ mptsas_expander_add(MPT_ADAPTER *ioc, u16 handle)
 	    MPI_SAS_EXPAND_PGAD_FORM_SHIFT), handle)))
 		return NULL;
 
-	port_info = kzalloc(sizeof(struct mptsas_portinfo), GFP_ATOMIC);
+	port_info = kzalloc(sizeof(struct mptsas_portinfo), GFP_KERNEL);
 	if (!port_info) {
 		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 		"%s: exit at line=%d\n", ioc->name,
-- 
2.32.0

