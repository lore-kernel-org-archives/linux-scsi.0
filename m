From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: 2.4.19 SCSI error handing, door locking, etc
Date: Fri, 4 Oct 2002 12:41:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021004194136.GC9544@beaverton.ibm.com>
References: <20020926012357.B8733@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020926012357.B8733@flint.arm.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-scsi@vger.kernel.org

Russell,

	Sorry it took so long to port forward and test these changes.  I
	will be posting the set of patches to the list right after this
	mail.

	Here is an overview the forward port in relation to your
	patches.

01-scsi-cmd-retry-1.diff
	- Brought forward with minor arg/ variable renaming.
01-scsi-cmd-retry-2.diff
	- Brought forward though my original implementation of how retries
	  are controlled is different than your code.
01-scsi-cmd-retry-3.diff
	- I need to think on this. I currently have 1 retry for TUR and
	  non for REQ sense. If a device is not responding the way we want the
	  probability of sending multiple commands in a short time period
	  especially TURs is most likely not going to result in what we
	  want. Though your delay mentioned below is something I
	  currently do not have. 
02-scsi-cmd-report.diff
	- I brought this forward, but it bothers me that the data in a
	  cmd is incorrect as the command should be restored after it has
	  been touched by error handling.
03-scsi-restart-ops.diff
	- Brought forward. In 2.5 we should probably consider removing all
	  these checks and just call the request_fn so that we do not have
	  the checks spread all over which leads to them becoming out of
	  sync or implemented incorrectly.  
04-scsi-door-lock-1.diff
	- Brought forward. I did need to increase the bus reset settle
	  time from 5 seconds to 10 to get the door lock to re-lock the
	  door.
04-scsi-door-lock-2.diff
	- Brought forward. In 2.5 we do not have the old error handler so
	  I removed the door lock completely from the the scsi_request_fn
	  function.
05-scsi-unjam-clean-1.diff
05-scsi-unjam-clean-2.diff
05-scsi-unjam-clean-3.diff
05-scsi-unjam-clean-4.diff
05-scsi-unjam-clean-5.diff
05-scsi-unjam-clean-6.diff
05-scsi-unjam-clean-8.diff
	- The previous patch I created for 2.5 scsi_error cleanup I
	believe covers similar changes as yours for 2.4. Patch is now
	part of 2.5.40.

05-scsi-unjam-clean-7.diff
	- I have not covered all these yet. One change that
	  made a difference is how the tur retry is done and I also
	  increased the bus_reset settle delay from 5 to 10. I will try to
	  ensure that the error policy you want is covered in 2.5.

2.) Added scsi_set_medium_removal to scsi_syms.c and scsi_ioctl.h



-andmike
--
Michael Anderson
andmike@us.ibm.com

