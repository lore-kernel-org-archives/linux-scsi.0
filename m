From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [linux-usb-devel] BUG when removing USB flash drive
Date: Thu, 13 May 2004 22:36:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040514053623.GD3819@us.ibm.com>
References: <20040514004132.GA10537@telpin.com.ar> <Pine.LNX.4.44L0.0405132305400.32262-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:49584 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S264295AbUENFgy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 May 2004 01:36:54 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0405132305400.32262-100000@netrider.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alberto Bertogli <albertogli@telpin.com.ar>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern [stern@rowland.harvard.edu] wrote:
> This BUG happened because the SCSI layer was still using the drive after 
> usb-storage had called scsi_remove_host().

In this case the scsi_remove_host is being called in a unexpected
disconnect case. Any IOs in flight will be canceled in the mid-layer
(i.e., they will not be chased down with calls to eh_abort_handler).

> 
> This is an aspect of SCSI midlayer <-> low-level driver interaction that
> I'm not very clear about.  How long after the host is removed can the
> midlayer continue to use it?  How does the driver know when the midlayer
> is finished using the host so the driver can exit (and unload from
> memory)?

The LLDD queuecommand should not be called after the return of
scsi_remove_host (unless we have a bug). The LLDD should not free its
resources until the release function is called on the struct device
passed in during the scsi_add_host call. This release function could be
called post the scsi_host_dev_release function being called as it does a
put on this struct device. This chain of release calls is undefined as a
hotplug goes out on the remove calls, but if user space never umounts /
closes the device things will not fully cleanup.

-andmike
--
Michael Anderson
andmike@us.ibm.com

