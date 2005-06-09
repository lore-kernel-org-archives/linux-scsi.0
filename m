From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: list_for_each_entry_safe() regarded as unsafe
Date: Thu, 9 Jun 2005 14:59:15 -0700
Message-ID: <20050609215915.GA3105@us.ibm.com>
References: <Pine.LNX.4.44L0.0506091201080.5136-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:19637 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S262482AbVFIV6g
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jun 2005 17:58:36 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j59LwYPX063218
	for <linux-scsi@vger.kernel.org>; Thu, 9 Jun 2005 17:58:35 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j59LwYCR098810
	for <linux-scsi@vger.kernel.org>; Thu, 9 Jun 2005 15:58:34 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j59LwYmB018632
	for <linux-scsi@vger.kernel.org>; Thu, 9 Jun 2005 15:58:34 -0600
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0506091201080.5136-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dag Nygren <dag@newtech.fi>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern [stern@rowland.harvard.edu] wrote:
> Mike and whoever else may be interested:
> 
> The scsi_forget_host() and __scsi_remove_target() routines (in scsi_scan.c 
> and scsi_sysfs.c) contain these lines respectively:
> 
> 	list_for_each_entry_safe(starget, tmp, &shost->__targets, siblings) {
> 
> 	list_for_each_entry_safe(sdev, tmp, &shost->__devices, siblings) {
> 
> Neither loop is truly safe because they release shost->host_lock to do the
> actual removals.  I've just seen a couple of different oopses caused when
> __scsi_remove_target() was called during scanning.  Details available if 
> you want them.

Well we need a updated scsi_host state model that would prevent scanning
while we are removing the host. I would believe that if the oopses in
__scsi_remove_target where prevent there maybe some other oopses showing
up as the host started going away.

> 
> I don't know what the best way is fix this.  Even if scsi_forget_host() 
> acquired the host's scan_mutex, that wouldn't be enough to guarantee the 
> __targets and __devices lists won't change, would it?  And it might cause 
> interference with other pathways.
> 

Yes if scsi_forget_host acquired the scan_mutex it would deadlock when
scsi_remove_device acquired it later on in the call stack.

> Maybe it's best simply to avoid using list_for_each_entry_safe, as in
> the example below:
> .. snip .. 
> +restart:
> +	list_for_each_entry(sdev, &shost->__devices, siblings) {
>  		if (sdev->channel != starget->channel ||
>  		    sdev->id != starget->id)
>  			continue;
>  		spin_unlock_irqrestore(shost->host_lock, flags);
>  		scsi_remove_device(sdev);
>  		spin_lock_irqsave(shost->host_lock, flags);
> +		goto restart;
>  	}
>  	spin_unlock_irqrestore(shost->host_lock, flags);
>  	scsi_target_reap(starget);
> 

Since we are not guaranteed that scsi_remove_device will remove the device
off the list (i.e. the release may not be called if unexpected disconnect)
you may get stuck on the same device for a bit.

-andmike
--
Michael Anderson
andmike@us.ibm.com

