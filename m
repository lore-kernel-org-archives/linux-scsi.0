Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C27ECC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 15:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243672AbiBJPfk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 10:35:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234987AbiBJPfj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 10:35:39 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936131DF
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 07:35:40 -0800 (PST)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jvgmz5FmDz67xFD;
        Thu, 10 Feb 2022 23:35:31 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 16:35:38 +0100
Received: from [10.202.227.197] (10.202.227.197) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 15:35:37 +0000
Message-ID: <b3efd3cf-e36b-9594-06b8-9772bb525e00@huawei.com>
Date:   Thu, 10 Feb 2022 15:35:37 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 00/20] libsas and pm8001 fixes
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Jason Yan" <yanaijie@huawei.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.197]
X-ClientProxiedBy: lhreml713-chm.china.huawei.com (10.201.108.64) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/02/2022 11:41, Damien Le Moal wrote:
> The first 3 patches fix a problem with libsas handling of NCQ NON DATA
> commands and simplify libsas code in a couple of places.
> The remaining patches are fixes for the pm8001 driver:
> * All sparse warnings are addressed, fixing along the way many le32
>    handling bugs for big-endian architectures
> * Fix handling of NCQ NON DATA commands
> * Fix NCQ error recovery (abort all task execution) that was causing a
>    crash
> * Simplify the code in many places
> 
> With these fixes, libzbc test suite passes all test case. This test
> suite was used with an SMR drive for testing because it generates many
> NCQ NON DATA commands (for zone management commands) and also generates
> many NCQ command errors to check ASC/ASCQ returned by the device. With
> the test suite, the error recovery path was extensively exercised.
> 
> Note that without these patches, libzbc test suite result in the
> controller hanging, or in kernel crashes.

Unfortunately I still see the hang on my arm64 system with this series :(

Thanks,
John
