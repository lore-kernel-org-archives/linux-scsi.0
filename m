From: Philippe Troin <phil@fifi.org>
Subject: Re: iRiver H100 series and usb-storage issues
Date: 07 Jun 2004 12:43:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <87brjvw3w9.fsf@ceramic.fifi.org>
References: <Pine.LNX.4.44L0.0406071040310.1800-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tantale.fifi.org ([216.27.190.146]:15516 "EHLO tantale.fifi.org")
	by vger.kernel.org with ESMTP id S265015AbUFGTnK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2004 15:43:10 -0400
In-Reply-To: <Pine.LNX.4.44L0.0406071040310.1800-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern <stern@rowland.harvard.edu> writes:

> I just noticed this thread on linux-kernel:
> 
> http://marc.theaimsgroup.com/?l=linux-kernel&m=108372064000188&w=2
> 
> Apparently under some circumstances the iRiver H100 returns 0 bytes 
> transferred with GOOD status and residue=512 for a READ(10) command 
> asking for 1 sector.  As far as I know this is legal, and it indicates the 
> command should simply be retried.

That's correct.  However, the iRiver H1xx will also commit a USB
protocol violation by not returning a CSW (Command Status
Wrapper).  That's what screws up the transfer.
 
> But apparently the sd driver doesn't realize what has happened and assumes 
> the transfer was successful.  If I'm right then the sd driver should be 
> fixed, but I'm not sure what is the best thing to do.

I am not sure the SCSI layer can recover given that the USB layer is
confused...

Please note that:

 1. I am just repeating what I have been told by various people and
    claim no knowledge of the USB or SCSI layers.  In other words, I
    could be all wrong :-)

 2. I do not own a H1xx anymore, having returned mine.
 
Phil.
