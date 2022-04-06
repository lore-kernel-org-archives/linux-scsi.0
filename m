Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067A9C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 12:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbiDFM0K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 08:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiDFMZp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 08:25:45 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24951F1D2A
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 01:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649232622; x=1680768622;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=W+sQyQXwqNPtg3DW2PfzXKmUropifws/e8bOcPZZ7OU=;
  b=eDM2M1h4UUAVtGziruY5rfORVrbXeJygti9RBD/3tVJvyHdE7L5XEj8N
   Qhl48VVOQWynpfH4yxOS3VYEeOuENr/mA+0wU4GEEQfv4hjECgO8wIEhG
   9FAwc80U4aVysLpq2SWLt6ukzqCqgF86+Zb3/j8k5Sl90zFlSyu2JH0Io
   6tvn84BzHATV6s5pzT/Gee/xtjSuH/w/fTXSqKQ9coMeJMhtH5/Te2GsP
   V0z28pJXPTkEQqtRusn4eqVDFhKhPIo55jIEGBI9fADdb+N6x1WOwsIlJ
   x27+3uLtxRvWmbQ0mQ1G32diaOvrhL39Cf8nKszm0xFXBFqUFlEeIDMFD
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,239,1643644800"; 
   d="scan'208";a="198116345"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Apr 2022 16:10:18 +0800
IronPort-SDR: 8ofZMbhPiR65NCXJ5xYQoKE5p1DUFKdrzImQKR66zDGzL/G1MMbiYAto3HdtXEn/QfyoH/1AYb
 oNQclWRJEH7q9tFwC5eosYyD/X0N1bhtm4XYeT0fa/M9gRO/pZ01tHe7kcS6LNDbzOg7R3vij/
 lk74/XZhy1dlmuM4RVYvEj9z1f61wOydoFdEQng6rpp/eU6+iqA9+7/2dSg8zQeFLqjkBkHZAq
 Jhz8BlwxPOpeU+V1L7JV6CE8j9mCFazmIbRyqQNjHFvh4bm7v3OqTUA8suDvWAMIipD86DDSo0
 2xpFahA6yTV7Cs8HBBN3GS/i
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Apr 2022 00:40:59 -0700
IronPort-SDR: Ie7aronUBi8OHi4gLp45uejDRIiyL+fs6PP6QfNj447iQ0Q9a6atqi0Q4LiQctLZ81eV0f/lbV
 BwHSe6sNjl4b5Tffz/+Yja0njv00cGf4ZTIDucWnvnZUDcBwMgD5icSxvL3TTq78uB0A6y+tQG
 +fmBQ/vyCaIppeTos1wH0SqiXybHpvWeP2OBvFct6dqIs5VCvfsXF4Df09DCyICSuBSUGWsD3Y
 s5ovNaTQjB4hRkuP3gcZ123tVUn2ZeVInFqTJZpFzcVXkRICJc3FWPO6R6fPQLa45k5VeJrOxZ
 z8w=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Apr 2022 01:10:18 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KYHHs2DD9z1SVp2
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 01:10:17 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1649232617; x=1651824618; bh=W+sQyQXwqNPtg3DW2PfzXKmUropifws/e8b
        OcPZZ7OU=; b=YQpi7rLri1JG8XMjZHACizTwCyxZucyFzTVIa6q/pXJHX/VwfZL
        5/ck+u3ezTbic3d0dSGYS/t6Bp38bTvEUWQKalhsi5cjvvJWghH1WbITQmU53F2A
        AMsQKOmzk2teRM+FEsFdJoyFGv9TpHcuRkM2O/wcgAy3m9GBEAl27mnJMxuI37b5
        p5r+o4vzDlkb/8p5szFdbFxke+gFSGkokDTNkiafPPE1a+R/MtdTduOSCdCxzmgY
        hVU5CGEln7gcX3tf8t4mW0j9BNhM0nL+M0U91O3pq2mQJdTVjMBKtOpiRQ55ivyn
        yoYvrlcXj10KR2HC7ffFADZ+CS3GxfPKBqQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id jkJMT_zIFVxf for <linux-scsi@vger.kernel.org>;
        Wed,  6 Apr 2022 01:10:17 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KYHHq6LY1z1Rvlx;
        Wed,  6 Apr 2022 01:10:15 -0700 (PDT)
Message-ID: <0c6c0c64-74f8-e15a-d79e-0866b5cc209d@opensource.wdc.com>
Date:   Wed, 6 Apr 2022 17:10:14 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 1/2] libata: Use scsi cmnd budget token for qc tag for
 SAS host
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, hch@lst.de
Cc:     linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-scsi@vger.kernel.org
References: <1649083990-207133-1-git-send-email-john.garry@huawei.com>
 <1649083990-207133-2-git-send-email-john.garry@huawei.com>
 <a3cce73f-2e91-309d-bee0-a34a30335a18@opensource.wdc.com>
 <ab6a13c1-90c4-63f0-c48d-c1faa0ae68fd@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <ab6a13c1-90c4-63f0-c48d-c1faa0ae68fd@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/6/22 16:12, John Garry wrote:
> On 06/04/2022 02:39, Damien Le Moal wrote:
>> On 4/4/22 23:53, John Garry wrote:
>>> For attaining a qc tag for a SAS host we need to allocate a bit in
>>> ata_port.sas_tag_allocated bitmap.
>>>
>>> However we already have a unique tag per device in range
>>> [0, ATA_MAX_QUEUE) in the scsi cmnd budget token, so just use that
>>> instead.
>>
>> The valid range is [0, ATA_MAX_QUEUE - 1]. Tag ATA_MAX_QUEUE is 
>> ATA_TAG_INTERNAL which is never allocated as a valid device tag but 
>> used directly in ata_exec_internal().
> 
> But that is what I have in [0, ATA_MAX_QUEUE), which is same as [0, 
> ATA_MAX_QUEUE - 1].

Oh ! I missed the ")" !
I would prefer an explicit [0, ATA_MAX_QUEUE - 1] to be clear :)

> 
> Thanks,
> john


-- 
Damien Le Moal
Western Digital Research
