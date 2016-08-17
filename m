From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v4 1/3] sas: provide stub implementation for scsi_is_sas_rphy
Date: Wed, 17 Aug 2016 11:46:16 +0200
Message-ID: <edbb4203c20358efe87d68cd9697d3e3cb8d0cca.1471426748.git.jthumshirn@suse.de>
References: <cover.1471426748.git.jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbcHQJqV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Aug 2016 05:46:21 -0400
In-Reply-To: <cover.1471426748.git.jthumshirn@suse.de>
In-Reply-To: <cover.1471426748.git.jthumshirn@suse.de>
References: <cover.1471426748.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>

Provide a stub implementation for scsi_is_sas_rphy for kernel
configurations which do not have CONFIG_SCSI_SAS_ATTRS defined.

Reported-by: kbuild test robot <lkp@intel.com>
Suggested-by: James Bottomley <jejb@linux.vnet.ibm.com>
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 include/scsi/scsi_transport_sas.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 13c0b2b..31ae074 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -15,8 +15,14 @@ static inline int is_sas_attached(struct scsi_device *sdev)
 {
 	return 0;
 }
+
+static inline int scsi_is_sas_rphy(const struct device *sdev)
+{
+	return 0;
+}
 #else
 extern int is_sas_attached(struct scsi_device *sdev);
+extern int scsi_is_sas_rphy(const struct device *);
 #endif
 
 static inline int sas_protocol_ata(enum sas_protocol proto)
@@ -202,7 +208,6 @@ extern int sas_rphy_add(struct sas_rphy *);
 extern void sas_rphy_remove(struct sas_rphy *);
 extern void sas_rphy_delete(struct sas_rphy *);
 extern void sas_rphy_unlink(struct sas_rphy *);
-extern int scsi_is_sas_rphy(const struct device *);
 
 struct sas_port *sas_port_alloc(struct device *, int);
 struct sas_port *sas_port_alloc_num(struct device *);
-- 
1.8.5.6

