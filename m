From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Mon, 24 Nov 2003 12:45:43 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031124124543.A1017@beaverton.ibm.com>
References: <20031027153932.A16679@infradead.org> <00c901c3b251$91016a30$a0074d0a@apac.cisco.com> <20031124074830.C29095@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:53642 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261522AbTKXUsG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 15:48:06 -0500
Content-Disposition: inline
In-Reply-To: <20031124074830.C29095@infradead.org>; from hch@infradead.org on Mon, Nov 24, 2003 at 07:48:30AM +0000
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: "Surekha.PC" <surekhap@cisco.com>, linux-scsi@vger.kernel.org

On Mon, Nov 24, 2003 at 07:48:30AM +0000, 'Christoph Hellwig' wrote:
> On Mon, Nov 24, 2003 at 11:39:48AM +0530, Surekha.PC wrote:
> > 
> > Hi,
> > 
> > >>  	- this comment indicates you don't want normal EH:
> > 
> > >> * check condition with no sense.  We need to avoid this, 
> > >> * since the Linux SCSI code could put the command in 
> > >> * SCSI_STATE_FAILED, which it's error recovery doesn't appear 
> > >> * to handle correctly, and even if it does, we're trying to 
> > >> * bypass all of the Linux error recovery code
> > >> * to avoid blocking all I/O to the HBA.  Fake some sense 
> > >> * data that gets a retry from Linux.
> > 
> > >	so don't use scsi_error.c and define your own
> > eh_strategy_handler method.
> > 
> > By implementing the iSCSI driver specific strategy_handler we will need
> > to duplicate most of the mid layer strategy handler logic only to
> > accommodate the above condition.
> > 
> > Is that justified ? Or is it ok, to fix the above case in scsi_error.c ?
> 
> I haven't followed the code closely, but the comment reads like scsi_error.c
> is mostly useless for you - if that were true I'd suggest using
> eh_strategy_handler, if on the other hand you can fix scsi_error.c easily
> it's better to use it.

The eh_strategy_handler only allows changing what happens after error
handling has started, but cannot modify when the error handler runs.

Using your own won't "avoid blocking all I/O to the HBA".

i.e., we wake up the error handler in scsi_error.c via:

void scsi_eh_wakeup(struct Scsi_Host *shost)
{
	if (shost->host_busy == shost->host_failed) {
		up(shost->eh_wait);
		SCSI_LOG_ERROR_RECOVERY(5,
				printk("Waking error handler thread\n"));
	}
}

We need a new timeout + canceller mechanism, so that a single command can
be cancelled without waiting for all other IO on an adapter to complete.
Errors must still escalate some how so device, bus, or adapter resets can
(under some conditions) still be issued.

The qla2xxx hacks around this by adding its own timer that is shorter than
the scsi cmd timeout. Is that a good or a bad hack? I don't know.

-- Patrick Mansfield
