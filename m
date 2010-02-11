From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 06/11] qla4xxx: added srb referance counter
Date: Thu, 11 Feb 2010 17:54:13 -0600
Message-ID: <4B7498A5.4040307@cs.wisc.edu>
References: <20100130062856.GG10274@linux-qf4p> <4B671BFC.90107@cs.wisc.edu> <20100211110852.GB8237@linux-qf4p> <4B748B4D.5030809@cs.wisc.edu> <4B748C86.6030903@cs.wisc.edu> <0CB616B0-0903-41A0-9ADD-5DD64989FFD1@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33036 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757430Ab0BKXyc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Feb 2010 18:54:32 -0500
In-Reply-To: <0CB616B0-0903-41A0-9ADD-5DD64989FFD1@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ravi.anand" <ravi.anand@qlogic.com>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

On 02/11/2010 05:19 PM, ravi.anand wrote:
>
> On Feb 11, 2010, at 3:02 PM, Mike Christie wrote:
>
>> On 02/11/2010 04:57 PM, Mike Christie wrote:
>>> On 02/11/2010 05:08 AM, Ravi Anand wrote:
>>>> On Mon, 01 Feb 2010, Mike Christie wrote:
>>>>>
>>>>> On 01/30/2010 12:28 AM, Ravi Anand wrote:
>>>>>>
>>>>>> - msleep(2000);
>>>>>> - } while (max_wait_time--);
>>>>>> + if (got_ref&& (atomic_read(&rp->ref_count) == 1)) {
>>>>>> + done++;
>>>>>> + break;
>>>>>> + }
>>>>>> +
>>>>>> + msleep(ABORT_POLLING_PERIOD);
>>>>>
>>>>>
>>>>> Did you want to use krefs for the refcounting?
>>>>
>>>> We will add it to our to do list and submit a patch later on.
>>>> For right now we will like to stick to it as kref will require
>>>> additional testing.
>>>>
>>>>> And why is this so funky (got_ref arg and refcount peak) compared
>>>>> to the
>>>>> qla2xxx one?
>>>>
>>>> I don't think qla2xxx is doing any reference counting in eh_abort()
>>>> path.
>>>> Basically its trying to differentiate for case where it takes an
>>>> additional
>>>> reference when the cmd is with the F/W. In that case if its the last
>>>> guy,
>>>> then it can go ahead and complete the command.
>>>>
>>>
>>> got_ref is always 0 isn't it (at least in the patch it is)? It seems
>>> like you can just get rid of all that and just copy qla2xxx's code.
>>
>
> In the abort path (PATCH 10/11) it gets incremented. So its not

Ah I see.

> always zero. And the reason we need a reference is because it can
> get completed behind our back leading to a dangling srb. Since
> now two guys are working on it : eh_abort() path as well as
> the normal completion path.
>

Except for the code you added above, I am not seeing how 
qla4xxx_eh_wait_on_command interacts with the srb or why it needs a 
refcount on it. I do see why  qla4xxx_abort_task needs it. If 
qla4xxx_eh_wait_on_command does need the ref then it seems like the 
device reset path is going to have a issue.

Can't you do sp_put() after qla4xxx_abort_task(). It seems like after 
the qla4xxx_abort_task() call, then no one needs to touch the srb. 
Without your patch, qla4xxx_eh_wait_on_command does not access the srb. 
It only checks if the cmd has been completed by checking if SCp.ptr has 
been cleared.

And why does qla4xxx_eh_abort() do this loop

+       /* Check active list for command */
+       spin_lock_irqsave(&ha->hardware_lock, flags);
+       for (i = 1; i < MAX_SRBS; i++) {
+               srb_cmd = scsi_host_find_tag(ha->host, i);
+               if (srb_cmd == NULL)
+                       continue;



It seems like you would want to do

qla4xxx_wait_for_hba_online()
spin_lock_irqsave(&ha->hardware_lock, flags);

srb = (struct srb *) cmd->SCp.ptr;
if (!srb)
	/* raced while waiting for hba online */
	return SUCCESS;

/* Get a reference to the sp and drop the lock.*/
sp_get(srb);
spin_unlock_irqrestore(&ha->hardware_lock, flags);
qla4xxx_abort_task()
sp_put(ha, srb)
spin_lock_irqsave(&ha->hardware_lock, flags);

qla4xxx_eh_wait_on_command(ha, cmd);
