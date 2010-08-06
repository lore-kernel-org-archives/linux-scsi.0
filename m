From: michaelc@cs.wisc.edu
Subject: [PATCH 1/5] fc class: add fc host default default dev loss setting
Date: Fri,  6 Aug 2010 03:02:37 -0500
Message-ID: <1281081761-24586-2-git-send-email-michaelc@cs.wisc.edu>
References: <1281081761-24586-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760251Ab0HFH7f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Aug 2010 03:59:35 -0400
In-Reply-To: <1281081761-24586-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jeykholt@cisco.com, andrew.vasquez@qlogic.com, giridhar.malavali@qlogic.com, James.Smart@Emulex.Com, brking@us.ibm.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch adds a fc_host setting to store the
default dev_loss_tmo. It is used if the driver
has a callack to get the value from the LLD. If
the callback is not set, then we use the fc class
module default value.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_fc.c |    6 +++++-
 include/scsi/scsi_transport_fc.h |    4 ++++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 0681378..01a5f9b 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2525,7 +2525,11 @@ fc_rport_create(struct Scsi_Host *shost, int channel,
 
 	rport->maxframe_size = -1;
 	rport->supported_classes = FC_COS_UNSPECIFIED;
-	rport->dev_loss_tmo = fc_dev_loss_tmo;
+	if (fci->f->get_host_def_dev_loss_tmo) {
+		fci->f->get_host_def_dev_loss_tmo(shost);
+		rport->dev_loss_tmo = fc_host_def_dev_loss_tmo(shost);
+	} else
+		rport->dev_loss_tmo = fc_dev_loss_tmo;
 	memcpy(&rport->node_name, &ids->node_name, sizeof(rport->node_name));
 	memcpy(&rport->port_name, &ids->port_name, sizeof(rport->port_name));
 	rport->port_id = ids->port_id;
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 87d81b3..9f98fca 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -496,6 +496,7 @@ struct fc_host_attrs {
 	u64 fabric_name;
 	char symbolic_name[FC_SYMBOLIC_NAME_SIZE];
 	char system_hostname[FC_SYMBOLIC_NAME_SIZE];
+	u32 def_dev_loss_tmo;
 
 	/* Private (Transport-managed) Attributes */
 	enum fc_tgtid_binding_type  tgtid_bind_type;
@@ -580,6 +581,8 @@ struct fc_host_attrs {
 	(((struct fc_host_attrs *)(x)->shost_data)->devloss_work_q_name)
 #define fc_host_devloss_work_q(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->devloss_work_q)
+#define fc_host_def_dev_loss_tmo(x) \
+	(((struct fc_host_attrs *)(x)->shost_data)->def_dev_loss_tmo)
 
 
 struct fc_bsg_buffer {
@@ -640,6 +643,7 @@ struct fc_function_template {
 	void	(*get_host_fabric_name)(struct Scsi_Host *);
 	void	(*get_host_symbolic_name)(struct Scsi_Host *);
 	void	(*set_host_system_hostname)(struct Scsi_Host *);
+	void	(*get_host_def_dev_loss_tmo)(struct Scsi_Host *);
 
 	struct fc_host_statistics * (*get_fc_host_stats)(struct Scsi_Host *);
 	void	(*reset_fc_host_stats)(struct Scsi_Host *);
-- 
1.6.6.1

