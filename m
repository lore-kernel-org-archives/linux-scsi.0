From: Laurence Oberman <loberman@redhat.com>
Subject: [PATCH ] tcm_qla2xxx - Enhancements to the tcm_debug jammer code to
 jam only data movement commands
Date: Thu, 22 Dec 2016 16:46:02 -0500 (EST)
Message-ID: <416360573.9077781.1482443162576.JavaMail.zimbra@redhat.com>
References: <1631152442.9077031.1482442562064.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:44301 "EHLO
        mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758367AbcLVVqG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Dec 2016 16:46:06 -0500
In-Reply-To: <1631152442.9077031.1482442562064.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, nab <nab@daterainc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello Himanshu and Nicholas,

Was going over my patches and remembered this one got lost.

Himanshu, you acked this already at some point.
Nicholas can we get this on next submission maybe.

Thanks
Laurence

Added the possibility of blocking only specific SCSI data movement commands
but allowing TUR'S to pass.
This has been helpful for debugging many driver/array interoperabilty
issues.

Folded documentation and code into single patch now

Tested by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Laurence Oberman <loberman@redhat.com>

 Documentation/scsi/tcm_qla2xxx.txt | 16 ++++++++++++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  7 +++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |  1 +
 3 files changed, 24 insertions(+)

diff --git a/Documentation/scsi/tcm_qla2xxx.txt b/Documentation/scsi/tcm_qla2xxx.txt
index c3a670a..8d26d29 100644
--- a/Documentation/scsi/tcm_qla2xxx.txt
+++ b/Documentation/scsi/tcm_qla2xxx.txt
@@ -20,3 +20,19 @@ echo 1 > /sys/kernel/config/target/qla2xxx/21:00:00:24:ff:27:8f:ae/tpgt_1/attrib
 
 Disable jamming on host 4
 echo 0 > /sys/kernel/config/target/qla2xxx/21:00:00:24:ff:27:8f:ae/tpgt_1/attrib/jam_host
+
+New feature added with a new attribute called jam_data.
+
+Setting a boolean of 1 for jam_data will allow the allow the dropping of data-only SCSI 
+ commands but allow TUR commands to pass.
+Note that for this to work jam_host needs to be set to 0
+
+This has proven very useful for testing Low Level driver response.
+
+Enable host 4 for only data commands to be jammed
+echo 0 > /sys/kernel/config/target/qla2xxx/21:00:00:24:ff:27:8f:ae/tpgt_1/attrib/jam_host
+echo 1 > /sys/kernel/config/target/qla2xxx/21:00:00:24:ff:27:8f:ae/tpgt_1/attrib/jam_data
+
+Disable jamming on host 4
+echo 0 > /sys/kernel/config/target/qla2xxx/21:00:00:24:ff:27:8f:ae/tpgt_1/attrib/jam_host
+echo 0 > /sys/kernel/config/target/qla2xxx/21:00:00:24:ff:27:8f:ae/tpgt_1/attrib/jam_data

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 6643f6f..1cb3f02 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -473,6 +473,10 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 		/* return, and dont run target_submit_cmd,discarding command */
 		return 0;
 	}
+	if (unlikely(tpg->tpg_attrib.jam_data && (cdb[0]==0x08 || cdb[0]==0x0A || cdb[0]==0x28 || cdb[0]==0x2A))) {
+                /* return, and dont run target_submit_cmd,discarding command if not TUR*/
+                return 0;
+        }
 #endif
 
 	cmd->vha->tgt_counters.qla_core_sbt_cmd++;
@@ -827,6 +831,7 @@ DEF_QLA_TPG_ATTRIB(prod_mode_write_protect);
 DEF_QLA_TPG_ATTRIB(demo_mode_login_only);
 #ifdef CONFIG_TCM_QLA2XXX_DEBUG
 DEF_QLA_TPG_ATTRIB(jam_host);
+DEF_QLA_TPG_ATTRIB(jam_data);
 #endif
 
 static struct configfs_attribute *tcm_qla2xxx_tpg_attrib_attrs[] = {
@@ -837,6 +842,7 @@ static struct configfs_attribute *tcm_qla2xxx_tpg_attrib_attrs[] = {
 	&tcm_qla2xxx_tpg_attrib_attr_demo_mode_login_only,
 #ifdef CONFIG_TCM_QLA2XXX_DEBUG
 	&tcm_qla2xxx_tpg_attrib_attr_jam_host,
+	&tcm_qla2xxx_tpg_attrib_attr_jam_data,
 #endif
 	NULL,
 };
@@ -1011,6 +1017,7 @@ static struct se_portal_group *tcm_qla2xxx_make_tpg(
 	tpg->tpg_attrib.cache_dynamic_acls = 1;
 	tpg->tpg_attrib.demo_mode_login_only = 1;
 	tpg->tpg_attrib.jam_host = 0;
+	tpg->tpg_attrib.jam_data = 0;
 
 	ret = core_tpg_register(wwn, &tpg->se_tpg, SCSI_PROTOCOL_FCP);
 	if (ret < 0) {
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index 37e026a..789bdeb 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -35,6 +35,7 @@ struct tcm_qla2xxx_tpg_attrib {
 	int demo_mode_login_only;
 	int fabric_prot_type;
 	int jam_host;
+	int jam_data;
 };
 
 struct tcm_qla2xxx_tpg {
-- 
2.5.5
--
