From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121531] Adaptec 7805H SAS HBA (pm80xx): hangs when writing
 >80MB at once
Date: Tue, 25 Oct 2016 15:20:05 +0000
Message-ID: <bug-121531-11613-Lsc3ea2R4G@https.bugzilla.kernel.org/>
References: <bug-121531-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751302AbcJYPUK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Oct 2016 11:20:10 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 6DE1720218
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2016 15:20:08 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 8005A2025A
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2016 15:20:05 +0000 (UTC)
In-Reply-To: <bug-121531-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=121531

Chloé Desoutter <chloe@tigres-rouges.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |chloe@tigres-rouges.net

--- Comment #16 from Chloé Desoutter <chloe@tigres-rouges.net> ---
Hello,

I'm a victim of the bug and this impaired heavily the use of this controller on
my filer when I wrote data constantly on it. After a few hours it would freeze
without possible recovery.
I've been researching the cause of this bug by comparing the source trees of
Microsemi and what's in the kernel.

The SCSI queue depth is not at stake, as changing it did not fix the issue. In
the  microsemi driver it is at 128, in the kernel tree it's at 508 but this
changes nothing in the end (except I noticed a slight performance loss when set
at 128).

However the MPI queue parameter is set way higher in the kernel tree than in
the Microsemi tree.

In the Microsemi tree this is managed by the MAX_IB_QUEUE_ELEMENTS and
MAX_OB_QUEUE_ELEMENTS defines. The events queue seems to be split evenly
between reads and writes. The total queue length is 512. There is an equal
number of inbound and outbound queues there.

In the kernel tree, this is handled by the PM8001_MPI_QUEUE define (value:
1024). There is 1 inbound queue and 4 outbound queues.

I noticed that the value PM8001_MPI_QUEUE = 1024 causes crashes of the driver
on a "PMC-Sierra PM8001 SAS HBA" as reported earlier. Changing this value to
512 results in a much more stable driver. I guess setting the MPI queue to
something too important results in instructions being lost when too much data
gets queued and the controller cannot keep up with the writes.

I will attach the following patch.

--- linux/drivers/scsi/pm8001/pm8001_defs.h.orig    2016-10-25
15:15:40.470112331 +0000
+++ linux/drivers/scsi/pm8001/pm8001_defs.h    2016-10-24 19:13:46.533108727
+0000
@@ -76,7 +76,7 @@ enum port_type {

 /* driver compile-time configuration */
 #define    PM8001_MAX_CCB         512    /* max ccbs supported */
-#define PM8001_MPI_QUEUE         1024   /* maximum mpi queue entries */
+#define PM8001_MPI_QUEUE         512   /* maximum mpi queue entries */
 #define    PM8001_MAX_INB_NUM     1
 #define    PM8001_MAX_OUTB_NUM     1
 #define    PM8001_MAX_SPCV_INB_NUM        1

-- 
You are receiving this mail because:
You are the assignee for the bug.