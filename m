Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D6CEC5479D
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Jan 2023 23:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237724AbjAIXWw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234906AbjAIXWp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 18:22:45 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1818738BC
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 15:22:45 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id h7-20020a17090aa88700b00225f3e4c992so14531528pjq.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Jan 2023 15:22:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/uaJGJ1BZuv6e4vCgomB4MPdWevpdOOTroMzTdk8lkk=;
        b=Fty/lBOflVU1MVVUfgf8cJ1iWQhdP2M64L+mh4lSRXlZI6ARi0tOQB3GXFFKuOFJPu
         5+wL4SIZyRdmxW/YwrbvG14WUbIZ6CqHDfZxFF8EaVBvtvunzCSVfnbkq9MMr8KnCG1k
         sCJX7Mv1mVBTNvglZBfwAXq51KMEGrvQ8+BiHscOMY+pLAcegKYxplZGFcwsAQiK72Ym
         yHrEK/+mIs4sDsmema6vOt26vhfMSfDAwH6kfPO07Ql1G0AILZ7bOSnNHWUEYA5rtg2T
         BWYDdXI3zI/VHM9vvJJa9UN5ihuQLc3qRzD/CtJujpwtjbclqOq2RA9NEmwE2p3oJLaK
         +M+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/uaJGJ1BZuv6e4vCgomB4MPdWevpdOOTroMzTdk8lkk=;
        b=xLosa2qKShBGwn73c6j3qI6dD43sCIM/cN7/EdcCQ+lp/i/Y3UTbeUTV6Ph1YD9OL8
         VH4FWrjZMIyH/Em0PG+ZhFbzgt6BLyaf8Hxm3R3JOUyA5v8ewWXD8PfsDlty6N8Ypm6J
         zn1SXMO4QPjK1NdCY0Jojy+Z1pbs2GcdKJ44/vkNpWsLlzWZkD2gXr5zz4uhtvkHUFpA
         n9yrE+pfQxcPnqKUQD7JHOTB+F5M52oIevPHEFQ5xPmaczDgq86bwIBcijEa95mYGcqY
         W990osZnm2cXVLLsCQQdEzniJ2WLc+lorh8i5yETIr/pGAc5EKv16D1o2K7nwo5urrN6
         OJFg==
X-Gm-Message-State: AFqh2kr3YcOAatdLd0rSjsGHXA+pRJ+mflLRs3YdWuVqave081wdJ7km
        o+6cpWAOzO80vF9uPQAMSJ2Rv/1oyiQ=
X-Google-Smtp-Source: AMrXdXttaY9ozzgAFkorgy7SRJGutfIjVs5NZ+iqDProZ/V6+rzzGYB+jesTjwJK8giZ/zQFRhGjuA==
X-Received: by 2002:a17:902:6bcb:b0:192:eb8d:4d62 with SMTP id m11-20020a1709026bcb00b00192eb8d4d62mr18486108plt.13.1673306564504;
        Mon, 09 Jan 2023 15:22:44 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d22-20020a170902aa9600b001871461688esm6628572plr.175.2023.01.09.15.22.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Jan 2023 15:22:44 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 04/12] lpfc: Set max dma segment size to hba supported SGE length
Date:   Mon,  9 Jan 2023 15:33:09 -0800
Message-Id: <20230109233317.54737-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230109233317.54737-1-justintee8345@gmail.com>
References: <20230109233317.54737-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During I/O, the following warning message occasionally appears.

DMA-API: lpfc 0000:04:00.0: mapping sg segment longer than device claims to
support [len=131072] [max=65536]

The hba is capable of supporting 131,072 bytes, so notify DMA layer via the
dma_set_max_seg_size API during hba initialization.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 25ba20e42825..4d58373f6ab6 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13917,6 +13917,13 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	if (sli4_params->sge_supp_len > LPFC_MAX_SGE_SIZE)
 		sli4_params->sge_supp_len = LPFC_MAX_SGE_SIZE;
 
+	rc = dma_set_max_seg_size(&phba->pcidev->dev, sli4_params->sge_supp_len);
+	if (unlikely(rc)) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"6400 Can't set dma maximum segment size\n");
+		return rc;
+	}
+
 	/*
 	 * Check whether the adapter supports an embedded copy of the
 	 * FCP CMD IU within the WQE for FCP_Ixxx commands. In order
-- 
2.38.0

