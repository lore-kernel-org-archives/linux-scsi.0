From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 14:55:37 -0700 (PDT)
Message-ID: <20060516215537.90788.qmail@web31811.mail.mud.yahoo.com>
References: <446A0031.1080209@garzik.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31811.mail.mud.yahoo.com ([68.142.207.74]:11652 "HELO
	web31811.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1750765AbWEPVzh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 17:55:37 -0400
In-Reply-To: <446A0031.1080209@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

--- Jeff Garzik <jeff@garzik.org> wrote:
> James Bottomley wrote:
> > On Tue, 2006-05-16 at 12:06 -0400, Jeff Garzik wrote:
> >> Sigh.  They clearly do not have the same effect, because the above code 
> >> guarantees that a timeout is forced, regardless of whether the timer has 
> >> fired or not.  That in turn guarantees that the timeout callback 
> >> (->eh_timed_out) is called, and the cmd is in a very specific state.
> > 
> > the API claims to be forcibly aborting a command, which is *not* a
> > timeout  ... trying to pretend to the midlayer that it is is the wrong
> > processing model.  You may choose to call this API because of a class
> > internal timeout, but you don't need the callback notification that it
> > is a timeout in this case, you already know it is.
> 
> I can certainly agree the name may not be the best choice.  Naming based 
> on implementation, it could be scsi_force_timeout_cmd() or somesuch.

But it is not that either!

As far as the LLDD is concerned, it is calling scsi_req_abort_cmd() to
request SCSI Core to abort it.  At the point of LLDD calling this function
the command is not marked anything.  This is important!

Why?

Because LLDD/interconnects 
 1. Do not want to race with SCSI Core changing the state of the command.
 2. You want to give LLDD a chance as the command may finish in due time since
    the interconnect requested it be aborted.  I.e. there could be a race in the
    transport too, which doesn't depend on the transport but on the end device, SDS,
    and the transport.
    
For these reasons the best bet is to emulate a time out so that SCSI Core calls back
into the transport to tell the transpor that, it, SCSI Core, is about to start ER
on the command.

Then LLDD/interconnects have another chance, plus it gives notification to LLDD/IC
that SCSI Core has changed its disposition of that command.

     Luben


