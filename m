From: Roland Dreier <rdreier@cisco.com>
Subject: [PATCH] srp.h: avoid padding of structs
Date: Tue, 18 Apr 2006 09:05:39 -0700
Message-ID: <adavet6j2cs.fsf_-_@cisco.com>
References: <20060416193443.GA1806@cheetah> <20060417091752.GA2947@cheetah>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from test-iport-1.cisco.com ([171.71.176.117]:51843 "EHLO
	test-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S1750928AbWDRQFp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Apr 2006 12:05:45 -0400
In-Reply-To: <20050823221723.GE31949@krispykreme> (Anton Blanchard's message of "Wed, 24 Aug 2005 08:17:23 +1000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, arne.redlich@xiranet.com

Thanks for pointing out this problem.  However I don't think we should
pack every structure in the file, because packing structures that
don't need it leads to gcc generating horrible code on architectures
like ia64.  I'd prefer something like the following.

James, can you queue this up?  I'd be happy to merge it through my
tree but it seems more appropriate for it to go through the SCSI tree.
It's probably 2.6.17 material at this point in the cycle.

Thanks,
  Roland



Several structs in <scsi/srp.h> get padded to a multiple of 8 bytes on
64-bit architectures and end up with a size that does not match the
definition in the SRP spec:

                                     SRP spec     64-bit
    sizeof (struct indirect_buf)        20          24
    sizeof (struct srp_login_rsp)       52          56
    sizeof (struct srp_rsp)             36          40

Fix this by adding __attribute__((packed)) to the offending structs.

Problem pointed out by Arne Redlich <arne.redlich@xiranet.com>.

Signed-off-by: Roland Dreier <rolandd@cisco.com>

diff --git a/include/scsi/srp.h b/include/scsi/srp.h
index 6c2681d..637f77e 100644
--- a/include/scsi/srp.h
+++ b/include/scsi/srp.h
@@ -95,14 +95,15 @@ struct srp_direct_buf {
 
 /*
  * We need the packed attribute because the SRP spec puts the list of
- * descriptors at an offset of 20, which is not aligned to the size
- * of struct srp_direct_buf.
+ * descriptors at an offset of 20, which is not aligned to the size of
+ * struct srp_direct_buf.  The whole structure must be packed to avoid
+ * having the 20-byte structure padded to 24 bytes on 64-bit architectures.
  */
 struct srp_indirect_buf {
 	struct srp_direct_buf	table_desc;
 	__be32			len;
-	struct srp_direct_buf	desc_list[0] __attribute__((packed));
-};
+	struct srp_direct_buf	desc_list[0];
+} __attribute__((packed));
 
 enum {
 	SRP_MULTICHAN_SINGLE = 0,
@@ -122,6 +123,11 @@ struct srp_login_req {
 	u8	target_port_id[16];
 };
 
+/*
+ * The SRP spec defines the size of the LOGIN_RSP structure to be 52
+ * bytes, so it needs to be packed to avoid having it padded to 56
+ * bytes on 64-bit architectures.
+ */
 struct srp_login_rsp {
 	u8	opcode;
 	u8	reserved1[3];
@@ -132,7 +138,7 @@ struct srp_login_rsp {
 	__be16	buf_fmt;
 	u8	rsp_flags;
 	u8	reserved2[25];
-};
+} __attribute__((packed));
 
 struct srp_login_rej {
 	u8	opcode;
@@ -207,6 +213,11 @@ enum {
 	SRP_RSP_FLAG_DIUNDER  = 1 << 5
 };
 
+/*
+ * The SRP spec defines the size of the RSP structure to be 36 bytes,
+ * so it needs to be packed to avoid having it padded to 40 bytes on
+ * 64-bit architectures.
+ */
 struct srp_rsp {
 	u8	opcode;
 	u8	sol_not;
@@ -221,6 +232,6 @@ struct srp_rsp {
 	__be32	sense_data_len;
 	__be32	resp_data_len;
 	u8	data[0];
-};
+} __attribute__((packed));
 
 #endif /* SCSI_SRP_H */
