From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: BUG in sd.c
Date: Wed, 4 Feb 2004 09:14:01 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040204171401.GA1687@beaverton.ibm.com>
References: <Pine.LNX.4.44L0.0402041108310.6676-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:49034 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S262827AbUBDRJN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Feb 2004 12:09:13 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0402041108310.6676-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Frank Pieczynski <pieczy@web.de>

Alan Stern [stern@rowland.harvard.edu] wrote:
> The following Bugzilla entry:
> 
> http://bugme.osdl.org/show_bug.cgi?id=1986
> 
> reports a problem with a USB card reader.  The cause and resolution of
> that problem are irrelevant to this list, but the manifestation of the
> problem may have been that the device replied with Check Condition (and no
> sense data) to every command.
> 
> At any rate, this caused an oops as a result of sd.c calling 
> scsi_disk_get() after the device's reference count had gone to 0.  Can 
> someone look at this and see if sd.c needs to be fixed?
> 
> Alan Stern

Just a quick look. We are racing scsi_disk_release with sd_open. The
return code check in scsi_disk_get from the call to kobject_get is
worthless. The kobject_get will take do a inc even if we may already be
in release. This will cause a oops as we will fail the scsi_device_get
call in scsi_disk_get which will cause a call to kobject_put on a struct
that will most likely be free'd. 

Maybe I am still reading the block layer locking wrong, but I do not see a
method to close the race with blkdev_open. I will look at this some more
and see if I can get a clue what I am missing.

-andmike
--
Michael Anderson
andmike@us.ibm.com

