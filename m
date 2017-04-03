From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195233] New: sd: discard_granularity set smaller than
 minimum_io_size when LBPRZ=1
Date: Mon, 03 Apr 2017 17:45:17 +0000
Message-ID: <bug-195233-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:57628 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751210AbdDCRp3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2017 13:45:29 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C24E328173
        for <linux-scsi@vger.kernel.org>; Mon,  3 Apr 2017 17:45:28 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 826B728173
        for <linux-scsi@vger.kernel.org>; Mon,  3 Apr 2017 17:45:28 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=195233

            Bug ID: 195233
           Summary: sd: discard_granularity set smaller than
                    minimum_io_size when LBPRZ=1
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.4.0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: dbuckley@oreilly.com
        Regression: No

Between 3.10 and 4.4 kernels this patch:
https://patchwork.kernel.org/patch/6995131/ was merged to ensure
discard_granularity is set to logical_block_size when a disk reports LBPRZ=1. 
In a case where a disk reports LBPRZ=1 with a 512 logical_block_size and 4096
physical_block_size and minimum_io_size, this results in discard_granularity
incorrectly being set to 512 which at least in my case results in discard
requests being ignored.

I believe the easiest fix would be changing:

        if (sdkp->lbprz) {
                q->limits.discard_alignment = 0;
                q->limits.discard_granularity = logical_block_size;
        } else {

to:

        if (sdkp->lbprz) {
                q->limits.discard_alignment = 0;
                q->limits.discard_granularity = max(logical_block_size,
minimum_io_size);
        } else {

but any change which results in discard_granularity being set properly would
solve this.

I have verified that with a 3.10 kernel discard_granularity is set to 4096 and
works as expected, but with 4.4 it is set to 512 and does not work. 

This is a fairly severe bug for my use case, as I rely on discard to free
unused blocks from the storage backing LUNs mounted by Linux clients and this
effectively makes critical functions like thin-provisioning and snapshots
infeasible for 4.x clients. 

I have only tested this with the Ubuntu-packaged kernels, but the problematic
code still is present in the current source.  I'm happy to provide any
additional information that might be helpful.

-- 
You are receiving this mail because:
You are the assignee for the bug.
