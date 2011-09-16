From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/5] target: Bugfixes for v3.1-rc6
Date: Fri, 16 Sep 2011 10:38:21 +0000
Message-ID: <1316169506-4441-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54891 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1IPLEk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Sep 2011 07:04:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Folks,

The following series contains the (hopefully) last set of target v3.1-rc6
bugfixes to address outstanding regressions, and a handful other issues
related to v3.1 mainline target core + iscsi-target code.  This includes:

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

Please go ahead and have a final look, and if there are no complaints they will
be headed to Linus in [GIT PULL] format soon to make next weeks -rc7 / -final
release.
 
This can be pulled directly from a temporary new target-pending.git tree based
upon the latest github v3.1-rc6 while kernel.org infrastructure is down:

    git://linux-iscsi.org/target-pending.git 3.1-rc-fixes

Thank you,

--nab

Christoph Hellwig (1):
  tcm_fc: Work queue based approach instead of managing own thread and
    event based mechanism

Kiran Patil (1):
  tcm_fc: Invalidation of DDP context for FCoE target in error
    conditions

Nicholas Bellinger (2):
  target: Skip non hex characters for EVPD=0x83 NAA IEEE Registered
    Extended
  iscsi-target: Disable markers + remove dangerous local scope array
    usage

Roland Dreier (1):
  target: Fix race between multiple invocations of target_qf_do_work()

 drivers/target/iscsi/iscsi_target_parameters.c |    2 +-
 drivers/target/iscsi/iscsi_target_util.c       |  248 +-----------------------
 drivers/target/target_core_cdb.c               |   35 +++-
 drivers/target/target_core_transport.c         |    9 +-
 drivers/target/tcm_fc/tcm_fc.h                 |   12 +-
 drivers/target/tcm_fc/tfc_cmd.c                |   90 +--------
 drivers/target/tcm_fc/tfc_conf.c               |    7 +-
 drivers/target/tcm_fc/tfc_io.c                 |   62 +++---
 8 files changed, 90 insertions(+), 375 deletions(-)

