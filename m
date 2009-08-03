From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: LSISAS1068E + WDC WD2002FYPS: I/O error & Sense Key
Date: Mon, 03 Aug 2009 09:34:53 -0500
Message-ID: <1249310093.3943.11.camel@mulgrave.site>
References: <20090727060322.GB27002@lifeintegrity.com>
	 <4A70A64A.2070605@gmail.com> <20090729200714.GA20706@lifeintegrity.com>
	 <4A70D57B.6030301@gmail.com> <20090731184023.GT3211@lifeintegrity.com>
	 <20090803050853.GA26430@lifeintegrity.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56762 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932108AbZHCOez (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2009 10:34:55 -0400
In-Reply-To: <20090803050853.GA26430@lifeintegrity.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Allan Wind <allan_wind@lifeintegrity.com>
Cc: linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2009-08-03 at 01:08 -0400, Allan Wind wrote:
> On 2009-07-31T14:40:23, Allan Wind wrote:
> > On 2009-07-29T17:04:27, Robert Hancock wrote:
> > > On 07/29/2009 02:07 PM, Allan Wind wrote:
> > >> On 2009-07-29T13:43:06, Robert Hancock wrote:
> > >>> On 07/27/2009 12:03 AM, Allan Wind wrote:
> > >>>> I have a pair of Western Digital RE4-GP (WD2002FYPS) in RAID1 configuration
> > >>>> using Linux 2.6.30.3 and seeing the following:
> > >>>>
> > >>>> [ 4907.485324] end_request: I/O error, dev sdb, sector 3907028974
> > >>> Are there no error messages before this point? Can you post the full
> > >>> dmesg output from bootup?
> > >>
> > >> Thanks for looking into this, Robert.  I do not see any relevant error
> > >> message before this point, but made the entire 82k dmesg available here:
> > >> http://lifeintegrity.com/~allan/dmesg
> > >
> > > It seems like some request failed but apparently that mptsas driver  
> > > isn't dumping out what happened for some reason. There are some of those  
> > > "recovered error" indications but they're not near the I/O error report,  
> > > so I'm not sure what's going on. CCing linux-scsi.
> > 
> > Is there any data I can help with to advance this issue?
> 
> The above complains about sector 3907028974 which is exactly 
> 19566 sectors greater than the size of the raid array according 
> to parted.  In other words it appears to be an access to the last 
> sector of the array.

If it's a read beyond the end of a partition, then it's possible it got
rejected in the partition checking logic before ever reaching the I/O
controller (which would explain why no messages from the fusion in the
log).

However, I don't think the analysis is correct.  Parted says


> Number  Start   End          Size         File system  Name  Flags
>  1      34s     19565s       19532s                          bios_grub
>  2      19566s  3907029134s  3907009569s  ext3               raid

So the absolute sector number 3907028974 is within partition 2.

I still think something went wrong in block.  Even if the fusion failed
to spit an error, the SCSI layer is usually quite chatty about failures.
To get a simple error in the log with no explanation usually tends to
indicate that it occurred in the block layer.

James


