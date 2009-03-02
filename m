From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 13/18] [PATCH] zfcp: Report fc_host_port_type as NPIV
Date: Mon, 02 Mar 2009 13:09:06 +0100
Message-ID: <20090302121003.769541000@de.ibm.com>
References: <20090302120853.279447000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:46608 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbZCBMKe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 07:10:34 -0500
Content-Disposition: inline; filename=714-zfcp-port-type.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Report the fc_host_port_type as FC_PORTTYPE_NPIV when the subchannel
is running in NPIV mode. This allows to see the correct type with
lsscsi -H -t --list

Acked-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2009-03-01 16:41:34.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2009-03-01 16:41:35.000000000 +0100
@@ -616,9 +616,10 @@ static void zfcp_fsf_exchange_port_evalu
 	if (req->data)
 		memcpy(req->data, bottom, sizeof(*bottom));
 
-	if (adapter->connection_features & FSF_FEATURE_NPIV_MODE)
+	if (adapter->connection_features & FSF_FEATURE_NPIV_MODE) {
 		fc_host_permanent_port_name(shost) = bottom->wwpn;
-	else
+		fc_host_port_type(shost) = FC_PORTTYPE_NPIV;
+	} else
 		fc_host_permanent_port_name(shost) = fc_host_port_name(shost);
 	fc_host_maxframe_size(shost) = bottom->maximum_frame_size;
 	fc_host_supported_speeds(shost) = bottom->supported_speed;

