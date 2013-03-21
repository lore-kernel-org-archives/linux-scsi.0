From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 0/3] PCI: Handle device quirks when accessing sysfs
	resource<N> entries
Date: Wed, 20 Mar 2013 22:34:49 -0600
Message-ID: <20130321043449.7229.81056.stgit@amt.stowe>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab3CUEe4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Mar 2013 00:34:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, yuxiangl@marvell.com, yxlraid@gmail.com, greg@kroah.com, alex.williamson@redhat.com, kay@vrfy.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Xiangliang reported that a platform hangs after "udevadm info
--attribute-walk --path=/sys/devices/pci0000:00/<...>/block/sda" is ran.
He was then able to isolate the failure further to accesses involving a
Marvell 9125 device's I/O BARs, or more specifically, accesses to I/O Port
space backing the device's I/O Port BARs.  Putting these two pieces of
information together he was able to reproduce the hang by targeting the
device's pci-sysfs 'resource<N>' entries, where N represents an I/O Port
Bar, via "cat /sys/devices/<...>/resource<N>" [1].

There are basically two issues at play here: pci-sysfs entries backing I/O
Port BARs, which directly map to the device's control and status
registers, being able to be accessed by userspace - which commit 8633328
introduced as part of adding virtualization based device assignment
functionality - and, abnormally strict access restrictions with respect to
the Marvell 9125 device's I/O Port region(s).

I proposed a patch to circumvent "udevadm info ..." from accessing these
specific pci-sysfs entries which started an interesting conversation [2].
While there were numerous issues brought up they basically filtered down to
whether or not it is possible to safely have userspace access device
registers and, if it is, how do we ensure that two or more entities can't
access a device simultaneously (see Don Dutile's quick summary as it most
succulently expressed the complexity of the situation we currently find
ourselves in).

There are plans for VFIO to replace the sysfs based accessing method,
moving device register accesses behind ioctls, but for now legacy KVM
device assignment relies on these files.


This patch series is a possible compromise to the immediate issue; a
quirking mechanism that can be used to detect accesses that do no meet the
device's restrictions, letting a device specific method intervene and
decide how to progress.

If consensus is reached that it is just too unsafe to allow userspace
access to device registers, then the series may serve as a stop gap
solution, addressing the symptom and not the underlying issue, until VFIO
materializes at which time commit 8633328, along with the second patch in
*this* series, would need to be reverted.

If on the other hand, consensus is that we need userspace device register
access capabilities - say for UIO drivers or such - then, depending on the
tact taken, we'll need this solution, or something like it, as part of
that overall strategy.

Reference(s):
  [1] https://lkml.org/lkml/2013/3/7/242
  [2] https://lkml.org/lkml/2013/3/16/168
---

Myron Stowe (2):
      PCI, scsi, ahci: Unify usages of 0x1b4b vendor ID to use PCI_VENDOR_ID_MARVELL_EXT
      PCI: Handle device quirks when accessing sysfs resource<N> entries

Xiangliang Yu (1):
      PCI: Define macro for Marvell vendor ID


 drivers/ata/ahci.c           |   10 +++---
 drivers/pci/pci-sysfs.c      |   11 +++----
 drivers/pci/pci.h            |   13 ++++++++
 drivers/pci/quirks.c         |   70 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/mvsas/mv_init.c |    6 ++--
 drivers/scsi/mvumi.c         |    4 +-
 drivers/scsi/mvumi.h         |    1 -
 include/linux/pci_ids.h      |    1 +
 8 files changed, 99 insertions(+), 17 deletions(-)

-- 
