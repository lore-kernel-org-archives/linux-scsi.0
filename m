From: John Garry <john.garry@huawei.com>
Subject: [PATCH v5 01/32] [SCSI] sas: centralise ssp frame information units
Date: Wed, 18 Nov 2015 00:50:28 +0800
Message-ID: <1447779059-136143-2-git-send-email-john.garry@huawei.com>
References: <1447779059-136143-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447779059-136143-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, john.garry@huawei.com
List-Id: linux-scsi@vger.kernel.org

The xfer_rdy, command, and task frame's iu structures
are not available in <scsi/sas.h>, but only aic94xx
driver folder.
Add them to include/scsi/sas.h

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/aic94xx/aic94xx_sas.h | 49 ++++---------------------
 include/scsi/sas.h                 | 74 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_sas.h b/drivers/scsi/aic94xx/aic94xx_sas.h
index 912e6b7..101072c 100644
--- a/drivers/scsi/aic94xx/aic94xx_sas.h
+++ b/drivers/scsi/aic94xx/aic94xx_sas.h
@@ -327,46 +327,9 @@ struct scb_header {
 
 #define LUN_SIZE                8
 
-/* See SAS spec, task IU
- */
-struct ssp_task_iu {
-	u8     lun[LUN_SIZE];	  /* BE */
-	u16    _r_a;
-	u8     tmf;
-	u8     _r_b;
-	__be16 tag;		  /* BE */
-	u8     _r_c[14];
-} __attribute__ ((packed));
-
-/* See SAS spec, command IU
- */
-struct ssp_command_iu {
-	u8     lun[LUN_SIZE];
-	u8     _r_a;
-	u8     efb_prio_attr;	  /* enable first burst, task prio & attr */
-#define EFB_MASK        0x80
-#define TASK_PRIO_MASK	0x78
-#define TASK_ATTR_MASK  0x07
-
-	u8    _r_b;
-	u8     add_cdb_len;	  /* in dwords, since bit 0,1 are reserved */
-	union {
-		u8     cdb[16];
-		struct {
-			__le64 long_cdb_addr;	  /* bus address, LE */
-			__le32 long_cdb_size;	  /* LE */
-			u8     _r_c[3];
-			u8     eol_ds;		  /* eol:6,6, ds:5,4 */
-		} long_cdb;	  /* sequencer extension */
-	};
-} __attribute__ ((packed));
-
-struct xfer_rdy_iu {
-	__be32 requested_offset;  /* BE */
-	__be32 write_data_len;	  /* BE */
-	__be32 _r_a;
-} __attribute__ ((packed));
-
+#define EFB_MASK                0x80
+#define TASK_PRIO_MASK          0x78
+#define TASK_ATTR_MASK          0x07
 /* ---------- SCB tasks ---------- */
 
 /* This is both ssp_task and long_ssp_task
@@ -511,7 +474,7 @@ struct abort_task {
 	u8     proto_conn_rate;
 	__le32 _r_a;
 	struct ssp_frame_hdr ssp_frame;
-	struct ssp_task_iu ssp_task;
+	struct ssp_tmf_iu ssp_task;
 	__le16 sister_scb;
 	__le16 conn_handle;
 	u8     flags;	  /* ovrd_itnl_timer:3,3, suspend_data_trans:2,2 */
@@ -549,7 +512,7 @@ struct clear_nexus {
 	u8     _r_b[3];
 	u8     conn_mask;
 	u8     _r_c[19];
-	struct ssp_task_iu ssp_task; /* LUN and TAG */
+	struct ssp_tmf_iu ssp_task; /* LUN and TAG */
 	__le16 _r_d;
 	__le16 conn_handle;
 	__le64 _r_e;
@@ -562,7 +525,7 @@ struct initiate_ssp_tmf {
 	u8     proto_conn_rate;
 	__le32 _r_a;
 	struct ssp_frame_hdr ssp_frame;
-	struct ssp_task_iu ssp_task;
+	struct ssp_tmf_iu ssp_task;
 	__le16 sister_scb;
 	__le16 conn_handle;
 	u8     flags;	  /* itnl override and suspend data tx */
diff --git a/include/scsi/sas.h b/include/scsi/sas.h
index 0d2607d..42a84ef 100644
--- a/include/scsi/sas.h
+++ b/include/scsi/sas.h
@@ -344,6 +344,43 @@ struct ssp_response_iu {
 	u8     sense_data[0];
 } __attribute__ ((packed));
 
+struct ssp_command_iu {
+	u8     lun[8];
+	u8     _r_a;
+
+	union {
+		struct {
+			u8  attr:3;
+			u8  prio:4;
+			u8  efb:1;
+		};
+		u8 efb_prio_attr;
+	};
+
+	u8    _r_b;
+
+	u8    _r_c:2;
+	u8    add_cdb_len:6;
+
+	u8    cdb[16];
+	u8    add_cdb[0];
+} __attribute__ ((packed));
+
+struct xfer_rdy_iu {
+	__be32 requested_offset;
+	__be32 write_data_len;
+	__be32 _r_a;
+} __attribute__ ((packed));
+
+struct ssp_tmf_iu {
+	u8     lun[8];
+	u16    _r_a;
+	u8     tmf;
+	u8     _r_b;
+	__be16 tag;
+	u8     _r_c[14];
+} __attribute__ ((packed));
+
 /* ---------- SMP ---------- */
 
 struct report_general_resp {
@@ -538,6 +575,43 @@ struct ssp_response_iu {
 	u8     sense_data[0];
 } __attribute__ ((packed));
 
+struct ssp_command_iu {
+	u8     lun[8];
+	u8     _r_a;
+
+	union {
+		struct {
+			u8  efb:1;
+			u8  prio:4;
+			u8  attr:3;
+		};
+		u8 efb_prio_attr;
+	};
+
+	u8    _r_b;
+
+	u8    add_cdb_len:6;
+	u8    _r_c:2;
+
+	u8    cdb[16];
+	u8    add_cdb[0];
+} __attribute__ ((packed));
+
+struct xfer_rdy_iu {
+	__be32 requested_offset;
+	__be32 write_data_len;
+	__be32 _r_a;
+} __attribute__ ((packed));
+
+struct ssp_tmf_iu {
+	u8     lun[8];
+	u16    _r_a;
+	u8     tmf;
+	u8     _r_b;
+	__be16 tag;
+	u8     _r_c[14];
+} __attribute__ ((packed));
+
 /* ---------- SMP ---------- */
 
 struct report_general_resp {
-- 
1.9.1
