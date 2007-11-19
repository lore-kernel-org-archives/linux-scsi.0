From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 9405] New: iSCSI does not implement ordering
	guarantees required by e.g. journaling filesystems
Date: Mon, 19 Nov 2007 15:28:40 -0600
Message-ID: <1195507720.3963.4.camel@localhost.localdomain>
References: <bug-9405-10286@http.bugzilla.kernel.org/>
	 <20071119125040.9f6eb1e2.akpm@linux-foundation.org>
	 <1195505766.3963.1.camel@localhost.localdomain>
	 <4741FE89.4020307@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:45600 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244AbXKSV2o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 16:28:44 -0500
In-Reply-To: <4741FE89.4020307@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, bart.vanassche@gmail.com


On Mon, 2007-11-19 at 15:22 -0600, Mike Christie wrote:
> James Bottomley wrote:
> > On Mon, 2007-11-19 at 12:50 -0800, Andrew Morton wrote:
> >> On Mon, 19 Nov 2007 05:44:01 -0800 (PST)
> >> bugme-daemon@bugzilla.kernel.org wrote:
> >>
> >>> http://bugzilla.kernel.org/show_bug.cgi?id=9405
> >>>
> >>>            Summary: iSCSI does not implement ordering guarantees required by
> >>>                     e.g. journaling filesystems
> >>>            Product: IO/Storage
> >>>            Version: 2.5
> >>>      KernelVersion: 2.6.23.1
> >>>           Platform: All
> >>>         OS/Version: Linux
> >>>               Tree: Mainline
> >>>             Status: NEW
> >>>           Severity: high
> >>>           Priority: P1
> >>>          Component: SCSI
> >>>         AssignedTo: io_scsi@kernel-bugs.osdl.org
> >>>         ReportedBy: bart.vanassche@gmail.com
> >>>
> >>>
> >>> Most recent kernel where this bug did not occur: (new issue)
> >>> Distribution: any
> >>> Hardware Environment: (does not apply)
> >>> Software Environment: (does not apply) 
> >>> Problem Description: The sd (SCSI disk) driver ignores block device barriers
> >>> (REQ_HARDBARRIER). The iSCSI code in the kernel sends all iSCSI commands with
> >>> flag ISCSI_ATTR_SIMPLE to the iSCSI target. This means that the target may
> >>> reorder these commands. Since a.o. correct operation of journaling filesystems
> >>> depends on being able to enforce the order of certain block write operations,
> >>> not enforcing write ordering is a bug. This can be solved by either adding
> >>> support for REQ_HARDBARRIER in the sd device or by replacing ISCSI_ATTR_SIMPLE
> >>> by ISCSI_ATTR_ORDERED.
> >>>
> >>> Steps to reproduce: Source reading of drivers/scsi/sd.c and
> >>> drivers/scsi/libiscsi.c.
> >>>
> >>> References: SCSI Architecture Model - 3, paragraph 8.6
> >>> (http://www.t10.org/ftp/t10/drafts/sam3/sam3r14.pdf).
> >>>
> >> (does iscsi have a maintainer?)
> > 
> > Yes, mike christie
> > 
> > And please close this as invalid.  FS ordering guarantees in linux
> > aren't done via ordered tags.
> > 
> 
> I had a related question. I was working on the attached patch for soe 
> other testing (patch made against scsi-rc-fixes, but is not stable so do 
> not apply), which does the scsi_populate_tag_msg conversion from MSG_* 
> to ISCSI_ATTR and sets the proper iscsi bits.
> 
> If I do this patch where I call scsi_activate_tcq on a device and that 
> concertsion, does this require that my driver not reorder commands? I 
> was just a little worried on some of the error handling paths where we 
> requeue commands to the mid layer.

Right, there's no way of guaranteeing that commands aren't reordered in
the error path (or even the queue full submission path) which is why we
don't use ordered tags to enforce barriers.

James


