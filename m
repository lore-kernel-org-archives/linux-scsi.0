Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B16A8C61D9D
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 01:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbjAYBT4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 20:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbjAYBTy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 20:19:54 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560B59778
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 17:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674609593; x=1706145593;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VfqTjjyMMR9U9lGOBZ0np8BZF5+SYnZqch6Vw3uctbk=;
  b=Q88L51BsI6atqGOeMwajFo14zZFZc6DxTgxrK6ExdUEnafOo30egXCug
   Mh3b1jq06cTXZUgXMJq36e0Tfz9tPmVlGfqzhd+3E41wbisHdcOfk8PgA
   PicDReAvndA3CNBGPzzlrulw2kvjxAnjUqgtvzHdWB7gvf5omaF0eLRZH
   8MyNkuxY32TEaMlFKE8fLK0B1eRULn4Eyts/OSynw2VBZgHC7dL+K5E5/
   eKMc4oKIDUwVBWZPH9Y9wIkbkUmAj45isbUZncNRPplCQ4O5u5iulhCJW
   ym0cqLNfC8NiyzchXy1LHRQiC90fobEoUf1O9EVRMyl2n4i5tpFDdan+j
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,244,1669046400"; 
   d="scan'208";a="325983396"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2023 09:19:50 +0800
IronPort-SDR: uOcpfdpDV55lIxsceSzVUp3GBdDmiq2lsMNrbsMqEoxV/fc4avArAwVhzuF4E7KHvyNOorxUQJ
 FcG5MWhXdkFFVJ2HA9OtWz6xkkQIzyhP8p2CTpmpfVDsctvs0ynOq07pru/58qpd+QFHemIuV8
 65dOZ59nZm2a8G4jp4PBCK8VyLhm5+0S6XtYiVUcDL1t+cgzArqT57CNDUyGl2DnUbsLa/8Pb4
 rECAP9MovbXzfEqRUH+z+fdovZ8uT8Vz7yd+ZwSCE+PN7dQLjSIJXQP8FWYhjA+kYy83Rg/b6l
 T5Q=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 16:31:38 -0800
IronPort-SDR: MSHL1vJs84zJhmHUQc5ak8OkEigONo45ZUDbHFk1jwOxIsqLdqoT3d5eL37tAmR2mPhaDIDFXg
 ryDRUSlfdvrDoxLxn96ogLRoyJAEF2TTkTg/+TyxZPndTjpU4Bnf5jQ8Daz3Vy6f4+PyXRE94l
 5pDNu6NYYkJ2BMPlIg1n5AxV9iXqjP7sSuwwNFhDKZFzmLJtbiEd/cP0S6IT/X7HGT3opXUoK3
 aGjajfilsffOvXxX35bfgAGz50nJhHqqG7iLzbDjy3PKLQxUpxunt+kJno5XEltfDkE/eiYO0l
 2j0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 17:19:50 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4P1mGY5vdTz1Rwrq
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 17:19:49 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1674609588; x=1677201589; bh=VfqTjjyMMR9U9lGOBZ0np8BZF5+SYnZqch6
        Vw3uctbk=; b=GZOCjYOoA83AgvwEmfwNHooHA2X22ipXOoXltO+/hPkc4tXu3Mr
        XcECjsvPiqlUHz8LNPfhXIS7BIAYMaa9AQj1jNGs5AQ6+TJx+Wt2Us2s0aXVZuml
        Nokt66ImwO7YVzmnfCHIhceZlEuUcVhEPEDUm3hMZAeIlBcLX72DHR8jWDo+2/R2
        lgG5BFJBGck6dRXo9x3Ml2seHw6MpKxBlyAEDEI+SbWSP7gkMklKILfmISgayrLj
        tOtssZQpPz6dE30z+a7aapIKAIU5Yo9nal63dUtOfuzWFjj7PSCE8MoA/vbVe/Ct
        vD8SIBwqtKfRyya5nTbZQQHPljsnLddMQ7A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Fffh8d2JgG1y for <linux-scsi@vger.kernel.org>;
        Tue, 24 Jan 2023 17:19:48 -0800 (PST)
Received: from [10.225.163.56] (unknown [10.225.163.56])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4P1mGW0kVVz1RvLy;
        Tue, 24 Jan 2023 17:19:46 -0800 (PST)
Message-ID: <275993f1-f9e8-e7a8-e901-2f7d3a6bb501@opensource.wdc.com>
Date:   Wed, 25 Jan 2023 10:19:45 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-2-niklas.cassel@wdc.com>
 <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org>
 <731aeacc-74c0-396b-efa0-f9ae950566d8@opensource.wdc.com>
 <873e0213-94b5-0d81-a8aa-4671241e198c@acm.org>
 <4c345d8b-7efa-85c9-fe1c-1124ea5d9de6@opensource.wdc.com>
 <5066441f-e265-ed64-fa39-f77a931ab998@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <5066441f-e265-ed64-fa39-f77a931ab998@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/25/23 09:05, Bart Van Assche wrote:
> On 1/24/23 14:59, Damien Le Moal wrote:
>> There is only one priority class that ATA understands: RT (the level is
>> irrelevant and ignored). All RT class IOs are mapped to high priority NCQ
>> commands. All other classes map to normal priority (no priority bit set)
>> commands.
>>
>> And sure, we could map the level of RT class IOs to a CDL index, as we do
>> for the CDL class, but what would be the point ? The user should use the
>> CDL class in that case.
>>
>> Furthermore, there is one additional thing that we do not yet support but
>> will later: CDL descriptor 0 can be used to set a target time limit for
>> high priority NCQ commands. Without this new feature introduced with CDL,
>> the drive is free to schedule high priority NCQ commands as it wants, and
>> that is hard coded in FW. So you can endup with very aggressive scheduling
>> leading to significant overall IOPS drop and long tail latency for low
>> priority commands. See page 11 and 20 of this presentation for an example:
>>
>> https://www.snia.org/sites/default/files/SDC/2021/pdfs/SNIA-SDC21-LeMoal-Be-On-Time-command-duration-limits-Feature-Support-in%20Linux.pdf
>>
>> For a drive that supports both CDL and NCQ priority, with CDL feature
>> turned off, CDL descriptor 0 defines the time limit hint for high priority
>> NCQ commands. Again, CDL and NCQ high priority are mutually exclusive.
>>
>> So for clarity, I really would prefer separating CDL and RT classes as we
>> did. We could integrate CDL support reusing the RT class + level for CDL
>> index, but I think this may be very confusing for users, especially
>> considering that the CLDs on a drive can be defined in any order the user
>> wants, resulting in indexes/levels that does do not have any particular
>> order, making it impossible for the host to correctly schedule commands.
> 
> Hi Damien,
> 
> Thanks again for the detailed reply. Your replies are very informative 
> and help me understand the context better.
> 
> However, I'm still less than enthusiast about the introduction of the 
> I/O priority class IOPRIO_CLASS_DL. To me command duration limits (CDL) 
> is a mechanism that is supported by one storage standard (SCSI) and of 

And ATA (ACS) too. Not just SCSI. This is actually an improvement over IO
priority (command priority) that is supported only by ATA NCQ and does not
exist with SCSI/SBC.

> which it is not sure that it will be integrated in other storage 
> standards (NVMe, ...). Isn't the purpose of the block layer to provide 
> an interface that is independent of the specifics of a single storage 
> standard? This is why I'm in favor of letting the ATA core translate one 
> of the existing I/O priority classes into a CDL instead of introducing a 
> new I/O priority class (IOPRIO_CLASS_DL) in the block layer.

We discussed CDL with Hannes in the context of NVMe over fabrics. Their
may be interesting extensions to consider for NVMe in that context (the
value for local PCI attached NVMe drive is more limited at best).

I would argue that IO priority is the same: that is not supported by all
device classes either, and for those that support it, the semantic is not
identical (ATA vs NVMe). Yet, we have the RT class that maps to high
priority for ATA, and nothing else as far as I know.

CDL at least covers SCSI *and* ATA, and as mentioned above, could be used
by NVMe-of host drivers to do fancy link selection for a multipath setup
based on the link speed for instance.

We could overload the RT class with a mapping to CDL feature on scsi and
ata, but I think this is more confusing/messy than a separate class as we
implemented.

> 
> Others may have a different opinion.
> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

