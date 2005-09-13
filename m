From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/2] fix EH thread teardown
Date: Tue, 13 Sep 2005 12:50:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509131247090.4481-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58788 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S964883AbVIMQu6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 12:50:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Christoph Hellwig <hch@lst.de>, SCSI development list <linux-scsi@vger.kernel.org>

Rolf Eike Beer wrote:
> 
> Ok, we looked a bit closer on all this. http://lwn.net/Articles/65178/ tells 
> that ktread_stop() will not send a signal, so the down_interruptible() will 
> never return on kthread_stop(). But calling up() directly before 
> kthread_stop() adds a race condition: if reschedule happens right after the 
> up() we've won nothing and it will hang again.

This problem shows up in other ways as well.  With hot-unpluggable 
hosts, the call that does the last 'put' on the last device will hang 
waiting for the eh thread to terminate.  See

http://bugzilla.kernel.org/show_bug.cgi?id=5237

Alan Stern

