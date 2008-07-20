From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11120] aacraid driver stalls on high-load SMP machines
Date: Sun, 20 Jul 2008 05:30:05 -0700 (PDT)
Message-ID: <20080720123005.687A211D107@picon.linux-foundation.org>
References: <bug-11120-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756702AbYGTMaH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jul 2008 08:30:07 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m6KCU5Vu013626
	for <linux-scsi@vger.kernel.org>; Sun, 20 Jul 2008 05:30:06 -0700
In-Reply-To: <bug-11120-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11120





------- Comment #2 from Mark_Salyzyn@adaptec.com  2008-07-20 05:30 -------
Increase your scsi bus timeouts and/or decrease the device queue depth. The
driver is doing what it can when the Adapter's Firmware gets overloaded and
reticent. One of the changes post 2.6.18 was to increase the maximum SGB Length
to 256 from 128 as safe at the time, this may have allowed this series of
Adapters to run out of internal resources in combination with other changes and
improvement in the block and scsi subsystem.

The line in .../drivers/scsi/aacraid/aacraid.h:

#define AAC_MAX_32BIT_SGBCOUNT  ((unsigned short)256)

affects this value.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
