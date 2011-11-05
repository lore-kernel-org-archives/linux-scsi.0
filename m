From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] last round of SCSI updates for the 3.1 merge window
Date: Sat, 05 Nov 2011 07:27:45 +0100
Message-ID: <1320474465.9995.8.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47194 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896Ab1KEG1s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Nov 2011 02:27:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org

This represents the stragglers from the last merge.  It's mostly bnx2fc,
mpt2sas, hpsa and the dm handler stuff.  Plus a fair few assorted bug
fixes.

The head sha1 (trying gpg signing) is

commit f7c9c6bb14f3104608a3a83cadea10a6943d2804

The patch is available here:

git://git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

(this should decode to a signed version of the above)

-----BEGIN PGP MESSAGE-----
Version: GnuPG v2.0.18 (GNU/Linux)

owGbwMvMwMRovmplmE7MXh7G07OTGPy2XHuQnJ+bm1mikGaebJlslpRkaJJmbGhg
YmZgkWicaGGcnJiSmmhokGhmaWKcYmRhYMLFFZKRqlCQWJKcoZBZrJBYlpiZk5iU
k6qQkVqUasXFlZ5ZYqWvDyT1slOL8lJz9PKL0q30C0qT9IuTc/VzMvNKK/QhMiBF
+lmpWSCZ4kzd3MziZF0jPTM9oDBXJ6MMCwMjEwMbKxPQjc8ZuDgFYA7fPIP9vzf7
z9qJ4clBfucXye4rkT0rPmWGm1ewzrvABWusPzn3Hctpl4xYe//sssR9ezbx+vwt
2CknHrzvpOI1zsCPkbHfE5iPHZnt87/c/dr+lxu+vlvdcud4p1Z5qCmn9L+rX3YW
T7CfMPPiArkHFw0DLj72kbE0VVYQn9waLv3CeLtV6qt/+bHXdgj9+PujQJI1qcD2
nHbSue+fBWfvVnTdei+YqcD/te9CkZ1/Xd03Bk6zlTlqw9kS959D8EJLhPis3iU1
Cxb8XuQccKNq+rudhruzihzmud9sVrF5NH9fgO1d8Rea3O0flUS9jrnOyk3J++Ic
+u7huUKXf7s2rCo/Njl2yf8Qy0SDSfpO5rcTNgIA
=6JSe
-----END PGP MESSAGE-----


The short changelog is:

Andrew Vasquez (1):
      qla2xxx: Correct inadvertent clearing of RISC_INTR status.

Andrzej Jakowski (1):
      isci: overriding max_concurr_spinup oem parameter by max(oem, user)

Anton Blanchard (1):
      Fix block queue and elevator memory leak in scsi_alloc_sdev

Bart Van Assche (1):
      Make scsi_free_queue() kill pending SCSI commands

Bhanu Prakash Gollapudi (3):
      bnx2fc: Bumped version to 1.0.9
      bnx2fc: Handle SRR LS_ACC drop scenario
      bnx2fc: Handle ABTS timeout during ulp timeout

Dan Williams (1):
      isci: revert bcn filtering

Dave Jones (1):
      pmcraid: pmcraid_chr_ioctl uses incorrect argument order to kmalloc()

Dave Kleikamp (1):
      sd: remove arbitrary SD_MAX_DISKS namespace limit

Jeff Skirvin (9):
      isci: Fix hard reset timeout conditions.
      isci: No need to manage the pending reset bit on pending requests.
      isci: Remove redundant isci_request.ttype field.
      isci: Fix task management for SMP, SATA and on dev remove.
      isci: No task_done callbacks in error handler paths.
      isci: Handle task request timeouts correctly.
      isci: Fix tag leak in tasks and terminated requests.
      isci: Immediately fail I/O to removed devices.
      isci: Lookup device references through requests in completions.

Marcos Paulo de Souza (1):
      scsi_transport_iscsi: Fix documentation os parameter

Michael Chan (1):
      edd: Treat "XPRS" host bus type the same as "PCI"

Moger, Babu (2):
      scsi_dh_alua: Fix the time inteval for alua rtpg commands
      scsi_dh: check queuedata pointer before proceeding further

Petr Uzel (1):
      st: fix race in st_scsi_execute_end

Robin H. Johnson (1):
      mv_sas: OCZ RevoDrive3 & zDrive R4 support

Scott Teel (2):
      hpsa: fix potential array overflow in hpsa_update_scsi_devices
      hpsa: rename HPSA_MAX_SCSI_DEVS_PER_HBA

Stephen M. Cameron (4):
      hpsa: detect controller lockup
      hpsa: fix flush cache transfer length
      hpsa: remove unused busy_initializing and busy_scanning
      hpsa: set max sectors instead of taking the default

Vasu Dev (3):
      libfc: improve flogi retries to avoid lport stuck
      libfc: avoid exchanges collision during lport reset
      libfc: fix checking FC_TYPE_BLS

Wayne Boyer (1):
      ipr: add definitions for additional adapter

nagalakshmi.nandigama@lsi.com (10):
      mpt2sas: Bump driver version to 10.100.00.00
      mpt2sas: Fix for Panic when inactive volume is tried deleting
      mpt2sas: Fix for issue Port Reset taking long time(around 5 mins) to complete while issued during creating a volume
      mpt2sas: Fix for deadlock between hot plug worker threads and host reset context
      mpt2sas: Fix for dead lock occurring between host_lock and sas_device_lock
      mpt2sas: Fix drives not getting properly deleted if sas cable is removed while host reset is active
      mpt2sas: Fix failure message displayed during diag reset
      mpt2sas: Fix for system hang when discovery in progress
      mpt2sas: New feature - Fast Load Support
      mpt2sas: MPI next revision header update

and the diffstat:

 drivers/firmware/edd.c                     |    6 +-
 drivers/scsi/bnx2fc/bnx2fc.h               |    5 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c           |   23 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c          |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c            |   37 ++
 drivers/scsi/device_handler/scsi_dh.c      |   10 +-
 drivers/scsi/device_handler/scsi_dh_alua.c |    3 +-
 drivers/scsi/fcoe/fcoe.c                   |   13 +-
 drivers/scsi/hosts.c                       |    9 +-
 drivers/scsi/hpsa.c                        |  221 ++++++++-
 drivers/scsi/hpsa.h                        |   10 +-
 drivers/scsi/hpsa_cmd.h                    |    5 +-
 drivers/scsi/ipr.c                         |    2 +
 drivers/scsi/ipr.h                         |    1 +
 drivers/scsi/isci/host.c                   |   23 +-
 drivers/scsi/isci/init.c                   |    2 +-
 drivers/scsi/isci/port.c                   |  146 +++----
 drivers/scsi/isci/port.h                   |    6 +-
 drivers/scsi/isci/probe_roms.h             |    4 +-
 drivers/scsi/isci/remote_device.c          |   85 ----
 drivers/scsi/isci/remote_device.h          |    5 +-
 drivers/scsi/isci/request.c                |   52 +--
 drivers/scsi/isci/request.h                |    6 -
 drivers/scsi/isci/task.c                   |  694 +++++++++-------------------
 drivers/scsi/isci/task.h                   |   35 +--
 drivers/scsi/libfc/fc_exch.c               |    7 +-
 drivers/scsi/libfc/fc_lport.c              |   96 ++--
 drivers/scsi/mpt2sas/mpi/mpi2.h            |   11 +-
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h       |  153 ++++++-
 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h        |  113 +++++-
 drivers/scsi/mpt2sas/mpt2sas_base.c        |  247 ++++++++--
 drivers/scsi/mpt2sas/mpt2sas_base.h        |   32 +-
 drivers/scsi/mpt2sas/mpt2sas_config.c      |   67 ++-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c         |    9 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c       |  634 ++++++++++++++++++++------
 drivers/scsi/mvsas/mv_init.c               |   10 +
 drivers/scsi/pmcraid.c                     |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c             |    2 +-
 drivers/scsi/scsi_lib.c                    |    9 +
 drivers/scsi/scsi_scan.c                   |    1 +
 drivers/scsi/scsi_transport_iscsi.c        |    2 +-
 drivers/scsi/sd.c                          |   12 +-
 drivers/scsi/sd.h                          |    6 -
 drivers/scsi/st.c                          |    4 +-
 include/linux/pci_ids.h                    |    2 +
 45 files changed, 1752 insertions(+), 1072 deletions(-)

James


