Return-Path: <SRS0=WdRn=3Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A639C35247
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 23:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D1B0217F4
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 23:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbgBDXWT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Feb 2020 18:22:19 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40744 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbgBDXWT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Feb 2020 18:22:19 -0500
Received: by mail-pf1-f194.google.com with SMTP id q8so138454pfh.7
        for <linux-scsi@vger.kernel.org>; Tue, 04 Feb 2020 15:22:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L0d/vzoLObdOTPR8STdNnCChsQAcwmOiSypULbDuEcU=;
        b=IwpNUrWSDSdXrGoSVc8tGWVfONAgGFeM9c4RCf/Zja+c5xWXLVVxOSx/n3mipiAl4r
         emG8DHW/okVE8BTRRTKrBlEgMTCIW09XKUZrxh2jf+f74LhEad44Xjqivlwl7ai7oK+e
         dWls6quUi4XFhlYkRsNymWKueOaMuSvH/2oMRSJD0vRYH2h+Ges2SHUtKDpYv98NmZT5
         zbo9lGgHrjfKNDbAmW/obox+5FoAEDYxhi9nrj6un9SnqP92IFlwD0aIhpD3ao5IhMoA
         2I6OlslVTcqISbZ0UN9YXAwFou9lXoTew+/fEJpK0UFpwU0eihwuiC6BolnmufFa8Spv
         hwGQ==
X-Gm-Message-State: APjAAAWWO9z0czm7b+izbMj3URQNKPPQ0nn9/0p7zTa+0+jxdXjTz3oc
        xK6sTbFwwfL0q2eyU7MdGtIlN377
X-Google-Smtp-Source: APXvYqzeTXNFkqRJykJBBI2V1UI+5zg7TVTpvFVjbK3FNGj1yaVGCa79V0CYxolOxAIu01ay86GU4w==
X-Received: by 2002:aa7:979a:: with SMTP id o26mr33693892pfp.257.1580858538392;
        Tue, 04 Feb 2020 15:22:18 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id c19sm3633944pgh.8.2020.02.04.15.22.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 15:22:17 -0800 (PST)
Subject: Re: [PATCH] scsi: return correct status in
 scsi_host_eh_past_deadline()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200204102316.39000-1-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <1bf037bc-44e9-c4bc-b1d4-db061fdc302f@acm.org>
Date:   Tue, 4 Feb 2020 15:22:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200204102316.39000-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/4/20 2:23 AM, Hannes Reinecke wrote:
> If the user changed the 'eh_deadline' setting to 'off' while evaluating
> the time_before() call we will return 'true', which is inconsistent
> with the first conditional, where we return 'false' if 'eh_deadline'
> is set to 'off'.
> 
> Reported-by: Martin Wilck <martin.wilck@suse.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/scsi_error.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index ae2fa170f6ad..ae29a9b4af56 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -113,7 +113,7 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
>   	    shost->eh_deadline > -1)
>   		return 0;
>   
> -	return 1;
> +	return shost->eh_deadline == -1 ? 0 : 1;
>   }

This seems like a good opportunity to change the return type of this 
function from 'int' into 'bool'?

Thanks,

Bart.
