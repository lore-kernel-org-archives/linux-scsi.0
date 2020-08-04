Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB0EFC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 12:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 883522086A
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 12:36:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OxhKHu6d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgHDMgB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 08:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgHDMgA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 08:36:00 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9882BC06174A;
        Tue,  4 Aug 2020 05:35:59 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id c16so21838379ejx.12;
        Tue, 04 Aug 2020 05:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6RTVhFDX46AnPd26vPe+RB8qNqmkRWknJbiE97l1Y+Y=;
        b=OxhKHu6db2XpSqxcE6NiFINrJxgBl1DWnXgFtyU+pkKBKOfzyy0+LMbh7NB7HNVfRU
         lMJGCoDE/FZs+I0WNEJMG5XsdddfDRzcUMWNJu6p52Gu7mJNM+sCuS/VaZb+qIJjMATc
         R1cfNcJHias4PZkk5yIkei6BALKCW9cfEB9U9E+BymV6YcI4tDWzyhTo0qzWC3ccQQyI
         sxBWhbkcntUTnU29PDsd1GGfMRoIqRSE0oM2eQqLEsR+ZqV0IScRascUv5BF4oWegVdu
         lczV+GvaY8Zlsj3LkvcSID3NqGz+TeqAadC7Cnrr+93GAVGDQafxcXR7klC/2PG27GV8
         oz4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6RTVhFDX46AnPd26vPe+RB8qNqmkRWknJbiE97l1Y+Y=;
        b=jUekQbGrFT7ZgGFEIE4H3sXm3s5gvvSVsueo1hRElcdR6g+rty4403BS43yKIw6PTR
         GTqZh8OQ9NDvw52QEpN80U83ZotLPbjAlLrRtVNAWkDtnwgwGLRpLfbIa1Ds9b9kL6vb
         eJL2Uh9Ns44cQIlzrDkmJ4a4sWtWgByNoq2nLER77VsJDsfk3ahTQp+VKQC64z+he/C2
         fVILTCHfP1rr+VYIN4Wgt6q9ZM18TH/kN6bZ8p6/ZFc2npgSVavz/gOgnfcKpsPCo6NT
         /cOTpAmBF1ts5lJf1L+LT3tmeFapPkCzlh0BEZZc9qC8Z7+tg5/bh0e/GI+ecuEW2nyr
         X4qQ==
X-Gm-Message-State: AOAM532339lKu8c2ep0RD+nMVOeT6uwF1geMfiFXFDQb03tykpfw+FTS
        mThQabI2JIA6jW9C8RZpcIx+VZSX
X-Google-Smtp-Source: ABdhPJz6aFKnteEC4JgAR1C+2YaUjYOnKQtqD4brmBogNEtSQ0mZlS4h+I6t7kqgs/QwPlpjFkXsRQ==
X-Received: by 2002:a17:906:a209:: with SMTP id r9mr22108168ejy.413.1596544558402;
        Tue, 04 Aug 2020 05:35:58 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:b88a:676c:15b9:533b:62ba:b5b3])
        by smtp.gmail.com with ESMTPSA id r19sm18514261edi.85.2020.08.04.05.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 05:35:57 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1] scsi: ufs: no need to send one Abort Task TM in case the task in DB was cleared
Date:   Tue,  4 Aug 2020 14:35:34 +0200
Message-Id: <20200804123534.29104-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

If the bit corresponds to a task in the Doorbell register has been
cleared, no need to poll the status of the task on the device side
and to send an Abort Task TM.
This patch also deletes dispensable dev_err() in case of the task
already completed.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 307622284239..581b4ab52bf4 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6425,19 +6425,16 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		return ufshcd_eh_host_reset_handler(cmd);
 
 	ufshcd_hold(hba, false);
-	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	/* If command is already aborted/completed, return SUCCESS */
-	if (!(test_bit(tag, &hba->outstanding_reqs))) {
-		dev_err(hba->dev,
-			"%s: cmd at tag %d already completed, outstanding=0x%lx, doorbell=0x%x\n",
-			__func__, tag, hba->outstanding_reqs, reg);
+	if (!(test_bit(tag, &hba->outstanding_reqs)))
 		goto out;
-	}
 
+	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	if (!(reg & (1 << tag))) {
 		dev_err(hba->dev,
 		"%s: cmd was completed, but without a notifying intr, tag = %d",
 		__func__, tag);
+		goto out;
 	}
 
 	/* Print Transfer Request of aborted task */
-- 
2.17.1

