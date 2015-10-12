From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 01/25] [SCSI] sas: centralise ssp frame information units
Date: Mon, 12 Oct 2015 23:20:13 +0800
Message-ID: <1444663237-238302-2-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
Cc: linux-kernel-u79uwXL29TZ19SzzRMN9sA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The xfer_rdy, command, and task frame's iu structures
are not available in <scsi/sas.h>, but only aic94xx
driver folder.
Add them to include/scsi/sas.h

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
