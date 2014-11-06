From: Chris Friesen <chris.friesen@windriver.com>
Subject: Re: absurdly high "optimal_io_size" on Seagate SAS disk
Date: Thu, 6 Nov 2014 11:16:53 -0600
Message-ID: <545BAD05.3050800@windriver.com>
References: <545BA625.40308@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:36383 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaKFRRD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 12:17:03 -0500
In-Reply-To: <545BA625.40308@windriver.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 11/06/2014 10:47 AM, Chris Friesen wrote:
> Hi,
>
> I'm running a modified 3.4-stable on relatively recent X86 server-class
> hardware.
>
> I recently installed a Seagate ST900MM0026 (900GB 2.5in 10K SAS drive)
> and it's reporting a value of 4294966784 for optimal_io_size.  The other
> parameters look normal though:
>
> /sys/block/sda/queue/hw_sector_size:512
> /sys/block/sda/queue/logical_block_size:512
> /sys/block/sda/queue/max_segment_size:65536
> /sys/block/sda/queue/minimum_io_size:512
> /sys/block/sda/queue/optimal_io_size:4294966784

<snip>

> According to the manual, the ST900MM0026 has a 512 byte physical sector
> size.
>
> Is this a drive firmware bug?  Or a bug in the SAS driver?  Or is there
> a valid reason for a single drive to report such a huge value?
>
> Would it make sense for the kernel to do some sort of sanity checking on
> this value?

Looks like this sort of thing has been seen before, in other drives (one 
of which is from the same family as my drive):

http://www.spinics.net/lists/linux-scsi/msg65292.html

http://iamlinux.technoyard.in/blog/why-is-my-ssd-disk-not-reconized-by-the-rhel6-anaconda-installer/

Perhaps the ST900MM0026 should be blacklisted as well?

Or maybe the SCSI code should do a variation on Mike Snitzer's original 
patch and just ignore any values above some reasonable threshold?  (And 
then we could remove the blacklist on the ST900MM0006.)

Chris
