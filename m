Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA237C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 17:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C238F60FBF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 17:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238026AbhJ0REK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 13:04:10 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:53783 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbhJ0REJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Oct 2021 13:04:09 -0400
Received: by mail-pj1-f48.google.com with SMTP id v10so1929898pjr.3;
        Wed, 27 Oct 2021 10:01:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tt//2MMoJvopgNbcKLmDGr14U8HIEjWsbBF/ZeP8PpU=;
        b=QsrEzgb8NiWg9MqaxNfph/u7Uh2ycdwsmmkcp2ZSzAOCsUlZ8KESN6KSWaar2nPhOz
         ci9Z2h36CmM8gwihF6DR+W/9NAcIhCYUPi3P+PeiLa9j0bi2+0zvBfW1f7fY34Z6b0iO
         X9DryBluojWxr5edQymr90QQ6bC1U1KiNf2obWDh9OiU09+z3p90i2Qf6go5NGOluksh
         2mQfaAk2iSyRhSYB/SVFWKZLgI29UQYhgoZB1Kt6dczqvDWnwcgLOMXe9xhikoNmGGmP
         f8pJevax0PZGyp3fvuYHNoSCCCln5T5OtcdCR6UCzV6BGo/PTyX8CyxPviyRbdxHoWfq
         fEHQ==
X-Gm-Message-State: AOAM532tlCQukUCkwnFccjT9HMEUNsP0BPuWejadFd6ruDmcHJUJbF4z
        wyzfthCczBtvNvx/rbwhVZU=
X-Google-Smtp-Source: ABdhPJw7Yz3m2Ub9PvfSvBZtLdPS94rAsV/nzBjXScn0qsBgSS0x5TSYkgQ/Dv+cxj2NNCFwFoje/A==
X-Received: by 2002:a17:90a:a88e:: with SMTP id h14mr7106967pjq.41.1635354103986;
        Wed, 27 Oct 2021 10:01:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d40:ea48:4805:9a5e])
        by smtp.gmail.com with ESMTPSA id pi9sm288134pjb.31.2021.10.27.10.01.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 10:01:43 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
References: <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com>
 <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk>
 <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
 <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
 <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
 <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
 <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org> <20211027052724.GA8946@lst.de>
 <b8aec3cb-75f1-3e1f-1dfc-5d77322b736f@acm.org>
 <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
 <YXlqSRLHuIFiMLY7@T590> <3f43feaa-5c3a-9e4c-ebc1-c982b0723e7e@kernel.dk>
 <yq135om1p3i.fsf@ca-mkp.ca.oracle.com>
 <bbab4d8f-67c0-83bb-a979-cb9f9ac28af5@kernel.dk>
 <yq1r1c6zd4f.fsf@ca-mkp.ca.oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b0149856-4582-a3c0-a206-9b0fbf13854e@acm.org>
Date:   Wed, 27 Oct 2021 10:01:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <yq1r1c6zd4f.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/21 9:16 AM, Martin K. Petersen wrote:
> Given that HPB developed over time, I am not sure how simple a revert
> would be. And we only have a couple of days left before release. I
> really want the smallest patch possible that either removes or disables
> the 2.0 support.

How about one of the untested patches below?

The patch below disables support for HPB 2.0 by ignoring the HPB version reported
by the UFS controller:

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 66b19500844e..5f9f7139480a 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -2872,8 +2872,8 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
  		return;
  	}

-	if (version == HPB_SUPPORT_LEGACY_VERSION)
-		hpb_dev_info->is_legacy = true;
+	/* Do not use HPB 2.0 because of the blk_insert_cloned_request() call. */
+	hpb_dev_info->is_legacy = true;

  	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
  		QUERY_ATTR_IDN_MAX_HPB_SINGLE_CMD, 0, 0, &max_hpb_single_cmd);


The second patch changes the blk_insert_cloned_request() call into a
blk_execute_rq_nowait() call. That should work fine since this function
bypasses the I/O scheduler for passthrough requests:

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 66b19500844e..9e16d1321b34 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -547,8 +547,7 @@ static int ufshpb_execute_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
  				 read_id);
  	rq->cmd_len = scsi_command_size(rq->cmd);

-	if (blk_insert_cloned_request(q, req) != BLK_STS_OK)
-		return -EAGAIN;
+	blk_execute_rq_nowait(req->rq_disk, req, true, req->end_io);

  	hpb->stats.pre_req_cnt++;

Thanks,

Bart.
