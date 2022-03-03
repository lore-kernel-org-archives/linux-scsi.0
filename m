Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3CF4C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 00:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiCCAxU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 19:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiCCAxT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 19:53:19 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F021AB8B5D
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 16:52:34 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id m13-20020a17090aab0d00b001bbe267d4d1so5067663pjq.0
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 16:52:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4UsYH24TRIY/uCGTb+RyLPYQXYzaN38EZd4lB08tSQE=;
        b=ED00HWFrEfs273OXHVdqP754h/X809NhEndGYVOlZhfqNvbahVU6OVSml0N0REoaYB
         wyOdq8nPSYYkCsTmnulfBjzvTv2qQTSkcyWyNXyhburP1mQ97+KV92RIRDwrRFT+Oa56
         +cGBj5ynX4+VCjZ2WJNsfkmFmDPQ9HnQNVku4Hw1ncEid3rcEcCgvyYpnpclBZXYvjSM
         Z2f1ZXY53Gp8kQlV/qjXeDGyVx07ra+Jkv6aMkZW+PZWxJRl+QevW3b+DOIecOsVcksZ
         rFBZmxLhur8HdEEIHLjnvGsHpI6H5PGR6tC8TOgXBqlcGwKAS0LXnOuaAZRvssHn1I8b
         kN4g==
X-Gm-Message-State: AOAM532fUb10yG0qEZLqt05agOUwaxRL2zknihJMwlXtWM6D4Ynwc38n
        u5MxK+G/LljtiDpMowyj39U=
X-Google-Smtp-Source: ABdhPJxBrnWYUHVA+j0bTuar6oVWTjaIQhGd2eI6bhJup/s3WLS8DUkqACjVQ6R1KUvqxPZsWTvnjg==
X-Received: by 2002:a17:902:ea11:b0:151:a425:1ebb with SMTP id s17-20020a170902ea1100b00151a4251ebbmr2745481plg.63.1646268754308;
        Wed, 02 Mar 2022 16:52:34 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id v10-20020a056a00148a00b004e0f420dd90sm382387pfu.40.2022.03.02.16.52.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 16:52:33 -0800 (PST)
Message-ID: <1d0bbaaa-e57e-3531-0344-dc96f212c785@acm.org>
Date:   Wed, 2 Mar 2022 16:52:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 10/14] scsi: sd: Move WRITE_ZEROES configuration to a
 separate function
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-11-martin.petersen@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220302053559.32147-11-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/22 21:35, Martin K. Petersen wrote:
> +	if (mode == SD_ZERO_DEFAULT)
> +		sdkp->zeroing_override = false;
> +	else
> +		sdkp->zeroing_override = true;

Hmm ... since sd_config_write_zeroes() special-cases mode == 
SD_ZERO_DEFAULT, does the value of zeroing_override matter if mode == 
SD_ZERO_DEFAULT?

> +static void sd_config_write_zeroes(struct scsi_disk *sdkp,
> +				   enum sd_zeroing_mode mode)
> +{
> +	struct request_queue *q = sdkp->disk->queue;
> +	unsigned int logical_block_size = sdkp->device->sector_size;
> +
> +	if (mode == SD_ZERO_DEFAULT && !sdkp->zeroing_override) {
> +		if (sdkp->lbprz && sdkp->lbpws)
> +			mode = SD_ZERO_WS16_UNMAP;
> +		else if (sdkp->lbprz && sdkp->lbpws10)
> +			mode = SD_ZERO_WS10_UNMAP;
> +		else if (sdkp->max_ws_blocks)
> +			mode = SD_ZERO_WS;
> +		else
> +			mode = SD_ZERO_WRITE;
> +	}
> +
> +	if (mode == SD_ZERO_DISABLE)
> +		sdkp->zeroing_override = true;

What does "zeroing_override" mean? I would expect if mode == 
SD_ZERO_DISABLE that that choice from the user is not overridden.

Thanks,

Bart.
