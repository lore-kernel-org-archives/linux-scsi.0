From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: mptsas problem
Date: Sun, 13 Apr 2008 16:49:10 -0400
Message-ID: <20080413204910.GA19651@animx.eu.org>
References: <47F95F5C.500@sauce.co.nz> <20080407010453.GA1952@animx.eu.org> <1208097071.4707.21.camel@localhost.localdomain> <20080413164800.GA23094@animx.eu.org> <1208105925.4707.27.camel@localhost.localdomain> <20080413170644.GA1234@animx.eu.org> <1208108263.4707.37.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:34657 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046AbYDMUtR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Apr 2008 16:49:17 -0400
Content-Disposition: inline
In-Reply-To: <1208108263.4707.37.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Richard Scobie <richard@sauce.co.nz>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sun, 2008-04-13 at 13:06 -0400, Wakko Warner wrote:
> > The aic sas one shows 3.AAE
> > The lsi mptsas can't be queried:
> > # smartctl -d scsi -i /dev/sdc
> > smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
> > Home page is http://smartmontools.sourceforge.net/
> > 
> > Serial number:             3QD076X8
> > Device type: disk
> > Local Time is: Sun Apr 13 13:02:36 2008 EDT
> > Device supports SMART and is Enabled
> > Temperature Warning Disabled or Not Supported
> > #
> > 
> > I tried -d ata, -d sat and not using -d, provided no information.  -T
> > permissive didn't work either.
> 
> That's a bit unfortunate ... it means the LSI firmware SAT layer doesn't
> support ATA_16.  you can try ATA_12 just to make sure (little chance it
> will work, but just in case):
> 
> smartctl -i -d sat,12 /dev/sd<x>

Same thing.

> If that doesn't work, I'm afraid you'll need to transfer the drive to a
> card that does support the command (like the aic).

The aic is not in the same place as the lsi.  I'm not willing to shutdown
this machine to do this right now.

> However, it doesn't have to be a drive firmware fault, it could be some
> type of corner case NCQ failure triggered by the NCQ handler inside the
> LSI firmware ... in which case, your only hope for fixing it lies with
> LSI.

Some how, I don't think it is the drive (but could be).

> There is one final thought:  the reason the aic94xx has a queue depth of
> 31 is because that's the maximum NCQ can support (well, it's 32 max, but
> we need one command for error handling).  So, if the LSI shows a queue

That's what I've read.

> depth of 64 it may be queueing internally as well.  You could try
> lowering the lsi queue to 31 and seeing if it makes a difference.

IIRC, someone said the LSIs does queue in firmware.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
