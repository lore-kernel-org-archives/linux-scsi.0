From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 02/15] zfcp: Enable auto-port discovery for NPIV.
Date: Fri, 17 Apr 2009 15:08:02 +0200
Message-ID: <20090417131122.090598000@de.ibm.com>
References: <20090417130800.923944000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:35499 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760778AbZDQNLu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 09:11:50 -0400
Content-Disposition: inline; filename=701-zfcp-port-discovery.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Since we're setting the host port type now to FC_PORTTYPE_NPIV
for adapters running in NPIV mode we should allow this port type
for auto-port scanning as well.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_fc.c	2009-04-17 15:03:22.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-04-17 15:03:31.000000000 +0200
@@ -637,7 +637,8 @@ int zfcp_scan_ports(struct zfcp_adapter 
 	max_entries = chain ? ZFCP_GPN_FT_MAX_ENTRIES : ZFCP_GPN_FT_ENTRIES;
 	max_bytes = chain ? ZFCP_GPN_FT_MAX_SIZE : ZFCP_CT_SIZE_ONE_PAGE;
 
-	if (fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPORT)
+	if (fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPORT &&
+	    fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPIV)
 		return 0;
 
 	ret = zfcp_wka_port_get(&adapter->nsp);

