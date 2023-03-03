Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E506C64EC4
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Mar 2023 18:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbjCCSED (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 13:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbjCCSEC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 13:04:02 -0500
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8FD2ED69
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 10:04:01 -0800 (PST)
Received: by mail-pg1-f182.google.com with SMTP id s18so2007633pgq.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 10:04:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677866641;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/oEne/zvpf4WHYM2FXSwcw5eZ2L0uqJK5+ORhLTj+ig=;
        b=insWmuOMibqLT4ou2C5jFxdVYQO6vd2HdgKrho4OOchtbl34EnkfUzGigsqLtZ2Fxf
         fhCzvbU5O95B79TY3IVyKUBsC7V5Ll1+RTE2GEBMu4Ki7sAGDMJMAdIUQN/Zxd3GqRmu
         aYCR0YujHx9nOw3Or2Txh2TStsuwx/PNxHsE2GR0hTF+YsTQZSfXlzoxenX0r69UK5e7
         VjNQmKz2mAGXFjf/yhvDGVOvj/q348dGGJv8sfHHlwm5TPRBGnbadyOrg38KGY1evh8C
         5f24qee52dr4HPXjGGHa9EicWlCDnajyNisMIVydBhZYqwC3YfffPSNxuVg2CqGx0L0X
         IbAg==
X-Gm-Message-State: AO0yUKWUWBSl8bX0h9Nayy/gNxsaUNYRProv6WVnMShwLlSaifzNPdn0
        MSON0atP9J4pWOi7OdDxuDg=
X-Google-Smtp-Source: AK7set+bIlw8jBYHkamP85k48DKfhJorMCdB9nODq0mo3+7vwpozrWPiYIwm7wOC2uM6QVrM5EXz/w==
X-Received: by 2002:aa7:96d8:0:b0:5ef:b4e1:db0e with SMTP id h24-20020aa796d8000000b005efb4e1db0emr2658669pfq.16.1677866640726;
        Fri, 03 Mar 2023 10:04:00 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:30f3:595a:48e5:cb41? ([2620:15c:211:201:30f3:595a:48e5:cb41])
        by smtp.gmail.com with ESMTPSA id w18-20020a63af12000000b004fbdfdffa40sm1848008pge.87.2023.03.03.10.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 10:04:00 -0800 (PST)
Message-ID: <8be7cebf-a5dc-4742-1ef2-207d1797f2f3@acm.org>
Date:   Fri, 3 Mar 2023 10:03:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 1/2] scsi: sd: Check physical sector alignment of
 sequential zone writes
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20230303014422.2466103-1-shinichiro.kawasaki@wdc.com>
 <20230303014422.2466103-2-shinichiro.kawasaki@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230303014422.2466103-2-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/2/23 17:44, Shin'ichiro Kawasaki wrote:
> +	if (sdkp->device->type == TYPE_ZBC && blk_rq_zone_is_seq(rq) &&
> +	    (req_op(rq) == REQ_OP_WRITE || req_op(rq) == REQ_OP_ZONE_APPEND) &&
> +	    (!IS_ALIGNED(blk_rq_pos(rq), pb_sectors) ||
> +	     !IS_ALIGNED(blk_rq_sectors(rq), pb_sectors))) {
> +		scmd_printk(KERN_ERR, cmd,
> +			    "Sequential write request not aligned to the physical block size\n");
> +		goto fail;
> +	}

I vote -1 for this patch because my opinion is that we should not 
duplicate checks that must be performed by the storage controller anyway 
inside the sd driver.

Thanks,

Bart.
