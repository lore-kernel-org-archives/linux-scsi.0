Return-Path: <SRS0=obCF=3E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FCFBC33CB1
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jan 2020 16:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E3AD214AF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jan 2020 16:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgAOQM2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jan 2020 11:12:28 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46576 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbgAOQM2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2020 11:12:28 -0500
Received: by mail-pl1-f194.google.com with SMTP id y8so7013373pll.13
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jan 2020 08:12:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=73DmHwdzUVmY7Q0zKrtBYlG/9zu3cjujPB8foWDOFsQ=;
        b=FDGdsott9eb4Brt7lG9jgk8jcYmnNJ2BD72ULecLLY5R3BKCqSPDfkNR6Iwr/ZC11d
         NyvpOTaZ7jwzyAySGQYgeUKsvc4JQBpPgwAeXapEeITHyTKXKMBT8UnYLq2KCuNVi6fZ
         FFc0Xl48fhUvGTg7o8NQT1CszjQ+rKyy5PP1vz9pEGnHFU945fijh4WLwiON/W9e1pM/
         RNh7d/AM6eJuIkwsIuYF7HKybzYuVaR5bdEfq0VtbzlzQhh6QQNxNo2JzqtbwN9ShwTV
         CChPhc/nvW7DUp63YQGTIYA4lhfJXRaS0TlNN9D2BZMHBb2iGS4C9Qd7VID2hqPnsxSx
         RLgw==
X-Gm-Message-State: APjAAAWQgnDK/EDahuHkkvAeXUkHSspieK4a5RTnRVfnzZ3bkIuzDg+z
        uS8Pd1BuZxCPcdqC8x4or5PIE+ZW
X-Google-Smtp-Source: APXvYqyiQqNIkzDZXAGV465vNjhij1ewkCkrxZBmzqOHIYXTCGtHDQob2I5Q6XV0ZZmpejcKJ2mRUw==
X-Received: by 2002:a17:90a:cb96:: with SMTP id a22mr626288pju.96.1579104747469;
        Wed, 15 Jan 2020 08:12:27 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id e2sm22476379pfh.84.2020.01.15.08.12.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 08:12:26 -0800 (PST)
Subject: Re: [PATCH] qla2xxx: Fix unbound NVME response length
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
References: <20200115024431.5421-1-hmadhani@marvell.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <97b53726-b26f-9074-a41c-eff4a6ec8613@acm.org>
Date:   Wed, 15 Jan 2020 08:12:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200115024431.5421-1-hmadhani@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/14/20 6:44 PM, Himanshu Madhani wrote:
> From: Arun Easi <aeasi@marvell.com>
> 
> On certain cases when response length is less than 32, NVME response data
> is supplied inline in IOCB. This is indicated by some combination of state
> flags. There was an instance when a high, and incorrect, response length was
> indicated causing driver to overrun buffers. Fix this by checking and
> limiting the response payload length.
> 
> Fixes: 7401bc18d1ee3 ("scsi: qla2xxx: Add FC-NVMe command handling")
> Cc: stable@vger.kernel.com
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
> Hi Martin,
> 
> We discovered issue with our newer Gen7 adapter when response length
> happens to be larger than 32 bytes, could result into crash.
> 
> Please apply this to 5.5/scsi-fixes branch at your earliest convenience.
> 
> Thanks,
> Himanshu
> ---
>   drivers/scsi/qla2xxx/qla_isr.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index e7bad0bfffda..90e816d13b0e 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1939,6 +1939,15 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
>   		inbuf = (uint32_t *)&sts->nvme_ersp_data;
>   		outbuf = (uint32_t *)fd->rspaddr;
>   		iocb->u.nvme.rsp_pyld_len = le16_to_cpu(sts->nvme_rsp_pyld_len);
> +		if (unlikely(iocb->u.nvme.rsp_pyld_len > 32)) {
> +			WARN_ONCE(1, "Unexpected response payload length %u.\n",
> +					iocb->u.nvme.rsp_pyld_len);
> +			ql_log(ql_log_warn, fcport->vha, 0x5100,
> +				"Unexpected response payload length %u.\n",
> +				iocb->u.nvme.rsp_pyld_len);
> +			iocb->u.nvme.rsp_pyld_len = 32;
> +			logit = 1;
> +		}
>   		iter = iocb->u.nvme.rsp_pyld_len >> 2;
>   		for (; iter; iter--)
>   			*outbuf++ = swab32(*inbuf++);
> 

Please change the constant '32' into sizeof(...) or into a symbolic name.

Thanks,

Bart.
