From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 10/11] zfcp: Replace FC4 constants with information from exchange port
Date: Wed, 17 Feb 2010 11:18:58 +0100
Message-ID: <20100217102019.191780000@de.ibm.com>
References: <20100217101848.662299000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.17.166]:37457 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab0BQKUY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2010 05:20:24 -0500
Content-Disposition: inline; filename=710-zfcp-fc4-constants.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The FC4 types are already available from exchange port.  Use this for
reporting the FC4 types, instead of having the value hardcoded in
zfcp.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2010-02-16 09:43:32.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2010-02-16 09:43:32.000000000 +0100
@@ -491,8 +491,6 @@ static int zfcp_fsf_exchange_config_eval
 	fc_host_port_id(shost) = ntoh24(bottom->s_id);
 	fc_host_speed(shost) = bottom->fc_link_speed;
 	fc_host_supported_classes(shost) = FC_COS_CLASS2 | FC_COS_CLASS3;
-	fc_host_supported_fc4s(shost)[2] = 1; /* FCP */
-	fc_host_active_fc4s(shost)[2] = 1; /* FCP */
 
 	adapter->hydra_version = bottom->adapter_type;
 	adapter->timer_ticks = bottom->timer_interval;
@@ -615,6 +613,10 @@ static void zfcp_fsf_exchange_port_evalu
 		fc_host_permanent_port_name(shost) = fc_host_port_name(shost);
 	fc_host_maxframe_size(shost) = bottom->maximum_frame_size;
 	fc_host_supported_speeds(shost) = bottom->supported_speed;
+	memcpy(fc_host_supported_fc4s(shost), bottom->supported_fc4_types,
+	       FC_FC4_LIST_SIZE);
+	memcpy(fc_host_active_fc4s(shost), bottom->active_fc4_types,
+	       FC_FC4_LIST_SIZE);
 }
 
 static void zfcp_fsf_exchange_port_data_handler(struct zfcp_fsf_req *req)

