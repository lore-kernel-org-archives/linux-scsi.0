Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70266C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Nov 2022 02:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbiKNCzs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Nov 2022 21:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbiKNCzr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Nov 2022 21:55:47 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF1612AD5
        for <linux-scsi@vger.kernel.org>; Sun, 13 Nov 2022 18:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668394546; x=1699930546;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GrlF25BMv/hgnxgz6AZMps3j8TAv++lebXrWmxtOd1w=;
  b=kIvP/qXH8gbTzljp6Lc/3+HdfJX08m2in7i7Xmgd2QBCpWBtkrTUXeqA
   f2ZCm7dyh78zB4h8axNUc7RhpcXFHoa8ed0SpjuMBNA2f/BaqDuXCYr62
   +LZprbRJhwB50CQx6VueMpDGU7k2awURBIWWf9PLxVnOXmV/I/dBBM0op
   DXoZw29ekA6etd4tVXMU9Y8rk3W5AhsTLVsajdGLla1+APm6pZh6YzOtR
   NAbRaDJjw8vYbsOAtNa/B0mbN2+ipVVP7GB/WNjZsjvdXoopxRgpMZBAG
   JZjPoMGxC+hxnmn6FTNs9z3IRsbW7l62cyy3YXDM+GsCvUkWmYbNgUarl
   w==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665417600"; 
   d="scan'208";a="320524910"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2022 10:55:45 +0800
IronPort-SDR: Rw394ttdhB+wjj2kieYI1qo2pkfiVMQu3ooJQXD8JfJr52vlPdKxARhwSIDmpCFz1eKdWIGKoU
 WhuoVkcfukKJY63r0d2UXvs2LIusOvH60pv+v/aRZ/02Uq3QK7MIFM0g04Bf7x30WkBm+f10W7
 fpzojs3bmZVtRM0+SfSdz+5FebYtQsTSUBbcBJT/iIgWUhk7vyClat5LwFdsa8T6f/PoYAt6+H
 Iu9xgqPK8Rw5UPXE0GFhMmQ3CDw4sPN5yxPEPF9ivwM7NWx4rEPLu+4MxB9AJ6z3t6pptJpvLm
 578=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Nov 2022 18:08:59 -0800
IronPort-SDR: BBk/tY7c3MylBcEma6VkFXPqQV0haNaDItT+YjzUL5uo3tahH+j5/lkA+Ax2vAwYiKuOhujMN0
 eBoZGxquyYVLIEqjnzWpkHKKNE5B0igc/DUT6tmjGBCnMf67U13PcgC4bTkHLfbMfHqe58K6pH
 S2O6wpzPKMZfo0bCJ/D7cYsYmSW8CMOFb/9oqBIrVrw+KkIMmsuFZz9TeyOCtyBHdjoHSf++5a
 XRLg7C8FPa5yaK2CfPyu64ydvz0xNvclMP5XX86CTM4adwKTBpY+5tNYdCg8kdjIFW2KwtQJzO
 fMY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Nov 2022 18:55:45 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4N9YpS6HVBz1RwtC
        for <linux-scsi@vger.kernel.org>; Sun, 13 Nov 2022 18:55:44 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1668394544; x=1670986545; bh=GrlF25BMv/hgnxgz6AZMps3j8TAv++lebXr
        WmxtOd1w=; b=RzonFaNZnTq55HTs2Ozddrx3kdQt4T+uPDGp3y3MecYScGa9Z3u
        0prISRMudR9dN03iYCJ7fHb9jMvOhCdwZNtfvfNqnYDA38EQ1Se5JZ6sb7Zmo8jV
        I5mvNlEQK6D++xmF2NdYFD7+USm7BVv6z7848++drs//Dnm1c/bRZB47PnirVztE
        3RcaBL9Kzl/3EkQSYlGQLVO1Ruw3tII7AzLoGFdRPp78mUvTIByQKj5atsTXtGCq
        uCCJiQQl5bWCAH/rUYrSSGvtoCjg7hxRrTcD3I9tOku2wMhPTMrtZGTHdBU/Cj9P
        0/g8oufSMhRep8/tKVo/gc7CMdwKvlbk1lg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id M7E-_kR0KKRJ for <linux-scsi@vger.kernel.org>;
        Sun, 13 Nov 2022 18:55:44 -0800 (PST)
Received: from [10.225.163.46] (unknown [10.225.163.46])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4N9YpR1vl2z1RvLy;
        Sun, 13 Nov 2022 18:55:43 -0800 (PST)
Message-ID: <26615b48-a20f-1db3-8dba-4de05f260d86@opensource.wdc.com>
Date:   Mon, 14 Nov 2022 11:55:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [RFC PATCH 0/5] scsi:scsi_debug:Add error injection for single
 lun
Content-Language: en-US
To:     dgilbert@interlog.com, Wenchao Hao <haowenchao@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221109155950.3536976-1-haowenchao@huawei.com>
 <58472d12-c1e4-59f3-bb37-a98db17ef2ba@interlog.com>
 <50e1411a-54c4-d9d2-7567-2388219c5bb1@opensource.wdc.com>
 <c9106b58-677b-31e3-5c4e-5cbef5b1fe63@interlog.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <c9106b58-677b-31e3-5c4e-5cbef5b1fe63@interlog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/14/22 11:54, Douglas Gilbert wrote:
> On 2022-11-13 19:30, Damien Le Moal wrote:
>> On 11/14/22 06:48, Douglas Gilbert wrote:
>>> On 2022-11-09 10:59, Wenchao Hao wrote:
>>>> The original error injection mechanism was based on scsi_host which
>>>> could not inject fault for a single SCSI device.
>>>>
>>>> This patchset provides the ability to inject errors for a single
>>>> SCSI device. Now we supports inject timeout errors, queuecommand
>>>> errors, and hostbyte, driverbyte, statusbyte, and sense data for
>>>> specific SCSI Command
>>>>
>>>> The first patch add an sysfs interface to add and inquiry single
>>>> device's error injection info; the second patch defined how to remove
>>>> an injection which has been added. The following 3 patches use the
>>>> injection info and generate the related error type.
>>>>
>>>> Wenchao Hao (5):
>>>>     scsi:scsi_debug: Add sysfs interface to manager single devices' error inject
>>>>     scsi:scsi_debug: Add interface to remove injection which has been added
>>>>     scsi:scsi_debug: make command timeout if timeout error is injected
>>>>     scsi:scsi_debug: Return failed value for specific command's queuecommand
>>>>     scsi:scsi_debug: fail specific scsi command with result and sense data
>>>>
>>>>    drivers/scsi/scsi_debug.c | 295 ++++++++++++++++++++++++++++++++++++++
>>>>    1 file changed, 295 insertions(+)
>>>
>>> Hi,
>>> This patchset seems to assume all scsi_debug devices will be disk (-like) SCSI
>>> devices. That leaves out other device types: tapes, enclosures, WLUNs, etc.
>>>
>>> Have you considered putting these device specific additions under:
>>>      /sys/class/scsi_device/<hctl>/device/error_inject/
>>> instead of
>>>      /sys/block/sdb/device/error_inject/
>>
>> But these are the same, no ?
>> At least on my Fedora box, I see:
>>
>> /sys/block/sdp/device/ being
>> /sys/devices/pseudo_0/adapter0/host19/target19:0:0/19:0:0:0
>>
>> and /sys/class/scsi_device/19:0:0:0/device being
>> /sys/devices/pseudo_0/adapter0/host19/target19:0:0/19:0:0:0
> 
> Well the patch descriptions are all in terms of /sys/block/sd<letter>/
> which will not exist if scsi_debug is called like this:
>    $ modprobe scsi_debug ptype=1
> 
> That creates a pseudo host with an attached (virtual) tape drive. If
> the patchset works for other peripheral device types (i.e. that don't
> use the sd driver) then the description should at least mention the
> more general case (i.e. /sys/class/scsi_device/<hctl>/device ) IMO.

Got it.

> 
> Doug Gilbert
> 

-- 
Damien Le Moal
Western Digital Research

