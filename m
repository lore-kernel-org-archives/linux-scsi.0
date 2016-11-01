From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121531] Adaptec 7805H SAS HBA (pm80xx): hangs when writing
 >80MB at once
Date: Tue, 01 Nov 2016 22:09:06 +0000
Message-ID: <bug-121531-11613-0lkF8iVFX7@https.bugzilla.kernel.org/>
References: <bug-121531-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbcKAWJK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Nov 2016 18:09:10 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 4DFDA20411
        for <linux-scsi@vger.kernel.org>; Tue,  1 Nov 2016 22:09:09 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 3AE00203C4
        for <linux-scsi@vger.kernel.org>; Tue,  1 Nov 2016 22:09:07 +0000 (UTC)
In-Reply-To: <bug-121531-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=121531

--- Comment #23 from Chloé Desoutter <chloe@tigres-rouges.net> ---
I can trigger crashes after a long while in a heavy workload, quite randomly,
with 256.

Out of curiosity I checked the pmspcv driver from FreeBSD and they use a lower
value still :


#define MPI_MAX_INBOUND_QUEUES          64     /**< Maximum number of inbound
queues */
#define MPI_MAX_OUTBOUND_QUEUES         64     /**< Maximum number of outbound
queues */

                                               /**< Max # of memory chunks
supported */
#define MPI_MAX_MEM_REGIONS             (MPI_MAX_INBOUND_QUEUES +
MPI_MAX_OUTBOUND_QUEUES) + 4
#define MPI_LOGSIZE                     4096  /**< default size */

so I'll try with this value and give feedback for stability and performance.

-- 
You are receiving this mail because:
You are the assignee for the bug.