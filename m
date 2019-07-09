From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI topic updates for the 5.2+ merge window: sg
Date: Tue, 09 Jul 2019 13:47:58 -0700
Message-ID: <1562705278.30003.8.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This topic branch covers a fundamental change in how our sg lists are
allocated to make mq more efficient by reducing the size of the
preallocated sg list.  This necessitates a large number of driver
changes because the previous guarantee that if a driver specified
SG_ALL as the size of its scatter list, it would get a non-chained list
and didn't need to bother with scatterlist iterators is now broken and
every driver *must* use scatterlist iterators.

This was broken out as a separate topic because we need to convert all
the drivers before pulling the trigger and unconverted drivers kept
being found, plus the odd bug, necessitating a rebase.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-sg

The short changelog is:

Finn Thain (2):
      scsi: NCR5380: use sg helper to iterate over scatterlist
      scsi: aha152x: use sg helper to iterate over scatterlist

Ming Lei (19):
      scsi: core: don't preallocate small SGL in case of NO_SG_CHAIN
      scsi: lib/sg_pool.c: clear 'first_chunk' in case of no preallocation
      scsi: core: avoid preallocating big SGL for data
      scsi: core: avoid preallocating big SGL for protection information
      scsi: lib/sg_pool.c: improve APIs for allocating sg pool
      scsi: esp: use sg helper to iterate over scatterlist
      scsi: wd33c93: use sg helper to iterate over scatterlist
      scsi: ppa: use sg helper to iterate over scatterlist
      scsi: pcmcia: nsp_cs: use sg helper to iterate over scatterlist
      scsi: imm: use sg helper to iterate over scatterlist
      scsi: s390: zfcp_fc: use sg helper to iterate over scatterlist
      scsi: staging: unisys: visorhba: use sg helper to iterate over scatterlist
      scsi: usb: image: microtek: use sg helper to iterate over scatterlist
      scsi: pmcraid: use sg helper to iterate over scatterlist
      scsi: ipr: use sg helper to iterate over scatterlist
      scsi: mvumi: use sg helper to iterate over scatterlist
      scsi: lpfc: use sg helper to iterate over scatterlist
      scsi: advansys: use sg helper to iterate over scatterlist
      scsi: vmw_pscsi: use sg helper to iterate over scatterlist

And the diffstat:

 drivers/nvme/host/fc.c                          |  7 ++--
 drivers/nvme/host/rdma.c                        |  7 ++--
 drivers/nvme/target/loop.c                      |  4 +--
 drivers/s390/scsi/zfcp_fc.c                     |  4 +--
 drivers/scsi/NCR5380.c                          | 41 ++++++++++------------
 drivers/scsi/advansys.c                         |  2 +-
 drivers/scsi/aha152x.c                          | 46 ++++++++++++-------------
 drivers/scsi/esp_scsi.c                         | 20 +++++++----
 drivers/scsi/esp_scsi.h                         |  2 ++
 drivers/scsi/imm.c                              |  2 +-
 drivers/scsi/ipr.c                              | 29 +++++++++-------
 drivers/scsi/lpfc/lpfc_nvmet.c                  |  3 +-
 drivers/scsi/mvumi.c                            | 11 +++---
 drivers/scsi/pcmcia/nsp_cs.c                    |  4 +--
 drivers/scsi/pmcraid.c                          | 14 ++++----
 drivers/scsi/ppa.c                              |  2 +-
 drivers/scsi/scsi_lib.c                         | 35 ++++++++++++++-----
 drivers/scsi/vmw_pvscsi.c                       |  2 +-
 drivers/scsi/wd33c93.c                          |  2 +-
 drivers/staging/unisys/visorhba/visorhba_main.c |  9 +++--
 drivers/usb/image/microtek.c                    | 20 +++++------
 drivers/usb/image/microtek.h                    |  2 +-
 include/linux/scatterlist.h                     | 11 +++---
 lib/scatterlist.c                               | 36 ++++++++++++-------
 lib/sg_pool.c                                   | 39 +++++++++++++++------
 net/sunrpc/xprtrdma/svc_rdma_rw.c               |  5 +--

James
