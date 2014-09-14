From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: qla2xxx: qla_gs.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 14 Sep 2014 23:43:49 +0200
Message-ID: <1410731029-18031-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/qla2xxx/qla_gs.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index a0df3b1..03e3276 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1300,8 +1300,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	/* Manufacturer. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_HBA_MANUFACTURER);
-	alen = strlen(QLA2XXX_MANUFACTURER);
-	strncpy(eiter->a.manufacturer, QLA2XXX_MANUFACTURER, alen + 1);
+	alen = strlcpy(eiter->a.manufacturer, QLA2XXX_MANUFACTURER,
+			sizeof(eiter->a.manufacturer));
 	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
@@ -1325,8 +1325,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	/* Model name. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_HBA_MODEL);
-	strcpy(eiter->a.model, ha->model_number);
-	alen = strlen(eiter->a.model);
+	alen = strlcpy(eiter->a.model, ha->model_number,
+					sizeof(eiter->a.model));
 	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
@@ -1337,8 +1337,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	/* Model description. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_HBA_MODEL_DESCRIPTION);
-	strncpy(eiter->a.model_desc, ha->model_desc, 80);
-	alen = strlen(eiter->a.model_desc);
+	alen = strlcpy(eiter->a.model_desc, ha->model_desc,
+			sizeof(eiter->a.model_desc));
 	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
@@ -1349,8 +1349,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	/* Hardware version. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_HBA_HARDWARE_VERSION);
-	strcpy(eiter->a.hw_version, ha->adapter_id);
-	alen = strlen(eiter->a.hw_version);
+	alen = strlcpy(eiter->a.hw_version, ha->adapter_id,
+					sizeof(eiter->a.hw_version));
 	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
@@ -1361,8 +1361,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	/* Driver version. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_HBA_DRIVER_VERSION);
-	strcpy(eiter->a.driver_version, qla2x00_version_str);
-	alen = strlen(eiter->a.driver_version);
+	alen = strlcpy(eiter->a.driver_version, qla2x00_version_str,
+			sizeof(eiter->a.driver_version));
 	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
@@ -1373,8 +1373,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	/* Option ROM version. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_HBA_OPTION_ROM_VERSION);
-	strcpy(eiter->a.orom_version, "0.00");
-	alen = strlen(eiter->a.orom_version);
+	alen = strlcpy(eiter->a.orom_version, "0.00",
+				sizeof(eiter->a.orom_version));
 	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
@@ -1614,8 +1614,8 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 	/* OS device name. */
 	eiter = (struct ct_fdmi_port_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_PORT_OS_DEVICE_NAME);
-	alen = strlen(QLA2XXX_DRIVER_NAME);
-	strncpy(eiter->a.os_dev_name, QLA2XXX_DRIVER_NAME, alen + 1);
+	alen = strlcpy(eiter->a.os_dev_name, QLA2XXX_DRIVER_NAME,
+			sizeof(eiter->a.os_dev_name));
 	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
@@ -1629,9 +1629,9 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 		    __constant_cpu_to_be32(FDMI_PORT_ATTR_COUNT);
 		eiter = (struct ct_fdmi_port_attr *) (entries + size);
 		eiter->type = __constant_cpu_to_be16(FDMI_PORT_HOST_NAME);
-		snprintf(eiter->a.host_name, sizeof(eiter->a.host_name),
-		    "%s", fc_host_system_hostname(vha->host));
-		alen = strlen(eiter->a.host_name);
+		alen = strlcpy(eiter->a.host_name,
+					fc_host_system_hostname(vha->host),
+					sizeof(eiter->a.host_name));
 		alen += (alen & 3) ? (4 - (alen & 3)) : 4;
 		eiter->len = cpu_to_be16(4 + alen);
 		size += 4 + alen;
-- 
1.7.10.4
