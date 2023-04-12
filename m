Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E331C7619A
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 20:41:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjDLUl4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjDLUly (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2023 16:41:54 -0400
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8236D59ED
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 13:41:53 -0700 (PDT)
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-51b0f9d7d70so653149a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 13:41:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681332113; x=1683924113;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iE3M16v/3jVwdoM92bNIaScesnw7812ie0MPO/4++BY=;
        b=MtlE9UeBa7EqLIWeiACRr99jeD0PTQc6LMzPrRjUXaoLZVBEfL+6iEvObh+VflZbUy
         aHbcodSb+12JHmowEutGh3yTVpHgycJuhnL/gm9BDHupYldW98xP5crBd93bYzr3vLb6
         nF7jq/KBo9GSrhI0V1lOVw06A0mFU8kSYE1dC4R2LbPPI50kQaIOumM5wnFHBc3EQod4
         N2MD5NlS5PDBJHJghkIXC9Izq6IntYwCFCK7xdjWWZWEfkBvYkd9E9x6tEaaieKPTe+9
         7f3TmRwQurLoxuCBJ8YRA6TrtXCqLyOrG3OTzCZ6YN6mWXIoesQ9zh0aqlC+aT2DPBoW
         ry+w==
X-Gm-Message-State: AAQBX9e3+IeMC1iMZnbd8Dtjb4jh2AR/3wa5N1ahRX4l3HHJovcn+nj1
        80F07Ohc0vpHYmlqicncdbc=
X-Google-Smtp-Source: AKy350YpRnvvJnO8oFKeB2Ret3DCLEYXNyfVGbvgExrFhk6mwdKfrROSRZpmLSn9SCLkg0QKxnbbcA==
X-Received: by 2002:a05:6a00:10d5:b0:63a:33d5:9224 with SMTP id d21-20020a056a0010d500b0063a33d59224mr213591pfu.18.1681332112960;
        Wed, 12 Apr 2023 13:41:52 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d89d:35dd:5938:1993])
        by smtp.gmail.com with ESMTPSA id l19-20020a62be13000000b006249928aba2sm12123364pff.59.2023.04.12.13.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 13:41:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH 3/3] scsi: ufs: Increase the START STOP UNIT timeout from one to ten seconds
Date:   Wed, 12 Apr 2023 13:41:25 -0700
Message-Id: <20230412204125.3222615-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
In-Reply-To: <20230412204125.3222615-1-bvanassche@acm.org>
References: <20230412204125.3222615-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

One UFS vendor asked to increase the UFS timeout from 1 s to 3 s.
Another UFS vendor asked to increase the UFS timeout from 1 s to 10 s.
Hence this patch that increases the UFS timeout to 10 s. This patch can
cause the total timeout to exceed 20 s, the Android shutdown timeout.
This is fine since the loop around ufshcd_execute_start_stop() exists to
deal with unit attentions and because unit attentions are reported
quickly.

Fixes: dcd5b7637c6d ("scsi: ufs: Reduce the START STOP UNIT timeout")
Fixes: 8f2c96420c6e ("scsi: ufs: core: Reduce the power mode change timeout")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 784787cf08c3..6831eb1afc30 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9182,7 +9182,8 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
 	};
 
 	return scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, /*buffer=*/NULL,
-			/*bufflen=*/0, /*timeout=*/HZ, /*retries=*/0, &args);
+			/*bufflen=*/0, /*timeout=*/10 * HZ, /*retries=*/0,
+			&args);
 }
 
 /**
