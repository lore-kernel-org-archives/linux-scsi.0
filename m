Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC29C4708F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 16:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC06B61405
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 16:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhFDQNA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 12:13:00 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:33669 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbhFDQM7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 12:12:59 -0400
Received: by mail-pj1-f44.google.com with SMTP id k22-20020a17090aef16b0290163512accedso5393451pjz.0;
        Fri, 04 Jun 2021 09:11:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w2ysyGxGgmyHl3kc4LuUtneRW6FPU4AZDsaSZQi6jlQ=;
        b=QPZwQXLYK0k2/yHIicZPCqTWo8LulDmtH4ND7pn11Ztjg/5O9NPRuvhHQzL9+yGAYB
         7vzyPe82csubxLiq/L9vgxC8s9vfwHzmvUbimMjobnjL+8MrmQRi0HghzkOwpLE9oSfN
         f4FXY8X7tlAIL/E7fgs33OiDwfPkajDrsHELOy/RpiEor4DradsoT12zqVe54vqex35e
         5n/vraVIJAp4j+dOAP5lyGxBlcyBObyeQ3t1ayQ9H8rcykdoHmO9s4B2r2MbE+uEX64x
         +/YrGE1SGXcHt0i1UORGxfIRw3Nyaaxwt4l94XXe1fNERxLJKhKHQzZ/iq7zNOWBoyQs
         Xx6A==
X-Gm-Message-State: AOAM532xXwOpjfU5ZjZ/SpMGxdZ5iSvI4FSrN/Zix3+H6wUvPswFWV2n
        kMb3C/NL4xyqLAMyTfnOjDE=
X-Google-Smtp-Source: ABdhPJxQjJqbe6fhOk/03WVDmjed3rm0PWwcWk5xSlDJmHpKF3/+iJR/96cZko0Jmr6DZBGKJVYxIA==
X-Received: by 2002:a17:90a:a10a:: with SMTP id s10mr5577907pjp.59.1622823072698;
        Fri, 04 Jun 2021 09:11:12 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id c11sm5009246pjr.32.2021.06.04.09.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 09:11:11 -0700 (PDT)
Subject: Re: [PATCH v12 3/3] ufs: set max_bio_bytes with queue max sectors
To:     Changheun Lee <nanich.lee@samsung.com>, Johannes.Thumshirn@wdc.com,
        alex_y_xu@yahoo.ca, asml.silence@gmail.com, axboe@kernel.dk,
        bgoncalv@redhat.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, cang@codeaurora.org,
        avri.altman@wdc.com, alim.akhtar@samsung.com,
        damien.lemoal@wdc.com, gregkh@linuxfoundation.org,
        hch@infradead.org, jaegeuk@kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ming.lei@redhat.com, osandov@fb.com, patchwork-bot@kernel.org,
        tj@kernel.org, tom.leiming@gmail.com, yi.zhang@redhat.com
Cc:     jisoo2146.oh@samsung.com, junho89.kim@samsung.com,
        mj0123.lee@samsung.com, seunghwan.hyun@samsung.com,
        sookwan7.kim@samsung.com, woosung2.lee@samsung.com,
        yt0928.kim@samsung.com
References: <20210604050324.28670-1-nanich.lee@samsung.com>
 <CGME20210604052201epcas1p41a27660b20d70b7fc4295c8f131d33ce@epcas1p4.samsung.com>
 <20210604050324.28670-4-nanich.lee@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <004bef40-1667-3b60-adaf-bea2b15f2514@acm.org>
Date:   Fri, 4 Jun 2021 09:11:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210604050324.28670-4-nanich.lee@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/3/21 10:03 PM, Changheun Lee wrote:
> Set max_bio_bytes same with queue max sectors. It will lead to fast bio
> submit when bio size is over than queue max sectors. And it might be helpful
> to align submit bio size in some case.
> 
> Signed-off-by: Changheun Lee <nanich.lee@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 3eb54937f1d8..37365a726517 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4858,6 +4858,7 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
>  {
>  	struct ufs_hba *hba = shost_priv(sdev->host);
>  	struct request_queue *q = sdev->request_queue;
> +	unsigned int max_bio_bytes;
>  
>  	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
>  	if (hba->quirks & UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE)
> @@ -4868,6 +4869,10 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
>  
>  	ufshcd_crypto_setup_rq_keyslot_manager(hba, q);
>  
> +	if (!check_shl_overflow(queue_max_sectors(q),
> +				SECTOR_SHIFT, &max_bio_bytes))
> +		blk_queue_max_bio_bytes(q, max_bio_bytes);
> +
>  	return 0;
>  }

Just like previous versions of this patch series, this approach will
trigger data corruption if dm-crypt is stacked on top of the UFS driver
since ufs_max_sectors << SECTOR_SHIFT = 1024 * 512 is less than the size
of the dm-crypt buffer (BIO_MAX_VECS << PAGE_SHIFT = 256 * 4096).

I am not recommending to increase max_sectors for the UFS driver. We
need a solution that is independent of the dm-crypt internals.

Bart.

