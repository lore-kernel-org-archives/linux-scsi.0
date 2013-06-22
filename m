From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.10-rc7
Date: Fri, 21 Jun 2013 20:20:40 -0700
Message-ID: <1371871240.23664.248.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59782 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423470Ab3FVDRN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jun 2013 23:17:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, Andy Grover <agrover@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>

Hello Linus,

Here are the current target-pending fixes queued for v3.10-rc7 code.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git =
master

Included is the recent tcm_qla2xxx residual underrun length fix from
Roland, along with Joern's iscsi-target patch for session_lock breakage
within iscsit_stop_time2retain_timer() code.  Both are CC'ed to stable.

The remaining two are specific to recent iscsi-target + iser conversion
changes.  One drops some left-over debug noise, and Andy's patch fixes
configfs attribute handling during an explicit network portal feature
bit disable when iser-target is unsupported.

Thank you,

--nab

Andy Grover (1):
  target/iscsi: Fix op=3Ddisable + error handling cases in np_store_ise=
r

J=C3=B6rn Engel (1):
  target/iscsi: don't corrupt bh_count in
    iscsit_stop_time2retain_timer()

Nicholas Bellinger (1):
  iscsi-target: Remove left over v3.10-rc debug printks

Roland Dreier (1):
  tcm_qla2xxx: Fix residual for underrun commands that fail

 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |    6 ++++-
 drivers/target/iscsi/iscsi_target_configfs.c |   27 +++++++++++++-----=
-------
 drivers/target/iscsi/iscsi_target_erl0.c     |    4 +-
 drivers/target/iscsi/iscsi_target_login.c    |    3 --
 drivers/target/iscsi/iscsi_target_nego.c     |    3 --
 5 files changed, 21 insertions(+), 22 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
