From: Pat LaVarre <p.lavarre@ieee.org>
Subject: ide-scsi emulation hangs the kernel?
Date: 10 Dec 2003 16:36:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1071099386.28943.45.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:30437 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264260AbTLJXgp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Dec 2003 18:36:45 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 4C3891CD7
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2003 16:36:45 -0700 (MST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> Could anybody please tell me what's wrong with
> the ide-scsi emulation in 2.4.21?

This question I'm too ignorant to answer.

Google linux-scsi tells me lk 2.6 deprecates ide-scsi in favour of
ide-cd, not that lk 2.4 drops support for ide-scsi.

> I have a cd-rw drive as a hdd, it works fine
> but the system (redhat9) suddenly freezes at
> any time with the following messages:

I'm writing because these messages do make some kind of sense to Me,
after having studied some of http://www.t13.org/ over the years.

Below you can see I conclude: "the host gave up entirely, declaring this
device broken".  Without more info I cannot know whether we should try
to fix the host and/or device and/or disc.

Please understand, I know nearly zero of lk, just enough of t13.org
ATA/PI to guess what these messages mean without being sure my guesses
are correct.

---

SCSI, including SCSI over IDE also known as ATAPI, works by the host and
the device taking turns to speak.

> Dec  8 01:11:14 localhost kernel: scsi : aborting command due to timeout : pid 22251, scsi0, channel 0, id 0, lun 0 Request Sense 00 00 00 40 00

"Timeout" often means the host lost patience while waiting for the
device to yield its turn to speak.

> Dec  8 01:11:14 localhost kernel: hdd: lost interrupt

Linux "hdd" often means the ID 1 "slave" device of the "secondary" IDE
bus.

Often the way an ATA/PI device yields its turn to speak is to interrupt
the host.  "Lost interrupt" could be a restatement of the "timeout"
idea, that 

> Dec  8 01:11:14 localhost kernel: ide-scsi: CoD != 0 in idescsi_pc_intr

ATA/PI sequences thru four states: x01 Command Out, x00 Data Out, x02
Data In, x03 Status In.

"CoD" may refer to that x 01 00 02 03 encoding.

> Dec  8 01:11:14 localhost kernel: hdd: DMA disabled

The port x1F2 SectorCount/InterruptReason mask x03
+Command/-Data:+In/-Out bits have no meaning unless DMA is disabled (in
favour of PIO).  The so-called "port x1F2" traditionally appeared as x86
i/o port address x1F2, also x172, etc.

> Dec  8 01:11:14 localhost kernel: hdd: ATAPI reset complete
> Dec  8 01:11:14 localhost kernel: hdd: irq timeout: status=0x80 { Busy }

Automagic reset may be how this host choose to recover from its own loss
of patience.

In IDE PIO, ports x1F7/3F6 Status/AlternateStatus mask x88 BSY:DRQ
simulate a shared memory semaphore, in which the value x00 means host
talks, x08 means host copies data, and either of x80 or x88 means the
device talks and the host has to wait.  Here we have x80 i.e. host
waiting, again consistent with the theory that our host lost patience.

> Dec  8 01:11:14 localhost kernel: hdd: ATAPI reset complete
> Dec  8 01:11:14 localhost kernel: hdd: irq timeout: status=0x80 { Busy }

This looks like a retry of a reset - this host is more passionately
losing patience.

> Dec  8 01:11:14 localhost kernel: hdd: ATAPI reset complete

This looks like the host gave up entirely, declaring this device broken.

---

Pat LaVarre


