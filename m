From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 00/29] Fixes, cleanups and modernization for NCR5380 drivers
Date: Thu, 02 Oct 2014 16:56:28 +1000
Message-ID: <20141002065628.256592712@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33692 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbaJBNDn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 09:03:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org


This patch series has fixes for bugs and compiler warnings as well as code
cleanup and modernization. It covers all ten NCR5380 drivers and the three
core NCR5380 drivers so it's fairly large.

At the end of this series about a thousand lines (net) have been removed
including two header files. A lot of C pre-processor abuse is eliminated.
There are patches for scsi_add_host() conversion for atari_scsi, mac_scsi
and sun3_scsi.

Some steps are taken toward re-unification of the NCR5380 core driver forks
by reducing divergence between them. Also, the atari_NCR5380.c core driver
is generalized such that it can be used by sun3_scsi.c. The next step is
to remove sun_NCR5380.c by adopting atari_NCR5380.c.

I have compile-tested all of the NCR5380 drivers (x86, ARM and m68k) and
executed mac_scsi and dmx3191d on suitable hardware. I found no regressions
but the core NCR5380 drivers have bugs unrelated to these patches.

Testing mac_scsi and dmx3191d provides only limited code coverage for these
patches. Some testing on Sun 3, Atari ST and/or Atari TT would be nice
(I don't have the hardware).

There are old bugs relating to exception handling and autosense in the
core NCR5380 drivers that can make testing difficult. I'm working on a series
of patches to address these bugs. Those patches are not yet ready for
submission but they were helpful in testing this patch series and may be
helpful to other testers. Let me know if so.

---
 arch/m68k/atari/config.c            |    5 
 arch/m68k/atari/stdma.c             |   62 ++-
 arch/m68k/include/asm/atari_stdma.h |    4 
 arch/m68k/include/asm/macintosh.h   |    3 
 arch/m68k/mac/config.c              |  101 ++++-
 arch/m68k/sun3/config.c             |   11 
 drivers/scsi/Kconfig                |    2 
 drivers/scsi/NCR5380.c              |  296 +++++----------
 drivers/scsi/NCR5380.h              |   59 +--
 drivers/scsi/arm/cumana_1.c         |   18 
 drivers/scsi/arm/oak.c              |   21 -
 drivers/scsi/atari_NCR5380.c        |  383 ++++++++------------
 drivers/scsi/atari_scsi.c           |  677 +++++++++++++++---------------------
 drivers/scsi/atari_scsi.h           |   60 ---
 drivers/scsi/dmx3191d.c             |   31 -
 drivers/scsi/dtc.c                  |   85 +---
 drivers/scsi/dtc.h                  |   26 -
 drivers/scsi/g_NCR5380.c            |  224 -----------
 drivers/scsi/g_NCR5380.h            |   26 -
 drivers/scsi/mac_scsi.c             |  545 ++++++++++++----------------
 drivers/scsi/mac_scsi.h             |   74 ---
 drivers/scsi/pas16.c                |  106 +----
 drivers/scsi/pas16.h                |   21 -
 drivers/scsi/sun3_NCR5380.c         |  187 ++-------
 drivers/scsi/sun3_scsi.c            |  518 ++++++++++++---------------
 drivers/scsi/sun3_scsi.h            |   75 ---
 drivers/scsi/t128.c                 |   83 +---
 drivers/scsi/t128.h                 |   23 -
 28 files changed, 1366 insertions(+), 2360 deletions(-)




