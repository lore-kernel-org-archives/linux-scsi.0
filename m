From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] SCSI & FC transport: extend event vendor id's to 64bits
Date: Tue, 22 Aug 2006 09:55:23 -0400
Message-ID: <1156254923.5607.5.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:31417 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932159AbWHVNza
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Aug 2006 09:55:30 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k7MDtSUO020940
	for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2006 06:55:29 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

During discussions with Mike Christie, I became convinced that we needed
a larger vendor id. This patch extends the id from 32 to 64 bits.

This applies on top of the prior patches that add SCSI transport events
via netlink.

-- james s


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2006-08-22 06:59:10.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2006-08-22 07:03:27.000000000 -0400
@@ -514,7 +514,7 @@ EXPORT_SYMBOL(fc_host_post_event);
  **/
 void
 fc_host_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
-		u32 data_len, char * data_buf, u32 vendor_id)
+		u32 data_len, char * data_buf, u64 vendor_id)
 {
 	struct sk_buff *skb;
 	struct nlmsghdr	*nlh;
diff -upNr a/include/scsi/scsi_netlink_fc.h b/include/scsi/scsi_netlink_fc.h
--- a/include/scsi/scsi_netlink_fc.h	2006-08-22 06:58:44.000000000 -0400
+++ b/include/scsi/scsi_netlink_fc.h	2006-08-22 07:04:41.000000000 -0400
@@ -58,7 +58,7 @@
 struct fc_nl_event {
 	struct scsi_nl_hdr snlh;		/* must be 1st element ! */
 	uint64_t seconds;
-	uint32_t vendor_id;
+	uint64_t vendor_id;
 	uint16_t host_no;
 	uint16_t event_datalen;
 	uint32_t event_num;
diff -upNr a/include/scsi/scsi_netlink.h b/include/scsi/scsi_netlink.h
--- a/include/scsi/scsi_netlink.h	2006-08-22 06:58:44.000000000 -0400
+++ b/include/scsi/scsi_netlink.h	2006-08-22 09:48:40.000000000 -0400
@@ -67,9 +67,10 @@ struct scsi_nl_hdr {
  *   Identifiers for each type:
  *    PCI :  ID data is the 16 bit PCI Registered Vendor ID
  */
-#define SCSI_NL_VID_ID_MASK			0x00FFFFFF
-#define SCSI_NL_VID_TYPE_MASK			0xFF000000
-#define SCSI_NL_VID_TYPE_PCI			0x01000000
+#define SCSI_NL_VID_TYPE_SHIFT		56
+#define SCSI_NL_VID_TYPE_MASK		((u64)0xFF << SCSI_NL_VID_TYPE_SHIFT)
+#define SCSI_NL_VID_TYPE_PCI		((u64)0x01 << SCSI_NL_VID_TYPE_SHIFT)
+#define SCSI_NL_VID_ID_MASK		(~ SCSI_NL_VID_TYPE_MASK)
 

 #define INIT_SCSI_NL_HDR(hdr, t, mtype, mlen)			\
diff -upNr a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h	2006-08-22 06:59:10.000000000 -0400
+++ b/include/scsi/scsi_transport_fc.h	2006-08-22 07:06:43.000000000 -0400
@@ -560,7 +560,7 @@ u32 fc_get_event_number(void);
 void fc_host_post_event(struct Scsi_Host *shost, u32 event_number,
 		enum fc_host_event_code event_code, u32 event_data);
 void fc_host_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
-		u32 data_len, char * data_buf, u32 vendor_id);
+		u32 data_len, char * data_buf, u64 vendor_id);
 	/* Note: when specifying vendor_id to fc_host_post_vendor_event()
 	 *   be sure to read the Vendor Type and ID formatting requirements
 	 *   specified in scsi_netlink.h


