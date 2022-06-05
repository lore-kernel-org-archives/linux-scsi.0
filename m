Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B826CC43334
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jun 2022 03:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348608AbiFED6q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Jun 2022 23:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346204AbiFED6q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jun 2022 23:58:46 -0400
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6039020F40;
        Sat,  4 Jun 2022 20:58:45 -0700 (PDT)
Received: by mail-pg1-f180.google.com with SMTP id g186so1449638pgc.1;
        Sat, 04 Jun 2022 20:58:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GLlhzihM2dCuAq2yDRRLxKU2EBuIMKBNP/WnxYGk2X0=;
        b=a2VKWgjXxAcUr+YZe5UWqt1xmfRAl+gyiwW6pkaZTpzwt2FOhggQMAfp0nKD2Sa8p/
         p5jx3fn/PyiHYTW3E1/b8yRmDtXWR8wLDwM/a9QbmAVhgDlxht0cB1eVfV3XMAhJYa8l
         x4DVE1xgXQdLPTy6IiCt3NWRj0Fv8XIP6skNX3LjKIHG8AuaIKP5BQ/SRymS58qKVrOf
         KJcmydBPq4Yk6h0ZAVSb6xeKDBBdeq6P3slkuCp6Kz4MeX3Bzj+iygnil+pYFP2yUBh6
         P7ieHYsn8EDpErUPxKdvfI9Lr17EQ0FLZJ/KCIK53R1rW3azJGklWm+kCHtbW5Mcqy5x
         K6AQ==
X-Gm-Message-State: AOAM5325MmABtXFZFD6g4jRe+0bn7JEgYki9fnSaizbKmXsGIUOTRgCo
        yEh5mjQwav59VXKCmlTKFwA=
X-Google-Smtp-Source: ABdhPJxjZQL2kRq6bvFCX8dmTJe/PfzlKduObJ6a9TyRigosO4HLRQYC+nhNd3VIblOwV0h/y4fT0g==
X-Received: by 2002:a63:4387:0:b0:3c6:9490:4e4b with SMTP id q129-20020a634387000000b003c694904e4bmr15298413pga.438.1654401524741;
        Sat, 04 Jun 2022 20:58:44 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15-20020aa7980f000000b0051826824d90sm8367665pfl.177.2022.06.04.20.58.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jun 2022 20:58:43 -0700 (PDT)
Message-ID: <b4d8fdba-53e3-0f16-1209-7ee2b25ce1ea@acm.org>
Date:   Sat, 4 Jun 2022 20:58:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 03/11] scsi: Move sd_pr_type to header to share.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <20220603065536.5641-4-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220603065536.5641-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/2/22 23:55, Mike Christie wrote:
> +static inline char block_pr_type_to_scsi(enum pr_type type)
> +{
> +	switch (type) {
> +	case PR_WRITE_EXCLUSIVE:
> +		return 0x01;
> +	case PR_EXCLUSIVE_ACCESS:
> +		return 0x03;
> +	case PR_WRITE_EXCLUSIVE_REG_ONLY:
> +		return 0x05;
> +	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
> +		return 0x06;
> +	case PR_WRITE_EXCLUSIVE_ALL_REGS:
> +		return 0x07;
> +	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
> +		return 0x08;
> +	default:
> +		return 0;
> +	}
> +};
> +
> +static inline enum pr_type scsi_pr_type_to_block(char type)
> +{
> +	switch (type) {
> +	case 0x01:
> +		return PR_WRITE_EXCLUSIVE;
> +	case 0x03:
> +		return PR_EXCLUSIVE_ACCESS;
> +	case 0x05:
> +		return PR_WRITE_EXCLUSIVE_REG_ONLY;
> +	case 0x06:
> +		return PR_EXCLUSIVE_ACCESS_REG_ONLY;
> +	case 0x07:
> +		return PR_WRITE_EXCLUSIVE_ALL_REGS;
> +	case 0x08:
> +		return PR_EXCLUSIVE_ACCESS_ALL_REGS;
> +	default:
> +		return 0;
> +	}
> +}

Since 'char' is used above to represent a single byte, please use u8 or 
uint8_t instead.

Thanks,

Bart.
