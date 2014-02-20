From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 5/5] tcm_qla2xxx: Fix NAA formatted name for NPIV WWPNs
Date: Thu, 20 Feb 2014 21:03:29 +0000
Message-ID: <1392930209-25065-6-git-send-email-nab@daterainc.com>
References: <1392930209-25065-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:39482 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbaBTVZ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 16:25:27 -0500
Received: by mail-ob0-f179.google.com with SMTP id wo20so2768239obc.38
        for <linux-scsi@vger.kernel.org>; Thu, 20 Feb 2014 13:25:25 -0800 (PST)
In-Reply-To: <1392930209-25065-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sawan Chandak <sawan.chandak@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes the NAA formatted name used by EVPD=0x83
device identifer to reflect the proper NPIV enabled WWPN.

Cc: Sawan Chandak <sawan.chandak@qlogic.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   27 +--------------------------
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |    4 ----
 2 files changed, 1 insertion(+), 30 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 5bdc440..788c4fe 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -182,20 +182,6 @@ static int tcm_qla2xxx_npiv_parse_wwn(
 	return 0;
 }
 
-static ssize_t tcm_qla2xxx_npiv_format_wwn(char *buf, size_t len,
-					u64 wwpn, u64 wwnn)
-{
-	u8 b[8], b2[8];
-
-	put_unaligned_be64(wwpn, b);
-	put_unaligned_be64(wwnn, b2);
-	return snprintf(buf, len,
-		"%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x,"
-		"%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x",
-		b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7],
-		b2[0], b2[1], b2[2], b2[3], b2[4], b2[5], b2[6], b2[7]);
-}
-
 static char *tcm_qla2xxx_npiv_get_fabric_name(void)
 {
 	return "qla2xxx_npiv";
@@ -227,15 +213,6 @@ static char *tcm_qla2xxx_get_fabric_wwn(struct se_portal_group *se_tpg)
 	return lport->lport_naa_name;
 }
 
-static char *tcm_qla2xxx_npiv_get_fabric_wwn(struct se_portal_group *se_tpg)
-{
-	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
-				struct tcm_qla2xxx_tpg, se_tpg);
-	struct tcm_qla2xxx_lport *lport = tpg->lport;
-
-	return &lport->lport_npiv_name[0];
-}
-
 static u16 tcm_qla2xxx_get_tag(struct se_portal_group *se_tpg)
 {
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
@@ -1811,8 +1788,6 @@ static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
 	}
 	lport->lport_npiv_wwpn = npiv_wwpn;
 	lport->lport_npiv_wwnn = npiv_wwnn;
-	tcm_qla2xxx_npiv_format_wwn(&lport->lport_npiv_name[0],
-			TCM_QLA2XXX_NAMELEN, npiv_wwpn, npiv_wwnn);
 	sprintf(lport->lport_naa_name, "naa.%016llx", (unsigned long long) npiv_wwpn);
 
 	ret = tcm_qla2xxx_init_lport(lport);
@@ -1921,7 +1896,7 @@ static struct target_core_fabric_ops tcm_qla2xxx_ops = {
 static struct target_core_fabric_ops tcm_qla2xxx_npiv_ops = {
 	.get_fabric_name		= tcm_qla2xxx_npiv_get_fabric_name,
 	.get_fabric_proto_ident		= tcm_qla2xxx_get_fabric_proto_ident,
-	.tpg_get_wwn			= tcm_qla2xxx_npiv_get_fabric_wwn,
+	.tpg_get_wwn			= tcm_qla2xxx_get_fabric_wwn,
 	.tpg_get_tag			= tcm_qla2xxx_get_tag,
 	.tpg_get_default_depth		= tcm_qla2xxx_get_default_depth,
 	.tpg_get_pr_transport_id	= tcm_qla2xxx_get_pr_transport_id,
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index a90966d..33aaac8 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -4,8 +4,6 @@
 #define TCM_QLA2XXX_VERSION	"v0.1"
 /* length of ASCII WWPNs including pad */
 #define TCM_QLA2XXX_NAMELEN	32
-/* lenth of ASCII NPIV 'WWPN+WWNN' including pad */
-#define TCM_QLA2XXX_NPIV_NAMELEN 66
 
 #include "qla_target.h"
 
@@ -65,8 +63,6 @@ struct tcm_qla2xxx_lport {
 	char lport_name[TCM_QLA2XXX_NAMELEN];
 	/* ASCII formatted naa WWPN for VPD page 83 etc */
 	char lport_naa_name[TCM_QLA2XXX_NAMELEN];
-	/* ASCII formatted WWPN+WWNN for NPIV FC Target Lport */
-	char lport_npiv_name[TCM_QLA2XXX_NPIV_NAMELEN];
 	/* map for fc_port pointers in 24-bit FC Port ID space */
 	struct btree_head32 lport_fcport_map;
 	/* vmalloc-ed memory for fc_port pointers for 16-bit FC loop ID */
-- 
1.7.10.4

