From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: LTO-3 read performance issues
Date: Wed, 7 Nov 2007 20:37:11 +0200 (EET)
Message-ID: <alpine.LSU.0.9999.0711072022370.7663@kai.makisara.local>
References: <4731D72D.5000404@moving-picture.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:35653 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbXKGSsE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Nov 2007 13:48:04 -0500
In-Reply-To: <4731D72D.5000404@moving-picture.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Pearson <james-p@moving-picture.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 7 Nov 2007, James Pearson wrote:

> I have two LTO-3 (QUANTUM ULTRIUM 3) drives attached to a dual Adaptec U160
> controller (one per SCSI host) on a Dell PE2850 running a RHEL4 based kernel
> (2.6.9 based).
> 
> I'm trying to read (with tar) LTO-3 tapes written on another system (possibly
> an SGI IRIX box), but I'm getting extremely variable read rates - from a few
> Kb/s to tens of Mb/s - while reading the same tape
> 
> After a bit of trial and error, it looks like the tapes have been written in
> variable block mode with a block size of 16Kb
> 
> To list the tapes, I need to set the block size to 0 (mt setblk 0) and run:
> 
> tar tvfb $TAPE 32
> 
> Running strace on the tar process shows that it does a number of read()'s then
> 'sticks' on a read() for a number of seconds, and then does a burst of
> read()'s - the number of reads it does in these bursts and the time if waits
> on a particular read vary.
> 
> My guess this is something to do the drive having to repositioning the tape
> between reads and breaking the tape streaming ...
> 
The Quuntum LTO-3 sustained transfer rate is 68 MB/s. Compression does 
increase this. In order to avoid stopping the tape, your system should be 
able to able to process the data continuously at this rate. If this is not 
the case, you can't avoid the stops.

> I get the same issue on both drives with different tapes from the same source.
> 
> I am using the default st module options and not doing anything other than
> using 'mt setblk 0'.
> 
> Is there anything I can do to get a decent, sustained read rate from these
> tapes?
> 
If your system can process the data fast enough and the tape blocks are of 
the same size, you can try using fixed block mode and buffered transfers. 
This allows the driver to use larger SCSI reads. You have to load the st 
module with parameter buffer_kbs=xxx, where xxx is, for instance, 1024 (1 
MB buffer). You also have to disable direct i/o with the module parameter
try_direct_io=0 (otherwise buffered transfers are disabled).

-- 
Kai
