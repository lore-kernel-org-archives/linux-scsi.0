From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [ANNOUNCE] sdparm 0.90
Date: Tue, 19 Apr 2005 10:33:14 +1000
Message-ID: <426451CA.1040301@torque.net>
References: <4263B56B.2010905@torque.net> <4263F189.3000700@pobox.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:38609 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261389AbVDSILu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 04:11:50 -0400
In-Reply-To: <4263F189.3000700@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Douglas Gilbert wrote:
> 
>> sdparm is a new command line utility designed to get and set
>> SCSI disk parameters (cf hdparm for ATA disks). More generally
>> it gets and sets mode page information on SCSI devices or devices
>> that use a SCSI command set (e.g. CD/DVD drives (any transport)
>> and SCSI tape drives).
> 
> 
> I'm biased, but I would prefer to use blktool for this sort of thing...

Jeff,
There is definitely some overlap on the most important
parameters for disks (e.g. write caching). blktool covers
near end (HBA), transport and device settings. sdparm
concentrates on the far end device settings (and in some
cases transport settings from the point of view of that
device) for devices that use a SCSI command set.

sdparm assumes some knowledge of SCSI mode page structure
and what facilities are available. Figures and descriptions
of mode pages are found in product manuals and SCSI
standards (e.g. SPC-3 and SBC-2). Beyond primary settings
such as write caching, there are many interesting
settings.

For example, SCSI disks recovered from (hardware)
RAIDs (>= 3) often have the Automatic Read/Write Reallocation
bits (ARRE and AWRE) clear. This is not the manufacturer's
default. I assume this is to generate medium errors at the
first sign of trouble so the parity disk is brought into
play. When such a disk is used stand alone, a user would probably
want those bits on (and of course they should be using
smartmontools or similar to gauge the health of the disk).
sdparm can set a mode page back to its manufacturer's
default settings.
Another example is the tuning mode that Seagate has
introduced for its disks (i.e. server or desktop mode).
See sdparm.8 for further information.

IMO blktool and sdparm complement one another.

Doug Gilbert

