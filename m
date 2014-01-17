From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Disk spin-up optimization during system resume
Date: Fri, 17 Jan 2014 13:18:43 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401171317480.1162-100000@iolanthe.rowland.org>
References: <20140117102121.GA8598@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54958 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751951AbaAQSSo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 13:18:44 -0500
In-Reply-To: <20140117102121.GA8598@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Oliver Neukum <oneukum@suse.de>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Phillip Susi <psusi@ubuntu.com>, Aaron Lu <aaron.lu@intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 17 Jan 2014, Tejun Heo wrote:

> Hello,
> 
> On Fri, Jan 17, 2014 at 11:16:49AM +0100, Oliver Neukum wrote:
> > The START-STOP may result in an error. What do you do in that case?
> 
> At least for libata, worrying about suspend/resume failures don't make
> whole lot of sense.  If suspend failed, just proceed with suspend.  If
> the device can't be woken up afterwards, that's that.  There isn't
> anything we could have done differently anyway.  The same for resume,
> if spinup fails, the device is dud and the following commands will
> invoke EH actions and will eventually fail.  Again, there really isn't
> any *choice* to make.  Just making sure the errors are handled
> gracefully (ie. don't crash) and the following commands are handled
> correctly should be enough.

Absolutely.  Even with normal synchronous resumes, we don't do 
anything if an error occurs, other than printing it in the kernel log.

Alan Stern

