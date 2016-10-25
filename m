From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121531] Adaptec 7805H SAS HBA (pm80xx): hangs when writing
 >80MB at once
Date: Tue, 25 Oct 2016 23:11:00 +0000
Message-ID: <bug-121531-11613-7WiW4V16rh@https.bugzilla.kernel.org/>
References: <bug-121531-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752173AbcJYXLE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Oct 2016 19:11:04 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 0A10120380
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2016 23:11:03 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 0B8CA20377
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2016 23:11:01 +0000 (UTC)
In-Reply-To: <bug-121531-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=121531

--- Comment #19 from Chloé Desoutter <chloe@tigres-rouges.net> ---
Said parameter has been introduced by this commit.
99c72ebceb4dda445b4b74c6f46035feec95a2b3

The rationale is OK but the flaw is that sometimes the controller will crash
completely so there needs to be another way.

I suggest we set the PM8001_MPI_QUEUE to 256 and find another way to mitigate
these performance degradations because we cannot afford crashed SAS
controllers.

-- 
You are receiving this mail because:
You are the assignee for the bug.