Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE9AC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 07:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiEWHdu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 03:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiEWHdJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 03:33:09 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDBCB4A9
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 00:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1653291184; x=1684827184;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OcwGBUpAAJiWZ5v/YJ1Btd+c99uDP5yJACtABgy45zE=;
  b=BXeSLecC+X2SL22i8nPIR15/CkeQerFielqQBqChuCtLNEak9vFyzrlT
   qxUyeD1XvG6AfXH2NGqoq/SIkO0cpewXuF5FIsQxjrIAXxfLwuUhEIuCi
   UVD4KYPdN3pD+Cgl2daNBWjY5AvYfr+npo6nu23ayu4jMqJtvDTtltJGu
   OIfJL41gLNiLfMrwu6yhCa66jjCtYR2GrgyI94HtyW/tFQeXwIUGTrVr2
   W7buoaR996agmpAhkyX67bYpEka5l3l5K0tQKub14N03gvMpJoLeNbJ8o
   hYJoTg7s7ril76ta0v/QOOdiV0XgpoFHim842AMa7x2TMy/OgUYazTIIq
   w==;
X-IronPort-AV: E=Sophos;i="5.91,245,1647273600"; 
   d="scan'208";a="201136181"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 23 May 2022 15:33:00 +0800
IronPort-SDR: 00fapcQU8OARtxZU/ZzkZiG1g73B60PvWxpJbU4rIPAuKJ82QWoV2GdmuMX3NEvnZMhZmQxM4p
 x9biQb3rYtwnangBqJ2qGPwuG2L8zEYRgiZoS/aFtUfyJzspaPXdvKYYeuHa7J3QyLPagT65z3
 wA9WFxE0xbV4cL/je559TaF1bFTZmxv6pE3jQZPAbGmisoQcBRBZFVJBmNaLZbV9KraUsQ6zPJ
 2v2Oq09WC/4yXmzZxEHfrkfuUNJBjI88Vmx1oYKLN/eYcv/1bG4EV3Ez6AaXEyiLaPQkf9OBLB
 yBmb3FsKJZvu4GLHbWW4/wPd
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 May 2022 23:57:00 -0700
IronPort-SDR: JNRDvs0qlRrSTuDwnQXl/Fcsxm5LpmG4nJwwlYqrsUDPPqo0vCyHPXxfQ9/am9+hF0UpGmsR+S
 81OanbOSGO7TUVkWbtm9/EtWwVd+Y4aXO79GMYjePj/KvkNbL65DMQTmLkddtOLlP7ySqvHS5o
 K1L16YXPE/0pBZ2Cd5KfyYj6XmiwyFOC6OA00hD1asOhsYQKmwKRwuOc9iyucWGpWWxaO+QaF3
 U/5/AgOAoQrv8m2p/7cDsgTr9RACxAk46l3BVwA/nHrRZTHh1pv7i+r9Pi2uu+43824RjwE3Yb
 fWw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 May 2022 00:33:01 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4L68F80tTmz1SVp4
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 00:33:00 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1653291178; x=1655883179; bh=OcwGBUpAAJiWZ5v/YJ1Btd+c99uDP5yJACt
        ABgy45zE=; b=KZLz5DNGE1EMHNc36tC3TAUZznz7ftzzJaC+XiqPThzU7wLVAYA
        WLfUP8He0YrJ1gLCARo0/rcSA1aAH7gEGyIPMYkb7xghe04wZPIdJhQ8Es8KrLsc
        voIAEVbQJRFEc+Kxs6E1ri4+rWS5+xkrOuLAP3jnkhTo70t8Wbl8uj/UZ/YY+Lgw
        O3NGzPEeIi8+9CqJe58gWphzlDmDbknR9HbRHwAwEsWnKFPHmcJ5tMuefSKLZ6Iq
        +s/9fC+dLrW26sIuZuoBl/X7bU4mDN/82cAyOB5T5dTmSEapTUa4mN1TpD3nXx76
        /vX5OQdlr//R6ve+zl4hlPdx4hHENJ++HSg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fW2QTRm6V21y for <linux-scsi@vger.kernel.org>;
        Mon, 23 May 2022 00:32:58 -0700 (PDT)
Received: from [10.89.85.73] (c02drav6md6t.dhcp.fujisawa.hgst.com [10.89.85.73])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4L68F40HYpz1Rvlc;
        Mon, 23 May 2022 00:32:55 -0700 (PDT)
Message-ID: <2b4426a6-88ac-1bce-ea80-52902897cd0f@opensource.wdc.com>
Date:   Mon, 23 May 2022 16:32:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 2/4] dma-iommu: Add iommu_dma_opt_mapping_size()
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, joro@8bytes.org,
        will@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, liyihang6@hisilicon.com,
        chenxiang66@hisilicon.com, thunder.leizhen@huawei.com
References: <1653035003-70312-1-git-send-email-john.garry@huawei.com>
 <1653035003-70312-3-git-send-email-john.garry@huawei.com>
 <250a10e6-40ae-e4e8-ae01-4f7144b089f8@opensource.wdc.com>
 <655b915c-e8d2-d65b-676a-a51e788f1695@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <655b915c-e8d2-d65b-676a-a51e788f1695@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/05/23 16:01, John Garry wrote:
> On 21/05/2022 00:33, Damien Le Moal wrote:
> 
> Hi Damien,
> 
>>> +unsigned long iova_rcache_range(void)
>> Why not a size_t return type ?
> 
> The IOVA code generally uses unsigned long for size/range while 
> dam-iommu uses size_t as appropiate, so I'm just sticking to that.

OK.

> 
>>
>>> +{
>>> +	return PAGE_SIZE << (IOVA_RANGE_CACHE_MAX_SIZE - 1);
>>> +}
>>> +
> 
> Thanks,
> John


-- 
Damien Le Moal
Western Digital Research
