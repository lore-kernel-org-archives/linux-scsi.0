From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
Date: Mon, 11 May 2009 09:18:20 -0500
Message-ID: <1242051500.3338.9.camel@mulgrave.int.hansenpartnership.com>
References: <1241423927-11871-4-git-send-email-tj@kernel.org>
	 <4A06DFAB.40205@panasas.com> <4A0767E5.5050205@kernel.org>
	 <20090511145024B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090511145024B.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tj@kernel.org, bharrosh@panasas.com, axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, dgilbert@interlog.com, djwong@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Mon, 2009-05-11 at 14:49 +0900, FUJITA Tomonori wrote:
> On Mon, 11 May 2009 08:48:53 +0900
> Tejun Heo <tj@kernel.org> wrote:
> 
> > Hello, Boaz.
> > 
> > Boaz Harrosh wrote:
> > 
> > > Hi Tejun, I've carefully reviewed these files which I know more
> > > about.  The drivers/block files I've skipped, since I'm not familiar
> > > with this code.
> > > 
> > > Except a small fallout, it looks very good. See some comments plus
> > > Ack/review below
> > 
> > Thanks a lot for reviewing it closely.  It's really nice to have
> > careful extra pair of eyes on the changes.  :-)
> > 
> > >> --- a/drivers/message/fusion/mptsas.c
> > >> +++ b/drivers/message/fusion/mptsas.c
> > >> @@ -1357,8 +1357,7 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
> > >>  		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
> > >>  		memcpy(req->sense, smprep, sizeof(*smprep));
> > >>  		req->sense_len = sizeof(*smprep);
> > >> -		req->data_len = 0;
> > >> -		rsp->data_len -= smprep->ResponseDataLength;
> > >> +		rsp->resid_len = rsp->data_len - smprep->ResponseDataLength;
> > >>  	} else {
> > >>  		printk(MYIOC_s_ERR_FMT "%s: smp passthru reply failed to be returned\n",
> > >>  		    ioc->name, __func__);
> > > 
> > > I think original code was assuming full residual count on the else side
> > > (not MPT_IOCTL_STATUS_RF_VALID). So maybe add:
> > > 
> > > +		rsp->resid_len = rsp->data_len;
> > 
> > Does resid_len make any sense w/ failed requests?  I think we would be
> > better off with declaring residual count to be undefined on request
> > failure.  Is there any place which depends on it?
> 
> IIRC, I wrote the code. I think that this doesn't matter but it's
> better not to change the behavior unless Eric ack on this change
> (maybe LSI has some management binary that assume this behavior though
> it's unlikely).

Actually, yes it does, for many possible reasons.

The first being if the device is too stupid to report an actual sector
location the next best way of determining where the error occurred is
from the residual.  We don't make use of this in kernel (perhaps we
should?) but some of the user space programs for CD/DVD burning do.

James


