From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target: Bugfixes for v3.1-rc7
Date: Sun, 18 Sep 2011 19:13:50 -0700
Message-ID: <1316398430.3622.7.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

The following patch series are the pending -rc7 fixes for mainline.  At
this point we are still tracking down two other outstanding v3.1
regressions reported by Roland and Martin, but I don't want these
outstanding issues to hold up the fixes currently in the mainline queue.

This series includes:

*) A bugfix from Christoph to use a work queue to address breakage in the
   current tcm_fc(fcoe) I/O path
*) A bugfix from Kiran to fix tcm_fc(fcoe) DDP offload error conditions
*) A bugfix from Roland to address list corruption in target core handling of
   QUEUE_FULL status.
*) A change to use only hex characters in the binary conversion of
   vpd_unit_serial for EVPD=0x83 NAA IEEE Registered Extended in target core
   to address a bug with internal hex2bin() usage, and finally,
*) A change to explictly disable iSCSI marker parameter key usage in order to
   remove a potentially dangerous local scope array allocation with markers
   enabled in the main iscsi-target I/O path.
*) A bugfix to address iscsi-target sendpage breakage with Padding + DataDigests
   iovec offsets after the v3.1 struct se_mem -> struct scatterlist conversion.

Please go ahead and pull from the following -rc6 based tree:

   git://linux-iscsi.org/target-pending.git 3.1-rc-fixes

Thanks,

--nab

Christoph Hellwig (1):
  tcm_fc: Work queue based approach instead of managing own thread and
    event based mechanism

Kiran Patil (1):
  tcm_fc: Invalidation of DDP context for FCoE target in error
    conditions

Nicholas Bellinger (3):
  target: Skip non hex characters for VPD=0x83 NAA IEEE Registered
    Extended
  iscsi-target: Disable markers + remove dangerous local scope array
    usage
  iscsi-target: Fix sendpage breakage with proper padding+DataDigest
    iovec offsets

Roland Dreier (1):
  target: Fix race between multiple invocations of target_qf_do_work()

 drivers/target/iscsi/iscsi_target_parameters.c |    2 +-
 drivers/target/iscsi/iscsi_target_util.c       |  270 ++----------------------
 drivers/target/target_core_cdb.c               |   35 +++-
 drivers/target/target_core_transport.c         |    9 +-
 drivers/target/tcm_fc/tcm_fc.h                 |   12 +-
 drivers/target/tcm_fc/tfc_cmd.c                |   90 +-------
 drivers/target/tcm_fc/tfc_conf.c               |    7 +-
 drivers/target/tcm_fc/tfc_io.c                 |   62 +++---
 8 files changed, 105 insertions(+), 382 deletions(-)
