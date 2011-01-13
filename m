From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL 0/3] target patches for scsi-post-merge .38 (round 2)
Date: Wed, 12 Jan 2011 17:03:14 -0800
Message-ID: <1294880594-6976-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.sbc.mail.re3.yahoo.com ([66.196.96.86]:47410 "HELO
	smtp103.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756468Ab1AMBDQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2011 20:03:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Joel Becker <jlbec@evilplan.org>, Randy Dunlap <randy.dunlap@oracle.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James,

Please pull the followup set of target fixes rebased against scsi-post-merge
for .38 here:

git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git master

This includes an important bugfix for TMR LUN_RESET specific to fabric modules
that go into uninterruptible sleep waiting for an unsolicited data out buffer to
become ready (eg: SW iSCSI), a minor cleanup to convert the last simple_strtoul() ->
strict_strtoul() in target_core_fabric_configfs.c, and configfs kbuild dependency
change to include sysfs (by default) to fix a build warning reported by rdd and
recently ACK'ed by jlbec.

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  target: Call transport_new_cmd_failure() while draining qobj_list
    during LUN_RESET
  target: Convert remaining usage of simple_strtoul -> strict_strtoul
  configfs: change depends -> select SYSFS

 drivers/target/target_core_fabric_configfs.c |   41 +++++++++++--------------
 drivers/target/target_core_tmr.c             |    9 ++++++
 drivers/target/target_core_transport.c       |    3 +-
 fs/configfs/Kconfig                          |   14 ++++----
 include/target/target_core_transport.h       |    1 +
 5 files changed, 36 insertions(+), 32 deletions(-)

-- 
1.7.3.5

