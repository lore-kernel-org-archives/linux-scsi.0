Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08602C43334
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jul 2022 23:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbiGCX2Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Jul 2022 19:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbiGCX2W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jul 2022 19:28:22 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B914EB73
        for <linux-scsi@vger.kernel.org>; Sun,  3 Jul 2022 16:28:20 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id r6so3149311pfq.6
        for <linux-scsi@vger.kernel.org>; Sun, 03 Jul 2022 16:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/hIVsD/q/UF9dyc1kLVHGPhnuZojG1AVD53nbKl4ZlU=;
        b=NebBmKITEmQKW9BtknzajFkyW09SQtUXtuNSOy+xU9ybV2LIkXH0+xvyqtF/klER4e
         tZRq7zXh8NiiFQQtC2tWlv4OcgG5mEx38rOxOTcxPHiIrwnA2y5DgLVKg0iIlZYLToy+
         a4ZYLPe6DjKcak2QDwNTQ63+NgoL0QJZgs3Oc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/hIVsD/q/UF9dyc1kLVHGPhnuZojG1AVD53nbKl4ZlU=;
        b=VFvD3bHdLF9u89NRl5kMsSha8aQFk1EVKonijusZeTpjPDRnyHfxRUUwsgrGmpUBc2
         wJL1gQziN0iYZmafLU4nIzaZgQqjROvkQqeMeTvJMMdgPYLczKihoCmOzORcDLGDowNV
         Cw0n8kH1pZP3v6W/urQvEdIY6xf9R3Yzzd22Kju8ERk8kj6pdSdXxTfNmP+KCjs6myzY
         +0XGlzhlrDW4OjkUGNw0DnuTr9XGIGilvNbpmyrDaALq32e909Mr1cIUpX2JPCBRVTZ5
         slWYru4AOqXxPrGBRhQvrlNBOsQ+U+vjtH2jIADhZWKwYDaYAVRiff+RpLEt3nq5fRQ3
         +Ovg==
X-Gm-Message-State: AJIora9LJrnpyaaGWMNxHUDYrO5LSrPpB28N0qyR4TqSSiEmIJ1iCtVc
        /jVSJTYQBhT33dcEgI3uGE0Y9/csls1qxA==
X-Google-Smtp-Source: AGRyM1tQqw8s/xQBYEY/2XBktL2xVedzh8VTLDgAYN/OkwES4S6cPCfjMQX31f3ag/IyV2Hf+LBkKg==
X-Received: by 2002:a63:124f:0:b0:412:4c1f:b611 with SMTP id 15-20020a63124f000000b004124c1fb611mr1898339pgs.574.1656890900258;
        Sun, 03 Jul 2022 16:28:20 -0700 (PDT)
Received: from dlunevwfh.roam.corp.google.com (n122-107-196-14.sbr2.nsw.optusnet.com.au. [122.107.196.14])
        by smtp.gmail.com with ESMTPSA id w18-20020a627b12000000b00527e026591esm10100594pfc.150.2022.07.03.16.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jul 2022 16:28:19 -0700 (PDT)
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
Subject: [PATCH] scsi: ufs: ufs-pci: Enable WriteBooster capability on ADL
Date:   Mon,  4 Jul 2022 09:28:06 +1000
Message-Id: <20220704092721.1.Ib5ebec952d9a59f5c69c89b694777f517d22466d@changeid>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sets the WrtieBooster capability flag when ADL's UFS controller is used.

Signed-off-by: Daniil Lunev <dlunev@chromium.org>

---

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

