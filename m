From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 0/4] target: Close se_node_acl lookup race
Date: Sun, 10 Jan 2016 20:28:40 +0000
Message-ID: <1452457724-10629-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33532 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265AbcAJUay (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jan 2016 15:30:54 -0500
Received: by mail-oi0-f49.google.com with SMTP id w75so9597188oie.0
        for <linux-scsi@vger.kernel.org>; Sun, 10 Jan 2016 12:30:53 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This -v2 series addresses a long standing race between
fabric driver se_node_acl lookup + pointer dereference
during session login, and when kref_get() of ->acl_kref
actually happens within __transport_register_session()
code. 

Also as reported earlier by HCH, go ahead and convert
core_tpg_set_initiator_node_queue_depth() to use proper
se_node_acl->se_acl_list -> se_session dereference,
following how core_tpg_del_initiator_node_acl() works
for invoking explicit session shutdown.

Please review,

--nab

-v2 changes:
  - Have tcm_fc/ib_srpt conversion preceed other changes
  - Fix demo-mode acl regression with generate_node_acls=1
  - Fix set_initiator_node_queue_depth session reference
    usage.
  - Add ib_srpt hack to avoid potential user-space
    backwards-compat issue.

Nicholas Bellinger (4):
  tcm_fc: Convert acl lookup to modern get_initiator_node_acl usage
  ib_srpt: Convert acl lookup to modern get_initiator_node_acl usage
  target: Fix change depth se_session reference usage
  target: Obtain se_node_acl->acl_kref during get_initiator_node_acl

 drivers/infiniband/ulp/srpt/ib_srpt.c        |  95 +++++-----------
 drivers/infiniband/ulp/srpt/ib_srpt.h        |   2 -
 drivers/target/iscsi/iscsi_target_configfs.c |  14 ++-
 drivers/target/iscsi/iscsi_target_tpg.c      |  10 --
 drivers/target/iscsi/iscsi_target_tpg.h      |   2 -
 drivers/target/target_core_tpg.c             | 161 +++++++++++----------------
 drivers/target/target_core_transport.c       |  22 ++--
 drivers/target/tcm_fc/tfc_conf.c             |  26 ++---
 drivers/target/tcm_fc/tfc_sess.c             |  18 +--
 include/target/target_core_fabric.h          |   4 +-
 10 files changed, 137 insertions(+), 217 deletions(-)

-- 
1.9.1

