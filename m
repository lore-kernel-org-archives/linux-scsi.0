From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.10-rc4
Date: Fri, 31 May 2013 16:06:34 -0700
Message-ID: <1370041594.6949.155.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:46553 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360Ab3EaXDE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 May 2013 19:03:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Roland Dreier <roland@kernel.org>

Hello Linus,

Here is the current set of target-pending fixes for v3.10-rc4 code.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

The highlights include:

  - Re-instate sess->wait_list in target_wait_for_sess_cmds() for active
    I/O shutdown handling in fabrics using se_cmd->cmd_kref
  - Make ib_srpt call target_sess_cmd_list_set_waiting() during session shutdown
  - Fix FILEIO off-by-one READ_CAPACITY bug for !S_ISBLK export
  - Fix iscsi-target login error heap buffer overflow (Kees)
  - Fix iscsi-target active I/O shutdown handling regression in v3.10-rc1

A big thanks to Kees Cook for fixing a long standing login error buffer
overflow bug.

All patches are CC'ed to stable with the exception of the v3.10-rc1
specific regression + other minor target cleanup.

Thank you,

--nab

Joern Engel (1):
  target: Remove unused wait_for_tasks bit in target_wait_for_sess_cmds

Kees Cook (1):
  iscsi-target: fix heap buffer overflow on error

Nicholas Bellinger (5):
  target: Re-instate sess_wait_list for target_wait_for_sess_cmds
  ib_srpt: Call target_sess_cmd_list_set_waiting during
    shutdown_session
  target/file: Fix off-by-one READ_CAPACITY bug for !S_ISBLK export
  target: Propigate up ->cmd_kref put return via
    transport_generic_free_cmd
  iscsi-target: Fix iscsit_free_cmd() se_cmd->cmd_kref shutdown
    handling

 drivers/infiniband/ulp/srpt/ib_srpt.c          |   34 ++++++++---
 drivers/infiniband/ulp/srpt/ib_srpt.h          |    1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c             |    2 +-
 drivers/target/iscsi/iscsi_target.c            |   12 ++--
 drivers/target/iscsi/iscsi_target_erl2.c       |   12 ++--
 drivers/target/iscsi/iscsi_target_parameters.c |    8 +--
 drivers/target/iscsi/iscsi_target_parameters.h |    4 +-
 drivers/target/iscsi/iscsi_target_util.c       |   50 ++++++++++++----
 drivers/target/iscsi/iscsi_target_util.h       |    2 +-
 drivers/target/target_core_file.c              |   11 ++--
 drivers/target/target_core_transport.c         |   74 +++++++++++-------------
 include/target/target_core_base.h              |    1 +
 include/target/target_core_fabric.h            |    4 +-
 13 files changed, 126 insertions(+), 89 deletions(-)

-- 
1.7.2.5

