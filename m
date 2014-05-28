From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76681] Adaptec 7805H SAS HBA (pm80xx) cannot survive ACPI S3 or
 ACPI S4
Date: Wed, 28 May 2014 20:10:15 +0000
Message-ID: <bug-76681-11613-M0E5Vg91Ds@https.bugzilla.kernel.org/>
References: <bug-76681-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38426 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251AbaE1UKS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2014 16:10:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A711D20306
	for <linux-scsi@vger.kernel.org>; Wed, 28 May 2014 20:10:17 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B5C9020304
	for <linux-scsi@vger.kernel.org>; Wed, 28 May 2014 20:10:16 +0000 (UTC)
In-Reply-To: <bug-76681-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=76681

Bradley Grove <bgrove@attotech.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bgrove@attotech.com

--- Comment #2 from Bradley Grove <bgrove@attotech.com> ---
We've hit the same issue when using the pm80xx driver with our PM8001 based
card.   After applying Jack's patch we encountered another issue.  When
powering up after hibernation, the driver receives a MPI event,
HW_EVENT_PHY_START_STATUS.   The handler for this tries to signal an
uninitialized completion.   I've been able to work around this by setting the
HBA struct flags to PM8001F_INIT_TIME until restore() completes.

-- 
You are receiving this mail because:
You are the assignee for the bug.
