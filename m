From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH] libsas: Don't issue commands to devices that have beenhot-removed
Date: Sun, 3 Oct 2010 09:49:19 +0800
Message-ID: <F7E470F880E7484FB0B89C9042473E86@usish.com.cn>
References: <20101001205547.30032.38448.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:41081 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0JDBrY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Oct 2010 21:47:24 -0400
In-Reply-To: <20101001205547.30032.38448.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Williams' <dan.j.williams@intel.com>, james.bottomley@suse.de
Cc: 'Haipao Fan' <haipao.fan@intel.com>, linux-scsi@vger.kernel.org, 'Jeff Garzik' <jeff@garzik.org>, 'Maciej Trela' <maciej.trela@intel.com>, 'Patrick Thomson' <patrick.s.thomson@intel.com>, 'Jeff Skirvin' <jeffrey.d.skirvin@intel.com>, 'Brian King' <brking@linux.vnet.ibm.com>, "'Darrick J. Wong'" <djwong@us.ibm.com>

[PATCH] libsas: Don't issue commands to devices that have beenhot-removed

From: Darrick J. Wong <djwong@us.ibm.com>

sd will get hung up issuing commands to flush write cache if a SAS
device behind the expander is unplugged without warning.  Change libsas
to reject commands to domain devices that have already gone away.

[maciej.trela@intel.com: removed setting ->gone in sas_deform_port() to
 permit sync cache commands at module removal]

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
linux-scsi-reference: <20071204223516.GA6767@tree.beaverton.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: Patrick Thomson <patrick.s.thomson@intel.com>
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Tested-by: Haipao Fan <haipao.fan@intel.com>
Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_ata.c       |    4 ++++
 drivers/scsi/libsas/sas_expander.c  |    3 +++
 drivers/scsi/libsas/sas_scsi_host.c |    7 +++++++
 include/scsi/libsas.h               |    1 +
 4 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 042153c..da2e740 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -162,6 +162,10 @@ static unsigned int sas_ata_qc_issue(struct
ata_queued_cmd *qc)
 	unsigned int xfer = 0;
 	unsigned int si;
 
+	/* If the device fell off, no sense in issuing commands */
+	if (dev->gone)
+		return AC_ERR_SYSTEM;
+
 	task = sas_alloc_task(GFP_ATOMIC);
 	if (!task)
 		return AC_ERR_SYSTEM;
diff --git a/drivers/scsi/libsas/sas_expander.c
b/drivers/scsi/libsas/sas_expander.c
index 83dd507..61d81f8 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1724,6 +1724,7 @@ static void sas_unregister_ex_tree(struct
domain_device *dev)
 	struct domain_device *child, *n;
 
 	list_for_each_entry_safe(child, n, &ex->children, siblings) {
+		child->gone = 1;
 		if (child->dev_type == EDGE_DEV ||
 		    child->dev_type == FANOUT_DEV)
 			sas_unregister_ex_tree(child);
@@ -1744,6 +1745,7 @@ static void sas_unregister_devs_sas_addr(struct
domain_device *parent,
 			&ex_dev->children, siblings) {
 			if (SAS_ADDR(child->sas_addr) ==
 			    SAS_ADDR(phy->attached_sas_addr)) {
+				child->gone = 1;
 				if (child->dev_type == EDGE_DEV ||
 				    child->dev_type == FANOUT_DEV)
 					sas_unregister_ex_tree(child);
@@ -1752,6 +1754,7 @@ static void sas_unregister_devs_sas_addr(struct
domain_device *parent,
 				break;
 			}
 		}
+		parent->gone = 1;
 		sas_disable_routing(parent, phy->attached_sas_addr);
 	}
 	memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c
b/drivers/scsi/libsas/sas_scsi_host.c
index f0cfba9..1787bd2 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -228,6 +228,13 @@ int sas_queuecommand(struct scsi_cmnd *cmd,
 			goto out;
 		}
 
+		/* If the device fell off, no sense in issuing commands */
+		if (dev->gone) {
+			cmd->result = DID_BAD_TARGET << 16;
+			scsi_done(cmd);
+			goto out;
+		}
+
 		res = -ENOMEM;
 		task = sas_create_task(cmd, dev, GFP_ATOMIC);
 		if (!task)
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index d06e13b..3dec194 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -205,6 +205,7 @@ struct domain_device {
         };
 
         void *lldd_dev;
+	int gone;
 };
 
[Jack]This one looks good to me! Thanks

