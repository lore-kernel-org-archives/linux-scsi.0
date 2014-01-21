From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Disk spin-up optimization during system resume
Date: Tue, 21 Jan 2014 11:49:14 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401211142140.1272-100000@iolanthe.rowland.org>
References: <52DE9DDA.9010406@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56876 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754713AbaAUQtR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jan 2014 11:49:17 -0500
In-Reply-To: <52DE9DDA.9010406@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 21 Jan 2014, Phillip Susi wrote:

> On 1/21/2014 11:03 AM, Alan Stern wrote:
> > However, there is a compromise.  The user gets to select the 
> > autosuspend delay.  If that delay is set to a very large value, it
> > will effectively prevent autosuspends from occurring, without
> > causing an already-suspended device to resume right away.  (On the
> > other hand, it would not prevent a lazy resume.)
> 
> Right, so why can't you set the delay to -1 without waking the already
> sleeping drive up?  There are separate sysfs knobs for the delay and
> whether or not it is enabled, yet the kernel seems to couple the two
> together.

Right now, setting the delay to -1 is taken to mean that runtime PM 
should be disabled.  Hence, if the device is suspended, it has to be 
resumed.  (The reason is historical; in the earliest implementation of 
runtime PM, there was no way to disable it other than to set the delay 
to -1 -- there was no separate sysfs knob.)

You are suggesting that the meaning be changed: The kernel would never 
initiate an autosuspend, but runtime PM would still be enabled so the 
device would remain suspended if it already was.

I can't think of any reason why that would cause any problems.  I'll 
suggest it in a new thread on the linux-pm mailing list.  It's somewhat 
off-topic for this thread.

Alan Stern

