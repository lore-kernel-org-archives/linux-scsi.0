Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 299A1C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 04:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0038561546
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 04:54:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237985AbhKPE5x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 23:57:53 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:47587 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238260AbhKPE5b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2021 23:57:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637038475; x=1668574475;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=RvdTMa1iisvKvKOdjw+8hb89Op85a9RC9y3ufNV9UHo=;
  b=Ln3bEM87NPr3iO89FLF2laFisZzWL6llSsRCqyFlAD6gbD1XxrCbjwNx
   M0QeVVq9vdqSXwIgWdFV/nUSXv6vxlwiMVvSLolH6v0Z7GITeWyx3zxoc
   loksrTYdFxJFti5yPfqNnja+y6HVctbjTwDpkGSnYpNb605558z6srY0b
   uDY7dOxI82EC2xBEC6XAD+3JIhm1DLYSd0BPZL5HU3jAheChwMnDERK3P
   EYJBeJ1ER738+dW2mlfncm3I7ivooJ9XidpqyLsauRpwVH4KdJzYr1Wn1
   cqTlfdemn9aIUfT1yWizxbMpiEcCXB0ZQB5sYwlaY4u4DRSefmaoMtmD9
   g==;
X-IronPort-AV: E=Sophos;i="5.87,237,1631548800"; 
   d="scan'208";a="289635314"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Nov 2021 12:54:32 +0800
IronPort-SDR: rz7ljM4awTm/GBZn66yWd48gIJnOpBHb9drv7y3/0POC1LgCvAn5GuCuq8crpMNAYfVoG9XNkg
 cLXoHEdbo9y/TfrV5/xty7pP5iEUYYA4PwpAx9XkAC6HYYjGW4lVfcce5ftbyHm7xT6kCxYY5S
 VRkSftoDbxaNZMYg5HAy9aDBiaSm4ui2UWG8QSXKCMBTySTvfl5gPSLeiXmR4bYxE9adrh+WOb
 Fs7qal21luGWTQZCB+YkO5uM0LCuuPNCDJy1v4wuQwWxSDyjKH9TttphVIHwnMCpH6ONqnoosL
 uGYn9O7JHs3O7yIFpsvXlFMf
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 20:29:36 -0800
IronPort-SDR: Rjz5qmDi99l00VccTEX9jC993es1bnhzhkEpugKjBitWV0hmy2JPz9gVx5sWk0NHpXuaCqNYU7
 iEIpr8jifawkN4wp7QbgNwLA/N+WPhDe7FfZB/9yhCk/WNBuHfWW3LjHawXR/dhU2FFlj97PyW
 vdPCHszQW5bw5ZKmJYSk4iNK0/z94puDSbP5OhHpmmJjjs64SRVXsTunTJs1QXYVt9B3Mk+4dQ
 7vXmuwFxHtM0f6Cl7pXFf6prrNQjRWRETapLSJMZuh1cYfq3DNPqccJe6oRttCUzSOPJb1LxFz
 pvk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 20:54:33 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HtYd44RFwz1RtVn
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 20:54:32 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1637038472; x=1639630473; bh=RvdTMa1iisvKvKOdjw+8hb89Op85a9RC9y3
        ufNV9UHo=; b=KQMOcrOtEu1HhQC/LYpECwhfUjBJ2bb1Jc0jErp6CwDVH7WwUsN
        lwAXcbX/HtncxH1s3mLxP5j0Qyw/iaXZZ2avC5OsKnpbltePvQfgmgfBfOt9yTjj
        2DK1wrRaRewLbKWTHnsdi9yCkJ4SI1KrZja7wxFWgxTZEz3zLOgJVealbafmhlTk
        j8kuSkXnEJtyz3v9StFNbTS7SycTYlPHiiE2/bE9jiFcEZskaxMvhYrO7ot5IfMY
        8d7aAKBw0kImR6wlmidtXPWKanYQOUxuuUVmtK1juuNFraR+Ve0/gl0PiHlMN1eB
        0EzYoMh8AK2ZLUIPfkoFSoskzjk5Tj6x9bA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Ne0qaGFefHpZ for <linux-scsi@vger.kernel.org>;
        Mon, 15 Nov 2021 20:54:32 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HtYd322mjz1RtVl;
        Mon, 15 Nov 2021 20:54:31 -0800 (PST)
Message-ID: <73bf2d9e-6c9c-305b-b5b3-0ecae66140f0@opensource.wdc.com>
Date:   Tue, 16 Nov 2021 13:54:29 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH] scsi: simplify registration of scsi host sysfs attributes
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Steffen Maier <maier@linux.ibm.com>
References: <20211115092922.367777-1-damien.lemoal@opensource.wdc.com>
 <52cea40c-1de2-9742-168a-c8ff0a29f0bf@acm.org>
 <00694cf2-b6d6-fd40-2d80-a36d306302b9@opensource.wdc.com>
 <6a548678-cd7b-f132-76cc-c3e5241f6c52@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <6a548678-cd7b-f132-76cc-c3e5241f6c52@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/11/16 13:22, Bart Van Assche wrote:
> On 11/15/21 19:29, Damien Le Moal wrote:
>> On 2021/11/16 11:18, Bart Van Assche wrote:
>>> On 11/15/21 1:29 AM, Damien Le Moal wrote:
>>>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>>>> index 8049b00b6766..c3b6812aac5b 100644
>>>> --- a/drivers/scsi/hosts.c
>>>> +++ b/drivers/scsi/hosts.c
>>>> @@ -359,6 +359,7 @@ static void scsi_host_dev_release(struct device *dev)
>>>>    static struct device_type scsi_host_type = {
>>>>    	.name =		"scsi_host",
>>>>    	.release =	scsi_host_dev_release,
>>>> +	.groups =	scsi_sysfs_shost_attr_groups,
>>>>    };
>>>
>>> Many SCSI LLDs use class_to_shost() to convert a device pointer into a SCSI host
>>> pointer. This patch makes the use of that macro very confusing since the SCSI
>>> host class is no longer involved in attribute registration.
>>
>> OK. But at least I think we should fix this:
>>
>> WARN_ON_ONCE(j >= ARRAY_SIZE(shost->shost_dev_attr_groups));
>>
>> to change it into:
>>
>> if (WARN_ON_ONCE(j >= ARRAY_SIZE(shost->shost_dev_attr_groups)))
>> 	shost->shost_dev_attr_groups[j] = NULL;
>>
>> to guarantee that the attribute groups array is NULL terminated, as it should
>> be. This will ensure that we do not end up with a kernel crash when a buggy
>> driver is loaded. No ?
> 
> Hi Damien,
> 
> Please take a look at 
> https://lore.kernel.org/linux-scsi/ab1a9bfd-c1d2-e101-a9f3-f969ed3d1cad@acm.org/. 
> That patch removes the WARN_ON_ONCE() statement entirely.

Looks good !

> 
> Thanks,
> 
> Bart.
> 


-- 
Damien Le Moal
Western Digital Research
