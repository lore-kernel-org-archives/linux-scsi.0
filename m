Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1AC0C47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 15:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBEA661354
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 15:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhFHPrg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 11:47:36 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:44796 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhFHPrf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 11:47:35 -0400
Received: by mail-pg1-f178.google.com with SMTP id y11so8687090pgp.11;
        Tue, 08 Jun 2021 08:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JHZwDARupnegF66MqNSD5mTlBjtWNzsos8IudcIJO3U=;
        b=FuHtyNGIrxso5CW+MyvIeKPlWcgg9WN3lHFsM6GxqLV/GrujjYjWg+efcwHayQxJRk
         oVYwRw+dSh0Oj0lvaWSGkDYaBmvjUh2CFemvSvWjT/TfZRXPYe4C6b9M3BfRdYVUy9Xf
         dUqPJXXRGA8KHFmbswbpWGPvK8uzAqSBAtwNJuQrBdS+xhE5K453gBbPL+UK3IzWlmPv
         AQEoHCol6xGaI93fLDGnF+6Hwc1xMA4z+hYmtx0U0qxR8ucqjK9xKc3DzX7OWa0B4Z0b
         WrEQHArZX1zrohL7Si4PXUf4hxJn6I6EjFlViFIig21rzRtzL8m7jc1yeENhQW5WgyhE
         B7qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JHZwDARupnegF66MqNSD5mTlBjtWNzsos8IudcIJO3U=;
        b=IAp9qnDiwumUqjMUJGEkbYQY5e3LT6X4OiBBsIsCTmZAuPAvjYosOY37HulDOrrPVq
         Ov9i6ALi15F7t5YV03v8ZHv530yuC9O+CRHOMBkwXylO4WGlOf1pao6P2Mmj0INFUlMv
         rvGOOsWPfNfy2Juzz3UtQQLzwVtrVVdEkVjvWbL8xvt37KiwJKil2PzU2ZOrMMlYcN6g
         bg/fQZcCU5CtjKPM7cjUKzbE5rusIDbCFK6Y1h0YxU8AV7Lr225zLo5DYe1RJyTe/hfq
         KeU8T/ljdx6iJRnGOjSvd/g3QLjiWNT3cUE+4PQrm2nakoKAty3vR2/t43Lpq7XHt0Yp
         W4pQ==
X-Gm-Message-State: AOAM530v2YiHADBbaDONyXrU/nkYX/jDavgFdcD+G7ntTmlge7kFKGbL
        VYfBzDfeFgD89X4/RqXBYk2njLY7HD0=
X-Google-Smtp-Source: ABdhPJzg5xyLuwTU05fGoj/G5IuPX4VrrVhaZsCfGF+Q0MFxRo21HPj4/M4kq4PJSpy67vsEPGEO0g==
X-Received: by 2002:a05:6a00:82:b029:2e9:c6db:e16d with SMTP id c2-20020a056a000082b02902e9c6dbe16dmr333804pfj.78.1623167067985;
        Tue, 08 Jun 2021 08:44:27 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l8sm11880362pgq.49.2021.06.08.08.44.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 08:44:27 -0700 (PDT)
Subject: Re: [PATCH -next] scsi: lpfc: Use list_move_tail instead of
 list_del/list_add_tail
To:     Zou Wei <zou_wei@huawei.com>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1623113493-49384-1-git-send-email-zou_wei@huawei.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <a6cbc5eb-212c-0701-3e25-93bd8486ee30@gmail.com>
Date:   Tue, 8 Jun 2021 08:44:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1623113493-49384-1-git-send-email-zou_wei@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/7/2021 5:51 PM, Zou Wei wrote:
> Using list_move_tail() instead of list_del() + list_add_tail().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>
> ---
>   drivers/scsi/lpfc/lpfc_sli.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index e2cfb86..84a9101 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -20162,8 +20162,7 @@ lpfc_cleanup_pending_mbox(struct lpfc_vport *vport)
>   			(mb->u.mb.mbxCommand != MBX_REG_VPI))
>   			continue;
>   
> -		list_del(&mb->list);
> -		list_add_tail(&mb->list, &mbox_cmd_list);
> +		list_move_tail(&mb->list, &mbox_cmd_list);
>   	}
>   	/* Clean up active mailbox command with the vport */
>   	mb = phba->sli.mbox_active;
> 

Thanks

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james
