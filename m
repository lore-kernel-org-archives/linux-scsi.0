Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF3F9C55ABD
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 10:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58BDA22228
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 10:19:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nipvy8G4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgKLKTg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Nov 2020 05:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgKLKTf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Nov 2020 05:19:35 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE8BC0613D4
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2020 02:19:33 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id a65so4987572wme.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2020 02:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=NHTrFF9eh2XblHyVl+3sVAWR30zEwKPwIKuGP3qg/NE=;
        b=nipvy8G4p8op6468cBHvIIQQvJCZwnFCXHMX5KTKjrjEP+xQE2ms8kUTkADJUUtVr5
         PmZ3KSJf5lbTeJej4/qktUVpjfNzG1PVLFeaviHo0OcYGLMEl4b03imTzbVY2NYhu/4g
         TjDhP5MXPbtiWEDpcnrctL3L4DK+35qmQ/mv3K80be63xPZJrQ+ujIAwdYffi/J4iOte
         Pooqb6ZILDtgrSaq1m0oMJ5qAwKyFvDy1OLO5aWJmX7fA49zDniWyuMMkwOf/wyCVYtF
         bUB9YY1rVd8nVN/EBha0J8vI099BPBHkAjMIV3xZRFeXp4b/oqJlyvIzwZ9dLglUuSiq
         fZVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=NHTrFF9eh2XblHyVl+3sVAWR30zEwKPwIKuGP3qg/NE=;
        b=OZdkVTKA96q7adPVmOmT0hXqDTPttQbkWZLAGTx0w/fg6wHYoiJwP6w50P5Odt7ERR
         x2rZHAOhBv9XoK8lubYulFzb9s5hiZ0TyfVXok1CvBgdfafoxPvn/ww+8Z5aMQZ9c/A3
         P3HpGkmlUhKOb6y9vgvaxT2H2Vn3hnkFPsiIpkz28C6jNHtDciN0EsboiQ43mom53a6l
         3RCMM8R52vkMe1JQWB0ITxEEoHThPa77kSWOX47KmjeBCwyOmgF/gwmcDggX2arEXTI2
         x16haukiVgd/qSN7KqkVsb1LV4ot6AF8kjgE/905b32sr7LvgNkkpRt1Pt/eJ7IIdsqp
         xoEA==
X-Gm-Message-State: AOAM530Cr2Y4Mx24D8e1LudPfub24W9u6ru0z2+2A8nvliCFynt9o+6O
        ooj5ak6vtDGUo8VUBBvZoV/KfDTRQvYWXyyI
X-Google-Smtp-Source: ABdhPJwgzkrq2N19ryFY3YIJyQ+0d7aUlC/ZIESzRyLGO0+UPzxGd6GcjXreMUTFvjpz0oEe6Hb9gg==
X-Received: by 2002:a1c:e006:: with SMTP id x6mr9112761wmg.107.1605176372216;
        Thu, 12 Nov 2020 02:19:32 -0800 (PST)
Received: from dell ([91.110.221.159])
        by smtp.gmail.com with ESMTPSA id i10sm6059583wrs.22.2020.11.12.02.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 02:19:31 -0800 (PST)
Date:   Thu, 12 Nov 2020 10:19:29 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Don Brace <don.brace@microchip.com>,
        Bugfixes to <esc.storagedev@microsemi.com>,
        storagedev@microchip.com
Subject: [PATCH v2 19/19] scsi: hpsa: Strip out a bunch of set but unused
 variables
Message-ID: <20201112101929.GC1997862@dell>
References: <20201102142359.561122-1-lee.jones@linaro.org>
 <20201102142359.561122-20-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201102142359.561122-20-lee.jones@linaro.org>
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

v2: Fix missing '{'

drivers/scsi/hpsa.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 16fd378285d27..99562b6bb8ccf 100644
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
+	if (rc != 0) {
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
