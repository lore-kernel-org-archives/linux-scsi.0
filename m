From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: SCSI woes (followup)
Date: Wed, 25 Sep 2002 10:22:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020925102254.A6624@eng2.beaverton.ibm.com>
References: <rmk@arm.linux.org.uk> <200209241346.g8ODkER09516@localhost.localdomain> <20020924145852.A28042@flint.arm.linux.org.uk> <20020924111847.A4151@eng2.beaverton.ibm.com> <20020924123250.A5890@eng2.beaverton.ibm.com> <20020924233941.A9952@flint.arm.linux.org.uk> <20020924170857.A15340@eng2.beaverton.ibm.com> <20020925094137.A24532@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020925094137.A24532@flint.arm.linux.org.uk>; from rmk@arm.linux.org.uk on Wed, Sep 25, 2002 at 09:41:37AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-scsi@vger.kernel.org

Russel -

On Wed, Sep 25, 2002 at 09:41:37AM +0100, Russell King wrote:
> On Tue, Sep 24, 2002 at 05:08:57PM -0700, Patrick Mansfield wrote:
> > On Tue, Sep 24, 2002 at 11:39:42PM +0100, Russell King wrote:
> > 
> > Looks nice.  I have the same comment as before about no commands.
> 
> I fail to see what the problem here is.  I've repeatedly explained this.
> I'm not going to explain it again; maybe it would be wise to read the
> 2.4.19 code?  Please re-read all my mails since Sunday.

OK, I understand those and the IO completion code.

I see now in your patch that if Scsi_Device::locked is set, we must
have Scsi_Device::cmd_blocks != 0, since we only set locked in upper
layers or via an ioctl to an upper layer device. So, checking for
cmd_blocks is redundant.

> > > +static void scsi_eh_lock_done(struct scsi_cmnd *SCpnt)
> > > +{
> > > +	struct scsi_request *SRpnt = SCpnt->sc_request;
> > > +
> > > +	SCpnt->sc_request = NULL;
> > > +	SRpnt->sr_command = NULL;
> > > +
> > > +	scsi_release_command(SCpnt);
> > > +	scsi_release_request(SRpnt);
> > > +}
> > 
> > This is back to my orginal point (i.e. case 1 in your other response
> > about "restarting operations after error handling", I haven't figured
> > out case 2 yet) - the above will not be called if there are no commands.

So, the above can never happen, since locked can't be set until after
cmd_blocks == 1.

-- Patrick Mansfield
