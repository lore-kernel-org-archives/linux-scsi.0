From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: blk_abort_queue on failed paths?
Date: Thu, 04 Jun 2009 12:56:29 -0500
Message-ID: <4A280ACD.8070708@cs.wisc.edu>
References: <448b15030906021555j4e476193kcf69e019992dc592@mail.gmail.com>
	<4A26ED7D.1010203@cs.wisc.edu>
	<20090604171817.GA6995@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090604171817.GA6995@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Mike Anderson wrote:
> Mike Christie <michaelc@cs.wisc.edu> wrote:
>> adding linux-scsi and Mike Anderson
>>
>> David Strand wrote:
>>> After updating to kernel 2.6.28 I found that when I performed some
>>> cable break testing during device i/o, I would get unwanted device or
>>> host resets. Ultimately I traced it back to this patch:
>>>
>>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=commit;h=224cb3e981f1b2f9f93dbd49eaef505d17d894c2
>>>
>>> The call to blk_abort_queue causes the block layer to call
>>> scsi_times_out for pending i/o, which can (or will) ultimately lead to
>>> device, and/or bus and/or host resets, which of course cause all the
>>> other devices significant disruption.
>>>
>> What driver were you using? I just did a work around for qla4xxx for  
>> this (have not posted it yet). I added a scsi_times_out handler to the  
>> driver so that if the IO was failed to a transport problem then the eh  
>> does not run.
>>
>> FC drivers already use fc_timed_out, but I think that will not work. The  
>> FC driver could fail the IO then call fc_remote_port_delete. So the  
>> failed IO could hit dm-mpath.c and that could call into the  
>> scsi_times_out (which for fc drivers call into fc_timed_out) but the  
>> fc_remote_port_delete has not been done yet, so the port_state is still  
>> online so that kicks off the scsi eh.
>>
> 
> For HA link transport failure cases the waking of scsi_eh should not


What is a HA link transport failure?


> matter. For tgt link transport failures the waking of scsi_eh is not good.
> Previous test runs with added debug I only saw a few case of going into the
> abort routines, but maybe my test configs where not complete (timing of
> the workqueues running will alter the outcome also). I will look into this


I think going into the abort routines is still bad. If are in the scsi 
eh then all IO on that host is stopped. So if you had two ports coming 
on that host, and if just one path is bad, now we cannot send IO on the 
other path until the scsi eh is done running. This could be quick, but 
for FC drivers we also do not just send an abort right away. If we have 
transitioned the port state to blocked by this time, then drivers wait 
for the port state to transition like this:

static void
qla2x00_block_error_handler(struct scsi_cmnd *cmnd)
{
         struct Scsi_Host *shost = cmnd->device->host;
         struct fc_rport *rport = 
starget_to_rport(scsi_target(cmnd->device));
         unsigned long flags;

         spin_lock_irqsave(shost->host_lock, flags);
         while (rport->port_state == FC_PORTSTATE_BLOCKED) {
                 spin_unlock_irqrestore(shost->host_lock, flags);
                 msleep(1000);
                 spin_lock_irqsave(shost->host_lock, flags);
         }
         spin_unlock_irqrestore(shost->host_lock, flags);
         return;
}

So we are stuck in the scsi eh until the dev loss timeo fires. There is 
a similar problem for some iscsi drivers.



> more. The original described failure case of getting host resets is not
> good though and would like to understand how we get this far.
> 
>> For transport errors I do not think blk_abort_queue is needed anymore -  
>> at least for scsi drivers. For FC almost every driver supports the  
>> terminate_rport_io call back (just mptfc does not), so you can set the  
>> fast io fail tmo to make sure all IO is failed quickly. For iscsi, we  
>> have the replacement/recovery_timeout. And for SAS, I think there is a  
>> timeout or the device/target/port is deleted, right?
>>
>>
> 
> Yes. (I believe there is an end case that others have discussed in the past
> that path checkers or other requests without the fast_fail flag set may
> wait until devloss).

That is not really there any more. Set the fast io fail tmo and IO is 
failed before dev loss.

The exceptions are for mptfc (does not have a terminate rport io 
callback) and for the scsi eh case like above where the scsi eh starts 
up then the port is deleted (so we miss the fc_timed_out check) and then 
drivers block until the port state transistions.

> 
>>> What was the reason for this change? I searched through my email from
>>> this mailing list and could not find a discussion about it.
>>
>> It seems like it would only make sense to call blk_abort_queue for maybe  
>> some block drivers (does cciss or dasd need it) or maybe for device  
>> errors. But it seems to be broken for the common multipath use cases.
> 
> One usage is to handle the case of slow multipath failover where devices
> are still responsive on the transport, but are not completing IOs. We can
> see a very long delay depending on IO timeout value vs. queue depth of the
> target.

I did not get that part. What component is bad? If you change paths, 
don't you just send IO to the same device? Is this that dasd setup? Or 
does device above mean the target controller or can you access a 
different logical unit through different ports on some multipath setups 
(some sort of clustering magic?)?

And also for this problem, what type of failure is it? Are drivers 
returning a DID_* error for this? Or is it some scsi error?
