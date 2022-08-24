Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B179FC00140
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Aug 2022 14:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236375AbiHXORR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Aug 2022 10:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238549AbiHXORP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Aug 2022 10:17:15 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263F598D1A
        for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2022 07:17:13 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id g14so3251352qto.11
        for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2022 07:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=KA2z6xHLEUzqWKEiYYIXxKRsDzjJ9f+eW1XE7xhJXUs=;
        b=BjeKqnI0vFhJkKNV9wKOgE4ya2QES4SUJ4U/5gV5uUGKYYHkOQ1PTVxI3HNakfuPub
         om4lUSkthFkJurjMcyssQ23gDAlBWSgWcVlW07lyveC7ps+VBpsZBFjquY6RIlv2Qoia
         dZxtbpFPzTsvc+VSRlY6h7LwSHHCWnToj+tQ1v1NESfqRVCIHfzytlJ/EYhqhjqYibfQ
         7pQlJEiathhtMjCz2iYlZud4Ik8vNlUmezUnJVIWrv+IN4AvnmX2rSIJAv0spDTcN5/C
         3BKee/Qg9hIaGcUtWBU4R+PPJnu/QLS9G23q1uhtRmUCZ21m5ehCBcI+bBIvC7D3mjPN
         E30A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=KA2z6xHLEUzqWKEiYYIXxKRsDzjJ9f+eW1XE7xhJXUs=;
        b=zPuRgD9KTzf0+UFdw+I5JxMSNPnRkHInvR0fDgzuH/CI0U623ftClHvFH2RV3359/j
         H1/zNAx3yMvZKOFMFYnOxGcoZEq/TDEggjR4suK79yn1lVerjXmU7DmvZ93rHmTbmwFo
         5syh816JT5gv1BMd1WG5M5G2UCm/KSN95q9v8ThvKrSJtVErXR08gWZmoTqxstTqlZ2w
         T+gjAbKin/zKt0AzkDM/fg1Wfk61SnNhPPpiCT9qWsUfsRWQoLwOrMZLW89k5KZ3q/cy
         pcvErkmxw0ZD4GDUfJ9ImSANXLiWMqp9DPWjYHSBqbkWolwWM/PsAgAXMrjPGOb9R+tN
         aLWw==
X-Gm-Message-State: ACgBeo0D/D/VvEhe02fkcKYs7Krz/ioI6ArKVk2T6CY9HiLdFCUj6P2/
        294qZdLKi3Wa30owb/6se04=
X-Google-Smtp-Source: AA6agR4FAqP1qOkyojtMs6sOYTTd5Uj41a3kty1afbMryNax00bhwWkqVImWlgv2qQSS3fuEiQw0GQ==
X-Received: by 2002:ac8:4e45:0:b0:343:5faf:3af6 with SMTP id e5-20020ac84e45000000b003435faf3af6mr24338015qtw.340.1661350632033;
        Wed, 24 Aug 2022 07:17:12 -0700 (PDT)
Received: from [192.168.50.208] (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id bl18-20020a05620a1a9200b006b8e63dfffbsm13575300qkb.58.2022.08.24.07.17.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 07:17:11 -0700 (PDT)
Message-ID: <1da6ddaa-8f93-9493-1e55-5fb2fc7a6bca@gmail.com>
Date:   Wed, 24 Aug 2022 07:17:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH] lpfc: Return DID_TRANSPORT_DISRUPTED instead of
 DID_REQUEUE
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20220824060033.138661-1-hare@suse.de>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <20220824060033.138661-1-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/23/2022 11:00 PM, Hannes Reinecke wrote:
> When the driver hits on an internal error condition returning
> DID_REQUEUE will cause I/O to be retried on the same ITL nexus.
> This will inhibit multipathing, resulting in endless retries
> even if the error could have been resolved by using a different
> ITL nexus.
> So return DID_TRANSPORT_DISRUPTED to allow for multipath to engage
> and route I/O to another ITL nexus.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 084c0f9fdc3a..938a5e435943 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -4272,7 +4272,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
>   		    lpfc_cmd->result == IOERR_ABORT_REQUESTED ||
>   		    lpfc_cmd->result == IOERR_RPI_SUSPENDED ||
>   		    lpfc_cmd->result == IOERR_SLER_CMD_RCV_FAILURE) {
> -			cmd->result = DID_REQUEUE << 16;
> +			cmd->result = DID_TRANSPORT_DISRUPTED << 16;
>   			break;
>   		}
>   		if ((lpfc_cmd->result == IOERR_RX_DMA_FAILED ||
> @@ -4562,7 +4562,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
>   			    lpfc_cmd->result == IOERR_NO_RESOURCES ||
>   			    lpfc_cmd->result == IOERR_ABORT_REQUESTED ||
>   			    lpfc_cmd->result == IOERR_SLER_CMD_RCV_FAILURE) {
> -				cmd->result = DID_REQUEUE << 16;
> +				cmd->result = DID_TRANSPORT_DISRUPTED << 16;
>   				break;
>   			}
>   			if ((lpfc_cmd->result == IOERR_RX_DMA_FAILED ||


We need to be careful about the conditions. But I think you handled it well.

Thanks

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james

