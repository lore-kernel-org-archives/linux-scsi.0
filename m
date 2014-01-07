From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Tue, 7 Jan 2014 10:25:41 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401071021100.1296-100000@iolanthe.rowland.org>
References: <52CBB188.2080707@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54940 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750933AbaAGPZn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jan 2014 10:25:43 -0500
In-Reply-To: <52CBB188.2080707@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Phillip Susi <psusi@ubuntu.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>

On Tue, 7 Jan 2014, Aaron Lu wrote:

> From: Aaron Lu <aaron.lu@intel.com>
> Date: Tue, 7 Jan 2014 15:02:13 +0800
> Subject: [PATCH 1/2] SCSI: pm: make use of runtime PM for SCSI device
> 
> To make system resume fast, modify SCSI PM callbacks so that if
> CONFIG_PM_RUNTIME is set, during a system suspend transition, make the
> disk device's status exactly the same as runtime suspended, i.e. drain
> its request queue and set its request queue's status to RPM_SUSPENDED,
> so that during system resume phase, instead of resuming the device
> synchronously, we can relay the resume operation to runtime PM framework
> by calling pm_request_resume to take advantage of the block layer
> runtime PM.

This doesn't seem like a good idea.  The way to speed up resumes is to
allow sd's resume routine to return while the disk is still spinning up
(i.e., make the spin-up asynchronous).  There already have been patches
submitted to do this; I don't know what happened to them.

Alan Stern

