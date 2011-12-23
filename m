From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 00/28] libsas: eh reworks (ata-eh vs discovery, races, ...)
Date: Thu, 22 Dec 2011 18:58:29 -0800
Message-ID: <20111223025350.21827.85779.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

v1 here: http://marc.info/?l=linux-scsi&m=132408929808366&w=2

Resending all patches given 16 patches were either modified or are new
in this set.

Changes since v1:
1/ The changes to kernel/workqueue.c (to track unchained work during a
   drain_workqueue() operation) have been dropped.  Instead this
   functionality has been pushed down into libsas.  "[PATCH v2 07/28]
   libsas: introduce sas_drain_work()"

2/ Extended "[PATCH v2 09/28] libsas: prevent domain rediscovery
   competing with ata error handling" to fix a deadlock encountered while
   removing a device.  Since device removal issues cache-flush i/o it
   causes libsas to be dependent on the completion of eh which in turn
   means that libsas must not hold eh_mutex over a removal event.

3/ New patch "[PATCH v2 27/28] libsas: fix sas_find_local_phy(), take
   phy references" addresses hitting the BUG_ON(!exphy) in this routine.
   Nothing prevents eh from still being in flight after libsas has removed a
   device from the domain, so the BUG_ON is bogus.

4/ A small collection of dev->gone related fixups, patch 25, 26, and 28.

5/ Picked up a few acked-by and reviewed-by's from Jack, but did not
   include his tested-by across the set given the changes since v1.

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git libsas


Note that I can still occasionally produce the following which appears
to be a use after free of the request_queue, but at least the hotplug /
eh bugs are starting to be dominated by upper layer issues:

[ 8756.193230] general protection fault: 0000 [#1] SMP 
[ 8756.199203] CPU 3 
[ 8756.201260] Modules linked in: isci libsas libata scsi_transport_sas sd_mod ipv6 md_mod i2c_i801 i2c_core [last unloaded: scsi_transport_sas]
[ 8756.216991] 
[ 8756.219041] Pid: 2986, comm: dd Not tainted 3.2.0-rc5+
[ 8756.232102] RIP: 0010:[<ffffffff8106942f>]  [<ffffffff8106942f>] __lock_acquire+0xe3/0xcf1
[ 8756.242131] RSP: 0018:ffff880032b83948  EFLAGS: 00010002
[ 8756.248457] RAX: 6b6b6b6b6b6b6b6b RBX: ffff8800350d0000 RCX: 0000000000000000
[ 8756.256824] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8800380c26a8
[ 8756.265189] RBP: ffff880032b839f8 R08: 0000000000000002 R09: 0000000000000001
[ 8756.273558] R10: ffffffff816123e0 R11: ffffea00005df200 R12: ffff8800350d0000
[ 8756.281925] R13: 0000000000000002 R14: 0000000000000000 R15: ffff8800380c26a8
[ 8756.290292] FS:  00007f4cfa9af700(0000) GS:ffff88003a6c0000(0000) knlGS:0000000000000000
[ 8756.300110] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8756.306921] CR2: 00007fff1fc37c78 CR3: 0000000023337000 CR4: 00000000000406e0
[ 8756.315285] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8756.323653] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8756.332032] Process dd (pid: 2986, threadinfo ffff880032b82000, task ffff8800350d0000)
[ 8756.341645] Stack:
[ 8756.344275]  ffff880000000000 ffffffff00000001 0000000000000000 000000000000000c
[ 8756.353363]  ffff880032b839b8 ffffffff81069159 ffff8800350d06a0 0000000000001000
[ 8756.362460]  0000000000000000 ffff8800350d0000 ffff8800350d06a0 0000000000000002
[ 8756.371558] Call Trace:
[ 8756.374681]  [<ffffffff81069159>] ? mark_lock+0x2d/0x220
[ 8756.381007]  [<ffffffff81069828>] ? __lock_acquire+0x4dc/0xcf1
[ 8756.387911]  [<ffffffff8103412d>] ? try_to_wake_up+0x2e/0x1d9
[ 8756.394725]  [<ffffffff8106a4d6>] lock_acquire+0xec/0x117
[ 8756.401147]  [<ffffffff8103412d>] ? try_to_wake_up+0x2e/0x1d9
[ 8756.407955]  [<ffffffff81497be7>] _raw_spin_lock_irqsave+0x4e/0x61
[ 8756.415255]  [<ffffffff8103412d>] ? try_to_wake_up+0x2e/0x1d9
[ 8756.422073]  [<ffffffff8111f83c>] ? bdi_start_background_writeback+0x52/0x78
[ 8756.430348]  [<ffffffff8103412d>] try_to_wake_up+0x2e/0x1d9
[ 8756.436970]  [<ffffffff81034301>] wake_up_process+0x15/0x17
[ 8756.443591]  [<ffffffff8111f855>] bdi_start_background_writeback+0x6b/0x78


Updated overview of the patchkit:

Patches 1 - 6, 10: miscellaneous cleanups
We seem to have been leaking struct domain_device objects for a while,
and the event locks in libsas are not required.  Calling
->lldd_dev_found() twice is removed in favor of libata notifying aic94xx
of the dma parameters directly.

Patch 7: sas_drain_work() implementation as noted above

Patch 8: uplevel sas_ata ata lock management

Patches 11 - 17, 27: completion races and libsas-eh vs libata-eh
Close races between eh completion and "late" completion by the lldd.
Where possible defer error handling to libata.  After these updates a
lldd can use sas_ata_schedule_reset() to ensure that the reset is
performed in libata context and not libsas-eh which has no link recovery
logic.

Patches 9, 18 - 24: libata link management
These patches aim to make sure all sources of reset of ata devices
occur in libata-eh context.  While libata-eh is active domain
rediscovery is held off.

Patches 25 - 26, 28: dev->gone related fixups

---
[PATCH v2 01/28] libsas: remove unused ata_task_resp fields
[PATCH v2 02/28] libsas: kill sas_slave_destroy
[PATCH v2 03/28] libsas: fix domain_device leak
[PATCH v2 04/28] libsas: fix leak of dev->sata_dev.identify_[packet_]device
[PATCH v2 05/28] libsas: replace event locks with atomic bitops
[PATCH v2 06/28] libsas: convert ha->state to flags
[PATCH v2 07/28] libsas: introduce sas_drain_work()
[PATCH v2 08/28] libsas: remove ata_port.lock management duties from lldds
[PATCH v2 09/28] libsas: prevent domain rediscovery competing with ata error handling
[PATCH v2 10/28] libsas: use ->set_dmamode to notify lldds of NCQ parameters
[PATCH v2 11/28] libsas: kill invocation of scsi_eh_finish_cmd from sas_ata_task_done
[PATCH v2 12/28] libsas: close error handling vs sas_ata_task_done() race
[PATCH v2 13/28] libsas: prevent double completion of scmds from eh
[PATCH v2 14/28] libsas: fix timeout vs completion race
[PATCH v2 15/28] libsas: let libata handle command timeouts
[PATCH v2 16/28] libsas: defer SAS_TASK_NEED_DEV_RESET commands to libata
[PATCH v2 17/28] libsas: use libata-eh-reset for sata rediscovery fis transmit failures
[PATCH v2 18/28] libsas: perform sas-transport resets in shost->workq context
[PATCH v2 19/28] libsas: execute transport link resets with libata-eh via host workqueue
[PATCH v2 20/28] libsas: sas_phy_enable via transport_sas_phy_reset
[PATCH v2 21/28] libsas: Remove redundant phy state notification calls.
[PATCH v2 22/28] libsas: add mutex for SMP task execution
[PATCH v2 23/28] libsas: async ata-eh
[PATCH v2 24/28] libsas: poll for ata device readiness after reset
[PATCH v2 25/28] libsas: don't mark expanders as gone when a child device is removed
[PATCH v2 26/28] libsas: check for 'gone' expanders in smp_execute_task()
[PATCH v2 27/28] libsas: fix sas_find_local_phy(), take phy references
[PATCH v2 28/28] libsas: don't recover 'gone' devices in sas_ata_hard_reset()

 Documentation/scsi/libsas.txt       |   15 -
 drivers/ata/libata-eh.c             |    1 
 drivers/ata/libata.h                |    1 
 drivers/scsi/aic94xx/aic94xx.h      |    2 
 drivers/scsi/aic94xx/aic94xx_dev.c  |   38 +-
 drivers/scsi/aic94xx/aic94xx_init.c |    5 
 drivers/scsi/aic94xx/aic94xx_tmf.c  |    9 
 drivers/scsi/isci/host.c            |    8 
 drivers/scsi/isci/init.c            |    1 
 drivers/scsi/isci/request.c         |    3 
 drivers/scsi/isci/task.c            |   15 -
 drivers/scsi/isci/task.h            |   36 --
 drivers/scsi/libsas/sas_ata.c       |  670 ++++++++++++++---------------------
 drivers/scsi/libsas/sas_discover.c  |  143 ++++++-
 drivers/scsi/libsas/sas_event.c     |   62 +++
 drivers/scsi/libsas/sas_expander.c  |  107 ++++--
 drivers/scsi/libsas/sas_init.c      |  190 +++++++++-
 drivers/scsi/libsas/sas_internal.h  |   71 ++--
 drivers/scsi/libsas/sas_phy.c       |   12 -
 drivers/scsi/libsas/sas_port.c      |   24 +
 drivers/scsi/libsas/sas_scsi_host.c |  299 +++++++---------
 drivers/scsi/mvsas/mv_init.c        |    1 
 drivers/scsi/mvsas/mv_sas.c         |   11 -
 drivers/scsi/pm8001/pm8001_init.c   |    1 
 drivers/scsi/pm8001/pm8001_sas.c    |   29 +-
 drivers/scsi/scsi_transport_sas.c   |   59 +++
 include/linux/libata.h              |    1 
 include/scsi/libsas.h               |   58 ++-
 include/scsi/sas_ata.h              |   26 +
 include/scsi/scsi_transport_sas.h   |   12 +
 30 files changed, 1063 insertions(+), 847 deletions(-)
