Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1478C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Dec 2022 12:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbiLUMY4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Dec 2022 07:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiLUMYt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2022 07:24:49 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA892317B
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 04:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1671625488; x=1703161488;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JP6kXKReLiKe0iNUrQQ7tFMFRaAdUy2nqah2AVaSLfc=;
  b=KgMFoHowBmsycn1ECxj5CHp7PTHft0cvwE+T4VFk/fWTCDd/MZ8mgofc
   AOCHuyDuLgPqcv4G9M/ch8KkW5FipSmmLkzMC1HnLkRifutEXMyklHn6B
   QkO1l7dLmfq6APwUzYYVYD/hPmGlFZh8qCMuHJSI9lzScalLkcQ4DSd3E
   OTUit03FripfPBEOBuBPxi24i7KE51MOFHJiBYDGUzpoycDWzk3uAvsBe
   Z1NKjnv8cCxtkhRg7aNe0o978sxfaaoHvLAN1MCSCeBA2i7bSMWkxZT3A
   EifpyM6FqX76Mu0tkmlBqNViz/siueLY89jrIsN1jcExLoJfD57BJD7+L
   A==;
X-IronPort-AV: E=Sophos;i="5.96,262,1665417600"; 
   d="scan'208";a="219142420"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Dec 2022 20:24:47 +0800
IronPort-SDR: 74BnzveAh4znxwaPaC6dBQnBXr3nC37wnank+tdxiuEuVwnHWo9IJsDFqDjqVKI+wBnpNBRSZ4
 jZpEnl7M80ZFK/rOevvCJ4qa0uPbGyTbXK2eAd7HVkfV7b1y7jCXZ9FeSVazgRbBj818VFZ4oh
 9UA3JMxFYuI+vGLSeoYtz3pwDrtELtEfyyJgEq6nBB2vW7gG27Ncm/jV+bnC8UDemxEzVx7GEE
 jENgBsoZ8aA0zc2DVLjtBzsXpwfESgN+WX6cxqQBgGaVa6xSBITwFABAf/AbjrOqLq7/EiAIKp
 aQU=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Dec 2022 03:37:16 -0800
IronPort-SDR: WA4U8yvFVA3DdugsBK7+7gvEWAhsUjx/zVy2bhBsTGvbWB32ty0uhK76XAsjG4j4A1QP67QLD+
 HJ5pGNOIYwz1rbv7fyyvcVyps2+u8GCUE8XCh7cVPw+DJ6dy5XszhXLPXFrBNGMPOQ4IinK8PD
 367V1QqS+ZagdiygO9/ub+pnIuLdkFQeby/wDQ6VDsw45HzqwgrtUGvvfYxX2hgu/mgqup3I/4
 4jUs4iiMKpc4uy++zZ8gRIAFS+d7HElFohd2csGEA3BrsbaC75o6Ko6plVMbODsYgUVeaXni9k
 iG0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Dec 2022 04:24:47 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NcXgy5Qyxz1Rwtl
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 04:24:46 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1671625485; x=1674217486; bh=JP6kXKReLiKe0iNUrQQ7tFMFRaAdUy2nqah
        2AVaSLfc=; b=r8o88TIM+zit033pTSLCPBHS94VlTTniEXMuq7UJ2qaMaau9Az/
        NMdAcHYPo9Ap14bDSKslBZ2yu8o9IFqx0c3lk1cxduytSxNzVAkT2iOEMCMppoCG
        Oi1s7hk98JyhvSlkAgLEF0NadBfPwA5g2jpn7fBoilWssi77xThrfOvDL+aFLjD8
        vTkX34Y9737qhAVeUwppbVEsQ26NhfuwTTaZ0AVdcNPGezNhLORueEfhUWBIDs3Q
        LK/3VVwWQXsV/crun8iRls5edJF7B1h1d6f8BLiqbApPNjVhbjCCET+NFUeFO8zZ
        C9Y3TbxHHgQcKINLSAOiitw3exR0RWlICHw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id LGV825izd4UZ for <linux-scsi@vger.kernel.org>;
        Wed, 21 Dec 2022 04:24:45 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NcXgv6Twbz1RvLy;
        Wed, 21 Dec 2022 04:24:43 -0800 (PST)
Message-ID: <54be50a6-88d2-82d8-b549-a5e49225c6c4@opensource.wdc.com>
Date:   Wed, 21 Dec 2022 21:24:42 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH] scsi: libsas: Grab the host lock in
 sas_ata_device_link_abort()
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Jason Yan <yanaijie@huawei.com>,
        John Garry <john.g.garry@oracle.com>,
        Xingui Yang <yangxingui@huawei.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "prime.zeng@hisilicon.com" <prime.zeng@hisilicon.com>,
        "kangfenglong@huawei.com" <kangfenglong@huawei.com>
References: <20221220125349.45091-1-yangxingui@huawei.com>
 <4ec9dbed-1758-d6b4-dc1d-ac42e8c22731@oracle.com>
 <c8387766-2ca0-51f3-e332-71492b13e5c1@opensource.wdc.com>
 <7347d117-6e0b-dd18-90a8-25685f757689@huawei.com>
 <4ff0ca00-31f5-2867-ff59-cecb5d6d1048@opensource.wdc.com>
 <755d7a9c-427e-024a-8509-449ebc5a00e6@huawei.com>
 <f77c7872-3711-2216-c17c-e23591f745c7@opensource.wdc.com>
 <Y6LVaE5e9iZNAYrF@x1-carbon>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <Y6LVaE5e9iZNAYrF@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/12/21 18:44, Niklas Cassel wrote:
> On Wed, Dec 21, 2022 at 05:31:59PM +0900, Damien Le Moal wrote:
>>>
>>> What about the interrupt handler such as ahci_error_intr()? I didn't see
>>> the callers hold the port lock too. Do they need the port lock?
>>
>> It looks like it is missing for ahci_thunderx_irq_handler() but that one
>> takes the host lock. Same for xgene_ahci_irq_intr(), again no port lock
>> but host lock taken. And again for ahci_single_level_irq_intr() for the
>> non MSI case. For modern MSI adapters, the port lock is taken in
>>
>> For other cases, ahci_multi_irqs_intr_hard) takes the port lock.
>>
>> So it looks like ahci_port_intr() needs to take the lock and some
>> cleanups overall (the host lock should not be necessary in the command
>> path. But nobody seems to have issues with the "bad" cases... Probably
>> because they are not mainstream adapters.
>>
>> Definitely some work needed here.
> 
> ahci_multi_irqs_intr_hard() takes the ap->lock before calling
> ahci_handle_port_interrupt(), which calls ahci_port_intr(),
> so I don't think there is any work needed for multi IRQ AHCI.

Yes. I tried to say that above.

> 
> For ahci_single_level_irq_intr() the host lock is taken before
> calling ahci_handle_port_intr(), so I don't see why we need any
> extra work for single IRQ AHCI.
> 
> 
> Remember, while the default is that:
> 	ap->lock = &host->lock;

Ah ! Yes ! good point ! So there are no issues anywhere. This is only confusing
because of the comments I think.

> see:
> https://github.com/torvalds/linux/blob/v6.1/drivers/ata/libata-core.c#L5305
> 
> In case of MULTI MSI, the ap->lock is using its own lock:
> https://github.com/torvalds/linux/blob/v6.1/drivers/ata/libahci.c#L2460
> 
> 
> So what is it that needs to be fixed for AHCI?
> 
> I haven't looked at ahci_thunderx_irq_handler() and xgene_ahci_irq_intr()
> so I can't speak for these.

These are not multi-irq and use the &host->lock directly, which is the same as
taking the ap->lock. We could clean that up for consistency and always use
ap->lock. But not a big deal. No bugs, just a little confusing with a simple
reading of the code.

> 
> 
> Kind regards,
> Niklas

-- 
Damien Le Moal
Western Digital Research

