From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: data corruption: ext3/lvm2/md/mptsas/vitesse/seagate
Date: Mon, 10 Mar 2008 10:36:26 -0500
Message-ID: <1205163386.2941.14.camel@localhost.localdomain>
References: <200803062108.m26L8e4i020882@colby.verdasys.com>
	 <1204848652.3062.100.camel@localhost.localdomain>
	 <200803101519.m2AFJCJS032509@colby.verdasys.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38287 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735AbYCJPg3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Mar 2008 11:36:29 -0400
In-Reply-To: <200803101519.m2AFJCJS032509@colby.verdasys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marc Bejarano <beej@alum.mit.edu>
Cc: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, Grant Grundler <grundler@google.com>

On Fri, 2008-03-07 at 17:40 -0500, Marc Bejarano wrote:
> In another instance of out-of-sync-ness, the bad disk looked as 
> follows.  The bad disk was in a completely different md raid1 
> "device", and if it needs to be said explicitly, was a totally 
> different physical drive.
> 
> b + 0x00000: "header of 16K mysql/innodb page 309713974 followed by
> good data"
> 
> b + 0x03600: **BAD DATA**: "header of 16K mysql/innodb page 
> 309713975", should be at b+0x04000, followed by first 10752 == 21*512 
> bytes of current correct value of page per disk with good copy
> 
> b + 0x06000: correct current last part of page 309713975 in proper
> place.
> 
> This is hard to explain.  It looks like page 309713975 got written 
> out to the proper spot, but then the first 10752 bytes got written 
> out again to the wrong spot?!?

I'm afraid your not going to like this, but this pattern of corruption
is almost completely definitive of a disk problem with head positioning.

The reason is that the block and all lower layers do write out in terms
of what they see as a logical block size (usually 4k, but definitely
whatever the block size of the underlying filesystem you have mysql on).

Seeing an odd number of 512 byte sectors out of position like that (21
in your case) when that number isn't a power of two (which is a linux
logical block size requirement) can't really have come from the kernel,
since we always deal in power of two units of the underlying 512 byte
sectors all the way from block, through md to the low level SCSI driver.

It's still theoretically possible that something went wrong in the
actual HBA, but I'd place most of my money on a disk fault.  The drives
you have, the Seagate 7200.10 were the first to use perpendicular
recording, so it could be they have head positioning errors with the new
technology.  There's also a lot of talk on the internet about
performance issues with the various revisions of their firmware:

http://www.fluffles.net/articles/seagate-AAK-firmware

Just as a matter of interest, what version of firmware do you have?  You
can get this with

hdparm -I /dev/sd<whatever>

I'm afraid the only way to confirm this theory definitively will be with
the destructive disktest from autotest (it was actually constructed to
check for drive head positioning errors), as Grant explained:

> If you can destroy (and later restore) the data on one or more
> of the disks, you might consider running disktest from:
>    http://test.kernel.org/autotest/
> 
> I've parked an SVN snapshot on:
>    http://iou.parisc-linux.org/~grundler/autotest-20080307.tgz
> 
> See autotest/tests/disktest/ . IIRC this test will tag each 512 byte
> "sector" it writes to a file and will read back those tags later to
> verify the sectors made it to media.

James


