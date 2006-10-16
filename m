From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] libsas: support NCQ for SATA disks
Date: Sun, 15 Oct 2006 19:22:02 -0700 (PDT)
Message-ID: <20061016022202.62044.qmail@web31803.mail.mud.yahoo.com>
References: <19106af40610151849n41a11e4frd8088797a4e1e65@mail.gmail.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31803.mail.mud.yahoo.com ([68.142.207.66]:18329 "HELO
	web31803.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1030300AbWJPCWD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Oct 2006 22:22:03 -0400
In-Reply-To: <19106af40610151849n41a11e4frd8088797a4e1e65@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Warner <andyw@pobox.com>, Mark Rustad <mrustad@mac.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>

--- Andy Warner <andyw@pobox.com> wrote:
> On 10/15/06, Mark Rustad <mrustad@mac.com> wrote:
> > [...]
> > > Hm... if I put in some debug printks in the qc_issue code, I get the
> > > same symptoms.  I've observed that once again we get hung up on ATA
> > > commands where the tag number > 0.  I also noticed this pattern:
> > >
> > > 1. ATA command w/ tag 0 (command A) issued.
> > > 2. Command A goes out to sas-ata.
> > > 2. ATA command w/ tag 1 (command B) issued.
> > > 3. Command A completes
> > > 4. Command B goes out to sas-ata.
> > > [...]
> > > 5. Command B times out.
> > >
> > > Very odd that this all works if there are no printks.  I don't see
> > > anything obvious that would suggest why this apparent race seems to
> > > happen--unless there's some conflict between issuing an ATA command
> > > while completing another one.
> >
> > We have found in our system, using libata with Luben's driver, that
> > the aic94xx sequencer expects the SATA commands to always have a tag
> > of 0. The sequencer assigns its own tag before passing it to the
> > drive. Interestingly, it seems to OR-in its generated tag value, so
> > if a non-zero tag value is passed in, a real mess ensues.
> 
> Mark speaks the truth. If you're going to use libata as a SATL,
> then you have to force the sector count to 0 before feeding the
> taskfile to the aic94xx code. There may be a role for a flag to
> libata that lets it totally skip the tag allocation, when used with
> smart adapters like the 9410. There's little point maintaining
> the bitfields if they are going to be ignored anyway.

Justin Gibbs explained many years ago the why and how of SCSI tags right
here in linux-scsi in a thread.  Their "domain", who is reponsible of
allocating them and why, and why they are needed for (i.e. it is impossible to)
managing SCSI Domains.  Although not as detailed as I had mentioned above,
his explanation is still true and holds today, as it did back then.

> You're also in for a bunch of fun servicing the SIGNAL_NCQ_ERROR
> escbs, suspending/clearing all outstanding I/O, issuing a read log
> page 10 command, mapping the tag back onto the original scb
> via the sister ddb, erroring that one, and retrying the rest. I'm working
> with mostly frozen code, so patches to the current de-Lubenised code
> are difficult (to put it mildly.) Sorry.

Andy, Mark, SAS/SATL is now at 1.2.7, both having been updated
as SAS and SAT had been updated.

   Luben

