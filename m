From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17551] mpt2sas -- spurious hotplug event causes drive drop to
 drop out of JBOD array
Date: Tue, 31 Aug 2010 12:36:20 GMT
Message-ID: <201008311236.o7VCaKvw028008@demeter1.kernel.org>
References: <bug-17551-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49668 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab0HaNfu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Aug 2010 09:35:50 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o7VDVorL002136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 31 Aug 2010 13:34:38 GMT
In-Reply-To: <bug-17551-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=17551





--- Comment #7 from starlight@binnacle.cx  2010-08-31 09:32:44 ---
Left out one bit of hardware, and remembering it lead to an idea.  A SuperMicro
SAS-113TQ SAS/SATA backplane (
http://www.supermicro.com/manuals/other/BPN-SAS-113TQ.pdf ) is also in the mix
and could be a possible cause of random hotplug events.  Distinctly recall
puzzling over two tiny ribbon cables that run between the controller card and
the backplane.  Turned out that the extra connections allow the controller and
backplane to communicate via the obscure "SGPIO" protocol (
http://en.wikipedia.org/wiki/SGPIO ).  Seems to be for flashing LEDs but who
knows?  Maybe the backplane can trigger hotplug events.

Another detail is that it's always the last drive in each of the two SAS IPASS
cable groups that drops:  either physical slot 3 or physical slot 7 (where the
ranges are 0-3 and 4-7).  A suspicious coincidence.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
