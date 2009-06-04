From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] blk_abort_queue on failed paths?
Date: Thu, 04 Jun 2009 13:02:09 -0500
Message-ID: <4A280C21.6020007@cs.wisc.edu>
References: <448b15030906021555j4e476193kcf69e019992dc592@mail.gmail.com>	<4A26ED7D.1010203@cs.wisc.edu>	<20090604171817.GA6995@linux.vnet.ibm.com> <4A280ACD.8070708@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41729 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbZFDSC3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jun 2009 14:02:29 -0400
In-Reply-To: <4A280ACD.8070708@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Christie wrote:
> Mike Anderson wrote:
>> Mike Christie <michaelc@cs.wisc.edu> wrote:
>>> adding linux-scsi and Mike Anderson
>>>
>>> David Strand wrote:
>>>> After updating to kernel 2.6.28 I found that when I performed some
>>>> cable break testing during device i/o, I would get unwanted device or
>>>> host resets. Ultimately I traced it back to this patch:
>>>>
>>>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=commit;h=224cb3e981f1b2f9f93dbd49eaef505d17d894c2 
>>>>
>>>>
>>>> The call to blk_abort_queue causes the block layer to call
>>>> scsi_times_out for pending i/o, which can (or will) ultimately lead to
>>>> device, and/or bus and/or host resets, which of course cause all the
>>>> other devices significant disruption.
>>>>
>>> What driver were you using? I just did a work around for qla4xxx for  
>>> this (have not posted it yet). I added a scsi_times_out handler to 
>>> the  driver so that if the IO was failed to a transport problem then 
>>> the eh  does not run.
>>>
>>> FC drivers already use fc_timed_out, but I think that will not work. 
>>> The  FC driver could fail the IO then call fc_remote_port_delete. So 
>>> the  failed IO could hit dm-mpath.c and that could call into the  
>>> scsi_times_out (which for fc drivers call into fc_timed_out) but the  
>>> fc_remote_port_delete has not been done yet, so the port_state is 
>>> still  online so that kicks off the scsi eh.
>>>
>>
>> For HA link transport failure cases the waking of scsi_eh should not
> 
> 
> What is a HA link transport failure?
> 
> 
>> matter. For tgt link transport failures the waking of scsi_eh is not 
>> good.
>> Previous test runs with added debug I only saw a few case of going 
>> into the
>> abort routines, but maybe my test configs where not complete (timing of
>> the workqueues running will alter the outcome also). I will look into 
>> this
> 
> 
> I think going into the abort routines is still bad. If are in the scsi 
> eh then all IO on that host is stopped. So if you had two ports coming 
> on that host, and if just one path is bad, now we cannot send IO on the 
> other path until the scsi eh is done running. This could be quick, but 
> for FC drivers we also do not just send an abort right away. If we have 
> transitioned the port state to blocked by this time, then drivers wait 
> for the port state to transition like this:
> 
> static void
> qla2x00_block_error_handler(struct scsi_cmnd *cmnd)
> {
>         struct Scsi_Host *shost = cmnd->device->host;
>         struct fc_rport *rport = 
> starget_to_rport(scsi_target(cmnd->device));
>         unsigned long flags;
> 
>         spin_lock_irqsave(shost->host_lock, flags);
>         while (rport->port_state == FC_PORTSTATE_BLOCKED) {
>                 spin_unlock_irqrestore(shost->host_lock, flags);
>                 msleep(1000);
>                 spin_lock_irqsave(shost->host_lock, flags);
>         }
>         spin_unlock_irqrestore(shost->host_lock, flags);
>         return;
> }
> 

Oh yeah for this, is it right? Maybe we only want to wait for min(time 
of port state transition (dev loss tmo or port readdition), fast io fail 
tmo firing)?

It would still be a wait, but a shorter one at least.
