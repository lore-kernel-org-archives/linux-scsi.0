From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11529] aacraid - WARNING: at lib/scatterlist.c
Date: Wed, 10 Sep 2008 02:01:40 -0700 (PDT)
Message-ID: <20080910090140.23D0B11D108@picon.linux-foundation.org>
References: <bug-11529-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865AbYIJJBm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2008 05:01:42 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8A91etM004440
	for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2008 02:01:41 -0700
In-Reply-To: <bug-11529-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11529





------- Comment #1 from anonymous@kernel-bugs.osdl.org  2008-09-10 02:01 -------
Reply-To: fujita.tomonori@lab.ntt.co.jp

On Wed, 10 Sep 2008 01:07:50 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11529
> 
>            Summary: aacraid - WARNING: at lib/scatterlist.c
>            Product: SCSI Drivers
>            Version: 2.5
>      KernelVersion: 2.6.26.5
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: AACRAID
>         AssignedTo: scsi_drivers-aacraid@kernel-bugs.osdl.org
>         ReportedBy: winfried@tilanus.com
> 
> 
> Latest working kernel version: 2.6.25.17
> Earliest failing kernel version: 2.6.26
> Distribution: Debian 
> Hardware Environment: Intel 686
> Problem Description:
> 
> During boot I see 16 warnings about scatterlist.c, right after the 
> initiantion of aacraid (Using a Adeptec AAR-2410SA raid card). Boot 
> seems to proceed normally. After the boot I don't see these messages 
> anymore:
> 
> [    5.640780] AAC0: kernel 4.2-0[8205] Aug 17 2005
> [    5.640780] AAC0: monitor 4.2-0[8205]
> [    5.640780] AAC0: bios 4.2-0[8205]
> [    5.640780] AAC0: serial C92A77
> [    5.640781] scsi2 : aacraid
> [    5.641921] ------------[ cut here ]------------
> [    5.641924] WARNING: at lib/scatterlist.c:316 sg_copy_buffer+0x2e/0x14f()
> [    5.641926] Modules linked in: pata_marvell(+) ata_piix(+) ohci1394(+)
> libata ieee1394 aacraid scsi_mod dock ehci_hcd uhci_hcd usbcore e1000e thermal
> processor fan thermal_sys

Sorry about the bug.

I thought that this function was called with local interrupts disabled
since in 2.6.25 this uses KM_IRQ0 without disabling local
interrupts...

This fix needs to go to scsi-rc-fixes.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] aacraid: disable local interrupts before scsi_sg_copy APIs

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: stable@kernel.org
---
 drivers/scsi/aacraid/aachba.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index aa4e77c..8e60d06 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -404,13 +404,16 @@ static void get_container_name_callback(void *context,
struct fib * fibptr)
                        char d[sizeof(((struct inquiry_data
*)NULL)->inqd_pid)];
                        int count = sizeof(d);
                        char *dp = d;
+                       unsigned long flags;
                        do {
                                *dp++ = (*sp) ? *sp++ : ' ';
                        } while (--count > 0);

+                       local_irq_save(flags);
                        scsi_sg_copy_to_buffer(scsicmd, &inq, sizeof(inq));
                        memcpy(inq.inqd_pid, d, sizeof(d));
                        scsi_sg_copy_from_buffer(scsicmd, &inq, sizeof(inq));
+                       local_irq_restore(flags);
                }
        }



-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
