Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA52C4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Aug 2021 03:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90A3660F51
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Aug 2021 03:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236695AbhHNDSQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Aug 2021 23:18:16 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:34383 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236466AbhHNDSP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Aug 2021 23:18:15 -0400
Received: by mail-pj1-f52.google.com with SMTP id gz13-20020a17090b0ecdb0290178c0e0ce8bso13634027pjb.1;
        Fri, 13 Aug 2021 20:17:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zq4l0+Pr/f31cKMp4VFkf9/Ag5nmI+uhXvgd4QMPJwM=;
        b=Z1vCLMdVOQg+IXFSLwA5qery3o9MzeYfLBacq3Sv2xZP+00WI402P6+kpq/Ytbf3fp
         WREv4bLNyaEhP4Xjpm2gJyfUriaxUFtL0r3A2WAr8VkXuGd2V3ofnv/WDh6e6DNDXxP7
         1/NQ42so5HFpJHJYHwdwDQ4+6Jg6haqAyChaIaqTCBOAGwfiWmS31oYA/kHKLXm/V885
         5TpS2GVGIbtnQiMzCcYbuyQlrvlxu3teoUx2YIyUPdHozsH/jwI9ZflKwugh7ZSAT7aH
         jxmtqdX90oz+AWq6yO+EBPqNN8Aq/LYEvifgIyz7/iB/lPcf6NCicLHYSHxLrQKggyt4
         bu/w==
X-Gm-Message-State: AOAM530fX0YUk8ZwXncWLQr57SVrkHUv8VWo8NfbBNgWfLkVweONMyMH
        GFBcDlakISphKwA1QBET1IY=
X-Google-Smtp-Source: ABdhPJy038U4F49ZXeNOKwyqtaRvWuFwCZACQJLv+Tqb7Ly2PTzE+8eD8ntKOtI9+SFs662RFmj/9Q==
X-Received: by 2002:a17:90a:a016:: with SMTP id q22mr5724600pjp.34.1628911067714;
        Fri, 13 Aug 2021 20:17:47 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:55d6:7aa0:a6ad:d964? ([2601:647:4000:d7:55d6:7aa0:a6ad:d964])
        by smtp.gmail.com with ESMTPSA id nr6sm3010060pjb.39.2021.08.13.20.17.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 20:17:46 -0700 (PDT)
Subject: Re: [PATCH 2/3] scsi: fnic: Stop setting scsi_cmnd.tag
To:     John Garry <john.garry@huawei.com>, satishkh@cisco.com,
        sebaddel@cisco.com, kartilak@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.de, hch@lst.de
References: <1628862553-179450-1-git-send-email-john.garry@huawei.com>
 <1628862553-179450-3-git-send-email-john.garry@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <3e5d1bd4-cee9-7fd0-93a4-58d808e198f6@acm.org>
Date:   Fri, 13 Aug 2021 20:17:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1628862553-179450-3-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/13/21 6:49 AM, John Garry wrote:
> It is never read. Setting it and the request tag seems dodgy
> anyway.

This is done because there is code in the SCSI error handler that may
allocate a SCSI command without allocating a tag. See also
scsi_ioctl_reset().

> ---
>  drivers/scsi/fnic/fnic_scsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index 0f9cedf78872..f8afbfb468dc 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -2213,7 +2213,7 @@ fnic_scsi_host_start_tag(struct fnic *fnic, struct scsi_cmnd *sc)
>  	if (IS_ERR(dummy))
>  		return SCSI_NO_TAG;
>  
> -	sc->tag = rq->tag = dummy->tag;
> +	rq->tag = dummy->tag;
>  	sc->host_scribble = (unsigned char *)dummy;

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
