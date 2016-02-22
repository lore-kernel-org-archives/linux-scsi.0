From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 0/6] ncr5380: Exception handling fixes for v4.5
Date: Tue, 23 Feb 2016 10:07:03 +1100
Message-ID: <20160222230703.994951661@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


These patches fix some exception handling and autosense bugs that I
accidentally introduced in v4.5-rc1.

The error recovery and autosense code in these drivers has been unstable
for a long time. Despite that, v4.5-rc1 shows a regression in as much as
it exposes a bug in the aranym emulator. This leads to error recovery,
which can crash.

Also, Michael Schmitz reported some crashes involving abort handling
for a certain target device. And Dan Carpenter found a NULL pointer deref
in the new bus reset code.

Error recovery and autosense are stable with these patches.

I tested them using a Domex 3191D PCI card. Errors during IO were
simulated by sending bus resets and unplugging/replugging the SCSI
cables. Some of these patches fix bugs that only affect more capable
hardware (like Atari). Thanks to Michael Schmitz for patiently testing
those.

Please review this series for v4.5.

---
 drivers/scsi/NCR5380.c       |  133 +++++++++++++++++++------------------------
 drivers/scsi/atari_NCR5380.c |  133 +++++++++++++++++++------------------------
 2 files changed, 118 insertions(+), 148 deletions(-)
