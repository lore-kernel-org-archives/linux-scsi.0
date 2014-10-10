From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85151] pm80xx + 7805H + HP SAS port expander =
 mpi_smp_completion 2604:smp IO status 0x2 and sas: expander ... discovery
 failed(0xffffffa6)
Date: Fri, 10 Oct 2014 21:32:26 +0000
Message-ID: <bug-85151-11613-Eq8to5djfm@https.bugzilla.kernel.org/>
References: <bug-85151-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43135 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbaJJVcb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Oct 2014 17:32:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 546352017D
	for <linux-scsi@vger.kernel.org>; Fri, 10 Oct 2014 21:32:30 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 0027820212
	for <linux-scsi@vger.kernel.org>; Fri, 10 Oct 2014 21:32:26 +0000 (UTC)
In-Reply-To: <bug-85151-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85151

--- Comment #12 from linux-ide@crashplan.pro ---
Note the changed behavior with kernel "Linux ubuntu14 3.17.0-031700rc7-generic
#201409281835 SMP Sun Sep 28 22:36:30 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux"
&& patched pm80xx, despite the SAS discovery errors the HP SAS expander is now
visible:

# lsscsi -g
[0:0:0:0]    disk    ATA      OCZ-VERTEX       1.3   /dev/sda   /dev/sg0
[4:0:0:0]    enclosu HP       HP SAS EXP Card  2.10  -          /dev/sg1

===
2nd HP SAS expander card = ok
===
Tried with a second HP SAS expander card, that also lists ok in lsscsi.

===
1 day more recent mainline kernel using unpatched pm80xx.ko = not ok
===
# uname -a
Linux ubuntu14 3.17.0-999-generic #201409282205 SMP Mon Sep 29 02:06:39 UTC
2014 x86_64 x86_64 x86_64 GNU/Linux
# modprobe -v pm80xx
...
insmod /lib/modules/3.17.0-999-generic/kernel/drivers/scsi/pm8001/pm80xx.ko
# lsscsi -g
[0:0:0:0]    disk    ATA      OCZ-VERTEX       1.3   /dev/sda   /dev/sg0

===
Copying this patched mv80xx over to 3.17.0-999 = ok
===
Unload
# modprobe -rv pm80xx
Rename stock kernel module
# mv /lib/modules/3.17.0-999-generic/kernel/drivers/scsi/pm8001/pm80xx.ko
/lib/modules/3.17.0-999-generic/kernel/drivers/scsi/pm8001/pm80xx.ko.bak
Copy
# cp /lib/modules/3.17.0-031700rc7-generic/extra/pm80xx.ko
/lib/modules/3.17.0-999-generic/extra/pm80xx.ko && depmod
# modprobe -v pm80xx
...
insmod /lib/modules/3.17.0-999-generic/extra/pm80xx.ko
# lsscsi -g
[0:0:0:0]    disk    ATA      OCZ-VERTEX       1.3   /dev/sda   /dev/sg0
[6:0:0:0]    enclosu HP       HP SAS EXP Card  2.10  -          /dev/sg1

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
