From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
Date: Tue, 12 May 2009 08:47:46 +0900
Message-ID: <20090512084808P.fujita.tomonori@lab.ntt.co.jp>
References: <1242051500.3338.9.camel@mulgrave.int.hansenpartnership.com>
	<20090512000249E.fujita.tomonori@lab.ntt.co.jp>
	<1242054809.3338.30.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1242054809.3338.30.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: fujita.tomonori@lab.ntt.co.jp, tj@kernel.org, bharrosh@panasas.com, axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, dgilbert@interlog.com, djwong@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Mon, 11 May 2009 10:13:29 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Mon, 2009-05-11 at 08:03 -0700, FUJITA Tomonori wrote:
> > On Mon, 11 May 2009 09:18:20 -0500
> > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > On Mon, 2009-05-11 at 14:49 +0900, FUJITA Tomonori wrote:
> > > > On Mon, 11 May 2009 08:48:53 +0900
> > > > Tejun Heo <tj@kernel.org> wrote:
> > > > 
> > > > > Hello, Boaz.
> > > > > 
> > > > > Boaz Harrosh wrote:
> > > > > 
> > > > > > Hi Tejun, I've carefully reviewed these files which I know more
> > > > > > about.  The drivers/block files I've skipped, since I'm not familiar
> > > > > > with this code.
> > > > > > 
> > > > > > Except a small fallout, it looks very good. See some comments plus
> > > > > > Ack/review below
> > > > > 
> > > > > Thanks a lot for reviewing it closely.  It's really nice to have
> > > > > careful extra pair of eyes on the changes.  :-)
> > > > > 
> > > > > >> --- a/drivers/message/fusion/mptsas.c
> > > > > >> +++ b/drivers/message/fusion/mptsas.c
> > > > > >> @@ -1357,8 +1357,7 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
> > > > > >>  		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
> > > > > >>  		memcpy(req->sense, smprep, sizeof(*smprep));
> > > > > >>  		req->sense_len = sizeof(*smprep);
> > > > > >> -		req->data_len = 0;
> > > > > >> -		rsp->data_len -= smprep->ResponseDataLength;
> > > > > >> +		rsp->resid_len = rsp->data_len - smprep->ResponseDataLength;
> > > > > >>  	} else {
> > > > > >>  		printk(MYIOC_s_ERR_FMT "%s: smp passthru reply failed to be returned\n",
> > > > > >>  		    ioc->name, __func__);
> > > > > > 
> > > > > > I think original code was assuming full residual count on the else side
> > > > > > (not MPT_IOCTL_STATUS_RF_VALID). So maybe add:
> > > > > > 
> > > > > > +		rsp->resid_len = rsp->data_len;
> > > > > 
> > > > > Does resid_len make any sense w/ failed requests?  I think we would be
> > > > > better off with declaring residual count to be undefined on request
> > > > > failure.  Is there any place which depends on it?
> > > > 
> > > > IIRC, I wrote the code. I think that this doesn't matter but it's
> > > > better not to change the behavior unless Eric ack on this change
> > > > (maybe LSI has some management binary that assume this behavior though
> > > > it's unlikely).
> > > 
> > > Actually, yes it does, for many possible reasons.
> > > 
> > > The first being if the device is too stupid to report an actual sector
> > > location the next best way of determining where the error occurred is
> > > from the residual.  We don't make use of this in kernel (perhaps we
> > > should?) but some of the user space programs for CD/DVD burning do.
> > 
> > This function is for SAS management protocol. Are there many possible
> > reasons?
> 
> It still indicates how much of the frame was transferred and we have the
> information, so why not set it.  Not doing so would be different from
> other data transfer functions and so violate the principle of least
> surprise.

As I wrote in the first reply, I agree with you. I wrote the original
code in that way. I was just curious to know if there are example
applications that could be broken due to this behavior.


> For SAS 1.1 ... the frames are small, so it's not that relevant.  For
> SAS 2.0 the SMP functions become multi-frame, so I could see this
> becoming relevant for some of the zone SMP commands.

I see, thanks.
