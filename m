From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Mon, 24 Nov 2003 07:48:30 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031124074830.C29095@infradead.org>
References: <20031027153932.A16679@infradead.org> <00c901c3b251$91016a30$a0074d0a@apac.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:56069 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263650AbTKXHsb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 02:48:31 -0500
Content-Disposition: inline
In-Reply-To: <00c901c3b251$91016a30$a0074d0a@apac.cisco.com>; from surekhap@cisco.com on Mon, Nov 24, 2003 at 11:39:48AM +0530
List-Id: linux-scsi@vger.kernel.org
To: "Surekha.PC" <surekhap@cisco.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, linux-scsi@vger.kernel.org

On Mon, Nov 24, 2003 at 11:39:48AM +0530, Surekha.PC wrote:
> 
> Hi,
> 
> >>  	- this comment indicates you don't want normal EH:
> 
> >> * check condition with no sense.  We need to avoid this, 
> >> * since the Linux SCSI code could put the command in 
> >> * SCSI_STATE_FAILED, which it's error recovery doesn't appear 
> >> * to handle correctly, and even if it does, we're trying to 
> >> * bypass all of the Linux error recovery code
> >> * to avoid blocking all I/O to the HBA.  Fake some sense 
> >> * data that gets a retry from Linux.
> 
> >	so don't use scsi_error.c and define your own
> eh_strategy_handler method.
> 
> By implementing the iSCSI driver specific strategy_handler we will need
> to duplicate most of the mid layer strategy handler logic only to
> accommodate the above condition.
> 
> Is that justified ? Or is it ok, to fix the above case in scsi_error.c ?

I haven't followed the code closely, but the comment reads like scsi_error.c
is mostly useless for you - if that were true I'd suggest using
eh_strategy_handler, if on the other hand you can fix scsi_error.c easily
it's better to use it.

