From: "Andy Warner" <andyw@pobox.com>
Subject: Re: [PATCH] libsas: support NCQ for SATA disks
Date: Sun, 15 Oct 2006 20:49:00 -0500
Message-ID: <19106af40610151849n41a11e4frd8088797a4e1e65@mail.gmail.com>
References: <453027A9.3060606@us.ibm.com>
	 <1160934124.3544.7.camel@mulgrave.il.steeleye.com>
	 <45328141.5020705@us.ibm.com>
	 <0E9A17FC-4047-48AE-A283-520B87E7F28D@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:53629 "EHLO
	ug-out-1314.google.com") by vger.kernel.org with ESMTP
	id S932106AbWJPBtC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Oct 2006 21:49:02 -0400
Received: by ug-out-1314.google.com with SMTP id o38so680866ugd
        for <linux-scsi@vger.kernel.org>; Sun, 15 Oct 2006 18:49:00 -0700 (PDT)
In-Reply-To: <0E9A17FC-4047-48AE-A283-520B87E7F28D@mac.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Rustad <mrustad@mac.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>

On 10/15/06, Mark Rustad <mrustad@mac.com> wrote:
> [...]
> > Hm... if I put in some debug printks in the qc_issue code, I get the
> > same symptoms.  I've observed that once again we get hung up on ATA
> > commands where the tag number > 0.  I also noticed this pattern:
> >
> > 1. ATA command w/ tag 0 (command A) issued.
> > 2. Command A goes out to sas-ata.
> > 2. ATA command w/ tag 1 (command B) issued.
> > 3. Command A completes
> > 4. Command B goes out to sas-ata.
> > [...]
> > 5. Command B times out.
> >
> > Very odd that this all works if there are no printks.  I don't see
> > anything obvious that would suggest why this apparent race seems to
> > happen--unless there's some conflict between issuing an ATA command
> > while completing another one.
>
> We have found in our system, using libata with Luben's driver, that
> the aic94xx sequencer expects the SATA commands to always have a tag
> of 0. The sequencer assigns its own tag before passing it to the
> drive. Interestingly, it seems to OR-in its generated tag value, so
> if a non-zero tag value is passed in, a real mess ensues.

Mark speaks the truth. If you're going to use libata as a SATL,
then you have to force the sector count to 0 before feeding the
taskfile to the aic94xx code. There may be a role for a flag to
libata that lets it totally skip the tag allocation, when used with
smart adapters like the 9410. There's little point maintaining
the bitfields if they are going to be ignored anyway.

You're also in for a bunch of fun servicing the SIGNAL_NCQ_ERROR
escbs, suspending/clearing all outstanding I/O, issuing a read log
page 10 command, mapping the tag back onto the original scb
via the sister ddb, erroring that one, and retrying the rest. I'm working
with mostly frozen code, so patches to the current de-Lubenised code
are difficult (to put it mildly.) Sorry.
-- 
Andy
