From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH] scsi: mpt3sas: Fix memory allocation failure test in
 'mpt3sas_base_attach()'
Date: Mon, 7 Aug 2017 10:45:35 +0200
Message-ID: <625e7538-3834-0c9b-55bf-9aa460ded9bb@wanadoo.fr>
References: <cover.1502058761.git.christophe.jaillet@wanadoo.fr>
 <20170806225134.27079-1-christophe.jaillet@wanadoo.fr>
 <5988240C.1050702@bfs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5988240C.1050702@bfs.de>
Sender: linux-kernel-owner@vger.kernel.org
To: wharms@bfs.de
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Le 07/08/2017 à 10:25, walter harms a écrit :
>
> Am 07.08.2017 00:51, schrieb Christophe JAILLET:
>> In the lines above this test, 8 'kzalloc' are performed, but only 7 results
>> are tested.
>>
>> Add the missing one (i.e. '!ioc->port_enable_cmds.reply').
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>>   drivers/scsi/mpt3sas/mpt3sas_base.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> index 1a5b6e40fb5c..8a44636ab0b5 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> @@ -5494,10 +5494,10 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
>>   	ioc->ctl_cmds.status = MPT3_CMD_NOT_USED;
>>   	mutex_init(&ioc->ctl_cmds.mutex);
>>   
>> -	if (!ioc->base_cmds.reply || !ioc->transport_cmds.reply ||
>> -	    !ioc->scsih_cmds.reply || !ioc->tm_cmds.reply ||
>> -	    !ioc->config_cmds.reply || !ioc->ctl_cmds.reply ||
>> -	    !ioc->ctl_cmds.sense) {
>> +	if (!ioc->base_cmds.reply || !ioc->port_enable_cmds.reply ||
>> +	    !ioc->transport_cmds.reply || !ioc->scsih_cmds.reply ||
>> +	    !ioc->tm_cmds.reply || !ioc->config_cmds.reply ||
>> +	    !ioc->ctl_cmds.reply || !ioc->ctl_cmds.sense) {
>>   		r = -ENOMEM;
>>   		goto out_free_resources;
>>   	}
>
> obviously it is better to follow the pattern "malloc() , check".
Agreed, but it is also more verbose. Leavig it as-is, is IMHO, good enough.

> Even the programmer lost track.
>
> Bonus points if you malloc the buffers in one step.
Most of the allocation are 'kzalloc(ioc->reply_sz, GFP_KERNEL);', so a 
kcalloc could be used instead.
However, the 'kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);' breaks this 
logic and allocating all at once would lead to spaghetti code for no reason.

Moreover, I don't have any idea how big can be 'ioc->reply_sz', even if 
I guess it should be small.
So allocating all at once, could fail where several steps would work.

So I won't play for the bonus points :).

Best regards.
CJ

> just my 2 cents,
>
> re,
>   wh
>
>
>
