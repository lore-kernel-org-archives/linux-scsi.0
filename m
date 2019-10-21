Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837EACA9EAF
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EAF720659
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbfJUQoo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:44:44 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39878 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbfJUQon (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Oct 2019 12:44:43 -0400
Received: by mail-pf1-f195.google.com with SMTP id v4so8765724pff.6
        for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2019 09:44:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QQ/ptNVg1pndlK/RZZts+DPBZ3JT1kpsy6yinL7extA=;
        b=VNBr3PEkRiqb9DLXURoBOVdbNo1cx3pD4pGeQ8rE2pzGc3ijGcKD2BmsVk5ImL0dfa
         66kBot814RTVJZ6N8h71o2j/aJSo8w+hYRjEpzdmLw04n7DxWFRHCYDGW/O/TGfbeosg
         4WFFRsaXFDR53hivkjxUqxPqswb5NQ3JHQkelFlx7oHZWDHcGf4qAlS4J2ieNIj9F/Qx
         Si80K59wxvnKKdqC3pIDy6ivcifv91RL0KtCyYbOiIH6f8yHp1lliYvlEgaPMN7+ApbP
         ol1ve1L+U596O+Q9hw8bCThvYhGP3mtoVIb2lLfWv8LS0OAF4LH0vous2S2WOqRNmteG
         kHpg==
X-Gm-Message-State: APjAAAX2HymU4HZbEtUa3ieaWS7D3bvopllYASN+2eCnQg2pqn5NuKu4
        JWdXggHtdy5RFsXeuwWStRedykGhFSU=
X-Google-Smtp-Source: APXvYqwIrd8Xrnzn5bV9XhcdP6DwBvqiYmEGAuXQYP1l+VlHOTxZ3w9tuzBm2zavILN82loq+Pqm0A==
X-Received: by 2002:a17:90a:989:: with SMTP id 9mr30375229pjo.101.1571676282233;
        Mon, 21 Oct 2019 09:44:42 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id h4sm14290354pgg.81.2019.10.21.09.44.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 09:44:41 -0700 (PDT)
Subject: Re: [PATCH 19/24] scsi_ioctl: return error code when blk_map_user()
 fails
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
References: <20191021095322.137969-1-hare@suse.de>
 <20191021095322.137969-20-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f636567d-9152-c05c-ccb8-7d4df806a2b7@acm.org>
Date:   Mon, 21 Oct 2019 09:44:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191021095322.137969-20-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/21/19 2:53 AM, Hannes Reinecke wrote:
> When failing to map the user buffer we should return the actual
> error code, avoiding the usage of DRIVER_ERROR.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   block/scsi_ioctl.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index f5e0ad65e86a..1ab1b8d9641c 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -485,9 +485,10 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
>   		break;
>   	}
>   
> -	if (bytes && blk_rq_map_kern(q, rq, buffer, bytes, GFP_NOIO)) {
> -		err = DRIVER_ERROR << 24;
> -		goto error;
> +	if (bytes) {
> +		err = blk_rq_map_kern(q, rq, buffer, bytes, GFP_NOIO);
> +		if (err)
> +			goto error;
>   	}
>   
>   	blk_execute_rq(q, disk, rq, 0);

Since sg_scsi_ioctl() is used to implement SCSI_IOCTL_SEND_COMMAND, does 
this patch change the ABI between user space and kernel in a 
backwards-incompatible way?

Thanks,

Bart.

