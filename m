Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D36C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 16:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F2BB6143C
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 16:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhEMQug (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 12:50:36 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:39776 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbhEMQu2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 12:50:28 -0400
Received: by mail-pf1-f173.google.com with SMTP id c17so22344448pfn.6
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 09:49:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4+IuO6KEGlx+5qHWUFAqfjtd04qaUnROSAOVdIrABTY=;
        b=FZRrngRZFNHe9LKuJS2/HHkjQTjQM3JByDFeRtfVTbb95om4u5nml/mDNs6IYh5phX
         00o4YMY4bzB1/Est+xqnNaskkp8uPdzdX/4a1tLyjHVaaAiX9nnCbRtaSbVRPoEm2zkr
         bVDu5s9xhuSm+uSoEMlh+pZ+PTk7bLilllmTseg/LkQ4CrMloKl+gCwj63tfXCoVP5B+
         g1uZV/YFotqCcIHMprfGpPVcs7r1THzMP60Wd5i5pDPArQk9wQPlCnCEVOpQESuUJi9v
         TereFIRxtlvhgbLo/sFD0BAgF3jdBRR2UR5OsqS0NB5k2Bmv9A6s2qY8xNFH51PEH0dv
         eK8A==
X-Gm-Message-State: AOAM532PYvYJuYwYbJXpp1s1hSVhHKMiQZboEjC0vyutASYiZiRprh6X
        vNdTQQTWAerppIA8cG6ILq4=
X-Google-Smtp-Source: ABdhPJwfkgN2nS3UyKJIU9lhuEHvZjhmHGPLa8ERMwARFilIp6PjfKmg6LbzRaJWkivg65vlYr/CXg==
X-Received: by 2002:a17:90a:bc94:: with SMTP id x20mr6130384pjr.107.1620924558634;
        Thu, 13 May 2021 09:49:18 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6dd7:5386:8c63:ccae])
        by smtp.gmail.com with ESMTPSA id x79sm2430789pfc.57.2021.05.13.09.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 09:49:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] ufs: Increase the usable queue depth
Date:   Thu, 13 May 2021 09:49:12 -0700
Message-Id: <20210513164912.5683-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With the current implementation of the UFS driver active_queues is 1
instead of 0 if all UFS request queues are idle. That causes
hctx_may_queue() to divide the queue depth by 2 when queueing a request
and hence reduces the usable queue depth.

The shared tag set code in the block layer keeps track of the number of
active request queues. blk_mq_tag_busy() is called before a request is
queued onto a hwq and blk_mq_tag_idle() is called some time after the hwq
became idle. blk_mq_tag_idle() is called from inside blk_mq_timeout_work().
Hence, blk_mq_tag_idle() is only called if a timer is associated with each
request that is submitted to a request queue that shares a tag set with
another request queue. Hence this patch that adds a blk_mq_start_request()
call in ufshcd_exec_dev_cmd(). This patch doubles the queue depth on my
test setup from 16 to 32.

In addition to increasing the usable queue depth, also fix the
documentation of the 'timeout' parameter in the header above
ufshcd_exec_dev_cmd().

Cc: Can Guo <cang@codeaurora.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 7252a3603015 ("scsi: ufs: Avoid busy-waiting by eliminating tag conflicts")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c96e36aab989..e669243354da 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2838,7 +2838,7 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
  * ufshcd_exec_dev_cmd - API for sending device management requests
  * @hba: UFS hba
  * @cmd_type: specifies the type (NOP, Query...)
- * @timeout: time in seconds
+ * @timeout: timeout in milliseconds
  *
  * NOTE: Since there is only one available tag for device management commands,
  * it is expected you hold the hba->dev_cmd.lock mutex.
@@ -2868,6 +2868,9 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	}
 	tag = req->tag;
 	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
+	/* Set the timeout such that the SCSI error handler is not activated. */
+	req->timeout = msecs_to_jiffies(2 * timeout);
+	blk_mq_start_request(req);
 
 	init_completion(&wait);
 	lrbp = &hba->lrb[tag];
