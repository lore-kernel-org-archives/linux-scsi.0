From: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH,RESEND] scsi: use __uX types for headers exported to user space
Date: Thu,  7 Jan 2010 15:20:05 +0100
Message-ID: <1262874005-25089-1-git-send-email-jacmet@sunsite.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:36079 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab0AGOU1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2010 09:20:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, james.smart@emulex.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>

Commit 9e4f5e29 (FC Pass Thru support) exported a number of header file=
s
in include/scsi to user space, but didn't change the uX types to the
userspace-compatible __uX types. Without that you'll get compile errors
when including them - E.G.:

/tmp/include/scsi/scsi.h:145: error: expected specifier-qualifier-list
before =E2=80=98u8=E2=80=99

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 No feedback since 27/11, resending.

 include/scsi/scsi.h         |    8 ++++----
 include/scsi/scsi_netlink.h |   20 ++++++++++----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 8b4deca..ec3053e 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -149,10 +149,10 @@ struct scsi_cmnd;
=20
 /* defined in T10 SCSI Primary Commands-2 (SPC2) */
 struct scsi_varlen_cdb_hdr {
-	u8 opcode;        /* opcode always =3D=3D VARIABLE_LENGTH_CMD */
-	u8 control;
-	u8 misc[5];
-	u8 additional_cdb_length;         /* total cdb length - 8 */
+	__u8 opcode;        /* opcode always =3D=3D VARIABLE_LENGTH_CMD */
+	__u8 control;
+	__u8 misc[5];
+	__u8 additional_cdb_length;         /* total cdb length - 8 */
 	__be16 service_action;
 	/* service specific data follows */
 };
diff --git a/include/scsi/scsi_netlink.h b/include/scsi/scsi_netlink.h
index 536752c..7445c46 100644
--- a/include/scsi/scsi_netlink.h
+++ b/include/scsi/scsi_netlink.h
@@ -105,8 +105,8 @@ struct scsi_nl_host_vendor_msg {
  *    PCI :  ID data is the 16 bit PCI Registered Vendor ID
  */
 #define SCSI_NL_VID_TYPE_SHIFT		56
-#define SCSI_NL_VID_TYPE_MASK		((u64)0xFF << SCSI_NL_VID_TYPE_SHIFT)
-#define SCSI_NL_VID_TYPE_PCI		((u64)0x01 << SCSI_NL_VID_TYPE_SHIFT)
+#define SCSI_NL_VID_TYPE_MASK		((__u64)0xFF << SCSI_NL_VID_TYPE_SHIFT)
+#define SCSI_NL_VID_TYPE_PCI		((__u64)0x01 << SCSI_NL_VID_TYPE_SHIFT)
 #define SCSI_NL_VID_ID_MASK		(~ SCSI_NL_VID_TYPE_MASK)
=20
=20
@@ -125,21 +125,21 @@ struct scsi_nl_host_vendor_msg {
 #include <scsi/scsi_host.h>
=20
 /* Exported Kernel Interfaces */
-int scsi_nl_add_transport(u8 tport,
+int scsi_nl_add_transport(__u8 tport,
 	 int (*msg_handler)(struct sk_buff *),
 	void (*event_handler)(struct notifier_block *, unsigned long, void *)=
);
-void scsi_nl_remove_transport(u8 tport);
+void scsi_nl_remove_transport(__u8 tport);
=20
-int scsi_nl_add_driver(u64 vendor_id, struct scsi_host_template *hostt=
,
+int scsi_nl_add_driver(__u64 vendor_id, struct scsi_host_template *hos=
tt,
 	int (*nlmsg_handler)(struct Scsi_Host *shost, void *payload,
-				 u32 len, u32 pid),
+				 __u32 len, __u32 pid),
 	void (*nlevt_handler)(struct notifier_block *nb,
 				 unsigned long event, void *notify_ptr));
-void scsi_nl_remove_driver(u64 vendor_id);
+void scsi_nl_remove_driver(__u64 vendor_id);
=20
-void scsi_nl_send_transport_msg(u32 pid, struct scsi_nl_hdr *hdr);
-int scsi_nl_send_vendor_msg(u32 pid, unsigned short host_no, u64 vendo=
r_id,
-			 char *data_buf, u32 data_len);
+void scsi_nl_send_transport_msg(__u32 pid, struct scsi_nl_hdr *hdr);
+int scsi_nl_send_vendor_msg(__u32 pid, unsigned short host_no, __u64 v=
endor_id,
+			 char *data_buf, __u32 data_len);
=20
 #endif /* __KERNEL__ */
=20
--=20
1.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
