Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E62BC07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18FBB61357
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhGIU3x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 16:29:53 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:53919 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbhGIU3w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 16:29:52 -0400
Received: by mail-pj1-f45.google.com with SMTP id p9so6369081pjl.3
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 13:27:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MMdVnriU+0MznJ/BnQqiwR0VpVYruaB3sRdsHxBFvEc=;
        b=Nra8FiEWcl2LoDv9uln2pFniNhbPBLc29dH/Pa+G3EtS9u5ZbH2SEGmbKXykzaHb8q
         X53J5tIwOZrQzoEcvyA3cxTrny6tee60ZjRuM+cettMFZvZ6trdgbr+JhtbBUpvmMrnw
         3v3/MPprMtZtmeYvOgV6SCfUeZ2bHtnjmA3edMcH59x61UpLPegYHT5TbG6URjvsRjYM
         Ptm4aP8UeHQDI0EtFpR/E7DfvURkTttZTs/C8iBcsIEj/rwe4ORnF5e7dsre7YwgA1Y5
         HBhSxMC1/d1Lk+BK/OSZO4456NziYoCuS2SUgwtYg09WSuTbNFI/dccS7eTX0MEOjw6l
         oXBQ==
X-Gm-Message-State: AOAM530USzSTANESy6Y1M7iWk3YurVq7U7M0eesKsPCW7SAsqwavPB5s
        3IafxzCMWvsKUUoGHAxLZs4=
X-Google-Smtp-Source: ABdhPJzu5diZ7zoP3hTQ9e86U6txGT78zvT7VgufUbC18Zg6A94gMTEvkCoNW0xDBf4hyiFCY2JlSg==
X-Received: by 2002:a17:90a:9b13:: with SMTP id f19mr39670715pjp.229.1625862428853;
        Fri, 09 Jul 2021 13:27:08 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id e16sm8812927pgl.54.2021.07.09.13.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:27:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 04/19] scsi: ufs: Rename the second ufshcd_probe_hba() argument
Date:   Fri,  9 Jul 2021 13:26:23 -0700
Message-Id: <20210709202638.9480-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709202638.9480-1-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename the second argument of ufshcd_probe_hba() such that the name of
that argument reflects its purpose instead of how the function is called.
See also commit 1b9e21412f72 ("scsi: ufs: Split ufshcd_probe_hba() based
on its called flow").

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Can Guo <cang@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 37302a8b3937..86ca9e1ce5aa 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7964,13 +7964,13 @@ static int ufshcd_clear_ua_wluns(struct ufs_hba *hba)
 }
 
 /**
- * ufshcd_probe_hba - probe hba to detect device and initialize
+ * ufshcd_probe_hba - probe hba to detect device and initialize it
  * @hba: per-adapter instance
- * @async: asynchronous execution or not
+ * @init_dev_params: whether or not to call ufshcd_device_params_init().
  *
  * Execute link-startup and verify device initialization
  */
-static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
+static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 {
 	int ret;
 	unsigned long flags;
@@ -8002,7 +8002,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 	 * Initialize UFS device parameters used by driver, these
 	 * parameters are associated with UFS descriptors.
 	 */
-	if (async) {
+	if (init_dev_params) {
 		ret = ufshcd_device_params_init(hba);
 		if (ret)
 			goto out;
