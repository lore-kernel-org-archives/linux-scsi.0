From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 17:25:42 -0700 (PDT)
Message-ID: <20060517002542.81288.qmail@web31803.mail.mud.yahoo.com>
References: <1147821176.3505.101.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31803.mail.mud.yahoo.com ([68.142.207.66]:33915 "HELO
	web31803.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S932355AbWEQAZn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 20:25:43 -0400
In-Reply-To: <1147821176.3505.101.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Tue, 2006-05-16 at 16:02 -0700, Luben Tuikov wrote:
> > The nexus between the driver and SCSI Core is terminated only when
> > done() is called.  done() is the antagonist of queuecommand().
> > 
> > Until done() is called, if the LLDD/IC/SCSI Core want to request that
> > a command be aborted for whatever reason, it calls
> > scsi_req_abort_cmd().
> > 
> > That is, until the nexus created by calling queuecommand(), is
> > returned
> > to SCSI Core (by the driver calling done()), if either the driver or
> > SCSI Core want to request the command be aborted, they call
> > scsi_req_abort_cmd().
> 
> Erm, no, actually, I think if you look at SAM-3 (section 4.12) you'll
> find that a nexus can only be maintained with the consent of both the
> initiator and the target.  The (transport dependent) signal of
> completion is an indicator of nexus termination (except in the linked
> command case).

Erm, no, actually, I'm not talking about a SAM nexus.  I'm talking about
the nexus established between SCSI Core and LLDD when SCSI Core called
queuecommand().  This nexus exists until the LLDD calls done().

Now in between that time, if either one wants to abort the command
then they call scsi_req_abort_cmd().

Most likely that would be the LLDD/IC.

    Luben

