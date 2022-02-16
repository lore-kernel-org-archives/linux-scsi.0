Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C51E5C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbiBPVFD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:05:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234300AbiBPVEN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:04:13 -0500
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564472225C5
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:59 -0800 (PST)
Received: by mail-pl1-f175.google.com with SMTP id 10so2982503plj.1
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x5776Xb1ZxOoCWofKgeVtEzZnuJVmA+hEux/0pEWZW4=;
        b=upr2NwsNH2oD4zfK3bot4okPlqelqf+ETEnFuQmi+yWgBIRmGrHjx8KL8gBdXhgCtP
         VZHABKlWUxztR+TfAuNvfWEmbAkpWeRE0SdkWpFSx7O/W1Yv5zB8e8FbY9knq9a+Enoc
         Ofc2id7VGyvuYCIdHdKYoSqA2nljNS6aTGmFZyMOme+AGODvbKREjzdcYKdSeJqdyNpT
         2m6Q3njYjICRSdi9YtE3htnWABpJb7mAOyiBxRVITzGGpSmyW+DKJTpoxegJZK7lSJPK
         QDHa7CLEDv++SCH1AiLoX4rXbf/93rUgKc8wgurXp9k6X+T5SUSfP/WD5fl2ukVj7wVs
         gHcQ==
X-Gm-Message-State: AOAM531lsNa1fetCdaLnzu6lURyrzZM4+mrFG9R09/s9zQMIhuDUH6np
        bxK/zgfNRXS8PAl4EgnkGJA=
X-Google-Smtp-Source: ABdhPJx9dts17MJOV8t60RLZnQ59930CywzZYtUrIusIUerhoSSkQ3TsgPz+Zp8rumgIF9kJ78ATDA==
X-Received: by 2002:a17:90b:3a85:b0:1b5:58c8:6d87 with SMTP id om5-20020a17090b3a8500b001b558c86d87mr3890077pjb.192.1645045438685;
        Wed, 16 Feb 2022 13:03:58 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:03:58 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Yufen Yu <yuyufen@huawei.com>,
        Yang Guang <yang.guang5@zte.com.cn>,
        Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v4 36/50] scsi: mvsas: Fix a set-but-not-used warning
Date:   Wed, 16 Feb 2022 13:02:19 -0800
Message-Id: <20220216210233.28774-37-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
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
index 44df7c03aab8..35406abeb852 100644
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
