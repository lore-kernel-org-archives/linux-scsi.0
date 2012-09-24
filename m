From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v7 0/6] ZPODD patches
Date: Mon, 24 Sep 2012 11:47:28 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1209241131430.1583-100000@iolanthe.rowland.org>
References: <20120924025540.GA15069@mint-spring.sh.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52126 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754776Ab2IXPr3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2012 11:47:29 -0400
In-Reply-To: <20120924025540.GA15069@mint-spring.sh.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@vger.kernel.org>, Aaron Lu <aaron.lwe@gmail.com>

[CC: list trimmed somewhat]

On Mon, 24 Sep 2012, Aaron Lu wrote:

> I've tried to do a disk_block_events call on its suspend callback when
> it is ready to be powered off, but there is a race that I don't know how
> to solve:
> pm_runtime_suspend			disk_events_workfn		
>   scsi_dev_type_suspend			  sr_block_check_events
>     sr_suspend				    cdrom_check_events
>       disk_block_events		      	      cdrom_update_events
>       (this call waits for all		        sr_check_events
>       running events_checking function	          scsi_autopm_get_device
>       to return)
> 
> Suppose sr_suspend runs first, and then sr_check_events comes in.
> sr_suspend calls disk_block_events, which waits for sr_check_events,
> while scsi_autopm_get_device wait for suspend callback to finish,
> deadlock.

The problem is in the scsi_autopm_get_device call.  What you need to do
here is increment the PM usage counter without resuming the drive.  
Then if the runtime PM status is RPM_SUSPENDING, decrement the usage
counter and return immediately (skip the status check); otherwise call
scsi_autopm_get_device as before and do an extra decrement after the
status check is finished.

It's a little more tricky than this because you need to acquire the 
private runtime PM spinlock in addition to incrementing the usage 
counter, for proper synchronization.  I don't think we have any 
interface to do this, although it would be easy to add one.

Alan Stern

