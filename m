From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v4 11/13] [SCSI] sr: check support for device busy class events
Date: Mon, 28 May 2012 13:08:38 +0800
Message-ID: <1338181720-4149-12-git-send-email-ming.m.lin@intel.com>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, David Woodhouse <David.Woodhouse@intel.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Aaron Lu <aaron.lu@amd.com>

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
---
 drivers/scsi/sr.c     |   23 +++++++++++++++++++++++
 drivers/scsi/sr.h     |    1 +
 include/linux/cdrom.h |   43 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5fc97d2..abfefab 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -101,6 +101,7 @@ static DEFINE_MUTEX(sr_ref_mutex);
 static int sr_open(struct cdrom_device_info *, int);
 static void sr_release(struct cdrom_device_info *);
 
+static void check_dbml(struct scsi_cd *);
 static void get_sectorsize(struct scsi_cd *);
 static void get_capabilities(struct scsi_cd *);
 
@@ -728,6 +729,28 @@ static int sr_probe(struct device *dev)
 	return error;
 }
 
+static void check_dbml(struct scsi_cd *cd)
+{
+	struct packet_command cgc;
+	unsigned char buffer[16];
+	struct rm_feature_desc *rfd;
+
+	init_cdrom_command(&cgc, buffer, sizeof(buffer), CGC_DATA_READ);
+	cgc.cmd[0] = GPCMD_GET_CONFIGURATION;
+	cgc.cmd[3] = CDF_RM;
+	cgc.cmd[8] = sizeof(buffer);
+	cgc.quiet = 1;
+
+	if (cd->cdi.ops->generic_packet(&cd->cdi, &cgc))
+		return;
+
+	rfd = (struct rm_feature_desc *)&buffer[sizeof(struct feature_header)];
+	if (be16_to_cpu(rfd->feature_code) != CDF_RM)
+		return;
+
+	if (rfd->dbml)
+		cd->dbml = 1;
+}
 
 static void get_sectorsize(struct scsi_cd *cd)
 {
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 37c8f6b..7cc40ad 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -41,6 +41,7 @@ typedef struct scsi_cd {
 	unsigned readcd_known:1;	/* drive supports READ_CD (0xbe) */
 	unsigned readcd_cdda:1;	/* reading audio data using READ_CD */
 	unsigned media_present:1;	/* media is present */
+	unsigned dbml:1;	/* generates device busy class events */
 
 	/* GET_EVENT spurious event handling, blk layer guarantees exclusion */
 	int tur_mismatch;		/* nr of get_event TUR mismatches */
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index dfd7f18..25f305c 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -727,6 +727,7 @@ struct request_sense {
 /*
  * feature profile
  */
+#define CDF_RM		0x0003	/* "Removeable Medium" */
 #define CDF_RWRT	0x0020	/* "Random Writable" */
 #define CDF_HWDM	0x0024	/* "Hardware Defect Management" */
 #define CDF_MRW 	0x0028
@@ -739,6 +740,48 @@ struct request_sense {
 #define CDM_MRW_BGFORMAT_ACTIVE		2
 #define CDM_MRW_BGFORMAT_COMPLETE	3
 
+/* Removable medium feature descriptor */
+struct rm_feature_desc {
+	__be16 feature_code;
+#if defined(__BIG_ENDIAN_BITFIELD)
+	__u8 reserved1		: 2;
+	__u8 feature_version	: 4;
+	__u8 persistent		: 1;
+	__u8 curr		: 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 curr		: 1;
+	__u8 persistent		: 1;
+	__u8 feature_version	: 4;
+	__u8 reserved1		: 2;
+#endif
+	__u8 add_len;
+#if defined(__BIG_ENDIAN_BITFIELD)
+	__u8 mech_type		: 3;
+	__u8 load		: 1;
+	__u8 eject		: 1;
+	__u8 pvnt_jmpr		: 1;
+	__u8 dbml		: 1;
+	__u8 lock		: 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 lock		: 1;
+	__u8 dbml		: 1;
+	__u8 pvnt_jmpr		: 1;
+	__u8 eject		: 1;
+	__u8 load		: 1;
+	__u8 mech_type		: 3;
+#endif
+	__u8 reserved2;
+	__u8 reserved3;
+	__u8 reserved4;
+};
+
+struct device_busy_event_desc {
+	__u8 device_busy_event	: 4;
+	__u8 reserved1		: 4;
+	__u8 device_busy_status;
+	__u8 time;
+};
+
 /*
  * mrw address spaces
  */
-- 
1.7.2.5
