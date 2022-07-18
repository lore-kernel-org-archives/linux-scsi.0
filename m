Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF72CCA479
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 10:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbiGRKsF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 06:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234090AbiGRKsE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 06:48:04 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C298A1BE85
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 03:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1658141283; x=1689677283;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7rBMGEx1YSGdVB6fbYn5Y5KkPOqfQscgrLN9anE2Owo=;
  b=OIo1ObY9fszzv+GLawt/DRoeY6Da61xLQJZQnDK5hOxgf4KcVbLiteHA
   v3yG1N7CITx3qPsg6R+yFIsaVEJejS3HGQYbDXYoT9y0k0qSrV4/OsaYN
   +oLE8AGiCzS8zywzX3jYTjWthzlHGa38w7VRHvSA//BmHlLjRaANWXawY
   H9b6WncqD3TsqN0jrK0mKfXNs57g/FS9G5WRhL1QDUYT/3WihhUgwTy4N
   DxqzGFQYj/ByL0M/Xj1kU2oOtTJPeqju/k6Rz2uh10CPUXIokQ8KCUHWq
   Nvw7vzBWOlfKgSG0tjVbrauIj6ZLvEq//6l3Ac7pjLk+JL4hcbPAYxwL9
   A==;
X-IronPort-AV: E=Sophos;i="5.92,280,1650902400"; 
   d="scan'208";a="206714057"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jul 2022 18:48:02 +0800
IronPort-SDR: uSWT8BnWRZ8NgOUDznJLSk6qD2wLfGZ0YzxOs43BsxlQ8jDl+fHY/LgyBeTL6eyKiRX7z8ROaQ
 sB2fz4HezP3m0+dtHkp6y5t4mGLgoPlZbo2vGVUPp9BQJdFQL0xxhfZ504sDVjUsWzm9du7Lca
 b0QnW4yQM2MpZUiB0ZlwbYhTvVRO0MpxRAOLQl0daIX/msBlDZ8UJjvkTwbhfBoVsUigO5S9xt
 PEgvmIpguprT8dJwybPKlHXtJixDi4PGXI4ppsu7Tfg+HEWx68u2zaU+xp0RUi3vYbxLpvvCdv
 yEuds/4bpP+0naQTtI06gBCv
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Jul 2022 03:04:46 -0700
IronPort-SDR: Ur31IeOMzA8V8K9Ujn1B+l/QOESMyVv+6gYnXVPNtyD2YGRsPMGzAMaGGahq67EwNaRVNcnH31
 Uwi9RKlPejCKVGEQa0oKwqFy8rtaczA+G3jGSPJD0kVw1wAezBbpdS85+BGoPfbqk92e2IrRbi
 KFOOawgINz1FXXj4JMF4Y6u9P9ShXh7YXgoozLQVMZVDbnuXWJj9iJTOeaCKCYUV56aA9geQ0o
 b5gyKLi9uxMRKgBT4oqxBIImQarLOi9vAGaD9o5AUoQxIO0letlvxed9nvO9tqfHfl29//8adU
 nRs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Jul 2022 03:48:02 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LmdwK2bX4z1Rws8
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 03:48:01 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1658141280; x=1660733281; bh=7rBMGEx1YSGdVB6fbYn5Y5KkPOqfQscgrLN
        9anE2Owo=; b=bjN5B1j0Rkc2vSnTaBg0I6yZlDKb3jC/Ey1Ow71t0OK/WvsEBS6
        zcLef5xxzvKAk6dN3xoqmSaUtbHCa7GpME+/Gyjh24WSx+3oRTp/RTNJw0MQirr9
        /HS1V4UnLFvDu+T4pFMk4KY+3/YbTd/C+0K+2mxZS9H9jBJuF+QtICaIVfDFwcoq
        Xf2U2c1D81NnxfOvu3UB2HOllG4nhOn6akT3u2/VfBdiWtKfjfBzx9y4PQm2k+Ek
        0JsdZ2kx7xVyP3FIIgro3g3SbxmL5fcX2NKc1Qc5XkWcUaSyDtLMWWgD9RAD5Dqz
        CmPSh/wyz5ZJehHEEZge/Uqk7PRq0biCTqg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id dtMBPBeR3CPR for <linux-scsi@vger.kernel.org>;
        Mon, 18 Jul 2022 03:48:00 -0700 (PDT)
Received: from [10.225.163.120] (unknown [10.225.163.120])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LmdwG3P48z1RtVk;
        Mon, 18 Jul 2022 03:47:58 -0700 (PDT)
Message-ID: <dad18548-8487-e059-9538-f34ed46d39c0@opensource.wdc.com>
Date:   Mon, 18 Jul 2022 19:47:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v6 5/6] scsi: scsi_transport_sas: Cap shost opt_sectors
 according to DMA optimal limit
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, joro@8bytes.org,
        will@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, iommu@lists.linux.dev,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com
References: <1657797329-98541-1-git-send-email-john.garry@huawei.com>
 <1657797329-98541-6-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1657797329-98541-6-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/14/22 20:15, John Garry wrote:
> Streaming DMA mappings may be considerably slower when mappings go through
> an IOMMU and the total mapping length is somewhat long. This is because the
> IOMMU IOVA code allocates and free an IOVA for each mapping, which may
> affect performance.
> 
> For performance reasons set the request queue max_sectors from
> dma_opt_mapping_size(), which knows this mapping limit.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/scsi_transport_sas.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 12bff64dade6..2f88c61216ee 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -225,6 +225,7 @@ static int sas_host_setup(struct transport_container *tc, struct device *dev,
>  {
>  	struct Scsi_Host *shost = dev_to_shost(dev);
>  	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
> +	struct device *dma_dev = shost->dma_dev;
>  
>  	INIT_LIST_HEAD(&sas_host->rphy_list);
>  	mutex_init(&sas_host->lock);
> @@ -236,6 +237,11 @@ static int sas_host_setup(struct transport_container *tc, struct device *dev,
>  		dev_printk(KERN_ERR, dev, "fail to a bsg device %d\n",
>  			   shost->host_no);
>  
> +	if (dma_dev->dma_mask) {
> +		shost->opt_sectors = min_t(unsigned int, shost->max_sectors,
> +				dma_opt_mapping_size(dma_dev) >> SECTOR_SHIFT);
> +	}
> +
>  	return 0;
>  }
>  

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
