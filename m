Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09527C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 09:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242615AbiBKJYK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 04:24:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiBKJYJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 04:24:09 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061F6B81
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 01:24:08 -0800 (PST)
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jw7Tl74bKz686xP;
        Fri, 11 Feb 2022 17:23:55 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 11 Feb 2022 10:24:04 +0100
Received: from [10.47.86.199] (10.47.86.199) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 11 Feb
 2022 09:24:03 +0000
Message-ID: <af3b0aff-3e43-5a1f-0d98-f68b9100090e@huawei.com>
Date:   Fri, 11 Feb 2022 09:24:02 +0000
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
 <b3efd3cf-e36b-9594-06b8-9772bb525e00@huawei.com>
 <ea6b25db-d4da-bab5-8bf2-ec5024c95f89@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <ea6b25db-d4da-bab5-8bf2-ec5024c95f89@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.86.199]
X-ClientProxiedBy: lhreml711-chm.china.huawei.com (10.201.108.62) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/02/2022 22:44, Damien Le Moal wrote:

Hi Damien,

>>> Note that without these patches, libzbc test suite result in the
>>> controller hanging, or in kernel crashes.
>> Unfortunately I still see the hang on my arm64 system with this series:(
> That is unfortunate. Any particular command sequence triggering the hang
> ? Or is it random ? What workload are you running ?
> 

mount/unmount fails mostly even after as few as one attempt, but then 
even fdisk -l fails sometimes:

root@(none)$ fdisk -l
[   97.924789] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[   97.930652] sas: sas_scsi_find_task: aborting task 0x(____ptrval____)
[   97.937149] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   97.943232] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   97.952020] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   97.958099] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   97.966881] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   97.972961] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   97.981737] pm80xx0:: pm8001_mpi_task_abort_resp  3682:task abort 
failed status 0x6 ,tag = 0x2, scp= 0x0
[   97.991241] pm80xx0:: pm8001_mpi_task_abort_resp  3682:task abort 
failed status 0x6 ,tag = 0x2, scp= 0x0
[   98.000752] pm80xx0:: pm8001_mpi_task_abort_resp  3682:task abort 
failed status 0x6 ,tag = 0x2, scp= 0x0
[   98.010223] pm80xx0:: pm8001_abort_task  1345:rc= -5
[   98.015180] sas: sas_scsi_find_task: querying task 0x(____ptrval____)
[   98.021645] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.027725] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.036495] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.042574] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.051344] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.057423] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.066154] pm80xx: rc= -5
[   98.068854] sas: sas_scsi_find_task: aborting task 0x(____ptrval____)
[   98.075331] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.081411] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.090192] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.096271] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.105053] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.111132] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.119909] pm80xx0:: pm8001_mpi_task_abort_resp  3682:task abort 
failed status 0x6 ,tag = 0x2, scp= 0x0
[   98.129414] pm80xx0:: pm8001_mpi_task_abort_resp  3682:task abort 
failed status 0x6 ,tag = 0x2, scp= 0x0
[   98.138919] pm80xx0:: pm8001_mpi_task_abort_resp  3682:task abort 
failed status 0x6 ,tag = 0x2, scp= 0x0
[   98.148388] pm80xx0:: pm8001_abort_task  1345:rc= -5
[   98.153345] sas: sas_scsi_find_task: querying task 0x(____ptrval____)
[   98.159812] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.165892] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.174661] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.180741] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.189511] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.195590] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.204320] pm80xx: rc= -5
[   98.207019] sas: sas_scsi_find_task: aborting task 0x(____ptrval____)
[   98.213497] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.219577] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.228359] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.234438] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.243220] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.249299] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.258075] pm80xx0:: pm8001_mpi_task_abort_resp  3682:task abort 
failed status 0x6 ,tag = 0x2, scp= 0x0
[   98.267580] pm80xx0:: pm8001_mpi_task_abort_resp  3682:task abort 
failed status 0x6 ,tag = 0x2, scp= 0x0
[   98.277085] pm80xx0:: pm8001_mpi_task_abort_resp  3682:task abort 
failed status 0x6 ,tag = 0x2, scp= 0x0
[   98.286554] pm80xx0:: pm8001_abort_task  1345:rc= -5
[   98.291510] sas: sas_scsi_find_task: querying task 0x(____ptrval____)
[   98.297978] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.304059] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.312827] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.318906] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.327677] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.333756] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.342487] pm80xx: rc= -5
[   98.345186] sas: sas_scsi_find_task: aborting task 0x(____ptrval____)
[   98.351664] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.357743] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.366525] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.372604] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.381386] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.387465] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.396230] pm80xx0:: pm8001_mpi_task_abort_resp  3682:task abort 
failed status 0x6 ,tag = 0x2, scp= 0x0
[   98.405734] pm80xx0:: pm8001_mpi_task_abort_resp  3682:task abort 
failed status 0x6 ,tag = 0x2, scp= 0x0
[   98.415239] pm80xx0:: pm8001_mpi_task_abort_resp  3682:task abort 
failed status 0x6 ,tag = 0x2, scp= 0x0
[   98.424709] pm80xx0:: pm8001_abort_task  1345:rc= -5
[   98.429665] sas: sas_scsi_find_task: querying task 0x(____ptrval____)
[   98.436133] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.442213] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.450982] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.457061] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.465825] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.471904] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.480629] pm80xx: rc= -5
[   98.483327] sas: sas_scsi_find_task: aborting task 0x(____ptrval____)
[   98.489800] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.495880] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.504661] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.510740] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.519523] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.525602] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.534372] pm80xx0:: pm8001_mpi_task_abort_resp  3682:task abort 
failed status 0x6 ,tag = 0x2, scp= 0x0
[   98.543877] pm80xx0:: pm8001_mpi_task_abort_resp  3682:task abort 
failed status 0x6 ,tag = 0x2, scp= 0x0
[   98.553382] pm80xx0:: pm8001_mpi_task_abort_resp  3682:task abort 
failed status 0x6 ,tag = 0x2, scp= 0x0
[   98.562851] pm80xx0:: pm8001_abort_task  1345:rc= -5
[   98.567807] sas: sas_scsi_find_task: querying task 0x(____ptrval____)
[   98.574275] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.580355] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.589124] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.595203] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.603968] pm80xx0:: mpi_ssp_completion  1937:sas IO status 0x3b
[   98.610047] pm80xx0:: mpi_ssp_completion  1948:SAS Address of IO 
Failure Drive:5000c500a7babc61
[   98.618778] pm80xx: rc= -5
[   98.621505] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1 
tries: 1

Sometimes I get TMF timeouts, which is a bad situation. I guess it's a 
subtle driver bug, but where ....?

BTW, this following log needs removal/fixing at some stage by someone:

[   98.480629] pm80xx: rc= -5

It's from pm8001_query_task().

Thanks,
John
