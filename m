From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 14:32:31 -0700 (PDT)
Message-ID: <20060516213231.33093.qmail@web31805.mail.mud.yahoo.com>
References: <1147797042.3505.44.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1147797042.3505.44.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jeff@garzik.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
List-Id: linux-scsi@vger.kernel.org

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Tue, 2006-05-16 at 12:06 -0400, Jeff Garzik wrote:
> > Sigh.  They clearly do not have the same effect, because the above code 
> > guarantees that a timeout is forced, regardless of whether the timer has 
> > fired or not.  That in turn guarantees that the timeout callback 
> > (->eh_timed_out) is called, and the cmd is in a very specific state.
> 
> the API claims to be forcibly aborting a command, which is *not* a
> timeout  ... trying to pretend to the midlayer that it is is the wrong

It doesn't matter.

> processing model.  You may choose to call this API because of a class

No, it is not the "wrong processng model".

> internal timeout, but you don't need the callback notification that it
> is a timeout in this case, you already know it is.

Then if you already know that it is, you MAY decide to ignore the event.
It wouldn't matter to you now would it.  Take a look at the GIT description:

  Introduce scsi_req_abort_cmd(struct scsi_cmnd *).
  This function requests that SCSI Core start recovery for the
  command by deleting the timer and adding the command to the eh
  queue.  It can be called by either LLDDs or SCSI Core.  LLDDs who
  implement their own error recovery MAY ignore the timeout event if
  they generated scsi_req_abort_cmd.

This function solves a myriad of issues, one of which is the atomic
marking of a command aborted by the transports when they've defined
BOTH the timeout callback and the error recovery callback to have complete
and consistent error recovery.

Also it doesn't matter that it is NOT a timeout as far as SCSI Core is
concerned.  Why?  Because proper status would be returned at Error Recover
time.  I.e. by the TMFs being called as part of ER.

    Luben

> 
> > Completion-or-timeout has none of these attributes.
> > 
> > Any alternative is forced to deal with two very different command, and 
> > EH, states...  to achieve the same eventual result.  Thus, the code 
> > presented is the one of least complexity, AFAICS.
> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

