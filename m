Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2CCFC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 23:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F6B860F41
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 23:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbhHJXrW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 19:47:22 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:56358 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235242AbhHJXrW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2021 19:47:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628639219; x=1660175219;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=dPGMvByzWLSxA0BgxLV93qSge/w5rLHLRxcrSB2fbiw=;
  b=A2BP/Bfi4VvFOcKxoO/wvN/KUNmv6dzcXrjWFtTKbiL3uRjRcM77YV9t
   kZV3edyozu1ARrSsukUzHzQrtY+Io9t6A4DqvTu64AxSfXRdsJ+jhVPgh
   xSARRha9OVFutlhgnHyodx+pnfFxKGRhAtCIX5N/yDzQDmLmfLe3RX3sR
   WS90VrY0ctzlFWMSbORBVEUWFTggEd7HrbtOmlg3mYbx2dI8yrjbV/PfG
   vwC4//5l8yQO/UQLNdaeGsoHO4DfzPN9l37hX4vf3rTLtjvSNCMJKXQU0
   Bd93S99eyTi16frZt7g8MHHJIrj50qXk7lEI8I9Jfb/s1afZkvvbMn54c
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,311,1620662400"; 
   d="scan'208";a="280695923"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Aug 2021 07:46:58 +0800
IronPort-SDR: N5zGXHRk7OnNBIPkjd6thnWTYks0Cv54H3wYvl+Wyb7Pr9hm024ccnlFaYHN4Ve/645530IoCA
 tTqlUrLpMxbJhTZnrQuIfGQdL68ux1ckM9tk3UeT41umMh3QuNfLuA2h22GvHkenUx5ySB5eTx
 6EPB+aqHXgFevWhpYHmEh4Xm9O+hHVT4Nsr4rJ+efNSDZDoPjpFKj7rICFIrBCYuuBhg5PhIH1
 ata0sPd1/LRZPn/EMpVIKyY1VxYKtoDfpYE+9RX6IrAob6POmo6zBnvjs5F/XFZ1WX247Z0IKX
 gE7YtMfijDVzISWLyGULOjcy
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 16:22:30 -0700
IronPort-SDR: PW9leUjEgCXoA6Lny2a34BA0Gagq+Sg29TNCIQXNZfVlkRxpcDrKEaN7ez/qfCUBj67hf+MqrN
 RWwG7kgwFYpz7DjFoVuY0zrRAP1eO/lp/ZsTmMXxMULb6Hy1nVEdhYfhIIvatUZsYzffJOL3DL
 P3eKhhp33gfu+1/w5LBOP4+ww6z9mt9FvlptVwXEKkdd2/fdf71WxXOedDUXRD87POrJ6I79qY
 HicZiPn5zRj7ijeXj3Hg8qkFyDRu7Unj8FwOJ+LUhPIVdI+r3oXHvLRpiJpRz3vq5HsWkJU2u6
 41w=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 16:46:59 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4GkqNy2hhhz1RvlH
        for <linux-scsi@vger.kernel.org>; Tue, 10 Aug 2021 16:46:58 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-language
        :content-type:in-reply-to:mime-version:user-agent:date
        :message-id:organization:from:references:to:subject; s=dkim; t=
        1628639218; x=1631231219; bh=dPGMvByzWLSxA0BgxLV93qSge/w5rLHLRxc
        rSB2fbiw=; b=aqHJamFTSQ6eUwc2aNEtw+zLXWpUQqiaKYgscxwrw7UVLIfvK+w
        +RMJNBWXFX69Axxl2No3y2gjENEOx2jKtq9Lhj/NKmQeTTVpa4T831T3WienpSEe
        LuoqyDJw3vcL3g6n8HQupKaI4V3L1KNLzUPUkY8JMKOVkI8FQe5iYwNejKdcix35
        8YgkaDLfwHWiEhga2M/2Q4g6GXanTzLbPgJdn/y89oCkIt2XgW0g+yigRq3Va0iA
        wkvDQuNyOmzqDbY77bg/5K9OsvdsXZATpGpWv36HNx6FgEg8kgRAKe0TzzX8+SF5
        QrmuGMdUaDMwwxfg4nPUA529+Lss/vmJFyw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id UxrthWxChaWu for <linux-scsi@vger.kernel.org>;
        Tue, 10 Aug 2021 16:46:58 -0700 (PDT)
Received: from [10.225.48.54] (unknown [10.225.48.54])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4GkqNw3xCJz1RvlC;
        Tue, 10 Aug 2021 16:46:56 -0700 (PDT)
Subject: Re: [PATCH v3 1/4] block: Add concurrent positioning ranges support
To:     "hch@infradead.org" <hch@infradead.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
References: <20210726013806.84815-1-damien.lemoal@wdc.com>
 <20210726013806.84815-2-damien.lemoal@wdc.com>
 <YRI3kMc39XPRLe/u@infradead.org>
 <DM6PR04MB7081844211DF94238A3FC6B4E7F79@DM6PR04MB7081.namprd04.prod.outlook.com>
 <YRKjGeOZLVnTjQNv@infradead.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
Message-ID: <53369ff7-017e-d72e-7eb6-418d6e258074@opensource.wdc.com>
Date:   Wed, 11 Aug 2021 08:46:54 +0900
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YRKjGeOZLVnTjQNv@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/11 1:02, hch@infradead.org wrote:
> On Tue, Aug 10, 2021 at 11:03:41AM +0000, Damien Le Moal wrote:
>>>> + * Dummy release function to make kobj happy.
>>>> + */
>>>> +static void blk_cranges_sysfs_nop_release(struct kobject *kobj)
>>>> +{
>>>> +}
>>>
>>> How do we ensure the kobj is still alive while it is accessed?
>>
>> q->sysfs_lock ensures that. This mutex is taken whenever revalidate registers
>> new ranges (see blk_queue_set_cranges below), and is taken also when the ranges
>> are unregistered (on revalidate if the ranges changed and when the request queue
>> is unregistered). And blk_crange_sysfs_show() takes that lock too. So the kobj
>> cannot be freed while it is being accessed (the sysfs inode lock also prevents
>> it since kobj_del() will take the inode lock).
> 
> Does it?  It only protects the access inside of it, but not the object
> lifetime.

Alloc & free of the cranges structure (the top kobj) are under the
q->sysfs_lock, always. With the accesses also under that same lock, this is
mutually exclusive and all protected. Furthermore, the crange
kobj_add()/kobj_del() do a kobj_get()/kobj_put() on the parent kobj, which is
the request queue kobj. So the queue cannot go away under the crange struct.

I can add a kobj_get/put for the crange struct, but I really do not see the need
for that. Or am I missing something ?

>>>> +void blk_queue_set_cranges(struct gendisk *disk, struct blk_cranges *cr)
>>>
>>> s/blk_queue/disk/
>>
>> Hmmm... The argument is a gendisk, but it is the request queue that is modified.
>> So following other functions like this, isn't blk_queue_ prefix better ?
> 
> Do we have blk_queue_ functions that take a gendisk anywhere?  The
> ones I noticed (and the ones I've recently added) all use disk_.

The only one I can find is blk_queue_set_zoned(), which we could probably rename
to disk_set_zoned(). There are blk_revalidate_disk_zones() and blkdev_nr_zones()
which also take a gendisk and could probably be renamed as
disk_revalidate_zones() and disk_nr_zones() for consistency.

Will rename to disk_set_cranges().

-- 
Damien Le Moal
Western Digital Research
