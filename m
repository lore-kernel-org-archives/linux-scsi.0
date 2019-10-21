Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E48CA9EB7
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82BFF20659
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbfJUQmC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:42:02 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41343 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729634AbfJUQmC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Oct 2019 12:42:02 -0400
Received: by mail-pl1-f196.google.com with SMTP id t10so6875886plr.8
        for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2019 09:42:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=go90kMB0c4Nm9l+G2Q+adYFw1Aioz++w/eIWcYML/HY=;
        b=to+vXcpN7c20xnAzPAzRbw05jeDkCPdEI80iascKP/5PzmXD7E64dFzY1tUyY/NcIL
         AsKRFVNXIrdaUj9IzG2M3n44FwNsqyMGjuuR3jax3rwwbkFjkKiHeJONe571OyHtNLtt
         6KWBGVaUP6/PZzWhRe6htmEld8vhrdnXXq0GUOqUtGjy+XLvdb4VJ2wmmEwy/nu71+9X
         nudz7PG0w9KIQMudUc1g0mCpJcoAqIkTpIKvYQ/hADwrGC/hubTiTIuBdJcBTH8sfg0D
         CvdBDW6RdVplG/AEhoE/5zUSECTyscgMgZZh9hf15zmJTd/UKg8lPtWS0MRunaD8et5W
         O0tQ==
X-Gm-Message-State: APjAAAUyHa3R96VW7IyM5puZR3J6EgFTnmjEReQVs5vNiT6aVItOIHCQ
        IxErfikRcATSVFDHFgVEd9T4mpGE+0k=
X-Google-Smtp-Source: APXvYqwaNNW2MM4LZxYFWZ3mPO1jtoEdIoyKqiG6uWCSZO68pjXVSKKT4v36GJ0RjatyDEgLIgyJDQ==
X-Received: by 2002:a17:902:6acb:: with SMTP id i11mr26563465plt.16.1571676120660;
        Mon, 21 Oct 2019 09:42:00 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id q26sm14097030pgk.60.2019.10.21.09.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 09:41:59 -0700 (PDT)
Subject: Re: [PATCH 18/24] st: return error code in st_scsi_execute()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
References: <20191021095322.137969-1-hare@suse.de>
 <20191021095322.137969-19-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <3a5ac65a-b765-df88-0613-455f3d4cab46@acm.org>
Date:   Mon, 21 Oct 2019 09:41:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191021095322.137969-19-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/21/19 2:53 AM, Hannes Reinecke wrote:
> We should return the actual error code in st_scsi_execute(),
> avoiding the need to use DRIVER_ERROR.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/st.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index e3266a64a477..5f38369cc62f 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -549,7 +549,7 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
>   			data_direction == DMA_TO_DEVICE ?
>   			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, 0);
>   	if (IS_ERR(req))
> -		return DRIVER_ERROR << 24;
> +		return PTR_ERR(req);
>   	rq = scsi_req(req);
>   	req->rq_flags |= RQF_QUIET;
>   
> @@ -560,7 +560,7 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
>   				      GFP_KERNEL);
>   		if (err) {
>   			blk_put_request(req);
> -			return DRIVER_ERROR << 24;
> +			return err;
>   		}
>   	}

The patch description looks confusing to me. Is it perhaps because the 
caller compares the st_scsi_execute() return value with zero and doesn't 
use the return value in any other way that it is fine to return an 
integer error code instead of a SCSI status?

Thanks,

Bart.
