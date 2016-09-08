From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 156321] New: mpt3sas timeout with xen, works only with
 mpt3sas.msix_disable=1 (SAS3008 card)
Date: Thu, 08 Sep 2016 07:39:17 +0000
Message-ID: <bug-156321-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752396AbcIHHjV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Sep 2016 03:39:21 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 73E0C20256
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2016 07:39:19 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 8E06720221
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2016 07:39:17 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=156321

            Bug ID: 156321
           Summary: mpt3sas timeout with xen, works only with
                    mpt3sas.msix_disable=1 (SAS3008 card)
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.6.0-1-amd64 (debian-kernel@lists.debian.org)
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: john.wyzer@gmx.de
        Regression: No

At the moment I've only tested the kernel version cited above. The hardware in
question is a SAS3008 card.

When I start the the machine without loading Xen, the mpt3sas driver works just
fine. 
When Xen is loaded, different timeouts occur during I/O.

For simplicity I'm citing the trace from
https://www-947.ibm.com/support/entry/portal/docdisplay?lndocid=migr-5099120 :

[Â Â 618.160182] mpt3sas0: _base_event_notification
[Â Â 648.160097] mpt3sas0: _base_event_notification: timeout
[Â Â 648.160103] mf:
07000000 00000000 00000000 00000000 00000000 0f2f7fff ffffff7c ffffffff
ffffffff 00000000 00000000
[Â Â 648.160117] mpt3sas0: mpt3sas_base_free_resources
[Â Â 648.160122] mpt3sas0: _base_make_ioc_ready
[Â Â 648.160125] mpt3sas0: sending message unit reset !!
[Â Â 648.168091] mpt3sas0: message unit reset: SUCCESS
[Â Â 648.168098] mpt3sas0: mpt3sas_base_unmap_resources
[Â Â 648.169040] mpt3sas0: _base_release_memory_pools
[Â Â 648.170854] mpt3sas0: request_pool(0xffff8800eae00000): free
[Â Â 648.171770] mpt3sas0: sense_pool(0xffff8800f8400000): free
[Â Â 648.173718] mpt3sas0: reply_pool(0xffff8801bba00000): free
[Â Â 648.173786] mpt3sas0: reply_free_pool(0xffff8800eeeb0000): free
[Â Â 648.173789] mpt3sas0: reply_post_free_pool(0xffff8800f9400000): free
[Â Â 648.173792] mpt3sas0: reply_post_free_pool(0xffff8801bb900000): free
[Â Â 648.176634] mpt3sas0: config_page(0xffff8801cc620000): free
[Â Â 649.490617] mpt3sas0: failure at mpt3sas_scsih.c:11439/_scsih_probe()!

I don't know if the trace is exactly the same but I remember the
"base_event_notification: timeout".

As the bug report on ibm.com cited above mentions, booting with
mpt3sas.msix_disable=1 solves the problem for the time being.

https://forums.servethehome.com/index.php?threads/lsi9211-8i-on-ubuntu-15-10-timeouts.8820/page-2
mentions the same problem in connection with Vmware ESXi.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.