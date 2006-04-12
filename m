From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH 1/2] SCSI: implement scsi_eh_schedule_cmd()
Date: Wed, 12 Apr 2006 09:18:42 -0700
Message-ID: <20060412161842.GA19787@us.ibm.com>
References: <443C642E.5090106@gmail.com> <20060412082442.49921.qmail@web31809.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060412082442.49921.qmail@web31809.mail.mud.yahoo.com>
Sender: linux-ide-owner@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>, hch@lst.de, James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, arjan@infradead.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 12, 2006 at 01:24:42AM -0700, Luben Tuikov wrote:
> --- Tejun Heo <htejun@gmail.com> wrote:
> > Patrick Mansfield wrote:
> > > On Tue, Apr 11, 2006 at 01:41:57PM -0400, Jeff Garzik wrote:
> > >> Tejun Heo wrote:

> > >>> +int scsi_eh_schedule_cmd(struct scsi_cmnd *scmd)

> > > Per other email it should be called scsi_req_abort_cmd() or such, as that
> > > is the only reason to call it, correct?
> > 
> > Well, it's named this way is to keep it consistent with 
> > scsi_eh_schedule_host().  Either name is okay with me but driver which 
> > use this function probably have interest in schedule_host() but not in 
> > other SCSI EH functions.  So, considering that, I think the current 
> > naming is okay.
> 
> Tejun, note that scsi_req_abort_cmd() absolves your patch.
> I think this is what Pat is trying to say.  I.e. it is much
> more general and thus applies to more applications (as in uses).
> Plus it is shorter, simpler (3 lines) and more straightforward.

Both implementations work ... really I'd prefer a scsi_times_out() and
scsi_abort_cmd() that call a __scsi_abort_cmd().

If we implement them right, in the future those simple interfaces can stay
the same even if we no longer have to invoke eh to abort a command.

> So, scsi_eh_reschedule_host() is equivalent to simply scsi_req_abort_cmd(cmd)
> xor scsi_req_dev_reset(dev), the latter in case you want to notify without
> piggybacking on a command.
> 
> Also, your routine calls more specific eh routines and you should try
> to be more general.
> 
> > > Any other handling can be completed by calling the ->done function.
> > > 
> > > Even the abort/cancel could be done in the driver without this, I assume
> > > it is avaiable so the driver can use the eh process and existing code
> > > paths rather than duplicate similar code.
> > 
> > Yeap, as I noted earlier, passing scmds to EH is possible without this 
> > function but it has to be done in a quite hackish way.  My earlier 

I didn't mean pass them to eh, I mean the driver or transport could have
its own work queue (or not ... we don't need a work queue or process
context to send commands, scsi core sends commands without a work queue or
process context), and issue the abort. Then on completion set error to
DID_TIME_OUT (or whatever makes sense) and call the ->done function.

We should move towards driver/transport supplied eh, that is invoked by
the driver/transport specific code, not (possibly) by a single timeout. I
thought this was the direction everyone wanted to go.

-- Patrick Mansfield
