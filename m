From: Douglas Gilbert <dougg@torque.net>
Subject: Re: mptsas problem
Date: Mon, 14 Apr 2008 08:22:26 +1000
Message-ID: <480287A2.7030308@torque.net>
References: <47F95F5C.500@sauce.co.nz> <20080407010453.GA1952@animx.eu.org>	 <1208097071.4707.21.camel@localhost.localdomain>	 <20080413164800.GA23094@animx.eu.org>	 <1208105925.4707.27.camel@localhost.localdomain>	 <20080413170644.GA1234@animx.eu.org> <1208108263.4707.37.camel@localhost.localdomain>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49831 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbYDMWWu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Apr 2008 18:22:50 -0400
In-Reply-To: <1208108263.4707.37.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Wakko Warner <wakko@animx.eu.org>, Richard Scobie <richard@sauce.co.nz>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sun, 2008-04-13 at 13:06 -0400, Wakko Warner wrote:
>>> There's an easy way to verify:  smartctl -i will print the firmware
>>> version string.
>> The aic sas one shows 3.AAE
>> The lsi mptsas can't be queried:
>> # smartctl -d scsi -i /dev/sdc
>> smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
>> Home page is http://smartmontools.sourceforge.net/
>>
>> Serial number:             3QD076X8
>> Device type: disk
>> Local Time is: Sun Apr 13 13:02:36 2008 EDT
>> Device supports SMART and is Enabled
>> Temperature Warning Disabled or Not Supported
>> #
>>
>> I tried -d ata, -d sat and not using -d, provided no information.  -T
>> permissive didn't work either.
> 
> That's a bit unfortunate ... it means the LSI firmware SAT layer doesn't
> support ATA_16.  you can try ATA_12 just to make sure (little chance it
> will work, but just in case):
> 
> smartctl -i -d sat,12 /dev/sd<x>
> 
> If that doesn't work, I'm afraid you'll need to transfer the drive to a
> card that does support the command (like the aic).
> 
> However, it doesn't have to be a drive firmware fault, it could be some
> type of corner case NCQ failure triggered by the NCQ handler inside the
> LSI firmware ... in which case, your only hope for fixing it lies with
> LSI.
> 
> There is one final thought:  the reason the aic94xx has a queue depth of
> 31 is because that's the maximum NCQ can support (well, it's 32 max, but
> we need one command for error handling).  So, if the LSI shows a queue
> depth of 64 it may be queueing internally as well.  You could try
> lowering the lsi queue to 31 and seeing if it makes a difference.

If memory serves, I needed to upgrade the firmware on my
MPT SAS fusion cards before the SCSI ATA PASS-THROUGH commands
worked (properly). I'm a long way away from my hardware
at the moment so I can't provide any further information
(such as firmware version numbers).


I have just asked Bruce Allen to place a date in the
smartctl copyright line because there are so many
versions of version 5.38 floating around! smartmontools
version 5.38 was recently released but beta (and sometimes
partially broken) versions of 5.38 have been available via
CVS for over 18 months. That said, the 5.38 versions
that mention 2008 (as in "2002-8") are most likely the
final release version.

Doug Gilbert

