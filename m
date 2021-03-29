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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B834C433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 18:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AF2A619AB
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 18:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbhC2Shl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 14:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbhC2ShS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 14:37:18 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD27C061574
        for <linux-scsi@vger.kernel.org>; Mon, 29 Mar 2021 11:37:17 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n13so20201403ybp.14
        for <linux-scsi@vger.kernel.org>; Mon, 29 Mar 2021 11:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=aEWjCg6FN/7Yw4nH7clrw1BBSZHZ2qAEkLv+oMpFcvw=;
        b=AYIo9aDi1PSFkzmIlGoDxWGtRcjMhhsdms81abnZUufixMLl9QnbalhZ2cIyRlL18Q
         MA8aFf3iuJ97mVDE1maB5dUAHOyjQhSqNd3R2Z+0GUKl8g2WYG0pV4DB8heSw5UqbQCf
         g6hVpxYsqFYo2WgBn0X83cEPENp8MixO+9HGPl+su2CABRwBceh/xONUBFHwU+9SHedA
         9Yp/varvOn5I+2QbUKsLV+TIsUJmCbx/wnxYmBLa7tT03qr2hAkM4vf9Z5yIH8gddmz7
         NNRsE4G0nxEveIzOFhcZ3fyg1iT4Z/89cbejsN5Gj93D0uunUtsFV76hvBQVj8PFjFIZ
         Tbow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aEWjCg6FN/7Yw4nH7clrw1BBSZHZ2qAEkLv+oMpFcvw=;
        b=dBW0GNCdhd/sRmzs6l6S7hXEdbR1kdWDvUqdFi0jS51tLws3CCo4XeeA0bYKqqzZ1V
         uefzgRFkQJynUtWlYLMDz7p32cjymuPrpv2w9CYeNFfFTGQuLzqzyVdNosdc5xzcSOGG
         YNeZhizz25qlmV396XPYx4BQ8IqYI/7HRl48CQiKX4Q7xQ/LITOQgp703FY4grbguWva
         R+TxopbpC6W6XcRhJDf8JOQhZvbkW95AOI4frzifvWgZlQTXMcXKmL/qedbv8H5nq9BR
         VXmsKppreMgnmzhFamfZzOyzq6LRpRTyGAc6TM5XkYtAE/ADY80+1VoDCAzaSuPeXD64
         X1Xw==
X-Gm-Message-State: AOAM533ZKn6kEgoFidHc/krfDIiCIZXyq2iEMM3s+reKRzy7Ewbh4/5R
        onGdi3iWGU/p5YITKFCJYRmo6KjQSwZ2jA==
X-Google-Smtp-Source: ABdhPJzTq1VMUcazsXu6EcdKvLzB5ilhvsrksjotyvOIp2GpquSbSKvYw0DPmXzkLQYqfaZKFe4cj2JYTeS0zg==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:11:31d5:9537:66db:f466])
 (user=ipylypiv job=sendgmr) by 2002:a25:bad0:: with SMTP id
 a16mr5425555ybk.441.1617043036946; Mon, 29 Mar 2021 11:37:16 -0700 (PDT)
Date:   Mon, 29 Mar 2021 11:36:39 -0700
In-Reply-To: <20210329183639.1674307-1-ipylypiv@google.com>
Message-Id: <20210329183639.1674307-3-ipylypiv@google.com>
Mime-Version: 1.0
References: <20210329183639.1674307-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 2/2] scsi: pm80xx: Remove busy wait from mpi_uninit_check()
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
index a6f65666c98e..9fade2ed9396 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1502,12 +1502,12 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
 
 	/* wait until Inbound DoorBell Clear Register toggled */
 	if (IS_SPCV_12G(pm8001_ha->pdev)) {
-		max_wait_count = (30 * 1000 * 1000) /* 30 sec */
+		max_wait_count = SPCV_DOORBELL_CLEAR_TIMEOUT;
 	} else {
-		max_wait_count = (15 * 1000 * 1000) /* 15 sec */
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
2.31.0.291.g576ba9dcdaf-goog

