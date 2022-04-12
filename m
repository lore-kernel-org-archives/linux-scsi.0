Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08141C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348537AbiDLSVf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238105AbiDLSVe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:21:34 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0116E12639
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:19:15 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id z16so18224335pfh.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:19:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kFrJiGoPLc1JlPkJ2qqLkZ4QwtfRPN1jzG22aAKAJhk=;
        b=NLIX15aY3dvAG1RZTt2p/x+L/uI4jtKPiFK9YWaYQWvp04gynnTagwY4TceWkMCtl1
         DSq+WvhyhlraOn01C6E9uq30A7VKX7JKcV863vFOzLj9qNlsIrQiw5rDCuoXa/DolZfS
         2KdmaBpXPyUp+RJzMHRn+YiYY/EWv3AdemLCPfoXES6/LmzIYTAD58vZms4jEenNXiYE
         EN1P7KfMNa1cCQb8ixePg5dYhPRdzHiv9RoccZkJZpJ6zRNAJnd5lRy7UzXMZDMwrT9W
         cOmaZxFzyVifu3dO9/oENuOjJFZ1uC9Ie5sDwW1MXdNrDABgc7PbFD4Gi24KsZ64zMlE
         O8Yg==
X-Gm-Message-State: AOAM533hnvMwC4Raa68taPLbhnS/gl+5rmJApgxiBTMlipyLwmssc51u
        5aMjgdp81cOqqmp40dIza7w=
X-Google-Smtp-Source: ABdhPJzpskmL/9fNQ7p6V1C2BzunzttWBr6tH9IvOpraMMNU2MRxivdm09AK7WaGN9px3F35aCClQw==
X-Received: by 2002:a63:495b:0:b0:399:8cd:81de with SMTP id y27-20020a63495b000000b0039908cd81demr30821826pgk.508.1649787555343;
        Tue, 12 Apr 2022 11:19:15 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:19:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Daejun Park <daejun7.park@samsung.com>
Subject: [PATCH v2 02/29] scsi: ufs: Declare ufshcd_wait_for_register() static
Date:   Tue, 12 Apr 2022 11:18:26 -0700
Message-Id: <20220412181853.3715080-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Declare this function static since it is only used inside the ufshcd.c
source file.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 drivers/scsi/ufs/ufshcd.h | 3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3f9caafa91bf..dbf50b50870b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -639,7 +639,7 @@ EXPORT_SYMBOL_GPL(ufshcd_delay_us);
  * Return:
  * -ETIMEDOUT on error, zero on success.
  */
-int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
+static int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
 				u32 val, unsigned long interval_us,
 				unsigned long timeout_ms)
 {
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 88c20f3608c2..949427714d0e 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1030,9 +1030,6 @@ void ufshcd_remove(struct ufs_hba *);
 int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
 int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
 void ufshcd_delay_us(unsigned long us, unsigned long tolerance);
-int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
-				u32 val, unsigned long interval_us,
-				unsigned long timeout_ms);
 void ufshcd_parse_dev_ref_clk_freq(struct ufs_hba *hba, struct clk *refclk);
 void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val);
 void ufshcd_hba_stop(struct ufs_hba *hba);
