From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] first cut at fixing unable to requeue with no outstanding commands
Date: Tue, 1 Oct 2002 09:23:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021001162347.GA1242@beaverton.ibm.com>
References: <20021001080115.A27028@eng2.beaverton.ibm.com> <200210011514.g91FEC703750@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210011514.g91FEC703750@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley [James.Bottomley@steeleye.com] wrote:
> patmans@us.ibm.com said:
> > What about applications and devices that only send one IO at a time?
> > They could still hang.
> 
> > We have: tape (st or osst), sg usage, partitioning, scanning, direct
> > use of the block device (i.e. dd if=/dev/sda), and probably others. 
> 
> I don't believe so.
> 
> Unplugging is a global thing.  The request function for a plugged queue will 
> always be run, that's a guarantee, so using this approach, the queue will 
> stall but never hang forever.
> 
> I think for a rejection of a command with none outstanding, a stall is what 
> you want (give the host/device time to recover from whatever the problem is).  
> The length of the stall will be dependent on I/O pressure in the system, which 
> is also roughly what you want: we can afford to give a device quite a while to 
> recover if we're not desparate to get I/O to it. We can also handle BUSY 
> returns this way too...
> 
> James

ok I see the call path now. I was unsure that blk_run_queues would be
called for non-fs IO.

I traced a dd (dd if=/dev/sda of=/dev/null count=2 bs=512) command under
uml with a modified scsi_debug to return 1 on a queuecommand call and
your patch. The trace showed blk_run_queues being called through
wb_kupdate.

#0  scsi_request_fn (...) at scsi_lib.c:738
#1  0xa00beda2 in blk_run_queues () at ll_rw_blk.c:1045
#2  0xa004fb0d in wb_kupdate (...) at page-writeback.c:270
#3  0xa004f6c9 in __pdflush (...) at pdflush.c:130
#4  0xa004f76e in pdflush (...) at pdflush.c:178
#5  0xa001aba4 in run_kernel_thread (...) at process.c:232


Since you are modifying scsi_mlqueue_insert what about a couple of these
cleanups.

	- Is the call to scsi_delete_timer really necessary. All callers
	  have already deleted the timer. The del_timer function takes a
	  lock which would be nice to avoid if we do not need to call
	  it.  If we want to protect the code we could do a quick check
	  on SCset->eh_timeout.function prior to calling.

	- Patrick pointed out a while ago that the "if (host->host_busy
	  == 0)" check and the similar one for the device will never be
	  called because to be in this function the values of these
	  variables need to be at least 1. I believe this direct call to
	  scsi_retry_command should be removed instead of adjusting the
	  check to "== 1" as this seems counter to how you are trying to
	  handle busy.

-andmike
--
Michael Anderson
andmike@us.ibm.com

