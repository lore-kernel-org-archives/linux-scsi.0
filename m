From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fix sd open/remove race
Date: 09 Apr 2004 11:08:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081526932.2203.61.camel@mulgrave>
References: <Pine.LNX.4.44L0.0404091141180.1000-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:8607 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261443AbUDIQJ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2004 12:09:28 -0400
In-Reply-To: <Pine.LNX.4.44L0.0404091141180.1000-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2004-04-09 at 10:55, Alan Stern wrote:
> Hmm.  That wouldn't matter if you cleared the indicator in sd_remove.  
> Then the race would only be sd_remove against sd_open.  Also, you do have
> to admit, your way of doing it is more obscure.  You should at least add
> comments explaining this 3-way race and the fact that the semaphore is
> already acquired during scsi_disk_release.

But, as I pointed out before, you can't clear the indicator in sd_remove
because, fundamentally, that's not where the race is.  The fundamental
race is the get/put one making sure no-one can get a reference to a
freed object.

sd_remove is just the disconnection indication.  It triggers a put of
the object, causing garbage collection if it's the last put, but that's
all it does.  To mediate the race, the synchronisation has to be around
object acquisition/deallocation.

I can add comments, but the placement of the semaphores is natural to
mediate the object acquisition/deallocation race.  The three thread
illustration was just the first thing that came into my head for
explaining what problems could be caused by not doing natural semaphore
placement.

James


