Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D964BCA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 16:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6BAA20656
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 16:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfKAQ0R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 12:26:17 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38991 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfKAQ0R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 12:26:17 -0400
Received: by mail-pl1-f196.google.com with SMTP id t12so4592883plo.6
        for <linux-scsi@vger.kernel.org>; Fri, 01 Nov 2019 09:26:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LY2EeCRcTk6FPTNVwZGokz1UAs87tWsRveTPIz9Kla0=;
        b=cbH6TcyZmNgn5h0ajjzzRSIlvo7TfzibQPPF92QZ6jwAv90+KvAGDBHs/D3SlZye8b
         Ul/NN1VirT0/dOBsd2slhFCsct0TgWeyuf1mQfxLthrQ/fIwr98WmpD/6s45uRYXO7wx
         JGesv2t4H+b1dQTpy9nI6opIaRmmSSp6MfILqa2eRR+OUNTkhxmUgQx126okEwiMJ3q2
         N+6M0kIbGnK6DXGWXsgV17NiLYkaGElHFQiy3/GpPTAdBaJAeobdY02l+ZR8LVPwKG3f
         Auf+jiWVkGNNh72uhx6Yspa10vYyposV92hU4OzWQkHNeR/ZvobAcyyxWLhAzSkx3Jkx
         ldFg==
X-Gm-Message-State: APjAAAWyycyZFJS8w/JNX8eq4OkUZvK2BPUxgmnzHNyr+P19Wqw9yzJY
        yq6lwjMw+/I6Pef7FsgYp2WG1JbAg2k=
X-Google-Smtp-Source: APXvYqxjq7W2ED09C4lg5GLXYCUFoNnpcyGR9q92ay2gIrQRBlxVvtReU2y6SulPI02/hn1gFAWGuQ==
X-Received: by 2002:a17:902:8494:: with SMTP id c20mr13311172plo.137.1572625576016;
        Fri, 01 Nov 2019 09:26:16 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id g7sm7576393pgr.52.2019.11.01.09.26.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2019 09:26:14 -0700 (PDT)
Subject: Re: [PATCH 05/24] scsi: use standard SAM status codes
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191031110452.73463-1-hare@suse.de>
 <20191031110452.73463-6-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8c3245df-97e3-95aa-498f-4ed47db96132@acm.org>
Date:   Fri, 1 Nov 2019 09:26:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191031110452.73463-6-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/31/19 4:04 AM, Hannes Reinecke wrote:
> Use standard SAM status codes and omit the explicit shift to convert
> to linux-specific ones.

Isn't an explicit shift required to convert *from* linux-specific codes 
instead of for converting *to* linux-specific ones?

>   drivers/ata/libata-scsi.c             |  2 +-
>   drivers/infiniband/ulp/srp/ib_srp.c   |  2 +-
>   drivers/scsi/3w-9xxx.c                |  5 +++--
>   drivers/scsi/3w-sas.c                 |  3 ++-
>   drivers/scsi/3w-xxxx.c                |  4 ++--
>   drivers/scsi/arcmsr/arcmsr_hba.c      |  4 ++--
>   drivers/scsi/bfa/bfad_im.c            |  2 +-
>   drivers/scsi/dc395x.c                 | 18 +++++-------------
>   drivers/scsi/dpt_i2o.c                |  2 +-
>   drivers/scsi/gdth.c                   | 12 ++++++------
>   drivers/scsi/megaraid.c               | 10 +++++-----
>   drivers/scsi/megaraid/megaraid_mbox.c | 12 ++++++------
>   drivers/scsi/pcmcia/nsp_cs.c          |  2 +-
>   13 files changed, 36 insertions(+), 42 deletions(-)

Should this patch be split into one patch per driver such? If this patch 
would introduce a regression that will make it easier to address such 
regressions. Splitting this patch will also make reviewing easier.

> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index 3337b1e80412..ada77c136f8b 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -1018,7 +1018,8 @@ static int twa_fill_sense(TW_Device_Extension *tw_dev, int request_id, int copy_
>   
>   	if (copy_sense) {
>   		memcpy(tw_dev->srb[request_id]->sense_buffer, full_command_packet->header.sense_data, TW_SENSE_DATA_LENGTH);
> -		tw_dev->srb[request_id]->result = (full_command_packet->command.newcommand.status << 1);
> +		tw_dev->srb[request_id]->result =
> +			full_command_packet->command.newcommand.status;
>   		retval = TW_ISR_DONT_RESULT;
>   		goto out;
>   	}

Does this change preserve the behavior of this LLD?

> diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
> index dda6fa857709..d11f62c60877 100644
> --- a/drivers/scsi/3w-sas.c
> +++ b/drivers/scsi/3w-sas.c
> @@ -891,7 +891,8 @@ static int twl_fill_sense(TW_Device_Extension *tw_dev, int i, int request_id, in
>   
>   	if (copy_sense) {
>   		memcpy(tw_dev->srb[request_id]->sense_buffer, header->sense_data, TW_SENSE_DATA_LENGTH);
> -		tw_dev->srb[request_id]->result = (full_command_packet->command.newcommand.status << 1);
> +		tw_dev->srb[request_id]->result =
> +			full_command_packet->command.newcommand.status;
>   		goto out;
>   	}

Same question here.

> diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
> index 6b5841b1c06e..e3cbe5d20aca 100644
> --- a/drivers/scsi/bfa/bfad_im.c
> +++ b/drivers/scsi/bfa/bfad_im.c
> @@ -150,7 +150,7 @@ bfa_cb_tskim_done(void *bfad, struct bfad_tskim_s *dtsk,
>   	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dtsk;
>   	wait_queue_head_t *wq;
>   
> -	cmnd->SCp.Status |= tsk_status << 1;
> +	cmnd->SCp.Status |= tsk_status;
>   	set_bit(IO_DONE_BIT, (unsigned long *)&cmnd->SCp.Status);
>   	wq = (wait_queue_head_t *) cmnd->SCp.ptr;
>   	cmnd->SCp.ptr = NULL;

Same question here.

Thanks,

Bart.
