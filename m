From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 1/3] sas: provide stub implementations for scsi_is_sas_phy and sas_get_address
Date: Mon, 15 Aug 2016 17:12:22 +0200
Message-ID: <f19d5eeb5cc16ce43d3932924105e77210f1daac.1471273623.git.jthumshirn@suse.de>
References: <cover.1471273623.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1471273623.git.jthumshirn@suse.de>
In-Reply-To: <cover.1471273623.git.jthumshirn@suse.de>
References: <cover.1471273623.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Provide stub implementations for scsi_is_sas_phy and sas_get_address
for kernel configurations which do not have CONFIG_SCSI_SAS_ATTRS
defined.

Reported-by: kbuild test robot <lkp@intel.com>
Suggested-by: James Bottomley <jejb@linux.vnet.ibm.com>
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 include/scsi/scsi_transport_sas.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 13c0b2b..0fc648e 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -15,8 +15,20 @@ static inline int is_sas_attached(struct scsi_device *sdev)
 {
 	return 0;
 }
+
+static inline int scsi_is_sas_phy(const struct device *sdev)
+{
+	return 0;
+}
+
+static inline u64 sas_get_address(struct scsi_device *sdev)
+{
+	return 0;
+}
 #else
 extern int is_sas_attached(struct scsi_device *sdev);
+extern int scsi_is_sas_phy(const struct device *);
+u64 sas_get_address(struct scsi_device *);
 #endif
 
 static inline int sas_protocol_ata(enum sas_protocol proto)
@@ -187,9 +199,7 @@ extern struct sas_phy *sas_phy_alloc(struct device *, int);
 extern void sas_phy_free(struct sas_phy *);
 extern int sas_phy_add(struct sas_phy *);
 extern void sas_phy_delete(struct sas_phy *);
-extern int scsi_is_sas_phy(const struct device *);
 
-u64 sas_get_address(struct scsi_device *);
 unsigned int sas_tlr_supported(struct scsi_device *);
 unsigned int sas_is_tlr_enabled(struct scsi_device *);
 void sas_disable_tlr(struct scsi_device *);
-- 
1.8.5.6
