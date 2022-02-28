Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 212B1C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 20:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiB1UJb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 15:09:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiB1UJa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 15:09:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2926F5C867
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 12:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646078930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N/k1lhZVEuxXWqpiPW2/CDVwRBpHX6EIjPik08jxjfU=;
        b=DB6T2QvEFAMv+eVHvz4UZkZQnHQwyMWqrh2/3NUq9R7umd2SiZ3P89rgKBg/dNGBkU3zxu
        zWw27+EujuXVRKgUpYj/41gXM+2fBX6tF04lvdP15vkiEfTSEpr5MI7GCgtXK3kgmmMCeE
        DqPZ2lhMq2nEbE4S2qkioYq12fRWTns=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-g3vtVaGdO_maELKqUSS4CQ-1; Mon, 28 Feb 2022 15:08:47 -0500
X-MC-Unique: g3vtVaGdO_maELKqUSS4CQ-1
Received: by mail-qv1-f70.google.com with SMTP id fh12-20020a0562141a0c00b00432f7fe8804so5901974qvb.4
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 12:08:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=N/k1lhZVEuxXWqpiPW2/CDVwRBpHX6EIjPik08jxjfU=;
        b=ssxawSM099wvg66MOTdoFg5RkcCXN4/E79yujuQMmEoBSPRbShWQ+ZY5WH6a3FiBKr
         s+oQ7q6GQVXDJdGo5dSy2WAKywly9EAAgbbgeVPaXVOVdB8Xu+T0Tb4feUYGO1Gi648H
         RXMZYwkBXlgKiCCE1tEzcs/5MDU+/HSxm/B0BtjTscpboq4KxOeBzsX1upqNVbZEVun4
         62+Bw9g1ys47f5wpYLjxqYN5YWD3oSC9Obd1kW4iKYZvEhh5f/5JesYMCYeVNSXryX+d
         8cgV22epusHQva9+QuR5XG5amnUm2OPuq40dQjV3TYmUlEu4lkWlgcrwmM87eqjI4jc0
         dm5g==
X-Gm-Message-State: AOAM533QGljJShRuT05JRR8wTbMnyA8yKpdGn8jF5yI2GH8TBr1qxkHw
        mpcgalJjwiu7BQnOtO/R2JcVRr04wNa7mDgbhv5JUSVrKJg3VW2tYrvX527RkpmFn7ELIMjto+o
        3zSW/3WNbZxtfGe3IGCCZDw==
X-Received: by 2002:a37:604:0:b0:47b:50bd:8ed8 with SMTP id 4-20020a370604000000b0047b50bd8ed8mr12398373qkg.195.1646078925805;
        Mon, 28 Feb 2022 12:08:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJye3TKKLJlqT6wD/l91+EkqUWVEqUdXjOjqo6al1zJvX1Nub2Xkba/aIz20hPMCYEOPJkX0jw==
X-Received: by 2002:a37:604:0:b0:47b:50bd:8ed8 with SMTP id 4-20020a370604000000b0047b50bd8ed8mr12398354qkg.195.1646078925567;
        Mon, 28 Feb 2022 12:08:45 -0800 (PST)
Received: from [192.168.0.14] (97-120-59-83.ptld.qwest.net. [97.120.59.83])
        by smtp.gmail.com with ESMTPSA id x26-20020ae9f81a000000b005f1916fc61fsm5353661qkh.106.2022.02.28.12.08.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 12:08:45 -0800 (PST)
Message-ID: <acf59770-cbed-7e3d-74b7-bba5b8d8427a@redhat.com>
Date:   Mon, 28 Feb 2022 12:08:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 6/6] scsi: iscsi: Drop temp workq_name.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, lduncan@suse.com,
        liuzhengyuang521@gmail.com
References: <20220226230435.38733-1-michael.christie@oracle.com>
 <20220226230435.38733-7-michael.christie@oracle.com>
From:   Chris Leech <cleech@redhat.com>
In-Reply-To: <20220226230435.38733-7-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/26/22 3:04 PM, Mike Christie wrote:
> When the workqueue code was created it didn't allow variable args so we
> have been using a temp buffer. Drop that.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/libiscsi.c | 6 ++----
>  include/scsi/libiscsi.h | 1 -
>  2 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 059dae8909ee..a75b85f0a189 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2798,11 +2798,9 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
>  	ihost = shost_priv(shost);
>  
>  	if (xmit_can_sleep) {
> -		snprintf(ihost->workq_name, sizeof(ihost->workq_name),
> -			"iscsi_q_%d", shost->host_no);
> -		ihost->workq = alloc_workqueue("%s",
> +		ihost->workq = alloc_workqueue("iscsi_q_%d",
>  			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
> -			1, ihost->workq_name);
> +			1, shost->host_no);
>  		if (!ihost->workq)
>  			goto free_host;
>  	}
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index 4ee233e5a6ff..2d85810d1929 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -371,7 +371,6 @@ struct iscsi_host {
>  	int			state;
>  
>  	struct workqueue_struct	*workq;
> -	char			workq_name[20];
>  };
>  
>  /*

Reviewed-by: Chris Leech <cleech@redhat.com>

