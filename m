Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E388C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Nov 2022 22:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiKBWzT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Nov 2022 18:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiKBWzC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2022 18:55:02 -0400
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A2CDF87;
        Wed,  2 Nov 2022 15:55:01 -0700 (PDT)
Received: by mail-pg1-f174.google.com with SMTP id v3so132302pgh.4;
        Wed, 02 Nov 2022 15:55:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FhcJfbAsBWcPbIOPhmf4NmsmIT2+nCjFL2diMORdIc4=;
        b=bzzZfRk7WGRSYoxpE3qiQ+pLdF0GfKY0zPHomZKxO/iMecZ92y/m7jsH2FjmpXArKR
         vIjxr1759C+1s6pwJFE1Gt1RWtt6BbdW/G3f6lzYP1SkwGmEcX32/zfwyuFrl+Y1ko0F
         /j7g83ma/Inx9gb9QuCcbzp6+/XWpn727ODds9G1OkDGpyVwy+h0wCI7Bf707O8LQou5
         l1eZlIuOAhhxdJzLyMDT1YCbjzw4ZydKwJdILOOeLQZ12UczsNWSNp24xi7TNiecI6UM
         CKZpXUpbNWR2S8Kt7ut7hna4hotgFzOXHkkQa3HuNgfql6UDsDhj4DIJY/w45JJDmw1/
         hLNQ==
X-Gm-Message-State: ACrzQf3EsZ6lN6U5CQi6RM5v9xlmVMEAFUdG53L/SPR2wj6mtFlium9k
        EylYz0escFKfO4AJseLjQ3A=
X-Google-Smtp-Source: AMsMyM6jm80wXzBme3fqf0bXNSyD8N9iJ7BsvU1v+V/kepBM9YQJbRErCViosW8DEAyldaWwwy8RvQ==
X-Received: by 2002:a63:d757:0:b0:46f:9446:273d with SMTP id w23-20020a63d757000000b0046f9446273dmr20335679pgi.436.1667429701140;
        Wed, 02 Nov 2022 15:55:01 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:22d3:f380:fa84:4b89? ([2620:15c:211:201:22d3:f380:fa84:4b89])
        by smtp.gmail.com with ESMTPSA id pc3-20020a17090b3b8300b00212cf2fe8c3sm3823933pjb.1.2022.11.02.15.54.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 15:55:00 -0700 (PDT)
Message-ID: <1b4bde2b-782d-67c2-62c7-8f5c13721fa8@acm.org>
Date:   Wed, 2 Nov 2022 15:54:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 04/19] scsi: Add support for block PR read
 keys/reservation
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-5-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221026231945.6609-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26/22 16:19, Mike Christie wrote:
> +static inline enum pr_type scsi_pr_type_to_block(enum scsi_pr_type type)
> +{
> +	switch (type) {
> +	case SCSI_PR_WRITE_EXCLUSIVE:
> +		return PR_WRITE_EXCLUSIVE;
> +	case SCSI_PR_EXCLUSIVE_ACCESS:
> +		return PR_EXCLUSIVE_ACCESS;
> +	case SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY:
> +		return PR_WRITE_EXCLUSIVE_REG_ONLY;
> +	case SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY:
> +		return PR_EXCLUSIVE_ACCESS_REG_ONLY;
> +	case SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS:
> +		return PR_WRITE_EXCLUSIVE_ALL_REGS;
> +	case SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS:
> +		return PR_EXCLUSIVE_ACCESS_ALL_REGS;
> +	default:
> +		return 0;
> +	}
> +}

Also for this function, how about moving the "return 0" statement out of 
the switch statement?

Thanks,

Bart.

