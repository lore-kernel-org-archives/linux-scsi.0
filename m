Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9AF5C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 22:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbiBNW3x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 17:29:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiBNW3w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 17:29:52 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C68F70DB
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 14:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644877783; x=1676413783;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=ocm4l4ax/+is28JMTf6hmBqzFnOZK4K7ZVaXxADc9ac=;
  b=gHpBdvQ/uv6mIPAI6MW5LFZ71DyJUs178pGrAQURt8aiG5vgKtNa8/Hg
   bqxO1Do5AA5wl/OuoHpzstmoENiUOpB/4Jm9aCmJCcDRok4UWqHvDefh5
   ylSy8Z+9Qv2qi8wgY+jVSEZaqxK4+hzgpdNUScC1qQMMsPNiBxrlBodVv
   DEDWomVWeA+yFTz5vo2U91TIXjGSPiErbChggN/qPtfK41uxDscHgCgLl
   ri3KqdLEUk6WyraocljsVf+f4n4F17q2wqGMc92nRISlvi0lofcRS71RG
   KBk4rJTCd+Lop1mdya1zAhIn9shnku2JIRknXpJ8I6f/P8csQX8MCTbEE
   A==;
X-IronPort-AV: E=Sophos;i="5.88,368,1635177600"; 
   d="scan'208";a="191831966"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 Feb 2022 06:29:42 +0800
IronPort-SDR: A2SdBm30P4W3dmDvIJsYS4qDNHvYqcqdivSpwPy7Z9Yk12p1H0dgb4nSGE3MlYg1sf0BWWtj9m
 UTu2xqIKSPJGgeWrsLa8om9WVr9/lG10ZJcWEkTjs8yOkTqI++8G7Rw3SlF7BqRlb/uXLOwjTe
 5Xf932fYvbQacGF2SHe9f/XGwbcsy1cdaiM58LGZ0JIO3IjzLNwdGg/t425lLsPDrtLFQQtjbD
 NJxGAed4sGLaB/Im7s8Ys1q51VG9bAV7OhGABniqmoBvK34+veDcmyssZJ15YReZUSqc88Tuuu
 mFstHE9Bec0eV0PWBv+U3RtA
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 14:01:24 -0800
IronPort-SDR: TdV3t2JqufpJCjHNO0a56INy95OVitvm90TYp97dM/c/oeN1otqHpT9l63GDd2inNQvMP/BsBH
 X9wbcjhaHtXyL6wv1tcWnqBnLmOPZSAoxQVxOyipt22CRPlxQEhCPq/e2ltcnP6fzqWI3bbKOM
 7oQ7kYQPX7NAlNN7XThqvEGhq8Yx9hoC/7UlER4mkYz3PDyOXtR9kHhQ6PbrLbDlW7342+6s0x
 d4EjV4pmmkp3RW6HtQzikKbkuh1zXTD7I4aAwWQkv6N1sXUdZB+C9ijvhzhF8omhMs2lRawz7P
 QOc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 14:29:43 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JyJn24HJQz1SVp0
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 14:29:42 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644877782; x=1647469783; bh=ocm4l4ax/+is28JMTf6hmBqzFnOZK4K7ZVa
        XxADc9ac=; b=IAvFLY3JpG+O2C2ddvR+muR2uTqttHlJ/TYNz9fbT3P5/kWGbdX
        3c3UTI0Zr/Gb9plgiw0UoBmZd6g8xJ+xf3LdIxihurSwJ6jmOXDANCiW3kChpeMs
        /aD+VAnnCYvXMDoawkjIL3G2Zk5VWmbBnE0q+c447ckVolmNWfBmBlYRO54hwbXB
        /o4K87XKUw5AWH/yJXPpvKcXEHt7iUCCXZSK+1djUdjLa6Chwy13CD+/LlEoZPif
        CSnIBJzucpxX4hZpHpOTq/8ORErBy4vvIWhqfMpKmsJ3X1jlIDhHu+AAeDiPVsNr
        IttLdWRrdR86XleXWKzlrAhiqxz885LCGeA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id TLBj_yIRHrcD for <linux-scsi@vger.kernel.org>;
        Mon, 14 Feb 2022 14:29:42 -0800 (PST)
Received: from [10.225.163.73] (unknown [10.225.163.73])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JyJn11TJYz1Rwrw;
        Mon, 14 Feb 2022 14:29:40 -0800 (PST)
Message-ID: <768d5978-c699-d882-0a4b-5403b3143aa0@opensource.wdc.com>
Date:   Tue, 15 Feb 2022 07:29:39 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 00/31] libsas and pm8001 fixes
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
 <3e09f069-4f3d-e9a3-717c-ed05c09b99e1@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <3e09f069-4f3d-e9a3-717c-ed05c09b99e1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/15/22 03:06, John Garry wrote:
> On 14/02/2022 02:17, Damien Le Moal wrote:
>> This first part of this series (patches 1 to 24) fixes handling of NCQ
>> NON DATA commands in libsas and many bugs in the pm8001 driver.
>>
>> The fixes for the pm8001 driver include:
>> * Suppression of all sparse warnings, fixing along the way many le32
>>    handling bugs for big-endian architectures
>> * Fix handling of NCQ NON DATA commands
>> * Fix of tag values handling (0*is*  a valid tag value)
>> * Fix many tag iand memory leaks in error path
>> * Fix NCQ error recovery (abort all task execution) that was causing a
>>    crash
>>
>> The second part of the series (patches 25 to 31) iadd a small cleanup of
>> libsas code and many simplifications of the pm8001 driver code.
>>
>> With these fixes, libzbc test suite passes all test case. This test
>> suite was used with an SMR drive for testing because it generates many
>> NCQ NON DATA commands (for zone management commands) and also generates
>> many NCQ command errors to check ASC/ASCQ returned by the device. With
>> the test suite, the error recovery path was extensively exercised. The
>> same tests were also executed with a SAS SMR drives to exercise the
>> error path.
>>
>> The patches are based on the 5.18/scsi-staging tree.
> 
> Hi Damien,
> 
> jfyi, I still see the hang with this series. I don't think that the tag 
> fixes were relevant unfortunately.

As mentioned above, I did test with a SAS drive too (an SMR one to
heavily test the error path) and it worked perfectly.
Note that using Martin's rc1 based scsi-staging tree, I did see a lot of
KASAN complaints on boot regarding MSI/PCI setup. These warnings are
gone with rc3/4. What kernel version base are you using ?

I could not find the ARM board I have in the lab yesterday. Will try
again to find it and test with it.

> 
> btw, how about add guys from get_maintainers.pl to lighten the review 
> workload (and we should have the official maintainer anyway)? There are 
> quite a few patches now...

I did that... I will check again. I may have made mistake creating the
distribution list.

> 
> Thanks,
> John


-- 
Damien Le Moal
Western Digital Research
