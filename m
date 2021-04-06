Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E7DAC433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 18:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FF91613D0
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 18:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244423AbhDFSGH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 14:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbhDFSGH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 14:06:07 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD67C06174A
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 11:05:58 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id b20so5623532qvf.2
        for <linux-scsi@vger.kernel.org>; Tue, 06 Apr 2021 11:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eic4V2E5QYXXouIYsjBjUC0eiCaHlV/G0hefFPFzL9c=;
        b=aCF6DzUmWjrJddmeiJ+Er7O7fvXgMUd7s+enaAXN04ws94d1y3eCiyRZbnz/yBb4dc
         1azQMvl9oDHz5/ckMmrvfNYa2h66HwDI9E7h9XXYLC+nhCXEOAy4y5g4eTpUTGT3PrY8
         69i6m/iToBJuujLaHS3KUgX4YQ8ReqVpvERgowxXoK74/TiyGPMkXPhR+wSUlFe56Qs0
         sGyDcz5gaI3WddHqPmVCjTwgoaaRmRyKnxCA9PEM3gw7uDR+nhrj9YUlEc0beJS5nTqa
         z+IQUeCIeNw4D8jJxfB8yox9jzyCW3ypt3LRhm2SbkSh/N4l6V0OhMmRtzfXanGdIcQD
         M7ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eic4V2E5QYXXouIYsjBjUC0eiCaHlV/G0hefFPFzL9c=;
        b=Z7rocvtLaeKI201gfskRcP4qaPb9Dh8OgbjOM8T2qGAPO4nzUqdTPk2Qo6zQHIaBTb
         AzDo7pl4kuSa7xzaXKw7x+nZlPGZaGAbm+bXiLSqj6FSbzmB5x4SsKAWC5sd0cCEjeEs
         v/TfTFmxwvf6rX4u+lSbDBr8xoQrjni0p3LnmoCFC3MHpPAjYfOVVmXM78T2PYVCt9Da
         W8B1zcUPA9tX4wcil/n+fMOQkTYTb3/LTNE/TatpE6l0wYLHc6xCnJhVAXqcmTm0jRNB
         CarNSM+4qDzYZGdtbYLZkbrgoI6VH3/eSex2z9c2YaWwNgFpbNx8KrIS2UphlelD5gZ3
         kcoA==
X-Gm-Message-State: AOAM530C0TCX3EDz3JxdDCjeELXZYmkCRV+EtgOu5yXitjR8NWUFePe9
        JNaryo8U9VXvF7x3xpfao5WNwPILdqY7aw==
X-Google-Smtp-Source: ABdhPJwHhObYyADNDH/g1MXsdlfZLluTAazZG6fTNu/+c18mp0dUjDJUD7nylORTaxJ7WwkyMpkZyIO6t30LkA==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:11:ff2:f4b8:7c38:13d7])
 (user=ipylypiv job=sendgmr) by 2002:a05:6214:9c9:: with SMTP id
 dp9mr4594501qvb.52.1617732357257; Tue, 06 Apr 2021 11:05:57 -0700 (PDT)
Date:   Tue,  6 Apr 2021 11:05:34 -0700
In-Reply-To: <20210406180534.1924345-1-ipylypiv@google.com>
Message-Id: <20210406180534.1924345-3-ipylypiv@google.com>
Mime-Version: 1.0
References: <20210406180534.1924345-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
Subject: [PATCH v2 2/2] scsi: pm80xx: Remove busy wait from mpi_uninit_check()
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Jolly Shah <jollys@google.com>, Yu Zheng <yuuzheng@google.com>,
        linux-scsi@vger.kernel.org, Viswas G <Viswas.G@microchip.com>,
        Deepak Ukey <deepak.ukey@microchip.com>,
        Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

mpi_uninit_check() is not being called in an ATOMIC context.
The only caller of mpi_uninit_check() is pm80xx_chip_soft_rst().

Callers of pm80xx_chip_soft_rst():
 - pm8001_ioctl_soft_reset()
 - pm8001_pci_probe()
 - pm8001_pci_remove()
 - pm8001_pci_suspend()
 - pm8001_pci_resume()

There was a similar fix for mpi_init_check() in commit d71023af4bec0
("scsi: pm80xx: Do not busy wait in MPI init check").

Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index c6b0834e3806..9fade2ed9396 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1502,12 +1502,12 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
 
 	/* wait until Inbound DoorBell Clear Register toggled */
 	if (IS_SPCV_12G(pm8001_ha->pdev)) {
-		max_wait_count = 30 * 1000 * 1000; /* 30 sec */
+		max_wait_count = SPCV_DOORBELL_CLEAR_TIMEOUT;
 	} else {
-		max_wait_count = 15 * 1000 * 1000; /* 15 sec */
+		max_wait_count = SPC_DOORBELL_CLEAR_TIMEOUT;
 	}
 	do {
-		udelay(1);
+		msleep(FW_READY_INTERVAL);
 		value = pm8001_cr32(pm8001_ha, 0, MSGU_IBDB_SET);
 		value &= SPCv_MSGU_CFG_TABLE_RESET;
 	} while ((value != 0) && (--max_wait_count));
@@ -1519,9 +1519,9 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
 
 	/* check the MPI-State for termination in progress */
 	/* wait until Inbound DoorBell Clear Register toggled */
-	max_wait_count = 2 * 1000 * 1000;	/* 2 sec for spcv/ve */
+	max_wait_count = 100; /* 2 sec for spcv/ve */
 	do {
-		udelay(1);
+		msleep(FW_READY_INTERVAL);
 		gst_len_mpistate =
 			pm8001_mr32(pm8001_ha->general_stat_tbl_addr,
 			GST_GSTLEN_MPIS_OFFSET);
-- 
2.31.1.295.g9ea45b61b8-goog

