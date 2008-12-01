From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: fix /proc memory leak in the SCSI core
Date: Mon, 1 Dec 2008 10:51:42 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0812011051260.2212-100000@iolanthe.rowland.org>
References: <4934060A.9050809@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34790 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751638AbYLAPvn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2008 10:51:43 -0500
In-Reply-To: <4934060A.9050809@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 1 Dec 2008, Boaz Harrosh wrote:

> Alan Stern wrote:
> > The SCSI core calls scsi_proc_hostdir_add() from within
> > scsi_host_alloc(), but the corresponding scsi_proc_hostdir_rm()
> > routine is called from within scsi_remove_host().  As a result, if a
> > host is allocated and then deallocated without ever being registered,
> > the host's directory in /proc is leaked.
> > 
> > This patch (as1181) fixes this bug in the SCSI core by moving
> > scsi_proc_hostdir_add() into scsi_host_add().
> > 
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > 
> 
> Nice this also fixes the premature visibility of the directory
> and the theoretical races, that can cause.

I'm not so sure about that...  There's still a window in which the
directory is visible but empty; it's just smaller than before.

Besides, the window that really matters is between sending out the
uevent notification (during device_add) and populating the directory.
The patch doesn't address that problem.  Should it?

Alan Stern

