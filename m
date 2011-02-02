From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/4] target: Move backend memory release to configfs_item_operations->release()
Date: Wed,  2 Feb 2011 00:26:47 -0800
Message-ID: <1296635211-6269-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm15-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.236]:22251 "HELO
	nm15-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753395Ab1BBI0r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Feb 2011 03:26:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>, Fubo Chen <fubo.chen@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This series addresses four scenarios in backend HBA/DEV target_core_configfs.c
code where config_item_put() being called upon the following TCM config_groups:

	struct se_hba->hba_group

	struct se_subsystem_dev->se_dev_group

	struct t10_alua_lu_gp->lu_gp_group

	struct t10_alua_tg_pt_gp->tg_pt_gp_group

and subsequently releasing memory of these four parent TCM data structures
is causing a number of SLUB 'Poison overwritten' warnings during slub_debug=FPUZ
testing with .38-rc2 code.

This series addresses the issue by using moving existing release logic
of the parent structure containing a struct_config_group into it's own
seperate struct configfs_item_operations->release() callback.

Please review and comment,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (4):
  target: Move core_delete_hba() into ->release() callback
  target: Move subdev release logic into ->release() callback
  target: Move core_alua_free_lu_gp() into ->release() callback
  target: Move core_alua_free_tg_pt_gp() into ->release() callback

 drivers/target/target_core_configfs.c |  114 +++++++++++++++++++++------------
 1 files changed, 73 insertions(+), 41 deletions(-)

