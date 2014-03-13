From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH] qla2xxx: Fix build errors related to invalid print fields on some architectures.
Date: Thu, 13 Mar 2014 14:16:40 -0400
Message-ID: <1394734600-25067-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:2242 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754653AbaCMSxH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Mar 2014 14:53:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Fixes some build warnings such as:
drivers/scsi/qla2xxx/qla_attr.c:162:6: warning: format '%lx' expects argument of
type 'long unsigned int', but argument 6 has type 'size_t'"
and
drivers/scsi/qla2xxx/qla_init.c:5198:7: warning: format '%lx' expects argument
of type 'long unsigned int', but argument 5 has type 'uint32_t' [-Wformat]

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    6 +++---
 drivers/scsi/qla2xxx/qla_init.c |   12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index aa81829..07befcf 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -159,7 +159,7 @@ qla2x00_sysfs_read_fw_dump_template(struct file *filp, struct kobject *kobj,
 		return 0;
 
 	ql_dbg(ql_dbg_user, vha, 0x70e2,
-	    "chunk <- off=%llx count=%lx\n", off, count);
+	    "chunk <- off=%llx count=%zx\n", off, count);
 	return memory_read_from_buffer(buf, count, &off,
 	    ha->fw_dump_template, ha->fw_dump_template_len);
 }
@@ -200,11 +200,11 @@ qla2x00_sysfs_write_fw_dump_template(struct file *filp, struct kobject *kobj,
 	if (off + count > ha->fw_dump_template_len) {
 		count = ha->fw_dump_template_len - off;
 		ql_dbg(ql_dbg_user, vha, 0x70d3,
-		    "chunk -> truncating to %lx bytes.\n", count);
+		    "chunk -> truncating to %zx bytes.\n", count);
 	}
 
 	ql_dbg(ql_dbg_user, vha, 0x70d4,
-	    "chunk -> off=%llx count=%lx\n", off, count);
+	    "chunk -> off=%llx count=%zx\n", off, count);
 	memcpy(ha->fw_dump_template + off, buf, count);
 
 	if (off + count == ha->fw_dump_template_len) {
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 0a25e8b..38aeb54 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5291,8 +5291,8 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
 	    "-> template size %x bytes\n", dlen);
 	if (dlen > risc_size * sizeof(*dcode)) {
 		ql_log(ql_log_warn, vha, 0x0167,
-		    "Failed fwdump template exceeds array by %lx bytes\n",
-		    dlen - risc_size * sizeof(*dcode));
+		    "Failed fwdump template exceeds array by %x bytes\n",
+		    (uint32_t)(dlen - risc_size * sizeof(*dcode)));
 		goto default_template;
 	}
 	ha->fw_dump_template_len = dlen;
@@ -5558,8 +5558,8 @@ qla24xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	ha->fw_dump_template_len = 0;
 
 	ql_dbg(ql_dbg_init, vha, 0x171,
-	    "Loading fwdump template from %lx\n",
-	    (void *)fwcode - (void *)blob->fw->data);
+	    "Loading fwdump template from %x\n",
+	    (uint32_t)((void *)fwcode - (void *)blob->fw->data));
 	risc_size = be32_to_cpu(fwcode[2]);
 	ql_dbg(ql_dbg_init, vha, 0x172,
 	    "-> array size %x dwords\n", risc_size);
@@ -5593,8 +5593,8 @@ qla24xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	    "-> template size %x bytes\n", dlen);
 	if (dlen > risc_size * sizeof(*fwcode)) {
 		ql_log(ql_log_warn, vha, 0x0177,
-		    "Failed fwdump template exceeds array by %lx bytes\n",
-		    dlen - risc_size * sizeof(*fwcode));
+		    "Failed fwdump template exceeds array by %x bytes\n",
+		    (uint32_t)(dlen - risc_size * sizeof(*fwcode)));
 		goto default_template;
 	}
 	ha->fw_dump_template_len = dlen;
-- 
1.7.7

