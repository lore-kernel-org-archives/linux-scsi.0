Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 691F3C32771
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 09:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbiI1JLJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 05:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiI1JLH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 05:11:07 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115A957264
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 02:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664356262; x=1695892262;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=349JM3KHYNKJseBQ7SQdZHYhaH/vwF6LdHBIxPPZF94=;
  b=Ctir+xwcbTswbM1AolWlXSxn3FDAnzqyfp6Prb7Hie3chPX6bAI8JG0O
   zRjRGLItDEZ7VX5JB5FmlLu0luTyngD/H7+OfjkBVCLZVR66gh/37X4kC
   7AZ6aKUbG65REgvyek4+gcFjueyiCBoSgUMcjHQ5bS6IGRzPNF53NSVF2
   PW3cObCI/iu/PjvbnLXjfxWmWsbwQjIOeo8cV7/aSW9EorL+A9PZL0GIU
   FkZghy6AKTy3OOipyFpUlpTVF6lyTwLf3v+KDKAnJcqk1Gmn1UU7o0qYD
   OaQQWl03Eo6nvb/moq5OYB54LMvLA0TaONgeuB3xyvl6vokWtX+faY/Mw
   A==;
X-IronPort-AV: E=Sophos;i="5.93,351,1654531200"; 
   d="scan'208";a="212886387"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Sep 2022 17:10:59 +0800
IronPort-SDR: 3UvK8mpTterpVBtk46O8zn8r8ci2NrvHndi6NxOQ+WpeVKvGbJFcVyR3hyJ0Fuh7avNGgAnd2F
 EOu4ZQwXPqLTDguawQW3BGQLNbDjB+oetg7/3YbEWZfkUM/Rl/o0t80nRm+2KTud91gFXVUUga
 OyJrmWEcPENz/mwlha+t7Su519ECndc4yQYPtJTFnc93QR3ZjHA1WjQZ+dG2DoXVfJF0YmF2Dd
 /p9TdYVxSM/AX4sUhSEjacOvHyMsvfAIzFXWBB9SYB+4t4lvYAFgm4hHiYO8VOAnrn+j/aXghl
 kJECGS1WEbdc4lmIbl4eF1kd
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Sep 2022 01:30:55 -0700
IronPort-SDR: cZoaQkAfX/Hx+BQxpVJkt1j7D8U0/H7ZF1B8kqG+/G3lseMLJKKW4nyvIStHPCkjo2ftrD3315
 3UQClQJZq20j6vjv6MIqlcoXrU6l9w3jjJIO1y9gC0nVLJkNafOPiVzklI8sBvDSigeBAYGmm5
 hhIn+4cWsefsDHex3VkBmXQ8Eq9oqE9qMWx5K+AqNAb0S4bgjsU3nlrAr6YtVw86ye5kJgXiU/
 UN2NNUbqPqcANXNwuJOMP0ymfVvSVlzYgtwdVo9QmVsg3NEqgIDmylPZrj0FIDFotO5gHBB+/g
 npI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Sep 2022 02:11:00 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4McrM71bDfz1RvTp
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 02:10:59 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664356258; x=1666948259; bh=349JM3KHYNKJseBQ7SQdZHYhaH/vwF6LdHB
        IxPPZF94=; b=LKa3rVGukGyrXqKTY4VOJ/4/Mx+cCmsFfym/HAQFm4h0n7Bdd2x
        syLWxh2XtxJQWClcv7uVIy/aVHcIkL+JGAK4vAtmogFoSO4xUz4AnVZq0HEAi4f4
        h05dry3UTFL+AZbJvm8yK5j+NkO+VrFA5q5vY9AyDv1y/3adf3KBiYY6ukMuySLR
        WIgwuDClnnHR7EHJRXXzeZwKpnLCrIYbuPPa4cnhmkwc61EoxE4CqJLmN6Z2yfsQ
        tx0BVx0El4q9cXa2LpMiigAsksZ+RfyyQioTz1c4T9KefGSeXmZXBhuHGAcdFdBv
        uHjIr265D2cjAe/byPvM+gqiWRRoqEoFmOw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id W7keQHxGBS-l for <linux-scsi@vger.kernel.org>;
        Wed, 28 Sep 2022 02:10:58 -0700 (PDT)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4McrM60rsrz1RvLy;
        Wed, 28 Sep 2022 02:10:57 -0700 (PDT)
Message-ID: <bc55b784-f735-ab11-5a50-da01f4d0cca6@opensource.wdc.com>
Date:   Wed, 28 Sep 2022 18:10:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 2/2] ata: libata-sata: Fix device queue depth control
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20220925230817.91542-1-damien.lemoal@opensource.wdc.com>
 <20220925230817.91542-3-damien.lemoal@opensource.wdc.com>
 <db84e61a-1069-982a-5659-297fcffc14f4@huawei.com>
 <ed504bcc-a880-12c5-0dea-4b22a8cce087@opensource.wdc.com>
 <66dbb3da-595e-c673-320d-00f139435192@huawei.com>
 <6f08d6b9-63ba-10f6-2900-020db60a94be@opensource.wdc.com>
 <13e5e5e5-7dc2-8f14-3dd2-43366343842d@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <13e5e5e5-7dc2-8f14-3dd2-43366343842d@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/22 16:53, John Garry wrote:
> On 28/09/2022 08:00, Damien Le Moal wrote:
>>> So we don't return. However the following subsequent test does evaluate
>>> true in ata_change_queue_depth():
>>>
>>> if (sdev->queue_depth == queue_depth)
>>> 	return -EINVAL;
>>>
>>> And we error.
>> I dug further into this. For AHCI, I still get an error when trying to set
>> 33. No capping and defaulting to 32. The reason is I believe that
>> sdev_store_queue_depth() has the check:
>>
>> 	if (depth < 1 || depth > sdev->host->can_queue)
>>                  return -EINVAL;
>>
>> as you mentioned. So all good.
>>
>> So changing that last "if" in ata_change_queue_depth() to
>>
>> 	if (sdev->queue_depth == queue_depth)
>> 		return sdev->queue_depth;
>>
>> has no effect. The error remains.
>>
>> Now, for a libsas SATA drive, if I add the above change, I do indeed get a
>> cap to 32 and the QD changes, no error. That is bothering me as that is
>> really inconsistent. Instead of suppressing the error, shouldn't we unify
>> AHCI and libsas behavior and error if the user is attempting to set a
>> value larger than what the*device*  supports (the host can_queue was
>> checked already). In a nutshell, the difference comes form
>> sdev->host->can_queue being equal to the device max qd for AHCI but not
>> necessarily for libsas.
> 
> Yes, I think consistent behaviour would be good. I suppose we just need 
> the same check to reject QD of > 32 in ata_change_queue_depth() (and not 
> just cap to 32 there).
> 
> Having said all that, scsi_device_max_queue_depth() does introduce some 
> capping. But let's just consider SATA behaviour now.
> 
>>
>> I am tempted to leave things as is for now (not changin gthe current weird
>> behavior) and cleaning that up during the next round. Thoughts ?
>>
> 
> It's up to you. Obviously we are making an improvement in this series, 
> but if we are going to backport then it's better to backport something 
> fully working first time.

OK. Since the current behavior has been in place for a long time, no
urgency to change anything now I think.
I will push the current 2 patches for 6.0-fixes and cook a full cleanup &
improvement for 6.1.

> 
> Thanks,
> John

-- 
Damien Le Moal
Western Digital Research

