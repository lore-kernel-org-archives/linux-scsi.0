Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 656FBC43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 06:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiGEGxi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 02:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiGEGxg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 02:53:36 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8082B5F89
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 23:53:35 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 145so10586814pga.12
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jul 2022 23:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0eNaY7c0YwJ/R0zBgjZVAVLdZXo+kCXJ/VuomQlDevs=;
        b=f4PP3EBCNydITxRlaj9nRNf92/D2xYVaxMBKIUs0w+w4J9Z2bgxCcqhXMSIPhmF7pX
         hHk2rVW8C9AOKc27TCe67oF3HiQvOuB/+4mNZxjxVZm7ptvTHw3UJZVewf3TpOc2dwno
         o808WuuSpjLZ4nFIeH02X8q4iW0312jfRhY8w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0eNaY7c0YwJ/R0zBgjZVAVLdZXo+kCXJ/VuomQlDevs=;
        b=MYqpb6zBW9rodvbF/AnQtpaaOY8XIeAA3x6i5hcL1+ja0Adzyf6OLPXkUN2uXrtUur
         wSNK/BXncCg0wGv1MTp8nwVmVPWNj9aeuVmpOGS+Okrp1MiogN/JRl7HEwK+q11eprbS
         SkCfYP8AFe+Pp9hwW/pKw4Xa0lEKfQbUIU1lnYiw95oBPRy/cjjSUXjSuMRrgv9D8XpQ
         DWXiOKyN2Zl1ksgRJQhAsE2/twibL3VNknewX9MkMWUVeFC2UTc9q7EBpdMJUxFvUV6b
         RKJenlsPa5zGUJovkCjR4bM4g5+jUkXuiVCezaEqVOf2A7yHrZHtT2kXkpgL42eUfTZ8
         vUFQ==
X-Gm-Message-State: AJIora/3fdQOM4ucwxgjFLAHz0uTLk2VPxHtYasjaqapFsFwdAXKAxv+
        CcH4P2HWvBIYGpdBnHbwDnHxIQ==
X-Google-Smtp-Source: AGRyM1vqPCOIa3mDo2BSwVN7PTIYIhI1Wgv1WavR9Z0i5FMx3CdSBqP8R+vMqOhXe2ypQzXNGbuoNA==
X-Received: by 2002:a05:6a00:1687:b0:518:6c6b:6a9a with SMTP id k7-20020a056a00168700b005186c6b6a9amr40044531pfc.81.1657004014947;
        Mon, 04 Jul 2022 23:53:34 -0700 (PDT)
Received: from dlunevwfh.roam.corp.google.com (n122-107-196-14.sbr2.nsw.optusnet.com.au. [122.107.196.14])
        by smtp.gmail.com with ESMTPSA id a15-20020a631a4f000000b00408a9264b36sm21611610pgm.3.2022.07.04.23.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 23:53:34 -0700 (PDT)
From:   Daniil Lunev <dlunev@chromium.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Daniil Lunev <dlunev@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH v2] scsi: ufs: ufs-pci: Enable WriteBooster capability on ADL
Date:   Tue,  5 Jul 2022 16:53:26 +1000
Message-Id: <20220705165316.v2.1.Ib5ebec952d9a59f5c69c89b694777f517d22466d@changeid>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sets the WriteBooster capability flag when ADL's UFS controller is used.

Signed-off-by: Daniil Lunev <dlunev@chromium.org>

---

Changes in v2:
- Fixed typo in commit message

 drivers/scsi/ufs/ufshcd-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index e892b9feffb11..fb7285a756969 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -425,6 +425,7 @@ static int ufs_intel_adl_init(struct ufs_hba *hba)
 {
 	hba->nop_out_timeout = 200;
 	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
+	hba->caps |= UFSHCD_CAP_WB_EN;
 	return ufs_intel_common_init(hba);
 }
 
-- 
2.31.0

