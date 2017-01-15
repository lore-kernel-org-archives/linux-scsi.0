From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151661] Adaptec 3405 3805 prints "AAC: Host adapter dead -1"
 every 10 seconds but works fine anyway
Date: Sun, 15 Jan 2017 11:10:11 +0000
Message-ID: <bug-151661-11613-KzYKnWrqsM@https.bugzilla.kernel.org/>
References: <bug-151661-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750824AbdAOLKQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 15 Jan 2017 06:10:16 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 8F204205B1
        for <linux-scsi@vger.kernel.org>; Sun, 15 Jan 2017 11:10:14 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 2B67C20584
        for <linux-scsi@vger.kernel.org>; Sun, 15 Jan 2017 11:10:13 +0000 (UTC)
In-Reply-To: <bug-151661-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151661

--- Comment #18 from Arkadiusz Miskiewicz <arekm@maven.pl> ---
The problem was introduced with commit below. Reverting this commit from kernel
4.9.3 makes the problem go away.

https://lkml.org/lkml/2017/1/15/47

commit 78cbccd3bd683c295a44af8050797dc4a41376ff
Author: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Date:   Mon Apr 25 23:32:37 2016 -0700

    aacraid: Fix for KDUMP driver hang

    When KDUMP is triggered the driver first talks to the firmware in INTX
    mode, but the adapter firmware is still in MSIX mode. Therefore the first
    driver command hangs since the driver is waiting for an INTX response and
    firmware gives a MSIX response. If when the OS is installed on a RAID
    drive created by the adapter KDUMP will hang since the driver does not
    receive a response in sync mode.

    Fixed by: Change the firmware to INTX mode if it is in MSIX mode before
    sending the first sync command.

    Cc: stable@vger.kernel.org
    Signed-off-by: Raghava Aditya Renukunta
<RaghavaAditya.Renukunta@microsemi.com>
    Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
