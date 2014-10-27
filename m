From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 00/36] Fixes, cleanups and modernization for NCR5380 drivers
Date: Mon, 27 Oct 2014 16:26:07 +1100
Message-ID: <20141027052607.105914311@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:48293 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaJ0Kbf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2014 06:31:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org


This patch series has fixes for bugs and compiler warnings as well as code
cleanup and modernization. It covers all ten NCR5380 drivers and the three
core NCR5380 drivers so it's fairly large.

These patches remove a lot of duplicated code and C pre-processor abuse.
There are also patches for scsi_add_host() conversion for atari_scsi,
mac_scsi and sun3_scsi.

Some steps are taken toward re-unification of the NCR5380 core driver forks
by reducing divergence between them. Also, the atari_NCR5380.c core driver
is generalized so it can be used by sun3_scsi.c (and others).

I have compile-tested all of the NCR5380 drivers (x86, ARM and m68k) and
executed mac_scsi and dmx3191d on suitable hardware. I found no regressions
but the core NCR5380 drivers have bugs unrelated to these patches.

Testing mac_scsi and dmx3191d provides only limited code coverage for these
patches. Some testing on Sun 3, Atari ST and/or Atari TT would be nice
(I don't have the hardware).

There are old bugs relating to exception handling and autosense in the
core NCR5380 drivers that can make testing difficult. I'm working on a
series of patches to address these bugs. Those patches are not yet ready
for submission but they were helpful for the testing I did and may be
helpful to other testers. Let me know if so.

Changes since v1:
- Re-based to v3.17.
- Addressed issues raised in code review (see relevant patches for details).
- Added patches 30 to 36, to remove sun3_NCR5380.c entirely and remove more
  static variables from atari_NCR5380.c.

This patch set stops short of parameterizing the drivers with platform_data
and/or ops struct. IMHO, it would be premature to do such refactoring before
drivers have been purged of static variables and certain #ifdefs. After
that is done, entire modules could be replaced with platform devices.

Several patches in this set address issues with the tagged command queueing
code (see patches 7, 33 and 34). I've since learned from recent discussions
on the linux-scsi list that use of the tag member in struct scsi_cmnd is
deprecated. If removal of the tag member is imminent then it may be better
to remove TCQ support from all of the NCR5380 drivers instead of this
cleanup. Or it could be done separately.

Removal of TCQ code might make re-unification easier, by bringing
atari_NCR5380.c closer to NCR5380.c and eliminating some #ifdefs.
Changes to the TCQ code would affect atari_scsi, being the only driver to
#define SUPPORT_TAGS.

---
 MAINTAINERS                         |    1 
 arch/m68k/atari/config.c            |   27 
 arch/m68k/atari/stdma.c             |   61 
 arch/m68k/include/asm/atari_stdma.h |    4 
 arch/m68k/include/asm/macintosh.h   |    4 
 arch/m68k/mac/config.c              |  146 +
 arch/m68k/sun3/config.c             |   60 
 drivers/scsi/Kconfig                |    2 
 drivers/scsi/NCR5380.c              |  295 +--
 drivers/scsi/NCR5380.h              |   78 
 drivers/scsi/arm/cumana_1.c         |   18 
 drivers/scsi/arm/oak.c              |   23 
 drivers/scsi/atari_NCR5380.c        |  981 +++++-------
 drivers/scsi/atari_scsi.c           |  676 +++-----
 drivers/scsi/atari_scsi.h           |   60 
 drivers/scsi/dmx3191d.c             |   31 
 drivers/scsi/dtc.c                  |   85 -
 drivers/scsi/dtc.h                  |   26 
 drivers/scsi/g_NCR5380.c            |  224 --
 drivers/scsi/g_NCR5380.h            |   26 
 drivers/scsi/mac_scsi.c             |  542 ++----
 drivers/scsi/mac_scsi.h             |   74 
 drivers/scsi/pas16.c                |  106 -
 drivers/scsi/pas16.h                |   21 
 drivers/scsi/sun3_NCR5380.c         | 2933 ------------------------------------
 drivers/scsi/sun3_scsi.c            |  512 ++----
 drivers/scsi/sun3_scsi.h            |   84 -
 drivers/scsi/t128.c                 |   83 -
 drivers/scsi/t128.h                 |   23 
 29 files changed, 1745 insertions(+), 5461 deletions(-)




