Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C3CC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 13:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350464AbiBKNOM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 08:14:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbiBKNOL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 08:14:11 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A839B7F
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 05:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644585249; x=1676121249;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=3oiDowETOhHDdS6JM/+3v/bVSFXLzEyYiDqsHmQBfb0=;
  b=JbvWIdR8Rfm5TRIB5RbfypLg6tjcpyVkrzZXRq1u0wjCddbUA7isurBQ
   dZDWaCI1QlbVlFYXwgNsSU9wzccuqOqdFzP74DKAObCnI4ppqb2SC0pzl
   VPkEpmuZ+S7509hblGanQ3b/ICktlva18ozWFPiqoQpICoB9WuYLuMOhv
   nax2xZUi7KtftDbwk4kNVLxMDIZdhl4CAjr9W19dSevM1ZCrRCxm13ivF
   hMKhXTioaXG4C3mP+QFsxXqzfrssYY+s/xuvbry0h1udceLtKQPlWiFAU
   f7w8u9X3hOnzVk7SdVvD+QxRyaJjGYT2Otfk0sOofP1hWRklaR9IUpgom
   A==;
X-IronPort-AV: E=Sophos;i="5.88,361,1635177600"; 
   d="scan'208";a="192693223"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 21:14:09 +0800
IronPort-SDR: uBXsiDi9g+wMrVbjT6VMGDm56k07slr9h2QGTixh7/4T7BQckcnIUHlNkxVHLLLkEnm4QU4v+p
 U6S7JoMWW25OvTCibGWS1ICd9miLxAiU1dvemV1bBkFYCqunEQPUo5fKWFXm58S0T/uHAlY1YH
 ZjV90TiQJTIBDC9IpkEjGF22nXaTWvg3UDsj2+XolmzMTtxSn/4Oe6TffXYiR9UaqbyrT0EXBr
 3HPtDPyINdtmdf8HTASdo+LR5imumcLTU/keXiz6DNHj6NZZlAQ1QPI0wPRYGfCtIPFn9Jxp8R
 nDkT1SIP5no1la+NugbrlZSr
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 04:47:05 -0800
IronPort-SDR: KRnEDWHjDqsI+bXi2StLX1H0Ss29XGCrGpwq/3TKQSsanofX95PSWr1hncJ7KNaLOLPciny5D/
 xKL+mYlAnm55AO1WlS6IqssQLBG44ds2BWXcdjQ/xpYVnrYS+yO8yCjKBwP0/5tDLeKVDuQn/C
 nYZj9usmvZBrDW17gFu2Sbp1o/QGBV9VQLr5++0WNRzOsUhpCoHdYoLNoAOCGkwWm+T/R9BGIa
 +dqHjxADA2FOsjZv8ANxzcoig4+qhRkiwvWfHGWUMLisJ2yU2xYWaoy74S6Kum6wHALy6KP37k
 sA4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 05:14:11 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JwDbQ3XbQz1SVnx
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 05:14:10 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644585250; x=1647177251; bh=3oiDowETOhHDdS6JM/+3v/bVSFXLzEyYiDq
        sHmQBfb0=; b=FaIKmbLEoIERaS4euDEMIlhIOQ6PHZKfqkN5/r564nZeN3eCJtX
        0/LvBqy6W9rd6IUKH/vr7kvCY0B+8V217ANUtOC1YDI1zN7Gxwf1Lu5f6ncIwlAr
        sin7pq2M1sQgGs5QWP5y196vTztEYr43pHt7/RwRyUDMwOS96N2O9VqnKvkngl4W
        lbjGM5PXt6N+ZalGL2vyhhZmMzMsL/bShG2pAq5kgAf+j1HfbIQNMygYp021llfI
        l0imGTOBhnlXAUfIfT/ctfB3fLLBwaEStvpB8EkYugMaxn+U8nNndYtqOJ1EzPdb
        EQODHFuUQCyK31Ph6kNBuYatc5RoVFKBlcg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Rmzq7pQca8BQ for <linux-scsi@vger.kernel.org>;
        Fri, 11 Feb 2022 05:14:10 -0800 (PST)
Received: from [10.225.163.67] (unknown [10.225.163.67])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JwDbP1sK8z1Rwrw;
        Fri, 11 Feb 2022 05:14:09 -0800 (PST)
Message-ID: <811ad0fb-9fc9-fac3-be78-f2d4d630c378@opensource.wdc.com>
Date:   Fri, 11 Feb 2022 22:14:07 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 00/20] libsas and pm8001 fixes
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
 <b3efd3cf-e36b-9594-06b8-9772bb525e00@huawei.com>
 <ea6b25db-d4da-bab5-8bf2-ec5024c95f89@opensource.wdc.com>
 <af3b0aff-3e43-5a1f-0d98-f68b9100090e@huawei.com>
 <db9c1fb7-bc0b-5742-c856-4b739bdfec39@opensource.wdc.com>
 <f4130aa7-fc02-f71a-7216-9a9f922278bf@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <f4130aa7-fc02-f71a-7216-9a9f922278bf@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/22 22:08, John Garry wrote:
> On 11/02/2022 12:37, Damien Le Moal wrote:
> 
> Hi Damien,
> 
>>> Sometimes I get TMF timeouts, which is a bad situation. I guess it's a
>>> subtle driver bug, but where ....?
>> What is the command failing ? Always the same ? Can you try adding scsi
>> trace to see the commands ?
> 
> This is the same issue I have had since day #1.
> 
> Generally mount/unmount or even fdisk -l fails after booting into 
> miniramfs. I wouldn't ever try to boot a distro.

busybox ?

> 
>>
>> If you are "lucky", it is always the same type of command like for the
>> NCQ NON DATA in my case.
> 
> I'm just trying SAS disks to start with - so it's an SCSI READ command. 
> SATA/STP support is generally never as robust for SAS HBAs (HW and LLD 
> bugs are common - as this series is evidence) so I start on something 
> more basic - however SATA/STP also has this issue.
> 
> The command is sent successfully but just never completes. Then 
> sometimes the TMFs for error handling timeout and sometimes succeed. I 
> don't have much to do on....

No SAS bus analyzer lying in a corner of the office ? :)
That could help...

I will go to the office Monday. So I will get a chance to add SAS drives
to my setup to see what I get. I have only tested with SATA until now.
My controller is not the same chip as yours though.

> 
>> Though on mount, I would only expect a lot of
>> read commands and not much else.
> 
> Yes, and it is commonly the first SCSI read command which times out. It 
> reliably breaks quite early. So I can think we can rule out issues like 
> memory barriers/timing.
> 
>   There may be some writes and a flush
>> too, so there will be "data" commands and "non data" commands. It may be
>> an issue with non-data commands too ?
>>
> 
> Not sure on that. I guess it isn't.

Anything special with the drives you are using ? Have you tried other
drives to see if you get lucky ?

> 
> Thanks,
> John


-- 
Damien Le Moal
Western Digital Research
