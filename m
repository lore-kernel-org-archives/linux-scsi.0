Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 473BDC2BA2B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 21:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 215CD221F9
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 21:35:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O73fRdHy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgDPVfj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 17:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727799AbgDPVfi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 17:35:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A842AC061A0C;
        Thu, 16 Apr 2020 14:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=ALVLHD2RNHekDAbv25k6R8kMb5XvPMsdU139s7Bmfkk=; b=O73fRdHyTZGG9/qw+Vm47xiAYT
        qR4eHMYfOTl4MHjc+iovIcgnudP+mR7/YBlPjax77KDd5U6pe241rpvmkGEsDU3oVyTTFVHrpJ2Gy
        2G9VCz7gNkXSsMH+IKai1iWb+42Y5eRuulmuIB302LJgO5wsXMqZy93E4g/8Nl3NWtSqFmWmHrfBr
        wO9zMYEq1Dv3wTBVTve9tvNdYtoeu0NYTYLXufm0lqUEFgp34hGsIM1lFhqtl/IVLhZgNtRpccxu+
        nFwHukU9yCXa6vy2+k5AFaTHbPyjTgPJnA7CvHT5VcC3LRfMfF+luJxGIqia7kr/a1faJ6CXmqWXG
        UGVcBHfA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jPCAX-0001JU-0y; Thu, 16 Apr 2020 21:35:33 +0000
Subject: Re: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
To:     huobean@gmail.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200416203126.1210-1-beanhuo@micron.com>
 <20200416203126.1210-6-beanhuo@micron.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <d8d3ccea-95dd-184b-3099-b168becbf00d@infradead.org>
Date:   Thu, 16 Apr 2020 14:35:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200416203126.1210-6-beanhuo@micron.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi--

A few Kconfig changes for you to consider:


On 4/16/20 1:31 PM, huobean@gmail.com wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> This patch is to add support for the UFS Host Performance Booster (HPB v1.0),
> which is used to improve UFS read performance, especially for the random read.
> 
> NAND flash-based storage devices, including UFS, have mechanisms to translate
> logical addresses of requests to the corresponding physical addresses of the
> flash storage. Traditionally this L2P mapping data is loaded to the internal
> SRAM in the storage controller. When the capacity of storage is larger, a
> larger size of SRAM for the L2P map data is required. Since increased SRAM
> size affects the manufacturing cost significantly, it is not cost-effective
> to allocate all the amount of SRAM needed to keep all the Logical-address to
> Physical-address (L2P) map data. Therefore, L2P map data, which is required
> to identify the physical address for the requested IOs, can only be partially
> stored in SRAM from NAND flash. Due to this partial loading, accessing the
> flash address area where the L2P information for that address is not loaded
> in the SRAM can result in serious performance degradation.
> 
> The HPB is a software solution for the above problem, which uses the host’s
> system memory as a cache for the FTL L2P mapping table. It does not need
> additional hardware support from the host side. By using HPB, the L2P mapping
> table can be read from host memory and stored in host-side memory. while
> reading the operation, the corresponding L2P information will be sent to the
> UFS device along with the reading request. Since the L2P entry is provided in
> the read request, UFS device does not have to load L2P entry from flash memory.
> This will significantly improve random read performance.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/Kconfig  |   62 +
>  drivers/scsi/ufs/Makefile |    1 +
>  drivers/scsi/ufs/ufshcd.c |   55 +-
>  drivers/scsi/ufs/ufshcd.h |   10 +
>  drivers/scsi/ufs/ufshpb.c | 3279 +++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshpb.h |  450 +++++
>  6 files changed, 3851 insertions(+), 6 deletions(-)
>  create mode 100644 drivers/scsi/ufs/ufshpb.c
>  create mode 100644 drivers/scsi/ufs/ufshpb.h
> 
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index e2005aeddc2d..48704062861a 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -160,3 +160,65 @@ config SCSI_UFS_BSG
>  
>  	  Select this if you need a bsg device node for your UFS controller.
>  	  If unsure, say N.
> +
> +config SCSI_UFSHPB
> +	bool "UFS Host Performance Booster (EXPERIMENTAL)"
> +	depends on SCSI_UFSHCD
> +	help
> +	  NAND flash-based storage devices, including UFS, have mechanisms to
> +	  translate logical addresses of the IO requests to the corresponding
> +	  physical addresses of the flash storage. Traditionally, this L2P
> +	  mapping data is loaded to the internal SRAM in the storage controller.
> +	  When the capacity of storage is larger, a larger size of SRAM for the
> +	  L2P map data is required. Since increased SRAM size affects the
> +	  manufacturing cost significantly, it is not cost-effective to allocate
> +	  all the amount of SRAM needed to keep all the Logical-address to
> +	  Physical-address (L2P) map data. Therefore, L2P map data, which is
> +	  required to identify the physical address for the requested IOs, can
> +	  only be partially stored in SRAM from NAND flash. Due to this partial
> +	  loading, accessing the flash address area where the L2P information
> +	  for that address is not loaded in the SRAM can result in serious
> +	  performance degradation.
> +
> +	  UFS Host Performance Booster (HPB) is a software solution for the
> +	  above problem, which uses the host side system memory as a cache for
> +	  the FTL L2P mapping table. It does not need additional hardware
> +	  support from the host side. By using HPB, the L2P mapping table can be
> +	  read from host memory and stored in host-side memory. while reading

	            ^??^                                        When performing a

> +	  the operation, the corresponding L2P information will be sent to the

	  read operation, the

> +	  UFS device along with the reading request. Since the L2P entry is

	                        the read request.

> +	  provided in the read request, UFS device does not have to load L2P
> +	  entry from flash memory to UFS internal SRAM. This will significantly
> +	  improve the read performance.
> +
> +	  When selected, this feature will be built in the UFS driver.
> +
> +	  If in doubt, say N.
> +
> +config UFSHPB_MAX_MEM_SIZE
> +	int "UFS HPB maximum memory size per controller (in MiB)"
> +	depends on SCSI_UFSHPB
> +	default 128
> +	range 0 65536
> +	help
> +	  This parameter defines the maximum UFS HPB memory/cache size in the
> +	  host system. The recommended HPB cache size by the UFS device can be
> +	  calculated from bHPBRegionSize and wDeviceMaxActiveHPBRegions. The
> +	  reference formula can be
> +
> +		(bHPBRegionSize(in KB) / 4KB) * 8 * wDeviceMaxActiveHPBRegions.
> +
> +	  The HPB cache in the host system is used to contain L2P mapping entry.

	                                                                  entries.

> +	  If the allocated HPB cache size is lower than what calculated by the

	                                                that

> +	  above formula, the use of HPB feature may provide lower performance
> +	  advantage. But the system memory resource has the limitation, we can
> +	  not let HPB driver allocate its cache at will according to the UFS
> +	  device recommendation, so an appropriate size of the cache for HPB
> +	  should be specified before you choose to use HPB, then please input a

	                                                    then enter a

> +	  non-zero positive integer value.
> +
> +	  Nevertheless, if you want to leave this right to the HPB driver, and

	                               leave this to the HPB driver, and

> +	  let the HPB driver allocate the HPB cache based on the recommendation
> +	  of the UFS device. Just give 0 value to this parameter.

	             device, just

> +
> +	  Leave the default value if unsure.

gday.
-- 
~Randy

