Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 224C5C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 00:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiCCAbg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 19:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiCCAbf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 19:31:35 -0500
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65894A644C
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 16:30:48 -0800 (PST)
Received: by mail-pj1-f54.google.com with SMTP id em10-20020a17090b014a00b001bc3071f921so6251231pjb.5
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 16:30:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mfJ+P34KL9hLyWIo3aAF1ntJtI+f7UaGs7eNRfVa828=;
        b=3rEOlkS/G7szWv8lE0ZRWICSJN5Sm2g+aW8nFoJXJCT6GoCYaRu95k1KLLeg51TI2s
         NqF3kNWKQyhmbdv/eyNrWhmrS0DyV0PvtJDylsXU8vb0zm0vmD+EEz5TPZMX6eASmAv5
         xCWCwGLQLrtX6zmEvVoK4Cx/H9mRgQ20QJd1iJ4Jsgoq9oebYfdekEZ6mIj8R53+KTeF
         ZiWr93BLBnw9vcx2gif0m7SAiNRRU0Css3hYnNGOqeoJLUmpwJotmQECS+WCMRaEUs3M
         Z+FqUuyWETLyaI5FHNQdvP9wgIhcdhwmaY5lSwAls/3qxhXuBQ8fGvAXx3MzR5IrqXlb
         WzeQ==
X-Gm-Message-State: AOAM531jzYqEt6GyPSCJn+kf5CIzLHgllybsOcbA58TqIifyN7vb46bC
        gcjyFv6BcZOjbFdovo1FNE7xw4JskgM=
X-Google-Smtp-Source: ABdhPJzyBY25Xc9ouO75qWZLDrri/7ilJa6xy2wKeHOLiExKRWHjzV3dlGWEYWuU07fqYBrhjCf76A==
X-Received: by 2002:a17:90a:1f4c:b0:1bc:fcbc:1474 with SMTP id y12-20020a17090a1f4c00b001bcfcbc1474mr2490935pjy.79.1646267447597;
        Wed, 02 Mar 2022 16:30:47 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id h2-20020a056a00218200b004f66d50f054sm293064pfi.158.2022.03.02.16.30.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 16:30:46 -0800 (PST)
Message-ID: <43d36f31-9f62-55de-219c-65c5e88fde69@acm.org>
Date:   Wed, 2 Mar 2022 16:30:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 02/14] scsi: core: Query VPD size before getting full page
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     "Maciej W . Rozycki" <macro@orcam.me.uk>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-3-martin.petersen@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220302053559.32147-3-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/22 21:35, Martin K. Petersen wrote:
> +static int scsi_get_vpd_size(struct scsi_device *sdev, u8 page)
> +{
> +	unsigned char vpd_header[SCSI_VPD_HEADER_SIZE];
> +	int result;

The SCSI core sets the minimum DMA alignment to 4 bytes. How about 
aligning the vpd_header[] array explicitly to a four-byte boundary such 
that the block layer does not have to allocate a temporary buffer?

> +	vpd_len = min(vpd_len, buf_len);
>   
> - found:
> -	result = scsi_vpd_inquiry(sdev, buf, page, buf_len);
> +retry_pg:
> +	/*
> +	 * Fetch the actual page. Since the appropriate size was reported
> +	 * by the device it is now safe to ask for something bigger.
> +	 */
> +	memset(buf, 0, buf_len);
> +	result = scsi_vpd_inquiry(sdev, buf, page, vpd_len);
>   	if (result < 0)
> -		goto fail;
> +		return -EINVAL;
> +	else if (result > vpd_len) {
> +		dev_warn_once(&sdev->sdev_gendev,
> +			      "%s: VPD page 0x%02x result %d > %d bytes\n",
> +			      __func__, page, result, vpd_len);
> +		vpd_len = min(result, buf_len);
> +		goto retry_pg;
> +	}

Will an endless loop be triggered if the VPD page length is larger than 
'buf_len'?

Thanks,

Bart.
