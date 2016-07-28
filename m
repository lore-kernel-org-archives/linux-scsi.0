From: Stig <thatsafunnyname@gmail.com>
Subject: Diagnosing interrupt problem seen with PERC H710P Mini firmware
 21.3.1-0004 or 21.3.2-0005
Date: Thu, 28 Jul 2016 22:25:48 +0100
Message-ID: <CAD9POpLu0n36dbELZCnGT-8ru4TMrXRasH8Xa_UHKGdb9Cr6Ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36806 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758511AbcG1VZu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2016 17:25:50 -0400
Received: by mail-oi0-f54.google.com with SMTP id w18so81281075oiw.3
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2016 14:25:49 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,
  I hope it is OK to post this.  I have been investigating a problem
seen on Dell R720(xd) hosts with PERC H710P Mini firmware 21.3.1-0004
or 21.3.2-0005, running RHEL 6.6 and 6.7.  Interrupts are only seen on
the first interrupt.  The details are in
https://bugzilla.redhat.com/show_bug.cgi?id=1361333 , I would
appreciate any help in isolating the problem behaviour (I plan to see
if we can downgrade the firmware as the next step), or if the bug is
already known.  Ruling out a problem with the megaraid driver and
being able to demonstrate a problem with the firmware would help me
when opening a support request with the hardware/firmware vendor.
  Thanks,
Peter (Stig) Edwards

Extract from https://bugzilla.redhat.com/show_bug.cgi?id=1361333

Description of problem:

Interrupts for "IR-PCI-MSI-edge megasas" are only being seen (for some
hosts) on one of the interrupts (the first).  irqbalance will mask the
interrupt to a CPU and so we see a single CPU can be saturated
handling interrupts under a heavy IO load.

Seen on these RHEL releases:
  RHEL6.6 2.6.32-573.12.1.el6.x86_64
  RHEL6.7 2.6.32-642.3.1.el6.x86_64

Seen on a few hosts, Dell Poweredge R720 and R720xd with one or two
E5-2630 v2 or a single E5-2680 0.  Seen on Dell BIOS 2.2.2, 2.4.3,
2.5.2 and 2.5.4.  Seen (and not seen) on hosts with identical BIOS and
firmware versions, and identical ACPI tables, identical (basic) BIOS
exposed by dmidecode and omreport.  Seen when there are 16 vCPUs,
24vCPUs online.  Seen when there are 48 possible CPUs.  Seen when
using irqbalance-1.0.7-8.el6 and with previous versions (where
interrupt would be limit to first vCPU on a NUMA node).  Controller is
PERC H710P Mini (Embedded), seen on firmware 21.3.1-0004, 21.3.2-0005
and driver version 06.806.08.00-rh3, 06.810.09.00-rh1, not seen on
firmware 21.2.0-0007

Version-Release number of selected component (if applicable):

So far the common items are:
  .) RHEL6.7 or RHEL6.6
  .) Dell R720 or R720xd
  .) 48 possible CPUs
  .) Dell BIOS version 2.2.2 or greater

Every host with the problem has:
  .) PERC H710P Mini (Embedded) firmware 21.3.1-0004 or 21.3.2-0005
