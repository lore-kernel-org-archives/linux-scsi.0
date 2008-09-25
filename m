From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11645] qla2xxx.ko can't load firmware binary code
Date: Thu, 25 Sep 2008 08:26:13 -0700 (PDT)
Message-ID: <20080925152613.86D0B11D107@picon.linux-foundation.org>
References: <bug-11645-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868AbYIYP0o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2008 11:26:44 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8PFQDrh019921
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2008 08:26:14 -0700
In-Reply-To: <bug-11645-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11645





------- Comment #6 from andrew.vasquez@qlogic.com  2008-09-25 08:26 -------
Nerijus,

I'm not very familiar with Debian and their support for a
driver's use of the request_firmware() interface.  Looking at
the codes 2.6.24 debian-sources, the qla2xxx driver is in fact 
already using request_firmware().

Loading of firmware is handled behind the scenes for driver, a
call is made within the driver and the requisite kernel-space/user-space
dialogue occurs via kobject messages and reading/writing to sysfs
nodes.  You can see that being done here (2.6.25):

   Sep 25 13:08:12 ameba kernel: [72135.637331] firmware: requesting
ql2300_fw.bin
   Sep 25 13:08:22 ameba kernel: [72145.634358] qla2xxx 0000:04:04.0: Firmware
image unavailable.

Is the driver being loaded from an initramfs image?  Has the firmware
been built into that image?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
