From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC v4 00/19] scsi: Add optional host_lock less scsi_dispatch_cmd()
Date: Mon, 27 Sep 2010 19:04:59 -0700
Message-ID: <1285639499-7204-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux>
Cc: James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.ballabio@inwind.it>, Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>, pm8001 maintainer Jack Wang <jack_wang@usish.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This is the forth RFC for allowing an optional struct Scsi_Host->host_lock
less bit for high performance LLDs who where originaly dropping and reaquiring
host_lock from within their own SHT->queuecommand() callers in order to increase
performance.  This series includes the wholesale conversion of existing libraries
and all other SCSI LLD ->queuecommand() callers that use the now extinct host_lock
optimization of:

        unlock() ; do_some_lld_work() ; lock() -> return from ->mylld_queuecommand()

This series includes patches to drop this historical optimization (and prevent a
sure-fire deadlock w/ host_lock here) in libiscsi, libsas, libfc, libata and in
lpfc, qla4xxx, qla2xxx, fnic, and buslogic SCSI LLDs.

This patch also converts the scsi_cmd_get_serial() call to a counting by 2 odd
counter that is no longer used directly and by default for LLDs in scsi_dispatch_cmd(),
but is still required for mpt-fusion, mpt2sas, and a handful of old LLDs.

For this case we add explict scsi_cmd_get_serial() calls into SHT->queuecommand()
callers for mpt2sas, mpt/fusion, dpt_i2o, eata and u14-34f.  There are other
SCSI LLDs that use struct scsi_cmnd->serial_number informationally, but no other
ones (AFAICT) actually depend on having ->serial_number set to function properly.

So if anyone else knows if any SCSI LLDs that either:

        *) drop and request struct Scsi_Host->host_lock in their SHT->queuecommand()
           to prevent dead-lock

        *) or depend upon struct scsi_cmnd->serial_number for some reason to prevent
           any other old/obsecure LLDs from having problems with a zero ->serial_number.

please let me know and I will queue a follow up patches to address any other issues.

Please note that this patch has a bug wrt to scsi_error.c usage mentioned by
Mike Anderson, and will be addressed in a RFC v5 series.

Changes from RFC v3 -> v4 include:

	*) Use scsi_dispatch_cmd_locked() by default when LLD is not registering
	   it's struct scsi_host_template with SHT->unlocked_qcmd=1
	*) Update aic94xx, mvsas, pm8001 and other LLDs included in RFCv3 to use
	   new SHT->unlocked_qcmd=1 who where already using the ->queuecommand()
	   'optimization' discussed above.

Many thanks go out to the linux.intel.com team (Vasu Dev, Tim Chen, Andi Kleen, Matthew Wilcox)
Joe Eykholt (Cisco), Mike Christie (RHAT), James Bottomley (Suse.de), Mike Anderson + Brian King
(linux.vnet.ibm.com) and Christof Schmitt (de.ibm.com) for their invaluable input towards
the whole-sale conversion of drivers/scsi to an optional host_lock less SHT->queuecommand()
dispatcher!

Thank you!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (19):
  scsi: Add SHT->unlocked_qcmd for host_lock less SHT->queuecommand()
    dispatch
  libiscsi: Remove host_lock unlock() + lock() from
    iscsi_queuecommand()
  libsas: Remove host_lock unlock() + lock() from sas_queuecommand()
  aic94xx: Set SHT->unlocked_qcmd=1 for libsas queuecommand()
  mvsas: Set SHT->unlocked_qcmd=1 for libsas queuecommand()
  pm8001: Set SHT->unlocked_qcmd=1 for libsas queuecommand()
  libfc: Remove host_lock unlock() + lock() from fc_queuecommand()
  fcoe: Set SHT->unlocked_qcmd=1 for libfc fc_queuecommand()
  libata: Remove host_lock unlock() + lock() from ata_scsi_queuecmd()
  lpfc: Remove host_lock unlock() + lock() from lpfc_queuecommand()
  qla4xxx: Remove host_lock unlock() + lock() from
    qla4xxx_queuecommand()
  qla2xxx: Remove host_lock unlock() + lock() from
    qla2xxx_queuecommand()
  fnic: Remove host_lock unlock() + lock() from fnic_queuecommand()
  buslogic: Remove host_lock unlock() + lock() from
    BusLogic_QueueCommand()
  mpt2sas: Add scsi_cmd_get_serial() call
  mpt/fusion: Add scsi_cmd_get_serial() call
  dpt_i2o: Add scsi_cmd_get_serial() call
  eata: Add scsi_cmd_get_serial() call
  u14-34f: Add scsi_cmd_get_serial() call

 block/blk.h                          |    4 ++
 drivers/ata/libata-scsi.c            |    4 +-
 drivers/message/fusion/mptfc.c       |    1 +
 drivers/message/fusion/mptsas.c      |    1 +
 drivers/message/fusion/mptscsih.c    |    5 ++
 drivers/message/fusion/mptspi.c      |    1 +
 drivers/scsi/BusLogic.c              |    4 --
 drivers/scsi/aic94xx/aic94xx_init.c  |    1 +
 drivers/scsi/dpt_i2o.c               |    5 ++
 drivers/scsi/eata.c                  |    5 ++
 drivers/scsi/fcoe/fcoe.c             |    1 +
 drivers/scsi/fnic/fnic_main.c        |    1 +
 drivers/scsi/fnic/fnic_scsi.c        |    9 ----
 drivers/scsi/hosts.c                 |    5 ++
 drivers/scsi/iscsi_tcp.c             |    1 +
 drivers/scsi/libfc/fc_fcp.c          |    5 +--
 drivers/scsi/libiscsi.c              |    4 --
 drivers/scsi/libsas/sas_scsi_host.c  |    5 --
 drivers/scsi/lpfc/lpfc_scsi.c        |    4 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    6 ++
 drivers/scsi/mvsas/mv_init.c         |    1 +
 drivers/scsi/pm8001/pm8001_init.c    |    1 +
 drivers/scsi/qla2xxx/qla_os.c        |    8 +--
 drivers/scsi/qla4xxx/ql4_os.c        |    9 +---
 drivers/scsi/scsi.c                  |   89 ++++++++++++++++++++++++++--------
 drivers/scsi/scsi_error.c            |   10 +++-
 drivers/scsi/u14-34f.c               |    6 ++
 include/linux/libata.h               |    1 +
 include/scsi/scsi_cmnd.h             |    1 +
 include/scsi/scsi_host.h             |   16 +++++-
 30 files changed, 144 insertions(+), 70 deletions(-)

-- 
1.7.3
