From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12730] USB memory stick moved to different device on error / may be due to problem with high concurrent load on two USB devices
Date: Wed, 18 Feb 2009 07:19:34 -0800 (PST)
Message-ID: <20090218151934.A904C10803F@picon.linux-foundation.org>
References: <bug-12730-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848AbZBRPTx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2009 10:19:53 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1IFJYmv025861
	for <linux-scsi@vger.kernel.org>; Wed, 18 Feb 2009 07:19:36 -0800
In-Reply-To: <bug-12730-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12730


stern@rowland.harvard.edu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |stern@rowland.harvard.edu




------- Comment #2 from stern@rowland.harvard.edu  2009-02-18 07:19 -------
Unfortunately, a lot of EHCI hardware seems to have trouble carrying out
transfers over different ports concurrently.

Your log doesn't contain enough information to tell just what happened.  If you
want more information, you can build a kernel with CONFIG_USB_DEBUG enabled. 
There may or may not have been an actual USB disconnect.  (Such an electronic
disconnect is indeed indistinguishable from a physical unplug.)

The log shows that the 1-2 drive got into an error state requiring a reset;
quite possibly the reset failed.  This leaves the kernel no choice but to carry
out a "logical" disconnect.  While it's not exactly the same as a physical
disconnect, it is treated the same way and so it is indistinguishable as far as
most of the kernel is concerned.

It's impossible to tell whether the error state was caused by the drive or by
the EHCI controller.  To find out for certain, you'd have to use a USB bus
analyzer.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
