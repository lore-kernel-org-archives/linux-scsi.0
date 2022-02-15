Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57CFEC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 08:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbiBOIQ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Feb 2022 03:16:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbiBOIQ4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2022 03:16:56 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3413F7C16C
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 00:16:46 -0800 (PST)
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JyYnN1vpPz67Xgw;
        Tue, 15 Feb 2022 16:15:52 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 09:16:43 +0100
Received: from [10.47.81.62] (10.47.81.62) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.21; Tue, 15 Feb
 2022 08:16:43 +0000
Message-ID: <f2528f26-0231-1a33-94fd-f29c7dd8bfdc@huawei.com>
Date:   Tue, 15 Feb 2022 08:16:44 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v3 00/31] libsas and pm8001 fixes
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Jason Yan" <yanaijie@huawei.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
 <3e09f069-4f3d-e9a3-717c-ed05c09b99e1@huawei.com>
 <768d5978-c699-d882-0a4b-5403b3143aa0@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <768d5978-c699-d882-0a4b-5403b3143aa0@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.81.62]
X-ClientProxiedBy: lhreml703-chm.china.huawei.com (10.201.108.52) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/02/2022 22:29, Damien Le Moal wrote:
> On 2/15/22 03:06, John Garry wrote:
>> On 14/02/2022 02:17, Damien Le Moal wrote:
>>> This first part of this series (patches 1 to 24) fixes handling of NCQ
>>> NON DATA commands in libsas and many bugs in the pm8001 driver.
>>>
>>> The fixes for the pm8001 driver include:
>>> * Suppression of all sparse warnings, fixing along the way many le32
>>>     handling bugs for big-endian architectures
>>> * Fix handling of NCQ NON DATA commands
>>> * Fix of tag values handling (0*is*  a valid tag value)
>>> * Fix many tag iand memory leaks in error path
>>> * Fix NCQ error recovery (abort all task execution) that was causing a
>>>     crash
>>>
>>> The second part of the series (patches 25 to 31) iadd a small cleanup of
>>> libsas code and many simplifications of the pm8001 driver code.
>>>
>>> With these fixes, libzbc test suite passes all test case. This test
>>> suite was used with an SMR drive for testing because it generates many
>>> NCQ NON DATA commands (for zone management commands) and also generates
>>> many NCQ command errors to check ASC/ASCQ returned by the device. With
>>> the test suite, the error recovery path was extensively exercised. The
>>> same tests were also executed with a SAS SMR drives to exercise the
>>> error path.
>>>
>>> The patches are based on the 5.18/scsi-staging tree.
>>
>> Hi Damien,
>>
>> jfyi, I still see the hang with this series. I don't think that the tag
>> fixes were relevant unfortunately.
> 
> As mentioned above, I did test with a SAS drive too (an SMR one to
> heavily test the error path) and it worked perfectly.
> Note that using Martin's rc1 based scsi-staging tree, I did see a lot of
> KASAN complaints on boot regarding MSI/PCI setup. These warnings are
> gone with rc3/4. What kernel version base are you using ?

I was using mkp 5.18 staging tree from yesterday as baseline:
https://github.com/hisilicon/kernel-dev/commits/private-topic-sas-5.17-damien-pm8001-v3

If I start using rc4 then I would get conflicts (which obviously would 
be resolvable easily enough), but I doubt it is an issue (in using rc1).

> 
> I could not find the ARM board I have in the lab yesterday. Will try
> again to find it and test with it.

That would be brilliant if you could. This problem could even be down to 
defconfig differences (between arm64 and x86_64).

Thanks,
John
