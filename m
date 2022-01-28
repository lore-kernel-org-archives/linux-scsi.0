Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B599C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351602AbiA1WWE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:22:04 -0500
Received: from mail-pl1-f179.google.com ([209.85.214.179]:45014 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351583AbiA1WVw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:21:52 -0500
Received: by mail-pl1-f179.google.com with SMTP id c9so7421657plg.11
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:21:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wWkOgMKl2EezXLa1AD0CgaTntPIFWUIbxUFm9NiH4h0=;
        b=zVQs8K6dPRDouSRr3TTqhwTXpgalWoFDxCGXttOetnkbCi3zPK7eUYp4Ia2Be/0euW
         jmS/e/5arut/BykxElLdwEY9QCbBGzFFJnprlZW0+nx4vJlUFISBiVKWFzKKErekN5fl
         k1fhVbIGJpkT93JKzJvtnIuwKpmaqGbqerhSCfSkK/IjDfcONARbh07F4E8YwFBImy58
         41MlIe5zVfzfFyH5hTXb+si6K5bHn45MDAqD9uKx2c6YIOMUYFWAXfxguK2MnE8Xhk9L
         nxLtFxct2e22UeMaWWyAptvcJlmVQSpOdx4O82bOIeyg+6f8DlQ+qpmYfCnJmj6fZpbd
         WQAA==
X-Gm-Message-State: AOAM531To6km0b8JF9OGGiY/qjXysz3NtL5lfHL6ekR3yinIcKR44YTu
        qCQqoBvztbVKq9z+wzEKof0=
X-Google-Smtp-Source: ABdhPJxSYUBlrGWsyXiQ9kJcrI0Q39oqqJZpZ42M3z1rbE3RyHA9xvYpPHHUZALu20q9NkBRVJu1ZQ==
X-Received: by 2002:a17:902:ce8d:: with SMTP id f13mr11192382plg.53.1643408496405;
        Fri, 28 Jan 2022 14:21:36 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:21:35 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Yufen Yu <yuyufen@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 30/44] mvsas: Fix a set-but-not-used warning
Date:   Fri, 28 Jan 2022 14:18:55 -0800
Message-Id: <20220128221909.8141-31-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
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
