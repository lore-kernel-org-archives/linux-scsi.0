From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after 2.6.20
Date: Wed, 19 Nov 2008 14:10:09 -0800 (PST)
Message-ID: <20081119221009.166C910800F@picon.linux-foundation.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968AbYKSWKk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2008 17:10:40 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mAJMA9We023515
	for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2008 14:10:10 -0800
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646





------- Comment #16 from daniel@economicmodeling.com  2008-11-19 14:10 -------
I have experienced this bug on IBM HS21 Blades running Debian Lenny/2.6.22
connected to IBM DS3400 storage via qlogic switch. The crashes occurred during
cp and rsync operations from one array to another.

I solved the problem by replacing the Linux qla2xxx module with the official
qlogic RHEL/SUSE driver and hacking it to work as a module in Debian. The
mailbox timeouts stopped after switching drivers. This suggests a bug in the
current Linux qla2xxx driver- NOT a hardware problem.

Here is syslog output from a typical crash:

Jan 27 19:41:53 hqhost kernel: qla2xxx 0000:08:01.0: Mailbox command timeout
occured. Issuing ISP abort.
Jan 27 19:41:53 hqhost kernel: qla2xxx 0000:08:01.0: Performing ISP error
recovery - ha= ffff810223d0c530.
Jan 27 19:41:53 hqhost kernel: qla2xxx 0000:08:01.0: LOOP UP detected (4 Gbps).
Jan 27 19:41:54 hqhost kernel: qla2xxx 0000:08:01.0: SNS scan failed --
assuming zero-entry result...
Jan 27 19:41:54 hqhost kernel: APIC error on CPU0: 00(40)
Jan 27 19:41:54 hqhost kernel: qla2xxx 0000:08:01.0: scsi(0:0:1): Abort command
issued -- 0 9a776 2002.
Jan 27 19:42:28 hqhost kernel:  rport-0:0-0: blocked FC remote port time out:
removing target and saving binding
Jan 27 19:42:28 hqhost kernel:  rport-0:0-4: blocked FC remote port time out:
removing target and saving binding
Jan 27 19:42:28 hqhost kernel:  rport-0:0-5: blocked FC remote port time out:
removing target and saving binding
Jan 27 19:42:28 hqhost kernel: qla2xxx 0000:08:01.0: scsi(0:0:0): DEVICE RESET
ISSUED.
Jan 27 19:42:28 hqhost kernel: APIC error on CPU5: 00(40)
Jan 27 19:42:28 hqhost kernel: sd 0:0:0:0: [sda] Synchronizing SCSI cache


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
