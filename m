Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F91C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 21:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbiDGVhz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 17:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbiDGVho (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 17:37:44 -0400
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C4263BDC
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 14:35:42 -0700 (PDT)
Received: by mail-pj1-f47.google.com with SMTP id m12-20020a17090b068c00b001cabe30a98dso10109872pjz.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 14:35:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qb527Q1XpbDhfMsEL6m6Pfc7ez48BsEA88prUV/sHqs=;
        b=zLke08pxoBI1UQTOB9jgmmKvQmNqBISj0si/QDy4NauqQ5aflPR3ym9hObIm2xLGZv
         8J7IPmclOR1hK5e88xv2pMJiA/wfLtgny/f9gHAFyi2C+qUQgta0HIrCWXe/xrueyWjv
         piI/xY3oN3fy58HzzWS+F2Aft5JEslC1xxPLDRm64v2LNC8OJDH3HYwkr31zY7IEEKOZ
         sUsaNMlgbuTX9MLPO6aXhxyeXYIldu/mHGGWz1ZS3MN/3X9fAVet8SvlQH4HIb+jrhVZ
         QJrSD9n+7uhWRug/P7HPgztpVb15i2LCDVBNUAA56p+orjuVIEHl6bdj4tGEOfwbINH/
         NNkg==
X-Gm-Message-State: AOAM532wEVMhffc5ikkKvAP55PEWPS8xgfQ9MTvIJVeGYnhtCleWtXnx
        xQQR8KbdY7dOjYY4zGoBKRs=
X-Google-Smtp-Source: ABdhPJxgBS1wd0RxdmtpEZIjrtcmhaa+b3lvRmig6uPnokc1ArztyArxEE7f50dCypkOG6tDA1KR1A==
X-Received: by 2002:a17:902:d2c7:b0:157:ebe:25c6 with SMTP id n7-20020a170902d2c700b001570ebe25c6mr3887894plc.34.1649367342253;
        Thu, 07 Apr 2022 14:35:42 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090a390d00b001c995e0a481sm9950640pjb.30.2022.04.07.14.35.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 14:35:41 -0700 (PDT)
Message-ID: <9e2b76be-c30a-3c72-35da-0c2e56b476c8@acm.org>
Date:   Thu, 7 Apr 2022 14:35:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 3/8] mpi3mr: move MPI headers to uapi/scsi/mpi3mr
Content-Language: en-US
To:     Sumit Saxena <sumit.saxena@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, hch@lst.de,
        sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
        chandrakanth.patil@broadcom.com, sreekanth.reddy@broadcom.com,
        prayas.patel@broadcom.com
References: <20220407192913.345411-1-sumit.saxena@broadcom.com>
 <20220407192913.345411-4-sumit.saxena@broadcom.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220407192913.345411-4-sumit.saxena@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/22 12:29, Sumit Saxena wrote:
> diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/include/uapi/scsi/mpi3mr/mpi30_cnfg.h
> similarity index 100%
> rename from drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
> rename to include/uapi/scsi/mpi3mr/mpi30_cnfg.h
> diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_image.h b/include/uapi/scsi/mpi3mr/mpi30_image.h
> similarity index 100%
> rename from drivers/scsi/mpi3mr/mpi/mpi30_image.h
> rename to include/uapi/scsi/mpi3mr/mpi30_image.h
> diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_init.h b/include/uapi/scsi/mpi3mr/mpi30_init.h
> similarity index 100%
> rename from drivers/scsi/mpi3mr/mpi/mpi30_init.h
> rename to include/uapi/scsi/mpi3mr/mpi30_init.h
> diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h b/include/uapi/scsi/mpi3mr/mpi30_ioc.h
> similarity index 100%
> rename from drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
> rename to include/uapi/scsi/mpi3mr/mpi30_ioc.h
> diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h b/include/uapi/scsi/mpi3mr/mpi30_pci.h
> similarity index 100%
> rename from drivers/scsi/mpi3mr/mpi/mpi30_pci.h
> rename to include/uapi/scsi/mpi3mr/mpi30_pci.h
> diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_sas.h b/include/uapi/scsi/mpi3mr/mpi30_sas.h
> similarity index 100%
> rename from drivers/scsi/mpi3mr/mpi/mpi30_sas.h
> rename to include/uapi/scsi/mpi3mr/mpi30_sas.h
> diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h b/include/uapi/scsi/mpi3mr/mpi30_transport.h
> similarity index 100%
> rename from drivers/scsi/mpi3mr/mpi/mpi30_transport.h
> rename to include/uapi/scsi/mpi3mr/mpi30_transport.h

Please only move the definitions that are useful for user space into 
include/uapi instead of moving all definitions, including those that are 
only used inside the kernel.

Thanks,

Bart.
