Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F5AAC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 23:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbiF3Xl6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 19:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbiF3Xlw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 19:41:52 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5A4564EA
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 16:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656632508; x=1688168508;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HnKju8kjGOSRgTCWdAK1YkRQ7CqpE1nsYg1ASv8QOFQ=;
  b=CS1vEGX7ergrXzr6OFFMrR29XgAN5DTc9BAWZcwOEoMe07fHAzMln5qY
   QXPTLHYKSdmn5gfSHnIf1m4RmsjiMbn6bQIRG3RKWf9V+jALj6+XFTJ+f
   KFcrY1ppjit6+Dv3Z9arXa16noUHxDEZR2ygYL3o/FcNpi44qEYc5IKQP
   lJ9L1J7hnKdmuZ9jlNkhJwyXDo66TSzdY6AvxlMmACy3VcmQtZBaQ4SPi
   T1FJ92UEIJgGFlvpHAlTKKumohq57y30J9hm3yQWrWKg5yTZI8EGDRm5W
   1nHPPHacklrpG22bGsAr9Oj9WqLbW42WQ+LaSBymYO/h9rv1uAHGAlMh9
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,235,1650902400"; 
   d="scan'208";a="308859548"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 01 Jul 2022 07:41:44 +0800
IronPort-SDR: GGPSy8W7CL0zjwdCU0yQHdzfS90jtHNhpms89SDn7kW+Mw3oEg5tca3JTj04aA+lLoQajx09L0
 MVTxVsx7Kce8rCMy5lyG6zusBGpmIw6kaBLdOIG8n5P2gzRqaiWOInWif7IRbN4BILkaTssMcO
 AvmpiUzMun8Fy7fxQN9CtyV+JLLq6TulNs+BdeFfEHCs8cYaiWmDzPtA7XhZbMmspo9YyPIwVF
 /74DVfmKaJMQ06Hy8TGhFez0E32IsEEDxA7eedRJnyWXbFdSGMk2zhWINkiR2NbBGZVfZzd/XI
 Zla7MJiE6uZcI/VdkOev0wK7
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Jun 2022 16:03:56 -0700
IronPort-SDR: 2duyvmFX0FRhn3SX9fhwuPFgE79xmEDS7QGnj7yBX/F/4ObOifN2DRXtr2qX6RTQSNbG4ATonB
 PL6KkaSHbjc05coFRfbNeVTzm7DCwSWJGioF3uw6UxOGoPhuDujWr+XKw4kr2++0yeqvpHFvTk
 Mxhatp5J3w/Y/gfx3cbJExQ4A27ywvdptjPGOwKKKUYrCiqGMLYBX44QSWxA7QfcQ3suPoYoLT
 LHK+vfX8v0dGmvdetLGk1f/ITf3rQakUvH9AOO0gfaEyHNEomcCzOzNph1ztBqk5p77uezrWwK
 qRA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Jun 2022 16:41:44 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LYvxM4GXGz1Rwnm
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 16:41:43 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1656632502; x=1659224503; bh=HnKju8kjGOSRgTCWdAK1YkRQ7CqpE1nsYg1
        ASv8QOFQ=; b=P9iYGd3HCrOxjqwh9g498JZGUki12Yfnka0lruYdSrS51RQi9dB
        4C36ZcMv5PQ2ayLdnbSLbZFyCziR2qZ7NXX02FI2JtsEHBvJv0K+hVe/JpmkW3o5
        lzjaWmF/XO4hGnvVhA4SNMmXmn6NIEWc/pkOeRZYh6Uwbf+8LWcpJxiTS48GyJJ7
        EQSNyd/s8Zs1i7oqHOHKMKajVL16c+qo9RZWXdRIMMXV2PsmkGXpOfiYKukihmBD
        Eryw0wrAkirDxdsAy1lHf/eBUFwKd9eWuvO7B6Rj359rXI/h4+M+Hj6pAM0FKdeU
        arXm7l4IWe9UTRVWxp8up6NLQqov8cKXlSQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id NsPywwrXW-4I for <linux-scsi@vger.kernel.org>;
        Thu, 30 Jun 2022 16:41:42 -0700 (PDT)
Received: from [10.225.163.102] (unknown [10.225.163.102])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LYvxJ3cq3z1RtVk;
        Thu, 30 Jun 2022 16:41:40 -0700 (PDT)
Message-ID: <5f79d8e7-0035-cfb0-d612-3e1c7f243f22@opensource.wdc.com>
Date:   Fri, 1 Jul 2022 08:41:39 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v5 3/5] scsi: core: Cap shost max_sectors according to DMA
 limits only once
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, joro@8bytes.org,
        will@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, iommu@lists.linux-foundation.org,
        iommu@lists.linux.dev, linux-scsi@vger.kernel.org,
        linuxarm@huawei.com
References: <1656590892-42307-1-git-send-email-john.garry@huawei.com>
 <1656590892-42307-4-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1656590892-42307-4-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/30/22 21:08, John Garry wrote:
> The shost->max_sectors is repeatedly capped according to the host DMA
> mapping limit for each sdev in __scsi_init_queue(). This is unnecessary, so
> set only once when adding the host.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hosts.c    | 5 +++++
>  drivers/scsi/scsi_lib.c | 4 ----
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 8352f90d997d..d04bd2c7c9f1 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -236,6 +236,11 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>  
>  	shost->dma_dev = dma_dev;
>  
> +	if (dma_dev->dma_mask) {
> +		shost->max_sectors = min_t(unsigned int, shost->max_sectors,
> +				dma_max_mapping_size(dma_dev) >> SECTOR_SHIFT);
> +	}

Nit: you could remove the curly brackets... But it being a multi-line
statement, having them is OK too I think.

> +
>  	error = scsi_mq_setup_tags(shost);
>  	if (error)
>  		goto fail;
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 6ffc9e4258a8..6ce8acea322a 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1884,10 +1884,6 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
>  		blk_queue_max_integrity_segments(q, shost->sg_prot_tablesize);
>  	}
>  
> -	if (dev->dma_mask) {
> -		shost->max_sectors = min_t(unsigned int, shost->max_sectors,
> -				dma_max_mapping_size(dev) >> SECTOR_SHIFT);
> -	}
>  	blk_queue_max_hw_sectors(q, shost->max_sectors);
>  	blk_queue_segment_boundary(q, shost->dma_boundary);
>  	dma_set_seg_boundary(dev, shost->dma_boundary);

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
