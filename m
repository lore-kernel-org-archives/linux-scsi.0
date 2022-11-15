Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20BB9C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 09:46:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238156AbiKOJq3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 04:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238189AbiKOJqJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 04:46:09 -0500
X-Greylist: delayed 475 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Nov 2022 01:46:07 PST
Received: from forward106j.mail.yandex.net (forward106j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC78713F49
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 01:46:07 -0800 (PST)
Received: from forward101q.mail.yandex.net (forward101q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb98])
        by forward106j.mail.yandex.net (Yandex) with ESMTP id 82F6D6BD7BA8
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 12:38:08 +0300 (MSK)
Received: from vla1-ef285479e348.qloud-c.yandex.net (vla1-ef285479e348.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:35a1:0:640:ef28:5479])
        by forward101q.mail.yandex.net (Yandex) with ESMTP id 7E77E13E80002
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 12:38:08 +0300 (MSK)
Received: by vla1-ef285479e348.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 3t0lMaHcTG-c8VmFh5M;
        Tue, 15 Nov 2022 12:38:08 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scst.dev; s=mail; t=1668505088;
        bh=XpiuN1OBF1vJ2Z69qxP9l7NTrZAKL51OqZS58QRfhmk=;
        h=Subject:From:To:Date:Message-ID;
        b=BADR/rqwUMqeqAr9HnMgtgYBNhrXY9ZgAb/20QXbC3D5nptQ3vGxu7nAVicncvB3X
         tsx7a4OZWO/yEHdE4Js56ekr4MRh4eNcLahJWgWPs1NkMfAnx4IzCxPXiUbsSHrmrF
         iFPzNtqEG+AmQEgRFzeH68CqYufDtMcWtmZfDT+0=
Authentication-Results: vla1-ef285479e348.qloud-c.yandex.net; dkim=pass header.i=@scst.dev
Message-ID: <376c89a2-a9ac-bcf9-bf0f-dfe89a02fd4b@scst.dev>
Date:   Tue, 15 Nov 2022 12:38:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     linux-scsi@vger.kernel.org
From:   Gleb Chesnokov <gleb.chesnokov@scst.dev>
Subject: [PATCH 2/2] qla2xxx: Initialize vha->unknown_atio_[list, work] for
 NPIV hosts
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Initialization of vha->unknown_atio_list and vha->unknown_atio_work
only happens for base_vha in qla_probe_one_stage1(). But there is no
initialization for NPIV hosts that are created in qla24xx_vport_create().

This causes a crash when trying to access these NPIV host fields.

Fix this by adding initialization to qla_vport_create().

Signed-off-by: Gleb Chesnokov <gleb.chesnokov@scst.dev>
---
  drivers/scsi/qla2xxx/qla_target.c | 3 +++
  1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c 
b/drivers/scsi/qla2xxx/qla_target.c
index bb754a950802..548f22705ddc 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6741,6 +6741,9 @@ qlt_vport_create(struct scsi_qla_host *vha, struct 
qla_hw_data *ha)
  	mutex_init(&vha->vha_tgt.tgt_mutex);
  	mutex_init(&vha->vha_tgt.tgt_host_action_mutex);

+	INIT_LIST_HEAD(&vha->unknown_atio_list);
+	INIT_DELAYED_WORK(&vha->unknown_atio_work, qlt_unknown_atio_work_fn);
+
  	qlt_clear_mode(vha);

  	/*
-- 
2.38.1
