From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: LSISAS1068E + WDC WD2002FYPS: I/O error & Sense Key
Date: Mon, 03 Aug 2009 11:15:58 -0500
Message-ID: <1249316158.3943.54.camel@mulgrave.site>
References: <20090727060322.GB27002@lifeintegrity.com>
	 <4A70A64A.2070605@gmail.com> <20090729200714.GA20706@lifeintegrity.com>
	 <4A70D57B.6030301@gmail.com> <20090731184023.GT3211@lifeintegrity.com>
	 <20090803050853.GA26430@lifeintegrity.com>
	 <1249310093.3943.11.camel@mulgrave.site>
	 <20090803160629.GA2011@lifeintegrity.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56025 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755047AbZHCQQB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2009 12:16:01 -0400
In-Reply-To: <20090803160629.GA2011@lifeintegrity.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Allan Wind <allan_wind@lifeintegrity.com>
Cc: linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2009-08-03 at 12:06 -0400, Allan Wind wrote:
> On 2009-08-03T09:34:53, James Bottomley wrote:
> > On Mon, 2009-08-03 at 01:08 -0400, Allan Wind wrote:
> > >
> > > The above complains about sector 3907028974 which is exactly 
> > > 19566 sectors greater than the size of the raid array according 
> > > to parted.  In other words it appears to be an access to the last 
> > > sector of the array.
> > 
> > If it's a read beyond the end of a partition, then it's possible it got
> > rejected in the partition checking logic before ever reaching the I/O
> > controller (which would explain why no messages from the fusion in the
> > log).
> > 
> > However, I don't think the analysis is correct.  Parted says
> > 
> > 
> > > Number  Start   End          Size         File system  Name  Flags
> > >  1      34s     19565s       19532s                          bios_grub
> > >  2      19566s  3907029134s  3907009569s  ext3               raid
> > 
> > So the absolute sector number 3907028974 is within partition 2.
> 
> I was actually trying to make a different point.  Namely that it 
> was curious that the error message complains about sector
> 3907028974 which is exactly the size of the array + 19566, or in 
> other words 1 sector past the end of array:

That's where md stores its superblock ... but it's still within the
partition.

James


