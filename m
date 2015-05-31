From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v4.1-rc6
Date: Sat, 30 May 2015 21:40:29 -0700
Message-ID: <1433047229.3170.15.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:52603 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbbEaEkl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 May 2015 00:40:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Hi Linus,

Here are the outstanding target-pending fixes for v4.1-rc6 code.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

These are mostly minor fixes, with the exception of the following that
address fall-out from recent v4.1-rc1 changes:

  - Regression fix related to the big fabric API registration changes 
    and configfs_depend_item() usage, that required cherry-picking one 
    of HCH's patches from for-next to address the issue for v4.1 code.
  - Remaining TCM-USER -v2 related changes to enforce full CDB 
    passthrough from Andy + Ilias.

Also included is a target_core_pscsi driver fix from Andy that addresses
a long standing issue with a Scsi_Host reference being leaked on PSCSI
device shutdown.

Thank you,

--nab

Andy Grover (6):
  target/user: Disallow full passthrough (pass_level=0)
  target/pscsi: Don't leak scsi_host if hba is VIRTUAL_HOST
  target/user: Update example code for new ABI requirements
  target/user: Only support full command pass-through
  target: Move passthrough CDB parsing into a common function
  target: Use a PASSTHROUGH flag instead of transport_types

Bart Van Assche (2):
  target: Fix bidi command handling
  target: Add missing parentheses

Christoph Hellwig (1):
  target: Fix se_tpg_tfo->tf_subsys regression + remove tf_subsystem

Evgenii Lepikhin (1):
  ISCSI: fix minor memory leak

Nicholas Bellinger (1):
  target: Drop signal_pending checks after interruptible lock acquire

Roland Dreier (1):
  iser-target: Fix error path in isert_create_pi_ctx()

 Documentation/target/tcmu-design.txt      |  33 ++-----
 drivers/infiniband/ulp/isert/ib_isert.c   |   6 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c        |   6 +-
 drivers/target/iscsi/iscsi_target.c       |   2 +-
 drivers/target/iscsi/iscsi_target_login.c |   1 +
 drivers/target/iscsi/iscsi_target_tpg.c   |   5 +-
 drivers/target/target_core_alua.c         |   4 +-
 drivers/target/target_core_configfs.c     |  40 ++++-----
 drivers/target/target_core_device.c       |  78 +++++++++++++++-
 drivers/target/target_core_file.c         |   1 -
 drivers/target/target_core_iblock.c       |   1 -
 drivers/target/target_core_internal.h     |   3 -
 drivers/target/target_core_pr.c           |  34 ++-----
 drivers/target/target_core_pscsi.c        |  58 ++----------
 drivers/target/target_core_pscsi.h        |   1 +
 drivers/target/target_core_rd.c           |   1 -
 drivers/target/target_core_sbc.c          |   2 +-
 drivers/target/target_core_transport.c    |  13 ++-
 drivers/target/target_core_user.c         | 143 +++++++-----------------------
 drivers/target/target_core_xcopy.c        |  15 ++--
 drivers/vhost/scsi.c                      |   6 +-
 include/target/target_core_backend.h      |   8 +-
 include/target/target_core_configfs.h     |   2 -
 include/target/target_core_fabric.h       |   4 +-
 24 files changed, 180 insertions(+), 287 deletions(-)

