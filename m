Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 381D2C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 20:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1038161262
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 20:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346524AbhI2UIq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 16:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346376AbhI2UIh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 16:08:37 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69AC0C061765;
        Wed, 29 Sep 2021 13:06:55 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id g19-20020a1c9d13000000b003075062d4daso2614909wme.0;
        Wed, 29 Sep 2021 13:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ILAT+2o+6gqhrlieIGJMKpWSNQBv8ibrXFHSWep9zww=;
        b=kkXwZ4tuBzkPLfkam+0iYfk/xFCF4zYV05sN0zvCBctbewdth5CnvCTTby4fdt/Cpb
         MYDNJxpx6oFgBw8BQZ6uGEgHYwN7K61Abvo6dYoRscpx0msKVFq3k5a2m1Fhhx4bg8LK
         FahAm/Hf2bEE3mT18vzRDnklNvzIbr/bgnRLDH4zZxAcN4UBn5mIiKL8LJHM091EdxnU
         oU9qOWQa5AAM3NL0la97yrek5LbvSmLUvyFuq460YB8RoeY0cBPt9RMVtfE+pB0Lwu1R
         y0PR4uB4CHEbNIZh1a2lFs0andfWLi9lWCUoqojfBTTeYaKivU6U5ihOf7i/OvXhdS2l
         cosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ILAT+2o+6gqhrlieIGJMKpWSNQBv8ibrXFHSWep9zww=;
        b=bEKlfluTzHebKFaZaYh31FoOiaPFtU0+C1snNB/3mG6tLGYeFN3fC+85IBpYxuyuMa
         Bc5SQI+GkaR1jpFSmiXKM6B5weoUuVUBadNCmD3CVWFR9/dAmteV379+UUXgcdHc1irL
         TrE5GYL/bNTy6NGbP/ANeckZDUd/qivzXoMMIYwPvBcQLtB1t7RsSJqFpt+UIt6+uxzJ
         JJZ9PFCuZJj2ZW9pvVUF6Iq68kY/wo9P59paDik8SMFJELuEnwvYzS3eiwSkgRmOj3no
         iCGxYWxJCzJkJotpmFqefYkD/jRo39fvp2YAx49fmon42LaZN9syHeLgefmdp5VLuGyJ
         rgAg==
X-Gm-Message-State: AOAM532qg+HLZTPDCp3Er97b1jgi3+rWUYLwMRTJkcbsnCpyyjUdLHlr
        3OYz+6ewGFn6DTPw0yKlweo=
X-Google-Smtp-Source: ABdhPJxad1BhmREousWctVnLaSaz9jijKR1eS00B42zCGUmdZ4M38z35GD5DZM4XLIA7QAJE9ewOZA==
X-Received: by 2002:a1c:1d13:: with SMTP id d19mr1892206wmd.89.1632946014130;
        Wed, 29 Sep 2021 13:06:54 -0700 (PDT)
Received: from ubuntu-laptop.speedport.ip (p200300e94717cf3fe089f40c55d147be.dip0.t-ipconnect.de. [2003:e9:4717:cf3f:e089:f40c:55d1:47be])
        by smtp.gmail.com with ESMTPSA id l17sm910405wrx.24.2021.09.29.13.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 13:06:53 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] scsi: ufs: core: Remove return statement in void function
Date:   Wed, 29 Sep 2021 22:06:40 +0200
Message-Id: <20210929200640.828611-4-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210929200640.828611-1-huobean@gmail.com>
References: <20210929200640.828611-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

return statement is not useful at the end of "void" function.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 081092418e2d..2f0366c3cbf8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5845,7 +5845,6 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 	ufs_debugfs_exception_event(hba, status);
 out:
 	ufshcd_scsi_unblock_requests(hba);
-	return;
 }
 
 /* Complete requests that have door-bell cleared */
-- 
2.25.1

