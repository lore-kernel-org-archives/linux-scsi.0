From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: 2.6.14-rc1 load average calculation broken?
Date: Mon, 19 Sep 2005 10:24:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509191020580.5306-100000@iolanthe.rowland.org>
References: <20050919035804.GA5260@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:28567 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932429AbVISOZB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2005 10:25:01 -0400
In-Reply-To: <20050919035804.GA5260@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Jan Dittmer <jdittmer@ppp0.net>, James Bottomley <James.Bottomley@SteelEye.com>, Pavel Machek <pavel@suse.cz>, Greg KH <greg@kroah.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 18 Sep 2005, Mike Anderson wrote:

> Since scsi_eh_wakeup can only be called on a completion or timeout of an IO
> you cannot get a comparison when both are 0 (unless we have a bug
> somewhere).

This is now a moot point since James's most recent patch

http://marc.theaimsgroup.com/?l=linux-scsi&m=112709424027012&w=2

but I'll answer it anyway.  In the patch I originally wrote, the error 
handler always checked the condition shost_busy == shost_failed before 
going to sleep.  So even without scsi_eh_wakeup being called, the error 
handler would fail to go to sleep when it originally started up, because 
both values were 0.

> If the increment of host_failed, increment of host_busy, decrement of
> host_busy, and the comparison of host_busy to host_failed is all under
> the host_lock why would the atomic_t be better.

They are not under the host_lock.

Alan Stern

