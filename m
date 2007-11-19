From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 9405] New: iSCSI does not implement ordering
 guarantees required by e.g. journaling filesystems
Date: Mon, 19 Nov 2007 12:50:40 -0800
Message-ID: <20071119125040.9f6eb1e2.akpm@linux-foundation.org>
References: <bug-9405-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55822 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751551AbXKSUun (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 15:50:43 -0500
In-Reply-To: <bug-9405-10286@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bugme-daemon@bugzilla.kernel.org, bart.vanassche@gmail.com

On Mon, 19 Nov 2007 05:44:01 -0800 (PST)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=9405
> 
>            Summary: iSCSI does not implement ordering guarantees required by
>                     e.g. journaling filesystems
>            Product: IO/Storage
>            Version: 2.5
>      KernelVersion: 2.6.23.1
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: SCSI
>         AssignedTo: io_scsi@kernel-bugs.osdl.org
>         ReportedBy: bart.vanassche@gmail.com
> 
> 
> Most recent kernel where this bug did not occur: (new issue)
> Distribution: any
> Hardware Environment: (does not apply)
> Software Environment: (does not apply) 
> Problem Description: The sd (SCSI disk) driver ignores block device barriers
> (REQ_HARDBARRIER). The iSCSI code in the kernel sends all iSCSI commands with
> flag ISCSI_ATTR_SIMPLE to the iSCSI target. This means that the target may
> reorder these commands. Since a.o. correct operation of journaling filesystems
> depends on being able to enforce the order of certain block write operations,
> not enforcing write ordering is a bug. This can be solved by either adding
> support for REQ_HARDBARRIER in the sd device or by replacing ISCSI_ATTR_SIMPLE
> by ISCSI_ATTR_ORDERED.
> 
> Steps to reproduce: Source reading of drivers/scsi/sd.c and
> drivers/scsi/libiscsi.c.
> 
> References: SCSI Architecture Model - 3, paragraph 8.6
> (http://www.t10.org/ftp/t10/drafts/sam3/sam3r14.pdf).
> 

(does iscsi have a maintainer?)
