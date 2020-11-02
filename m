Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A78C388F2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C818206F8
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:24:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="p5gv76b1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgKBOYb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 09:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgKBOY3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 09:24:29 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7855EC061A49
        for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2020 06:24:29 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id c9so8036918wml.5
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2020 06:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gYXRe7D5GCobzJA+DWJKpgWmSfraOvjmjOLuPeMvqEQ=;
        b=p5gv76b1szPR4z0IxdEII81bCJNxDSSxIMAfclFyk8C9w1Nd+xN7AeEDqZaOvLIXrf
         RQngPHA8G1W3uCO6VwNGLZnAACNyvAu7HsxchW2qnbAsyTSUcdEkpTlAFFY0Z1ufc54y
         G9X4dRk7XP+WoySTS8eC0n90QrxHw0ZGlm9QalH4uvgpEe1JrJrRCE347nlOMlY6ArUk
         OcmU7WzxS7Sw85uRzcyaiEVrIPqHcxgRNpagMaZ7C1tDFEcdkKfhSFwHSAPaf3Kh5P0M
         1XolWtLpv7bfG8AbDIy9HpeIcbpESDPk5OuvS/vZth2dScABz1tSu6QddG1ptVCvwwVT
         EN0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gYXRe7D5GCobzJA+DWJKpgWmSfraOvjmjOLuPeMvqEQ=;
        b=CRYTMeYKKpeWYkCR7LrCtYMmYtaEvoel5Qt/6mLq21Kva/C94SHxVf3XCKgOOFK39K
         OZCQsmnKT5aMkVGK4uBaQ/umbbPoqdjF4pU9dRk5VBbR1nYrELVQT8nH/kjzywx3fGXw
         eAhKhEw2jUyZ1p9PzojTX7jBqeCuNlnL1lbtrUat7QC6WWsPbjcw+g1+wV8xtll1AbCD
         +K+2DAVq5YrQ/QOwXVwqqDWryS72paPuCR5hkrHBBD0CnOnrz8NDpYOu9plUZExSlTDV
         RU/KcACeRxcsns+faVjaqKu06bmyOYSQoccwTfsZc3Pugd0YP1u8GPfy96pFYDgWuGbZ
         ozRg==
X-Gm-Message-State: AOAM5330ZNuf+Pf7VcSPgjdS7VNfEo8MPpb6h22a7b9UDKp5cqbkEeE1
        KmPODsaLsEaLvSGuNYJPBkU1Sw==
X-Google-Smtp-Source: ABdhPJxvCxyHKzS8jJeU6IcN2+ly0u9053pwOpBwSYvsX9YBJpXtOYx91dPoTF/ddYExAU0yGpQ32g==
X-Received: by 2002:a7b:c387:: with SMTP id s7mr17592278wmj.52.1604327068228;
        Mon, 02 Nov 2020 06:24:28 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id f7sm23542501wrx.64.2020.11.02.06.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 06:24:27 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Don Brace <don.brace@microchip.com>,
        Bugfixes to <esc.storagedev@microsemi.com>,
        storagedev@microchip.com
Subject: [RESEND 19/19] scsi: hpsa: Strip out a bunch of set but unused variables
Date:   Mon,  2 Nov 2020 14:23:59 +0000
Message-Id: <20201102142359.561122-20-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102142359.561122-1-lee.jones@linaro.org>
References: <20201102142359.561122-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/hpsa.c: In function ‘hpsa_volume_offline’:
 drivers/scsi/hpsa.c:3885:5: warning: variable ‘scsi_status’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/hpsa.c:3884:6: warning: variable ‘cmd_status’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/hpsa.c: In function ‘hpsa_update_scsi_devices’:
 drivers/scsi/hpsa.c:4354:9: warning: variable ‘n_ext_target_devs’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/hpsa.c: In function ‘hpsa_scatter_gather’:
 drivers/scsi/hpsa.c:4583:36: warning: variable ‘last_sg’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/hpsa.c: In function ‘hpsa_init_one’:
 drivers/scsi/hpsa.c:8639:6: warning: variable ‘dac’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/hpsa.c: In function ‘hpsa_enter_performant_mode’:
 drivers/scsi/hpsa.c:9300:7: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]

Cc: Don Brace <don.brace@microchip.com>
Cc: Bugfixes to <esc.storagedev@microsemi.com>
Cc: storagedev@microchip.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/hpsa.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 16fd378285d27..02e20bed8a484 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3881,8 +3881,6 @@ static unsigned char hpsa_volume_offline(struct ctlr_info *h,
 	u8 sense_key, asc, ascq;
 	int sense_len;
 	int rc, ldstat = 0;
-	u16 cmd_status;
-	u8 scsi_status;
 #define ASC_LUN_NOT_READY 0x04
 #define ASCQ_LUN_NOT_READY_FORMAT_IN_PROGRESS 0x04
 #define ASCQ_LUN_NOT_READY_INITIALIZING_CMD_REQ 0x02
@@ -3902,8 +3900,6 @@ static unsigned char hpsa_volume_offline(struct ctlr_info *h,
 	else
 		sense_len = c->err_info->SenseLen;
 	decode_sense_data(sense, sense_len, &sense_key, &asc, &ascq);
-	cmd_status = c->err_info->CommandStatus;
-	scsi_status = c->err_info->ScsiStatus;
 	cmd_free(h, c);
 
 	/* Determine the reason for not ready state */
@@ -4351,7 +4347,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 	u32 ndev_allocated = 0;
 	struct hpsa_scsi_dev_t **currentsd, *this_device, *tmpdevice;
 	int ncurrent = 0;
-	int i, n_ext_target_devs, ndevs_to_allocate;
+	int i, ndevs_to_allocate;
 	int raid_ctlr_position;
 	bool physical_device;
 	DECLARE_BITMAP(lunzerobits, MAX_EXT_TARGETS);
@@ -4416,7 +4412,6 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 		raid_ctlr_position = nphysicals + nlogicals;
 
 	/* adjust our table of devices */
-	n_ext_target_devs = 0;
 	for (i = 0; i < nphysicals + nlogicals + 1; i++) {
 		u8 *lunaddrbytes, is_OBDR = 0;
 		int rc = 0;
@@ -4580,7 +4575,7 @@ static int hpsa_scatter_gather(struct ctlr_info *h,
 		struct scsi_cmnd *cmd)
 {
 	struct scatterlist *sg;
-	int use_sg, i, sg_limit, chained, last_sg;
+	int use_sg, i, sg_limit, chained;
 	struct SGDescriptor *curr_sg;
 
 	BUG_ON(scsi_sg_count(cmd) > h->maxsgentries);
@@ -4602,7 +4597,6 @@ static int hpsa_scatter_gather(struct ctlr_info *h,
 	curr_sg = cp->SG;
 	chained = use_sg > h->max_cmd_sg_entries;
 	sg_limit = chained ? h->max_cmd_sg_entries - 1 : use_sg;
-	last_sg = scsi_sg_count(cmd) - 1;
 	scsi_for_each_sg(cmd, sg, sg_limit, i) {
 		hpsa_set_sg_descriptor(curr_sg, sg);
 		curr_sg++;
@@ -8635,7 +8629,7 @@ static struct ctlr_info *hpda_alloc_ctlr_info(void)
 
 static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	int dac, rc;
+	int rc;
 	struct ctlr_info *h;
 	int try_soft_reset = 0;
 	unsigned long flags;
@@ -8711,13 +8705,9 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* configure PCI DMA stuff */
 	rc = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
-	if (rc == 0) {
-		dac = 1;
-	} else {
+	if (rc != 0)
 		rc = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
-		if (rc == 0) {
-			dac = 0;
-		} else {
+		if (rc != 0) {
 			dev_err(&pdev->dev, "no suitable DMA available\n");
 			goto clean3;	/* shost, pci, lu, aer/h */
 		}
@@ -9298,10 +9288,9 @@ static int hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
 	} else if (trans_support & CFGTBL_Trans_io_accel2) {
 		u64 cfg_offset, cfg_base_addr_index;
 		u32 bft2_offset, cfg_base_addr;
-		int rc;
 
-		rc = hpsa_find_cfg_addrs(h->pdev, h->vaddr, &cfg_base_addr,
-			&cfg_base_addr_index, &cfg_offset);
+		hpsa_find_cfg_addrs(h->pdev, h->vaddr, &cfg_base_addr,
+				    &cfg_base_addr_index, &cfg_offset);
 		BUILD_BUG_ON(offsetof(struct io_accel2_cmd, sg) != 64);
 		bft2[15] = h->ioaccel_maxsg + HPSA_IOACCEL2_HEADER_SZ;
 		calc_bucket_map(bft2, ARRAY_SIZE(bft2), h->ioaccel_maxsg,
-- 
2.25.1

