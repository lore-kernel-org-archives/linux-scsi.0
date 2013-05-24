From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: Re: [PATCH] scsi: megaraid: check kzalloc
Date: Fri, 24 May 2013 17:30:26 +0800
Message-ID: <519F3332.1010300@huawei.com>
References: <519ECEF1.9060804@huawei.com> <CALMYJDua65PKyC4R+RdX8TxX8JFw3LX4h8dxxcExyiUboMwCvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALMYJDua65PKyC4R+RdX8TxX8JFw3LX4h8dxxcExyiUboMwCvg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: megaraidlinux@lsi.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kashyap.desai@lsi.com, aradford@gmail.com, Li Zefan <lizefan@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 2013/5/24 11:20, Santosh Y wrote:
> On Fri, May 24, 2013 at 7:52 AM, Libo Chen <clbchenlibo.chen@huawei.com> wrote:
>>
>> we should check kzalloc, avoid to hit oops
>>
>> Signed-off-by: Libo Chen <libo.chen@huawei.com>
>> ---
>>  drivers/scsi/megaraid.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
>> index 846f475..195b095 100644
>> --- a/drivers/scsi/megaraid.c
>> +++ b/drivers/scsi/megaraid.c
>> @@ -4162,6 +4162,10 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
>>
>>         sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
>>         scmd->device = sdev;
>                               ^^^^^^
> I guess assigning after the NULL check of 'sdev' is more appropriate.

Ah, there is a little different.  ok, I will update.


Thanks,

Libo

> 
>> +       if (!scmd->device) {
>> +               scsi_free_command(GFP_KERNEL, scmd);
>> +               return -ENOMEM;
>> +       }
>>
>>         memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));
>>         scmd->cmnd = adapter->int_cdb;
>> --
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
