From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 00/12] target: Updates for .38-rc4
Date: Thu,  3 Feb 2011 22:45:00 -0800
Message-ID: <1296801912-18857-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm18-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.210]:37037 "HELO
	nm18-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751417Ab1BDGpL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Feb 2011 01:45:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Joel Becker <jlbec@evilplan.org>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James and Co,

Please consider the following patch series for mainline target code.
It consists of predominately configfs bugfixes uncovered with recent SLUB
poison testing, and proper removal of legacy procfs target_core_mib.c code.
Note that the complete set of fabric independent statistics (SCSI MIBs) and
fabric dependent statistics will be included as native configfs group context
'per value' attribute series during the .39 time frame.

Note this series is expected to be applied on top of the 24 patch series
from scsi-post-merge-2.6.git/for-38-rc3-v2 here:

[PATCH 00/24] target updates for .38-rc3 (v2)
http://marc.info/?l=linux-scsi&m=129632617326015&w=2

This patch series is against the following commit with the above series
applied:

   commit ebf53826e105f488f4f628703a108e98940d1dc5
   Author: Linus Torvalds <torvalds@linux-foundation.org>
   Date:   Tue Feb 1 13:05:49 2011 +1000

       Linux 2.6.38-rc3

This series is also availible for a direct PULL from here:

   git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-38-rc4

Please review and apply for mainline.

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Jesper Juhl (1):
  target: Avoid mem leak and needless work in transport_generic_get_mem

Nicholas Bellinger (11):
  target: Fix top-level configfs_subsystem default_group shutdown
    breakage
  target: Move core_delete_hba() into ->release() callback
  target: Move subdev release logic into ->release() callback
  target: Move core_alua_free_lu_gp() into ->release() callback
  target: Move core_alua_free_tg_pt_gp() into ->release() callback
  target: Move fabric dependent struct se_wwn free into ->release()
    callback
  target: Move fabric dependent se_portal_group free into ->release()
    callback
  target: Move fabric dependent se_node_acl free into ->release
    callback()
  target: Move fabric dependent struct se_tpg_np free into ->release()
    callback
  target: Move fabric independent se_lun_acl free into ->release()
    callback
  target: Remove procfs based target_core_mib.c code

 drivers/target/Makefile                      |    1 -
 drivers/target/target_core_configfs.c        |  149 ++--
 drivers/target/target_core_device.c          |    3 -
 drivers/target/target_core_fabric_configfs.c |   92 ++-
 drivers/target/target_core_hba.c             |    1 -
 drivers/target/target_core_mib.c             | 1098 --------------------------
 drivers/target/target_core_mib.h             |   21 -
 drivers/target/target_core_tpg.c             |   10 -
 drivers/target/target_core_transport.c       |   52 +-
 include/target/target_core_base.h            |   21 +-
 include/target/target_core_transport.h       |    2 +
 11 files changed, 207 insertions(+), 1243 deletions(-)
 delete mode 100644 drivers/target/target_core_mib.c
 delete mode 100644 drivers/target/target_core_mib.h

-- 
1.7.4

