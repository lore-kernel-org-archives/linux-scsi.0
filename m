From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Wed, 5 Nov 2003 10:39:32 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060ED64@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
content-class: urn:content-classes:message
To: Mike Anderson <andmike@us.ibm.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Mike,

> > A new version of the 8.x series driver for Linux 2.6.x kernels has
> > been uploaded to SourceForge:
> 
> Thanks for the update.
> 
> Can you give more information on why clustering was turned off
> starting in b5?
> 

This change was part of a relatively large performance-patch that was
originally against the 6.x series driver.  There were two main reasons
for disabling clustering support:

	o Given the ability of the ISP to efficiently DMA to and from
	  a significant number of data segment descriptors (via
	  command/continuation type IOCBs), there were some questions
	  regarding the benefits that clustering provided given the
	  overhead incurred by the mid-layer attempting merge the
	  requests.

	o Given the ISPs inability to handle data segments that cross
	  32-bit page boundaries, and the overhead in defensive logic
	  within the driver to prevent these cases (compare the 6.x
	  code to the 8.x code and you will see what I mean), by
	  disabling clustering we guarantee that a single SG element
	  never crosses a 4GB boundary.

Now, in 2.6 there are some significant changes.  For one, with the
block layer rewrite and the ability to limit segment boundaries of a
block queue request with the blk_queue_segment_boundary() call, a LLDD
need not concern itself with any defensive fast-path logic to handle
the 4GB cross.

So, we're left with the benefits of the overhead of this merge process
done by the block layer.  I'm certainly receptive to the notion of
reexamining the use of clustering given some solid data points showing
an (significant -- this is subjective) increase in performance and/or a
resounding 'yeah, enable it!' from those in the block-layer 'know.'

Regards,
Andrew Vasquez
