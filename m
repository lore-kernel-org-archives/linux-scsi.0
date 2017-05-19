From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 06/25] qla2xxx: Reduce excessive debug print during 27xx fwdump.
Date: Fri, 19 May 2017 14:53:25 -0700
Message-ID: <20170519215344.2168-7-himanshu.madhani@cavium.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0041.outbound.protection.outlook.com ([104.47.36.41]:5734
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756806AbdESVyF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 17:54:05 -0400
In-Reply-To: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

Retain loop test for fwdump length exceeding buffer length.

Cc: <stable@vger.kernel.org>
Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c |  8 ++++----
 drivers/scsi/qla2xxx/qla_tmpl.c | 16 +++++++++-------
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f6130e8b1ca1..eaaf73fd23d9 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -6356,8 +6356,8 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
 	    "-> template size %x bytes\n", dlen);
 	if (dlen > risc_size * sizeof(*dcode)) {
 		ql_log(ql_log_warn, vha, 0x0167,
-		    "Failed fwdump template exceeds array by %x bytes\n",
-		    (uint32_t)(dlen - risc_size * sizeof(*dcode)));
+		    "Failed fwdump template exceeds array by %lx bytes\n",
+		    dlen - risc_size * sizeof(*dcode));
 		goto default_template;
 	}
 	ha->fw_dump_template_len = dlen;
@@ -6658,8 +6658,8 @@ qla24xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	    "-> template size %x bytes\n", dlen);
 	if (dlen > risc_size * sizeof(*fwcode)) {
 		ql_log(ql_log_warn, vha, 0x0177,
-		    "Failed fwdump template exceeds array by %x bytes\n",
-		    (uint32_t)(dlen - risc_size * sizeof(*fwcode)));
+		    "Failed fwdump template exceeds array by %lx bytes\n",
+		    dlen - risc_size * sizeof(*fwcode));
 		goto default_template;
 	}
 	ha->fw_dump_template_len = dlen;
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 8a58ef3adab4..2f2633a8c4ad 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -219,8 +219,6 @@ qla27xx_skip_entry(struct qla27xx_fwdt_entry *ent, void *buf)
 {
 	if (buf)
 		ent->hdr.driver_flags |= DRIVER_FLAG_SKIP_ENTRY;
-	ql_dbg(ql_dbg_misc + ql_dbg_verbose, NULL, 0xd011,
-	    "Skipping entry %d\n", ent->hdr.entry_type);
 }
 
 static int
@@ -818,6 +816,8 @@ qla27xx_walk_template(struct scsi_qla_host *vha,
 	ql_dbg(ql_dbg_misc, vha, 0xd01a,
 	    "%s: entry count %lx\n", __func__, count);
 	while (count--) {
+		if (buf && *len >= vha->hw->fw_dump_len)
+			break;
 		if (qla27xx_find_entry(ent->hdr.entry_type)(vha, ent, buf, len))
 			break;
 		ent = qla27xx_next_entry(ent);
@@ -825,18 +825,20 @@ qla27xx_walk_template(struct scsi_qla_host *vha,
 
 	if (count)
 		ql_dbg(ql_dbg_misc, vha, 0xd018,
-		    "%s: residual count (%lx)\n", __func__, count);
+		    "%s: entry residual count (%lx)\n", __func__, count);
 
 	if (ent->hdr.entry_type != ENTRY_TYPE_TMP_END)
 		ql_dbg(ql_dbg_misc, vha, 0xd019,
-		    "%s: missing end (%lx)\n", __func__, count);
+		    "%s: missing end entry (%lx)\n", __func__, count);
 
-	ql_dbg(ql_dbg_misc, vha, 0xd01b,
-	    "%s: len=%lx\n", __func__, *len);
+	if (buf && *len != vha->hw->fw_dump_len)
+		ql_dbg(ql_dbg_misc, vha, 0xd01b,
+		    "%s: length=%#lx residual=%+ld\n",
+		    __func__, *len, vha->hw->fw_dump_len - *len);
 
 	if (buf) {
 		ql_log(ql_log_warn, vha, 0xd015,
-		    "Firmware dump saved to temp buffer (%ld/%p)\n",
+		    "Firmware dump saved to temp buffer (%lu/%p)\n",
 		    vha->host_no, vha->hw->fw_dump);
 		qla2x00_post_uevent_work(vha, QLA_UEVENT_CODE_FW_DUMP);
 	}
-- 
2.12.0
