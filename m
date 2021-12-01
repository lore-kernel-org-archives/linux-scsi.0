Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A792BC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Dec 2021 04:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241655AbhLAEUM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 23:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhLAEUL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 23:20:11 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599CCC061574
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 20:16:51 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id k11-20020a63d84b000000b003252e72da7eso7880448pgj.23
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 20:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ca/vuAWjh+yWCCXVshsP8CUHFNxjIwEBTNSt5P7GQ5c=;
        b=Ozy+paL3pzIN27wO/eqvfyx1oQJgnxwcIsvF6Kuy6e+T2t8JdL4CGkxM776tHTniJO
         ZVRI1X8ESno/326Ak4vKV2J/9VJfhJjxEtwYotpXXcMO8Chu9qs/h3HhzUnQKXORPqzG
         HwVvNiPECPll33s00cAr+0tplryxe7pVuOjD6JjSdhJbWPX1GHibPn5cVHoSH5UFleJQ
         IMmUNxUyp3b6gUpkVjSMFm1/CseI8pmNnIwJa4HH2DDNu29a06PsLwlFQNW97Letm7Bu
         m0XhKrKhj4EGr++uU/XMRiXRdSQCnK7rPbNH+TML4TwkRJY2M3wUB0C+XmyDdATb5dCT
         MUpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ca/vuAWjh+yWCCXVshsP8CUHFNxjIwEBTNSt5P7GQ5c=;
        b=7dTaJCmB/nEfwRmhkiVPdBsmE0ejmoR2xCmrb2pdwCoSAzmUbU/n1OfSUYpKhesga6
         GCZ6XLWW4h2EKKIcTCIsp63BXZjOzq42e/O7NTM9yxbLZkp44UxitIMSvEBDqbkWLbwp
         bGl7hJBWKFlQ3p1DBVYtJUf6KiMmPswCMPzZtQefhT1UAMzvd5fUGAT8KVSrqHRp+2oX
         JgtPyz1+SX6T1cwNNqY+FrnvIFRXw6oOMaXkDSuMmwX5Cri7XsB5OUu9dOmZxjBpex6U
         HtZENODhnRzyLso5aTyZ7rsVlXju/1Tn0yXJcFClDe4DLzA2tfFVFeX3CCjJ4S91C5gE
         TtvQ==
X-Gm-Message-State: AOAM531+SmytWg8A49ghgrH/rGMTKiFCJklEPoenIHxNVeHLBUftJed1
        3MXm1LCXoCwye3EZmwpUhwsosAbq7WJU2g==
X-Google-Smtp-Source: ABdhPJyUswvy2Tg49TPJDecYuACLM1TIAV5qzJNmwmEEV7LX7FEphPzBDd7GDGNA8ol7x34bOXGhvHo2969v1g==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:11:e457:4150:54f4:88dd])
 (user=ipylypiv job=sendgmr) by 2002:a17:902:b7c6:b0:141:9a3a:f213 with SMTP
 id v6-20020a170902b7c600b001419a3af213mr4336252plz.15.1638332210841; Tue, 30
 Nov 2021 20:16:50 -0800 (PST)
Date:   Tue, 30 Nov 2021 20:16:27 -0800
Message-Id: <20211201041627.1592487-1-ipylypiv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH] scsi: pm80xx: Do not call scsi_remove_host() in pm8001_alloc()
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Vishakha Channapattan <vishakhavc@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        linux-scsi@vger.kernel.org, Viswas G <Viswas.G@microchip.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Calling scsi_remove_host() before scsi_add_host() results in a crash:

 BUG: kernel NULL pointer dereference, address: 0000000000000108
 RIP: 0010:device_del+0x63/0x440
 Call Trace:
  device_unregister+0x17/0x60
  scsi_remove_host+0xee/0x2a0
  pm8001_pci_probe+0x6ef/0x1b90 [pm80xx]
  local_pci_probe+0x3f/0x90

We cannot call scsi_remove_host() in pm8001_alloc() because
scsi_add_host() have not been called yet at that point of time.

Function call tree:

  pm8001_pci_probe()
  |
  `- pm8001_pci_alloc()
  |  |
  |  `- pm8001_alloc()
  |     |
  |     `- scsi_remove_host()
  |
  `- scsi_add_host()

Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of supported queues")
Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index bed8cc125544..fbfeb0b046dd 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -282,12 +282,12 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 	if (rc) {
 		pm8001_dbg(pm8001_ha, FAIL,
 			   "pm8001_setup_irq failed [ret: %d]\n", rc);
-		goto err_out_shost;
+		goto err_out;
 	}
 	/* Request Interrupt */
 	rc = pm8001_request_irq(pm8001_ha);
 	if (rc)
-		goto err_out_shost;
+		goto err_out;
 
 	count = pm8001_ha->max_q_num;
 	/* Queues are chosen based on the number of cores/msix availability */
@@ -423,8 +423,6 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 	pm8001_tag_init(pm8001_ha);
 	return 0;
 
-err_out_shost:
-	scsi_remove_host(pm8001_ha->shost);
 err_out_nodev:
 	for (i = 0; i < pm8001_ha->max_memcnt; i++) {
 		if (pm8001_ha->memoryMap.region[i].virt_ptr != NULL) {
-- 
2.34.0.rc2.393.gf8c9666880-goog

