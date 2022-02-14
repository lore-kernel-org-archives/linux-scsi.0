Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E79C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 18:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348972AbiBNSGj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 13:06:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238603AbiBNSGi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 13:06:38 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E293C60D9A
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 10:06:29 -0800 (PST)
Received: from fraeml743-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JyBwv1CgKz6H7hJ;
        Tue, 15 Feb 2022 02:06:07 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml743-chm.china.huawei.com (10.206.15.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Feb 2022 19:06:26 +0100
Received: from [10.47.81.62] (10.47.81.62) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.21; Mon, 14 Feb
 2022 18:06:25 +0000
Message-ID: <3e09f069-4f3d-e9a3-717c-ed05c09b99e1@huawei.com>
Date:   Mon, 14 Feb 2022 18:06:27 +0000
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
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.81.62]
X-ClientProxiedBy: lhreml703-chm.china.huawei.com (10.201.108.52) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/02/2022 02:17, Damien Le Moal wrote:
> This first part of this series (patches 1 to 24) fixes handling of NCQ
> NON DATA commands in libsas and many bugs in the pm8001 driver.
> 
> The fixes for the pm8001 driver include:
> * Suppression of all sparse warnings, fixing along the way many le32
>    handling bugs for big-endian architectures
> * Fix handling of NCQ NON DATA commands
> * Fix of tag values handling (0*is*  a valid tag value)
> * Fix many tag iand memory leaks in error path
> * Fix NCQ error recovery (abort all task execution) that was causing a
>    crash
> 
> The second part of the series (patches 25 to 31) iadd a small cleanup of
> libsas code and many simplifications of the pm8001 driver code.
> 
> With these fixes, libzbc test suite passes all test case. This test
> suite was used with an SMR drive for testing because it generates many
> NCQ NON DATA commands (for zone management commands) and also generates
> many NCQ command errors to check ASC/ASCQ returned by the device. With
> the test suite, the error recovery path was extensively exercised. The
> same tests were also executed with a SAS SMR drives to exercise the
> error path.
> 
> The patches are based on the 5.18/scsi-staging tree.

Hi Damien,

jfyi, I still see the hang with this series. I don't think that the tag 
fixes were relevant unfortunately.

btw, how about add guys from get_maintainers.pl to lighten the review 
workload (and we should have the official maintainer anyway)? There are 
quite a few patches now...

Thanks,
John
