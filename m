From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: BUG: CD driver sends command during host removal
Date: 29 Sep 2004 14:09:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096481358.2123.74.camel@mulgrave>
References: <Pine.LNX.4.44L0.0409291239250.1167-100000@ida.rowland.org>
	<415AF8A6.2080705@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:32440 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268765AbUI2SJX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 14:09:23 -0400
In-Reply-To: <415AF8A6.2080705@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, Mohammed Sameer <uniball@gmx.net>, USB users list <linux-usb-users@lists.sourceforge.net>

On Wed, 2004-09-29 at 14:02, Luben Tuikov wrote:
> > According to Documentation/scsi/scsi_mid_low_api.txt, the only possible 
> > error returns are SCSI_MLQUEUE_DEVICE_BUSY and SCSI_MLQUEUE_HOST_BUSY.  
> > Neither is appropriate; should the second one be returned?
> 
> I believe internally SCSI Core returns DID_ERROR.

For a device that no-longer exists, DID_NO_CONNECT is probably the most
appropriately descriptive.

> >>> This would involve a race, because it's possible for
> >>>queuecommand to accept a command and then scsi_remove_host() to be called
> >>>before the command is carried out.

Correct, scsi_remove_host() is asynchronous ... you can get requests
after calling it while the queue is halting ... you must error these.

> > If the command belongs to the LLDD, why does scsi_remove_host do the
> > following:
> > 
> > 	calls scsi_host_cancel,
> > 	which calls scsi_device_cancel_cb for each device,
> > 	which calls scsi_device_cancel,
> > 	which calls scsi_finish_command for each active command,
> > 	which passes the command back to the upper layer
> > 
> > Either there's a bug in the host removal sequence, or else the LLDD 
> > doesn't own any requests once scsi_remove_host has been called.

Right.  scsi_remove_host tells the mid-layer that it's OK to trash all
inflight commands because you removed all their users before calling
it.  It also tells us that you won't accept any future commands for this
host (because you'll error any attempt in queuecommand).

James


