From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: clustering and 2.6
Date: 07 Sep 2004 12:40:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094575251.1716.113.camel@mulgrave>
References: <20040907161254.GA23325@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:8426 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268223AbUIGQk4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 12:40:56 -0400
In-Reply-To: <20040907161254.GA23325@beardog.cca.cpqcorp.net>
List-Id: linux-scsi@vger.kernel.org
To: mikem <mikem@beardog.cca.cpqcorp.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

On Tue, 2004-09-07 at 12:12, mikem wrote:
> All,
> I'm having some issues when trying to use some clustering software when
> running any 2.6.x kernel.
> Basically, there are 2 nodes connected to 1 storage storage enclosure.
> When node 1 comes up it reserves the volume(s) in the enclosure. When
> node 2 comes up the read capacity fails as expected because of the 
> SCSI reservation. However, if node 1 fails node 2 breaks the reservation,
> but cannot register the disk. At this time we're assuming it's because the read
> capacity failed and the size of the disk is zero blocks.
> 
> The SCSI mid-layer sets a bogus size on a device when read capacity fails.
> Is this the preferred way to get around this issue? Seems like there
> should be a better way.
> 
> Any input is greatly appreciated.

The bogus size thing is a holdover from the old days.

However, I recently did a test where I forced the size to zero.  What I
see is that the partition does indeed not get registered (even for the
whole disc device).  However I can still send a BLKRRPART ioctl to it
trigger a rescan and get the correct size.

James


