From: Dan Williams <dan.j.williams@intel.com>
Subject: isci.git#all for linux-next
Date: Fri, 10 Feb 2012 10:59:25 -0800
Message-ID: <1328900367.27478.29.camel@ultramagnus.opencreations.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:38613 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759670Ab2BJS7a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2012 13:59:30 -0500
Received: by ghbz22 with SMTP id z22so1831081ghb.25
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2012 10:59:28 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sfr@canb.auug.org.au
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

Hi Stephen,

I have a couple of active topic branches brewing for 3.4 that address
problems in libsas as well as ongoing development of the libsas-based
isci driver.  They are at the point where they should be getting
exposure in -next, so I have combined them into a daily-merge branch
'all' for linux-next consumption.

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git all

Since I have been rebasing to address the odd compile error, or delete a
patch that turned out to be unnecessary, it has been a bit too much
thrash to work into a (mostly) patches-only scsi-misc work flow.  That
being said there are some nicely aged commits in the tree:

 30 commits 5 weeks old
 11 commits 1-3 weeks old
 18 under a week old

For at least the next few weeks I would like to have this tree in -next.
This gives James the option of letting these brew with -next exposure
before applying the patches, or just pulling the git topics directly for
the merge window.  If this tree ever develops a conflict with scsi-misc
-next should drop it as that probably means the patches have started
making their way into scsi-misc.

All patches hit the mailing list prior to appearing in git, and at any
given point I would feel comfortable sending an official pull request
for the contents.

--
Dan

The following changes since commit d65b4e98d7ea3038b767b70fe8be959b2913f16d:

  Linux 3.3-rc3 (2012-02-08 19:21:53 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git all

Andrzej Jakowski (1):
      isci: improvements in driver unloading routine

Dan Williams (62):
      libsas: remove unused ata_task_resp fields
      libsas: kill sas_slave_destroy
      libsas: fix domain_device leak
      libsas: fix leak of dev->sata_dev.identify_[packet_]device
      libsas: replace event locks with atomic bitops
      libsas: convert ha->state to flags
      libsas: introduce sas_drain_work()
      libsas: remove ata_port.lock management duties from lldds
      libsas: convert dev->gone to flags
      libsas: prevent domain rediscovery competing with ata error handling
      libsas: use ->set_dmamode to notify lldds of NCQ parameters
      libsas: kill invocation of scsi_eh_finish_cmd from sas_ata_task_done
      libsas: close error handling vs sas_ata_task_done() race
      libsas: prevent double completion of scmds from eh
      libsas: fix timeout vs completion race
      libsas: let libata handle command timeouts
      libsas: defer SAS_TASK_NEED_DEV_RESET commands to libata
      libsas: use libata-eh-reset for sata rediscovery fis transmit failures
      libsas: perform sas-transport resets in shost->workq context
      libsas: execute transport link resets with libata-eh via host workqueue
      libsas: sas_phy_enable via transport_sas_phy_reset
      libsas: async ata-eh
      libsas: poll for ata device readiness after reset
      libsas: don't mark expanders as gone when a child device is removed
      libsas: check for 'gone' expanders in smp_execute_task()
      libsas: fix sas_find_local_phy(), take phy references
      libsas: don't recover 'gone' devices in sas_ata_hard_reset()
      isci: kill iphy->isci_port lookups
      isci: kill isci_port->status
      isci: fix interpretation of "hard" reset
      isci: stop interpreting ->lldd_lu_reset() as an ata soft-reset
      isci: ->lldd_ata_check_ready handler
      isci: remove bus and reset handlers
      isci: remove IDEV_EH hack to disable "discovery-time" ata resets
      isci: Merge commit 'v3.3-rc1' into devel
      isci: debug, provide state-enum-to-string conversions
      libsas: pre-clean commands that won the eh vs completion race
      libsas: mark all domain devices gone if root port disappears
      libsas: close scsi_remove_target() vs libata-eh race
      libsas: fix mixed topology recovery
      libsas: route local link resets through ata-eh
      libsas: fix sas_unregister_ports vs sas_drain_work
      libsas: improve debug statements
      libsas: fix sas port naming
      libsas: let libata recover links that fail to transmit initial sig-fis
      libsas: delete device on sas address changed
      libsas: restore scan order
      libsas: async ata scanning
      libsas: fix lifetime of SAS_HA_FROZEN
      libsas: revert ata srst
      libsas: set attached device type and target protocols for local phys
      isci: improve phy event warnings
      libsas: fixup target_port_protocols for expanders that don't report sata
      libsas: don't recover end devices attached to disabled phys
      scsi_transport_sas: 'enable' phys on reset
      libsas: libsas.force_hard_reset module parameter
      libsas: enforce eh strategy handlers only in eh context
      libsas: add sas_eh_abort_handler
      libsas: use ->lldd_I_T_nexus_reset for ->eh_bus_reset_handler
      isci: use sas eh strategy handlers
      libsas: trim sas_task of slow path infrastructure
      Merge branches 'devel' and 'fixes' into all

Dave Jiang (2):
      isci: Fix NULL ptr dereference when no firmware is being loaded
      isci: T10 DIF support

Jeff Skirvin (2):
      libsas: Remove redundant phy state notification calls.
      libsas: add mutex for SMP task execution

Jesper Juhl (1):
      isci: Just #include "host.h" once in host.c

Maciej Trela (1):
      libsas: kill spurious sas_put_device

Marcin Tomczak (1):
      isci: enable clock gating

 Documentation/kernel-parameters.txt     |    6 +
 Documentation/scsi/libsas.txt           |   15 -
 drivers/ata/libata-core.c               |   34 +-
 drivers/ata/libata-eh.c                 |    1 +
 drivers/ata/libata-scsi.c               |   13 +
 drivers/ata/libata.h                    |    2 +-
 drivers/scsi/aic94xx/aic94xx.h          |    2 +
 drivers/scsi/aic94xx/aic94xx_dev.c      |   38 +-
 drivers/scsi/aic94xx/aic94xx_init.c     |    6 +-
 drivers/scsi/aic94xx/aic94xx_tmf.c      |   11 +-
 drivers/scsi/isci/host.c                |   22 +-
 drivers/scsi/isci/host.h                |   19 +-
 drivers/scsi/isci/init.c                |   27 +-
 drivers/scsi/isci/phy.c                 |  171 ++++---
 drivers/scsi/isci/phy.h                 |  155 +++----
 drivers/scsi/isci/port.c                |  263 ++++++-----
 drivers/scsi/isci/port.h                |  114 ++---
 drivers/scsi/isci/registers.h           |   27 +-
 drivers/scsi/isci/remote_device.c       |   82 ++--
 drivers/scsi/isci/remote_device.h       |  212 ++++-----
 drivers/scsi/isci/remote_node_context.c |   19 +-
 drivers/scsi/isci/remote_node_context.h |   97 ++--
 drivers/scsi/isci/request.c             |  370 +++++++--------
 drivers/scsi/isci/request.h             |  228 ++++-----
 drivers/scsi/isci/scu_task_context.h    |   55 ++-
 drivers/scsi/isci/task.c                |  158 ++-----
 drivers/scsi/isci/task.h                |   40 --
 drivers/scsi/libsas/sas_ata.c           |  827 +++++++++++++++----------------
 drivers/scsi/libsas/sas_discover.c      |  216 +++++++--
 drivers/scsi/libsas/sas_event.c         |   96 ++++-
 drivers/scsi/libsas/sas_expander.c      |  360 +++++++++-----
 drivers/scsi/libsas/sas_host_smp.c      |   11 +-
 drivers/scsi/libsas/sas_init.c          |  243 ++++++++-
 drivers/scsi/libsas/sas_internal.h      |   97 +++--
 drivers/scsi/libsas/sas_phy.c           |   12 +-
 drivers/scsi/libsas/sas_port.c          |   32 +-
 drivers/scsi/libsas/sas_scsi_host.c     |  421 ++++++++---------
 drivers/scsi/mvsas/mv_init.c            |    2 -
 drivers/scsi/mvsas/mv_sas.c             |   31 +-
 drivers/scsi/pm8001/pm8001_init.c       |    2 -
 drivers/scsi/pm8001/pm8001_sas.c        |   59 ++-
 drivers/scsi/scsi_transport_sas.c       |   60 ++-
 include/linux/libata.h                  |    2 +
 include/scsi/libsas.h                   |   86 ++--
 include/scsi/sas.h                      |    4 +-
 include/scsi/sas_ata.h                  |   44 +-
 include/scsi/scsi_transport_sas.h       |   12 +-
 47 files changed, 2592 insertions(+), 2212 deletions(-)


