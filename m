From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: BUG: CD driver sends command during host removal
Date: Wed, 29 Sep 2004 14:02:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <415AF8A6.2080705@adaptec.com>
References: <Pine.LNX.4.44L0.0409291239250.1167-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:12171 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S268752AbUI2SCb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 14:02:31 -0400
In-Reply-To: <Pine.LNX.4.44L0.0409291239250.1167-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Mohammed Sameer <uniball@gmx.net>, USB users list <linux-usb-users@lists.sourceforge.net>

Alan Stern wrote:
> 
>>>Next usb-storage called scsi_remove_host().  Apparently this caused some
>>>component of the CD driver to queue a command:
> 
> 
> This sounds like a bug, by the way.  Commands shouldn't be queued because 
> of a call to scsi_remove_host!

Yes.

>>>usb-storage accepted the command but then ignored it because the host was
>>>in process of removal.  Should the queuecommand routine have rejected the
>>>command?
>>
>>Yes, if the service delivery subsystem (SDS) knows that the device is gone
>>and the command wouldn't be delivered, it should *not* "ignore" the
>>command, but return it with error.
>>
>>I.e. if the LLDD has active/most recent knowledge about the device
>>whereto the command is destined, it should act on that and return
>>an appropriate error.  After all, this is what a properly implemented
>>SDS would do.
> 
> 
> According to Documentation/scsi/scsi_mid_low_api.txt, the only possible 
> error returns are SCSI_MLQUEUE_DEVICE_BUSY and SCSI_MLQUEUE_HOST_BUSY.  
> Neither is appropriate; should the second one be returned?

I believe internally SCSI Core returns DID_ERROR.

> 
>>> This would involve a race, because it's possible for
>>>queuecommand to accept a command and then scsi_remove_host() to be called
>>>before the command is carried out.
>>
>>If the command hasn't been carried out, then delivery would fail and SDS
>>would return the appropriate error back to SCSI Core.
> 
> 
> How?  The SCSI core deallocates the scsi_cmnd before the SDS has a chance 
> to return anything.

Hmm, once queuecommand() has been called, SCSI Core *should NOT* touch
the struct command until the LLDD calls scsi_done() or it times
out and ownership is given back indirectly via the appropriate
return result of the times_out() function.

>>Where *was* the command?  From the point of time when queuecommand() is
>>called until scsi_done() is called, the command belongs to the LLDD.
>>It should honor any TMF, regardless of the _state_ of the task.
> 
> 
> If the command belongs to the LLDD, why does scsi_remove_host do the
> following:
> 
> 	calls scsi_host_cancel,
> 	which calls scsi_device_cancel_cb for each device,
> 	which calls scsi_device_cancel,
> 	which calls scsi_finish_command for each active command,
> 	which passes the command back to the upper layer
> 
> Either there's a bug in the host removal sequence, or else the LLDD 
> doesn't own any requests once scsi_remove_host has been called.

Ah, definitely sounds like a bug -- the LLDD has not been given
a chance to "return" the struct command.

One thing I wanted to point out is that in scsi_remove_host()
the _very_ first thing which should be done is setting
the proper shost_state, SHOST_DEL, which should imply
SHOST_CANCEL (by virtue of meaning), as opposed to "doubly"
setting it.

_Thought_ experiment: is it possibe to "catch" a command between
a non-canceled host but canceled device (of that host)?

So, first the host state is set to "cancelled", then each
device is set accordingly, then commands sent to each device
are "recovered" (all this top->down); and then
the resources freed in opposite order: commands, devices,
hosts.  This may involve waiting for the LLDD to respond
in the recovery process.

	Luben


