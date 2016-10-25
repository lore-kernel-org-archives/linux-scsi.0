From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121531] Adaptec 7805H SAS HBA (pm80xx): hangs when writing
 >80MB at once
Date: Tue, 25 Oct 2016 23:03:27 +0000
Message-ID: <bug-121531-11613-XxfnWRN8AA@https.bugzilla.kernel.org/>
References: <bug-121531-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754120AbcJYXDb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Oct 2016 19:03:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 18F9620117
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2016 23:03:30 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id EBE9620376
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2016 23:03:27 +0000 (UTC)
In-Reply-To: <bug-121531-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=121531

--- Comment #18 from Chloé Desoutter <chloe@tigres-rouges.net> ---
Actually further MicroSemi driver analysis lets me think that the proper,
recommended value is 256.

$ egrep '#define\s+MAX_[IO]B_QUEUE_ELEMENTS' *.h
pm8001_sas.h:#define    MAX_IB_QUEUE_ELEMENTS   256
pm8001_sas.h:#define    MAX_OB_QUEUE_ELEMENTS   256

so I shall test with this value for PM8001_MPI_QUEUE and see if I achieve real
stability with constant workloads.

-- 
You are receiving this mail because:
You are the assignee for the bug.