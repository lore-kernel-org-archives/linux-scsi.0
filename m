From: Naveen Burmi <naveenb@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Thu, 11 Dec 2003 18:01:08 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <03121118010802.15757@naveenb-lnx.cisco.com>
References: <20031027153932.A16679@infradead.org> <00c901c3b251$91016a30$a0074d0a@apac.cisco.com> <20031124074830.C29095@infradead.org>
Reply-To: naveenb@cisco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:17015 "EHLO
	sj-iport-2.cisco.com") by vger.kernel.org with ESMTP
	id S264922AbTLKM3E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2003 07:29:04 -0500
In-Reply-To: <20031124074830.C29095@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: "Surekha.PC" <surekhap@cisco.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, linux-scsi@vger.kernel.org



On Monday 24 November 2003 01:18 pm, 'Christoph Hellwig' wrote:
> On Mon, Nov 24, 2003 at 11:39:48AM +0530, Surekha.PC wrote:
> > Hi,
> >
> > >>  	- this comment indicates you don't want normal EH:
> > >>
> > >> * check condition with no sense.  We need to avoid this,
> > >> * since the Linux SCSI code could put the command in
> > >> * SCSI_STATE_FAILED, which it's error recovery doesn't appear
> > >> * to handle correctly, and even if it does, we're trying to
> > >> * bypass all of the Linux error recovery code
> > >> * to avoid blocking all I/O to the HBA.  Fake some sense
> > >> * data that gets a retry from Linux.
> > >
> > >	so don't use scsi_error.c and define your own
> >
> > eh_strategy_handler method.
> >
> > By implementing the iSCSI driver specific strategy_handler we will need
> > to duplicate most of the mid layer strategy handler logic only to
> > accommodate the above condition.
> >
> > Is that justified ? Or is it ok, to fix the above case in scsi_error.c ?
>
> I haven't followed the code closely, but the comment reads like
> scsi_error.c is mostly useless for you - if that were true I'd suggest
> using
> eh_strategy_handler, if on the other hand you can fix scsi_error.c easily
> it's better to use it.

James Bottomley agreed to add "DID_" code which ensures retry of scsi 
command without affecting the retry count.
Once that will be in place then instead of faking sense data in case of 
"check condition with no sense" iSCSI LLD will use it to make sure command 
will be retried.

Naveen.
