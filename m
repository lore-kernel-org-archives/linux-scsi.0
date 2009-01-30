From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/4] [LIO-Target/PERSISTENT-RESERVATION]: Add support for
	iSCSI Transport IDs
Date: Fri, 30 Jan 2009 01:35:12 -0800
Message-ID: <1233308112.6442.256.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:28391 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752414AbZA3JgV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2009 04:36:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Rafiu Fakunle <rafiu@openfiler.com>, "Lawrence E. Rosen" <lrosen@pyxtechnologies.com>, Arne Redlich <agr@powerkom-dd.de>, Ming Zhang <blackmagic02881@gmail.com>

>From df842680009acc0b2bf8a2e593c05df7429af9e9 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 30 Jan 2009 00:35:37 -0800
Subject: [PATCH 4/4] [LIO-Target/PERSISTENT-RESERVATION]: Add support for iSCSI Transport IDs

This patch adds support for the following SPC-4 defined TransportIDs to
LIO-Target/ConfigFS v3.0:

*) iSCSI Initiator device TransportID format (iSCSI Initiator IQN)
*) iSCSI Initiator port TransportID format (iSCSI Initiator IQN + ISID)

The latter is avaiable when there is an active I_T Nexus (iSCSI Session)
via SPC-3 compliant PRIN SA READ_FULL_STATUS.

Tested using sg_persist  on v2.6.29-rc2 32-bit HVM.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_configfs.c |    2 +
 drivers/lio-core/iscsi_target_tpg.c      |  142 +++++++++++++++++++++++++++++-
 drivers/lio-core/iscsi_target_tpg.h      |    4 +-
 3 files changed, 146 insertions(+), 2 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_configfs.c b/drivers/lio-core/iscsi_target_configfs.c
index 9906ad8..9e136ea 100644
--- a/drivers/lio-core/iscsi_target_configfs.c
+++ b/drivers/lio-core/iscsi_target_configfs.c
@@ -2291,6 +2291,8 @@ extern int iscsi_target_register_configfs (void)
 	fabric->tf_ops.tpg_get_wwn = &lio_tpg_get_endpoint_wwn;
 	fabric->tf_ops.tpg_get_tag = &lio_tpg_get_tag;
 	fabric->tf_ops.tpg_get_default_depth = &lio_tpg_get_default_depth;
+	fabric->tf_ops.tpg_get_pr_transport_id = &lio_tpg_get_pr_transport_id;
+	fabric->tf_ops.tpg_get_pr_transport_id_len = &lio_tpg_get_pr_transport_id_len;
 	fabric->tf_ops.tpg_check_demo_mode = &lio_tpg_check_demo_mode;
 	fabric->tf_ops.tpg_check_demo_mode_cache = &lio_tpg_check_demo_mode_cache;
 	fabric->tf_ops.tpg_check_demo_mode_write_protect = &lio_tpg_check_demo_mode_write_protect;
diff --git a/drivers/lio-core/iscsi_target_tpg.c b/drivers/lio-core/iscsi_target_tpg.c
index 3068aba..b5a7480 100644
--- a/drivers/lio-core/iscsi_target_tpg.c
+++ b/drivers/lio-core/iscsi_target_tpg.c
@@ -86,7 +86,7 @@ extern char *lio_tpg_get_endpoint_wwn (se_portal_group_t *se_tpg)
 	return(&tpg->tpg_tiqn->tiqn[0]);
 }
 
-extern u32 lio_tpg_get_tag (se_portal_group_t *se_tpg)
+extern u16 lio_tpg_get_tag (se_portal_group_t *se_tpg)
 {
 	iscsi_portal_group_t *tpg = (iscsi_portal_group_t *)se_tpg->se_tpg_fabric_ptr;
 
@@ -100,6 +100,146 @@ extern u32 lio_tpg_get_default_depth (se_portal_group_t *se_tpg)
 	return(ISCSI_TPG_ATTRIB(tpg)->default_cmdsn_depth);
 }
 
+extern u32 lio_tpg_get_pr_transport_id (
+	se_portal_group_t *se_tpg,
+	se_node_acl_t *se_nacl,
+	int *format_code,
+	unsigned char *buf)
+{
+	iscsi_session_t *sess;
+	se_session_t *se_sess;
+	u32 off = 4, padding = 0;
+	u16 len = 0;
+
+	spin_lock(&se_nacl->nacl_sess_lock);
+	/*
+	 * Set PROTOCOL IDENTIFIER to 5h for iSCSI
+	 */
+	buf[0] = 0x05;
+	/*
+	 * From spc4r17 Section 7.5.4.6: TransportID for initiator
+	 * ports using SCSI over iSCSI.
+	 *
+	 * The null-terminated, null-padded (see 4.4.2) ISCSI NAME field
+	 * shall contain the iSCSI name of an iSCSI initiator node (see
+	 * RFC 3720). The first ISCSI NAME field byte containing an ASCII
+	 * null character terminates the ISCSI NAME field without regard for
+	 * the specified length of the iSCSI TransportID or the contents of
+	 * the ADDITIONAL LENGTH field.
+	 */
+	len = sprintf(&buf[off], "%s", se_nacl->initiatorname);
+	/*
+	 * Add Extra byte for NULL terminator
+	 */
+	len++;
+	/*
+	 * If there is an active iSCSI session, and *format code == 1
+	 * 1, use iSCSI Initiator port TransportID format.
+	 *
+	 * Otherwise use iSCSI Initiator device TransportID format that
+	 * does not contain the ASCII encoded iSCSI Initiator iSID value
+	 * provied by the iSCSi Initiator during the iSCSI login process.
+	 */
+	if ((*format_code == 1) && (se_sess = se_nacl->nacl_sess)) {  
+		/*
+		 * Set FORMAT CODE 01b for iSCSI Initiator port TransportID
+		 * format.
+		 */
+		buf[0] |= 0x40;
+		/*
+		 * From spc4r17 Section 7.5.4.6: TransportID for initiator
+		 * ports using SCSI over iSCSI.  Table 390
+		 *
+		 * The SEPARATOR field shall contain the five ASCII
+		 * characters ",i,0x".
+		 *
+		 * The null-terminated, null-padded ISCSI INITIATOR SESSION ID
+		 * field shall contain the iSCSI initiator session identifier
+		 * (see RFC 3720) in the form of ASCII characters that are the
+		 * hexadecimal digits converted from the binary iSCSI initiator
+		 * session identifier value. The first ISCSI INITIATOR SESSION
+		 * ID field byte containing an ASCII null character
+		 */
+		sess = (iscsi_session_t *)se_sess->fabric_sess_ptr;
+		buf[off+len] = 0x2c; off++; // ASCII Character: ","
+		buf[off+len] = 0x69; off++; // ASCII Character: "i"
+		buf[off+len] = 0x2c; off++; // ASCII Character: ","
+		buf[off+len] = 0x30; off++; // ASCII Character: "0"
+		buf[off+len] = 0x78; off++; // ASCII Character: "x"
+		len += 5;
+		buf[off+len] = sess->isid[0]; off++;
+		buf[off+len] = sess->isid[1]; off++;
+		buf[off+len] = sess->isid[2]; off++;
+		buf[off+len] = sess->isid[3]; off++;
+		buf[off+len] = sess->isid[4]; off++;
+		buf[off+len] = sess->isid[5]; off++;
+		buf[off+len] = '\0'; off++;
+		len += 7;
+	}
+	spin_unlock(&se_nacl->nacl_sess_lock);
+	/*
+	 * The ADDITIONAL LENGTH field specifies the number of bytes that follow
+	 * in the TransportID. The additional length shall be at least 20 and
+	 * shall be a multiple of four.
+	 */
+	if ((padding = ((-len) & 3)) != 0) 
+		len += padding;
+
+	buf[2] = ((len >> 8) & 0xff);
+	buf[3] = (len & 0xff);
+	/*
+	 * Increment value for total payload + header length for
+	 * full status descriptor
+	 */
+	len += 4;
+
+	return(len);
+}
+
+extern u32 lio_tpg_get_pr_transport_id_len (
+	se_portal_group_t *se_tpg,
+	se_node_acl_t *se_nacl,
+	int *format_code)
+{
+	se_session_t *se_sess;
+	u32 len = 0, padding = 0;
+
+	spin_lock(&se_nacl->nacl_sess_lock);
+	len = strlen(se_nacl->initiatorname);
+	/*
+	 * Add extra byte for NULL terminator
+	 */
+	len++;
+	/*
+	 * If there is an active iSCSI session, use format code:
+	 * 01b: iSCSI Initiator port TransportID format
+	 *
+	 * If there is not an active iSCSI session, use format code:
+	 * 00b: iSCSI Initiator device TransportID format
+	 */
+	if ((se_sess = se_nacl->nacl_sess)) {
+		len += 5; /* For ",i,0x" ASCII seperator */
+		len += 7; /* For iSCSI Initiator Session ID + Null terminator */
+		*format_code = 1;
+	} else
+		*format_code = 0;
+	spin_unlock(&se_nacl->nacl_sess_lock);
+	/*
+	 * The ADDITIONAL LENGTH field specifies the number of bytes that follow
+	 * in the TransportID. The additional length shall be at least 20 and
+	 * shall be a multiple of four.
+	 */
+	if ((padding = ((-len) & 3)) != 0)
+		len += padding;
+	/*
+	 * Increment value for total payload + header length for
+	 * full status descriptor
+	 */
+	len += 4;
+
+	return(len);
+}
+
 extern int lio_tpg_check_demo_mode (se_portal_group_t *se_tpg)
 {
 	iscsi_portal_group_t *tpg = (iscsi_portal_group_t *)se_tpg->se_tpg_fabric_ptr;
diff --git a/drivers/lio-core/iscsi_target_tpg.h b/drivers/lio-core/iscsi_target_tpg.h
index 68fb2a8..749e148 100644
--- a/drivers/lio-core/iscsi_target_tpg.h
+++ b/drivers/lio-core/iscsi_target_tpg.h
@@ -30,8 +30,10 @@
 #define ISCSI_TARGET_TPG_H
 
 extern char *lio_tpg_get_endpoint_wwn (struct se_portal_group_s *);
-extern u32 lio_tpg_get_tag (struct se_portal_group_s *);
+extern u16 lio_tpg_get_tag (struct se_portal_group_s *);
 extern u32 lio_tpg_get_default_depth (struct se_portal_group_s *);
+extern u32 lio_tpg_get_pr_transport_id (struct se_portal_group_s *, struct se_node_acl_s *, int *, unsigned char *);
+extern u32 lio_tpg_get_pr_transport_id_len (struct se_portal_group_s *, struct se_node_acl_s *, int *);
 extern int lio_tpg_check_demo_mode (struct se_portal_group_s *);
 extern int lio_tpg_check_demo_mode_cache (struct se_portal_group_s *);
 extern int lio_tpg_check_demo_mode_write_protect (struct se_portal_group_s *);
-- 
1.5.4.1



