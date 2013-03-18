From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 53281] megaraid_mbox kernel panic during boot
Date: Mon, 18 Mar 2013 11:52:34 +0000 (UTC)
Message-ID: <20130318115234.243B311FB85@bugzilla.kernel.org>
References: <bug-53281-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:48697 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab3CRLwh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Mar 2013 07:52:37 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6D59120341
	for <linux-scsi@vger.kernel.org>; Mon, 18 Mar 2013 11:52:36 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 2BC2C20334
	for <linux-scsi@vger.kernel.org>; Mon, 18 Mar 2013 11:52:34 +0000 (UTC)
In-Reply-To: <bug-53281-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=53281


justgivemeafkenaccountplx@yahoo.co.uk changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |justgivemeafkenaccountplx@y
                   |                            |ahoo.co.uk




--- Comment #10 from justgivemeafkenaccountplx@yahoo.co.uk  2013-03-18 11:52:33 ---
I'm getting a very similar kernel dump on an LSI MegaRaid SATA 300-8X card.
(1000:0409) This card also uses the megaraid_mbox driver. Boots fine, but
crashes consistently when running badblocks -wsv over an array, usually within
an hour. Sometimes it will dump to console and flash the keyboard lights,
sometimes it just hangs.

Server is running nothing else at the moment beyond the basics, and the LSI
currently has no filesystems. I have no reason to suspect the card or the
server as both were running Win2003 server for the last 5 - 6 years without any
issues beyond the fact Windows was running on it :)

Ubuntu 12.04 i386 server, same results with Ubuntu kernel 3.5.0-25 and latest
compiled kernel 3.8.3. If there is any interest here I can post the kernel
dump, hardware details, etc. In a nutshell it's a single hyperthread P4 Xeon
2.4GHz on an Intel PCI-X server board with one jigglybyte of DDR1 ECC. LSI card
is running four 200GB SATA drives in a RAID5, configured with Write Through
caching and DirectIO, 128MB of cache, no backup battery.

I have tried various kernel flags to no avail but seemed to have some success
when I turned off all the performance enhancing settings in the LSI BIOS.
(Multiple PCI delayed transactions, command queuing, HDD write caching) It got
4 - 5 hours through badblocks without crashing but I stopped it as it was
taking forever. Could well have been just a result of decreased load though.
Turning hyperthread on/off makes no difference.

Currently testing various different settings in the LSI BIOS but it's slow
going. Any help would be appreciated here.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
