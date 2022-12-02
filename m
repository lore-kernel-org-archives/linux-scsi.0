Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A053C4321E
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Dec 2022 13:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbiLBN6f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Dec 2022 08:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbiLBN6e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2022 08:58:34 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504D398026
        for <linux-scsi@vger.kernel.org>; Fri,  2 Dec 2022 05:58:32 -0800 (PST)
Received: from dggpemm500017.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NNvf26wgHzRpLZ;
        Fri,  2 Dec 2022 21:57:46 +0800 (CST)
Received: from [10.174.178.220] (10.174.178.220) by
 dggpemm500017.china.huawei.com (7.185.36.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 21:58:30 +0800
Message-ID: <7fb4c882-c332-551c-8980-9b07ae9519dd@huawei.com>
Date:   Fri, 2 Dec 2022 21:58:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [QUESTION]: Why did we clear the lowest bit of SCSI command's
 status in scsi_status_is_good
Content-Language: en-US
To:     <jejb@linux.ibm.com>, Wenchao Hao <haowenchao22@gmail.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linfeilong@huawei.com>,
        <yanaijie@huawei.com>, <xuhujie@huawei.com>, <lijinlin3@huawei.com>
References: <6e9ea80e-d4e0-6d52-47c1-8939c13d60a8@huawei.com>
 <ca7e2aba5db5bd6e15182070f26e0c2c77c70927.camel@linux.ibm.com>
 <ada12c1d-b732-59a9-8dba-1662673b6a5d@huawei.com>
 <70f4d744d64bc075138128a7a98b7186375170d8.camel@linux.ibm.com>
 <CAOptpSPfswNrmYe4rnKFM3zWXY7P0JuWY94p=mfp7tV9ghFQ2w@mail.gmail.com>
 <f2e3c4dc0bfad6b05f40d716738e56f2cbb80810.camel@linux.ibm.com>
From:   Wenchao Hao <haowenchao@huawei.com>
In-Reply-To: <f2e3c4dc0bfad6b05f40d716738e56f2cbb80810.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggpeml100007.china.huawei.com (7.185.36.28) To
 dggpemm500017.china.huawei.com (7.185.36.178)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2022/11/29 2:12, James Bottomley wrote:
> On Tue, 2022-11-29 at 01:38 +0800, Wenchao Hao wrote:
>> On Mon, Nov 28, 2022 at 11:24 PM James Bottomley <jejb@linux.ibm.com>
>> wrote:
>>>
>>> On Mon, 2022-11-28 at 22:41 +0800, Wenchao Hao wrote:
>>>> On 2022/11/28 20:52, James Bottomley wrote:
>>>>> On Mon, 2022-11-28 at 11:58 +0800, Wenchao Hao wrote:
>>> [...]
>>>>>> We found some firmware or drivers would return status which
>>>>>> did not defined in SAM. Now SCSI middle level do not have an
>>>>>> uniform behavior for these undefined status. I want to change
>>>>>> the logic to return error for all status which did not
>>>>>> defined in SAM or define a method in host template to let
>>>>>> drivers to judge what to do in this condition.
>>>>>
>>>>> Why? The general rule of thumb is be strict in what you emit
>>>>> and generous in what you receive (which is why reserved bits
>>>>> are ignored). Is the drive you refer to above not working in
>>>>> some way, in which case detail it so people can understand the
>>>>> actual problem.
>>>>>
>>>>> James
>>>>>
>>>>> .
>>>>
>>>>
>>>> We come with an issue with megaraid_sas driver. Where scsi_cmnd
>>>> is completed with result's status byte set to 1,
>>>
>>> Megaraid_sas is an emulation driver for the most part, so it sounds
>>> like this is in the RAID emulation firmware, correct?  The driver
>>> can correct for emulation failures, if you can figure out what it's
>>> trying to signal and convert it to the correct SAM error code.
>>> There's no need to change anything in the layers above.  If you
>>> can't figure out the translation and you want the transfer to
>>> error, then add DID_ERROR, which is a nice catch all.  If this is
>>> transient and could be fixed by a retry, then do DID_SOFT_ERROR
>>> instead.
>>>
>>> James
>>>
>>
>> Thanks for your answer, Of curse we can recognize these undefined
>> status and map to an error which can be handled by SCSI middle level
>> now. But I still confused why shouldn't we change the
>> scsi_status_is_good() to respect to SAM?
> 
> Because it wouldn't be backwards compatible and something might break.
> Under SCSI-1, devices were allowed to set this bit to signal vendor
> unique status and a lot of manufacturers continued doing this for SCSI-
> 2, even though it was flagged as reserved instead of vendor specific in
> that standard, hence the mask.  Since this was over 20 years ago, it is
> possible there is no remaining functional device that does this, but if
> it's not causing a problem, why take the risk?
> 
> James
> 
> .

Hi James, thank you very much for your answer.

I think we should think about the following functions of megaraid driver:

megasas_complete_cmd() defined in drivers/scsi/megaraid/megaraid_sas_base.c,
megasas_complete_cmd
	...
	switch (hdr->cmd) {
	...
	case MFI_CMD_LD_READ:
	case MFI_CMD_LD_WRITE:
		switch (hdr->cmd_status) {
		case MFI_STAT_SCSI_DONE_WITH_ERROR:
			cmd->scmd->result = (DID_OK << 16) | hdr->scsi_status;
			break;
		...
		}
	...
	}

map_cmd_status() defined in drivers/scsi/megaraid/megaraid_sas_fusion.c 
map_cmd_status
	...
	switch (status) {
	...
	case MFI_STAT_SCSI_DONE_WITH_ERROR:
		scmd->result = (DID_OK << 16) | ext_status;
		break;
	...
	}

Both of these functions did not check the status byte, which can not make
sure the status byte is defined in SAM.

What we meet is the status byte set to 1, and the host_byte is set to DID_OK.

In this condition, the scsi_cmnd would be finished by scsi middle layer with BLK_STS_OK
if the kernel version is before 3d45cefc8edd7 (scsi: core: Drop obsolete Linux-specific
SCSI status codes).

Because scsi_io_completion_nz_result() would return a non zero value, so we call
scsi_io_completion_action() to handle this command.
While in scsi_io_completion_action(), the blk_stat mapped by scsi_result_to_blk_status()
is BLK_STS_OK which finally result in the command finished with BLK_STS_OK.
