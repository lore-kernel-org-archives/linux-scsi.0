Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF3A6C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 01:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiCCBZv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 20:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiCCBZv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 20:25:51 -0500
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA983D4B
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 17:25:06 -0800 (PST)
Received: by mail-pj1-f52.google.com with SMTP id mr24-20020a17090b239800b001bf0a375440so995828pjb.4
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 17:25:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ECmZkgki146yeTTJVY2iPUNHxYYZQ9RfuqpcxAG3UnU=;
        b=efIqkIzv/0N/mAIj5O/QkAM0zKmzu+fGEb/RmHI6mjyK4K97J9a3F8pSes4EjO3pRe
         jQz1vQSu9lLRUaFIUQHyEGrRFQUa1GEqfyiHsG+bk78oedK46qTxk1jzqg8hOp3D52Nc
         Xmo/KYcb7E3q/ZlNyKT2CMxvCP3KU+ye67SPWDTLw87uRddd2W78ekYWajkgB4jKBQAg
         Sf5zLvMApyAPq4nxe942ELNzbZ42BxP8prLYfiOzQCiGRVpWW36OYHjIOw3SnKut2wDn
         9hgAekOnm67bo1L4t6wFEDqmWrxvrgHjhY/9WgxL+Mlq+q2mpCY1XvgOoJRgKYbLg+wY
         FMCg==
X-Gm-Message-State: AOAM5312VhEae+mWpMJOjNAnUvU1WKVePJXM8v7d9GAnnZMSSGtfPnIh
        VQPkNPxJTPUdgOvbmJ1imCY=
X-Google-Smtp-Source: ABdhPJzbnNVEk7BjUrwsgwNw92G6+IqbsIyjjQzh1vkEYjdXbKxDGWrQLWeA3VYoUPNjyskNAM9Pug==
X-Received: by 2002:a17:902:e809:b0:14f:fe0b:553d with SMTP id u9-20020a170902e80900b0014ffe0b553dmr33339455plg.102.1646270706210;
        Wed, 02 Mar 2022 17:25:06 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id m20-20020a634c54000000b003739af127c9sm340838pgl.70.2022.03.02.17.25.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 17:25:05 -0800 (PST)
Message-ID: <1d7b5136-c2c6-cf28-255e-db2bd7c43369@acm.org>
Date:   Wed, 2 Mar 2022 17:25:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 14/14] scsi: sd: Enable modern protocol features on more
 devices
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Aman Karmani <aman@tmm1.net>, David Sebek <dasebek@gmail.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-15-martin.petersen@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220302053559.32147-15-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/22 21:35, Martin K. Petersen wrote:
> +static unsigned int sd_sbc_version(struct scsi_device *sdp)
> +{
> +	unsigned int i;
> +	unsigned int max;
> +
> +	if (sdp->inquiry_len < INQUIRY_DESC_START + INQUIRY_DESC_SIZE)
> +		return 0;
> +
> +	max = min_t(unsigned int, sdp->inquiry_len, INQUIRY_DESC_END);
> +	max = rounddown(max, INQUIRY_DESC_SIZE);
> +
> +	for (i = INQUIRY_DESC_START ; i < max ; i += INQUIRY_DESC_SIZE) {
> +		u16 desc = get_unaligned_be16(&sdp->inquiry[i]);
> +
> +		switch (desc) {
> +		case 0x0600:
> +			return 4;
> +		case 0x04c0: case 0x04c3: case 0x04c5: case 0x04c8:
> +			return 3;
> +		case 0x0320: case 0x0322: case 0x0324: case 0x033B:
> +		case 0x033D: case 0x033E:
> +			return 2;
> +		case 0x0180: case 0x019b: case 0x019c:
> +			return 1;
> +		}
> +	}

Please add a comment that explains where these constants come from (the 
SPC Version descriptor values table?). Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
