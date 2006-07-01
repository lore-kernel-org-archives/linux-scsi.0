From: Neil Brown <neilb@suse.de>
Subject: More RAID / SATA / barrier problems [ Re: 2.6.17-mm5 ]
Date: Sun, 2 Jul 2006 08:29:04 +1000
Message-ID: <17574.63280.655747.111167@cse.unsw.edu.au>
References: <20060701033524.3c478698.akpm@osdl.org>
	<20060701142419.GB28750@tlg.swandive.local>
	<20060701143047.b3975472.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53677 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1751195AbWGAW3Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Jul 2006 18:29:16 -0400
In-Reply-To: message from Andrew Morton on Saturday July 1
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Grant Wilson <grant.wilson@zen.co.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Saturday July 1, akpm@osdl.org wrote:
> 
> mddev->pers is NULL in md_error(), so the test of
> !mddev->pers->error_handler oopsed.  Perhaps this is a real MD bug which is
> now being exposed by the new barrier-handling problem.
> 

Yes, this is a real MD bug which would hit whenever writing a
superblock fails during array-shutdown.  I guess that has never
happened before!  The work around you propose is probably as good as
any, but I'll think through it some more and see.

It seems that super block writes are always failing in some
configurations at the moment!

I wonder what we *should* do when writing to the superblock on the
last device of a raid1 faills... maybe switch the array to read-only?
I'll have a think about that too.

But we need to find out why barrier-writes are returning EIO.
Hopefully Reuben's testing will shed some light.

NeilBrown
