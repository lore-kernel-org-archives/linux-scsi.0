Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12952C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Oct 2022 23:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiJGXHP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Oct 2022 19:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJGXHN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2022 19:07:13 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2E5F88F9
        for <linux-scsi@vger.kernel.org>; Fri,  7 Oct 2022 16:07:12 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-34d188806a8so57882237b3.19
        for <linux-scsi@vger.kernel.org>; Fri, 07 Oct 2022 16:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YJA+QKDUILUYuI63EpErW7+KuSNjI9fLtfT2e7vYlNo=;
        b=OoioH/J1Cy3VD9tPZHJhUM/NlEfntG1JFbhwBgwGfc7lUIT2uxzlSIF5KsHBXOI5Uc
         f4ZuW5h/sEdMYNzXorCcnb/DvgtQCxKTMCUyEveWhXV2BroibS4+AJRTmzj6287Mo4IT
         KElTElKR/wKcr2gLdKCjxXq0DlZ1SdHbeQJOo/BJsXlSxVPM5GcZPKAH8fZWpZ9g7Itu
         CIvq0Yl1HTr9nv1CWsKhNyqYCVgo6EtZU/TTLAQ34MhyurLMklsQYTsaYGmFNgaSzYH4
         +LzVzZoAkFPDqeimC6gfkSA9Fli3XurXx6bId9hsgj8PL6LMn5EMcsG+3lxLAkLgyv5L
         p3uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YJA+QKDUILUYuI63EpErW7+KuSNjI9fLtfT2e7vYlNo=;
        b=f0RVam1h7lxyy9TLTxexRURXSJrb7llMgAwracbIG6WZ9heNnnaPzqhCaclAYiF9si
         ZxVz+V7ELCXlknFD4B7ISOqxp0f6dPPS0gcc4AiRI6tlEIdZJ/yMqUNH2yoPoMKs+adf
         2XBhRRy01bPrmGUoCLdY6Bn+GoXXiRfj7FrGPzPLhsJUlZ2xQQoZ7r3FEqY00lBdPYaa
         hlnXQyBDnjqkU4yDOw/tYzqAwG6nxK9ESNyTuQ19C5ToJByUNCG1VZYTZ2kC4Eky/20i
         u/bxAf7Z72BbT1R1jf9n2sL8kGOC+k0hKgmQEIS4qsRUEafzoLrMDmmTFiThe/6JauuK
         ZzKA==
X-Gm-Message-State: ACrzQf3s8voYes2DO3RUrga6tabR+b1XBot98vovfDWG8IjL3TxpbDMh
        9bVg3TvGbBuCPIReAC10t00LdEpCbr1GmA==
X-Google-Smtp-Source: AMsMyM7o5KGwh4y7/UHW5IpSzRTor8WUOnX4DwnVHofxJb3H+yYywIFhRTfVNmpQxGV88+n1mpz5uNPQgP0gAw==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:4341:2093:c9c3:a120])
 (user=ipylypiv job=sendgmr) by 2002:a81:8103:0:b0:345:62dd:a9a7 with SMTP id
 r3-20020a818103000000b0034562dda9a7mr6549007ywf.330.1665184031390; Fri, 07
 Oct 2022 16:07:11 -0700 (PDT)
Date:   Fri,  7 Oct 2022 16:06:51 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221007230651.308969-1-ipylypiv@google.com>
Subject: [PATCH] scsi: pm80xx: Display proc_name in sysfs
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jolly Shah <jollys@google.com>,
        Andrew Konecki <awkonecki@google.com>,
        linux-scsi@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The proc_name entry in sysfs for pm80xx is "(null)" because it is
not initialized in scsi_host_template:

Before:
host:~# cat /sys/class/scsi_host/host6/proc_name
(null)

After:
host:~# cat /sys/class/scsi_host/host6/proc_name
pm80xx

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Reviewed-by: Jolly Shah <jollys@google.com> 
---
 drivers/scsi/pm8001/pm8001_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 2ff2fac1e403..7a7d63aa90e2 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -99,6 +99,7 @@ static void pm8001_map_queues(struct Scsi_Host *shost)
 static struct scsi_host_template pm8001_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
+	.proc_name		= DRV_NAME,
 	.queuecommand		= sas_queuecommand,
 	.dma_need_drain		= ata_scsi_dma_need_drain,
 	.target_alloc		= sas_target_alloc,
-- 
2.38.0.rc1.362.ged0d419d3c-goog

