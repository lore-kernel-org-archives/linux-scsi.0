From: Arne Redlich <arne.redlich@xiranet.com>
Subject: Re: [PATCH] srp.h: avoid padding of structs
Date: Mon, 17 Apr 2006 11:17:52 +0200
Message-ID: <20060417091752.GA2947@cheetah>
References: <20060416193443.GA1806@cheetah>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 162.237.80.212.versanetonline.de ([212.80.237.162]:10728 "EHLO
	cheetah.dd.xiranet.com") by vger.kernel.org with ESMTP
	id S1750716AbWDQJR6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Apr 2006 05:17:58 -0400
Content-Disposition: inline
In-Reply-To: <20060416193443.GA1806@cheetah>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: arne.redlich@xiranet.com

On Sun, Apr 16, 2006 at 09:34:43PM +0200, Arne Redlich wrote:
> Several structs in srp.h are padded by the compiler on some architectures, causing problems e.g. in ib_srp:
> 
> 				i386	x86_64	(SRP spec)
> 
> sizeof(struct indirect_buf)	20	24	(20)
> sizeof(struct srp_login_rsp)	52	56	(52)
> sizeof(struct srp_rsp)		36	40	(36)
> 
> The patch below addresses this issue by packing these three structs, as well as the remaining ones.
> 

Scratch the previous version - I've mistakenly left an old and broken
"__attribute__((packed))" in struct srp_indirect_buf. Corrected below.

Signed-off-by: Arne Redlich <arne.redlich@xiranet.com>

diff -prauN a/include/scsi/srp.h b/include/scsi/srp.h
--- a/include/scsi/srp.h	2006-04-16 19:12:27.347924280 +0200
+++ b/include/scsi/srp.h	2006-04-17 11:04:24.333322224 +0200
@@ -91,18 +91,13 @@ struct srp_direct_buf {
 	__be64	va;
 	__be32	key;
 	__be32  len;
-};
+} __attribute__((packed));
 
-/*
- * We need the packed attribute because the SRP spec puts the list of
- * descriptors at an offset of 20, which is not aligned to the size
- * of struct srp_direct_buf.
- */
 struct srp_indirect_buf {
 	struct srp_direct_buf	table_desc;
 	__be32			len;
-	struct srp_direct_buf	desc_list[0] __attribute__((packed));
-};
+	struct srp_direct_buf	desc_list[0];
+} __attribute__((packed));
 
 enum {
 	SRP_MULTICHAN_SINGLE = 0,
@@ -120,7 +115,7 @@ struct srp_login_req {
 	u8	reserved3[5];
 	u8	initiator_port_id[16];
 	u8	target_port_id[16];
-};
+} __attribute__((packed));
 
 struct srp_login_rsp {
 	u8	opcode;
@@ -132,7 +127,7 @@ struct srp_login_rsp {
 	__be16	buf_fmt;
 	u8	rsp_flags;
 	u8	reserved2[25];
-};
+} __attribute__((packed));
 
 struct srp_login_rej {
 	u8	opcode;
@@ -142,13 +137,13 @@ struct srp_login_rej {
 	u8	reserved2[8];
 	__be16	buf_fmt;
 	u8	reserved3[6];
-};
+} __attribute__((packed));
 
 struct srp_i_logout {
 	u8	opcode;
 	u8	reserved[7];
 	u64	tag;
-};
+} __attribute__((packed));
 
 struct srp_t_logout {
 	u8	opcode;
@@ -156,30 +151,22 @@ struct srp_t_logout {
 	u8	reserved[2];
 	__be32	reason;
 	u64	tag;
-};
+} __attribute__((packed));
 
-/*
- * We need the packed attribute because the SRP spec only aligns the
- * 8-byte LUN field to 4 bytes.
- */
 struct srp_tsk_mgmt {
 	u8	opcode;
 	u8	sol_not;
 	u8	reserved1[6];
 	u64	tag;
 	u8	reserved2[4];
-	__be64	lun __attribute__((packed));
+	__be64	lun;
 	u8	reserved3[2];
 	u8	tsk_mgmt_func;
 	u8	reserved4;
 	u64	task_tag;
 	u8	reserved5[8];
-};
+} __attribute__((packed));
 
-/*
- * We need the packed attribute because the SRP spec only aligns the
- * 8-byte LUN field to 4 bytes.
- */
 struct srp_cmd {
 	u8	opcode;
 	u8	sol_not;
@@ -189,14 +176,14 @@ struct srp_cmd {
 	u8	data_in_desc_cnt;
 	u64	tag;
 	u8	reserved2[4];
-	__be64	lun __attribute__((packed));
+	__be64	lun;
 	u8	reserved3;
 	u8	task_attr;
 	u8	reserved4;
 	u8	add_cdb_len;
 	u8	cdb[16];
 	u8	add_data[0];
-};
+} __attribute__((packed));
 
 enum {
 	SRP_RSP_FLAG_RSPVALID = 1 << 0,
@@ -221,6 +208,6 @@ struct srp_rsp {
 	__be32	sense_data_len;
 	__be32	resp_data_len;
 	u8	data[0];
-};
+} __attribute__((packed));
 
 #endif /* SCSI_SRP_H */
