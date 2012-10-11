From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 2/2] [SCSI] sd: update sd to use the new pm callbacks
Date: Thu, 11 Oct 2012 16:10:19 +0800
Message-ID: <20121011081018.GB1819@mint-spring.sh.intel.com>
References: <1349854086-2502-3-git-send-email-aaron.lu@intel.com>
 <Pine.LNX.4.44L0.1210101433571.1170-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59568 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758106Ab2JKIKW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Oct 2012 04:10:22 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1210101433571.1170-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>

On Wed, Oct 10, 2012 at 02:35:47PM -0400, Alan Stern wrote:
> On Wed, 10 Oct 2012, Aaron Lu wrote:
> 
> > Update sd driver to use the callbacks defined in dev_pm_ops.
> > 
> > sd_freeze is NULL, the bus level callback has taken care of quiescing
> > the device so there should be nothing needs to be done here.
> > Consequently, sd_thaw is not needed here either.
> > 
> > Both suspend and poweroff shares the same routine sd_suspend, which will
> > sync flush and then stop the drive, this is the same as before.
> > 
> > sd_runtime_suspend also uses sd_suspend, so when a scsi disk is runtime
> > suspended, it will be placed to stopped power state.
> 
> This is not the same as before.  The existing code does not spin down 
> the disk during runtime suspend.
> 
> Now maybe it should -- I don't know.  The point is that this patch 
> makes two separate changes, which is generally not a good idea.

Agree. Will seperate, thanks.

-Aaron

