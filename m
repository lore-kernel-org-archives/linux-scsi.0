From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Wed, 07 Sep 2005 14:42:14 -0400
Message-ID: <431F3486.4060704@adaptec.com>
References: <Pine.LNX.4.44L0.0509071413070.4988-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:15285 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932212AbVIGSmU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2005 14:42:20 -0400
In-Reply-To: <Pine.LNX.4.44L0.0509071413070.4988-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 09/07/05 14:27, Alan Stern wrote:
> On Wed, 7 Sep 2005, James Bottomley wrote:
> 
> 
>>On Tue, 2005-07-26 at 10:12 -0400, Alan Stern wrote:
>>
>>>This patch (as542) fixes a few loose ends left by Mike's patches.  It adds 
>>>a declaration for the new scsi_host_set_state routine, adds an allowed 
>>>transition from the SHOST_RECOVERY state to the SHOST_CANCEL state, and 
>>>avoids returning an uninitialized value in __scsi_add_device.
>>
>>The first part (external declaration) is already in.
>>
>>The second (allow RECOVERY->CANCEL) isn't really an answer.  The correct
>>thing, I suppose, is to have scsi_remove_host() wait for the error
>>handler to finish if the state transition cannot be accomodated
>>(otherwise the error handler will try to transition ->RUNNING part way
>>through the removal).
> 
> 
> I'm going to argue strongly about this.  scsi_remove_host should _not_
> wait for error recovery to complete -- to do so will invite deadlocks.  
> (Suppose the error handler is waiting for a bus reset, but the bus reset
> routine requires a semaphore held by the LLD during the call to
> scsi_remove_host?)  Furthermore, error recovery can potentially take quite
> a long time -- much longer than we want to wait during a removal event.  
> Instead, the error handler should not be allowed to make the transition to
> RUNNING once the removal has started.

Alan, this tells me one thing: the _layering_ infrastructure is broken,
and in this case, it looks like is not SCSI Core.

E.g. why is the LLDD messing with semas of the host? (rhetorical, please
do not answer as this would go into another thread...)

BTW, since the eh is a _function of the host_, James is correct that
scsi_remove_host should wait for the eh to finish.

This makes me believe that maybe USB storage would need an overhaul
of the event infra: removing and adding, and/or implement its own
eh.

	Luben


> 
> 
>>The third (don't allow uninitialised return from __scsi_add_device) is
>>correct, but the return is universally ignored (the only actual user
>>being ipr).  Unfortunately, now I look at this, ipr gets it wrong too.
>>This API currently returns an sdev with an incremented refcount.  If you
>>ignore the return, as ipr does, you're leaking refcounts.  So, since the
>>only user gets it wrong all the time, I'd vote for modifying the API not
>>to return a device.
> 
> 
> Changing the API is fine with me, but the existing code is still shaky
> because it calls scsi_alloc_target before checking scsi_host_scan_allowed.  
> Maybe that's not an out-and-out mistake, but better to avoid it.
> 
> Would you like me to submit an updated patch?
> 
> Alan Stern
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

