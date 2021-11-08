Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F9DC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 17:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8792610A6
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 17:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237686AbhKHRTg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 12:19:36 -0500
Received: from mail-pj1-f46.google.com ([209.85.216.46]:45969 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbhKHRTf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 12:19:35 -0500
Received: by mail-pj1-f46.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so392769pjb.4;
        Mon, 08 Nov 2021 09:16:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6qrbAoBrJjelIsGjirLwZN0gyhg8Hh/Ojtm8QnhOi0g=;
        b=A73n+QazPeO2QdsJcqw2SVc29aBVqGbufyGCbTEyDbXyUnj7zdTcU8xXpxivFAlBh/
         6hzmIYUxycxdbikUFEAIUVR3RdJ1JG7w6YF8ChgjV/V6S+mAwb4ULGnh5g2LHcKFQL1b
         RBgnrRd9vvmDt03Othl2NVqo6TkHhcPbY4nFw8ry83XP/JYBNPHumKyVs/VhReaeJ0LN
         H6sn2qSueinvUoufcyrVbtFt/BT8lHrHfQ2/H6l2fprVYxzDXSmUX/4j3ncW4BDZY7u+
         QtBFvrv+Rhzeadg/mQa53jLcL3Tmf9cKBCjx95mBb31RMWWFts9OJf+FqHtVCjDPd5XE
         cYlw==
X-Gm-Message-State: AOAM531fyTujzUKgchUU6J2XVZEJMHpeQ2505I97Tk1oRVAVKk0MZSSN
        E3JbnHffmHaAv0iw05XAeUg=
X-Google-Smtp-Source: ABdhPJwL77HdCCHFjIvjr9rRDpMNNq43Z/sC2S3wBnrlSjlbPKp9TS0HcR6iMPctY/0vIcXyjwt14w==
X-Received: by 2002:a17:90a:ba03:: with SMTP id s3mr533039pjr.116.1636391811033;
        Mon, 08 Nov 2021 09:16:51 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4ca8:59a2:ad3c:1580])
        by smtp.gmail.com with ESMTPSA id z4sm6657616pfg.101.2021.11.08.09.16.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 09:16:49 -0800 (PST)
Subject: Re: [PATCH 2/2] scsi: ufs: Return a bsg request immediatley if
 eh-in-progress
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>
References: <20211108120804.10405-1-avri.altman@wdc.com>
 <20211108120804.10405-3-avri.altman@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <fa7dae1f-06ac-9d5a-616d-cc00c38e5feb@acm.org>
Date:   Mon, 8 Nov 2021 09:16:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211108120804.10405-3-avri.altman@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/8/21 4:08 AM, Avri Altman wrote:
> ufs-bsg is attempting to access the device from user-space, and it is
> unaware of the internal driver flows, specifically if error handling is
> currently ongoing.
> 
> Fixes: 5e0a86eed846 (scsi: ufs: Add API to execute raw upiu commands)
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>   drivers/scsi/ufs/ufshcd.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 3869bb57769b..828061c05909 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6830,6 +6830,9 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
>   	enum utp_ocs ocs_value;
>   	u8 tm_f = be32_to_cpu(req_upiu->header.dword_1) >> 16 & MASK_TM_FUNC;
>   
> +	if (!ufshcd_is_user_access_allowed(hba))
> +		return -EBUSY;
> +
>   	switch (msgcode) {
>   	case UPIU_TRANSACTION_NOP_OUT:
>   		cmd_type = DEV_CMD_TYPE_NOP;

Making operations fail if error handling is in progress makes it harder than
necessary to write user space software that uses the BSG interface. Has it
been considered to wait inside ufshcd_exec_raw_upiu_cmd() until error handling
has finished?

Thanks,

Bart.


