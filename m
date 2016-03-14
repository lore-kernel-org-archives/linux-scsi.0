From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2] scsi_transport_sas: add 'scsi_target_id' sysfs attribute
Date: Mon, 14 Mar 2016 10:43:08 +0100
Message-ID: <1457948588-14558-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbcCNJnO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2016 05:43:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Manoj Kumar <manoj@linux.vnet.ibm.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

There is no way to detect the scsi_target_id for any given SAS
remote port, so add a new sysfs attribute 'scsi_target_id'.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_sas_internal.h  | 2 +-
 drivers/scsi/scsi_transport_sas.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sas_internal.h b/drivers/scsi/scsi_sas_internal.h
index 6266a5d..e659912 100644
--- a/drivers/scsi/scsi_sas_internal.h
+++ b/drivers/scsi/scsi_sas_internal.h
@@ -4,7 +4,7 @@
 #define SAS_HOST_ATTRS		0
 #define SAS_PHY_ATTRS		17
 #define SAS_PORT_ATTRS		1
-#define SAS_RPORT_ATTRS		7
+#define SAS_RPORT_ATTRS		8
 #define SAS_END_DEV_ATTRS	5
 #define SAS_EXPANDER_ATTRS	7
 
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 80520e2..b6f958193 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1286,6 +1286,7 @@ sas_rphy_protocol_attr(identify.target_port_protocols, target_port_protocols);
 sas_rphy_simple_attr(identify.sas_address, sas_address, "0x%016llx\n",
 		unsigned long long);
 sas_rphy_simple_attr(identify.phy_identifier, phy_identifier, "%d\n", u8);
+sas_rphy_simple_attr(scsi_target_id, scsi_target_id, "%d\n", u32);
 
 /* only need 8 bytes of data plus header (4 or 8) */
 #define BUF_SIZE 64
@@ -1886,6 +1887,7 @@ sas_attach_transport(struct sas_function_template *ft)
 	SETUP_RPORT_ATTRIBUTE(rphy_device_type);
 	SETUP_RPORT_ATTRIBUTE(rphy_sas_address);
 	SETUP_RPORT_ATTRIBUTE(rphy_phy_identifier);
+	SETUP_RPORT_ATTRIBUTE(rphy_scsi_target_id);
 	SETUP_OPTIONAL_RPORT_ATTRIBUTE(rphy_enclosure_identifier,
 				       get_enclosure_identifier);
 	SETUP_OPTIONAL_RPORT_ATTRIBUTE(rphy_bay_identifier,
-- 
1.8.5.6

