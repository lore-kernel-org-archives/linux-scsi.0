From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC 0/5] scsi, sd, pm, request based runtime PM for scsi disk
Date: Mon, 6 Feb 2012 10:13:37 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1202061007570.1525-100000@iolanthe.rowland.org>
References: <1328513548-19786-1-git-send-email-ying.huang@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1328513548-19786-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 6 Feb 2012, Huang Ying wrote:

> SSD becomes more and more popular, this makes it possible to put disk into
> low power state more often.  And request based runtime PM for scsi disk is
> more useful than open/close based one because disk is normally mounted at
> most time.
> 
> One known issue, because SCSI TEST_UNIT_READY will be put into request
> queue every 2 seconds by default, this makes it hard for disk to sleep.
> Maybe we can implement check_events callback in some other way?
> 
> [RFC 1/5] pm, runtime, Add resume notifier
> [RFC 2/5] scsi, pm, rename scsi_autopm_get/put_xxx to
> [RFC 3/5] scsi, pm, add pm_runtime_get/put in scsi request
> [RFC 4/5] scsi, pm, use autosuspend for scsi runtime PM
> [RFC 5/5] scsi, sd, pm, request based runtime PM support

Your whole approach is at the wrong level.  Runtime PM between I/O 
requests for block devices should be implemented in the block layer, 
not in the SCSI layer.

It also is much more difficult than your patches would indicate.  For 
example, some USB card readers indicate a media change every time they 
resume; therefore they must not be suspended while the device file is 
open.

Another difficulty arises because some drivers need to send SCSI 
commands (such as SYNCHRONIZE CACHE) _while_ suspending or resuming.

Alan Stern
