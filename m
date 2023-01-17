Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE5E7C6379F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 08:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235924AbjAQIHd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 03:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235874AbjAQIHc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 03:07:32 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F45D9EE7
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2023 00:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673942851; x=1705478851;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=h+hpWb1N2z+sU/R5W+ZfOI5VrXzlmlexOMQc9+gqGoI=;
  b=aCe92Oojlmazj85baieTc7hNbJy1rAWwk2rMntiqFMDQEvnM+S7a4C6h
   GvGb39te+JGcVn/kjIrHr1Zb9d+68GZzOb7qTN587NgjGZ8E7eA7AMiJ8
   M5RAa9+ORwDX7TZU5+OeOlTwBHqW6Ptt7USC9KtuWOp/R+0yumURl5BJh
   dSdE+fcw8M4pYQq9i06ODtRv4pqLnzjH2+cyg+tInp7kBiIfykwG/gt/s
   1i6pZUxPF8JF12BGulZop5RQjqvnMZkfxBpxr/QEvb5RPpFdNXnKcBE3j
   lDMan/bPZBYPjl3GXxNmLWRKEvPUKJjyess8osklhmeIrhVRq0oEl3dVB
   g==;
X-IronPort-AV: E=Sophos;i="5.97,222,1669046400"; 
   d="scan'208";a="219318753"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jan 2023 16:07:29 +0800
IronPort-SDR: BFhjNGGrFbrYzjtGrkr8khj1GuKg/x43uZKgzVuqK/U/x/l4smR0DySA57jVx8zQSysOFWWuZt
 DEvd0ZC1RbPM1ncFLaFB1mFliODPFEujzyT3gNTrkcZkuw3EQfZLuJTJvx3qgyoRxOgvpPssbq
 4i1gdjtdoZyQ9OeqFPZsE4FN6grJDmlAr9f3fhu9s0NlerQpxOCwGAhbCtQHGJwcAv0qBTsyZp
 C/TiUFdrkPum+GSJIJbj1T9Aq2+ZC1yD7neoG2fKzw8Er3Ptr5M+ACX8fzLRIIju5XePhFxO6m
 TYs=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Jan 2023 23:24:43 -0800
IronPort-SDR: NxYzTuFwX8GP7ReMv9AT92KhGKmIXUoGghg1F1p8FUog+lND2OEnCJ1yaizSk1Ov1yzo6Uu4dn
 YRIBYvLsZmGHn10ktl5DFWzjhm4N4n4RZibHl0BGHQs7GCL4vGMr6A40QlVRL/AeF037VZt49L
 j418UmVhsWhMq7X92FMkjT5XBLFh3kc2iTDIjfInUSmK6z4P3oOk5aT6YPMg9WDfyc+04CBv+B
 r1P10EzDblledX3BC9N99IKyjl1v+HGaQMtzFxl+atpiCDGLNxvJzMTW9lh1Eq3K7wOW38jmrP
 3GA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Jan 2023 00:06:56 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Nx1gz1xbhz1Rwt8
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2023 00:06:55 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1673942814; x=1676534815; bh=h+hpWb1N2z+sU/R5W+ZfOI5VrXzlmlexOMQ
        c9+gqGoI=; b=iHt7q5R6/sEMGvZ/mKYvjSUXdc8Z2SGxfcYpbOLKOwiR4XeNv9Y
        s/1MJEBcguILOW5Pr0FX4Ip2j/8KPCrzLLqsaZVyApGBIUTo1gPEnLr2zLanV1Z6
        K/FK/xqBF6hqu/1WIWobJ5gyFZ8pdaVpmKAq/o2qbzDL8ajfBt2vGMUMl6DKzY37
        f9rsI4zDi2hBL9uJVFximnJ08YMeCcWHnppHghhV285D0lTlGJ5zJmIY+6DXaXva
        +9SNheIQ2i/Q9r2n7GnV1C7ODQ45P7IuMCyWuAxnrTvnCjaL0xNl7fXScqSOuxMi
        7bz+QUbVMBbidxXD2JhHnooxMOU+8+FgVMQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id igKhEh-MrC7M for <linux-scsi@vger.kernel.org>;
        Tue, 17 Jan 2023 00:06:54 -0800 (PST)
Received: from [10.225.163.30] (unknown [10.225.163.30])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Nx1gx2ppjz1RvLy;
        Tue, 17 Jan 2023 00:06:53 -0800 (PST)
Message-ID: <2bd49412-de68-91d3-e710-0b24fed625d2@opensource.wdc.com>
Date:   Tue, 17 Jan 2023 17:06:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 07/18] block: introduce duration-limits priority class
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>,
        Niklas Cassel <niklas.cassel@wdc.com>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
 <20230112140412.667308-8-niklas.cassel@wdc.com>
 <Y8ZNftvsEIuPqMFP@infradead.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <Y8ZNftvsEIuPqMFP@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/17/23 16:25, Christoph Hellwig wrote:
> On Thu, Jan 12, 2023 at 03:03:56PM +0100, Niklas Cassel wrote:
>> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>>
>> Introduce the IOPRIO_CLASS_DL priority class to indicate that IOs should
>> be executed using duration-limits targets. The duration target to apply
>> to a command is indicated using the priority level. Up to 8 levels are
>> supported, with level 0 indiating "no limit".
>>
>> This priority class has effect only if the target device supports the
>> command duration limits feature and this feature is enabled by the user.
>> In BFQ and mq-deadline, all requests with this new priority class are
>> handled using the highest priority class RT and priority level 0.
> 
> Hmm, does it make sense to force a high priority?  Can't applications
> use CDL to also fore a lower priority?

They can, by using a large limit for "low priority" IOs. But then, these
would still have a limit while any IO issued simultaneously without a CDL
index specified would have no limit at all. So strictly speaking, the no
limit IOs should be considered as even lower priority that CDL IOs with
large limits.

The other aspect here is that on ATA drives, CDL and NCQ priority cannot
be used together. A mix of CDL and high priority commands cannot be sent
to a device. Combining this with the above thinking, it made sense to me
to have the CDL priority class handled the same as the RT class (as that
is the one that maps to ATA NCQ high prio commands).

-- 
Damien Le Moal
Western Digital Research

