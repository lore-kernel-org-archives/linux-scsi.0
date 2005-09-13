From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/2] fix EH thread teardown
Date: Tue, 13 Sep 2005 16:57:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509131653100.4662-100000@iolanthe.rowland.org>
References: <20050913190536.GA26985@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:39330 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932479AbVIMU5Z
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 16:57:25 -0400
In-Reply-To: <20050913190536.GA26985@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 13 Sep 2005, Christoph Hellwig wrote:

> > Tell me what you think of this patch.  I'm not sure whether that 
> > condition, host_busy == host_failed, is correct for the call to 
> > wait_event_interruptible.
> 
> I don't think we even need the waitque, a wake_up_process can replace
> it when there's only a single process waiting on it ever.  Similarly
> we don't need eh_alive - EH must be alive after scsi_add_host returned,
> and no command may be in flight before that.

You're right about the wait_queue; I'll take it out.  The reason for 
adding eh_alive was to prevent scsi_eh_scmd_add from calling 
scsi_eh_wakeup after the error handler thread had exited.  The test that 
used to be there, shost->eh_wait == NULL, no longer applies.  On the other 
hand, since we're no longer checking for signals maybe this test isn't 
needed at all.  The error handler thread won't exit until the last 
reference to the host is gone.

Alan Stern

