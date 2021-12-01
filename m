Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6CBEC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Dec 2021 21:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhLAVa1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Dec 2021 16:30:27 -0500
Received: from mail-pf1-f182.google.com ([209.85.210.182]:38629 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243044AbhLAVaD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Dec 2021 16:30:03 -0500
Received: by mail-pf1-f182.google.com with SMTP id g18so25927235pfk.5
        for <linux-scsi@vger.kernel.org>; Wed, 01 Dec 2021 13:26:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4ChACoTh18mRsLTO2LLnA/tGUkbwKD6aQCJLGtXG+Y0=;
        b=IJBzEiXI9hZvUwCxzyIj8decwYWkqL+JSQjbS3sg/U+cMYsZAHGvFMTHjBkVWwq5xZ
         4jTN4ks/PugCcB5q2OlG8I3EwBBmnSxE5pvcGLGSGYiYUNtX2YkxiGzRI2C3SQjoSeid
         tjDEcQwDA7fHKQnGmCogjmWREiy8Nd884S6PuyBRv4ntoQ/z2+soDKo/1Re3TLmhN7w3
         EhySyUx0z5kgAwtRYrPJUkGksumny8YMRXCMfTZ+nJJ/cp/sVhNGYv2/wv2JU75UNq/J
         vIMVryinl/lc70MdxoQn54oq1OHNnXt/GnGCBPA3YjiPTsqrlmqHdt64g1OE0ICMqOkE
         h9+g==
X-Gm-Message-State: AOAM530yqQwQFjIu3LB9ei6INRl5nY61YgxYOrmlIIolt4VIRkFBr5bk
        HGDORUEYWbVO3z0G1F8CQeE=
X-Google-Smtp-Source: ABdhPJy2LMmspBX12cN0sf4mrxs4zbIX/8wJFmozer0X1qLx+QAfWNh2IJfXKu22sKJfnBgh4VY6Sw==
X-Received: by 2002:a05:6a00:148c:b0:49f:e048:25dc with SMTP id v12-20020a056a00148c00b0049fe04825dcmr8719687pfu.12.1638394001937;
        Wed, 01 Dec 2021 13:26:41 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7344:c0bd:a55f:88b8])
        by smtp.gmail.com with ESMTPSA id g20sm815706pfj.12.2021.12.01.13.26.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 13:26:41 -0800 (PST)
Subject: Re: [PATCH v3 10/17] scsi: ufs: Fix a deadlock in the error handler
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Keoseong Park <keosung.park@samsung.com>
References: <20211130233324.1402448-1-bvanassche@acm.org>
 <20211130233324.1402448-11-bvanassche@acm.org>
 <25844cd2-872a-514f-4384-6ee877418dc7@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ab84bffe-fd84-82c6-d4f2-3ee73e7a850e@acm.org>
Date:   Wed, 1 Dec 2021 13:26:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <25844cd2-872a-514f-4384-6ee877418dc7@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/1/21 5:48 AM, Adrian Hunter wrote:
> I think cmd_queue is not used anymore after this.

Let's remove cmd_queue via a separate patch. I have started testing this patch:

Subject: [PATCH] scsi: ufs: Remove hba->cmd_queue

Suggested-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/scsi/ufs/ufshcd.c | 11 +----------
  drivers/scsi/ufs/ufshcd.h |  2 --
  2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5b3efc880246..d379c2b0c058 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9409,7 +9409,6 @@ void ufshcd_remove(struct ufs_hba *hba)
  	ufs_sysfs_remove_nodes(hba->dev);
  	blk_cleanup_queue(hba->tmf_queue);
  	blk_mq_free_tag_set(&hba->tmf_tag_set);
-	blk_cleanup_queue(hba->cmd_queue);
  	scsi_remove_host(hba->host);
  	/* disable interrupts */
  	ufshcd_disable_intr(hba, hba->intr_mask);
@@ -9630,12 +9629,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
  		goto out_disable;
  	}

-	hba->cmd_queue = blk_mq_init_queue(&hba->host->tag_set);
-	if (IS_ERR(hba->cmd_queue)) {
-		err = PTR_ERR(hba->cmd_queue);
-		goto out_remove_scsi_host;
-	}
-
  	hba->tmf_tag_set = (struct blk_mq_tag_set) {
  		.nr_hw_queues	= 1,
  		.queue_depth	= hba->nutmrs,
@@ -9644,7 +9637,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
  	};
  	err = blk_mq_alloc_tag_set(&hba->tmf_tag_set);
  	if (err < 0)
-		goto free_cmd_queue;
+		goto out_remove_scsi_host;
  	hba->tmf_queue = blk_mq_init_queue(&hba->tmf_tag_set);
  	if (IS_ERR(hba->tmf_queue)) {
  		err = PTR_ERR(hba->tmf_queue);
@@ -9713,8 +9706,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
  	blk_cleanup_queue(hba->tmf_queue);
  free_tmf_tag_set:
  	blk_mq_free_tag_set(&hba->tmf_tag_set);
-free_cmd_queue:
-	blk_cleanup_queue(hba->cmd_queue);
  out_remove_scsi_host:
  	scsi_remove_host(hba->host);
  out_disable:
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 411c6015bbfe..88c20f3608c2 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -738,7 +738,6 @@ struct ufs_hba_monitor {
   * @host: Scsi_Host instance of the driver
   * @dev: device handle
   * @lrb: local reference block
- * @cmd_queue: Used to allocate command tags from hba->host->tag_set.
   * @outstanding_tasks: Bits representing outstanding task requests
   * @outstanding_lock: Protects @outstanding_reqs.
   * @outstanding_reqs: Bits representing outstanding transfer requests
@@ -805,7 +804,6 @@ struct ufs_hba {

  	struct Scsi_Host *host;
  	struct device *dev;
-	struct request_queue *cmd_queue;
  	/*
  	 * This field is to keep a reference to "scsi_device" corresponding to
  	 * "UFS device" W-LU.
