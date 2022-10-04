Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F592C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 23:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiJDXqg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 19:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJDXqY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 19:46:24 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD1E1AD8F
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 16:46:19 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id h8-20020a17090a054800b00205ccbae31eso249359pjf.5
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 16:46:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ACPxYNm3X7/XN1MOj8uBE32BkmUWMPKsGIRYee8Z1CQ=;
        b=GFf67vfxnM2/oF8c6RwEIebqgXPRRHPTpsjIeP55ZFvK75+4S65dElPkAzKML0mNyn
         LZWDb6GQ9uVTuY4oVnu6Zs+BX7U66UoQ4mhOFSukqPricXvwURzTM8XUvlPR6wCJKeQH
         O0m8q/TfzXpnpbvw6sUpgQ+jTETdwUZgN5znVdCsisdxwNlsBTxo0zAOE+Au38/glDNQ
         F8jZa60xS2MT8JzuOn0UsL405mMePXmiTpSgrCOjLZ5xP7WU83qGUU9eHyIMqoSs1drj
         7/2mWrcDjlK3Wy5EL5bog5ZywKirXtLUAFEMMht0zh+1NTByNDi8O5xNHu/AUhddd7qM
         64yA==
X-Gm-Message-State: ACrzQf3SZjOSIn8VlYD9O3QCjTeT00saaTz1KWyXtab+SK31YoiEIDSP
        FCZeyqAvh4nFF8ctATkAB9o=
X-Google-Smtp-Source: AMsMyM6l/lAeM2gCdp8zeiMB5lKW0jRXzD8IlCm1ORBw4jBDArKQYfyzaTG5jDHQgilos0Y5+YTVPg==
X-Received: by 2002:a17:902:c245:b0:178:3912:f1fe with SMTP id 5-20020a170902c24500b001783912f1femr29662944plg.13.1664927178169;
        Tue, 04 Oct 2022 16:46:18 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id l6-20020a170902d34600b0016c0c82e85csm9449821plk.75.2022.10.04.16.46.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 16:46:17 -0700 (PDT)
Message-ID: <04972e86-6cc1-c890-e257-957957e92a30@acm.org>
Date:   Tue, 4 Oct 2022 16:46:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 23/35] scsi: Have scsi-ml retry sd_spinup_disk errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-24-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221003175321.8040-24-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:53, Mike Christie wrote:
> This simplifies sd_spinup_disk so scsi-ml retries errors for it. Note that
> we retried specifically on a UA and also if scsi_status_is_good returned
> failed which could happen for all check conditions, so in this patch we
> don't check for only UAs.
> 
> We do not handle the outside loop's retries because we want to sleep
> between tried and we don't support that yet.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/sd.c | 68 ++++++++++++++++++++++++++---------------------
>   1 file changed, 37 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index a35c089c3097..912cc2623d47 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2064,50 +2064,56 @@ sd_spinup_disk(struct scsi_disk *sdkp)
>   {
>   	unsigned char cmd[10];

Can the cmd[] declaration be changed into something like the following?

static const u8 cmd[10] = { TEST_UNIT_READY };

Thanks,

Bart.
