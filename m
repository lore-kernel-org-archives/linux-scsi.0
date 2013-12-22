From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.13-rc5
Date: Sat, 21 Dec 2013 18:39:17 -0800
Message-ID: <1387679957.5567.80.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48449 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718Ab3LVCiO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Dec 2013 21:38:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Hi Linus,

Here are the outstanding target pending fixes for v3.13-rc5.

Please go ahead and pull from:

   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master 

Mostly minor items this time around, the most notable being a FILEIO
backend change to enforce hw_max_sectors based upon the current
block_size to address a bug where large sized I/Os (> 1M) where being
rejected.

Thank you,

--nab

Andy Grover (1):
  target: Remove extra percpu_ref_init

Eric Seppanen (1):
  iscsi-target: return -EINVAL on oversized configfs parameter

Nicholas Bellinger (5):
  iscsi-target: Fix-up all zero data-length CDBs with R/W_BIT set
  iscsi-target: Fix incorrect np->np_thread NULL assignment
  iser-target: Move INIT_WORK setup into isert_create_device_ib_res
  target/file: Update hw_max_sectors based on current block_size
  qla2xxx: Fix scsi_host leak on qlt_lport_register callback failure

Roland Dreier (1):
  target: Remove write-only stats fields and lock from struct
    se_node_acl

Shivaram Upadhyayula (1):
  qla2xxx: Fix schedule_delayed_work() for target timeout calculations

Wei Yongjun (1):
  iser-target: fix error return code in isert_create_device_ib_res()

 drivers/infiniband/ulp/isert/ib_isert.c      |   22 +++++++++++++++------
 drivers/scsi/qla2xxx/qla_target.c            |   10 ++++++----
 drivers/target/iscsi/iscsi_target.c          |   27 +++++++++++++-------------
 drivers/target/iscsi/iscsi_target_configfs.c |    3 ++-
 drivers/target/iscsi/iscsi_target_login.c    |    6 ------
 drivers/target/target_core_device.c          |    5 +++++
 drivers/target/target_core_file.c            |    8 ++++----
 drivers/target/target_core_file.h            |    5 ++++-
 drivers/target/target_core_tpg.c             |   10 +---------
 include/target/target_core_base.h            |    5 +----
 10 files changed, 52 insertions(+), 49 deletions(-)

