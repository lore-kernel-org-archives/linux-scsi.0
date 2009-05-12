From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
Date: Tue, 12 May 2009 10:34:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905121023220.2824-100000@iolanthe.rowland.org>
References: <1242137329.3308.6.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1242137329.3308.6.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bharrosh@panasas.com, axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, dgilbert@interlog.com, djwong@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 12 May 2009, James Bottomley wrote:

> On Tue, 2009-05-12 at 15:04 +0900, Tejun Heo wrote:
> > Hello, James.
> > 
> > James Bottomley wrote:
> > >> * Not well defined.  What does it mean really?  It can't indicate
> > >>   successful partial transfer.  If the request partially succeeded,
> > >>   the required behavior is to successfully complete the request
> > >>   partially with residual count and then fail the latter part when
> > >>   issued again.  If the failure applies to the whole request but
> > >>   location information is useful, it should be carried in the sense
> > >>   data.
> > > 
> > > The definition is the amount of data transfer requested less the actual
> > > that went over the wire ... that's certainly a well defined quantity;
> > > although, one could argue about what this means in the device.
> > > Certainly I agree that just because the data was transferred to or from
> > > the device is no guarantee that the device did anything with it (or
> > > transferred it accurately).
> > 
> > I think it's more like how many bytes are valid where the validity is
> > defined as the number of meaningful bytes on dev -> host commands and
> > the number of bytes the device actually consumed on the other
> > direction.  Please note that this is different from the number of
> > bytes transferred due to padding or under other error conditions.
> 
> For failed commands we don't have that information.  All we know is how
> many bytes were actually transferred (because the HBA keeps a count), so
> it's the actual transfer count we use to construct the residual.  No
> imputation of validity or otherwise.  It just says I transferred this
> amount, based on the error make of it what you will.

It might help to agree on terminology.  For example, in the USB
mass-storage protocol, "Error" means the command or its result could
not be transferred at all -- a problem at the link layer.  "Failure"
means the command was received and possibly executed to some extent,
but the device returned Check Condition status.  "Success" means the 
same as failure except that the device returned Okay status rather than 
Check Condition.

So for an error, the residue is meaningless (although you could say
that it was equal to the full transfer length if you want).  For a
failure or a success it is meaningful, and it need not be the same as
the amount of data transferred.

Incidentally, as long as we're trying to be precise about terminology,
the correct term is "residue", not "residual".  In fact, the last time
I checked a copy of the SCSI spec the word "residual" did not occur
anywhere in it.

> > >> * What about corner values?  What does 0 or full resid count on
> > >>   failure mean?
> > > 
> > > 0 means everything transferred, full residual means nothing did.
> > 
> > Yeap, I was wondering about the combination 0 resid count + failure.
> > What would it mean?  All bytes are valid but the command failed?
> 
> Well, there are certain SCSI conditions called deferred errors and the
> like where we return Check Condition but everything's OK, redisual count
> should be zero, same goes for recovered errors ... there are actually
> lots of things we can get back as an "error" which means I'm warning you
> of something, but the transfer was OK.  Likewise we get unit attentions
> (essentialy AENs) which mean I'm telling you something before you start,
> so please try again.  Here residual would be the full transfer.   Also,
> we have the nasty USB case where no error return but an actual residual
> tells you something really went wrong.

These should all be described either as failures or as successes with
a partial transfer, not as errors.

Alan Stern

