Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12931CA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E94EE20869
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbfKDRmF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:42:05 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39256 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728188AbfKDRmE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:42:04 -0500
Received: by mail-pg1-f196.google.com with SMTP id 29so467748pgm.6
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:42:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O+8kdaG9JnmWrot5ymhkUEGNgr8xxyrG4UokRBJev8g=;
        b=SZN3uYZgKgG1w1Wwpszc6OC37AWW4NDieyUOVtd4pOpUgiFDFdZTmiR3kMu9x8ERCg
         Qb8gSsFcuEHMeWAZYR1+Nlzw72gdSg4jdJLzdyyjPZwVWTNpc/Lg9a73Q0u9aHLM6+v7
         wLhlry/7Rq2zNPL1s5nMEf+nyldmmt0RBpMkajSDtALqv9QMRBDzh9v9nt0+8gYCSBHx
         OtjUxASUVnCHLU15OLVq7fVs8tjSkXpY9Y7s+x8tQENN+JT750BQmpliKm2b2V2T1fMw
         ILa34b0TysJa87+jOG5HbCfPRC2H1wqA1rM0Y5QX4rqVcdq4mZy8cn914ElPHjO2eZ+h
         kwag==
X-Gm-Message-State: APjAAAV65uCwNPG6sWBYndg41a1dDTRUWzCr/29INdWgsMWhhJ6HEPgK
        xgMh/YtUvHOdlrT+k3wcqezL/Eg8
X-Google-Smtp-Source: APXvYqx+uEfTQEe+A827ONGt5H/caCUnbf1sS2i2xH72mNxSrMvPjQYZsWpgqDM+nJqWEVJkeqMvYQ==
X-Received: by 2002:a17:90a:b308:: with SMTP id d8mr386909pjr.23.1572889323321;
        Mon, 04 Nov 2019 09:42:03 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id e3sm15440045pjs.15.2019.11.04.09.42.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:42:02 -0800 (PST)
Subject: Re: [PATCH 14/52] nsp_cs: use standard SAM status codes
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-15-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5f094d16-6332-b2ee-9161-67ba381dce86@acm.org>
Date:   Mon, 4 Nov 2019 09:42:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-15-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/19 1:01 AM, Hannes Reinecke wrote:
> Use standard SAM status codes and omit the explicit shift to convert
> from linux-specific ones.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/pcmcia/nsp_cs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
> index 97416e1dcc5b..8e905fb94fd3 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.c
> +++ b/drivers/scsi/pcmcia/nsp_cs.c
> @@ -223,7 +223,7 @@ static int nsp_queuecommand_lck(struct scsi_cmnd *SCpnt,
>   
>   	data->CurrentSC		= SCpnt;
>   
> -	SCpnt->SCp.Status	= CHECK_CONDITION;
> +	SCpnt->SCp.Status	= SAM_STAT_CHECK_CONDITION;
>   	SCpnt->SCp.Message	= 0;
>   	SCpnt->SCp.have_data_in = IO_UNKNOWN;
>   	SCpnt->SCp.sent_command = 0;

It seems like there is a mismatch between the patch description and the 
patch. The patch description refers to omitting an explicit shift but I 
don't see that omission in the patch itself?

Bart.
