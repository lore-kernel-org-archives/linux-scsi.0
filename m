From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: PATCH: (as54) Fix hot-unplugging for sr.c
Date: Wed, 9 Jul 2003 07:44:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030709144410.GA3544@beaverton.ibm.com>
References: <20030708222906.GF2232@beaverton.ibm.com> <Pine.LNX.4.44L0.0307090956350.846-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:23182 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S268276AbTGIO07
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2003 10:26:59 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0307090956350.846-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern [stern@rowland.harvard.edu] wrote:
> On Tue, 8 Jul 2003, Mike Anderson wrote:
> 
> > Alan,
> > 	This looks like it solves the problem for sr and could be
> > 	replicated for other upper level drivers. The patch I created
> > 	works a little differently in that the remove function is not
> > 	called until opens drop to zero (if the device is open).
> 
> Interesting.  As I understand it, remove() is called from the SCSI core
> whereas block_release() is called through the filesystem.  The two code
> paths only intersect in sr.c.  So how does the core know when opens drops
> to 0?

struct device_driver remove() is called as a result of device_unregister
or device_del being called which usually is called by the SCSI core.

I changed scsi_device_put to check if access_count drops to zero and the
device is marked to be deleted. If these two checks are true then call
device_del. access_count is also checked in the scsi_sysfs.c code under
a common sema.

> Speaking of /proc/scsi, have you given any thought to making the procinfo 
> contents available through sysfs?  That way the /proc entry points can be 
> deprecated and eventually removed, but the information will still be 
> easily available.

Yes we should look into this. A old issue was a policy for sysfs of
one attribute value per file. This would be a large overhead for some of
the LLDDs to convert to and it would probably be a mess in the
directory.

-andmike
--
Michael Anderson
andmike@us.ibm.com

