From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] [LIO-Target]: Update iSCSI TransportID parser to
	return length
Date: Sat, 08 Aug 2009 21:57:31 -0700
Message-ID: <1249793851.11105.237.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:32784 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751135AbZHIE5c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Aug 2009 00:57:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, James Smart <James.Smart@Emulex.Com>, Philipp Reisner <philipp.reisner@linbit.com>

Hello,

This patch updates the iSCSI Transport parser in lio_tpg_parse_pr_out_transport_id()
to return the total length of the received TransportID as a function parameter u32 *tid_len,
for SPC-3 PR SA REGISTER w/ SPEC_I_PT=1 operations with the LIO-Target fabric module.

When a u32 *tid_len pointer exists, this patch will attempt to rebuild tid_len based on the
received additional length parameter field in the iSCSI TransportID header, but also checks
the total NULL terminated and NULL padded string sizes of the received iSCSI Initiator Port/Device
to double check, and will return the latter if the former does not match.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_tpg.c |   26 +++++++++++++++++++++++++-
 drivers/lio-core/iscsi_target_tpg.h |    2 +-
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_tpg.c b/drivers/lio-core/iscsi_target_tpg.c
index fcb5006..15648a5 100644
--- a/drivers/lio-core/iscsi_target_tpg.c
+++ b/drivers/lio-core/iscsi_target_tpg.c
@@ -243,10 +243,12 @@ extern u32 lio_tpg_get_pr_transport_id_len (
 
 extern char *lio_tpg_parse_pr_out_transport_id(
 	const char *buf,
-	u32 tid_len,
+	u32 *out_tid_len,
 	char **port_nexus_ptr)
 {
 	char *p;
+	u32 tid_len, padding;
+	u16 add_len;
 	u8 format_code = (buf[0] & 0xc0);
 	/*
 	 * Check for FORMAT CODE 00b or 01b from spc4r17, section 7.5.4.6:
@@ -266,6 +268,28 @@ extern char *lio_tpg_parse_pr_out_transport_id(
 		return NULL;
 	}
 	/*
+	 * If the caller wants the TransportID Length, we set that value for the
+	 * entire iSCSI Tarnsport ID now.
+	 */
+	if (out_tid_len != NULL) {
+		add_len = ((buf[2] >> 8) & 0xff);
+		add_len |= (buf[3] & 0xff);
+
+		tid_len = strlen((char *)&buf[4]);
+		tid_len += 4; /* Add four bytes for iSCSI Transport ID header */
+		tid_len += 1; /* Add one byte for NULL terminator */
+		if ((padding = ((-tid_len) & 3)) != 0)
+			tid_len += padding;
+
+		if ((add_len + 4) != tid_len) {
+			printk(KERN_INFO "LIO-Target Extracted add_len: %hu "
+				"does not match calculated tid_len: %u,"
+				" using tid_len instead\n", add_len+4, tid_len);
+			*out_tid_len = tid_len;
+		} else 
+			*out_tid_len = (add_len + 4);
+	}
+	/*
 	 * Check for the ',i,0x' seperator between iSCSI Name and iSCSI Initiator
 	 * Session ID as defined in Table 390 -- iSCSI initiator port TransportID
 	 * format.
diff --git a/drivers/lio-core/iscsi_target_tpg.h b/drivers/lio-core/iscsi_target_tpg.h
index 83bb822..7971226 100644
--- a/drivers/lio-core/iscsi_target_tpg.h
+++ b/drivers/lio-core/iscsi_target_tpg.h
@@ -34,7 +34,7 @@ extern u16 lio_tpg_get_tag (struct se_portal_group_s *);
 extern u32 lio_tpg_get_default_depth (struct se_portal_group_s *);
 extern u32 lio_tpg_get_pr_transport_id (struct se_portal_group_s *, struct se_node_acl_s *, int *, unsigned char *);
 extern u32 lio_tpg_get_pr_transport_id_len (struct se_portal_group_s *, struct se_node_acl_s *, int *);
-extern char *lio_tpg_parse_pr_out_transport_id(const char *, u32, char **);
+extern char *lio_tpg_parse_pr_out_transport_id(const char *, u32 *, char **);
 extern int lio_tpg_check_demo_mode (struct se_portal_group_s *);
 extern int lio_tpg_check_demo_mode_cache (struct se_portal_group_s *);
 extern int lio_tpg_check_demo_mode_write_protect (struct se_portal_group_s *);
-- 
1.5.4.1



