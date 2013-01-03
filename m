From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51881] HighPoint RocketRAID 2720 fail to detect some SATA hdd
Date: Thu,  3 Jan 2013 15:57:37 +0000 (UTC)
Message-ID: <20130103155737.900EF11FE9B@bugzilla.kernel.org>
References: <bug-51881-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39518 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261Ab3ACP5l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jan 2013 10:57:41 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E75E0203C1
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jan 2013 15:57:39 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id D74D6203AC
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jan 2013 15:57:37 +0000 (UTC)
In-Reply-To: <bug-51881-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=51881


Kalin KOZHUHAROV <kalin@thinrope.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kalin@thinrope.net




--- Comment #8 from Kalin KOZHUHAROV <kalin@thinrope.net>  2013-01-03 15:57:37 ---
Happy New Year!
Glad I found this bug before starting to dissect, it fixed my OCZ-REVODRIVE3
X2!

I have 960GB PCIe OCZ-REVODRIVE3 X2 that also uses mvsas and was working fine
with 3.6.9, but started failing with 3.7.1 (internally it is 4x SandForce 2281)
with only two of the four drives being detected. This was in dmesg:

$ grep "\] ata[91]" 3.7.1-pf-r6-a.dmesg 
[    0.807680] ata1: DUMMY
[    9.006504] ata9.00: ATA-8: OCZ-REVODRIVE3 X2, 2.22, max UDMA/133
[    9.006510] ata9.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    9.006996] ata9.00: failed to get Identify Device Data, Emask 0x1
[    9.014874] ata9.00: failed to get Identify Device Data, Emask 0x1
[    9.014883] ata9.00: configured for UDMA/133
[    9.190157] ata10.00: both IDENTIFYs aborted, assuming NODEV
[    9.363328] ata11.00: ATA-8: OCZ-REVODRIVE3 X2, 2.22, max UDMA/133
[    9.363334] ata11.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    9.363860] ata11.00: failed to get Identify Device Data, Emask 0x1
[    9.373757] ata11.00: failed to get Identify Device Data, Emask 0x1
[    9.373765] ata11.00: configured for UDMA/133
[    9.546921] ata12.00: both IDENTIFYs aborted, assuming NODEV

I applied the above patch (id=89551) to 3.7.1 and it started working again. I
hope it can be merged in 3.8.

Let me know if any more testing is needed.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
