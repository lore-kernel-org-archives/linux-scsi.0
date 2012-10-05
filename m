From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [qla2xxx] INFO: possible irq lock inversion dependency detected
Date: Fri, 05 Oct 2012 17:25:30 +0530
Message-ID: <506ECAB2.2050005@linux.vnet.ibm.com>
References: <506D80C2.5040405@linux.vnet.ibm.com> <alpine.LNX.2.00.1210041500010.9942@pobox.suse.cz> <506DAE41.6040007@linux.vnet.ibm.com> <1349376255.740.11.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1349376255.740.11.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>
List-Id: linux-scsi@vger.kernel.org


Hi Nicholas,

On 10/05/2012 12:14 AM, Nicholas A. Bellinger wrote:
> On Thu, 2012-10-04 at 21:11 +0530, Srivatsa S. Bhat wrote:
>> Hi Jiri,
>>
>> Thanks for taking a look!
> 
> Hi Srivatsa & Jiri,
> 
>>  
>>> This seems to be real. You should be seeing that since 3.5-rc1 already 
>>> though ... ?
>>>
>>> Does the patch below fix that?
>>>
>>
>> Yes, it does, thanks! But 3.6-rc kernels were booting fine as far as I remember.
>> I'll check again and get back tomorrow.
>>
> 
> Thanks for testing with v3.7-rc0 code !
> 
> Cc'ing the Qlogic folks here, as this irq lock inversion warning appears
> to be regression from v3.7-rc1 qla2xxx (initiator) LLD changes that went
> in recently via scsi.git.
> 

Actually Jiri is right - I am seeing this with 3.5-rc1 kernel also. So its not
a regression from this merge window.. it was there all along!

Regards,
Srivatsa S. Bhat

> 
>>>
>>> From: Jiri Kosina <jkosina@suse.cz>
>>> Subject: [PATCH] [SCSI] qla2xxx: fix potential deadlock on ha->hardware_lock
>>>
>>> Lockdep reports:
>>>
>>> === [ cut here ] ===
>>>  =========================================================
>>>  [ INFO: possible irq lock inversion dependency detected ]
>>>  3.6.0-0.0.0.28.36b5ec9-default #1 Not tainted
>>>  ---------------------------------------------------------
>>>  qla2xxx_1_dpc/368 just changed the state of lock:
>>>   (&(&ha->vport_slock)->rlock){+.....}, at: [<ffffffffa009b377>] qla2x00_configure_hba+0x197/0x3c0 [qla2xxx]
>>>  but this lock was taken by another, HARDIRQ-safe lock in the past:
>>>   (&(&ha->hardware_lock)->rlock){-.....}
>>>
>>> and interrupts could create inverse lock ordering between them.
>>>
>>> other info that might help us debug this:
>>>  Possible interrupt unsafe locking scenario:
>>>
>>>        CPU0                    CPU1
>>>        ----                    ----
>>>   lock(&(&ha->vport_slock)->rlock);
>>>                                local_irq_disable();
>>>                                lock(&(&ha->hardware_lock)->rlock);
>>>                                lock(&(&ha->vport_slock)->rlock);
>>>   <Interrupt>
>>>     lock(&(&ha->hardware_lock)->rlock);
>>> === [ cut here ] ===
>>>
>>> Fix the potential deadlock by disabling IRQs while holding ha->vport_slock.
>>>
>>> Reported-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>>> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>>
>> Tested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>>
>> Regards,
>> Srivatsa S. Bhat
>>
>>> ---
>>>  drivers/scsi/qla2xxx/qla_init.c |    5 +++--
>>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
>>> index 799a58b..48fca47 100644
>>> --- a/drivers/scsi/qla2xxx/qla_init.c
>>> +++ b/drivers/scsi/qla2xxx/qla_init.c
>>> @@ -2080,6 +2080,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
>>>  	uint8_t       domain;
>>>  	char		connect_type[22];
>>>  	struct qla_hw_data *ha = vha->hw;
>>> +	unsigned long flags;
>>>
>>>  	/* Get host addresses. */
>>>  	rval = qla2x00_get_adapter_id(vha,
>>> @@ -2154,9 +2155,9 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
>>>  	vha->d_id.b.area = area;
>>>  	vha->d_id.b.al_pa = al_pa;
>>>
>>> -	spin_lock(&ha->vport_slock);
>>> +	spin_lock_irqsave(&ha->vport_slock, flags);
>>>  	qlt_update_vp_map(vha, SET_AL_PA);
>>> -	spin_unlock(&ha->vport_slock);
>>> +	spin_unlock_irqrestore(&ha->vport_slock, flags);
>>>
>>>  	if (!vha->flags.init_done)
>>>  		ql_log(ql_log_info, vha, 0x2010,
>>>
>>
