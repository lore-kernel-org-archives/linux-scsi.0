From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/2] SCSI: implement scsi_eh_schedule_cmd()
Date: Fri, 21 Apr 2006 11:39:52 +0900
Message-ID: <20060421023952.GH25726@htj.dyndns.org>
References: <4446ECCF.7080000@gmail.com> <20060420192357.26257.qmail@web31814.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060420192357.26257.qmail@web31814.mail.mud.yahoo.com>
Sender: linux-ide-owner@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, hch@lst.de, James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, arjan@infradead.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Luben.

On Thu, Apr 20, 2006 at 12:23:57PM -0700, Luben Tuikov wrote:
> --- Tejun Heo <htejun@gmail.com> wrote:
> > Hmmm.. libata isn't SCSI.  It's just hitch-hiking on the back of SCSI at 
> > the moment.  And, being able to invoke EH on the host directly makes 
> > things a lot simpler for libata.  So, what do you think about just 
> > adding shost->host_eh_scheduled, adding a condition to 
> > scsi_error_handler() and export scsi_eh_wakeup()?  The changes will be 
> > like three lines.  And, also, ->host_eh_scheduled can be marked as hack 
> > for libata.  libata can handle the rest.
> 
> Hi Tejun,
> 
> I don't mind such a patch.  It is well defined -- all you want is
> process (ER) context to do some hw/proto ER work.  Clearly the architecture
> of libata doesn't allow for protocol/hw work in a process as we'd discussed,
> and so I think such a small patch would be completely ok to make the rest
> of your work go through.

Good.

> > This may not be the most graceful thing to do but...
> > 
> > 1. SCSI change is minimal
> 
> I think this is a good thing, and for clearly understood and well defined
> solutions we want patches to be small.  Your architecural SATA layer work
> can be as big as it needs to be and I think you're doing an excellent
> job -- FWIW, if it hadn't been for your patches, a lot of things would
> be pretty stagnant in libata, SCSI and the block layer.
> 
> > 2. it's a temporary measure (moving libata out of SCSI is one of the 
> > items on my agenda and if no one else does it I'm gonna give a shot at 
> > it in not-so-distant future.  Once libata is gone of SCSI, the three 
> > lines can be removed.)
> 
> You are a very, very smart person to want to move libata out of SCSI.
> It is very unfortunate, but I clearly understand why you'd want to do
> it.

libata piggy-backed on SCSI mainly for convenience reasons.  It just
basically wanted to use the SCSI high level drivers, command queue
handling, EH and etc.  libata is scheduled to be detached from SCSI
almost from the beginning, IIRC.  Well, ATA pass-through and other
changes somewhat decreased the need, but still...

> > 3. It will take a lot more work to achieve the same thing in libata 
> > proper without the three line change.
> > 
> > Luben, what do you think?
> 
> I think it sounds good.
> 
> Good luck!
>        Luben
> 
> P.S.  Remember what we'd discussed earlier, if you can offload something
> to command ER or device ER, do it!  It will save you a lot of special
> cases, IRQ/process context jungle, and differing paths and races.
> 
> Don't you mind that if a command fails, you know that all of them
> queued commands would have to get zapped and that the device would probably
> have to be reset.  Just call scsi_req_abort_cmd() and do that abstraction
> later in process context when it calls your ER routine.

Thank you for the advice.  I'll think about it.

So, if no one else objects, let's merge stuff.  If there is no
immediate need in SCSI, I think both Luben's scsi_req_abort_cmd() and
my hack are better off being merged via libata, where the current need
is.  Any opinions?

Thanks.

-- 
tejun
