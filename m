Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B6B7C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Feb 2022 06:19:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbiBLGT1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Feb 2022 01:19:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbiBLGT0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Feb 2022 01:19:26 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8995F2716D
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 22:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644646763; x=1676182763;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=MS6jIKZG/CGTuvzFb1UIhod7mxNMr2z3dkLA7SyXblw=;
  b=W0VtH8VA8weHZ+VjsmXu2APZnP1l61s/qEUwfIsxD4dGnQva1R0QvSdU
   TJoK2JjmulPF7e3SNVK4gqCNwnQM4rLbrHGCGlcMYR3xR/zDjoBUNZZSD
   gMlJ4uE4Zgvn0tUwXGNa+ngbKy+LLRFg+G5rYqx9ElcXFlDIZW9Yg8n5f
   uuygdULCknTB+3UPalu5wLUKK/fIfifT13tngs5yneyRVYMHnuLU1Y/uu
   Ib3OszoiFblmM5v3GHeRPcLXpiVRYV8f6xpl+XP6drAHpb1dr4xl9wbh/
   f9K+8I1pwgMKj5MqFzYfIBDESR7BQ9u9gffdDn17lJrMuntiKNCfwCgrm
   g==;
X-IronPort-AV: E=Sophos;i="5.88,363,1635177600"; 
   d="scan'208";a="304649429"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Feb 2022 14:19:23 +0800
IronPort-SDR: mAgJ4q37PelPTwRY2urV1Tjh7hgzvYZHCZV0CXEdVmucXrfloOEA4QVolMKBNFXoUbWCaUa1aY
 G3DHfjkzxlnFU0dziJtOx9A2xit6UBz91Oj4lcomW9xaS4pjNNcOcY8msNkItMg7L8YyqWAEas
 WM2TIAT4SqwqOnkXoeVCS4I7R7FwOb1y7CE1ra7wQsGW6zBt6CQa1Jy8PjucWSoIAXyiK1Bh7K
 Sg2//zZAJu3mhcmdoEaC1sfF8bKZf4I6pxMKKIe0REon4MNKaBo90MHFvVtVJ8MG10jqK2pCjW
 6ANAG6MlVP4PrOa9kosVaFDu
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 21:51:07 -0800
IronPort-SDR: rN6icWTBx1iZHxjxdT7kD1Xb1ubr8+QJuUwKU/I6AFO0C49O7EGtHR0SDRW3hcZ34LlbgonPRw
 FX2erMf+0c7cVYbXFCXmz4c6+2AHNv8IsX1r0p6TNCGCoBJES4NmTUSSrrPG8y5C3EIHzKFXzS
 o5VrXc3JOCu4mRJv8nf82tQZflG9HgAwFYTk2lU/pmWT6s0H9fB9vB2cjht+eiL2H74+3tb6sI
 2e5mbHErfA962+cH6mt2l7AqDBZXHSkuSi/4rbgLlZZP+tQmW+QKfOhO/SGAHvM0du76KHGW0p
 lqQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 22:19:23 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JwgLL4GtHz1SVp3
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 22:19:22 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644646761; x=1647238762; bh=MS6jIKZG/CGTuvzFb1UIhod7mxNMr2z3dkL
        A7SyXblw=; b=krx0B2REW0cANM7dZ6F+qSxsiztT4y4CsqReKRtYOMAkCPu5+3h
        mMsCBPu4XcfZpnLxrM3aX6j83L1OqCbcELC3hpHNQjnx1ukMuXr46fhtyiF3aHOn
        y6lI5ogAGQP8gGLHvhUSN7ZZU0uVZmLRtJyWKx5rWUqOzq9Zxxm74nc1d+dOJtZV
        jkdexuH5ke96x27t+i2wc1lPeZjXj3a+e76HOnsNX3Pq+BKWWxKGXbFUaQI6XyrY
        ey8nQW7BDdWiB53DUGzIkBGahml8Eo/Foqs3grr9xuKPTeS3KKgFbmIomLUEm8q5
        XTZoBK3MCV9hpKIEltdSRsFO72t6tp48Evw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id oBwiCIfj5eQF for <linux-scsi@vger.kernel.org>;
        Fri, 11 Feb 2022 22:19:21 -0800 (PST)
Received: from [10.225.163.67] (unknown [10.225.163.67])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JwgLJ702pz1Rwrw;
        Fri, 11 Feb 2022 22:19:20 -0800 (PST)
Message-ID: <c88ac83a-1f6a-ca76-68b3-7fde0db42893@opensource.wdc.com>
Date:   Sat, 12 Feb 2022 15:19:19 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 00/20] libsas and pm8001 fixes
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>, Ajish.Koshy@microchip.com
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
 <b3efd3cf-e36b-9594-06b8-9772bb525e00@huawei.com>
 <ea6b25db-d4da-bab5-8bf2-ec5024c95f89@opensource.wdc.com>
 <af3b0aff-3e43-5a1f-0d98-f68b9100090e@huawei.com>
 <db9c1fb7-bc0b-5742-c856-4b739bdfec39@opensource.wdc.com>
 <f4130aa7-fc02-f71a-7216-9a9f922278bf@huawei.com>
 <811ad0fb-9fc9-fac3-be78-f2d4d630c378@opensource.wdc.com>
 <272a19b3-b5d7-f568-83d2-867a07def721@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <272a19b3-b5d7-f568-83d2-867a07def721@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/22 22:54, John Garry wrote:
> Hi Damien,
> 
>>>
>>>>> Sometimes I get TMF timeouts, which is a bad situation. I guess it's a
>>>>> subtle driver bug, but where ....?
>>>> What is the command failing ? Always the same ? Can you try adding scsi
>>>> trace to see the commands ?
>>>
>>> This is the same issue I have had since day #1.
>>>
>>> Generally mount/unmount or even fdisk -l fails after booting into
>>> miniramfs. I wouldn't ever try to boot a distro.
>>
>> busybox ?
>>
> 
> Yes
> 
>>>
>>>>
>>>> If you are "lucky", it is always the same type of command like for the
>>>> NCQ NON DATA in my case.
>>>
>>> I'm just trying SAS disks to start with - so it's an SCSI READ command.
>>> SATA/STP support is generally never as robust for SAS HBAs (HW and LLD
>>> bugs are common - as this series is evidence) so I start on something
>>> more basic - however SATA/STP also has this issue.
>>>
>>> The command is sent successfully but just never completes. Then
>>> sometimes the TMFs for error handling timeout and sometimes succeed. I
>>> don't have much to do on....
>>
>> No SAS bus analyzer lying in a corner of the office ? :)
>> That could help...
> 
> None unfortunately
> 
>>
>> I will go to the office Monday. So I will get a chance to add SAS drives
>> to my setup to see what I get. I have only tested with SATA until now.
>> My controller is not the same chip as yours though.
> 
> jfyi, Ajish, cc'ed, from microchip says that they see the same issue on 
> their arm64 system. Unfortunately fixing it is not a priority for them. 
> So it is something which arm64 is exposing.
> 
> And I tried an old kernel - like 4.10 - on the same board and the pm8001 
> driver was working somewhat reliably (no hangs). It just looks like a 
> driver issue.
> 
> I'll have a look at the driver code again if I get a chance. It might be 
> a DMA issue.

There is one more thing that I find strange in the driver and that may
cause problems: tag 0 is a perfectly valid tag value that can be
returned by pm8001_tag_alloc() since find_first_zero_bit() will return 0
if the first bit is 0. And yet, there are many places in the driver that
treat !tag as an error. Extremely weird, if not outright broken...

I patched that and tested and everything seems OK... Could it be that
you are not seeing some completions because of that ?

I added the patch to my v3. Will send Monday.



-- 
Damien Le Moal
Western Digital Research
