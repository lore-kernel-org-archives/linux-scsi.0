Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD51C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Oct 2022 21:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiJEVVl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Oct 2022 17:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiJEVVj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Oct 2022 17:21:39 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33D75AC45
        for <linux-scsi@vger.kernel.org>; Wed,  5 Oct 2022 14:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1665004898; x=1696540898;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=rWsmTDbQWDKLjp3tIJzodQGMLcFM7p6n1EHIncapWFc=;
  b=KtB3j/4+hoq6SPdzJAcYQrFGUWihVPZ2T6kPjUnA4zVDr9o/lgZ3qI6Z
   82WIXb6/VYG4DoSJDNeIvz+pvxFAVUuD1I/iJJD+QV29rNg5ZB3BfwEio
   Z5abEODQz5wpoA8bG2Lw9TeEZhd5MW5j4r0Xx/+HBCV9TxTn2jVYlocqq
   ZFeU3pxE44eB1NDr8gf1sMNCuvFUN2S941EnEDDDM1uf0wrUOCXGHlRpQ
   Mv3xqIiIhEKZ6VaBoup8hI7JUX6Y6RCtJm7WIIgv9OHSsq/hPzvnbBSwz
   XQgxU4M/o+LYwyo8HS7m8XHloTCjmse+9juyrY4ERqNBkrW/C5xK4dQLr
   g==;
X-IronPort-AV: E=Sophos;i="5.95,162,1661788800"; 
   d="scan'208";a="213079187"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Oct 2022 05:21:38 +0800
IronPort-SDR: BAh9pkV08ZJ0BK2OvqCI5pHaqerE4r8UCyemu4iOsI/NxXAW8HYESC1U7u6Av1B0mWeHhgn5O8
 LZ5Voq3WLLgttJYmOcbffGmDqtBAy0DZ+8mkenCB1vcdCQHY2d35seWzHM1lfrnwiCKrZeiQWP
 BZQUIJR60ImpvlUBjT5UBcABk+lPTPd5yDVaArW56ew6exZf2owlKVU3VVLo77DM6QbrKtqHM/
 MxEd+ID/cNT4crEOAu4hQOwcLUlVwicn2o70VOA42yjmAyV9Etfq/HcFa0NGiul8ojkj9Nm8xv
 8nINbiyeJ7ELO7+0iSYLHlCd
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Oct 2022 13:41:24 -0700
IronPort-SDR: K5a8KLUrP9un90KybJWX30+AvnHUMvJMc/EqIvK3Vmvt1x0jigCOWp8RvXTkRRK9DOMZbzlpnq
 QuxsWPoKrGG133dsdrhfJzU1xcKXg4kam+kcB1T7Y5zKIKL6KZUhUMaBlmWWMtdvWn3NPIsJs2
 w+cJp4gIyEEGh8h/gBrxb/hRnm2FeF0mWUaZCn3Ed303rT7ENGjwSKmWQ9H2jppl5e5Hh9CVvY
 edWfSTN3Xyz8t0qWC/kQRC5gVWdOtVlFmBR4+pzEJS68hyTkVpSmjd/pJ9cljsxAEJpH2AHOqd
 c4c=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Oct 2022 14:21:38 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MjSDx6Jr4z1RvTr
        for <linux-scsi@vger.kernel.org>; Wed,  5 Oct 2022 14:21:37 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1665004897; x=1667596898; bh=rWsmTDbQWDKLjp3tIJzodQGMLcFM7p6n1EH
        IncapWFc=; b=KxPSCvpD+U5B4BPKgEf0KyUU6MLtTzLMNkyDFlcfOK3rX9exFR1
        2WACzQAcGXMAw7tZE0EeCBGiQ5aQd5LEfzwDxspQIjE9Jelkf/V4X407Keb7QHCw
        +NWEgFE1BgeoRyv/8bL7c40E1SzLUmcxvtea/yR0laVE9RQwPHsWd1vmuateRVLR
        NAiL9pcDLW6nVD6pzAY0lNBmNob2/Jb63Qd7hI7/mBrgiVUApjA8+9xIAtbuwCRX
        eSQYhxnUW8p30GVqOFb+xKDa9MJzBYK7OLKJJL9OtsdyTJYyNnHNHtOgaEFB6kvg
        YcGouu2X6uLtKD4wEf3TXKvYbRPhqd29GIw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 771J9c8AYJlz for <linux-scsi@vger.kernel.org>;
        Wed,  5 Oct 2022 14:21:37 -0700 (PDT)
Received: from [10.225.163.106] (unknown [10.225.163.106])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MjSDw27Bnz1RvLy;
        Wed,  5 Oct 2022 14:21:36 -0700 (PDT)
Message-ID: <9100d34c-26ab-fa19-15c6-cf626383cab1@opensource.wdc.com>
Date:   Thu, 6 Oct 2022 06:21:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: Do we still need the scsi IPR driver ?
Content-Language: en-US
To:     Brian King <brking@linux.vnet.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Brian King <brking@us.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <a5a3527c-d662-5bd1-e1dd-ad4930d10b3a@opensource.wdc.com>
 <3dbd9ae4-a101-e55d-79c8-9b3a96ab5b17@linux.vnet.ibm.com>
 <be79092f-fdd6-9f0f-4ffa-95ffc4b778c5@linux.vnet.ibm.com>
 <369448ed-f89a-c2db-1850-91450d8b5998@opensource.wdc.com>
 <dc892956-56bf-19aa-f206-b3bbcc781fea@huawei.com>
 <5f2efa8a-8207-403c-12e8-74f43d8d8a14@linux.vnet.ibm.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <5f2efa8a-8207-403c-12e8-74f43d8d8a14@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/6/22 02:20, Brian King wrote:
> On 9/20/22 8:07 AM, John Garry wrote:
>> On 21/06/2022 23:12, Damien Le Moal wrote:
>>>>> We still need it around for now. IBM still sells these adapters
>>>>> and they can still be ordered even on our latest Power 10 systems.
>>>> At one point I did look into modifying ipr to use an ->error_handler.
>>>> I recall I ran into some issues that resulted in this getting put
>>>> on the shelf, but its been a while. I'll go dig that code up and
>>>> see what it looks like.
>>> Thanks. It would be really great if you can convert to using
>>> error_handler. This is really the last ata/libsas driver that does not use
>>> this.
>>>
>>
>> Hi Brian,
>>
>> I am wondering if there is any update here?
>>
>> As you may have seen in [0], I think that we need to make progress on this topic first to keep the solution there a bit simpler.
>>
>> [0] https://lore.kernel.org/linux-scsi/1663669630-21333-1-git-send-email-john.garry@huawei.com/T/#mf890cb4f1627112652831524dca62cbde4a0a637
> 
> I've made some progress. I was able to dig up the code to move ipr to use error_handler
> and have gotten it to compile, but haven't gotten to trying it in the lab yet.

Great ! Thanks for doing that.

> 
> -Brian
> 
> 

-- 
Damien Le Moal
Western Digital Research

