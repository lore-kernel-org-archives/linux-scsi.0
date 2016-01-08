From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/4] target: Close se_node_acl lookup race
Date: Fri,  8 Jan 2016 07:15:44 +0000
Message-ID: <1452237348-2277-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:33102 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbcAHHRv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jan 2016 02:17:51 -0500
Received: by mail-oi0-f52.google.com with SMTP id y66so329782322oig.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Jan 2016 23:17:51 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This series addresses a long standing race between when
fabric driver se_node_acl lookup and associated pointer
dereference happens, and when kref_get() of ->acl_kref
actually occurs within __transport_register_session()
code.

To address this bug, patch #1 makes get_initiator_node_acl
lookup obtain ->acl_kref while ->acl_node_mutex is held,
and uses existing core_tpg_del_initiator_node_acl() logic
for shutdown based on struct kref + struct completion.

Also while auditing existing se_node_acl lookup users,
there is one particular case in target-core during session
queue depth change where lookup is completely unnecessary.
Go ahead and drop this pointless lookup in patch #2.

Finally, convert the last two remaining fabric drivers
that once upon a time where using some manner of internal
or quasi internal driver methods for node acl lookup.
Do this for tcm_fc + ib_srpt drivers in patch #3 + #4.

Please review,

--nab

Nicholas Bellinger (4):
  target: Obtain se_node_acl->acl_kref during get_initiator_node_acl
  target: Remove useless set_initiator_node_queue_depth acl lookup
  tcm_fc: Convert acl lookup to modern get_initiator_node_acl usage
  ib_srpt: Convert acl lookup to modern get_initiator_node_acl usage

 drivers/infiniband/ulp/srpt/ib_srpt.c        | 78 ++++++----------------------
 drivers/infiniband/ulp/srpt/ib_srpt.h        |  2 -
 drivers/target/iscsi/iscsi_target_configfs.c |  6 +--
 drivers/target/iscsi/iscsi_target_tpg.c      | 10 ----
 drivers/target/iscsi/iscsi_target_tpg.h      |  2 -
 drivers/target/target_core_tpg.c             | 29 ++++-------
 drivers/target/target_core_transport.c       | 18 ++++---
 drivers/target/tcm_fc/tfc_conf.c             | 26 +++-------
 drivers/target/tcm_fc/tfc_sess.c             | 18 ++++---
 include/target/target_core_fabric.h          |  2 +-
 10 files changed, 61 insertions(+), 130 deletions(-)

-- 
1.9.1

