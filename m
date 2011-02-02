From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/5] Move fabric configfs memory release to configfs_item_operations->release()
Date: Wed,  2 Feb 2011 03:10:41 -0800
Message-ID: <1296645046-7076-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:24327 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752125Ab1BBLKh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Feb 2011 06:10:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>, Fubo Chen <fubo.chen@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This followup series addresses five scenarios in generic target_core_fabric_configfs.c
code where config_item_put() being called upon the following fabric groups with
struct configfs_group_operations->drop_item() directly releasing struct
config_group memory is causing a number of SLUB 'Poison overwritten' warnings
during testing with .38-rc2.

	struct se_wwn->wwn_group

	struct se_portal_group->tpg_group

	struct se_node_acl->acl_group

	struct se_tpg_np->tpg_np_group

	struct se_lun_acl->se_lun_group

As with the earlier series, these patches address the issue by using moving
existing release logic of the parent structures containing a struct config_group
into their own seperate struct configfs_item_operations->release() callbacks.

The first four patches are for struct target_core_fabric_ops cases where
se_wwn, se_portal_group, se_node_acl and se_tpg_np memory is presented from
target fabric module memory.  The fifth patch is for struct se_lun_acl memory
which is internal to target_core_fabric_configfs.c and not accessed directly
by target fabric module code.

These patches resolve the existing slub_debug=FPUZ warnings/errors that
I have encountered with generic /sys/kernel/config/target/$FABRIC_MOD ops,
so please test, review and comment.

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (5):
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

 drivers/target/target_core_fabric_configfs.c |   93 +++++++++++++++++++-------
 include/target/target_core_base.h            |    1 +
 2 files changed, 69 insertions(+), 25 deletions(-)

