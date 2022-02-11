Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD268C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354155AbiBKWeb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:34:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354149AbiBKWeW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:34:22 -0500
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A752DD63
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:19 -0800 (PST)
Received: by mail-pf1-f178.google.com with SMTP id x15so16246219pfr.5
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ol6ZWWUNPy/gYGRQ0hDi/zoduTNBX5Oh6PGzctrMhbg=;
        b=wLVQUbslWh+3/Zhmh0VtQ4uFrEtyBUPQY5Fnj5b8eR6jYLApiCAetLPBuEmkv2DITe
         XGDx62KZiW8kte6KHdCEw5VAMR9mc6nCMEsEvBrmJeRa5S6L+FYuBMkkt52E9UWVVJbd
         89C4PqPLT66JO4v9MQLC4+WeZs6SBtB/WN3ykJdPabJu5Mt0+kLU30vGn6FyS8AWO9he
         l5A7eNCriJM5Q5ww98fX5J0SLT0LhiXMbBbhceXfPz2rTv40cGGgEPe40ePBL/sYe0eM
         wsUgua5Bogn6Is8vbuW2K4DJWJh2ztO1nxoteUjRIJ0tubO8xiFnSHkWvdv5iPj1fPp4
         ZWQg==
X-Gm-Message-State: AOAM532b3RDBGAsV0LzMebWwfNfcbNX78WiSJlI12PCyPAUdi/vmeOhK
        4vsB7PDEfsCEzTBb78qlCck=
X-Google-Smtp-Source: ABdhPJygLB4JFUTPYUPJ0Xj7sEKfoPDWqtZc38ekmKXXajzgxiX93ZvpZu9nDfqTMD1AIOBCHSqvJA==
X-Received: by 2002:a05:6a00:218b:: with SMTP id h11mr3795446pfi.29.1644618859071;
        Fri, 11 Feb 2022 14:34:19 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:34:18 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v3 34/48] scsi: mvsas: Fix a set-but-not-used warning
Date:   Fri, 11 Feb 2022 14:32:33 -0800
Message-Id: <20220211223247.14369-35-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
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
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mvsas/mv_init.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index dcae2d4464f9..733758b3782d 100644
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
@@ -559,10 +558,13 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 		nhost++;
 	} while (nhost < chip->n_host);
-	mpi = (struct mvs_prv_info *)(SHOST_TO_SAS_HA(shost)->lldd_ha);
 #ifdef CONFIG_SCSI_MVSAS_TASKLET
+	{
+	struct mvs_prv_info *mpi = SHOST_TO_SAS_HA(shost)->lldd_ha;
+
 	tasklet_init(&(mpi->mv_tasklet), mvs_tasklet,
 		     (unsigned long)SHOST_TO_SAS_HA(shost));
+	}
 #endif
 
 	mvs_post_sas_ha_init(shost, chip);
