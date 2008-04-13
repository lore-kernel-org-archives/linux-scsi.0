From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: mptsas problem
Date: Sun, 13 Apr 2008 12:37:43 -0500
Message-ID: <1208108263.4707.37.camel@localhost.localdomain>
References: <47F95F5C.500@sauce.co.nz> <20080407010453.GA1952@animx.eu.org>
	 <1208097071.4707.21.camel@localhost.localdomain>
	 <20080413164800.GA23094@animx.eu.org>
	 <1208105925.4707.27.camel@localhost.localdomain>
	 <20080413170644.GA1234@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45365 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677AbYDMRhr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Apr 2008 13:37:47 -0400
In-Reply-To: <20080413170644.GA1234@animx.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: Richard Scobie <richard@sauce.co.nz>, linux-scsi@vger.kernel.org

On Sun, 2008-04-13 at 13:06 -0400, Wakko Warner wrote:
> > There's an easy way to verify:  smartctl -i will print the firmware
> > version string.
> 
> The aic sas one shows 3.AAE
> The lsi mptsas can't be queried:
> # smartctl -d scsi -i /dev/sdc
> smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
> Home page is http://smartmontools.sourceforge.net/
> 
> Serial number:             3QD076X8
> Device type: disk
> Local Time is: Sun Apr 13 13:02:36 2008 EDT
> Device supports SMART and is Enabled
> Temperature Warning Disabled or Not Supported
> #
> 
> I tried -d ata, -d sat and not using -d, provided no information.  -T
> permissive didn't work either.

That's a bit unfortunate ... it means the LSI firmware SAT layer doesn't
support ATA_16.  you can try ATA_12 just to make sure (little chance it
will work, but just in case):

smartctl -i -d sat,12 /dev/sd<x>

If that doesn't work, I'm afraid you'll need to transfer the drive to a
card that does support the command (like the aic).

However, it doesn't have to be a drive firmware fault, it could be some
type of corner case NCQ failure triggered by the NCQ handler inside the
LSI firmware ... in which case, your only hope for fixing it lies with
LSI.

There is one final thought:  the reason the aic94xx has a queue depth of
31 is because that's the maximum NCQ can support (well, it's 32 max, but
we need one command for error handling).  So, if the LSI shows a queue
depth of 64 it may be queueing internally as well.  You could try
lowering the lsi queue to 31 and seeing if it makes a difference.

James


