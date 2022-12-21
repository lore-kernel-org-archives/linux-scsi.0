Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC142C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Dec 2022 04:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234180AbiLUEAC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Dec 2022 23:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbiLUEAB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Dec 2022 23:00:01 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C5DEA6
        for <linux-scsi@vger.kernel.org>; Tue, 20 Dec 2022 19:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1671595199; x=1703131199;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=x75bHZHEUWl0iFLgcRBohFMshs2LLAhyBh4URz+y8R4=;
  b=As/YhFf4MUy8jo3ThXiihvvdUbwFGdhLd51EEZz5ZbnbyoqCElTr0oBr
   zdNuRueAB6/u/c52dfH5Sf94aJMxaz1JSGFusGCvWIKH8REgH7YMlK1NF
   utKTQF5C1pcm8LZottRvRzasgvYI3LUOWtv0qKHyhEF3dlCXK8GjY1zb0
   0INhHXyxO6lo3QGW+YxnN3VD9HlACwHMP4+g0Bt4Lll8CJZQvZVU20Xvd
   tsEfRrUmZhB8Nv8wYuUlZ7PqkwwDdj1AQEkdGrnq5jFmfwRq6TBTn2Tn/
   rCGcXEMu/nP4FlhLhGwR9AbRL3rxuzvXqeFt6UODqzYHELcn29TPfupow
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,261,1665417600"; 
   d="scan'208";a="323485729"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Dec 2022 11:59:59 +0800
IronPort-SDR: s7XPTWD8motK6ZPZc1UsSgiGYwIinaAXxLEO8d9XlkNzNPh/5wj8gFA0s/2D8LxRTNu9mUB7sa
 hJCw1QaeO3ThafXkIkiZmGq9aAiaiHCr8lgKY7YIcqO2JXuY/6t4Y7kEfMw5pG8gBqTeBvN3YW
 UApt5kRu5EIue210prFL7M5yiZc3gE/lDxOi2L4+udRhUZ9O2UEBWKz+juo4nG2ONWkUmVPBFL
 FUbdZBG1OCASTtmsVTIs5YBrJ2SvA6wibIBva4I/qGX4kXPuLXVS8SRfBViLazKYLDDFd3S1F7
 XoE=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Dec 2022 19:12:29 -0800
IronPort-SDR: hSjIRcpDo7pYRlgbGPZJaDHSPSkl0fTcLmYhgICMPrVzWVVaNgNydEmzcVnksRH4Hc/1X4fTU1
 tlt3Z4AxWA0RngdcS3OTgjiGm/QTHHvNAQu/GOyhD0Kh96Q2PxkaA8akDsMwCow2AEQjZLZTo8
 0RXHOfQqSzT5rilKUkiz9aoMMaknVvxke6Lt5nTcz/RoF+TSJ1fTNVB2E/URMbUWKzWMW5yw5W
 oH6ATgRTTdPnvS+HvfaFvuwwj56E2ION9TNYZkCT+W2gft9jiFhUKtcFMfPLbYj7v9UW7UWN9P
 /k4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Dec 2022 20:00:00 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NcKTV6Ykjz1RvTp
        for <linux-scsi@vger.kernel.org>; Tue, 20 Dec 2022 19:59:58 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1671595198; x=1674187199; bh=x75bHZHEUWl0iFLgcRBohFMshs2LLAhyBh4
        URz+y8R4=; b=YqEG4pXF67jFgCcjnnQY+ofO2YuodPsFRbU/FHv2JKCYYo7hFJ3
        6VizM97Uo/0VyfsQC/LNlQ81TY4tz4cC+LEYEqMUVszTFDIT9fhdaNDVLvUo6fxm
        LQqe00Zt4vbepzD1OLuzA0s7s3UZ7NWWPgKfrpwDmYTXuDwCmRoMRgyaxEPv0P1w
        /f4HzLTXkjT3lPvzQDhbdwZ4Wu5I39foxN2TqBb18gvgUcmsH1y1Lmkmo6AoPevI
        6W2aINeq9AVlIffZwbwOAa1BBA4WLOxRbueGJeDX5xJU6Uw+jjnmKKSd05iSUHh6
        lSGXatI0FVULa7b/ITQsmg3Nc86Li2PCZog==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id JWB3D3amFsVO for <linux-scsi@vger.kernel.org>;
        Tue, 20 Dec 2022 19:59:58 -0800 (PST)
Received: from [10.89.80.120] (c02drav6md6t.dhcp.fujisawa.hgst.com [10.89.80.120])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NcKTS3G3Lz1RvLy;
        Tue, 20 Dec 2022 19:59:56 -0800 (PST)
Message-ID: <4ff0ca00-31f5-2867-ff59-cecb5d6d1048@opensource.wdc.com>
Date:   Wed, 21 Dec 2022 12:59:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [PATCH] scsi: libsas: Grab the host lock in
 sas_ata_device_link_abort()
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>,
        John Garry <john.g.garry@oracle.com>,
        Xingui Yang <yangxingui@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, niklas.cassel@wdc.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, prime.zeng@hisilicon.com,
        kangfenglong@huawei.com
References: <20221220125349.45091-1-yangxingui@huawei.com>
 <4ec9dbed-1758-d6b4-dc1d-ac42e8c22731@oracle.com>
 <c8387766-2ca0-51f3-e332-71492b13e5c1@opensource.wdc.com>
 <7347d117-6e0b-dd18-90a8-25685f757689@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <7347d117-6e0b-dd18-90a8-25685f757689@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/12/21 11:42, Jason Yan wrote:
> On 2022/12/21 8:36, Damien Le Moal wrote:
>> On 2022/12/20 23:59, John Garry wrote:
>>> On 20/12/2022 12:53, Xingui Yang wrote:
>>>> Grab the host lock in sas_ata_device_link_abort() before calling
>>>
>>> This is should be the ata port lock, right? I know that the ata comments
>>> say differently.
>>>
>>>> ata_link_abort(), as the comment in ata_link_abort() mentions.
>>>>
>>>
>>> Can you please add a fixes tag?
>>>
>>>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
>>>
>>> Reviewed-by: John Garry <john.g.garry@oracle.com>
>>>
>>>> ---
>>>>    drivers/scsi/libsas/sas_ata.c | 3 +++
>>>>    1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
>>>> index f7439bf9cdc6..4f2017b21e6d 100644
>>>> --- a/drivers/scsi/libsas/sas_ata.c
>>>> +++ b/drivers/scsi/libsas/sas_ata.c
>>>> @@ -889,7 +889,9 @@ void sas_ata_device_link_abort(struct domain_device *device, bool force_reset)
>>>>    {
>>>>    	struct ata_port *ap = device->sata_dev.ap;
>>>>    	struct ata_link *link = &ap->link;
>>>> +	unsigned long flags;
>>>>    
>>>> +	spin_lock_irqsave(ap->lock, flags);
>>>>    	device->sata_dev.fis[2] = ATA_ERR | ATA_DRDY; /* tf status */
>>>>    	device->sata_dev.fis[3] = ATA_ABORTED; /* tf error */
>>>>    
>>>> @@ -897,6 +899,7 @@ void sas_ata_device_link_abort(struct domain_device *device, bool force_reset)
>>>>    	if (force_reset)
>>>>    		link->eh_info.action |= ATA_EH_RESET;
>>>>    	ata_link_abort(link);
>>
>> Really need to add lockdep annotations in libata to avoid/catch such bugs...
>> Will work on that.
> 
> Actually in libata there are many places calling ata_link_abort() not 
> holding port lock. And some places are holding the real host 
> lock(ata_host->lock) while calling ata_link_abort(). So if you add the 
> lockdep annotations, there may be too many warnings. If these are real 
> issues, we should fix them first.

libata-EH does most of its work without the port lock held because by the time
we get EH started, we are guaranteed to be idle with no commands in flight. That
is why the calls you mention look like "bugs" but are not.

lockdep annotation will be a little tricky, but not too hard to do either.

> 
> Thanks,
> Jason

-- 
Damien Le Moal
Western Digital Research

