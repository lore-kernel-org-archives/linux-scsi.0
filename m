From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/4] [Target_Core_Mod/PERSISTENT_RESERVATION]: Add support
	for PRIN SA READ_FULL_STATUS
Date: Fri, 30 Jan 2009 01:34:11 -0800
Message-ID: <1233308051.6442.254.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:41726 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751239AbZA3JfU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2009 04:35:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Rafiu Fakunle <rafiu@openfiler.com>, "Lawrence E. Rosen" <lrosen@pyxtechnologies.com>, Arne Redlich <agr@powerkom-dd.de>, Ming Zhang <blackmagic02881@gmail.com>

>From 652c67d6ff1cfbb5a2e42613f65854b7993bba3e Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 30 Jan 2009 00:29:32 -0800
Subject: [PATCH 3/4] [Target_Core_Mod/PERSISTENT_RESERVATION]: Add support for PRIN SA READ_FULL_STATUS

This patch adds support for PRIN Service Action READ_FULL_STATUS as defined
by spc4r17.  This patch adds struct target_core_fabric_ops->tpg_get_pr_transport_id()
and struct target_core_fabric_ops->tpg_get_pr_transport_id_len() for this purpose
as calls into loaded $FABRIC_MOD SCSI Target Ports and Logical Units from the
Target_Core_Mod/ConfigFS SCSI device server.

This patch defines the $FABRIC_MOD independent aspects of Target_Core_Mod/ConfigFS
SPC-3 compliant Persistent Reservations support.  Here is what it looks like
with multiple PR registrations from two different Linux/iSCSI Initiatior nodes with
a WRITE_EXCLUSIVE reservation held:

opensuse:~# sg_persist -in --read-full-status -v /dev/sdb
    Persistent Reservation In cmd: 5e 03 00 00 00 00 00 20 00 00
  PR generation=0x2
    Key=0x5678efff
      All target ports bit set
      << Reservation holder >>
      scope: LU_SCOPE,  type: Write Exclusive
      Transport Id of initiator:
        iSCSI world wide unique port id: iqn.1993-08.org.debian:01:2dadf92d0ef
    Key=0x1234ffff
      All target ports bit clear
      Relative port address: 0x1
      not reservation holder
      Transport Id of initiator:
        iSCSI world wide unique port id: iqn.1996-04.de.suse:01:1661f9ee7b5

Tested with ALL_TG_PT=[1,0] bits using sg_persist on v2.6.29-rc2 32-bit HVM

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h       |    1 +
 drivers/lio-core/target_core_fabric_ops.h |    4 +-
 drivers/lio-core/target_core_pr.c         |  129 ++++++++++++++++++++++++++++-
 3 files changed, 130 insertions(+), 4 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index c773c13..c900517 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -225,6 +225,7 @@ typedef struct t10_reservation_template_s {
 
 typedef struct t10_pr_registration_s {
 	int pr_reg_all_tg_pt; /* Reservation effects all target ports */
+	int pr_res_holder;
 	int pr_res_type;
 	int pr_res_scope;
 	u32 pr_res_generation;
diff --git a/drivers/lio-core/target_core_fabric_ops.h b/drivers/lio-core/target_core_fabric_ops.h
index 5693dac..3fdf305 100644
--- a/drivers/lio-core/target_core_fabric_ops.h
+++ b/drivers/lio-core/target_core_fabric_ops.h
@@ -1,8 +1,10 @@
 struct target_core_fabric_ops {
 	char *(*get_fabric_name)(void);
 	char *(*tpg_get_wwn)(struct se_portal_group_s *);
-	u32 (*tpg_get_tag)(struct se_portal_group_s *);
+	u16 (*tpg_get_tag)(struct se_portal_group_s *);
 	u32 (*tpg_get_default_depth)(struct se_portal_group_s *);
+	u32 (*tpg_get_pr_transport_id)(struct se_portal_group_s *, struct se_node_acl_s *, int *, unsigned char *);
+	u32 (*tpg_get_pr_transport_id_len)(struct se_portal_group_s *, struct se_node_acl_s *, int *);
 	int (*tpg_check_demo_mode)(struct se_portal_group_s *);
 	int (*tpg_check_demo_mode_cache)(struct se_portal_group_s *);
 	int (*tpg_check_demo_mode_write_protect)(struct se_portal_group_s *);
diff --git a/drivers/lio-core/target_core_pr.c b/drivers/lio-core/target_core_pr.c
index f48b092..3b50ff2 100644
--- a/drivers/lio-core/target_core_pr.c
+++ b/drivers/lio-core/target_core_pr.c
@@ -698,6 +698,7 @@ static int core_scsi3_pro_reserve (
 	 */
 	pr_reg->pr_res_scope = scope;
 	pr_reg->pr_res_type = type;
+	pr_reg->pr_res_holder = 1;
 	dev->dev_pr_res_holder = pr_reg;
 
 	printk("SPC-3 PR [%s] Service Action: RESERVE created new reservation"
@@ -875,7 +876,7 @@ static int core_scsi3_emulate_pro_release (
 	/*
 	 * Clear TYPE and SCOPE for the next PROUT Service Action: RESERVE
 	 */
-	pr_reg->pr_res_type = pr_reg->pr_res_scope = 0;
+	pr_reg->pr_res_holder = pr_reg->pr_res_type = pr_reg->pr_res_scope = 0;
 	spin_unlock(&dev->dev_reservation_lock);
 
 	return(0);
@@ -1162,8 +1163,132 @@ static int core_scsi3_pri_report_capabilities (se_cmd_t *cmd)
 	return(0);
 }
 
+/*
+ * PERSISTENT_RESERVE_IN Service Action READ_FULL_STATUS
+ *
+ * See spc4r17 section 6.13.5 Table 168 and 169
+ */
 static int core_scsi3_pri_read_full_status (se_cmd_t *cmd)
 {
+	se_device_t *se_dev = SE_DEV(cmd);
+	se_node_acl_t *se_nacl;
+	se_subsystem_dev_t *su_dev = SU_DEV(se_dev);
+	se_portal_group_t *se_tpg;
+	t10_pr_registration_t *pr_reg, *pr_reg_tmp;
+	t10_reservation_template_t *pr_tmpl = &SU_DEV(se_dev)->t10_reservation;
+	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
+	u32 add_desc_len = 0, add_len = 0, desc_len, exp_desc_len;
+	u32 off = 8; /* off into first Full Status descriptor */
+	int format_code = 0;
+	
+	buf[0] = ((T10_RES(su_dev)->pr_generation >> 24) & 0xff);
+	buf[1] = ((T10_RES(su_dev)->pr_generation >> 16) & 0xff);
+	buf[2] = ((T10_RES(su_dev)->pr_generation >> 8) & 0xff);
+	buf[3] = (T10_RES(su_dev)->pr_generation & 0xff);
+
+	spin_lock(&pr_tmpl->registration_lock);
+	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
+			&pr_tmpl->registration_list, pr_reg_list) {
+
+		se_nacl = pr_reg->pr_reg_nacl;
+		se_tpg = pr_reg->pr_reg_nacl->se_tpg;
+		add_desc_len = 0;
+		/*
+		 * Determine expected length of $FABRIC_MOD specific
+		 * TransportID full status descriptor..
+		 */
+		exp_desc_len = TPG_TFO(se_tpg)->tpg_get_pr_transport_id_len(
+				se_tpg, se_nacl, &format_code);
+
+		if (((exp_desc_len > add_desc_len) + add_len) > cmd->data_length) {
+			printk(KERN_WARNING "SPC-3 PRIN READ_FULL_STATUS ran"
+				" out of buffer: %d\n", cmd->data_length);
+			break;
+		}
+		/*
+		 * Set RESERVATION KEY
+		 */
+		buf[off++] = ((pr_reg->pr_res_key >> 56) & 0xff);
+		buf[off++] = ((pr_reg->pr_res_key >> 48) & 0xff);
+		buf[off++] = ((pr_reg->pr_res_key >> 40) & 0xff);
+		buf[off++] = ((pr_reg->pr_res_key >> 32) & 0xff);
+		buf[off++] = ((pr_reg->pr_res_key >> 24) & 0xff);
+		buf[off++] = ((pr_reg->pr_res_key >> 16) & 0xff);
+		buf[off++] = ((pr_reg->pr_res_key >> 8) & 0xff);
+		buf[off++] = (pr_reg->pr_res_key & 0xff);
+		off += 4; /* Skip Over Reserved area */
+
+		/*
+		 * Set ALL_TG_PT bit if PROUT SA REGISTER had this set.
+		 */
+		if (pr_reg->pr_reg_all_tg_pt)
+			buf[off] = 0x02;
+		/*
+		 * The se_lun_t pointer will be present for the
+		 * reservation holder for PR_HOLDER bit.
+		 *
+		 * Also, if this registration is the reservation
+		 * holder, fill in SCOPE and TYPE in the next byte.
+		 */
+		if (pr_reg->pr_res_holder) {	
+			buf[off++] |= 0x01;
+			buf[off++] = (pr_reg->pr_res_scope & 0xf0) |
+				     (pr_reg->pr_res_type & 0x0f);
+		} else
+			off += 2;
+		
+		off += 4; /* Skip over reserved area */
+		/*
+		 * From spc4r17 6.3.15:
+		 *
+		 * If the ALL_TG_PT bit set to zero, the RELATIVE TARGET PORT
+		 * IDENTIFIER field contains the relative port identifier (see
+		 * 3.1.120) of the target port that is part of the I_T nexus
+		 * described by this full status descriptor. If the ALL_TG_PT
+		 * bit is set to one, the contents of the RELATIVE TARGET PORT
+		 * IDENTIFIER field are not defined by this standard.
+		 */
+		if (!(pr_reg->pr_reg_all_tg_pt)) {
+			u16 tpgt = TPG_TFO(se_tpg)->tpg_get_tag(se_tpg);
+
+			buf[off++] = ((tpgt >> 8) & 0xff);
+			buf[off++] = (tpgt & 0xff);
+		} else
+			off += 2; /* Skip over RELATIVE TARGET PORT IDENTIFER */
+
+		/*
+		 * Now, have the $FABRIC_MOD fill in the protocol identifier
+		 */
+		desc_len = TPG_TFO(se_tpg)->tpg_get_pr_transport_id(se_tpg,
+				se_nacl, &format_code, &buf[off+4]);
+		/*
+		 * Set the ADDITIONAL DESCRIPTOR LENGTH
+		 */
+		buf[off++] = ((desc_len >> 24) & 0xff);
+		buf[off++] = ((desc_len >> 16) & 0xff);
+		buf[off++] = ((desc_len >> 8) & 0xff);
+		buf[off++] = (desc_len & 0xff);
+		/*
+		 * Size of full desctipor header minus TransportID
+		 * containing $FABRIC_MOD specific) initiator device/port
+		 * WWN information.
+		 * 
+		 *  See spc4r17 Section 6.13.5 Table 169
+		 */
+		add_desc_len = (24 + desc_len);
+
+		off += desc_len;
+		add_len += add_desc_len;
+	}
+	spin_unlock(&pr_tmpl->registration_lock);
+	/*
+	 * Set ADDITIONAL_LENGTH
+	 */
+	buf[4] = ((add_len >> 24) & 0xff);
+	buf[5] = ((add_len >> 16) & 0xff);
+	buf[6] = ((add_len >> 8) & 0xff);
+	buf[7] = (add_len & 0xff);
+
 	return(0);
 }
 
@@ -1176,10 +1301,8 @@ static int core_scsi3_emulate_pr_in (se_cmd_t *cmd, unsigned char *cdb)
 		return(core_scsi3_pri_read_reservation(cmd));
 	case PRI_REPORT_CAPABILITIES:
 		return(core_scsi3_pri_report_capabilities(cmd));
-#if 0
 	case PRI_READ_FULL_STATUS:
 		return(core_scsi3_pri_read_full_status(cmd));
-#endif
 	default:
 		printk(KERN_ERR "Unknown PERSISTENT_RESERVE_IN service"
 			" action: 0x%02x\n", cdb[1] & 0x1f);
-- 
1.5.4.1



