From: David Milburn <dmilburn@redhat.com>
Subject: Re: [PATCH] libsas: fix/amend device gone notification in	sas_deform_port()
Date: Fri, 04 Mar 2011 16:44:53 -0600
Message-ID: <4D716B65.20007@redhat.com>
References: <20110217030659.4303.12762.stgit@localhost6.localdomain6> <4D5DB0F0.4060006@redhat.com> <4D5DBB10.4030905@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932569Ab1CDWow (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Mar 2011 17:44:52 -0500
In-Reply-To: <4D5DBB10.4030905@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "james.bottomley@suse.de" <james.bottomley@suse.de>, "Fan, Haipao" <haipao.fan@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Trela, Maciej" <Maciej.Trela@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Darrick J. Wong" <djwong@us.ibm.com>

Dan Williams wrote:
> On 2/17/2011 3:36 PM, David Milburn wrote:
>> Dan Williams wrote:
>>> Commit 56dd2c06 "libsas: Don't issue commands to devices that have been
>>> hot-removed" edited Darrick's original patch to remove setting 'gone' in
>>> the sas_deform_port() path because that prevented scsi sync cache
>>> commands from being issued when the driver was unloaded.  However, this
>>> allows true device gone notifications (as signaled port phy events) to
>>> trigger sync cache commands to devices that are known to be unreachable.
>>>
>>> Teach libsas which sas_deform_port() invocations are likely device gone
>>> events.
>>>
>>> This patch also introduces sas_device_gone() which hopefully allows
>>> subtle/tricky locking to be dropped from lldd drivers, like the
>>> following in mvsas which is broken if the ata path is ever converted to
>>> call lldd_execute_task() with irqs enabled:
>>>
>>>     flags_libsas = 0;
>>>     [...]
>>>     spin_unlock_irqrestore(dev->sata_dev.ap->lock, flags_libsas);
>>>     spin_unlock_irqrestore(&mvi->lock, flags);
>>>     t->task_done(t);
>>>     spin_lock_irqsave(&mvi->lock, flags);
>>>     spin_lock_irqsave(dev->sata_dev.ap->lock, flags_libsas);
>>>
>>> Cc: Darrick J. Wong<djwong@us.ibm.com>
>>> Cc: Haipao Fan<haipao.fan@intel.com>
>>> Cc: Maciej Trela<maciej.trela@intel.com>
>>> Cc: David Milburn<dmilburn@redhat.com>
>>> Signed-off-by: Dan Williams<dan.j.williams@intel.com>
>>> ---
>>>
>>> The sas_device_gone() change could be split into its own patch for 
>>> bisection
>>> purposes, let me know if you want me to resubmit.  This is being 
>>> driven by a
>>> lockdep error in isci as it calls task->done() from lldd_execute_task()
>>> when it finds lldd_dev == NULL for the ata domain_device.
>>
>> Dan,
>>
>> So, you are seeing sas_ata_task_done() trying to get the ata_port lock,
>> but it has already been taken earlier in the code path?
>>
>> ata_scsi_queuecmd (spin_lock_irqsave(ap->lock, irq_flags)
>>     __ata_scsi_queuecmd
>>       ata_scsi_translate
>>         ata_qc_issue
>>           sas_ata_qc_issue
>>             isci_task_execute_task
>>               isci_task_complete_for_upper_layer
>>                 sas_ata_task_done
>> (spin_lock_irqsave(dev->sata_dev.ap->lock, flags)
> 
> Exactly.
> 
> sas_device_gone() should prevent an lldd from ever attempting an i/o to 
> a missing sata device (one that has been notified via lldd_dev_gone). 
> Although, I have only had time to verify the simple unplug case and 
> sync-cache commands at driver unload.  We'll still need to handle 
> missing ssp devices, but there are no lldd-external locking concerns in 
> that path.
> 

Dan,

One other question, should sas_device_gone() be sync'ing with sata io
thru ata port lock instead of the Scsi_Host lock?

Looking at sas_queuecommand, the host_lock is released and the ata
port lock is taken before calling ata_sas_queuecmd, and ata port lock is 
held
down the __ata_scsi_queuecmd path.

Should sas_device_gone get the ap->lock from the domain_device->
sata_dev to better sync against sata io?

Thanks,
David



> -- 
> Dan

