From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] BUG when removing USB flash drive
Date: Sat, 15 May 2004 15:56:58 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0405151542380.17935-100000@netrider.rowland.org>
References: <20040514215501.GD10575@telpin.com.ar>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:3342 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S264716AbUEOT47
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 May 2004 15:56:59 -0400
In-Reply-To: <20040514215501.GD10575@telpin.com.ar>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Alberto Bertogli <albertogli@telpin.com.ar>, Mike Anderson <andmike@us.ibm.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

I took a look at scsi_host_cancel(), scsi_device_cancel(), and a few other 
routines.  Three things stood out:

	When a host is removed, currently executing requests are 
	aborted within the midlevel but the low-level driver is not
	informed of this.  Presumably it shouldn't care since it
	ought to cancel its own outstanding I/O?

	There's a race between scsi_host_cancel()/scsi_device_cancel()
	and scsi_times_out().  If the timer fires before 
	scsi_device_cancel() can delete it, and scsi_host_cancel()
	tests the SHOST_RECOVERY bit before the error handler manages
	to set it, then you will remove a host that's still in error
	recovery.

	There's no protection against accessing the host template
	via procfs, if a user process pins the file during
	scsi_remove_host().  You probably are already aware of this.

Alan Stern

