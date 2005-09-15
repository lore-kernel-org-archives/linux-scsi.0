From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 4/5] SCSI scanning and removal fixes
Date: Thu, 15 Sep 2005 16:09:53 -0400
Message-ID: <1126814993.4821.56.camel@mulgrave>
References: <Pine.LNX.4.44L0.0507261020540.4746-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:61312 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030483AbVIOUJz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 16:09:55 -0400
In-Reply-To: <Pine.LNX.4.44L0.0507261020540.4746-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2005-07-26 at 10:27 -0400, Alan Stern wrote:
> This patch (as545) fixes the list traversals in __scsi_remove_target and 
> scsi_forget_host.  In each case the existing code list_for_each_entry_safe 
> in an _unsafe_ manner, because the list was not protected from outside 
> modification while the iteration was running.

Yes, but all you're doing is trying to close a race between add and
remove by trying the remove until there's nothing left.  That still
won't close the race window.

The solution is to enforce the state model:  Once the host goes into
cancel or del, no further additions may be made to the host list and if
we add the other patch to enforce the state model on removal then only
one process could be in remove as well.

> The new scsi_forget_host routine takes the moderately controversial step 
> of iterating over devices for removal rather than iterating over targets.  
> This makes more sense to me because the current scheme treats targets as 
> second-class citizens, created and removed on demand, rather than as 
> objects corresponding to actual hardware.  (Also I couldn't figure out any 
> safe way to iterate over the target list, since it's not so easy to tell 
> when a target has already been removed.)

Actually, in doing that, the target now never gets reaped, which would
leave us with dangling target objects.

James


