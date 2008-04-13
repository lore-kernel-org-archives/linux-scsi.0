From: Douglas Gilbert <dougg@torque.net>
Subject: Re: mptsas problem
Date: Sun, 13 Apr 2008 23:00:43 +1000
Message-ID: <480203FB.7070105@torque.net>
References: <47F95F5C.500@sauce.co.nz> <20080407010453.GA1952@animx.eu.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55179 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbYDMNBL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Apr 2008 09:01:11 -0400
In-Reply-To: <20080407010453.GA1952@animx.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: Richard Scobie <richard@sauce.co.nz>, linux-scsi@vger.kernel.org

Wakko Warner wrote:
> Richard Scobie wrote:
>>> I recall seeing some of this problem on the list a few days ago, but 
>> I > can't remember what the subject was and was unable to find the thread.
>>
>> You are perhaps thinking of this:
>>
>> http://marc.info/?l=linux-scsi&m=120696978819085&w=2
> 
> Yes.
> 
>> but it seems to be a different issue.
> 
> Ok.
> 
>> From the message you posted, it looks as though there may be a problem 
>> with sda.
> 
> It's working fine with /sys/block/sd[abc]/device/queue_depth = 1 (on boot up,
> as stated before, it's 64)
> 
> I performed the same copy again with queue_depth=1 after the array rebuilt.
> It worked fine then.  No errors.
> 
>> Does smartctl -a -d ata /dev/sda show any obvious problems?
> 
> smartctl doesn't work on sd[a-d] at all:
> # smartctl -a -d ata /dev/sdd
> smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
> Home page is http://smartmontools.sourceforge.net/
> 
> Smartctl: Device Read Identity Failed (not an ATA/ATAPI device)
> 
> A mandatory SMART command failed: exiting. To continue, add one or more '-T
> permissive' options.
> # smartctl -a -d ata -T permissive /dev/sdd

As a smartmontools developer I know that '-d ata' is
incorrect in this context. The 'd <command_set> should
either not be given or '-d sat' should be given.

This is difficult to explain and hence put in an easily
understood option. As far as linux is concerned SCSI
commands are being issued to a SCSI device (on a SCSI
transport). But those SCSI commands are mostly instances
of the SCSI ATA PASS-THROUGH command.

It is further complicated by the fact that a properly
implemented SAT layer (and I have never met one)
implements the SCSI commands used for SMART support.
If that was the case 'smartctl -a -d scsi /dev/sdd' would
yield useful output which would be a subset of what 'd sat'
would yield.

Clear as mud?

Doug Gilbert


> smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
> Home page is http://smartmontools.sourceforge.net/
> 
> Smartctl: Device Read Identity Failed (not an ATA/ATAPI device)
> 
> === START OF INFORMATION SECTION ===
> Device Model:     [No Information Found]
> Serial Number:    [No Information Found]
> Firmware Version: [No Information Found]
> Device is:        Not in smartctl database [for details use: -P showall]
> ATA Version is:   1
> ATA Standard is:  Exact ATA specification draft version not indicated
> Local Time is:    Sun Apr  6 21:02:45 2008 EDT
> SMART is only available in ATA Version 3 Revision 3 or greater.
> We will try to proceed in spite of this.
> SMART support is: Ambiguous - ATA IDENTIFY DEVICE words 82-83 don't show if SMART supported.
>                   Checking for SMART support by trying SMART ENABLE command.
> Error SMART Enable failed: Invalid argument
>                   SMART ENABLE failed - this establishes that this device lacks SMART functionality.
> A mandatory SMART command failed: exiting. To continue, add one or more '-T permissive' options.
> # 
> 

