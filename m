From: Jordan Hargrave <jharg93@gmail.com>
Subject: [PATCH] Remove check for SAS expander when querying bay/enclosure IDs.
Date: Mon, 13 Jul 2015 09:27:33 -0500
Message-ID: <1436797653-9822-1-git-send-email-jordan_hargrave@dell.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jbottomley@odin.com, jordan_hargrave@dell.com
List-Id: linux-scsi@vger.kernel.org

Dell Server backplanes can report bay/enclosure IDs without an
expander present.  This patch allows the bay/enclosure IDs to be
propagaged to sysfs.we

Signed-off-by: Jordan Hargrave <jordan_hargrave@dell.com>
---
 drivers/scsi/scsi_transport_sas.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 9a05819..30d26e3 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1222,13 +1222,6 @@ show_sas_rphy_enclosure_identifier(struct device *dev,
 	u64 identifier;
 	int error;
 
-	/*
-	 * Only devices behind an expander are supported, because the
-	 * enclosure identifier is a SMP feature.
-	 */
-	if (scsi_is_sas_phy_local(phy))
-		return -EINVAL;
-
 	error = i->f->get_enclosure_identifier(rphy, &identifier);
 	if (error)
 		return error;
@@ -1248,9 +1241,6 @@ show_sas_rphy_bay_identifier(struct device *dev,
 	struct sas_internal *i = to_sas_internal(shost->transportt);
 	int val;
 
-	if (scsi_is_sas_phy_local(phy))
-		return -EINVAL;
-
 	val = i->f->get_bay_identifier(rphy);
 	if (val < 0)
 		return val;
-- 
1.9.1
