From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11194] megaraid_mbox kernel panic during st driver initialization
Date: Sun, 31 Aug 2008 22:37:31 -0700 (PDT)
Message-ID: <20080901053731.282F010805B@picon.linux-foundation.org>
References: <bug-11194-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840AbYIAFiD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Sep 2008 01:38:03 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m815bV3g030348
	for <linux-scsi@vger.kernel.org>; Sun, 31 Aug 2008 22:37:32 -0700
In-Reply-To: <bug-11194-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11194


cshore@fionavar.ca changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |cshore@fionavar.ca




------- Comment #5 from cshore@fionavar.ca  2008-08-31 22:37 -------
Using a second adaptor card and moving the non-RAID devices off the megaraid
controller solved the panic.  It appears the problem is the non-RAID devices
and may be related the the bug for which there is a patch for newer CERC
firmware (sorry don't have the post url, it was on this list) which deals with
an error in the way the devices are enumerated.

This controller is a Dell PERC3/DCL and has the following BIOS/firmware
revision info:

on boot screen BIOS is listed as 3.35 May 7,2004
Standard Firmware is listed as 199D

in the setup screen, it shows
PERC/CERC BIOS Configuration Utility U827

lspci -vvv gives:

04:00.0 RAID bus controller: American Megatrends Inc. MegaRAID (rev 20)
        Subsystem: Dell Device 0493
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at e0000000 (32-bit, prefetchable) [size=64M]
        [virtual] Expansion ROM at dff00000 [disabled] [size=64K]
        Capabilities: <access denied>
        Kernel driver in use: megaraid
        Kernel modules: megaraid_mbox


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
