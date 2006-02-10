From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: SCSI BLIST_*, sdev_bflags, and scsi_device flags
Date: Fri, 10 Feb 2006 10:08:01 -0800
Message-ID: <20060210180801.GA24712@us.ibm.com>
References: <20060210001730.GA4865@us.ibm.com> <Pine.LNX.4.44L0.0602092150430.24417-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:1437 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932160AbWBJSIG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 13:08:06 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k1AI85Wc019104
	for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2006 13:08:05 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k1AI844C196154
	for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2006 13:08:04 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k1AI848R005734
	for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2006 13:08:04 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0602092150430.24417-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, Feb 09, 2006 at 10:00:52PM -0500, Alan Stern wrote:
> On Thu, 9 Feb 2006, Patrick Mansfield wrote:

> Which BLIST bits exactly are per-target?  Obviously everything with LUN in
> the name and probably the two INQUIRY flags.  Anything else?

Per other posts and whether the vendor and product can change across LU's
on a given target, they could all be per-target, but we can't assume
that. I didn't audit the BLIST values.

> > IMO store them all in sdev_bflags for now.
> 
> In fact, the sdev_bflags and the starget_bflags can be copies of each
> other (subject to modification by the host adapter driver, of course).  I
> think the accessors should be inline routines, so they can do
> type-checking on the argument (scsi_device vs. scsi_target).

I was thinking that too, but then you have to get values out of the sdev
flags, and don't need starget flags except to pass bflags around during
scan.

So, just use a per sdev flag.

> Do you mind if I don't bother to write setter routines?

I don't care. hch or James?

I think they would only be used by host drivers or transports, as the scan
would set sdev_bflags = scsi_get_device_flags().

-- Patrick Mansfield
