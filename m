From: Tejun Heo <htejun@gmail.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Wed, 17 May 2006 01:08:38 +0900
Message-ID: <4469F906.7040602@gmail.com>
References: <4468B596.9090508@garzik.org>	 <1147789098.3505.19.camel@mulgrave.il.steeleye.com>	 <4469F2B2.703@garzik.org> <1147794708.3505.30.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:58197 "EHLO
	py-out-1112.google.com") by vger.kernel.org with ESMTP
	id S1751844AbWEPQIt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 12:08:49 -0400
Received: by py-out-1112.google.com with SMTP id w49so6984pyg
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2006 09:08:48 -0700 (PDT)
In-Reply-To: <1147794708.3505.30.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

James Bottomley wrote:
> On Tue, 2006-05-16 at 11:41 -0400, Jeff Garzik wrote:
>> I can't see a case _in libata operation_ where a set of circumstances 
>> arises that causes missed wakeups, can you elaborate?
> 
> This is scsi_eh_wakeup():
> 
> void scsi_eh_wakeup(struct Scsi_Host *shost)
> {
> 	if (shost->host_busy == shost->host_failed) {
> 		wake_up_process(shost->ehandler);
> 
> so if you try a wakeup with no failed commands and the host still busy,
> nothing happens.

It's handled the same way shost->host_failed is handled.
scsi_device_unbusy() wakes it up when the condition is met.

void scsi_device_unbusy(struct scsi_device *sdev)
{
	struct Scsi_Host *shost = sdev->host;
	unsigned long flags;

	spin_lock_irqsave(shost->host_lock, flags);
	shost->host_busy--;
	if (unlikely(scsi_host_in_recovery(shost) &&
		     (shost->host_failed || shost->host_eh_scheduled)))
		scsi_eh_wakeup(shost);
	spin_unlock(shost->host_lock);
	spin_lock(sdev->request_queue->queue_lock);
	sdev->device_busy--;
	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
}

[--snip--]
>>> 2) This scsi_req_abort_cmd() is fundamentally the wrong logic.
>>> Everything else is communicated back as a result code from the command
>>> in done().  This should be no different ... A status return of
>>> DID_FAILED which scsi_decide_disposition() always translates to FAILED
>>> would seem to do exactly what you want without all the overhead.
>> Inigo sez[1]:  I do not think "fundamentally wrong" means what you think 
>> it means.

Currently, there is no reliable way to trigger DID_FAILED
unconditionally.  I thought about adding some host code or whatever to
force it but it felt too hackish and went with the
scsi_eh_schedule_scmd().  Then, Luben suggested scsi_req_abort_cmd(), so
that's what I've ended up with.

>> You miss the fact that the timer may have already fired, in which 
>> completing a command gets you...... not a damned thing.  scsi_done() 
>> will simply return, if the timeout has fired.  This has always been an 
>> annoying problem to work around.
> 
> No ... in that case the eh is already active, and your API does this:
> 
> void scsi_req_abort_cmd(struct scsi_cmnd *cmd)
> {
> 	if (!scsi_delete_timer(cmd))
> 		return;
> 		^^^^^^^
> 	scsi_times_out(cmd);
> }
> 
> Which likewise does nothing if the timer has already fired, so they both
> have the same effect.

-- 
tejun
