From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC 0/5] scsi, sd, pm, request based runtime PM for scsi disk
Date: Sat, 11 Feb 2012 20:37:07 +0100
Message-ID: <201202112037.07173.oliver@neukum.org>
References: <Pine.LNX.4.44L0.1202061007570.1525-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:43704 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab2BKTep (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Feb 2012 14:34:45 -0500
In-Reply-To: <Pine.LNX.4.44L0.1202061007570.1525-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Huang Ying <ying.huang@intel.com>, ming.m.lin@intel.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>

Am Montag, 6. Februar 2012, 16:13:37 schrieb Alan Stern:
> On Mon, 6 Feb 2012, Huang Ying wrote:
> 
> > SSD becomes more and more popular, this makes it possible to put disk into
> > low power state more often.  And request based runtime PM for scsi disk is
> > more useful than open/close based one because disk is normally mounted at
> > most time.

Yes.

> > One known issue, because SCSI TEST_UNIT_READY will be put into request
> > queue every 2 seconds by default, this makes it hard for disk to sleep.
> > Maybe we can implement check_events callback in some other way?
> > 
> > [RFC 1/5] pm, runtime, Add resume notifier
> > [RFC 2/5] scsi, pm, rename scsi_autopm_get/put_xxx to
> > [RFC 3/5] scsi, pm, add pm_runtime_get/put in scsi request
> > [RFC 4/5] scsi, pm, use autosuspend for scsi runtime PM
> > [RFC 5/5] scsi, sd, pm, request based runtime PM support
> 
> Your whole approach is at the wrong level.  Runtime PM between I/O 
> requests for block devices should be implemented in the block layer, 
> not in the SCSI layer.

I must disagree. The block layer has no more information than the SCSI
layer and lacks everything the lower layers know.

> It also is much more difficult than your patches would indicate.  For 
> example, some USB card readers indicate a media change every time they 
> resume; therefore they must not be suspended while the device file is 
> open.

Actually they must not be suspended while they contain a medium,
lest you drive the GUI and the user mad.
 
> Another difficulty arises because some drivers need to send SCSI 
> commands (such as SYNCHRONIZE CACHE) _while_ suspending or resuming.

It seems to me that most of these difficulties go away if we strictly
differentiate between host adapter and disks.

First, the sr driver cannot really suspend a disk. It can spin down a disk,
but that is not the same thing as suspending, because the disk is still
functional. It may just return special sense codes. The sr driver just
prepares devices for suspension.
It is true, that the sr driver probably does have a few conditions under
which a device should not be suspended (eg. error handling) but it
lacks positive knowledge about when we may suspend.

The same is also true for any higher layer.

The problem of needing to do IO for suspension goes away if we
treat the disk as always suspendable and use an active command
as a condition for not suspending the storage device as opposed to the disk
the problem goes away.

	Regards
		Oliver
