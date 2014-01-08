From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Wed, 8 Jan 2014 13:31:08 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401081318040.1659-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1401081220170.1659-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1401081220170.1659-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

On Wed, 8 Jan 2014, Alan Stern wrote:

> In essence, you want your disk's state to move directly from unpowered
> (system asleep) to runtime-suspended with no intermediate active -- but
> only if the disk doesn't spin up all by itself.

> In the end, it sounds like what you want can be done fairly easily.  

It turns out there is a snag.  The PM core is set up such that during
system sleep transitions, there's no way to tell whether or not
userspace has permitted runtime PM for a device.  (This is because the
core wants to prevent untimely runtime suspends from occurring in the
middle of a system sleep transition, and to do so it uses the same
mechanism as it does when userspace disallows runtime suspend.)

As a result, we must not go directly from unpowered to
runtime-suspended.  Not without some sort of change to the PM core.

Alan Stern

