From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 21/22] zfcp: Activate fc4s attributes for zfcp in FC transport class
Date: Tue, 24 Nov 2009 16:54:17 +0100
Message-ID: <20091124160139.089614000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:59809 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933259AbZKXQBe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:01:34 -0500
Content-Disposition: inline; filename=721-zfcp-fc4s-attributes.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Enable the display of supported and active fc4s for zfcp in the FC
transport class. zfcp only supports FCP, so simply hard-code this
information.  The zfcp hbaapi already has this information hardcoded,
but this would allow to switch from the coding in the zfcp hbaapi to
the common FC transport attributes in the future.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c  |    2 ++
 drivers/s390/scsi/zfcp_scsi.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/s390/scsi/zfcp_fsf.c	2009-11-24 12:36:57.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-11-24 12:37:01.000000000 +0100
@@ -495,6 +495,8 @@ static int zfcp_fsf_exchange_config_eval
 	fc_host_port_id(shost) = ntoh24(bottom->s_id);
 	fc_host_speed(shost) = bottom->fc_link_speed;
 	fc_host_supported_classes(shost) = FC_COS_CLASS2 | FC_COS_CLASS3;
+	fc_host_supported_fc4s(shost)[2] = 1; /* FCP */
+	fc_host_active_fc4s(shost)[2] = 1; /* FCP */
 
 	adapter->hydra_version = bottom->adapter_type;
 	adapter->timer_ticks = bottom->timer_interval;
--- a/drivers/s390/scsi/zfcp_scsi.c	2009-11-24 12:36:58.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-11-24 12:37:01.000000000 +0100
@@ -643,6 +643,7 @@ struct fc_function_template zfcp_transpo
 	.show_host_port_name = 1,
 	.show_host_permanent_port_name = 1,
 	.show_host_supported_classes = 1,
+	.show_host_supported_fc4s = 1,
 	.show_host_supported_speeds = 1,
 	.show_host_maxframe_size = 1,
 	.show_host_serial_number = 1,
@@ -652,6 +653,7 @@ struct fc_function_template zfcp_transpo
 	.get_host_port_state = zfcp_get_host_port_state,
 	.terminate_rport_io = zfcp_scsi_terminate_rport_io,
 	.show_host_port_state = 1,
+	.show_host_active_fc4s = 1,
 	.bsg_request = zfcp_fc_exec_bsg_job,
 	/* no functions registered for following dynamic attributes but
 	   directly set by LLDD */

