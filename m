Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF982C433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 08:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF4BC20657
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 08:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbgGOIpB convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 04:45:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729377AbgGOIpB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Jul 2020 04:45:01 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 207855] arcconf host reset causes kernel panic -> driver crash?
Date:   Wed, 15 Jul 2020 08:45:00 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: janpieter.sollie@edpnet.be
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-207855-11613-8mf35y1REE@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207855-11613@https.bugzilla.kernel.org/>
References: <bug-207855-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207855

--- Comment #11 from Janpieter Sollie (janpieter.sollie@edpnet.be) ---
the issue seems to be related to:

> [59502.794967] Call Trace:
> [59502.794967]  _raw_spin_lock_irqsave+0x20/0x30
> [59502.794968]  __scsi_iterate_devices+0x22/0x80
> [59502.794968]  scsi_eh_ready_devs+0x129/0x7c0
> [59502.794968]  ? __pm_runtime_resume+0x54/0x70
> [59502.794968]  scsi_error_handler+0x394/0x3a0
> [59502.794969]  kthread+0xf3/0x130
> [59502.794969]  ? scsi_eh_get_sense+0x120/0x120
> [59502.794969]  ? kthread_park+0x80/0x80
> [59502.794970]  ret_from_fork+0x1f/0x30

As far as I see, this stack blocks the entire scsi subsystem.
I do not see why: the scsi_error_handler runs in a separate kthread, so it
*should* not block the IO subsystem ... but it definitely does: all storage
devices on all SAS/SATA controllers (even USB) become inaccessible.  I managed
to get a dmesg out of it, but "echo 1 >
/sys/class/pci_bus/0000\:04/device/reset"
never completed.  this command was issued over a running SSH session.  A new
session could not be established any longer.  But it proves the PCI subsystem
is partially intact.

is it possible the raw_spin_lock_irqsave hurts when the adapter is not ready
yet? and as such locks a device but never completes?

-- 
You are receiving this mail because:
You are the assignee for the bug.
