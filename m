Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86411C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 17:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbiF1RvK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 13:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbiF1Ru4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 13:50:56 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4553AE4A
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 10:49:20 -0700 (PDT)
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LXXBq00bdz6GD4M;
        Wed, 29 Jun 2022 01:48:34 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 28 Jun 2022 19:49:18 +0200
Received: from [10.126.174.24] (10.126.174.24) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 28 Jun 2022 18:49:17 +0100
Message-ID: <6f43f652-69ec-6843-0070-1e1b1696bb1a@huawei.com>
Date:   Tue, 28 Jun 2022 18:49:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 1/2] mpi3mr: Enable shared host tagset
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20220628074848.5036-1-sreekanth.reddy@broadcom.com>
 <20220628074848.5036-2-sreekanth.reddy@broadcom.com>
 <11cc137e-2b3e-2f0d-4aa8-b54ac49ad8e3@huawei.com>
 <CAK=zhgrH3ajb-_XXBazMeDktYi27qTjNUck8PUD+sNFEuYYtBw@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <CAK=zhgrH3ajb-_XXBazMeDktYi27qTjNUck8PUD+sNFEuYYtBw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.174.24]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/06/2022 18:41, Sreekanth Reddy wrote:
> On Tue, Jun 28, 2022 at 8:32 PM John Garry <john.garry@huawei.com> wrote:
>>
>> On 28/06/2022 08:48, Sreekanth Reddy wrote:
>>> Enable shared host tagset to make sure that total outstanding
>>> IOs count won't cross controller's can_queue.
>>>
>>> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
>>> ---
>>>    drivers/scsi/mpi3mr/mpi3mr_os.c | 2 ++
>>>    1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
>>> index d8c195b..da85eda 100644
>>> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
>>> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
>>> @@ -4321,6 +4321,8 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>>        shost->max_channel = 0;
>>>        shost->max_id = 0xFFFFFFFF;
>>>
>>> +     shost->host_tagset = 1;
>>> +
>>
>> nit: any reason not to set the flag in the scsi_host_template instead?
> 
> There is no specific reason. Please let me know if I need to repost
> the patch with the host_tagset flag set in the scsi_host_template.
> 

You don't need to repost just for me. I was just hinting that this can 
be set in the scsi_host_template, which is a bit neater.

Thanks,
John

>>
>>>        if (prot_mask >= 0)
>>>                scsi_host_set_prot(shost, prot_mask);
>>>        else {
>>

