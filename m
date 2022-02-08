Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48AFC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384331AbiBHR04 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384246AbiBHR0w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:26:52 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0624FC061579
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:26:39 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id c5-20020a17090a1d0500b001b904a7046dso1086125pjd.1
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:26:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EfDpcRH/wUvCYGTAdpcRL1qrzNAeJ4TURimHHQ3yw5k=;
        b=nNaXKMhufSNfwO/ysjNGVHPkXNL7zGZslP0IhqWx6Nn6e4SaAlOLr8lrwa39TLx5kJ
         3hEWnbGGPvwChim7HSLNcWkxi2owT9TvOHeMqGuloje2BW2xHPRjT1tKyrGLOEjq9QkU
         EhThhaFjezQlODwFZM1YvCf5MMD/efqXo32lzWY5YQ413WWTpU0F0aewphajxbHQhfCw
         4ACoPPiQ4Xq5gRnmuvmgOkDDSj66/4eQKoR1YhH9Z/p+gB7a0D7zbzF6As+KK4t3m7WF
         mR1H/A61fWWUkzEGnkzIAuTVISdVRtVmkaP3i3hJYFkB0RCKWjtK7k9/1eYpj4J7hqXE
         NaBg==
X-Gm-Message-State: AOAM530eG1TnhyCHCgGwgbWsli6kLnIVA+ENvhs4N+ZSpOjC8yXPtS2c
        awmy3vhtiCIimA6DzAUaWB0reCNypdGu8XlV
X-Google-Smtp-Source: ABdhPJxF9SpBajZPekR7E8S/L89T9JLumG/gShk4/aGxHDyoORNSIQKWTApx/Xs6FrXGJAsjWpJ8rQ==
X-Received: by 2002:a17:90a:bc81:: with SMTP id x1mr2509487pjr.119.1644341198407;
        Tue, 08 Feb 2022 09:26:38 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:26:37 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Yufen Yu <yuyufen@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 30/44] mvsas: Fix a set-but-not-used warning
Date:   Tue,  8 Feb 2022 09:25:00 -0800
Message-Id: <20220208172514.3481-31-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following compiler warning:

drivers/scsi/mvsas/mv_init.c: In function ‘mvs_pci_init’:
drivers/scsi/mvsas/mv_init.c:497:30: warning: variable ‘mpi’ set but not used [-Wunused-but-set-variable]
  497 |         struct mvs_prv_info *mpi;
      |                              ^~~

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mvsas/mv_init.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index dcae2d4464f9..d82b3129119a 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -494,7 +494,6 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	unsigned int rc, nhost = 0;
 	struct mvs_info *mvi;
-	struct mvs_prv_info *mpi;
 	irq_handler_t irq_handler = mvs_interrupt;
 	struct Scsi_Host *shost = NULL;
 	const struct mvs_chip_info *chip;
@@ -559,10 +558,14 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 		nhost++;
 	} while (nhost < chip->n_host);
-	mpi = (struct mvs_prv_info *)(SHOST_TO_SAS_HA(shost)->lldd_ha);
 #ifdef CONFIG_SCSI_MVSAS_TASKLET
+	{
+	struct mvs_prv_info *mpi;
+
+	mpi = (struct mvs_prv_info *)(SHOST_TO_SAS_HA(shost)->lldd_ha);
 	tasklet_init(&(mpi->mv_tasklet), mvs_tasklet,
 		     (unsigned long)SHOST_TO_SAS_HA(shost));
+	}
 #endif
 
 	mvs_post_sas_ha_init(shost, chip);
