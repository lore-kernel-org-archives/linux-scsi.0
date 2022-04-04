Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76AB7C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Apr 2022 14:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377120AbiDDO1l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Apr 2022 10:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377146AbiDDO1k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2022 10:27:40 -0400
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3173E5DA
        for <linux-scsi@vger.kernel.org>; Mon,  4 Apr 2022 07:25:45 -0700 (PDT)
Received: by mail-pg1-f179.google.com with SMTP id q19so8472056pgm.6
        for <linux-scsi@vger.kernel.org>; Mon, 04 Apr 2022 07:25:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+Wtq/Z3aPZ2OAgttgisz65dz/8jstRPltCnkdQPfUyY=;
        b=HS4/r83VQiII4t5JiuUogB2tmQADWOhIzgMyUcccji9QU/96C8Z1yrK3LS45JarPtM
         ouu3hP57SRhQVpAss3g9L0ZCGevMw6kiZMihL8cvEsXLABDIIN2rodJrsA6Iwyu/pskE
         mpm54eJ6bWVNeV4+A1wbh2xULzaxjMAj0+C+tcSvOmHW7YS13pQ45vD3h2IvolpRNncr
         bY5Bdvzcpf8e/zDvWJtRzIVVE9hFmc7unGJYSU6tQFWqdVPgPMhf/RdUBDo3zPXG8lM0
         bcm8Me6o7TBjgAEcXJqE+xWqnIwROr8qOIzKKLFRW9y+GJXxfe4W6G0Juyk7WidLKsNF
         UMFw==
X-Gm-Message-State: AOAM530TLVoMGDK3qyR6Km7RRP1wVJ3cS2q8IpHW9qvPclWmfV5c/1/t
        P4RELGBJzt34hasviK3eEA4=
X-Google-Smtp-Source: ABdhPJym3sU/JsSsQv1CuQ4h4litOJczWLrbTZ+1Y2CS00ejOla33Lo8zeBIC4eezQzjgwmhy9n9jA==
X-Received: by 2002:a65:4503:0:b0:382:aad5:ad7d with SMTP id n3-20020a654503000000b00382aad5ad7dmr125445pgq.488.1649082344340;
        Mon, 04 Apr 2022 07:25:44 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm12731360pfo.155.2022.04.04.07.25.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Apr 2022 07:25:43 -0700 (PDT)
Message-ID: <8a3dfb77-9c42-871a-0d16-1ddf84516c8e@acm.org>
Date:   Mon, 4 Apr 2022 07:25:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 2/7] mpi3mr: add support for driver commands
Content-Language: en-US
To:     Sumit Saxena <sumit.saxena@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, chandrakanth.patil@broadcom.com,
        sreekanth.reddy@broadcom.com, prayas.patel@broadcom.com,
        Christoph Hellwig <hch@lst.de>
References: <20220329180616.22547-1-sumit.saxena@broadcom.com>
 <20220329180616.22547-3-sumit.saxena@broadcom.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220329180616.22547-3-sumit.saxena@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/29/22 11:06, Sumit Saxena wrote:
> +/**
> + * struct mpi3mr_nvme_pt_sge -  Structure to store SGEs for NVMe
> + * Encapsulated commands.
> + *
> + * @base_addr: Physical address
> + * @length: SGE length
> + * @rsvd: Reserved
> + * @rsvd1: Reserved
> + * @sgl_type: sgl type
> + */
> +struct mpi3mr_nvme_pt_sge {
> +	u64 base_addr;
> +	u32 length;
> +	u16 rsvd;
> +	u8 rsvd1;
> +	u8 sgl_type;
> +};

Does the above data structure force user space software to pass a 
physical address to the kernel? A kernel driver should not do this 
unless there is a very good reason to do so. Passing a physical address 
from user space to the kernel requires freezing the virtual-to-physical 
mapping. Some user space developers erroneously use mlock() for this 
purpose. Is there any other way than the VFIO_IOMMU_MAP_DMA ioctl to 
prevent that the kernel modifies the virtual-to-physical mapping?

Thanks,

Bart.
