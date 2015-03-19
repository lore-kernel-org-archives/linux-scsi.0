From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 95101] scsi/mpt2sas: setpci reset results in kernel oops
Date: Thu, 19 Mar 2015 21:46:04 +0000
Message-ID: <bug-95101-11613-GkCRa2fRHA@https.bugzilla.kernel.org/>
References: <bug-95101-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34760 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbbCSVqH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Mar 2015 17:46:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 73ACB20522
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2015 21:46:06 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D0F7820525
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2015 21:46:04 +0000 (UTC)
In-Reply-To: <bug-95101-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=95101

Joe Lawrence <joe.lawrence@stratus.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |joe.lawrence@stratus.com

--- Comment #1 from Joe Lawrence <joe.lawrence@stratus.com> ---
>From the /var/log/messages attachment:

Mar 16 01:13:10 RHEL63 kernel: mpt2sas1: _base_fault_reset_work: Running
mpt2sas_dead_ioc thread success !!!!
...
Mar 16 01:13:20 RHEL63 kernel: mpt2sas1: _scsih_ir_shutdown: timeout
Mar 16 01:13:20 RHEL63 kernel: mpt2sas1: removing handle(0x0024),
wwid(0x0c4e8a1c03a9b742)

indicates that _scsih_remove was called when the driver's watchdog detected
that the device was misbehaving.  Driver device removal invokes:

mpt2sas_base_detach
  mpt2sas_base_free_resources
    iounmap(ioc->chip)

setting the stage for the crash:

Mar 16 01:13:37 RHEL63 kernel: BUG: unable to handle kernel paging request at
ffffc900171e0000                             
Mar 16 01:13:37 RHEL63 kernel: IP: [<ffffffffa00502e0>]
mpt2sas_base_get_iocstate+0x10/0x30 [mpt2sas]
...
Mar 16 01:13:37 RHEL63 kernel: RAX: ffffc900171e0000 RBX: ffff88105a0aa788 RCX:
0000000000004fdc

where mpt2sas_base_get_iocstate was probably calling
readl(&ioc->chip->Doorbell)

So it would seem that the mpt2sas ioctl code (step 5, I think) isn't
synchronized against device removal.

-- 
You are receiving this mail because:
You are on the CC list for the bug.
