From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Disk spin-up optimization during system resume
Date: Tue, 21 Jan 2014 11:03:20 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401211049160.1272-100000@iolanthe.rowland.org>
References: <52DE860C.6010502@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56852 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755099AbaAUQDX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jan 2014 11:03:23 -0500
In-Reply-To: <52DE860C.6010502@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 21 Jan 2014, Phillip Susi wrote:

> On 1/21/2014 5:12 AM, Dan Williams wrote:
> > The need is to avoid tying rpm and dpm ops together in surprising
> > new ways that require userspace to change if it wants to keep the
> > default behavior of hiding resume latency as much as possible.  A
> > lazy_resume knob vs changing the default let's the few setups that
> > care set the power-up in standby mode.  It should also "perform"
> > better given it does not require the disk to be runtime suspended
> > prior to system suspend, it will unconditionally resume on demand.
> 
> The more I think about it the more I agree that the new knob is
> needed.  If the user wants runtime pm but without the lazy system
> resume, switching off runtime pm prior to suspend would needlessly
> force the disk to spin up if it is already in standby, then right back
> down again.  At least, that's how rpm is currently implemented, which
> is something else I found odd about it.  Why can't you disable auto
> suspend, but still be able to manually suspend or leave an already
> suspended device asleep?

The user is in charge of enabling or disabling runtime PM.  But the
kernel chooses whether or not runtime PM will use autosuspend -- the
user doesn't get to decide that.  It is determined by how the driver is
written.

Thus, if a device's driver chooses to use autosuspend, the only way the 
user can prevent the device from going into runtime suspend is by 
disabling it for runtime PM altogether (which means waking up the 
device if it is already suspended).

However, there is a compromise.  The user gets to select the
autosuspend delay.  If that delay is set to a very large value, it will
effectively prevent autosuspends from occurring, without causing an
already-suspended device to resume right away.  (On the other hand, it 
would not prevent a lazy resume.)

Alan Stern

