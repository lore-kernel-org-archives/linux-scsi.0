From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194837] VM with virtio-scsi drive often crashes during boot
 with kernel 4.11rc1
Date: Wed, 15 Mar 2017 07:07:32 +0000
Message-ID: <bug-194837-11613-eLnJ7AftCt@https.bugzilla.kernel.org/>
References: <bug-194837-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45586 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750820AbdCOHHi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 03:07:38 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id AA47428395
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 07:07:37 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D88AC28558
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 07:07:36 +0000 (UTC)
In-Reply-To: <bug-194837-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=194837

--- Comment #11 from Omar Sandoval (osandov@osandov.com) ---
The fix was
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=df23de55615fa7a190a85f49a950ccecdd9102f3,
which was part of this patch series:

c01228db4ba9 Revert "scsi, block: fix duplicate bdi name registration crashes"
90f16fddcc28 block: Make del_gendisk() safer for disks without queues
df23de55615f bdi: Fix use-after-free in wb_congested_put()
b6f8fec4448a block: Allow bdi re-registration

If you are still seeing crashes on -rc2, could you please report it to
linux-block@vger.kernel.org?

-- 
You are receiving this mail because:
You are the assignee for the bug.
