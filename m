From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17551] mpt2sas -- spurious hotplug event causes drive to drop
 out of JBOD array
Date: Sun, 5 Sep 2010 06:41:28 GMT
Message-ID: <201009050641.o856fSpg021021@demeter1.kernel.org>
References: <bug-17551-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60775 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab0IEGla (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Sep 2010 02:41:30 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o856fT8v021022
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 5 Sep 2010 06:41:29 GMT
In-Reply-To: <bug-17551-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=17551





--- Comment #9 from starlight@binnacle.cx  2010-09-05 06:40:44 ---
Possibly have figured this out.  Since the problem often has occurred when the
logging application becomes idle, it seems possible that power management in
the drives is a cause.  The Seagate Momentus ST9500420AS drives are known for
parking their heads aggressively (and driving laptop users nuts).  For some
reason 'hdparm' does not work with LSI attached drives under CentOS 5.5, but it
does work under Fedora 12.  Have a F12 OS image available on the server and
used it to run 'hdparm -B 255 /dev/sdX' on all of the drives, then rebooted
back to CentOS after verifying that the value sticks.  Time will tell if
disabling APM on the drives works around the issue.

If this is the cause, it implies that possibly the LSI firmware is mistaking
APM event notifications from the drives as hot-plug events.  Seems to me that
would be a bug.  However it's strange that this only happens after an extended
period of time, so it may be a more complex variation of that basic theory. 
Perhaps the drives have a quirk where they drop into the spin-down power state
only after a certain amount of uptime.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
