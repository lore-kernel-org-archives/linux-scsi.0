From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Notify about errors during initialization
Date: Mon, 8 Dec 2003 11:15:06 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0312081101480.1043-100000@ida.rowland.org>
References: <20031207051634.GB21951@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:9732 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264574AbTLHQPH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Dec 2003 11:15:07 -0500
In-Reply-To: <20031207051634.GB21951@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

Cross-posted to the linux-scsi list in the hope that someone there can 
confirm this answer...

On Sat, 6 Dec 2003, Matthew Dharm wrote:

> Question: Are we guaranteed that scsi_scan_host() doesn't return until the
> scanning process is complete?

I'm not absolutely certain -- best to check with someone on the linux-scsi
list.  But a quick look through the call chain in scsi_scan.c indicates
that scsi_scan_host() doesn't return until the scanning process is indeed
complete.  The real work is done in scsi_probe_lun() (called from
scsi_probe_and_add_lun()), and that uses scsi_wait_req().  After all, it
can't tell whether the LUN is there or not until it gets a reply to the
INQUIRY!

> I recall a problem that we had with the setting of flags and the call to
> scan the host -- without pre-emption, it worked, but with pre-emption
> things happened in the wrong order.  Could that happen here?

I don't remember that problem.  But I don't think pre-emption would cause 
any difficulties here.  All the flags should be set before we call 
scsi_scan_host().  If you can provide more details or a reference to what 
you're thinking of, I could reply in more detail.

When pre-emption does cause a problem it's generally because of some
assumption that the current task won't be scheduled out when it calls up()
or complete() or something like that.

Alan Stern

