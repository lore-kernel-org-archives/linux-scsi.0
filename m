From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v3 14/23] scsi: hisi_sas: add v3 cq interrupt handler
Date: Thu, 8 Jun 2017 13:09:38 +0100
Message-ID: <0336e738-e5a7-889a-2ee2-f1a951492067@huawei.com>
References: <1496241195-217678-1-git-send-email-john.garry@huawei.com>
 <1496241195-217678-15-git-send-email-john.garry@huawei.com>
 <20170601054147.GB4743@infradead.org>
 <04821e06-7541-1861-d52b-4df869570ca7@huawei.com>
 <20170608073400.GA9292@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:7393 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751092AbdFHMLG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2017 08:11:06 -0400
In-Reply-To: <20170608073400.GA9292@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, Xiang Chen <chenxiang66@hisilicon.com>

On 08/06/2017 08:34, Christoph Hellwig wrote:
> Hi John,
>
> sorry for dropping the ball, but your repost reminded me.
>
> On Thu, Jun 01, 2017 at 11:36:55AM +0100, John Garry wrote:
>> In the command completion code we need to check for abnormal completion due
>> to underflow, but ignore it when it occurs in some commands, like inquiry.
>> This is why we check for rw command - it is equivalent to !inquiry.
>>
>> I'll see if we can change the check to explicitly ignore certain commands
>> which complete abnormally with underflow.
>
> In general it should be up to the higher level and not the driver
> to detect underflow, and that's how most (hopefully all, but I won't
> bet on some older ones) of our drivers operate.
>

Hi Christoph,

Right, I see most LLDDs will not check for underflow; but, FWIW, I do 
see scsi_cmnd.underflow referenced in some...

However, for drivers using libsas, we detect underflow for the reason 
just so libsas knows the sas_task status (SAS_DATA_UNDERRUN) and sets 
the scsi cmd result properly (and also the residual) in sas_end_task().

We used this method for the predecessor hw driver, and I think that we 
can revert to it.

Much appreciated,
John

>>
>>> What about 32-byte CDs or things like Write Same?
>>>
>>
>> You're talking about VARIABLE_LENGTH_CMD (opcode 0x7f) for 32-byte CDs,
>> right?
>
> Yes.
>
> .
>
