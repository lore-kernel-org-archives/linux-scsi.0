From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Mon, 3 May 2010 22:22:11 GMT
Message-ID: <201005032222.o43MMBdL025132@demeter.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58773 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758575Ab0ECWWN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2010 18:22:13 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o43MMC09025133
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 22:22:12 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831


Ryan Kuester <rkuester@kspace.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |rkuester@kspace.net




--- Comment #15 from Ryan Kuester <rkuester@kspace.net>  2010-05-03 22:22:06 ---
Take a look at my diagnosis here:
http://lkml.org/lkml/2010/4/26/335

It includes a rough-draft patch.  I'd be very interested in hearing reports of
whether this fixes this smartctl issue in others' environments as it has in
mine.

The reason I haven't proposed it as a real patch is that there's probably a
better location for that code.  Where I have it, it'll apply to every SCSI host
using the MPT Fusion framework, and if it's a hardware bug, perhaps we want it
to apply only to this specific LSI 1068 controller.

That said, I expect most requests hitting the device are already well-aligned,
so this wouldn't affect many requests even if it did apply to a
broader-than-necessary collection of hardware.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
