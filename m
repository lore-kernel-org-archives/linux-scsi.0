From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 6/8] zfcp: Add port_state attribute to sysfs
Date: Tue, 10 Jun 2008 18:20:59 +0200
Message-ID: <20080610162517.622082000@de.ibm.com>
References: <20080610162053.144590000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:35921 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbYFJQZ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2008 12:25:58 -0400
Content-Disposition: inline; filename=port_state.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Sven Schuetz <sven@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Sven Schuetz <sven@linux.vnet.ibm.com>

The sysfs attribute /sys/class/fc_host/hostX/port_state was not set by
zfcp so far.

Now, the appropriate members of the fc_function_template struct are
set during its initialziation. The first is a boolean to show the port
state. The second is a function pointer to the function
zfcp_get_host_port_state, which reads the port state from our adapter
status bits and calls fc_host_port_state with the approriate port
state afterwards.

Signed-off-by: Sven Schuetz <sven@linux.vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_scsi.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/s390/scsi/zfcp_scsi.c	2008-06-04 14:27:47.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-06-04 14:28:16.000000000 +0200
@@ -704,6 +704,23 @@ zfcp_reset_fc_host_stats(struct Scsi_Hos
 	}
 }
 
+static void zfcp_get_host_port_state(struct Scsi_Host *shost)
+{
+	struct zfcp_adapter *adapter =
+		(struct zfcp_adapter *)shost->hostdata[0];
+	int status = atomic_read(&adapter->status);
+
+	if ((status & ZFCP_STATUS_COMMON_RUNNING) &&
+	    !(status & ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED))
+		fc_host_port_state(shost) = FC_PORTSTATE_ONLINE;
+	else if (status & ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED)
+		fc_host_port_state(shost) = FC_PORTSTATE_LINKDOWN;
+	else if (status & ZFCP_STATUS_COMMON_ERP_FAILED)
+		fc_host_port_state(shost) = FC_PORTSTATE_ERROR;
+	else
+		fc_host_port_state(shost) = FC_PORTSTATE_UNKNOWN;
+}
+
 static void zfcp_set_rport_dev_loss_tmo(struct fc_rport *rport, u32 timeout)
 {
 	rport->dev_loss_tmo = timeout;
@@ -726,6 +743,8 @@ struct fc_function_template zfcp_transpo
 	.get_fc_host_stats = zfcp_get_fc_host_stats,
 	.reset_fc_host_stats = zfcp_reset_fc_host_stats,
 	.set_rport_dev_loss_tmo = zfcp_set_rport_dev_loss_tmo,
+	.get_host_port_state = zfcp_get_host_port_state,
+	.show_host_port_state = 1,
 	/* no functions registered for following dynamic attributes but
 	   directly set by LLDD */
 	.show_host_port_type = 1,

-- 
