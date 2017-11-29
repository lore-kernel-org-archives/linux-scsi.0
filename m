From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197875] Processes hang on attempted access of WDC WD30-EZRX 3TB
 HDD on HP Z420 Workstation
Date: Wed, 29 Nov 2017 16:36:47 +0000
Message-ID: <bug-197875-11613-JJxgs57LuM@https.bugzilla.kernel.org/>
References: <bug-197875-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60538 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753210AbdK2Qgs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Nov 2017 11:36:48 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id CBD1729B51
        for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2017 16:36:47 +0000 (UTC)
In-Reply-To: <bug-197875-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=197875

--- Comment #5 from Bart Van Assche (bvanassche@acm.org) ---
So command processing got stuck. Since there are two code paths in recent
kernels we need to know whether or not scsi-mq was used. Hence please provide
the output of the following command:

for d in /sys/block/*; do sfx=""; [ -e "$d/mq" ] && sfx=" [mq]"; echo "$d$sfx";
done

If the above command reports that scsi-mq is being used for the WDC disk,
please check whether the following command resolves the lockup:

for d in /sys/kernel/debug/block/*/state; do echo kick >$d; done

-- 
You are receiving this mail because:
You are the assignee for the bug.
