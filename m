From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bugme-new] [Bug 9405] New: iSCSI does not implement ordering
 guarantees required by e.g. journaling filesystems
Date: Mon, 19 Nov 2007 15:15:22 -0600
Message-ID: <4741FCEA.4040101@cs.wisc.edu>
References: <bug-9405-10286@http.bugzilla.kernel.org/> <20071119125040.9f6eb1e2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020808030804080107040306"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54783 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbXKSVPr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 16:15:47 -0500
In-Reply-To: <20071119125040.9f6eb1e2.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, bart.vanassche@gmail.com

This is a multi-part message in MIME format.
--------------020808030804080107040306
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> On Mon, 19 Nov 2007 05:44:01 -0800 (PST)
> bugme-daemon@bugzilla.kernel.org wrote:
> 
>> http://bugzilla.kernel.org/show_bug.cgi?id=9405
>>
>>            Summary: iSCSI does not implement ordering guarantees required by
>>                     e.g. journaling filesystems
>>            Product: IO/Storage
>>            Version: 2.5
>>      KernelVersion: 2.6.23.1
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: high
>>           Priority: P1
>>          Component: SCSI
>>         AssignedTo: io_scsi@kernel-bugs.osdl.org
>>         ReportedBy: bart.vanassche@gmail.com
>>
>>
>> Most recent kernel where this bug did not occur: (new issue)
>> Distribution: any
>> Hardware Environment: (does not apply)
>> Software Environment: (does not apply) 
>> Problem Description: The sd (SCSI disk) driver ignores block device barriers
>> (REQ_HARDBARRIER). The iSCSI code in the kernel sends all iSCSI commands with
>> flag ISCSI_ATTR_SIMPLE to the iSCSI target. This means that the target may
>> reorder these commands. Since a.o. correct operation of journaling filesystems
>> depends on being able to enforce the order of certain block write operations,
>> not enforcing write ordering is a bug. This can be solved by either adding
>> support for REQ_HARDBARRIER in the sd device or by replacing ISCSI_ATTR_SIMPLE
>> by ISCSI_ATTR_ORDERED.
>>
>> Steps to reproduce: Source reading of drivers/scsi/sd.c and
>> drivers/scsi/libiscsi.c.
>>
>> References: SCSI Architecture Model - 3, paragraph 8.6
>> (http://www.t10.org/ftp/t10/drafts/sam3/sam3r14.pdf).
>>
> 
> (does iscsi have a maintainer?)

Attached is a patch to add me to the maintainers file so it will be 
easier to hunt me down in the future. It was made over 2.6.24-rc2.

--------------020808030804080107040306
Content-Type: text/x-patch;
 name="add-mike-christie-to-maintainers.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="add-mike-christie-to-maintainers.patch"

Add Mike Christie to MAINTAINERS file.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/MAINTAINERS b/MAINTAINERS
index 1c7c229..82b5751 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2111,6 +2111,14 @@ L:	irda-users@lists.sourceforge.net (subscribers-only)
 W:	http://irda.sourceforge.net/
 S:	Maintained
 
+iSCSI
+P:	Mike Christie
+M:	michaelc@cs.wisc.edu
+L:	open-iscsi@googlegroups.com
+W:	www.open-iscsi.org
+T:	git kernel.org:/pub/scm/linux/kernel/mnc/linux-2.6-iscsi.git
+S:	Maintained
+
 ISAPNP
 P:	Jaroslav Kysela
 M:	perex@perex.cz

--------------020808030804080107040306--
