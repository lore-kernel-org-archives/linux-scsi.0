From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12164] cciss driver hangs on boot
Date: Fri,  5 Dec 2008 01:15:47 -0800 (PST)
Message-ID: <20081205091547.6E6F810800F@picon.linux-foundation.org>
References: <bug-12164-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922AbYLEJPt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 04:15:49 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mB59Fl7R001974
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2008 01:15:48 -0800
In-Reply-To: <bug-12164-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12164





------- Comment #1 from rich@hq.vsaa.lv  2008-12-05 01:15 -------
lspci -v -s 00:04.0

00:04.0 RAID bus controller: Compaq Computer Corporation Smart Array 5i/532
(rev 01)
        Subsystem: Compaq Computer Corporation Smart Array 5i
        Flags: bus master, 66MHz, medium devsel, latency 71, IRQ 3
        Memory at f5f80000 (64-bit, non-prefetchable) [size=256K]
        I/O ports at 2800 [size=256]
        Memory at f5df0000 (64-bit, prefetchable) [size=16K]
        Expansion ROM at <unassigned> [disabled] [size=16K]
        Capabilities: [c0] Power Management version 2
        Capabilities: [cc] Message Signalled Interrupts: 64bit+ Queue=0/1
Enable-
        Capabilities: [dc] PCI-X non-bridge device


grepping changelogs for cciss shows the following changes in kernel versions
that could potentially break this :

ChangeLog-2.4.26:  o cciss update: support the new MSA30 storage enclosure
ChangeLog-2.4.26:  o cciss update: If no device attached we return -ENXIO
instead of some bogus numbers
ChangeLog-2.4.27:  o cciss update
ChangeLog-2.4.27:  o cciss update: support for two new controllers
ChangeLog-2.4.27:  o Fix cciss bug in proc reporting
ChangeLog-2.4.28:  o Mike Miller: cciss typo fix
ChangeLog-2.4.28:  o cpqarray/cciss gcc3.4 inline fixes
ChangeLog-2.4.28:  o cciss update [1/5] PCI ID fix for cciss SATA hba
ChangeLog-2.4.28:  o cciss update [2/5] fix for 32/64-bit conversions
ChangeLog-2.4.28:  o cciss update [3/5] pci_dev->irq fix
ChangeLog-2.4.28:  o cciss update [4/5] fix for HP utilities
ChangeLog-2.4.28:  o cciss update [5/5] maintainers update for HP drivers


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
