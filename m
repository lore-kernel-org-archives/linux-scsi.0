Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB6EC433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 06:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0D50619E5
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 06:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhCXGMH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 02:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbhCXGLm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 02:11:42 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B81C061763;
        Tue, 23 Mar 2021 23:11:41 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id i9so16984065qka.2;
        Tue, 23 Mar 2021 23:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KcC838RF/TN3pV7IC2FHIE1xfHNqpubjGGbGI/klA/U=;
        b=k04RD2JMw0j2ErelTTY3RFlh05vhDtmtc1ZhVESD5nrGclc7S1/TTkFI8VgqwNHaeS
         2wF8HLYmxGfcI6ro+KWWrU9aR1oSUqaxcn7zh4WQPzHPJ1Ip9X8Xrc8eXuDd/AMr9pjL
         ZUgJ9T7J2cZt4VnDt7696Fgo95fdRXv5gOwFGpmjZ6KBc0X/T3vyc02/SsWi+PVMiJwM
         SCZT4yiMk02Q5nZG0bozWWtcLXedAiHAfqrB7gJDatcXEzRF3L817d0/LCkQO6k/TRT3
         qffkIR/2wMZmjM9bPMQaI3QOBaU0KOQtCZKdEhv8UGoHii2zFGWtRvzNkpmeP0xWAmjw
         qXgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KcC838RF/TN3pV7IC2FHIE1xfHNqpubjGGbGI/klA/U=;
        b=qyQ6fGOxXGLr3hcgHdCG38WevOx8GDiEkhcOzxz1za32Bim2YCE05RcA2du+368cjF
         6Ke1GRLID6iYpBKqyycqf/jltnUjRaW1QaU1snlzDx5/rypD4VoVwDkdFRJ9lri9IUiJ
         z5/ZmexMpeFWpyjjoMh+Jh+Mk+NbAsV6q0YusNExyw+lykWCk8knoV0PUSCImwUlNltw
         WVO4wSFH4PknvRqzihuOPUH+806UabqL/bN2bNHAlXqbI8PIOTXPPwtKYaGgS2TCrAYg
         nHv55xISKfB7UBaDg1WmGojqCwpDquJ6hFbQbguWbY+I5QdLbrkJRFpbE17KvEpA/8ES
         /0RQ==
X-Gm-Message-State: AOAM532l4LC0fODlFu4BTSvORaxW96vXV6GlIH2pQhEqf+DKdP1Ziwdx
        ypx2B/fbS1kbiCl/i6NSBDA=
X-Google-Smtp-Source: ABdhPJzc0UVZm4VniaSQlCMnj1ICJwguc4z5GqTbFHDq3jjJ63I1qROVLt3PAlJ+by7aMk6cp6BLEw==
X-Received: by 2002:a05:620a:6a9:: with SMTP id i9mr1556104qkh.344.1616566301102;
        Tue, 23 Mar 2021 23:11:41 -0700 (PDT)
Received: from Slackware.localdomain ([156.146.37.194])
        by smtp.gmail.com with ESMTPSA id v35sm833759qtd.56.2021.03.23.23.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 23:11:40 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] scsi: esp_scsi: Trivial typo fixes
Date:   Wed, 24 Mar 2021 11:43:18 +0530
Message-Id: <20210324061318.5744-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


s/conditon/condition/
s/pecularity/peculiarity/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/scsi/esp_scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 007ccef5d1e2..342535ac0570 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -647,7 +647,7 @@ static void esp_unmap_sense(struct esp *esp, struct esp_cmd_entry *ent)
 	ent->sense_ptr = NULL;
 }

-/* When a contingent allegiance conditon is created, we force feed a
+/* When a contingent allegiance condition is created, we force feed a
  * REQUEST_SENSE command to the device to fetch the sense data.  I
  * tried many other schemes, relying on the scsi error handling layer
  * to send out the REQUEST_SENSE automatically, but this was difficult
@@ -1341,7 +1341,7 @@ static int esp_data_bytes_sent(struct esp *esp, struct esp_cmd_entry *ent,
 	bytes_sent -= esp->send_cmd_residual;

 	/*
-	 * The am53c974 has a DMA 'pecularity'. The doc states:
+	 * The am53c974 has a DMA 'peculiarity'. The doc states:
 	 * In some odd byte conditions, one residual byte will
 	 * be left in the SCSI FIFO, and the FIFO Flags will
 	 * never count to '0 '. When this happens, the residual
--
2.30.1

