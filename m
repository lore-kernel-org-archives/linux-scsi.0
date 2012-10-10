From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/2] [SCSI] sd: update sd to use the new pm callbacks
Date: Wed, 10 Oct 2012 14:35:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1210101433571.1170-100000@iolanthe.rowland.org>
References: <1349854086-2502-3-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59574 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755516Ab2JJSfs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Oct 2012 14:35:48 -0400
In-Reply-To: <1349854086-2502-3-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>

On Wed, 10 Oct 2012, Aaron Lu wrote:

> Update sd driver to use the callbacks defined in dev_pm_ops.
> 
> sd_freeze is NULL, the bus level callback has taken care of quiescing
> the device so there should be nothing needs to be done here.
> Consequently, sd_thaw is not needed here either.
> 
> Both suspend and poweroff shares the same routine sd_suspend, which will
> sync flush and then stop the drive, this is the same as before.
> 
> sd_runtime_suspend also uses sd_suspend, so when a scsi disk is runtime
> suspended, it will be placed to stopped power state.

This is not the same as before.  The existing code does not spin down 
the disk during runtime suspend.

Now maybe it should -- I don't know.  The point is that this patch 
makes two separate changes, which is generally not a good idea.

Alan Stern

