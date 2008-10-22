From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11800] building SES support fails w/ gcc-3.4.5
Date: Wed, 22 Oct 2008 12:43:28 -0700 (PDT)
Message-ID: <20081022194328.DF458108043@picon.linux-foundation.org>
References: <bug-11800-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752016AbYJVToA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2008 15:44:00 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m9MJhS3l007982
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2008 12:43:29 -0700
In-Reply-To: <bug-11800-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11800





------- Comment #2 from anonymous@kernel-bugs.osdl.org  2008-10-22 12:43 -------
Reply-To: beej@alum.mit.edu

At 18:52 10/21/2008, Andrew Morton wrote:
 >On Tue, 21 Oct 2008 11:36:12 -0700 (PDT)
 >bugme-daemon@bugzilla.kernel.org wrote:
 >
 >> http://bugzilla.kernel.org/show_bug.cgi?id=11800
 >>
 >>            Summary: building SES support fails w/ gcc-3.4.5
 >>            Product: SCSI Drivers
 >>            Version: 2.5
 >>      KernelVersion: 2.6.27.1
 >>           Platform: All
 >>         OS/Version: Linux
 >>               Tree: Mainline
 >>             Status: NEW
 >>           Severity: normal
 >>           Priority: P1
 >>          Component: Other
 >>         AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
 >>         ReportedBy: bugzilla.kernel.org@beej.org
 >>
 >>
 >> [beej@dell ~]$ cat /etc/redhat-release
 >> CentOS release 4.3 (Final)
 >> [beej@dell ~]$ rpm -qf `which gcc`
 >> gcc-3.4.5-2
 >> [beej@dell linux-2.6.27.1]$ diff .config .config.old
 >> 4c4
 >> < # Tue Oct 21 14:07:00 2008
 >> ---
 >> > # Thu Oct 16 17:54:42 2008
 >> 1006c1006
 >> < # CONFIG_SCSI_ENCLOSURE is not set
 >> ---
 >> > CONFIG_SCSI_ENCLOSURE=m
 >>
 >> using .config.old,
 >> [beej@dell linux-2.6.27.1]$ make
 >> <snip>
 >> Kernel: arch/x86/boot/bzImage is ready  (#2)
 >>   Building modules, stage 2.
 >>   MODPOST 668 modules
 >> ERROR: "__you_cannot_kmalloc_that_much" [drivers/scsi/ses.ko] undefined!
 >> make[1]: *** [__modpost] Error 1
 >> make: *** [modules] Error 2
 >>
 >
 >That's weird.  It means that we did a kmalloc(N, ...) where the value
 >of N is known at compile time, and N is too large.
 >
 >But I can find no such kmalloc/kzalloc calls in ses.c.  It might be gcc
 >bustage - we've seen that before.
 >
 >Please do
 >
 >      make drivers/scsi/ses.s
 >
 >then have a look in drivers/scsi/ses.s and see which function is
 >emitting a call to __you_cannot_kmalloc_that_much.  Or email me
 >drivers/scsi/ses.s and I'll take a look.

attached

marc


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
