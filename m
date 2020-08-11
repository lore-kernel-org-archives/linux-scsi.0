Return-Path: <SRS0=1zSt=BV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 379EAC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 14:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C3EA206C3
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 14:19:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UsZATr2c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgHKOTq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Aug 2020 10:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728516AbgHKOTo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2020 10:19:44 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3273C06174A;
        Tue, 11 Aug 2020 07:19:43 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id bo3so13254605ejb.11;
        Tue, 11 Aug 2020 07:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YEsfFaQhbNo4Nh7eCvn4HhXSvpFeuv1zORb6ik42jgw=;
        b=UsZATr2cNAFxqiVxvPOK8ahADy4L1dDNduK7GACjlWsMDN5tCavCLbrwWccj5laels
         4LF3Y0HrqBHLTow17Q3+C4k0XZPQIOvHsdgOjn0bG6GOXutiI91kMxU6m5wb5wCCvwnh
         mQASFylYiGrx78sXVASy1jobZxKWsX2jZoixnvnHwNExSwW7ezpU+6IEVUh0+Fg49LSR
         RKCDtYHTRgWUD0gD+o/mo1+s/LzfcKF7tVr5YZEVMwgI2Qwr1Bj1xgVDZgzfhJY7aXbj
         mTjbk4cSq+6wW44wOzKpu8ynei0pQlM4yVJlilDZi3N/Qmr5qIC2m35QNCnJo+loQNdK
         YAbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YEsfFaQhbNo4Nh7eCvn4HhXSvpFeuv1zORb6ik42jgw=;
        b=VrwOzhDJ4ZOyogbNll2UxXlSIcWtD56PSzHnn2ihjAyYOJZ9XEyxK0IH9AwIxZsn7D
         Wm7RWoQ6lIdNbZyiX+QHY7rk34SbqcX9N6HvYn6pAOj9mx0F0oWHkO5r0A4VNoBBY2ot
         5Gz0jquGGWd6YX4q0s3QYOGs2wQBY4H3GEvYK4izh1EIp90IshHOW6mYzFeCwL/2wii/
         Rg6CxnjgrpEFimewwkGsL69yhc7ToebuRg9lwA5ZWFd6r37/CtHc9W4+8L2sUBp2UN8O
         Q0jjJHyQNZOL34eYJ6O/p3RWuHSM5bcw0SOJAYFGIDDWay8YfGbzs5xwNNYyZdtjEwzk
         3F2Q==
X-Gm-Message-State: AOAM530qXFSaLeZGQg8+ujxwFMjOCvayZRPWU1SFYfz9iS2gmaxwnqVO
        fCBtukkAam7MJoA0l1+G45s=
X-Google-Smtp-Source: ABdhPJzyb7M7mG3dDtcLnkTiqXUcQEES7gFqcW6KVcEobXEubQ5NScG4FLPERR6RFSxXw5NYrc0idg==
X-Received: by 2002:a17:906:73d9:: with SMTP id n25mr8793159ejl.412.1597155582400;
        Tue, 11 Aug 2020 07:19:42 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:b888:52c9:44c:d55b:5f94:2fc4])
        by smtp.gmail.com with ESMTPSA id q15sm1467050edc.74.2020.08.11.07.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 07:19:41 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] scsi: ufs: no need to send one Abort Task TM in case the task in DB was cleared
Date:   Tue, 11 Aug 2020 16:18:59 +0200
Message-Id: <20200811141859.27399-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200811141859.27399-1-huobean@gmail.com>
References: <20200811141859.27399-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

If the bit corresponds to a task in the Doorbell register has been
cleared, no need to poll the status of the task on the device side
and to send an Abort Task TM. Instead, let it directly goto cleanup.

Meanwhile, to keep original debug print, move this goto below the debug
print.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 66fe814c8725..5f09cda7b21c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6434,14 +6434,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto out;
 	}
 
-	if (!(reg & (1 << tag))) {
-		dev_err(hba->dev,
-		"%s: cmd was completed, but without a notifying intr, tag = %d",
-		__func__, tag);
-	}
-
 	/* Print Transfer Request of aborted task */
-	dev_err(hba->dev, "%s: Device abort task at tag %d\n", __func__, tag);
+	dev_info(hba->dev, "%s: Device abort task at tag %d\n", __func__, tag);
 
 	/*
 	 * Print detailed info about aborted request.
@@ -6462,6 +6456,13 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	}
 	hba->req_abort_count++;
 
+	if (!(reg & (1 << tag))) {
+		dev_err(hba->dev,
+		"%s: cmd was completed, but without a notifying intr, tag = %d",
+		__func__, tag);
+		goto cleanup;
+	}
+
 	/* Skip task abort in case previous aborts failed and report failure */
 	if (lrbp->req_abort_skip) {
 		err = -EIO;
-- 
2.17.1

