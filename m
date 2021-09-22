Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E58DCC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 20:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF82F6112F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 20:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237684AbhIVUth (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 16:49:37 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:37818 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237592AbhIVUtg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Sep 2021 16:49:36 -0400
Received: by mail-pj1-f41.google.com with SMTP id me5-20020a17090b17c500b0019af76b7bb4so5399568pjb.2
        for <linux-scsi@vger.kernel.org>; Wed, 22 Sep 2021 13:48:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3AFQqXZmo4K+7iWw+BjmjwCMVEBuW2c+N//wcEqcQOA=;
        b=pumEp/EgcJa+qBC2yo01Sd0onMwLxTSQZXuVvgECBoy7BbML+VHBOpEnZHFvO29hG6
         SWjX0ug7tqOUrnng/gbDGP6AXWosWUqMsd8kUyD4ZjNw6U1DSwGEWtoENqG20YLTUEGo
         a61bF1O+5ZUGIK4ruSy8g/l4lyGMAymfLEZSDDoIAAzC1jSlQ2flJSPsVlt9BLu/FN+j
         NrlI26U/Z42b89kTHYjksbMBjLMHQSKgD+qSarjmdhAX/vs9FoklTfk4G6wqbxpIP83o
         /nNofqcXse2VRmFNWV95eLghNyqMq9qXsudAAT6Wz8eFcDdkdkt2UALsqsQtt1MQD0pm
         WZzQ==
X-Gm-Message-State: AOAM532igN/0U1K8noEbYPio44BHbiHDCgkhq8yHDEtZcHB7fMLPzm2F
        NX6Ki0f4EpQAelgniGXldQqovtwEGkQ=
X-Google-Smtp-Source: ABdhPJy6tnpnpkINl+teTV4KHuxO7+fUlmZK+YUg7WEhiJS4zeYI2/3ytTrYRrxPWUr4d+ShakK/Iw==
X-Received: by 2002:a17:90a:cb8e:: with SMTP id a14mr13558594pju.227.1632343685151;
        Wed, 22 Sep 2021 13:48:05 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f3b9:da7d:f0c0:c71c])
        by smtp.gmail.com with ESMTPSA id e7sm3274974pfc.114.2021.09.22.13.48.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 13:48:04 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: Fix task management completion
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org
References: <20210922091059.4040-1-adrian.hunter@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <88b64fec-4034-3e0d-d15e-46dcfaad5863@acm.org>
Date:   Wed, 22 Sep 2021 13:48:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210922091059.4040-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/21 2:10 AM, Adrian Hunter wrote:
> The UFS driver uses blk_mq_tagset_busy_iter() when identifying task
> management requests to complete, however blk_mq_tagset_busy_iter()
> doesn't work.
> 
> blk_mq_tagset_busy_iter() only iterates requests dispatched by the block
> layer. That appears as if it might have started since commit 37f4a24c2469a1
> ("blk-mq: centralise related handling into blk_mq_get_driver_tag") which
> removed 'data->hctx->tags->rqs[rq->tag] = rq' from blk_mq_rq_ctx_init()
> which gets called:
> 
> 	blk_get_request
> 		blk_mq_alloc_request
> 			__blk_mq_alloc_request
> 				blk_mq_rq_ctx_init
> 
> Since UFS task management requests are not dispatched by the block
> layer, hctx->tags->rqs[rq->tag] remains NULL,  and since
> blk_mq_tagset_busy_iter() relies on finding requests using
> hctx->tags->rqs[rq->tag], UFS task management requests are never found by
> blk_mq_tagset_busy_iter().
> 
> By using blk_mq_tagset_busy_iter(), the UFS driver was relying on internal
> details of the block layer, which was fragile and subsequently got
> broken. Fix by removing the use of blk_mq_tagset_busy_iter() and having
> the driver keep track of task management requests.

Thanks for the detailed analysis. I agree that using blk_mq_tagset_busy_iter()
no longer works due to recent changes in the block layer. Has it been
considered to export blk_mq_all_tag_iter() and to use that function instead of
blk_mq_tagset_busy_iter()?

Thanks,

Bart.


