From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI core: fix leakage of scsi_cmnd's
Date: Tue, 13 Sep 2005 16:34:01 -0500
Message-ID: <1126647241.4809.65.camel@mulgrave>
References: <Pine.LNX.4.44L0.0509131254250.4481-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:58326 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932408AbVIMVeH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 17:34:07 -0400
In-Reply-To: <Pine.LNX.4.44L0.0509131254250.4481-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2005-09-13 at 13:00 -0400, Alan Stern wrote:
> On Fri, 9 Sep 2005, James Bottomley wrote:
> 
> > On Thu, 2005-09-08 at 16:49 -0400, Alan Stern wrote:
> > > This hasn't been tested very thoroughly, so please look through it 
> > > carefully.
> > 
> > Actually, just one problem and one cosmetic fix:
> > 
> > 1) We need to dequeue for the loop and kill case (it seems easiest
> > simply to dequeue in the scsi_kill_request() routine)
> > 2) There's no real need to drop the queue lock.  __scsi_done() is lock
> > agnostic, so since there's no requirement, let's just leave it in to
> > avoid any locking issues.
> 
> Have you applied this to any publicly-accessible tree yet?  I looked at 
> the git browsers on parisc-linux.org and kernel.org, but the patch doesn't 
> seem to be there yet.

Yes, they should both be in 2.6.14-rc1

> For that matter, what about the other patches you agreed to take (as543 - 
> as546)?  They aren't in the git repositories either.  It would be good if 
> all these things could be ready in time for the next -mm release.

That I think was these [from the latest GIT PATCH email]:

> Alan Stern:
>   o Fix module removal/device add race
>   o fix callers of scsi_remove_device() who already hold the scan
> muted
>   o add missing scan mutex to scsi_scan_target()

James


