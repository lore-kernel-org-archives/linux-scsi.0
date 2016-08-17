From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v3 1/3] sas: provide stub implementation for scsi_is_sas_rphy
Date: Wed, 17 Aug 2016 10:40:02 +0200
Message-ID: <9ff63d3df2286ad79b32bea6be0b3fb94cf67a53.1471423022.git.jthumshirn@suse.de>
References: <cover.1471423022.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1471423022.git.jthumshirn@suse.de>
In-Reply-To: <cover.1471423022.git.jthumshirn@suse.de>
References: <cover.1471423022.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Provide a stub implementation for scsi_is_sas_rphy for kernel
configurations which do not have CONFIG_SCSI_SAS_ATTRS defined.

Reported-by: kbuild test robot <lkp@intel.com>
Suggested-by: James Bottomley <jejb@linux.vnet.ibm.com>
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 include/scsi/scsi_transport_sas.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 13c0b2b..8d0d2fb 100644
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
@@ -187,7 +193,6 @@ extern struct sas_phy *sas_phy_alloc(struct device *, int);
 extern void sas_phy_free(struct sas_phy *);
 extern int sas_phy_add(struct sas_phy *);
 extern void sas_phy_delete(struct sas_phy *);
-extern int scsi_is_sas_phy(const struct device *);
 
 u64 sas_get_address(struct scsi_device *);
 unsigned int sas_tlr_supported(struct scsi_device *);
-- 
1.8.5.6
