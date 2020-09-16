Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0844C43461
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 22:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60CE22078D
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 22:43:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YxqXjBno"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgIPWm6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Sep 2020 18:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgIPWm5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2020 18:42:57 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D01C061355
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2020 14:23:37 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id fa1so125757pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2020 14:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ZBFu0UNBFa9CnSNOLqO1iaGjWYwIYQRdqIYLh7xURtg=;
        b=YxqXjBno5a0CYkuByH0VQaisk9EX+TazgeTo7cbB7ZpVO6ATR34iTZsv9rRt+pd9TV
         M3qPyYTTQDZjm/KJfRNQYMF+yMg0hMAv0jziSp2G8t2S4ear/R7CawlfWwPUrB/7bz23
         KF0tp7If+eJZ2Vi3QmvGONtcOBY2swqex1HsY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZBFu0UNBFa9CnSNOLqO1iaGjWYwIYQRdqIYLh7xURtg=;
        b=Vf72ihD8Junu9hS0UEkhGcoi+RFuH1UmFaUgKvgt54CIKvXGmnvvoolQfV9M/5LVdq
         acgvhw16V7W9aPYs/EI8Nszpd3wYjOLePR5J6SALXlGhV1skDT879/1EATTzOvMhjPv0
         x5CiZ4EL8W1GyJcPOAsUYdV9scrSaxCeF4kTz2GEUTxnMhm9riTa8sHhX4tZUgpJ89ef
         FxMt4ASRt2UGYIW0r4Me1/8OJYkLdd3CF82Z3MBAOaAstnZCES+upKhswH68smgJiIjd
         gWgjnAQcCDsxxxUaSG+F0l11irx5IDJFn+3fcESXvq30IZKgwsEV30bZalJ5kSWsRvRl
         PCtw==
X-Gm-Message-State: AOAM531zaRoL/TLa53Z+9xG3ok22sWEjj8ClRtV+ysYHeVwXQ7J2oQch
        un1/KbNQK9SDBQCh0HJqWOe8RcvtTmx3wvf7VHonvRH2Csyn4JTUITVOUsu4bLG3PVvHR7ZLudx
        cTQcVhzSyiSQka1NBrUn+/ooaGu5yePvogyS4A+EmBaGkYWEkBPPUSvAKQ7ZgZoWR31pXAcgrZN
        cg/XVu4g==
X-Google-Smtp-Source: ABdhPJz/LvQS9+vHo067qYVXQK6faOThlwZjJzxQ5+/b2+abtQvnbzd9Rz02MLpaD6OcHHGNKtvD8Q==
X-Received: by 2002:a17:90b:d86:: with SMTP id bg6mr5592065pjb.155.1600291415669;
        Wed, 16 Sep 2020 14:23:35 -0700 (PDT)
Received: from [10.69.69.102] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w10sm8764602pgr.27.2020.09.16.14.23.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2020 14:23:34 -0700 (PDT)
Subject: Re: [PATCH] lpfc: use NVMe error codes for LS request done callback
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200916085059.27206-1-hare@suse.de>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <97c2e517-6b7b-70f5-f8da-14145f00361c@broadcom.com>
Date:   Wed, 16 Sep 2020 14:23:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200916085059.27206-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 9/16/2020 1:50 AM, Hannes Reinecke wrote:
> The LS request callback requires a 'status' argument, but that one
> should be an NVMe error code, not a driver specific one which has
> no meaning in the nvme layer.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/lpfc/lpfc_nvme.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
> index e5be334d6a11..4b007a28014b 100644
> --- a/drivers/scsi/lpfc/lpfc_nvme.c
> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
> @@ -498,7 +498,9 @@ __lpfc_nvme_ls_req_cmp(struct lpfc_hba *phba,  struct lpfc_vport *vport,
>   		cmdwqe->context3 = NULL;
>   	}
>   	if (pnvme_lsreq->done)
> -		pnvme_lsreq->done(pnvme_lsreq, status);
> +		pnvme_lsreq->done(pnvme_lsreq,
> +				  status == IOSTAT_SUCCESS ?
> +				  NVME_SC_SUCCESS : NVME_SC_INTERNAL);
>   	else
>   		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
>   				 "6046 NVMEx cmpl without done call back? "

No - it's not a nvme command, so doesn't need a nvme status code. It 
should be a -Exxx  value or a 0 (success).  nvme_fc_send_ls_req() for 
example calls __nvme_fc_send_ls_req(), which can return any number of 
-Exxx values, and the routine returns the value returned by the done 
call after waiting for it to complete - so they should all follow the 
same form.

-- james

