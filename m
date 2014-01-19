From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Sun, 19 Jan 2014 12:17:55 +0000
Message-ID: <bug-60644-11613-cbR4a4lwrE@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39758 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbaASMSA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jan 2014 07:18:00 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A836D2013D
	for <linux-scsi@vger.kernel.org>; Sun, 19 Jan 2014 12:17:59 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 9F04B2013A
	for <linux-scsi@vger.kernel.org>; Sun, 19 Jan 2014 12:17:56 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #43 from Konstantin <ktrackfd@gmail.com> ---
Hello all,

enabling "Above 4G encoding" in the bios did not help in my case.

I enabled PERR and SERR as well. PCIe ASPM is forced on by the bios and the
kernel.

When I scrub my zpool, the system locks up. This time at 7.13% progress. After
a reset the scrubbing continues and sometimes the locks up a second time.

So in general I get 1-2 lockups during a scrub, but it always finishes the
scrub without errors (ofc when the disks drop out the zfs scrubbing mentions
errors).

Hardware:

Case: Inter-Tech 4HU-4324L
Board: Supermicro X9SCM-F
CPU: Intel Xeon E3-1230 V2
RAM: 2x8GB ECC ( Samsung M391B1G73BH0-CH9 )
HBA: IBM ServeRAID M1015 ( IT mode, FW version 17 )
Disks: 10x 3TB WD Green ( WD30EZRX ) and 1x 3TB Hitachi ( HDS5C303 )

Software:

- Gentoo hardened, kernel 3.12.6-hardened-r4 (other kernel version failing,
too)
- All the disks luks encrypted
- A pool "rpool" for the system on a ssd
- A pool "tank" for the data on a raidz3

I have attached "zpool status" and dmesg logs (see posts above).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
