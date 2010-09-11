From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] lio-target: Convert to use libcrypto crc32c
Date: Sat, 11 Sep 2010 03:31:26 -0700
Message-ID: <1284201086-22382-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, Vasu Dev <vasu.dev@linux.intel.com>, Joe Eykholt <jeykholt@cisco.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the LIO-Target fabric module to use the libcrypto API for
handling crc32c calculations when HeaderDigest=CRC32C and/or DataDigest=CRC32C
are enabled.  This includes the removal of the legacy internal slicing by 1x code
in iscsi_crc.c, and includes the addition of the following structure members to
struct iscsi_conn:

	struct hash_desc	conn_rx_hash;
	struct hash_desc	conn_tx_hash;

These are used in iSCSI RX and TX thread connection context for preforming
crypto_hash_*() calls to validate an incoming CRC32C checksum, or attaching an
outgoing CRC32C checksum.

On the setup side, this patch updates iscsi_target_login.c:iscsi_login_init_conn()
to add the necessary crypto_alloc_hash() calls for conn_rx_hash and conn_tx_hash.
On the shutdown side, the necessary crypto_free_hash() calls have been added to
the login exception path in iscsi_target_login.c:iscsi_target_login_thread(), and
in the normal iSCSI connection shutdown patch in iscsi_target.c:iscsi_close_connection().

This main changes on the I/O side involve the conversion of the legacy do_crc()
calls in iscsi_target.c to use crypto_hash_init(), crypto_hash_update() and
crypto_hash_final().  On the RX side for struct iscsi_cmd->conn_rx_hash this includes
the following:

	*) iscsi_handle_data_out() - iSCSI WRITE payload
	*) iscsi_handle_nop_out() - NopOut payload
	*) iscsi_handle_text_cmd() - Text payload
	*) iscsi_handle_immediate_data() - iSCSI WRITE payload
	*) iscsi_target_rx_thread() - 48 byte iSCSI PDU

and on the TX side for struct iscsi_cmd->conn_tx_hash:

	*) iscsi_send_async_msg() - Async Msg header digest
	*) iscsi_send_conn_drop_async_message() - Async Msg header digest
	*) iscsi_send_data_in() - DataIN header digest and iSCSI READ payload
	*) iscsi_send_logout_response() - Logout response header digest
	*) iscsi_send_unsolicited_nopin() - NopIN header digest
	*) iscsi_send_nopin_response() - NopIN header digest
	*) iscsi_send_r2t() - R2T header digest
	*) iscsi_send_status() - iSCSI status and SCSI sense payload
	*) iscsi_send_task_mgt_rsp() - iSCSI TMR header digest
	*) iscsi_send_text_rsp() - iSCSI text response and payload
	*) iscsi_send_reject() - iSCSI reject header digest and payload

So far this has been tested with HeaderDigest=CRC32C and DataDigest=CRC32C
on v2.6.36-rc3 in x86 KVM guest running with an Open-iSCSI initiator.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/lio-target/Kbuild               |    1 -
 drivers/target/lio-target/iscsi_crc.c          |  171 -------------
 drivers/target/lio-target/iscsi_crc.h          |    9 -
 drivers/target/lio-target/iscsi_target.c       |  302 ++++++++++++++++++------
 drivers/target/lio-target/iscsi_target_core.h  |    3 +
 drivers/target/lio-target/iscsi_target_erl1.c  |    1 -
 drivers/target/lio-target/iscsi_target_erl2.c  |    1 -
 drivers/target/lio-target/iscsi_target_login.c |   35 +++-
 drivers/target/lio-target/iscsi_target_nego.c  |    1 -
 drivers/target/lio-target/iscsi_target_tmr.c   |    1 -
 10 files changed, 268 insertions(+), 257 deletions(-)
 delete mode 100644 drivers/target/lio-target/iscsi_crc.c
 delete mode 100644 drivers/target/lio-target/iscsi_crc.h

diff --git a/drivers/target/lio-target/Kbuild b/drivers/target/lio-target/Kbuild
index 04c9290..0e9cdd9 100644
--- a/drivers/target/lio-target/Kbuild
+++ b/drivers/target/lio-target/Kbuild
@@ -3,7 +3,6 @@ EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/include/scsi/ -I$(srct
 EXTRA_CFLAGS+=-D_TARGET -DPYX_ISCSI_VENDOR='"Linux-iSCSI.org"'
 
 iscsi_target_mod-objs		:=	iscsi_auth_chap.o \
-				   	iscsi_crc.o \
 					iscsi_debug_opcodes.o \
 					iscsi_parameters.o \
 					iscsi_seq_and_pdu_list.o \
diff --git a/drivers/target/lio-target/iscsi_crc.c b/drivers/target/lio-target/iscsi_crc.c
deleted file mode 100644
index 456f729..0000000
--- a/drivers/target/lio-target/iscsi_crc.c
+++ /dev/null
@@ -1,171 +0,0 @@
-/*******************************************************************************
- * Filename:  iscsi_crc.c
- *
- * Routine to calculate a "running" crc for iscsi.
- *
- * Copyright (c) 2002, 2003, 2004, 2005 PyX Technologies, Inc.
- * Copyright (c) 2005, 2006, 2007 SBE, Inc.
- * Copyright (c) 2007 Rising Tide Software, Inc.
- *
- * Nicholas A. Bellinger <nab@kernel.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- *
- ******************************************************************************/
-
-#include <linux/slab.h>
-#include <asm/byteorder.h>
-#ifdef __BIG_ENDIAN
-# define ISCSI_BIG_ENDIAN 1
-#endif
-#include <iscsi_crc.h>
-
-/*****************************************************************/
-/*                                                               */
-/* CRC LOOKUP TABLE                                              */
-/* ================                                              */
-/* The following CRC lookup table was generated automagically    */
-/* by the Rocksoft^tm Model CRC Algorithm Table Generation       */
-/* Program V1.0 using the following model parameters:            */
-/*                                                               */
-/*    Width   : 4 bytes.                                         */
-/*    Poly    : 0x1EDC6F41L                                      */
-/*    Reverse : TRUE.                                            */
-/*                                                               */
-/* For more information on the Rocksoft^tm Model CRC Algorithm,  */
-/* see the document titled "A Painless Guide to CRC Error        */
-/* Detection Algorithms" by Ross Williams                        */
-/* (ross@guest.adelaide.edu.au.). This document is likely to be  */
-/* in the FTP archive "ftp.adelaide.edu.au/pub/rocksoft".        */
-/*                                                               */
-/*****************************************************************/
-
-u32  crctable[256] = {
- 0x00000000L, 0xF26B8303L, 0xE13B70F7L, 0x1350F3F4L,
- 0xC79A971FL, 0x35F1141CL, 0x26A1E7E8L, 0xD4CA64EBL,
- 0x8AD958CFL, 0x78B2DBCCL, 0x6BE22838L, 0x9989AB3BL,
- 0x4D43CFD0L, 0xBF284CD3L, 0xAC78BF27L, 0x5E133C24L,
- 0x105EC76FL, 0xE235446CL, 0xF165B798L, 0x030E349BL,
- 0xD7C45070L, 0x25AFD373L, 0x36FF2087L, 0xC494A384L,
- 0x9A879FA0L, 0x68EC1CA3L, 0x7BBCEF57L, 0x89D76C54L,
- 0x5D1D08BFL, 0xAF768BBCL, 0xBC267848L, 0x4E4DFB4BL,
- 0x20BD8EDEL, 0xD2D60DDDL, 0xC186FE29L, 0x33ED7D2AL,
- 0xE72719C1L, 0x154C9AC2L, 0x061C6936L, 0xF477EA35L,
- 0xAA64D611L, 0x580F5512L, 0x4B5FA6E6L, 0xB93425E5L,
- 0x6DFE410EL, 0x9F95C20DL, 0x8CC531F9L, 0x7EAEB2FAL,
- 0x30E349B1L, 0xC288CAB2L, 0xD1D83946L, 0x23B3BA45L,
- 0xF779DEAEL, 0x05125DADL, 0x1642AE59L, 0xE4292D5AL,
- 0xBA3A117EL, 0x4851927DL, 0x5B016189L, 0xA96AE28AL,
- 0x7DA08661L, 0x8FCB0562L, 0x9C9BF696L, 0x6EF07595L,
- 0x417B1DBCL, 0xB3109EBFL, 0xA0406D4BL, 0x522BEE48L,
- 0x86E18AA3L, 0x748A09A0L, 0x67DAFA54L, 0x95B17957L,
- 0xCBA24573L, 0x39C9C670L, 0x2A993584L, 0xD8F2B687L,
- 0x0C38D26CL, 0xFE53516FL, 0xED03A29BL, 0x1F682198L,
- 0x5125DAD3L, 0xA34E59D0L, 0xB01EAA24L, 0x42752927L,
- 0x96BF4DCCL, 0x64D4CECFL, 0x77843D3BL, 0x85EFBE38L,
- 0xDBFC821CL, 0x2997011FL, 0x3AC7F2EBL, 0xC8AC71E8L,
- 0x1C661503L, 0xEE0D9600L, 0xFD5D65F4L, 0x0F36E6F7L,
- 0x61C69362L, 0x93AD1061L, 0x80FDE395L, 0x72966096L,
- 0xA65C047DL, 0x5437877EL, 0x4767748AL, 0xB50CF789L,
- 0xEB1FCBADL, 0x197448AEL, 0x0A24BB5AL, 0xF84F3859L,
- 0x2C855CB2L, 0xDEEEDFB1L, 0xCDBE2C45L, 0x3FD5AF46L,
- 0x7198540DL, 0x83F3D70EL, 0x90A324FAL, 0x62C8A7F9L,
- 0xB602C312L, 0x44694011L, 0x5739B3E5L, 0xA55230E6L,
- 0xFB410CC2L, 0x092A8FC1L, 0x1A7A7C35L, 0xE811FF36L,
- 0x3CDB9BDDL, 0xCEB018DEL, 0xDDE0EB2AL, 0x2F8B6829L,
- 0x82F63B78L, 0x709DB87BL, 0x63CD4B8FL, 0x91A6C88CL,
- 0x456CAC67L, 0xB7072F64L, 0xA457DC90L, 0x563C5F93L,
- 0x082F63B7L, 0xFA44E0B4L, 0xE9141340L, 0x1B7F9043L,
- 0xCFB5F4A8L, 0x3DDE77ABL, 0x2E8E845FL, 0xDCE5075CL,
- 0x92A8FC17L, 0x60C37F14L, 0x73938CE0L, 0x81F80FE3L,
- 0x55326B08L, 0xA759E80BL, 0xB4091BFFL, 0x466298FCL,
- 0x1871A4D8L, 0xEA1A27DBL, 0xF94AD42FL, 0x0B21572CL,
- 0xDFEB33C7L, 0x2D80B0C4L, 0x3ED04330L, 0xCCBBC033L,
- 0xA24BB5A6L, 0x502036A5L, 0x4370C551L, 0xB11B4652L,
- 0x65D122B9L, 0x97BAA1BAL, 0x84EA524EL, 0x7681D14DL,
- 0x2892ED69L, 0xDAF96E6AL, 0xC9A99D9EL, 0x3BC21E9DL,
- 0xEF087A76L, 0x1D63F975L, 0x0E330A81L, 0xFC588982L,
- 0xB21572C9L, 0x407EF1CAL, 0x532E023EL, 0xA145813DL,
- 0x758FE5D6L, 0x87E466D5L, 0x94B49521L, 0x66DF1622L,
- 0x38CC2A06L, 0xCAA7A905L, 0xD9F75AF1L, 0x2B9CD9F2L,
- 0xFF56BD19L, 0x0D3D3E1AL, 0x1E6DCDEEL, 0xEC064EEDL,
- 0xC38D26C4L, 0x31E6A5C7L, 0x22B65633L, 0xD0DDD530L,
- 0x0417B1DBL, 0xF67C32D8L, 0xE52CC12CL, 0x1747422FL,
- 0x49547E0BL, 0xBB3FFD08L, 0xA86F0EFCL, 0x5A048DFFL,
- 0x8ECEE914L, 0x7CA56A17L, 0x6FF599E3L, 0x9D9E1AE0L,
- 0xD3D3E1ABL, 0x21B862A8L, 0x32E8915CL, 0xC083125FL,
- 0x144976B4L, 0xE622F5B7L, 0xF5720643L, 0x07198540L,
- 0x590AB964L, 0xAB613A67L, 0xB831C993L, 0x4A5A4A90L,
- 0x9E902E7BL, 0x6CFBAD78L, 0x7FAB5E8CL, 0x8DC0DD8FL,
- 0xE330A81AL, 0x115B2B19L, 0x020BD8EDL, 0xF0605BEEL,
- 0x24AA3F05L, 0xD6C1BC06L, 0xC5914FF2L, 0x37FACCF1L,
- 0x69E9F0D5L, 0x9B8273D6L, 0x88D28022L, 0x7AB90321L,
- 0xAE7367CAL, 0x5C18E4C9L, 0x4F48173DL, 0xBD23943EL,
- 0xF36E6F75L, 0x0105EC76L, 0x12551F82L, 0xE03E9C81L,
- 0x34F4F86AL, 0xC69F7B69L, 0xD5CF889DL, 0x27A40B9EL,
- 0x79B737BAL, 0x8BDCB4B9L, 0x988C474DL, 0x6AE7C44EL,
- 0xBE2DA0A5L, 0x4C4623A6L, 0x5F16D052L, 0xAD7D5351L
-};
-
-/*****************************************************************/
-/*                   End of CRC Lookup Table                     */
-/*****************************************************************/
-
-/*****************************************************************/
-/*                   ComputeCRC                                  */
-/*****************************************************************/
-
-#define TB_INIT 0xFFFFFFFF
-#define TB_INIT_REFLECTED 0xFFFFFFFF
-#define TB_XOROT 0xFFFFFFFF
-
-/*	If restart has 0x01 set, initialize the accumulator.
- *
- *
- */
-inline void do_crc(u8 *data, u32 len, int restart, u32 *result)
-{
-#ifdef ISCSI_BIG_ENDIAN
-	u8 byte0, byte1, byte2, byte3;
-#endif
-	u32 crc_calc;
-
-	if (restart & 0x01)
-		crc_calc = TB_INIT_REFLECTED;
-	else {
-#ifdef ISCSI_BIG_ENDIAN
-		byte0 = ((*result >> 24) & 0xff);
-		byte1 = ((*result >> 16) & 0xff);
-		byte2 = ((*result >> 8) & 0xff);
-		byte3 = (*result & 0xff);
-		*result = ((byte3 << 24) | (byte2 << 16) |
-			   (byte1 << 8) | (byte0));
-#endif
-		crc_calc = *result ^ TB_XOROT;
-	}
-
-	while (len-- > 0)
-		crc_calc = crctable[(crc_calc ^ *data++) & 0xFFL] ^
-				    (crc_calc >> 8);
-
-	*result = crc_calc ^ TB_XOROT;
-#ifdef ISCSI_BIG_ENDIAN
-	byte0 = ((*result >> 24) & 0xff);
-	byte1 = ((*result >> 16) & 0xff);
-	byte2 = ((*result >> 8) & 0xff);
-	byte3 = (*result & 0xff);
-	*result = ((byte3 << 24) | (byte2 << 16) | (byte1 << 8) | (byte0));
-#endif
-}
diff --git a/drivers/target/lio-target/iscsi_crc.h b/drivers/target/lio-target/iscsi_crc.h
deleted file mode 100644
index f97570b..0000000
--- a/drivers/target/lio-target/iscsi_crc.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef _ISCSI_CRC_H_
-#define _ISCSI_CRC_H_
-
-/*	calculate a 32-bit crc	*/
-/*	if restart has 0x01 set, initialize the accumulator */
-/*	if restart has 0x02 set, save result in network byte order */
-extern void do_crc(__u8 *data, __u32 len, int restart, __u32 *result);
-
-#endif /*** _ISCSI_CRC_H_ ***/
diff --git a/drivers/target/lio-target/iscsi_target.c b/drivers/target/lio-target/iscsi_target.c
index 1b51c0e..59f3e87 100644
--- a/drivers/target/lio-target/iscsi_target.c
+++ b/drivers/target/lio-target/iscsi_target.c
@@ -42,6 +42,7 @@
 #include <linux/smp_lock.h>
 #include <linux/in.h>
 #include <linux/utsname.h>
+#include <linux/crypto.h>
 #include <net/sock.h>
 #include <net/tcp.h>
 
@@ -65,7 +66,6 @@
 #include <iscsi_target.h>
 #include <iscsi_target_device.h>
 
-#include <iscsi_crc.h>
 #include <iscsi_parameters.h>
 #include <iscsi_thread_queue.h>
 
@@ -1969,10 +1969,9 @@ static inline int iscsi_handle_data_out(struct iscsi_conn *conn, unsigned char *
 		return -1;
 
 	if (CONN_OPS(conn)->DataDigest) {
-		__u8 reset_crc = 1;
 		__u32 counter = hdr->length, data_crc = 0;
 		struct iovec *iov_ptr = &SE_CMD(cmd)->iov_data[0];
-
+		struct scatterlist sg;
 		/*
 		 * Thanks to the IP stack shitting on passed iovecs,  we have to
 		 * call set_iovec_data_ptrs() again in order to have a iMD/PSCSI
@@ -1989,10 +1988,14 @@ static inline int iscsi_handle_data_out(struct iscsi_conn *conn, unsigned char *
 					&map_sg, &unmap_sg) < 0)
 			return -1;
 
+		crypto_hash_init(&conn->conn_rx_hash);
+
 		while (counter > 0) {
-			do_crc(iov_ptr->iov_base, iov_ptr->iov_len,
-				reset_crc, &data_crc);
-			reset_crc = 0;
+			sg_init_one(&sg, iov_ptr->iov_base,
+					iov_ptr->iov_len);
+			crypto_hash_update(&conn->conn_rx_hash, &sg,
+					iov_ptr->iov_len);
+
 			TRACE(TRACE_DIGEST, "Computed CRC32C DataDigest %d"
 				" bytes, CRC 0x%08x\n", iov_ptr->iov_len,
 				data_crc);
@@ -2001,13 +2004,15 @@ static inline int iscsi_handle_data_out(struct iscsi_conn *conn, unsigned char *
 		}
 
 		if (padding) {
-			do_crc((__u8 *)&pad_bytes, padding,
-				reset_crc, &data_crc);
-			reset_crc = 0;
+			sg_init_one(&sg, (__u8 *)&pad_bytes, padding);
+			crypto_hash_update(&conn->conn_rx_hash, &sg,
+					padding);
 			TRACE(TRACE_DIGEST, "Computed CRC32C DataDigest %d"
 				" bytes of padding, CRC 0x%08x\n",
 				padding, data_crc);
 		}
+		crypto_hash_final(&conn->conn_rx_hash, (u8 *)&data_crc);
+
 #ifdef DEBUG_ERL
 		if (iscsi_target_debugerl_data_out_0(conn, buf) < 0)
 			data_crc = 0;
@@ -2078,11 +2083,11 @@ static inline int iscsi_handle_nop_out(
 {
 	unsigned char *ping_data = NULL;
 	int cmdsn_ret, niov = 0, ret = 0, rx_got, rx_size;
-	__u8 reset_crc = 1;
 	__u32 checksum, data_crc, padding = 0;
 	struct iscsi_cmd *cmd = NULL;
 	struct iovec *iov = NULL;
 	struct iscsi_init_nop_out *hdr;
+	struct scatterlist sg;
 
 	hdr			= (struct iscsi_init_nop_out *) buf;
 	hdr->length		= be32_to_cpu(hdr->length);
@@ -2174,12 +2179,20 @@ static inline int iscsi_handle_nop_out(
 		}
 
 		if (CONN_OPS(conn)->DataDigest) {
-			do_crc((__u8 *) ping_data, hdr->length,
-				reset_crc, &data_crc);
-			reset_crc = 0;
-			if (padding)
-				do_crc((__u8 *)&cmd->pad_bytes, padding,
-					reset_crc, &data_crc);
+			crypto_hash_init(&conn->conn_rx_hash);
+
+			sg_init_one(&sg, (u8 *)ping_data, hdr->length);
+			crypto_hash_update(&conn->conn_rx_hash, &sg,
+					hdr->length);
+
+			if (padding) {
+				sg_init_one(&sg, (u8 *)&cmd->pad_bytes,
+					padding);
+				crypto_hash_update(&conn->conn_rx_hash, &sg,
+					padding);
+			}
+			crypto_hash_final(&conn->conn_rx_hash, (u8 *)&data_crc);
+
 			if (checksum != data_crc) {
 				printk(KERN_ERR "Ping data CRC32C DataDigest"
 				" 0x%08x does not match computed 0x%08x\n",
@@ -2475,12 +2488,12 @@ static inline int iscsi_handle_text_cmd(
 {
 	char *text_ptr, *text_in;
 	int cmdsn_ret, niov = 0, rx_got, rx_size;
-	__u8 reset_crc = 1;
 	__u32 checksum = 0, data_crc = 0;
 	__u32 padding = 0, pad_bytes = 0, text_length = 0;
 	struct iscsi_cmd *cmd;
 	struct iovec iov[3];
 	struct iscsi_init_text_cmnd *hdr;
+	struct scatterlist sg;
 
 	hdr			= (struct iscsi_init_text_cmnd *) buf;
 	hdr->length		= be32_to_cpu(hdr->length);
@@ -2538,12 +2551,19 @@ static inline int iscsi_handle_text_cmd(
 		}
 
 		if (CONN_OPS(conn)->DataDigest) {
-			do_crc((__u8 *) text_in, text_length,
-				reset_crc, &data_crc);
-			reset_crc = 0;
-			if (padding)
-				do_crc((__u8 *)&pad_bytes, padding,
-					reset_crc, &data_crc);
+			crypto_hash_init(&conn->conn_rx_hash);
+
+			sg_init_one(&sg, (u8 *)text_in, text_length);
+			crypto_hash_update(&conn->conn_rx_hash, &sg,
+					text_length);
+
+			if (padding) {
+				sg_init_one(&sg, (u8 *)&pad_bytes, padding);
+				crypto_hash_update(&conn->conn_rx_hash, &sg,
+						padding);
+			}
+			crypto_hash_final(&conn->conn_rx_hash, (u8 *)&data_crc);	
+
 			if (checksum != data_crc) {
 				printk(KERN_ERR "Text data CRC32C DataDigest"
 					" 0x%08x does not match computed"
@@ -2979,10 +2999,9 @@ static int iscsi_handle_immediate_data(
 	}
 
 	if (CONN_OPS(conn)->DataDigest) {
-		__u8 reset_crc = 1;
 		__u32 counter = length, data_crc;
 		struct iovec *iov_ptr = &SE_CMD(cmd)->iov_data[0];
-
+		struct scatterlist sg;
 		/*
 		 * Thanks to the IP stack shitting on passed iovecs,  we have to
 		 * call set_iovec_data_ptrs again in order to have a iMD/PSCSI
@@ -2999,10 +3018,14 @@ static int iscsi_handle_immediate_data(
 					&unmap_sg) < 0)
 			return IMMEDIDATE_DATA_CANNOT_RECOVER;
 
+		crypto_hash_init(&conn->conn_rx_hash);
+
 		while (counter > 0) {
-			do_crc(iov_ptr->iov_base, iov_ptr->iov_len,
-				reset_crc, &data_crc);
-			reset_crc = 0;
+			sg_init_one(&sg, iov_ptr->iov_base,
+					iov_ptr->iov_len);
+			crypto_hash_update(&conn->conn_rx_hash, &sg,
+					iov_ptr->iov_len);
+
 			TRACE(TRACE_DIGEST, "Computed CRC32C DataDigest %d"
 			" bytes, CRC 0x%08x\n", iov_ptr->iov_len, data_crc);
 			counter -= iov_ptr->iov_len;
@@ -3010,12 +3033,13 @@ static int iscsi_handle_immediate_data(
 		}
 
 		if (padding) {
-			do_crc((__u8 *)&pad_bytes, padding,
-				reset_crc, &data_crc);
-			reset_crc = 0;
+			sg_init_one(&sg, (__u8 *)&pad_bytes, padding);
+			crypto_hash_update(&conn->conn_rx_hash, &sg,
+					padding);
 			TRACE(TRACE_DIGEST, "Computed CRC32C DataDigest %d"
 			" bytes of padding, CRC 0x%08x\n", padding, data_crc);
 		}
+		crypto_hash_final(&conn->conn_rx_hash, (u8 *)&data_crc);
 
 #ifdef DEBUG_ERL
 		if (iscsi_target_debugerl_immeidate_data(conn,
@@ -3076,6 +3100,7 @@ int iscsi_send_async_msg(
 	struct timer_list async_msg_timer;
 	struct iscsi_targ_async_msg *hdr;
 	struct iovec iov;
+	struct scatterlist sg;
 
 	memset((void *)&iov, 0, sizeof(struct iovec));
 	memset((void *)&iscsi_hdr, 0, ISCSI_HDR_LEN);
@@ -3139,8 +3164,15 @@ int iscsi_send_async_msg(
 	iov.iov_len	= ISCSI_HDR_LEN;
 
 	if (CONN_OPS(conn)->HeaderDigest) {
-		do_crc((__u8 *)&iscsi_hdr, ISCSI_HDR_LEN, 0x01,
-				&hdr->header_digest);
+		crypto_hash_init(&conn->conn_tx_hash);
+		
+		sg_init_one(&sg, (u8 *)&iscsi_hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg,
+				ISCSI_HDR_LEN);
+
+		crypto_hash_final(&conn->conn_tx_hash,
+				(u8 *)&hdr->header_digest);
+
 		iov.iov_len += CRC_LEN;
 		tx_send += CRC_LEN;
 		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest for Async"
@@ -3235,6 +3267,7 @@ static int iscsi_send_conn_drop_async_message(
 	struct iscsi_conn *conn)
 {
 	struct iscsi_targ_async_msg *hdr;
+	struct scatterlist sg;
 
 	cmd->tx_size = ISCSI_HDR_LEN;
 	cmd->iscsi_opcode = ISCSI_TARG_ASYNC_MSG;
@@ -3257,8 +3290,15 @@ static int iscsi_send_conn_drop_async_message(
 			cpu_to_be16(SESS_OPS_C(conn)->DefaultTime2Retain);
 
 	if (CONN_OPS(conn)->HeaderDigest) {
-		do_crc((unsigned char *)hdr, ISCSI_HDR_LEN,
-			0x01, &hdr->header_digest);
+		crypto_hash_init(&conn->conn_tx_hash);
+		
+		sg_init_one(&sg, (u8 *)hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg,
+				ISCSI_HDR_LEN);
+
+		crypto_hash_final(&conn->conn_tx_hash,
+				(u8 *)&hdr->header_digest);
+
 		cmd->tx_size += CRC_LEN;
 		TRACE(TRACE_DIGEST, "Attaching CRC32C HeaderDigest to"
 			" Async Message 0x%08x\n", hdr->header_digest);
@@ -3298,13 +3338,14 @@ static inline int iscsi_send_data_in(
 	int *eodr)
 {
 	int iov_ret = 0, set_statsn = 0;
-	__u8 *pad_bytes, reset_crc = 1;
+	__u8 *pad_bytes;
 	__u32 iov_count = 0, tx_size = 0;
 	struct iscsi_datain datain;
 	struct iscsi_datain_req *dr;
 	struct se_map_sg map_sg;
 	struct iscsi_targ_scsi_data_in *hdr;
 	struct iovec *iov;
+	struct scatterlist sg;
 
 	memset(&datain, 0, sizeof(struct iscsi_datain));
 	dr = iscsi_get_datain_values(cmd, &datain);
@@ -3385,8 +3426,15 @@ static inline int iscsi_send_data_in(
 	tx_size += ISCSI_HDR_LEN;
 
 	if (CONN_OPS(conn)->HeaderDigest) {
-		do_crc((__u8 *)hdr, ISCSI_HDR_LEN, 0x01,
-			&hdr->header_digest);
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg,
+				ISCSI_HDR_LEN);	
+
+		crypto_hash_final(&conn->conn_tx_hash,
+				(u8 *)&hdr->header_digest);
+
 		iov[0].iov_len += CRC_LEN;
 		tx_size += CRC_LEN;
 		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest"
@@ -3428,16 +3476,23 @@ static inline int iscsi_send_data_in(
 	if (CONN_OPS(conn)->DataDigest) {
 		__u32 counter = (datain.length + unmap_sg->padding);
 		struct iovec *iov_ptr = &SE_CMD(cmd)->iov_data[1];
+
+		crypto_hash_init(&conn->conn_tx_hash);
+
 		while (counter > 0) {
-			do_crc((__u8 *)iov_ptr->iov_base, iov_ptr->iov_len,
-				reset_crc, &cmd->data_crc);
-			reset_crc = 0;
+			sg_init_one(&sg, iov_ptr->iov_base,
+					iov_ptr->iov_len);
+			crypto_hash_update(&conn->conn_tx_hash, &sg,
+					iov_ptr->iov_len);
+
 			TRACE(TRACE_DIGEST, "Computed CRC32C DataDigest %u"
 				" bytes, crc 0x%08x\n", iov_ptr->iov_len,
 					cmd->data_crc);
 			counter -= iov_ptr->iov_len;
 			iov_ptr++;
 		}
+		crypto_hash_final(&conn->conn_tx_hash, (u8 *)&cmd->data_crc);
+
 		iov[iov_count].iov_base	= &cmd->data_crc;
 		iov[iov_count++].iov_len = CRC_LEN;
 		tx_size += CRC_LEN;
@@ -3482,7 +3537,7 @@ static inline int iscsi_send_logout_response(
 	struct iscsi_session *sess = SESS(conn);
 	struct iovec *iov;
 	struct iscsi_targ_logout_rsp *hdr;
-
+	struct scatterlist sg;
 	/*
 	 * The actual shutting down of Sessions and/or Connections
 	 * for CLOSESESSION and CLOSECONNECTION Logout Requests
@@ -3570,8 +3625,15 @@ static inline int iscsi_send_logout_response(
 	iov[niov++].iov_len	= ISCSI_HDR_LEN;
 
 	if (CONN_OPS(conn)->HeaderDigest) {
-		do_crc((unsigned char *)hdr, ISCSI_HDR_LEN,
-			0x01, &hdr->header_digest);
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg,
+				ISCSI_HDR_LEN); 
+
+		crypto_hash_final(&conn->conn_tx_hash,
+				(u8 *)&hdr->header_digest);
+
 		iov[0].iov_len += CRC_LEN;
 		tx_size += CRC_LEN;
 		TRACE(TRACE_DIGEST, "Attaching CRC32C HeaderDigest to"
@@ -3601,6 +3663,7 @@ static inline int iscsi_send_unsolicited_nopin(
 {
 	int tx_size = ISCSI_HDR_LEN;
 	struct iscsi_targ_nop_in *hdr;
+	struct scatterlist sg;
 
 	hdr			= (struct iscsi_targ_nop_in *) cmd->pdu;
 	memset(hdr, 0, ISCSI_HDR_LEN);
@@ -3616,8 +3679,15 @@ static inline int iscsi_send_unsolicited_nopin(
 	hdr->max_cmd_sn		= cpu_to_be32(SESS(conn)->max_cmd_sn);
 
 	if (CONN_OPS(conn)->HeaderDigest) {
-		do_crc((unsigned char *)hdr, ISCSI_HDR_LEN,
-			0x01, &hdr->header_digest);
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg,
+				ISCSI_HDR_LEN); 
+
+		crypto_hash_final(&conn->conn_tx_hash,
+				(u8 *)&hdr->header_digest);
+
 		tx_size += CRC_LEN;
 		TRACE(TRACE_DIGEST, "Attaching CRC32C HeaderDigest to"
 			" NopIN 0x%08x\n", hdr->header_digest);
@@ -3646,10 +3716,10 @@ static inline int iscsi_send_nopin_response(
 	struct iscsi_conn *conn)
 {
 	int niov = 0, tx_size;
-	__u8 reset_crc = 1;
 	__u32 padding = 0;
 	struct iovec *iov;
 	struct iscsi_targ_nop_in *hdr;
+	struct scatterlist sg;
 
 	tx_size = ISCSI_HDR_LEN;
 	hdr			= (struct iscsi_targ_nop_in *) cmd->pdu;
@@ -3672,8 +3742,15 @@ static inline int iscsi_send_nopin_response(
 	iov[niov++].iov_len	= ISCSI_HDR_LEN;
 
 	if (CONN_OPS(conn)->HeaderDigest) {
-		do_crc((__u8 *)hdr, ISCSI_HDR_LEN,
-				0x01, &hdr->header_digest);
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg,
+				ISCSI_HDR_LEN); 
+
+		crypto_hash_final(&conn->conn_tx_hash,
+				(u8 *)&hdr->header_digest);
+
 		iov[0].iov_len += CRC_LEN;
 		tx_size += CRC_LEN;
 		TRACE(TRACE_DIGEST, "Attaching CRC32C HeaderDigest"
@@ -3701,12 +3778,21 @@ static inline int iscsi_send_nopin_response(
 				" padding bytes.\n", padding);
 		}
 		if (CONN_OPS(conn)->DataDigest) {
-			do_crc((__u8 *)cmd->buf_ptr, cmd->buf_ptr_size,
-				reset_crc, &cmd->data_crc);
-			reset_crc = 0;
-			if (padding)
-				do_crc((__u8 *)&cmd->pad_bytes, padding,
-					reset_crc, &cmd->data_crc);
+			crypto_hash_init(&conn->conn_tx_hash);
+
+			sg_init_one(&sg, (u8 *)cmd->buf_ptr,
+					cmd->buf_ptr_size);
+			crypto_hash_update(&conn->conn_tx_hash, &sg,
+					cmd->buf_ptr_size);
+
+			if (padding) {
+				sg_init_one(&sg, (u8 *)&cmd->pad_bytes, padding);
+				crypto_hash_update(&conn->conn_tx_hash, &sg,
+						padding);	
+			}
+
+			crypto_hash_final(&conn->conn_tx_hash,
+					(u8 *)&cmd->data_crc);
 
 			iov[niov].iov_base = &cmd->data_crc;
 			iov[niov++].iov_len = CRC_LEN;
@@ -3743,6 +3829,7 @@ int iscsi_send_r2t(
 	__u32 trace_type;
 	struct iscsi_r2t *r2t;
 	struct iscsi_targ_r2t *hdr;
+	struct scatterlist sg;
 
 	r2t = iscsi_get_r2t_from_list(cmd);
 	if (!(r2t))
@@ -3772,7 +3859,14 @@ int iscsi_send_r2t(
 	tx_size += ISCSI_HDR_LEN;
 
 	if (CONN_OPS(conn)->HeaderDigest) {
-		do_crc((__u8 *)hdr, ISCSI_HDR_LEN, 0x01, &hdr->header_digest);
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg,
+				ISCSI_HDR_LEN); 
+
+		crypto_hash_final(&conn->conn_tx_hash, (u8 *)&hdr->header_digest);
+
 		cmd->iov_misc[0].iov_len += CRC_LEN;
 		tx_size += CRC_LEN;
 		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest for R2T"
@@ -3952,6 +4046,7 @@ static inline int iscsi_send_status(
 	__u32 padding = 0, trace_type, tx_size = 0;
 	struct iscsi_targ_scsi_rsp *hdr;
 	struct iovec *iov;
+	struct scatterlist sg;
 
 	recovery = (cmd->i_state != ISTATE_SEND_STATUS);
 	if (!recovery)
@@ -4009,9 +4104,16 @@ static inline int iscsi_send_status(
 		}
 
 		if (CONN_OPS(conn)->DataDigest) {
-			do_crc((__u8 *)SE_CMD(cmd)->sense_buffer,
-				(SE_CMD(cmd)->scsi_sense_length + padding),
-					0x01, &cmd->data_crc);
+			crypto_hash_init(&conn->conn_tx_hash);
+
+			sg_init_one(&sg, (u8 *)SE_CMD(cmd)->sense_buffer,
+				(SE_CMD(cmd)->scsi_sense_length + padding));
+			crypto_hash_update(&conn->conn_tx_hash, &sg,
+				(SE_CMD(cmd)->scsi_sense_length + padding));
+
+			crypto_hash_final(&conn->conn_tx_hash,
+					(u8 *)&cmd->data_crc);
+
 			iov[iov_count].iov_base    = &cmd->data_crc;
 			iov[iov_count++].iov_len     = CRC_LEN;
 			tx_size += CRC_LEN;
@@ -4028,7 +4130,15 @@ static inline int iscsi_send_status(
 	}
 
 	if (CONN_OPS(conn)->HeaderDigest) {
-		do_crc((__u8 *)hdr, ISCSI_HDR_LEN, 0x01, &hdr->header_digest);
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg,
+				ISCSI_HDR_LEN); 
+
+		crypto_hash_final(&conn->conn_tx_hash,
+				(u8 *)&hdr->header_digest);
+
 		iov[0].iov_len += CRC_LEN;
 		tx_size += CRC_LEN;
 		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest for Response"
@@ -4071,6 +4181,7 @@ static int iscsi_send_task_mgt_rsp(
 {
 	struct se_tmr_req *se_tmr = SE_CMD(cmd)->se_tmr_req;
 	struct iscsi_targ_task_mgt_rsp *hdr;
+	struct scatterlist sg;
 	u32 tx_size = 0;
 
 	hdr			= (struct iscsi_targ_task_mgt_rsp *) cmd->pdu;
@@ -4090,7 +4201,15 @@ static int iscsi_send_task_mgt_rsp(
 	tx_size += ISCSI_HDR_LEN;
 
 	if (CONN_OPS(conn)->HeaderDigest) {
-		do_crc((__u8 *)hdr, ISCSI_HDR_LEN, 0x01, &hdr->header_digest);
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg,
+				ISCSI_HDR_LEN); 
+
+		crypto_hash_final(&conn->conn_tx_hash,
+				(u8 *)&hdr->header_digest);
+
 		cmd->iov_misc[0].iov_len += CRC_LEN;
 		tx_size += CRC_LEN;
 		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest for Task"
@@ -4125,6 +4244,7 @@ static int iscsi_send_text_rsp(
 	__u32 padding = 0, text_length = 0, tx_size = 0;
 	struct iscsi_targ_text_rsp *hdr;
 	struct iovec *iov;
+	struct scatterlist sg;
 
 	text_length = iscsi_build_sendtargets_response(cmd);
 
@@ -4159,8 +4279,15 @@ static int iscsi_send_text_rsp(
 	tx_size += (ISCSI_HDR_LEN + text_length + padding);
 
 	if (CONN_OPS(conn)->HeaderDigest) {
-		do_crc((__u8 *)hdr, ISCSI_HDR_LEN, 0x01,
-			&hdr->header_digest);
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg,
+				ISCSI_HDR_LEN); 
+
+		crypto_hash_final(&conn->conn_tx_hash,
+				(u8 *)&hdr->header_digest);
+
 		iov[0].iov_len += CRC_LEN;
 		tx_size += CRC_LEN;
 		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest for"
@@ -4168,8 +4295,15 @@ static int iscsi_send_text_rsp(
 	}
 
 	if (CONN_OPS(conn)->DataDigest) {
-		do_crc((__u8 *) cmd->buf_ptr, text_length + padding,
-				0x01, &cmd->data_crc);
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)cmd->buf_ptr, (text_length + padding));
+		crypto_hash_update(&conn->conn_tx_hash, &sg,
+				(text_length + padding));
+
+		crypto_hash_final(&conn->conn_tx_hash,
+				(u8 *)&cmd->data_crc);
+
 		iov[iov_count].iov_base	= &cmd->data_crc;
 		iov[iov_count++].iov_len = CRC_LEN;
 		tx_size	+= CRC_LEN;
@@ -4203,6 +4337,7 @@ static int iscsi_send_reject(
 	__u32 iov_count = 0, tx_size = 0;
 	struct iscsi_targ_rjt *hdr;
 	struct iovec *iov;
+	struct scatterlist sg;
 
 	hdr			= (struct iscsi_targ_rjt *) cmd->pdu;
 	hdr->opcode		= ISCSI_TARG_RJT;
@@ -4224,8 +4359,15 @@ static int iscsi_send_reject(
 	tx_size = (ISCSI_HDR_LEN + ISCSI_HDR_LEN);
 
 	if (CONN_OPS(conn)->HeaderDigest) {
-		do_crc((__u8 *)hdr, ISCSI_HDR_LEN, 0x01,
-				&hdr->header_digest);
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg,
+				ISCSI_HDR_LEN); 
+
+		crypto_hash_final(&conn->conn_tx_hash,
+				(u8 *)&hdr->header_digest);
+
 		iov[0].iov_len += CRC_LEN;
 		tx_size += CRC_LEN;
 		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest for"
@@ -4233,8 +4375,15 @@ static int iscsi_send_reject(
 	}
 
 	if (CONN_OPS(conn)->DataDigest) {
-		do_crc((__u8 *)cmd->buf_ptr, ISCSI_HDR_LEN, 0x01,
-				&cmd->data_crc);
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)cmd->buf_ptr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg,
+				ISCSI_HDR_LEN);
+
+		crypto_hash_final(&conn->conn_tx_hash,
+				(u8 *)&cmd->data_crc);
+
 		iov[iov_count].iov_base = &cmd->data_crc;
 		iov[iov_count++].iov_len  = CRC_LEN;
 		tx_size += CRC_LEN;
@@ -4648,6 +4797,7 @@ int iscsi_target_rx_thread(void *arg)
 	struct iscsi_conn *conn = NULL;
 	struct se_thread_set *ts = (struct se_thread_set *) arg;
 	struct iovec iov;
+	struct scatterlist sg;
 
 	{
 	    static unsigned int x = 1;  /* unique number added to thread name */
@@ -4699,7 +4849,14 @@ restart:
 			if (iscsi_target_debugerl_rx_thread1(conn) < 0)
 				digest = 0;
 #endif /* DEBUG_ERL */
-			do_crc(buffer, ISCSI_HDR_LEN, 0x01, &checksum);
+			crypto_hash_init(&conn->conn_rx_hash);
+
+			sg_init_one(&sg, (u8 *)buffer, ISCSI_HDR_LEN);
+			crypto_hash_update(&conn->conn_rx_hash, &sg,
+					ISCSI_HDR_LEN);
+
+			crypto_hash_final(&conn->conn_rx_hash, (u8 *)&checksum);
+
 			if (digest != checksum) {
 				printk(KERN_ERR "HeaderDigest CRC32C failed,"
 					" received 0x%08x, computed 0x%08x\n",
@@ -4976,6 +5133,11 @@ int iscsi_close_connection(
 	 */
 	iscsi_check_conn_usage_count(conn);
 
+	if (conn->conn_rx_hash.tfm)
+		crypto_free_hash(conn->conn_rx_hash.tfm);
+	if (conn->conn_tx_hash.tfm)
+		crypto_free_hash(conn->conn_tx_hash.tfm);
+
 	kfree(conn->conn_ops);
 	conn->conn_ops = NULL;
 
diff --git a/drivers/target/lio-target/iscsi_target_core.h b/drivers/target/lio-target/iscsi_target_core.h
index 7fa24b1..586e14e 100644
--- a/drivers/target/lio-target/iscsi_target_core.h
+++ b/drivers/target/lio-target/iscsi_target_core.h
@@ -583,6 +583,9 @@ struct iscsi_conn {
 	spinlock_t		nopin_timer_lock;
 	spinlock_t		response_queue_lock;
 	spinlock_t		state_lock;
+	/* libcrypto RX and TX contexts for crc32c */
+	struct hash_desc	conn_rx_hash;
+	struct hash_desc	conn_tx_hash;
 	/* list_head of struct iscsi_cmd for this connection */
 	struct list_head	conn_cmd_list;
 	struct list_head	immed_queue_list;
diff --git a/drivers/target/lio-target/iscsi_target_erl1.c b/drivers/target/lio-target/iscsi_target_erl1.c
index 6de09e1..1c3b8b9 100644
--- a/drivers/target/lio-target/iscsi_target_erl1.c
+++ b/drivers/target/lio-target/iscsi_target_erl1.c
@@ -38,7 +38,6 @@
 
 #include <iscsi_protocol.h>
 #include <iscsi_debug_opcodes.h>
-#include <iscsi_crc.h>
 #include <iscsi_debug.h>
 
 #include <target/target_core_base.h>
diff --git a/drivers/target/lio-target/iscsi_target_erl2.c b/drivers/target/lio-target/iscsi_target_erl2.c
index 86200be..0cebd4d 100644
--- a/drivers/target/lio-target/iscsi_target_erl2.c
+++ b/drivers/target/lio-target/iscsi_target_erl2.c
@@ -38,7 +38,6 @@
 
 #include <iscsi_protocol.h>
 #include <iscsi_debug_opcodes.h>
-#include <iscsi_crc.h>
 #include <iscsi_debug.h>
 #include <iscsi_target_core.h>
 #include <target/target_core_base.h>
diff --git a/drivers/target/lio-target/iscsi_target_login.c b/drivers/target/lio-target/iscsi_target_login.c
index 25b9345..a51296d 100644
--- a/drivers/target/lio-target/iscsi_target_login.c
+++ b/drivers/target/lio-target/iscsi_target_login.c
@@ -33,6 +33,7 @@
 #include <linux/smp_lock.h>
 #include <linux/in.h>
 #include <linux/inet.h>
+#include <linux/crypto.h>
 #include <net/sock.h>
 #include <net/tcp.h>
 #include <net/ipv6.h>
@@ -57,7 +58,7 @@
  *
  *
  */
-static void iscsi_login_init_conn(struct iscsi_conn *conn)
+static int iscsi_login_init_conn(struct iscsi_conn *conn)
 {
 	INIT_LIST_HEAD(&conn->conn_list);
 	INIT_LIST_HEAD(&conn->conn_cmd_list);
@@ -78,6 +79,27 @@ static void iscsi_login_init_conn(struct iscsi_conn *conn)
 	spin_lock_init(&conn->nopin_timer_lock);
 	spin_lock_init(&conn->response_queue_lock);
 	spin_lock_init(&conn->state_lock);
+	/*
+	 * Setup the RX and TX libcrypto contexts
+	 */
+	conn->conn_rx_hash.flags = 0;
+	conn->conn_rx_hash.tfm = crypto_alloc_hash("crc32c", 0,
+						CRYPTO_ALG_ASYNC);
+	if (IS_ERR(conn->conn_rx_hash.tfm)) {
+		printk(KERN_ERR "crypto_alloc_hash() failed for conn_rx_tfm\n");
+		return -ENOMEM;
+	}
+
+	conn->conn_tx_hash.flags = 0;
+	conn->conn_tx_hash.tfm = crypto_alloc_hash("crc32c", 0,
+						CRYPTO_ALG_ASYNC);
+	if (IS_ERR(conn->conn_tx_hash.tfm)) {	
+		printk(KERN_ERR "crypto_alloc_hash() failed for conn_tx_tfm\n");
+		crypto_free_hash(conn->conn_rx_hash.tfm);
+		return -ENOMEM;
+	}
+
+	return 0;
 }
 
 /*	iscsi_login_check_initiator_version():
@@ -1062,7 +1084,11 @@ get_new_sock:
 			" struct iscsi_conn_ops.\n");
 		goto new_sess_out;
 	}
-	iscsi_login_init_conn(conn);
+	/*
+	 * Perform the remaining iSCSI connection initialization items..
+	 */
+	if (iscsi_login_init_conn(conn) < 0)
+		goto new_sess_out;
 
 	memset(buffer, 0, ISCSI_HDR_LEN);
 	memset(&iov, 0, sizeof(struct iovec));
@@ -1282,6 +1308,11 @@ old_sess_out:
 		iscsi_dec_session_usage_count(SESS(conn));
 	}
 
+	if (conn->conn_rx_hash.tfm)
+		crypto_free_hash(conn->conn_rx_hash.tfm);
+	if (conn->conn_tx_hash.tfm)
+		crypto_free_hash(conn->conn_tx_hash.tfm);
+
 	kfree(conn->conn_ops);
 
 	if (conn->param_list) {
diff --git a/drivers/target/lio-target/iscsi_target_nego.c b/drivers/target/lio-target/iscsi_target_nego.c
index c963ea9..8f28993 100644
--- a/drivers/target/lio-target/iscsi_target_nego.c
+++ b/drivers/target/lio-target/iscsi_target_nego.c
@@ -49,7 +49,6 @@
 #include <iscsi_target.h>
 #include <iscsi_auth_kernel.h>
 #include <iscsi_parameters.h>
-#include <iscsi_crc.h>
 
 #define MAX_LOGIN_PDUS	7
 
diff --git a/drivers/target/lio-target/iscsi_target_tmr.c b/drivers/target/lio-target/iscsi_target_tmr.c
index 8a62939..4ab46bb 100644
--- a/drivers/target/lio-target/iscsi_target_tmr.c
+++ b/drivers/target/lio-target/iscsi_target_tmr.c
@@ -34,7 +34,6 @@
 #include <iscsi_debug.h>
 #include <iscsi_protocol.h>
 #include <iscsi_debug_opcodes.h>
-#include <iscsi_crc.h>
 #include <iscsi_debug.h>
 #include <iscsi_target_core.h>
 #include <target/target_core_base.h>
-- 
1.5.6.5
