Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC970C4361B
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 23:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FDFB23BE5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 23:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389167AbgLJXRo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 18:17:44 -0500
Received: from mx.exactcode.de ([144.76.154.42]:34154 "EHLO mx.exactcode.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732785AbgLJXRa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Dec 2020 18:17:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=exactco.de; s=x;
        h=Content-Transfer-Encoding:Content-Type:Mime-Version:From:Subject:Cc:To:Message-Id:Date; bh=hPuCGvN6E60eqPKYyS9zHg+PKYCwq64O9R8Rs8z+3s0=;
        b=incP0PwxlehK0Nzhl98Lnv6PhZ91iRS9RqQE3MX6FedhHK9TOqL/mL/Wzc/lcfEH2qVvZTVuDhJrnLVXGFBFqBsiQVDV3rW0tjQsNWAdHNoNaEMMxI/TeNE3Wxwyj1B5AOXAuuDaA4AlvPImq+TELLxz9Wv0sYkj5qz5A7wEVSA=;
Received: from exactco.de ([90.187.5.221])
        by mx.exactcode.de with esmtp (Exim 4.82)
        (envelope-from <rene@exactcode.com>)
        id 1knTfX-0006ew-2h; Thu, 10 Dec 2020 21:40:11 +0000
Received: from [192.168.2.130] (helo=localhost)
        by exactco.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.86_2)
        (envelope-from <rene@exactcode.com>)
        id 1knTTw-0000cj-9n; Thu, 10 Dec 2020 21:28:12 +0000
Date:   Thu, 10 Dec 2020 22:39:44 +0100 (CET)
Message-Id: <20201210.223944.388095546873159172.rene@exactcode.com>
To:     linux-scsi@vger.kernel.org
Cc:     Michael Reed <mdr@sgi.com>
Subject: [PATCH] fix qla1280 printk regression
From:   Rene Rebe <rene@exactcode.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since Linus Torvalds reinstated KERN_CONT in commit 4bcc595 in 2015,
the qla1280 scsi driver printed a rather ugly and screen real estate
wasting multi-line per device status glibberish during boot.
Fix this by adding KERN_CONT as needed.

Tested on my Sgi Octane: https://youtu.be/Lfqe1SYR2jk

Signed-off-by: Ren=E9 Rebe <rene@exactcode.de>

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 545936cb3980..46de2541af25 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -3906,18 +3906,18 @@ qla1280_get_target_parameters(struct scsi_qla_h=
ost *ha,
 	printk(KERN_INFO "scsi(%li:%d:%d:%d):", ha->host_no, bus, target, lun=
);
 =

 	if (mb[3] !=3D 0) {
-		printk(" Sync: period %d, offset %d",
+		printk(KERN_CONT " Sync: period %d, offset %d",
 		       (mb[3] & 0xff), (mb[3] >> 8));
 		if (mb[2] & BIT_13)
-			printk(", Wide");
+			printk(KERN_CONT ", Wide");
 		if ((mb[2] & BIT_5) && ((mb[6] >> 8) & 0xff) >=3D 2)
-			printk(", DT");
+			printk(KERN_CONT ", DT");
 	} else
-		printk(" Async");
+		printk(KERN_CONT " Async");
 =

 	if (device->simple_tags)
-		printk(", Tagged queuing: depth %d", device->queue_depth);
-	printk("\n");
+		printk(KERN_CONT ", Tagged queuing: depth %d", device->queue_depth);=

+	printk(KERN_CONT "\n");
 }
 =

 =

 =

-- =

  Ren=E9 Rebe, ExactCODE GmbH, Lietzenburger Str. 42, DE-10789 Berlin
  https://exactcode.com | https://t2sde.org | https://rene.rebe.de
