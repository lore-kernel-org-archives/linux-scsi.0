From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: megaraid_sas: add an i/o barrier
Date: Mon, 1 Feb 2016 13:53:25 +0100
Message-ID: <56AF5545.3050707@redhat.com>
References: <56ABA2C5.6060603@redhat.com>
 <5955d77ec60a460d09e5480cf7928177@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbcBAMx1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2016 07:53:27 -0500
In-Reply-To: <5955d77ec60a460d09e5480cf7928177@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, linux-scsi@vger.kernel.org
Cc: Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>

On 1.2.2016 05:45, Kashyap Desai wrote:
>> -----Original Message-----
>> From: Tomas Henzl [mailto:thenzl@redhat.com]
>> Sent: Friday, January 29, 2016 11:05 PM
>> To: 'linux-scsi@vger.kernel.org'
>> Cc: Sumit.Saxena@avagotech.com; Desai, Kashyap; Uday Lingala
>> Subject: megaraid_sas: add an i/o barrier
>>
>> A barrier should be added to ensure proper ordering of memory mapped
>> writes.
>>
>> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
>> ---
>>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> index d9d0029fb1..98a848bdfd 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> @@ -204,6 +204,7 @@ megasas_fire_cmd_fusion(struct
>> megasas_instance *instance,
>>  		&instance->reg_set->inbound_low_queue_port);
>>  	writel(le32_to_cpu(req_desc->u.high),
>>  		&instance->reg_set->inbound_high_queue_port);
>> +	mmiowb();
>>  	spin_unlock_irqrestore(&instance->hba_lock, flags);  #endif  }
> Tomas-
>
> We may need similar changes around below Functions as well, because there is
> no associated readX or mmiowb() call.
> megasas_fire_cmd_xscale()
> megasas_fire_cmd_ppc()
> megasas_fire_cmd_skinny()
> megasas_fire_cmd_gen2()
>
> Also,  wrireq() routine in same function megasas_fire_cmd_fusion() need i/o
> barrier.

I don't think so (with the exception of megasas_fire_cmd_skinny - I missed this one).
When two threads try to use a fire_cmd there is no protection of certain ordering,
that had to be done in a caller of fire_cmd (for example in megasas_build_and_issue_cmd_fusion)
and it seems to me that there is nothing like that. Likely is, that this - a strict ordering 
of commands - is not needed.
The protection which I'm adding is needed when a command consist of a sequence of more
than one write, see memory-barriers.txt.

(It looks to me that 
megasas_fire_cmd_ -xscale -ppc -skiny -gen2 do not need the hba_lock unless there is another
i/o sequence protected with the same lock (note also that there is
no such lock in megasas_fire_cmd_fusion).)


I'll add the mmiowb to megasas_fire_cmd_skinny and send a new patch - agreed?

--tms

>
>> --
>> 2.4.3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

