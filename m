Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D56C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 22:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbjBBWCG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Feb 2023 17:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbjBBWCD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2023 17:02:03 -0500
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F391F8AC18
        for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2023 14:01:44 -0800 (PST)
Received: by mail-pl1-f171.google.com with SMTP id h9so3318584plf.9
        for <linux-scsi@vger.kernel.org>; Thu, 02 Feb 2023 14:01:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=43Il6geCoBwdzoPJ2eu5yaFzdKGrs+yfucUHHgPZhuo=;
        b=k9mZjcK7jVzt8RWqq3Oao/b//+JopprBO104Ti4BJR5osZRdVeC1ICZ/uw+5isuZDw
         IsZfVI7UOYXie/cMCjVK6aNO1eRkuRNObBsg2pubj8RM8qaTWqVyhScaE61pl9Ssypo9
         dmP+TV9eW66MMe5KLdpNs5JyZNnLIB6tIsvwLBuLbf/Iq67ZqQbh3Wj0cpKz0vZ5wFAv
         KUowj2PDp4NN32d+IuSXzEMAUrN3SMVQYuJ+q2vmnnKfaGeR3suPngjNKGOZ0ivOoqWC
         vF4Vuii1hWlmTFNMo/Vf+TT9fUaEoYMEPfWI6lLQ/Jjxb3H2JLgrWFgZXeerAddlTT1V
         Apxw==
X-Gm-Message-State: AO0yUKVwT6znhYEfxe9Kg7u1HkJhAdy7FQlnkd90W5z7mOZtHuOZzgdq
        wYiTqxLaHh4UMoHzSMHZNfQ=
X-Google-Smtp-Source: AK7set++ERfgiI4KnYYwd7RkDCvPL3gPZsuGOgsEoFFZVpTd6GxvBRlR4C8qPch4A3mWQ78F+oLgfA==
X-Received: by 2002:a05:6a20:bf28:b0:bf:1e6b:663d with SMTP id gc40-20020a056a20bf2800b000bf1e6b663dmr7183315pzb.44.1675375265464;
        Thu, 02 Feb 2023 14:01:05 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf7f:37aa:6a01:bf09])
        by smtp.gmail.com with ESMTPSA id t8-20020a63b708000000b004f1e87530cesm232951pgf.91.2023.02.02.14.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 14:01:04 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v2 2/2] scsi: ufs: Use SYNCHRONIZE CACHE instead of FUA
Date:   Thu,  2 Feb 2023 14:00:41 -0800
Message-Id: <20230202220041.560919-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
In-Reply-To: <20230202220041.560919-1-bvanassche@acm.org>
References: <20230202220041.560919-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Asutosh Das <quic_asutoshd@quicinc.com>

UFS devices perform better when using SYNCHRONIZE CACHE command
instead of the FUA flag. Hence this patch.

Signed-off-by: Asutosh Das <quic_asutoshd@quicinc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
[ bvanassche: modified a source code comment ]
---
 drivers/ufs/core/ufshcd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bf3cb12ef02f..a8d42d9308da 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -24,6 +24,7 @@
 #include <linux/sched/clock.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include "ufshcd-priv.h"
@@ -5056,6 +5057,9 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
 	/* WRITE_SAME command is not supported */
 	sdev->no_write_same = 1;
 
+	/* Use SYNCHRONIZE CACHE instead of FUA to improve performance */
+	sdev->sdev_bflags = BLIST_BROKEN_FUA;
+
 	ufshcd_lu_init(hba, sdev);
 
 	ufshcd_setup_links(hba, sdev);
