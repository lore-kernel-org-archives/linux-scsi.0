Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E572EC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 09:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238142AbiKOJqR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 04:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238149AbiKOJqD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 04:46:03 -0500
X-Greylist: delayed 469 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Nov 2022 01:45:59 PST
Received: from forward103o.mail.yandex.net (forward103o.mail.yandex.net [37.140.190.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489B92253D
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 01:45:59 -0800 (PST)
Received: from forward103q.mail.yandex.net (forward103q.mail.yandex.net [IPv6:2a02:6b8:c0e:50:0:640:b21c:d009])
        by forward103o.mail.yandex.net (Yandex) with ESMTP id 8A91A10ABACE
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 12:38:06 +0300 (MSK)
Received: from vla5-1ef2161cc1d7.qloud-c.yandex.net (vla5-1ef2161cc1d7.qloud-c.yandex.net [IPv6:2a02:6b8:c18:3607:0:640:1ef2:161c])
        by forward103q.mail.yandex.net (Yandex) with ESMTP id 8882D56A000F
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 12:38:06 +0300 (MSK)
Received: by vla5-1ef2161cc1d7.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 4GKwqsXDKC-c6ViWqMK;
        Tue, 15 Nov 2022 12:38:06 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scst.dev; s=mail; t=1668505086;
        bh=rpwLPQDmf5elCM4Q+zu7ZuQabFqn6TyrCcl2DhwpaYY=;
        h=Subject:From:To:Date:Message-ID;
        b=DdSfG88iacjm6or/C4EpSDJ1zNF2tKotnSQIQdq2vmHAjGjVY9N7nW+aoEqLi/PT4
         tagbFs39ZFqvIhDBjokzMJSpARR50wdsYHA8A6JOjF2tAsr2bN7ZwdPVAOt6LR2UqU
         9p2g1+/9KQ0PrJPtCODbG3mVJn/ZqyT1HXsk+3iA=
Authentication-Results: vla5-1ef2161cc1d7.qloud-c.yandex.net; dkim=pass header.i=@scst.dev
Message-ID: <822b3823-f344-67d6-30f1-16e31cf68eed@scst.dev>
Date:   Tue, 15 Nov 2022 12:38:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     linux-scsi@vger.kernel.org
From:   Gleb Chesnokov <gleb.chesnokov@scst.dev>
Subject: [PATCH 1/2] qla2xxx: Remove duplicate of vha->iocb_work
 initialization
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 9b3e0f4d4147 ("scsi: qla2xxx: Move work element processing
out of DPC thread") introduced the initialization of vha->iocb_work in
qla2x00_create_host() function.

This initialization is also called from qla2x00_probe_one() function,
just after qla2x00_create_host().

Hence remove this duplicate call since it has already been called before.

Signed-off-by: Gleb Chesnokov <gleb.chesnokov@scst.dev>
---
  drivers/scsi/qla2xxx/qla_os.c | 1 -
  1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2c85f3cce726..9d82921d94b8 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3284,7 +3284,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const 
struct pci_device_id *id)
  	    host->max_cmd_len, host->max_channel, host->max_lun,
  	    host->transportt, sht->vendor_id);

-	INIT_WORK(&base_vha->iocb_work, qla2x00_iocb_work_fn);
  	INIT_WORK(&ha->heartbeat_work, qla_heartbeat_work_fn);

  	/* Set up the irqs */
-- 
2.38.1
