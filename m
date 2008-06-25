From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10861] 2.6.26-rc4-git2 - long pause during boot
Date: Wed, 25 Jun 2008 01:26:54 -0700 (PDT)
Message-ID: <20080625082654.C8FD8108035@picon.linux-foundation.org>
References: <bug-10861-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612AbYFYI04 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 04:26:56 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m5P8QsEV009335
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2008 01:26:56 -0700
In-Reply-To: <bug-10861-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10861





------- Comment #5 from chris2553@googlemail.com  2008-06-25 01:26 -------
Kay,

The udev rules that are broken/insufficient are part of the Slackware rules
file that are present in the udev distribution (including that latest release,
124).
This is the patch that I am now applying when I build udev:

--- udev-122/etc/udev/slackware/udev.rules~     2008-06-14 05:45:11.000000000
+0000
+++ udev-122/etc/udev/slackware/udev.rules      2008-06-14 05:45:30.000000000
+0000
@@ -9,7 +9,7 @@

 # wait for sysfs
 ACTION=="add", DEVPATH=="/devices/*", ENV{PHYSDEVBUS}=="?*",
WAIT_FOR_SYSFS="bus"
-ACTION=="add", SUBSYSTEM=="scsi", WAIT_FOR_SYSFS="ioerr_cnt"
+ACTION=="add", KERNEL=="[0-9]*:[0-9]*", SUBSYSTEM=="scsi",
WAIT_FOR_SYSFS="ioerr_cnt"
 ACTION=="add", SUBSYSTEM=="net", WAIT_FOR_SYSFS="address"

 # all block devices

The new rule is taken from the udev rules file for Slackware 12.1


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
