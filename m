From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: BUG: CD driver sends command during host removal
Date: Wed, 29 Sep 2004 15:33:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <415B0DF0.2020600@adaptec.com>
References: <Pine.LNX.4.44L0.0409291452120.1700-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:25021 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S268590AbUI2TdV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 15:33:21 -0400
In-Reply-To: <Pine.LNX.4.44L0.0409291452120.1700-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Mohammed Sameer <uniball@gmx.net>, USB users list <linux-usb-users@lists.sourceforge.net>

Alan Stern wrote:
> On Wed, 29 Sep 2004, Luben Tuikov wrote:
> 
>  > Hmm, once queuecommand() has been called, SCSI Core *should NOT* touch
>  > the struct command until the LLDD calls scsi_done() or it times
>  > out and ownership is given back indirectly via the appropriate
>  > return result of the times_out() function.
> 
> On 29 Sep 2004, James Bottomley wrote:
> 
>  > Right.  scsi_remove_host tells the mid-layer that it's OK to trash all
>  > inflight commands because you removed all their users before calling
>  > it.  It also tells us that you won't accept any future commands for this
>  > host (because you'll error any attempt in queuecommand).
> 
> It sounds like the two of you are in contradiction.  Should the SCSI core
> deallocate in-flight commands without consulting the LLDD or shouldn't it?

If the host is really gone, then no pending commands would
ever "return".

This means that the LLDD can call scsi_done() immediately, without
any waiting or delay of any sort.

Basically, when your host is gone, plug queuecommand(), call
scsi_done() on all your pending commands, and call scsi_remove_host().
The only problem would be if you have to sleep while "recovering"
the pending commands, but I cannot imagine why you'd do that
as your host is gone.

Now since LLDD shouldn't keep internal queues of pending commands,
ideally, this function is left to SCSI Core.

	Luben









