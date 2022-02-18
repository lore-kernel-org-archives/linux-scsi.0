Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 163C1C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238504AbiBRTxe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:53:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238354AbiBRTxY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:53:24 -0500
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC61A2944C3
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:50 -0800 (PST)
Received: by mail-pl1-f174.google.com with SMTP id i10so7989053plr.2
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x5776Xb1ZxOoCWofKgeVtEzZnuJVmA+hEux/0pEWZW4=;
        b=zQWTDNi+rSGU7MlidYyQNLbkH3rFSJcLChszbNWnu9hiVi/Z54jm6c8MOz/gexM3Xc
         HVHl62QgEMa+gPGsKzkil2OE1Ff+mkRwsUPCCUy2/i9u6vh+FrNIoy46QWybajPs9BjQ
         SOaHXv7qCZm+NFVCS23j3iqUFbbbCyxLfpK3hOB6FN8Ub4l33Q7Dnan83mOMYRnzfRZx
         jvXCc3eBGMuRnPfusOnsEdURbBu59dC7Wgqxj8gppf6H1G3i1qMXaOUha4zJAGw7JQTQ
         BF1N7eQ6K7C6lzVzr2pGnCMFxSoz3lvdtxlQKWLv4QYt4Ockihz0TLvEuT3lEuEveyRq
         OSrw==
X-Gm-Message-State: AOAM531aBdqPnZK7DPvjyuZGA2hoGVWczkLvNPNRJsTj3q0Z768yLDLN
        ttsESN4PScZ+6AsxNeqcWCs=
X-Google-Smtp-Source: ABdhPJzdCMuGlzj2tjkyiU8MNThco/qqLiU9TbyzdGK6/3xr56JlsdMHhnPmwMyCX8utwFaah/9B8g==
X-Received: by 2002:a17:902:8491:b0:14e:dad4:5ce5 with SMTP id c17-20020a170902849100b0014edad45ce5mr8801895plo.76.1645213970079;
        Fri, 18 Feb 2022 11:52:50 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:52:49 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Yang Guang <yang.guang5@zte.com.cn>,
        Yufen Yu <yuyufen@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v5 35/49] scsi: mvsas: Fix a set-but-not-used warning
Date:   Fri, 18 Feb 2022 11:51:03 -0800
Message-Id: <20220218195117.25689-36-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
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
