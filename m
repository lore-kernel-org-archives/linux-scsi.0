From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Disk spin-up optimization during system resume
Date: Sat, 18 Jan 2014 09:08:32 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401180906330.19470-100000@netrider.rowland.org>
References: <CAPcyv4i2+GAEV7NNx6MkOOcZSCxhOWB3sCO1eCuH40Z2fhpw3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:49876 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752032AbaAROId (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2014 09:08:33 -0500
In-Reply-To: <CAPcyv4i2+GAEV7NNx6MkOOcZSCxhOWB3sCO1eCuH40Z2fhpw3g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Phillip Susi <psusi@ubuntu.com>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 17 Jan 2014, Dan Williams wrote:

> I think it's a bit of an interface surprise to have pm_runtime disable
> have side effects only for scsi_disk devices.  I think lazy_resume
> needs to be an explicit attribute of the disk.  For ata devices any
> command wakes up the drive.  Perhaps we could simply do the same for
> scsi devices.  In lazy_resume mode flag the device as "needs spinup"
> at sd_resume time and schedule it when a command arrives.

What you have just described is essentially what runtime PM does.  
There's no need to implement it any other way.  And this explains why 
disabling runtime PM would also disable lazy resume.

Alan Stern

