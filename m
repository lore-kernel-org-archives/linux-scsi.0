From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG: CD driver sends command during host removal
Date: Wed, 29 Sep 2004 15:01:10 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0409291452120.1700-100000@ida.rowland.org>
References: <415AF8A6.2080705@adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:27652 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S266275AbUI2TBL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 15:01:11 -0400
In-Reply-To: <415AF8A6.2080705@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Mohammed Sameer <uniball@gmx.net>, USB users list <linux-usb-users@lists.sourceforge.net>

On 29 Sep 2004, James Bottomley wrote:

> On Wed, 2004-09-29 at 14:02, Luben Tuikov wrote:
> > > According to Documentation/scsi/scsi_mid_low_api.txt, the only possible
> > > error returns are SCSI_MLQUEUE_DEVICE_BUSY and SCSI_MLQUEUE_HOST_BUSY.
> > > Neither is appropriate; should the second one be returned?
> >
> > I believe internally SCSI Core returns DID_ERROR.
>
> For a device that no-longer exists, DID_NO_CONNECT is probably the most
> appropriately descriptive.

Regardless of how descriptive the value is, the code in
scsi_dispatch_cmd treats anything other than SCSI_MLQUEUE_DEVICE_BUSY
as SCSI_MLQUEUE_HOST_BUSY.  Will this matter?


On Wed, 29 Sep 2004, Luben Tuikov wrote:

> Hmm, once queuecommand() has been called, SCSI Core *should NOT* touch
> the struct command until the LLDD calls scsi_done() or it times
> out and ownership is given back indirectly via the appropriate
> return result of the times_out() function.

On 29 Sep 2004, James Bottomley wrote:

> Right.  scsi_remove_host tells the mid-layer that it's OK to trash all
> inflight commands because you removed all their users before calling
> it.  It also tells us that you won't accept any future commands for this
> host (because you'll error any attempt in queuecommand).

It sounds like the two of you are in contradiction.  Should the SCSI core 
deallocate in-flight commands without consulting the LLDD or shouldn't it?

Alan Stern

