From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/2] Fixed for 64bit LUNs
Date: Fri,  4 Jul 2014 13:54:33 +0200
Message-ID: <1404474875-109997-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbaGDLyj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jul 2014 07:54:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi Christoph,

here are some more fixes for 64bit LUNs, which should fix the latest
built issues from Fengguang.
Most notably I've introduced a new accessor 'sdev_scsi2lun' for those
devices which are not capable of handling LUNs higher than 255.
And I've removed the custom LUN handling code from ib_srp.

Hannes Reinecke (2):
  Use sdev_scsi2lun for SCSI parallel drivers
  ib_srp: 64bit LUN fixes

 arch/ia64/hp/sim/simscsi.c            |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c   |  9 ++--
 drivers/infiniband/ulp/srpt/ib_srpt.c | 81 +--------------------------------
 drivers/scsi/53c700.c                 | 12 ++---
 drivers/scsi/BusLogic.c               |  2 +-
 drivers/scsi/NCR5380.c                | 32 ++++++-------
 drivers/scsi/NCR53c406a.c             |  2 +-
 drivers/scsi/a100u2w.c                |  4 +-
 drivers/scsi/advansys.c               | 16 +++----
 drivers/scsi/aha152x.c                | 13 +++---
 drivers/scsi/aha1542.c                |  4 +-
 drivers/scsi/aha1740.c                |  2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c    | 19 ++++----
 drivers/scsi/aic7xxx/aic79xx_proc.c   |  2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c    | 23 +++++-----
 drivers/scsi/aic7xxx/aic7xxx_proc.c   |  2 +-
 drivers/scsi/arm/acornscsi.c          | 20 ++++----
 drivers/scsi/arm/fas216.c             | 15 +++---
 drivers/scsi/arm/queue.c              |  8 ++--
 drivers/scsi/atari_NCR5380.c          | 81 +++++++++++++++++----------------
 drivers/scsi/atp870u.c                |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c       |  4 +-
 drivers/scsi/ch.c                     | 16 +++----
 drivers/scsi/dc395x.c                 | 73 ++++++++++++++---------------
 drivers/scsi/eata.c                   |  4 +-
 drivers/scsi/eata_pio.c               |  2 +-
 drivers/scsi/esp_scsi.c               |  6 +--
 drivers/scsi/g_NCR5380.c              |  2 +-
 drivers/scsi/gdth.c                   |  4 +-
 drivers/scsi/hptiop.c                 |  6 +--
 drivers/scsi/in2000.c                 | 36 ++++++++-------
 drivers/scsi/initio.c                 |  4 +-
 drivers/scsi/megaraid.c               | 10 ++--
 drivers/scsi/mesh.c                   |  6 +--
 drivers/scsi/mvumi.c                  |  2 +-
 drivers/scsi/ncr53c8xx.c              | 33 +++++++-------
 drivers/scsi/nsp32.c                  | 14 +++---
 drivers/scsi/ps3rom.c                 |  2 +-
 drivers/scsi/qlogicpti.c              |  6 +--
 drivers/scsi/scsi.c                   |  2 +-
 drivers/scsi/stex.c                   |  2 +-
 drivers/scsi/sun3_NCR5380.c           | 86 +++++++++++++++++++----------------
 drivers/scsi/sym53c8xx_2/sym_glue.c   | 19 ++++----
 drivers/scsi/sym53c8xx_2/sym_hipd.c   | 10 ++--
 drivers/scsi/tmscsim.c                | 12 +++--
 drivers/scsi/u14-34f.c                |  6 +--
 drivers/scsi/ufs/ufshcd.c             |  4 +-
 drivers/scsi/ultrastor.c              |  2 +-
 drivers/scsi/wd33c93.c                | 35 ++++++++------
 drivers/scsi/wd7000.c                 |  3 +-
 drivers/staging/rts5208/rtsx.c        |  4 +-
 include/scsi/scsi_device.h            |  5 ++
 52 files changed, 373 insertions(+), 398 deletions(-)

-- 
1.7.12.4

