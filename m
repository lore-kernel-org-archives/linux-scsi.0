Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED406C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 07:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239987AbhK2HlC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 02:41:02 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:11281 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238298AbhK2HjB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 02:39:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1638171344; x=1669707344;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gHwuodvHzEmX2nKPYKnYaOMUzj5zyz35lcTRQ3MmRC4=;
  b=dR97D56NMeMVODL2uBk9pONU6sLJ9hbAl10yT4d9TRCmEXhCIXuaRk03
   EM540LjWYt7GVtJv0XR5Ujg3U2IBFPMPZZEp6YqBE99M8I1vC55x39T4M
   mgT995TZ1mZM0R0ZOT4Fonlv5/HUev+TxTDT3negEmOR5HuQogZzt1QT4
   uw3VRZK/4z7B3Wxd4XuyMj217WYX1PEOKoKlH4DJlKG3hCogQOG4iiAGq
   23cm96VWVNBNJxLqbHPqVqzSymMLXx6yZRpYWXA6YFyQTxbBKivvU2acn
   5uF5O+bLQLFcT1Hc1MlVr48aRopeJa3I1LOdHAiG6Dynd5GvpGLEHf+Ty
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,272,1631548800"; 
   d="scan'208";a="185921396"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 29 Nov 2021 15:35:44 +0800
IronPort-SDR: HnatXmMxkrKF5y2z9YpXG9hfKtm+Hn7Im7QL2bNwU1sb11ZL7edm6er877/oWWj9ADk3DRRJfK
 +wwPOYclArYM8jtvgZewDhqj4XtqEpZSbJwgrHRW7hwEoHAudKk9PjvNMckaAtNtOk0GQ1Y5HN
 7bUUE2q77q9ZZnuSakI22LhJE19dDxOSEEd0/UiZ4FG1UCm+YMZNlCugAYepyq0MYSZlI2tBUT
 5ccwk46weZVpv0vI52KuydTk7mGe2vP1Q1gm+TFUhpGwkZKwnY0lVEI02Cp7wEF9fkQ7gbAVj6
 zJ62Y+38GSZDuKAlP8bz/z3v
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2021 23:10:31 -0800
IronPort-SDR: CilpYoFOmfj+NeXLQaJvZPzDaxw7429eHuTT9GQkVc3vSKwV61ofFischpx4TQJsj7NMSVFN6z
 /FoymTm2VIB/xdNmK+RvBGlHdyJBF/OOY1FV5u24quUR0nv08O+pGWVPzgpCrQwcYd/8UHu5zm
 8qRH4FQm8GRxzLRnZmFIp+yY2p9Z4pfuS/h9aGdV0VlB5laM3xHREVfAoyCKG0y+S5/ZCEI1v5
 B9P8HHo+cExfhtR56AChu9pKb9OI7k2wHWIIIkPVNHyoqsvRmARbH9Yz5h8KEC4kE3aYlbj3sz
 dTY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2021 23:35:45 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J2cb41jybz1RtVt
        for <linux-scsi@vger.kernel.org>; Sun, 28 Nov 2021 23:35:44 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1638171343; x=1640763344; bh=gHwuodvHzEmX2nKPYKnYaOMUzj5zyz35lcT
        RQ3MmRC4=; b=YlFcE6aRBm4kdIwU+aRyrUJ8xq20+0rFsa4Tl2GXCMy+3HS+Eh7
        dA07y6EmwP/cZ94ELwhC3sOHFz+l3msiI6LLNEa4XvTtWQ864/7pzGkHvZEA5AFq
        h2A3Wst+6IrDqcKVKNxQWbfvKRK2z9i6kks+qiz34eYaRXKq0vbzF2xW1Hm/7Je5
        eghTgmiK2YnkqgGXARBSAZAG2FHH+9BvLUGMj2I4TrX+f/vRDvCMGGGJndr5DVCZ
        UCUWCnu87Y8kpxFDNorUmF54mzngtOoDispOz1Sdp4JjH01RZkxZBiW27+s1sIQ9
        oZKatK5vD95xFTO4qXGusFhBX1n21IC7CVw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id MjNGNCcK_tQK for <linux-scsi@vger.kernel.org>;
        Sun, 28 Nov 2021 23:35:43 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J2cb2642Gz1RtVl;
        Sun, 28 Nov 2021 23:35:42 -0800 (PST)
Message-ID: <aae7748c-7915-28b4-75a4-033dc76f75d2@opensource.wdc.com>
Date:   Mon, 29 Nov 2021 16:35:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH 1/2] scsi: sd_zbc: Compare against block layer enum values
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20211126125533.266015-1-Niklas.Cassel@wdc.com>
 <9172d395-29d0-6b1a-4be7-8968bfac6762@opensource.wdc.com>
 <YaIBOPmCC6QH2rei@x1-carbon>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <YaIBOPmCC6QH2rei@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/11/27 18:58, Niklas Cassel wrote:
> On Sat, Nov 27, 2021 at 10:00:57AM +0900, Damien Le Moal wrote:
>> On 2021/11/26 21:55, Niklas Cassel wrote:
>>> From: Niklas Cassel <niklas.cassel@wdc.com>
>>>
>>> sd_zbc_parse_report() fills in a struct blk_zone, which is the block layer
>>> representation of a zone. This struct is also what will be copied to user
>>> for a BLKREPORTZONE ioctl.
>>>
>>> Since sd_zbc_parse_report() compares against zone.type and zone.cond, which
>>> are members of a struct blk_zone, the correct enum values to compare
>>> against are the enum values defined by the block layer.
>>>
>>> These specific enum values for ZBC and the block layer happen to have the
>>> same enum constants, but they could theoretically have been different.
>>>
>>> Compare against the block layer enum values, to make it more obvious that
>>> struct blk_zone is the block layer representation of a zone, and not the
>>> SCSI/ZBC representation of a zone.
>>>
>>> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
>>> ---
>>>  drivers/scsi/sd_zbc.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
>>> index ed06798983f8..024f1bec6e5a 100644
>>> --- a/drivers/scsi/sd_zbc.c
>>> +++ b/drivers/scsi/sd_zbc.c
>>> @@ -62,8 +62,8 @@ static int sd_zbc_parse_report(struct scsi_disk *sdkp, u8 *buf,
>>>  	zone.capacity = zone.len;
>>>  	zone.start = logical_to_sectors(sdp, get_unaligned_be64(&buf[16]));
>>>  	zone.wp = logical_to_sectors(sdp, get_unaligned_be64(&buf[24]));
>>> -	if (zone.type != ZBC_ZONE_TYPE_CONV &&
>>> -	    zone.cond == ZBC_ZONE_COND_FULL)
>>> +	if (zone.type != BLK_ZONE_TYPE_CONVENTIONAL &&
>>> +	    zone.cond == BLK_ZONE_COND_FULL)
>>>  		zone.wp = zone.start + zone.len;
>>
>> For the sake of avoiding layering violation, I would keep the code as is, unles
>> Martin and James are OK with this ?
> 
> Sorry, but I don't understand this comment.
> 
> The whole point of sd_zbc_parse_report() is to take a ZBC zone representation,
> stored in u8 *buf, and to convert it to a struct blk_zone used by the block
> layer.

Yes. So what is the problem with using the scsi_proto.h defined ZBC_ZONE_*
macros ? We are deep in scsi territory with this code, so using an UAPI defined
macro is weird.

> Similarly, nvme_zone_parse_entry() takes a ZNS zone representation, stored in a
> struct nvme_zone_descriptor *entry, and to convert it to a struct blk_zone.
> 
> 
> When comparing against struct members inside entry, the NVMe enums have to be
> used, i.e. NVME_ZONE_TYPE_SEQWRITE_REQ.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/nvme/host/zns.c#n158
> 
> However, assigning, or comparing against struct members of struct blk_zone,
> the blk layer enums have to be used, i.e. BLK_ZONE_TYPE_SEQWRITE_REQ:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/nvme/host/zns.c#n164
> 
> And why did you give me your Reviewed-by on the NVMe patch that uses the
> blk later enums here:
> https://lore.kernel.org/linux-nvme/ef1c39ab-7b56-6a37-0f4f-1ca111d5b48b@opensource.wdc.com/T/#t
> 
> Be consistent, either ack both or nack both :)

I am not nacking anything. I am giving my opinion, which is that I find this
code change useless.

>> A more sensible patch may be to add a static checking that all BLK_ZONE_COND_*
>> and BLK_ZONE_TYPE_* enum values are equal to the ZBC defined values in
>> include/scsi/scsi_proto.h (ZBC_ZONE_COND_* and ZBC_ZONE_TYPE_* macros).
> 
> The blk-zoned block layer is obviously modeled after ZBC, that is why all the
> enum constants happen to be the same. But this obviously doesn't have to be
> true for all existing/future lower level interfaces which supports zones.

If you are worried that sd_zbc_parse_report() does not fill the values as
defined for struct blk_zone, then add something like:

static_assert(BLK_ZONE_COND_FULL == ZBC_ZONE_COND_FULL);
static_assert(BLK_ZONE_TYPE_CONVENTIONAL == ZBC_ZONE_TYPE_CONV);

at the beginning of that function.

blk_dev_revalidate_zones() will check everything is valid anyway.

-- 
Damien Le Moal
Western Digital Research
