From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: convert 520 byte sector disk to 512 byte sector?
Date: Mon, 9 Jun 2003 12:29:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609122907.A16169@beaverton.ibm.com>
References: <20030609174647.GB29808@cup.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:29410 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264503AbTFITT1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2003 15:19:27 -0400
Content-Disposition: inline
In-Reply-To: <20030609174647.GB29808@cup.hp.com>; from iod00d@hp.com on Mon, Jun 09, 2003 at 10:46:47AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <iod00d@hp.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Jun 09, 2003 at 10:46:47AM -0700, Grant Grundler wrote:
> Hi,
> 
> I've got several ST336753FC and ST336704FC disks which came out
> of a VA7100 RAID enclosure. The VA7100 is able to reformat those
> disks from 512 to 520 bytes per sector. I'd like to convert them
> back to 512 byte/sector for use as "regular" disks.
> Anyone know the trick to do that?

> I haven't tried blk512-linux with parallel SCSI under linux,
> but I know it's not working with the above FC disks when run
> on an ia64-linux box.  The format mode page "current" values
> aren't changing using the "trick" that worked for the parallel
> SCSI disks. And the "writeable" indicates none of the formt mode
> page parameters are allowed to be changed (clearly a lie).
> 
> The default format mode page clearly shows the drive was 512 byte/sector.
> I'd just like to get them back to that for the some performance testing.

I did this for some Seagate FC drives (don't have the exact model numbers
handly), but don't have my hacks, and can't find details of my results. I
used the same thing you have in your code - set the "direct access device
mode paramter block descriptor"'s block length (versus the more obvious
data bytes per physical page), and then formatted the drive.
 
Did you try setting the data bytes per physical page?

So the MODE SENSE format device page (0x3) "data bytes per physical
sector" does _not_ show 512 bytes after you send the MODE SELECT format
device page? That is what I (eventually) saw.

Did you format the drive after changing the block size?

Are you sure the mode select is really working in your code? I suppose
there are no other format page values you can change.

I can't remember when the MODE SENSE format page showed the modified block
size for me - I believe it was after the MODE SELECT format page, rather
than after the FORMAT command itself.

-- Patrick Mansfield
