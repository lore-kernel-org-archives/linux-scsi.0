From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: 2.4.19 SCSI error handing, door locking, etc
Date: Fri, 4 Oct 2002 20:49:25 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021004204925.D31015@flint.arm.linux.org.uk>
References: <20020926012357.B8733@flint.arm.linux.org.uk> <20021004194136.GC9544@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flint.arm.linux.org.uk ([3ffe:8260:2002:1:201:2ff:fe14:8fad])
	by caramon.arm.linux.org.uk with asmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.04)
	id 17xYRy-0002mO-00
	for linux-scsi@vger.kernel.org; Fri, 04 Oct 2002 20:49:26 +0100
Received: from rmk by flint.arm.linux.org.uk with local (Exim 4.04)
	id 17xYRx-0007J6-00
	for linux-scsi@vger.kernel.org; Fri, 04 Oct 2002 20:49:25 +0100
Content-Disposition: inline
In-Reply-To: <20021004194136.GC9544@beaverton.ibm.com>; from andmike@us.ibm.com on Fri, Oct 04, 2002 at 12:41:36PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Fri, Oct 04, 2002 at 12:41:36PM -0700, Mike Anderson wrote:
> 01-scsi-cmd-retry-3.diff
> 	- I need to think on this. I currently have 1 retry for TUR and
> 	  non for REQ sense. If a device is not responding the way we want the
> 	  probability of sending multiple commands in a short time period
> 	  especially TURs is most likely not going to result in what we
> 	  want. Though your delay mentioned below is something I
> 	  currently do not have. 

With the current behaviour, I've seen this situation:

- bus reset
- tape drive responds to bus reset by positioning at the start of tape
- while tape drive is repositioning, it returns "drive not ready"
- we mark the tape drive off line despite there being absolutely
  nothing wrong with it.

> 02-scsi-cmd-report.diff
> 	- I brought this forward, but it bothers me that the data in a
> 	  cmd is incorrect as the command should be restored after it has
> 	  been touched by error handling.

It goes wrong when HBA drivers use the Scsi_Cmnd to perform the
request sense, and don't restore the command structure.  I've seen
no documentation that says "HBA drivers must restore the Scsi_Cmnd
structure to pristine state before handing it back to the scsi core."

Ok, I'll update my 2.4 version with your comments to keep things
consistent.  The bits people are happy with I'm again submit to Alan.

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

