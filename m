Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E15FC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Apr 2022 23:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiD0Xmk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Apr 2022 19:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiD0Xmh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2022 19:42:37 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4715F25F
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 16:39:25 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so6209722pju.2
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 16:39:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Pb20ev5jB8nj0N8bVNVYGAJNTRZq9Y7U0EGQL8t0l4=;
        b=7W1Ps1oVJEsgSaVyQx1N0K1ls9qe9HbruEEaSapnVlygq6jwRIznrV84vE02MG50OX
         YZKSwbiCe9aYrzoA+IVzUxNIc/cOKy2RnjCMUZA2jNcKPY2HApKkOXbWt/PD20l3/+LF
         9c1mA7mgaVV8060QWf2mIE9L9MjxMv+I2H5LHu81PgEcQD5GkUUi+Lkw19zsNrlaEvfx
         jkuzZDdqepKfaAlJJr9i3v/mDxfGV/nQl837fdVDR/yGLX2HIU4yfwb1ZM9KQ9skNP/3
         7ZlxKsuxldW9qBEMV44hZ/V+5kqiKBMI/bXmpQhxytOj+ACazq94KqY9jDJmu7MruUyJ
         1JCA==
X-Gm-Message-State: AOAM5318VlwxBHYImmEIN0H4pjjGThjKF8haVYrsD6IBnV184KeFffFv
        kJL6xf8VSslQ6dP7V0LC7qA77um+AAfCAg==
X-Google-Smtp-Source: ABdhPJzwJl7I6CMP6Ody6ZItv51jIEV+McI2f4m13wVfLA4JbtOiQIql9hIC00lOfPTgyYsk5OSEzA==
X-Received: by 2002:a17:90b:1a8a:b0:1d2:e93e:6604 with SMTP id ng10-20020a17090b1a8a00b001d2e93e6604mr46408221pjb.233.1651102764903;
        Wed, 27 Apr 2022 16:39:24 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6cbb:d78e:9b3:bb62])
        by smtp.gmail.com with ESMTPSA id f16-20020aa78b10000000b0050a81508653sm19817580pfd.198.2022.04.27.16.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 16:39:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/4] scsi: ufs: Reduce the clock scaling latency
Date:   Wed, 27 Apr 2022 16:38:52 -0700
Message-Id: <20220427233855.2685505-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
In-Reply-To: <20220427233855.2685505-1-bvanassche@acm.org>
References: <20220427233855.2685505-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Wait at most 20 ms before rechecking the doorbells instead of waiting
for a potentially long time between doorbell checks.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2b4390a1106e..a3fecbb403d3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1141,7 +1141,7 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 		}
 
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
-		schedule();
+		io_schedule_timeout(msecs_to_jiffies(20));
 		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
 		    wait_timeout_us) {
 			timeout = true;
