From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 16:02:33 -0700 (PDT)
Message-ID: <20060516230233.39830.qmail@web31813.mail.mud.yahoo.com>
References: <1147818578.3505.92.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31813.mail.mud.yahoo.com ([68.142.207.76]:20816 "HELO
	web31813.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S932232AbWEPXCe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 19:02:34 -0400
In-Reply-To: <1147818578.3505.92.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Tue, 2006-05-16 at 15:24 -0700, Luben Tuikov wrote:
> > "*after* the nexus is terminated"?
> > 
> > Are you saying that libata calls "done()" and then calls
> > "scsi_req_abort_cmd()" on the same command in succession?
> 
> no, I'm saying ata_qc_complete() is an indication from the driver that
> the nexus is terminated.

But this is completely out of SCSI Core's domain.

The nexus between the driver and SCSI Core is terminated only when
done() is called.  done() is the antagonist of queuecommand().

Until done() is called, if the LLDD/IC/SCSI Core want to request that
a command be aborted for whatever reason, it calls scsi_req_abort_cmd().

That is, until the nexus created by calling queuecommand(), is returned
to SCSI Core (by the driver calling done()), if either the driver or
SCSI Core want to request the command be aborted, they call
scsi_req_abort_cmd().

What scsi_req_abort_cmd() accomplishes is that both parties of the
nexus are "on the same page" wrt the state of the command, independently
of which party called scsi_req_abort_cmd().

    Luben

> 
> > I haven't looked in the code (which GIT tree is it?) but I don't
> > believe that Tejun would do such a thing.
> 
> It's in the libata-dev tree on www.kernel.org/git
> 
> James
> 
> 
> 

