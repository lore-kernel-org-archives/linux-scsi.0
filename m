From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
Date: Tue, 12 May 2009 10:45:26 -0500
Message-ID: <1242143126.3308.20.camel@mulgrave.int.hansenpartnership.com>
References: <1241423927-11871-4-git-send-email-tj@kernel.org>
	 <4A06DFAB.40205@panasas.com> <4A0767E5.5050205@kernel.org>
	 <20090511145024B.fujita.tomonori@lab.ntt.co.jp>
	 <1242051500.3338.9.camel@mulgrave.int.hansenpartnership.com>
	 <4A08C094.2060602@kernel.org>
	 <1242099783.19949.8.camel@mulgrave.int.hansenpartnership.com>
	 <4A09115D.3080009@kernel.org>
	 <1242137329.3308.6.camel@mulgrave.int.hansenpartnership.com>
	 <4A0992ED.4090200@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A0992ED.4090200@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bharrosh@panasas.com, axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, dgilbert@interlog.com, djwong@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-05-13 at 00:17 +0900, Tejun Heo wrote:
> Hello, James.
> 
> James Bottomley wrote:
> >> I think it's more like how many bytes are valid where the validity is
> >> defined as the number of meaningful bytes on dev -> host commands and
> >> the number of bytes the device actually consumed on the other
> >> direction.  Please note that this is different from the number of
> >> bytes transferred due to padding or under other error conditions.
> > 
> > For failed commands we don't have that information.  All we know is how
> > many bytes were actually transferred (because the HBA keeps a count), so
> > it's the actual transfer count we use to construct the residual.  No
> > imputation of validity or otherwise.  It just says I transferred this
> > amount, based on the error make of it what you will.
> 
> Hmmm... so two separate meaning depending on command success/failure?
> I doubt high level code or user application can make much use out of
> raw transfer byte count.  It doesn't mean all that much as it varies
> depending on specific transport protocol in use.

Well, no, the definition is the same in both cases:  how much data went
over the wire.  In the success case, you assume that means the device
processed it correctly.  In the failure case you need to interpret the
error (and possibly device specific knowledge) to determine what it
means.

> >>>> * What about corner values?  What does 0 or full resid count on
> >>>>   failure mean?
> >>> 0 means everything transferred, full residual means nothing did.
> >> Yeap, I was wondering about the combination 0 resid count + failure.
> >> What would it mean?  All bytes are valid but the command failed?
> > 
> > Well, there are certain SCSI conditions called deferred errors and
> > the like where we return Check Condition but everything's OK,
> > redisual count should be zero, same goes for recovered errors
> > ... there are actually lots of things we can get back as an "error"
> > which means I'm warning you of something, but the transfer was OK.
> 
> Shouldn't those be request successful w/ sense data?  Please note that
> the term "error" in this context means failure of block layer request
> not SCSI layer CHECK SENSE.

Heh, well, this is where we get into interpretations.  For SG_IO
requests, we have three separate ways of returning error.  The error
return to the block layer, the results return and the sense code.  The
error to block is a somewhat later addition to the layer, so not all
cases are handled right or agreed (for instance we just altered BLOCK_PC
with recovered error from -EIO to no error).  So hopefully we've just
decided that deferred and current but recovered all fall into the no
error to block, but results and sense to the user.

Note that the error to block is basically discarded from SG_IO before we
return to the user, so the user *only* has results and sense to go by,
thus the concept of residual not valid on error to block is something
the user can't check.  That's why a consistent definition in all cases
(i.e. the amount of data the HBA transferred) is the correct one and
allows userspace to make the determination of what it should do based on
the returns it gets.

> > Likewise we get unit attentions (essentialy AENs) which mean I'm
> > telling you something before you start, so please try again.  Here
> > residual would be the full transfer.
> 
> And these are request failures.
> 
> > Also, we have the nasty USB case where no error return but an actual
> > residual tells you something really went wrong.
> 
> This is something to be interpreted by lld, be it usb or scsi layer,
> from block layer POV, if it's partial completion, it's success w/
> residue count.  If nothing really happened, it's request failure.
> 
> >> The behavior wasn't guaranteed before the change in paths including
> >> SG_IO fast fail one.  libata and ide have been and are completely
> >> funky about residual counts anyway so I highly doubt anyone has been
> >> depending on it.
> >>
> >> There's nothing wrong with keeping the original behavior in itself but
> >> to me it looks like it would be a bad precedence when no one should
> >> depend on the behavior.
> > 
> > OK, that's what we'll do then, thanks.
> 
> I'm still reluctant to do it because...
> 
> * Its definition still isn't clear (well, at least to me) and if it's
>   defined as the number of valid bytes on request success and the
>   number of bytes HBA transferred on request failure, I don't think
>   it's all that useful.

It's not valid bytes in either case ... it's number transferred.  One
can infer from a successful SCSI status code that number transferred ==
valid bytes, but I'd rather we didn't say that.

> * Seen from userland, residue count on request failure has never been
>   guaranteed and there doesn't seem to be any valid in kernel user.

But that's the point ... we don't define for userland what request
failure is very well.

> * It would be extra code explicitly setting the residue count to full
>   on failure path.  If it's something necessary, full residue count on
>   failure needs to be made default.  If not, it will only add more
>   confusion.

OK, so if what you're asking is that we can regard the residue as
invalid if SG_IO itself returns an error, then I can agree ... but not
if blk_end_request() returns error, because that error gets ignored by
SG_IO.

James


