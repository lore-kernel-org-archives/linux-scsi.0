From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z: dev
 error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Fri, 22 Aug 2014 12:13:42 +0000
Message-ID: <bug-81861-11613-rcxSV8ODsY@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50343 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbaHVMNq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2014 08:13:46 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 11B082017A
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2014 12:13:45 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 9B6772018E
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2014 12:13:42 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

--- Comment #6 from linux-ide@crashplan.pro ---
When connecting just a single 4 drive group to the good ports (for example 2C)
of the external PCIe expander card:
cold boot = doesn't detect any of the 4 PUIS drives
warm boot = does detect all 4 PUIS drives

When powering up using the warm boot method there don't seem to be errors
reported by smartctl neither sg_ses.

However this cold boot issue might be a different issue from this kernel crash.
According to debug messages first a "Set Features" (0xEF) is being sent. My
guess is that this set features issues subcommand (0x07): spin up media.

And later on the "Identify Device" (0xEC) is sent.


When I correctly read the Hitachi specification the Spin Up (Set Features)
should be sent after "Drive Identify". For this Hitachi HDS5C3020BLE630 the
Drive_Identify (# sg_sat_identify -v /dev/sdb) word 2 outputs "738c" (hex),
which translates to specification "Need Set Feature for spin-up after power-up
Identify Device is complete" according to HGST specification page 127.

Is there a boot parameter (or similar way) to load the mvsas driver without
sending the "Set Features" (0xEF) command?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
