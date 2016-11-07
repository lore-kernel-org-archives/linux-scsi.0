From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187231] kernel panic during hpsa MSI plus tg3 MSI
Date: Mon, 07 Nov 2016 16:16:05 +0000
Message-ID: <bug-187231-11613-401cl4AVVt@https.bugzilla.kernel.org/>
References: <bug-187231-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753109AbcKGQQK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Nov 2016 11:16:10 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id F14082022A
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2016 16:16:08 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 1756F2025A
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2016 16:16:06 +0000 (UTC)
In-Reply-To: <bug-187231-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=187231

--- Comment #3 from Don <don.brace@microsemi.com> ---

(In reply to Patrick Schaaf from comment #2)
> Thanks Don for the reaction!
> 
> Right now, on the box that had that panic and the worst resetting/reset
> issues (see the other bug I linked), I'm back to 3.14.79, and want to stay
> there for another 24 to 36 hours, to see that this issue was not present
> with that kernel series.
> 
> What would your patch help with? Specifically the panic potential in case a
> logical device reset is ongoing? Or should it affect / remedy the mysterious
> (to me) "resetting logical" events in the first place?
> 
> I'm willing to test patches on that box starting Thursday, but I'd like to
> understand a bit better what we are dealing with here.

The specific issue that this patch addresses is that during a reset,
complete_scsi_command returns without having called scsi_done which causes the
OS to offline the disk (after two more occurrences). But this code path is not
often followed so the issue does not happen with all resets.

There are some other recent patches that should also be tested that have been
recently applied.

>From git format-patch:
0457-scsi-hpsa-Check-for-null-device-pointers.patch
    * This checks for a NULL device that can happen if the OS
      off-lines the disk because of the afore mentioned reset issue.
0460-scsi-hpsa-Check-for-null-devices-in-ioaccel-submissi.patch
0462-scsi-hpsa-correct-call-to-hpsa_do_reset.patch
    * Fine tunes resets into LOGICAL/Physical resets.

A patch I still have pending on linux-scsi
0464-hpsa-add-generate-controller-NMI-on-lockup.patch
    * This patch just adds more granularity on lock-up detection.

It would be nice to know why the reset is happening in the first place.

-- 
You are receiving this mail because:
You are the assignee for the bug.
