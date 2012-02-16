From: Tejun Heo <tj@kernel.org>
Subject: Re: Bug when rescanning partitions on -ENOMEDIA
Date: Thu, 16 Feb 2012 08:33:14 -0800
Message-ID: <20120216163314.GG24986@google.com>
References: <Pine.LNX.4.44L0.1202161111501.1268-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46058 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab2BPQdT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2012 11:33:19 -0500
Received: by daed14 with SMTP id d14so2185029dae.19
        for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2012 08:33:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1202161111501.1268-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Huajun Li <huajun.li.lee@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, Feb 16, 2012 at 11:23:22AM -0500, Alan Stern wrote:
> Tejun:
> 
> Please take a look at this thread:
> 
> 	http://marc.info/?t=132214525000001&r=1&w=2
> 
> Evidently your commit 1196f8b814f32cd04df334abf47648c2a9fd8324 (block: 
> rescan partitions on invalidated devices on -ENOMEDIA too) is causing 
> crashes.  The problem is that the partition scanning code calls 
> sd_revalidate_disk() after the underlying scsi_disk structure has been 
> deallocated.
> 
> There have been numerous bug reports filed on multiple Bugzillas about 
> this, for example, 
> 
> 	https://bugzilla.redhat.com/show_bug.cgi?id=754518
> 
> I don't know the right way to fix this, but it looks like there needs
> to be some synchronization between del_gendisk() and
> rescan_partitions().
> 
> Or maybe you think the synchronization should be done in the SCSI layer 
> instead.  But then what about non-SCSI users of the block layer?  Does 
> the block layer guarantee that it won't call methods in disk->fops 
> after del_gendisk() has returned?

No, the problem is that I used rescan_partitions() instead of
non-existing drop_partitions_and_truncate_disk().  Please read the
following thread.  Jun'ichi Nomura already proposed a patch.

 http://thread.gmane.org/gmane.linux.kernel/1250235/

Thanks.

-- 
tejun
