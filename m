Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE69146A7A;
	Fri, 29 Nov 2024 15:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732894832; cv=none; b=kX37IQ4Dy6Lvur40t8fCxzlB/uPprjtYC5jqx1E42JyStRQVE1CcKv/sYsZhSekV/mjci5sJqfSMV/k/P9BJeWsfE/oJjwTNSJlf/rmDNfV1UF7prseSCS56FQoO7XK25Tk3aWNxc0MEkj9s06Ytz6Fa+hT9O+Gvg593vlhZqN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732894832; c=relaxed/simple;
	bh=mYWjTwMbSUBTPCSWNXtmWRfN8xrM7jV2NHElXXLeKn8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W4xgnNX8qhXCg/tUZfep/OolDvyhZ0XV3zIi/cC+Jv6zZa+eqWJzIERtqeZJ6A4MBb6up3D/V44Dcq5PTMzGK1ZJNDIsaVoXB2q7xNQ9x4r316PawbLaiCU6LsB8+FzvQf7b+4Pp3M1qrHtotlUkmAtoeGXUdFbUKPPNjouWwNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=lDmjvl27; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=K2w7m/mW; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="lDmjvl27";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="K2w7m/mW"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com CF8A2E0008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1732894345; bh=Kc1h4J+DLLOsDo7zjYah/KNP7IJRC9IKfhrhGCJecS4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=lDmjvl27taBt0i/8nyinEgNem7nl8V1MuKV7aXY+PdwFKLw01Kr+bWV02FDe0Z9Zg
	 HNYn5pKT+9c2UyzatDGUYDsaleUO5Xu553KGn/dLgKO7iuLEbOoxyoAcvXGofMG3rb
	 d4DDUC0YhJ13ReZ6Z/p5wvfP6+c3/uLZ76nGIse5NETTpYhs6mLlVlMD008rTuVEpf
	 h0Ke+u0IsgzxFH0j5J9oP/41Zv/nXYGKRXtPXfByuGe/oVb1TPHfO4wj1QCS/b0qwR
	 xij6Kkf/9u/Tl0I71DyKUPBW4H97FsQMEjOxjuU+Wv+o338vbWnab4hLwbZfNvd2kh
	 03T0L+OxEl8ng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1732894345; bh=Kc1h4J+DLLOsDo7zjYah/KNP7IJRC9IKfhrhGCJecS4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=K2w7m/mW1vXFbhf86StMtS/Wgp1vZc/qlr9sTfVskIF7exO1BjzOvIdhyGR40A6hC
	 nE0/v40p+AUYRIVGnYoV3B5GmVzCBJzr2rpq+gvHaRIMQQCSXKWin8upeLVL2L1+Ss
	 U0kPhEgbFU5k1UbxagIvjLPCGDd6jcjw5Opr4AsX57Yo9CX3IAqmziTfbnY0cKzK2g
	 M2yU4kfmD42bGFw0qyxg9Y10S6y7xn/yZ0tdsBGxG6qyyWBr03JRZAHBA1rfSR6BTn
	 4o6DA9flX40zbcc47198Q2DFYNiD7YqlVF7T2ckCCj3g4EXJMMus8Jm8//tY9gM8S1
	 Ozm0D5y32mt5w==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <martin.petersen@oracle.com>, <bootc@bootc.net>, <bostroesser@gmail.com>,
	<michael.christie@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
	<linux@yadro.com>
Subject: [PATCH 03/10] target: Fix quoted strings splitting
Date: Fri, 29 Nov 2024 18:30:49 +0300
Message-ID: <20241129153056.6985-4-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.3
In-Reply-To: <20241129153056.6985-1-a.kovaleva@yadro.com>
References: <20241129153056.6985-1-a.kovaleva@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-09.corp.yadro.com (172.17.11.59) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

Fix splitted strings and some other obvious style problems related to
quoted strings. This patch was made automatically with this command:

./scripts/checkpatch.pl --test-only=quoted --fix-inplace -f ./drivers/target/**/*.{c,h}

and then carefully checked manually.

Note: The checkpatch script should be run several times due to its
algorithm. It will fix splitting only once even if the string was split
on 3 or more lines.

Note: Some functions were manually changed. In some logs there were
typos, in others the script made mistakes. Functions, where logs were
changed manually:

iscsit_build_sendtargets_response
lio_target_nacl_info_show
core_alua_show_tg_pt_gp_info
item_to_hba
target_pr_res_pr_all_tgt_pts_show
target_pr_res_pr_holder_tg_port_show
target_tg_pt_gp_members_show
core_scsi3_update_aptpl_buf
pscsi_show_configfs_dev_params
rd_show_configfs_dev_params
transport_dump_vpd_proto_id
transport_dump_vpd_ident
MODULE_PARM_DESC global_max_data_area_mb
ft_del_wwn
target_set_nacl_queue_depth

Then all format strings arguments were aligned by parenthesis by
git-clang-format util.

It may not be checked manually.

Reviewed-by: Dmitriy Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
---
 drivers/target/iscsi/cxgbit/cxgbit_cm.c       |   6 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c   |  48 +--
 drivers/target/iscsi/iscsi_target.c           | 312 ++++++------------
 drivers/target/iscsi/iscsi_target_auth.c      |  12 +-
 drivers/target/iscsi/iscsi_target_configfs.c  |  43 +--
 .../target/iscsi/iscsi_target_datain_values.c |   7 +-
 drivers/target/iscsi/iscsi_target_erl0.c      |  95 ++----
 drivers/target/iscsi/iscsi_target_erl1.c      |  96 ++----
 drivers/target/iscsi/iscsi_target_erl2.c      |  38 +--
 drivers/target/iscsi/iscsi_target_login.c     |  54 +--
 drivers/target/iscsi/iscsi_target_nego.c      | 103 ++----
 .../target/iscsi/iscsi_target_nodeattrib.c    |  72 ++--
 .../target/iscsi/iscsi_target_parameters.c    |  97 ++----
 .../target/iscsi/iscsi_target_seq_pdu_list.c  |  40 +--
 drivers/target/iscsi/iscsi_target_tmr.c       |  79 ++---
 drivers/target/iscsi/iscsi_target_tpg.c       |  87 ++---
 drivers/target/iscsi/iscsi_target_util.c      |  57 ++--
 drivers/target/target_core_alua.c             |  77 ++---
 drivers/target/target_core_configfs.c         | 230 +++++--------
 drivers/target/target_core_device.c           |  38 +--
 drivers/target/target_core_fabric_configfs.c  |  16 +-
 drivers/target/target_core_fabric_lib.c       |   6 +-
 drivers/target/target_core_file.c             |  49 +--
 drivers/target/target_core_hba.c              |   8 +-
 drivers/target/target_core_iblock.c           |  15 +-
 drivers/target/target_core_pr.c               | 305 ++++++-----------
 drivers/target/target_core_pscsi.c            |  84 ++---
 drivers/target/target_core_rd.c               |  30 +-
 drivers/target/target_core_sbc.c              |  61 ++--
 drivers/target/target_core_spc.c              |   9 +-
 drivers/target/target_core_tmr.c              |   9 +-
 drivers/target/target_core_tpg.c              |  28 +-
 drivers/target/target_core_transport.c        |  67 ++--
 drivers/target/target_core_ua.c               |  11 +-
 drivers/target/target_core_xcopy.c            |  65 ++--
 drivers/target/tcm_fc/tfc_cmd.c               |  11 +-
 drivers/target/tcm_fc/tfc_io.c                |  11 +-
 37 files changed, 760 insertions(+), 1616 deletions(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_cm.c b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
index 2575549cb579..036e275de088 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_cm.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
@@ -1249,8 +1249,7 @@ cxgbit_pass_accept_req(struct cxgbit_device *cdev, struct sk_buff *skb)
 
 	/* Find output route */
 	if (iptype == 4)  {
-		target_debug("%s parent sock %p tid %u laddr %pI4 raddr %pI4 "
-			     "lport %d rport %d peer_mss %d\n",
+		target_debug("%s parent sock %p tid %u laddr %pI4 raddr %pI4 lport %d rport %d peer_mss %d\n",
 			     __func__, cnp, tid, local_ip, peer_ip, ntohs(local_port),
 			     ntohs(peer_port), peer_mss);
 		dst = cxgb_find_route(&cdev->lldi, cxgbit_get_real_dev,
@@ -1259,8 +1258,7 @@ cxgbit_pass_accept_req(struct cxgbit_device *cdev, struct sk_buff *skb)
 				      local_port, peer_port,
 				      PASS_OPEN_TOS_G(ntohl(req->tos_stid)));
 	} else {
-		target_debug("%s parent sock %p tid %u laddr %pI6 raddr %pI6 "
-			     "lport %d rport %d peer_mss %d\n",
+		target_debug("%s parent sock %p tid %u laddr %pI6 raddr %pI6 lport %d rport %d peer_mss %d\n",
 			     __func__, cnp, tid, local_ip, peer_ip, ntohs(local_port),
 			     ntohs(peer_port), peer_mss);
 		dst = cxgb_find_route6(&cdev->lldi, cxgbit_get_real_dev,
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index c49d3d975c80..95301f3c62a2 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -860,9 +860,7 @@ cxgbit_handle_immediate_data(struct iscsit_cmd *cmd, struct iscsi_scsi_req *hdr,
 	if (pdu_cb->flags & PDUCBF_RX_DCRC_ERR) {
 		target_err("ImmediateData CRC32C DataDigest error\n");
 		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-			target_err("Unable to recover from"
-				   " Immediate Data digest failure while"
-				   " in ERL=0.\n");
+			target_err("Unable to recover from Immediate Data digest failure while in ERL=0.\n");
 			iscsit_reject_cmd(cmd, ISCSI_REASON_DATA_DIGEST_ERROR,
 					  (unsigned char *)hdr);
 			return IMMEDIATE_DATA_CANNOT_RECOVER;
@@ -1034,17 +1032,15 @@ static int cxgbit_handle_iscsi_dataout(struct cxgbit_sock *csk)
 	}
 
 	if (pdu_cb->flags & PDUCBF_RX_DCRC_ERR) {
-		target_err("ITT: 0x%08x, Offset: %u, Length: %u,"
-			   " DataSN: 0x%08x\n",
-			   hdr->itt, hdr->offset, data_len, hdr->datasn);
+		target_err("ITT: 0x%08x, Offset: %u, Length: %u, DataSN: 0x%08x\n", hdr->itt,
+			   hdr->offset, data_len, hdr->datasn);
 
 		dcrc_err = true;
 		goto check_payload;
 	}
 
-	target_debug("DataOut data_len: %u, "
-		     "write_data_done: %u, data_length: %u\n",
-		     data_len, cmd->write_data_done, cmd->se_cmd.data_length);
+	target_debug("DataOut data_len: %u, write_data_done: %u, data_length: %u\n", data_len,
+		     cmd->write_data_done, cmd->se_cmd.data_length);
 
 	if (!(pdu_cb->flags & PDUCBF_RX_DATA_DDPD)) {
 		u32 skip = data_offset % PAGE_SIZE;
@@ -1094,9 +1090,7 @@ static int cxgbit_handle_nop_out(struct cxgbit_sock *csk, struct iscsit_cmd *cmd
 
 	if (pdu_cb->flags & PDUCBF_RX_DCRC_ERR) {
 		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-			target_err("Unable to recover from"
-				   " NOPOUT Ping DataCRC failure while in"
-				   " ERL=0.\n");
+			target_err("Unable to recover from NOPOUT Ping DataCRC failure while in ERL=0.\n");
 			ret = -1;
 			goto out;
 		} else {
@@ -1104,9 +1098,7 @@ static int cxgbit_handle_nop_out(struct cxgbit_sock *csk, struct iscsit_cmd *cmd
 			 * drop this PDU and let the
 			 * initiator plug the CmdSN gap.
 			 */
-			target_info("Dropping NOPOUT"
-				    " Command CmdSN: 0x%08x due to"
-				    " DataCRC error.\n",
+			target_info("Dropping NOPOUT Command CmdSN: 0x%08x due to DataCRC error.\n",
 				    hdr->cmdsn);
 			ret = 0;
 			goto out;
@@ -1119,8 +1111,7 @@ static int cxgbit_handle_nop_out(struct cxgbit_sock *csk, struct iscsit_cmd *cmd
 	if (payload_length && hdr->ttt == cpu_to_be32(0xFFFFFFFF)) {
 		ping_data = kzalloc(payload_length + 1, GFP_KERNEL);
 		if (!ping_data) {
-			target_err("Unable to allocate memory for"
-				   " NOPOUT ping data.\n");
+			target_err("Unable to allocate memory for NOPOUT ping data.\n");
 			ret = -1;
 			goto out;
 		}
@@ -1135,9 +1126,7 @@ static int cxgbit_handle_nop_out(struct cxgbit_sock *csk, struct iscsit_cmd *cmd
 		cmd->buf_ptr = ping_data;
 		cmd->buf_ptr_size = payload_length;
 
-		target_debug("Got %u bytes of NOPOUT ping"
-			     " data.\n",
-			     payload_length);
+		target_debug("Got %u bytes of NOPOUT ping data.\n", payload_length);
 		target_debug("Ping Data: \"%s\"\n", ping_data);
 	}
 
@@ -1164,18 +1153,14 @@ cxgbit_handle_text_cmd(struct cxgbit_sock *csk, struct iscsit_cmd *cmd)
 
 	if (pdu_cb->flags & PDUCBF_RX_DCRC_ERR) {
 		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-			target_err("Unable to recover from"
-				   " Text Data digest failure while in"
-				   " ERL=0.\n");
+			target_err("Unable to recover from Text Data digest failure while in ERL=0.\n");
 			goto reject;
 		} else {
 			/*
 			 * drop this PDU and let the
 			 * initiator plug the CmdSN gap.
 			 */
-			target_info("Dropping Text"
-				    " Command CmdSN: 0x%08x due to"
-				    " DataCRC error.\n",
+			target_info("Dropping Text Command CmdSN: 0x%08x due to DataCRC error.\n",
 				    hdr->cmdsn);
 			return 0;
 		}
@@ -1301,8 +1286,7 @@ static int cxgbit_rx_opcode(struct cxgbit_sock *csk)
 	if (conn->sess->sess_ops->SessionType &&
 	    ((!(opcode & ISCSI_OP_TEXT)) ||
 	     (!(opcode & ISCSI_OP_LOGOUT)))) {
-		target_err("Received illegal iSCSI Opcode: 0x%02x"
-			   " while in Discovery Session, rejecting.\n",
+		target_err("Received illegal iSCSI Opcode: 0x%02x while in Discovery Session, rejecting.\n",
 			   opcode);
 		iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
 				  (unsigned char *)hdr);
@@ -1328,8 +1312,7 @@ static int cxgbit_rx_login_pdu(struct cxgbit_sock *csk)
 	login_req = (struct iscsi_login_req *)login->req;
 	memcpy(login_req, pdu_cb->hdr, sizeof(*login_req));
 
-	target_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x,"
-		     " CmdSN: 0x%08x, ExpStatSN: 0x%08x, CID: %hu, Length: %u\n",
+	target_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x, CmdSN: 0x%08x, ExpStatSN: 0x%08x, CID: %hu, Length: %u\n",
 		     login_req->flags, login_req->itt, login_req->cmdsn, login_req->exp_statsn,
 		     login_req->cid, pdu_cb->dlen);
 	/*
@@ -1393,9 +1376,8 @@ static void cxgbit_lro_skb_dump(struct sk_buff *skb)
 		    lro_cb->pdu_totallen);
 
 	for (i = 0; i < lro_cb->pdu_idx; i++, pdu_cb++)
-		target_info("skb 0x%p, pdu %d, %u, f 0x%x, seq 0x%x, dcrc 0x%x, "
-			    "frags %u.\n",
-			    skb, i, pdu_cb->pdulen, pdu_cb->flags, pdu_cb->seq, pdu_cb->ddigest,
+		target_info("skb 0x%p, pdu %d, %u, f 0x%x, seq 0x%x, dcrc 0x%x, frags %u.\n", skb,
+			    i, pdu_cb->pdulen, pdu_cb->flags, pdu_cb->seq, pdu_cb->ddigest,
 			    pdu_cb->frags);
 	for (i = 0; i < ssi->nr_frags; i++)
 		target_info("skb 0x%p, frag %d, off %u, sz %u.\n", skb, i,
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 5c0482ba3da5..313b829d6c54 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -514,9 +514,8 @@ iscsit_xmit_nondatain_pdu(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 
 		iov[0].iov_len += ISCSI_CRC_LEN;
 		tx_size += ISCSI_CRC_LEN;
-		target_debug("Attaching CRC32C HeaderDigest"
-			     " to opcode 0x%x 0x%08x\n",
-			     hdr->opcode, *header_digest);
+		target_debug("Attaching CRC32C HeaderDigest to opcode 0x%x 0x%08x\n", hdr->opcode,
+			     *header_digest);
 	}
 
 	if (data_buf_len) {
@@ -530,9 +529,7 @@ iscsit_xmit_nondatain_pdu(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 			iov[niov].iov_base = &cmd->pad_bytes;
 			iov[niov++].iov_len = padding;
 			tx_size += padding;
-			target_debug("Attaching %u additional"
-				     " padding bytes.\n",
-				     padding);
+			target_debug("Attaching %u additional padding bytes.\n", padding);
 		}
 
 		if (conn->conn_ops->DataDigest) {
@@ -544,8 +541,7 @@ iscsit_xmit_nondatain_pdu(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 			iov[niov].iov_base = &cmd->data_crc;
 			iov[niov++].iov_len = ISCSI_CRC_LEN;
 			tx_size += ISCSI_CRC_LEN;
-			target_debug("Attached DataDigest for %u"
-				     " bytes opcode 0x%x, CRC 0x%08x\n",
+			target_debug("Attached DataDigest for %u bytes opcode 0x%x, CRC 0x%08x\n",
 				     data_buf_len, hdr->opcode, cmd->data_crc);
 		}
 	}
@@ -710,8 +706,7 @@ static int __init iscsi_target_init_module(void)
 			sizeof(struct iscsi_queue_req),
 			__alignof__(struct iscsi_queue_req), 0, NULL);
 	if (!lio_qr_cache) {
-		target_err("Unable to kmem_cache_create() for"
-			   " lio_qr_cache\n");
+		target_err("Unable to kmem_cache_create() for lio_qr_cache\n");
 		goto cpumask_out;
 	}
 
@@ -719,8 +714,7 @@ static int __init iscsi_target_init_module(void)
 			sizeof(struct iscsi_datain_req),
 			__alignof__(struct iscsi_datain_req), 0, NULL);
 	if (!lio_dr_cache) {
-		target_err("Unable to kmem_cache_create() for"
-			   " lio_dr_cache\n");
+		target_err("Unable to kmem_cache_create() for lio_dr_cache\n");
 		goto qr_out;
 	}
 
@@ -728,8 +722,7 @@ static int __init iscsi_target_init_module(void)
 			sizeof(struct iscsi_ooo_cmdsn),
 			__alignof__(struct iscsi_ooo_cmdsn), 0, NULL);
 	if (!lio_ooo_cache) {
-		target_err("Unable to kmem_cache_create() for"
-			   " lio_ooo_cache\n");
+		target_err("Unable to kmem_cache_create() for lio_ooo_cache\n");
 		goto dr_out;
 	}
 
@@ -737,8 +730,7 @@ static int __init iscsi_target_init_module(void)
 			sizeof(struct iscsi_r2t), __alignof__(struct iscsi_r2t),
 			0, NULL);
 	if (!lio_r2t_cache) {
-		target_err("Unable to kmem_cache_create() for"
-			   " lio_r2t_cache\n");
+		target_err("Unable to kmem_cache_create() for lio_r2t_cache\n");
 		goto ooo_out;
 	}
 
@@ -1015,8 +1007,7 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 
 	if (!(hdr->flags & ISCSI_FLAG_CMD_WRITE) &&
 	    !(hdr->flags & ISCSI_FLAG_CMD_FINAL)) {
-		target_err("ISCSI_FLAG_CMD_WRITE & ISCSI_FLAG_CMD_FINAL"
-			   " not set. Bad iSCSI Initiator.\n");
+		target_err("ISCSI_FLAG_CMD_WRITE & ISCSI_FLAG_CMD_FINAL not set. Bad iSCSI Initiator.\n");
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_BOOKMARK_INVALID, buf);
 	}
@@ -1036,17 +1027,13 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 		hdr->flags &= ~ISCSI_FLAG_CMD_READ;
 		hdr->flags &= ~ISCSI_FLAG_CMD_WRITE;
 
-		target_warn("ISCSI_FLAG_CMD_READ or ISCSI_FLAG_CMD_WRITE"
-			    " set when Expected Data Transfer Length is 0 for"
-			    " CDB: 0x%02x, Fixing up flags\n",
+		target_warn("ISCSI_FLAG_CMD_READ or ISCSI_FLAG_CMD_WRITE set when Expected Data Transfer Length is 0 for CDB: 0x%02x, Fixing up flags\n",
 			    hdr->cdb[0]);
 	}
 
 	if (!(hdr->flags & ISCSI_FLAG_CMD_READ) &&
 	    !(hdr->flags & ISCSI_FLAG_CMD_WRITE) && (hdr->data_length != 0)) {
-		target_err("ISCSI_FLAG_CMD_READ and/or ISCSI_FLAG_CMD_WRITE"
-			   " MUST be set if Expected Data Transfer Length is not 0."
-			   " Bad iSCSI Initiator\n");
+		target_err("ISCSI_FLAG_CMD_READ and/or ISCSI_FLAG_CMD_WRITE MUST be set if Expected Data Transfer Length is not 0. Bad iSCSI Initiator\n");
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_BOOKMARK_INVALID, buf);
 	}
@@ -1059,15 +1046,13 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	}
 
 	if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
-		target_err("Illegally set Immediate Bit in iSCSI Initiator"
-			   " Scsi Command PDU.\n");
+		target_err("Illegally set Immediate Bit in iSCSI Initiator Scsi Command PDU.\n");
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_BOOKMARK_INVALID, buf);
 	}
 
 	if (payload_length && !conn->sess->sess_ops->ImmediateData) {
-		target_err("ImmediateData=No but DataSegmentLength=%u,"
-			   " protocol error.\n",
+		target_err("ImmediateData=No but DataSegmentLength=%u, protocol error.\n",
 			   payload_length);
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_PROTOCOL_ERROR, buf);
@@ -1075,32 +1060,27 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 
 	if ((be32_to_cpu(hdr->data_length) == payload_length) &&
 	    (!(hdr->flags & ISCSI_FLAG_CMD_FINAL))) {
-		target_err("Expected Data Transfer Length and Length of"
-			   " Immediate Data are the same, but ISCSI_FLAG_CMD_FINAL"
-			   " bit is not set protocol error\n");
+		target_err("Expected Data Transfer Length and Length of Immediate Data are the same, but ISCSI_FLAG_CMD_FINAL bit is not set protocol error\n");
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_PROTOCOL_ERROR, buf);
 	}
 
 	if (payload_length > be32_to_cpu(hdr->data_length)) {
-		target_err("DataSegmentLength: %u is greater than"
-			   " EDTL: %u, protocol error.\n",
+		target_err("DataSegmentLength: %u is greater than EDTL: %u, protocol error.\n",
 			   payload_length, hdr->data_length);
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_PROTOCOL_ERROR, buf);
 	}
 
 	if (payload_length > conn->conn_ops->MaxXmitDataSegmentLength) {
-		target_err("DataSegmentLength: %u is greater than"
-			   " MaxXmitDataSegmentLength: %u, protocol error.\n",
+		target_err("DataSegmentLength: %u is greater than MaxXmitDataSegmentLength: %u, protocol error.\n",
 			   payload_length, conn->conn_ops->MaxXmitDataSegmentLength);
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_PROTOCOL_ERROR, buf);
 	}
 
 	if (payload_length > conn->sess->sess_ops->FirstBurstLength) {
-		target_err("DataSegmentLength: %u is greater than"
-			   " FirstBurstLength: %u, protocol error.\n",
+		target_err("DataSegmentLength: %u is greater than FirstBurstLength: %u, protocol error.\n",
 			   payload_length, conn->sess->sess_ops->FirstBurstLength);
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_BOOKMARK_INVALID, buf);
@@ -1146,8 +1126,7 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	else if (iscsi_task_attr == ISCSI_ATTR_ACA)
 		sam_task_attr = TCM_ACA_TAG;
 	else {
-		target_debug("Unknown iSCSI Task Attribute: 0x%02x, using"
-			     " TCM_SIMPLE_TAG\n",
+		target_debug("Unknown iSCSI Task Attribute: 0x%02x, using TCM_SIMPLE_TAG\n",
 			     iscsi_task_attr);
 		sam_task_attr = TCM_SIMPLE_TAG;
 	}
@@ -1194,8 +1173,7 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 			  cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun),
 			  conn->cmd_cnt);
 
-	target_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
-		     " ExpXferLen: %u, Length: %u, CID: %hu\n",
+	target_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x, ExpXferLen: %u, Length: %u, CID: %hu\n",
 		     hdr->itt, hdr->cmdsn, be32_to_cpu(hdr->data_length), payload_length,
 		     conn->cid);
 
@@ -1489,21 +1467,18 @@ __iscsit_check_dataout_hdr(struct iscsit_conn *conn, void *buf,
 	/* iSCSI write */
 	atomic_long_add(payload_length, &conn->sess->rx_data_octets);
 
-	target_debug("Got DataOut ITT: 0x%08x, TTT: 0x%08x,"
-		     " DataSN: 0x%08x, Offset: %u, Length: %u, CID: %hu\n",
+	target_debug("Got DataOut ITT: 0x%08x, TTT: 0x%08x, DataSN: 0x%08x, Offset: %u, Length: %u, CID: %hu\n",
 		     hdr->itt, hdr->ttt, hdr->datasn, ntohl(hdr->offset), payload_length,
 		     conn->cid);
 
 	if (cmd->cmd_flags & ICF_GOT_LAST_DATAOUT) {
-		target_err("Command ITT: 0x%08x received DataOUT after"
-			   " last DataOUT received, dumping payload\n",
+		target_err("Command ITT: 0x%08x received DataOUT after last DataOUT received, dumping payload\n",
 			   cmd->init_task_tag);
 		return iscsit_dump_data_payload(conn, payload_length, 1);
 	}
 
 	if (cmd->data_direction != DMA_TO_DEVICE) {
-		target_err("Command ITT: 0x%08x received DataOUT for a"
-			   " NON-WRITE command.\n",
+		target_err("Command ITT: 0x%08x received DataOUT for a NON-WRITE command.\n",
 			   cmd->init_task_tag);
 		return iscsit_dump_data_payload(conn, payload_length, 1);
 	}
@@ -1520,8 +1495,7 @@ __iscsit_check_dataout_hdr(struct iscsit_conn *conn, void *buf,
 		int dump_unsolicited_data = 0;
 
 		if (conn->sess->sess_ops->InitialR2T) {
-			target_err("Received unexpected unsolicited data"
-				   " while InitialR2T=Yes, protocol error.\n");
+			target_err("Received unexpected unsolicited data while InitialR2T=Yes, protocol error.\n");
 			transport_send_check_condition_and_sense(&cmd->se_cmd,
 					TCM_UNEXPECTED_UNSOLICITED_DATA, 0);
 			return -1;
@@ -1597,8 +1571,7 @@ iscsit_check_dataout_hdr(struct iscsit_conn *conn, void *buf,
 	}
 
 	if (payload_length > conn->conn_ops->MaxXmitDataSegmentLength) {
-		target_err_ratelimited("DataSegmentLength: %u is greater than"
-				       " MaxXmitDataSegmentLength: %u\n",
+		target_err_ratelimited("DataSegmentLength: %u is greater than MaxXmitDataSegmentLength: %u\n",
 				       payload_length, conn->conn_ops->MaxXmitDataSegmentLength);
 		return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR, buf);
 	}
@@ -1668,15 +1641,12 @@ iscsit_get_dataout(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 						    cmd->pad_bytes);
 
 		if (checksum != data_crc) {
-			target_err("ITT: 0x%08x, Offset: %u, Length: %u,"
-				   " DataSN: 0x%08x, CRC32C DataDigest 0x%08x"
-				   " does not match computed 0x%08x\n",
+			target_err("ITT: 0x%08x, Offset: %u, Length: %u, DataSN: 0x%08x, CRC32C DataDigest 0x%08x does not match computed 0x%08x\n",
 				   hdr->itt, hdr->offset, payload_length, hdr->datasn, checksum,
 				   data_crc);
 			data_crc_failed = 1;
 		} else {
-			target_debug("Got CRC32C DataDigest 0x%08x for"
-				     " %u bytes of Data Out\n",
+			target_debug("Got CRC32C DataDigest 0x%08x for %u bytes of Data Out\n",
 				     checksum, payload_length);
 		}
 	}
@@ -1761,8 +1731,7 @@ int iscsit_setup_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	}
 
 	if (hdr->itt == RESERVED_ITT && !(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
-		target_err("NOPOUT ITT is reserved, but Immediate Bit is"
-			   " not set, protocol error.\n");
+		target_err("NOPOUT ITT is reserved, but Immediate Bit is not set, protocol error.\n");
 		if (!cmd)
 			return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
 						 (unsigned char *)hdr);
@@ -1772,9 +1741,7 @@ int iscsit_setup_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	}
 
 	if (payload_length > conn->conn_ops->MaxXmitDataSegmentLength) {
-		target_err("NOPOUT Ping Data DataSegmentLength: %u is"
-			   " greater than MaxXmitDataSegmentLength: %u, protocol"
-			   " error.\n",
+		target_err("NOPOUT Ping Data DataSegmentLength: %u is greater than MaxXmitDataSegmentLength: %u, protocol error.\n",
 			   payload_length, conn->conn_ops->MaxXmitDataSegmentLength);
 		if (!cmd)
 			return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
@@ -1784,8 +1751,7 @@ int iscsit_setup_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 					 (unsigned char *)hdr);
 	}
 
-	target_debug("Got NOPOUT Ping %s ITT: 0x%08x, TTT: 0x%08x,"
-		     " CmdSN: 0x%08x, ExpStatSN: 0x%08x, Length: %u\n",
+	target_debug("Got NOPOUT Ping %s ITT: 0x%08x, TTT: 0x%08x, CmdSN: 0x%08x, ExpStatSN: 0x%08x, Length: %u\n",
 		     hdr->itt == RESERVED_ITT ? "Response" : "Request", hdr->itt, hdr->ttt,
 		     hdr->cmdsn, hdr->exp_statsn, payload_length);
 	/*
@@ -1904,9 +1870,7 @@ static int iscsit_handle_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cm
 
 		padding = ((-payload_length) & 3);
 		if (padding != 0) {
-			target_debug("Receiving %u additional bytes"
-				     " for padding.\n",
-				     padding);
+			target_debug("Receiving %u additional bytes for padding.\n", padding);
 			iov[niov].iov_base	= &cmd->pad_bytes;
 			iov[niov++].iov_len	= padding;
 			rx_size += padding;
@@ -1930,13 +1894,10 @@ static int iscsit_handle_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cm
 						  cmd->pad_bytes, &data_crc);
 
 			if (checksum != data_crc) {
-				target_err("Ping data CRC32C DataDigest"
-					   " 0x%08x does not match computed 0x%08x\n",
+				target_err("Ping data CRC32C DataDigest 0x%08x does not match computed 0x%08x\n",
 					   checksum, data_crc);
 				if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-					target_err("Unable to recover from"
-						   " NOPOUT Ping DataCRC failure while in"
-						   " ERL=0.\n");
+					target_err("Unable to recover from NOPOUT Ping DataCRC failure while in ERL=0.\n");
 					ret = -1;
 					goto out;
 				} else {
@@ -1944,16 +1905,13 @@ static int iscsit_handle_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cm
 					 * Silently drop this PDU and let the
 					 * initiator plug the CmdSN gap.
 					 */
-					target_debug("Dropping NOPOUT"
-						     " Command CmdSN: 0x%08x due to"
-						     " DataCRC error.\n",
+					target_debug("Dropping NOPOUT Command CmdSN: 0x%08x due to DataCRC error.\n",
 						     hdr->cmdsn);
 					ret = 0;
 					goto out;
 				}
 			} else {
-				target_debug("Got CRC32C DataDigest"
-					     " 0x%08x for %u bytes of ping data.\n",
+				target_debug("Got CRC32C DataDigest 0x%08x for %u bytes of ping data.\n",
 					     checksum, payload_length);
 			}
 		}
@@ -1965,9 +1923,7 @@ static int iscsit_handle_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cm
 		cmd->buf_ptr = ping_data;
 		cmd->buf_ptr_size = payload_length;
 
-		target_debug("Got %u bytes of NOPOUT ping"
-			     " data.\n",
-			     payload_length);
+		target_debug("Got %u bytes of NOPOUT ping data.\n", payload_length);
 		target_debug("Ping Data: \"%s\"\n", ping_data);
 	}
 
@@ -2016,9 +1972,7 @@ iscsit_handle_task_mgt_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	hdr->flags &= ~ISCSI_FLAG_CMD_FINAL;
 	function = hdr->flags;
 
-	target_debug("Got Task Management Request ITT: 0x%08x, CmdSN:"
-		     " 0x%08x, Function: 0x%02x, RefTaskTag: 0x%08x, RefCmdSN:"
-		     " 0x%08x, CID: %hu\n",
+	target_debug("Got Task Management Request ITT: 0x%08x, CmdSN: 0x%08x, Function: 0x%02x, RefTaskTag: 0x%08x, RefCmdSN: 0x%08x, CID: %hu\n",
 		     hdr->itt, hdr->cmdsn, function, hdr->rtt, hdr->refcmdsn, conn->cid);
 
 	if ((function != ISCSI_TM_FUNC_ABORT_TASK) &&
@@ -2030,9 +1984,7 @@ iscsit_handle_task_mgt_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 
 	if ((function == ISCSI_TM_FUNC_TASK_REASSIGN) &&
 			!(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
-		target_err("Task Management Request TASK_REASSIGN not"
-			   " issued as immediate command, bad iSCSI Initiator"
-			   "implementation\n");
+		target_err("Task Management Request TASK_REASSIGN not issued as immediate command, bad iSCSI Initiator implementation\n");
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_PROTOCOL_ERROR, buf);
 	}
@@ -2063,9 +2015,7 @@ iscsit_handle_task_mgt_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	if (function != ISCSI_TM_FUNC_TASK_REASSIGN) {
 		tcm_function = iscsit_convert_tmf(function);
 		if (tcm_function == TMR_UNKNOWN) {
-			target_err("Unknown iSCSI TMR Function:"
-				   " 0x%02x\n",
-				   function);
+			target_err("Unknown iSCSI TMR Function: 0x%02x\n", function);
 			return iscsit_add_reject_cmd(cmd,
 				ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
 		}
@@ -2135,9 +2085,7 @@ iscsit_handle_task_mgt_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 					ISCSI_REASON_BOOKMARK_INVALID, buf);
 		break;
 	default:
-		target_err("Unknown TMR function: 0x%02x, protocol"
-			   " error.\n",
-			   function);
+		target_err("Unknown TMR function: 0x%02x, protocol error.\n", function);
 		se_tmr->response = ISCSI_TMF_RSP_NOT_SUPPORTED;
 		goto attach;
 	}
@@ -2193,8 +2141,7 @@ iscsit_setup_text_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	u32 payload_length = ntoh24(hdr->dlength);
 
 	if (payload_length > conn->conn_ops->MaxXmitDataSegmentLength) {
-		target_err("Unable to accept text parameter length: %u"
-			   "greater than MaxXmitDataSegmentLength %u.\n",
+		target_err("Unable to accept text parameter length: %u greater than MaxXmitDataSegmentLength %u.\n",
 			   payload_length, conn->conn_ops->MaxXmitDataSegmentLength);
 		return iscsit_reject_cmd(cmd, ISCSI_REASON_PROTOCOL_ERROR,
 					 (unsigned char *)hdr);
@@ -2207,8 +2154,7 @@ iscsit_setup_text_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 					(unsigned char *)hdr);
 	}
 
-	target_debug("Got Text Request: ITT: 0x%08x, CmdSN: 0x%08x,"
-		     " ExpStatSN: 0x%08x, Length: %u\n",
+	target_debug("Got Text Request: ITT: 0x%08x, CmdSN: 0x%08x, ExpStatSN: 0x%08x, Length: %u\n",
 		     hdr->itt, hdr->cmdsn, hdr->exp_statsn, payload_length);
 
 	cmd->iscsi_opcode	= ISCSI_OP_TEXT;
@@ -2236,15 +2182,13 @@ iscsit_process_text_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	if (!text_in) {
 		cmd->targ_xfer_tag = be32_to_cpu(hdr->ttt);
 		if (cmd->targ_xfer_tag == 0xFFFFFFFF) {
-			target_err("Unable to locate text_in buffer for sendtargets"
-				   " discovery\n");
+			target_err("Unable to locate text_in buffer for sendtargets discovery\n");
 			goto reject;
 		}
 		goto empty_sendtargets;
 	}
 	if (strncmp("SendTargets=", text_in, 12) != 0) {
-		target_err("Received Text Data that is not"
-			   " SendTargets, cannot continue.\n");
+		target_err("Received Text Data that is not SendTargets, cannot continue.\n");
 		goto reject;
 	}
 	/* '=' confirmed in strncmp */
@@ -2317,9 +2261,7 @@ iscsit_handle_text_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 
 		padding = rx_size - payload_length;
 		if (padding)
-			target_debug("Receiving %u additional bytes"
-				     " for padding.\n",
-				     padding);
+			target_debug("Receiving %u additional bytes for padding.\n", padding);
 		if (conn->conn_ops->DataDigest) {
 			iov[niov].iov_base	= &checksum;
 			iov[niov++].iov_len	= ISCSI_CRC_LEN;
@@ -2337,37 +2279,28 @@ iscsit_handle_text_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 						  &data_crc);
 
 			if (checksum != data_crc) {
-				target_err("Text data CRC32C DataDigest"
-					   " 0x%08x does not match computed"
-					   " 0x%08x\n",
+				target_err("Text data CRC32C DataDigest 0x%08x does not match computed 0x%08x\n",
 					   checksum, data_crc);
 				if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-					target_err("Unable to recover from"
-						   " Text Data digest failure while in"
-						   " ERL=0.\n");
+					target_err("Unable to recover from Text Data digest failure while in ERL=0.\n");
 					goto reject;
 				} else {
 					/*
 					 * Silently drop this PDU and let the
 					 * initiator plug the CmdSN gap.
 					 */
-					target_debug("Dropping Text"
-						     " Command CmdSN: 0x%08x due to"
-						     " DataCRC error.\n",
+					target_debug("Dropping Text Command CmdSN: 0x%08x due to DataCRC error.\n",
 						     hdr->cmdsn);
 					kfree(text_in);
 					return 0;
 				}
 			} else {
-				target_debug("Got CRC32C DataDigest"
-					     " 0x%08x for %u bytes of text data.\n",
+				target_debug("Got CRC32C DataDigest 0x%08x for %u bytes of text data.\n",
 					     checksum, payload_length);
 			}
 		}
 		text_in[payload_length - 1] = '\0';
-		target_debug("Successfully read %d bytes of text"
-			     " data.\n",
-			     payload_length);
+		target_debug("Successfully read %d bytes of text data.\n", payload_length);
 	}
 
 	return iscsit_process_text_cmd(conn, cmd, hdr);
@@ -2383,9 +2316,8 @@ int iscsit_logout_closesession(struct iscsit_cmd *cmd, struct iscsit_conn *conn)
 	struct iscsit_conn *conn_p;
 	struct iscsit_session *sess = conn->sess;
 
-	target_debug("Received logout request CLOSESESSION on CID: %hu"
-		     " for SID: %u.\n",
-		     conn->cid, conn->sess->sid);
+	target_debug("Received logout request CLOSESESSION on CID: %hu for SID: %u.\n", conn->cid,
+		     conn->sess->sid);
 
 	atomic_set(&sess->session_logout, 1);
 	atomic_set(&conn->conn_logout_remove, 1);
@@ -2414,8 +2346,7 @@ int iscsit_logout_closeconnection(struct iscsit_cmd *cmd, struct iscsit_conn *co
 	struct iscsit_conn *l_conn;
 	struct iscsit_session *sess = conn->sess;
 
-	target_debug("Received logout request CLOSECONNECTION for CID:"
-		     " %hu on CID: %hu.\n",
+	target_debug("Received logout request CLOSECONNECTION for CID: %hu on CID: %hu.\n",
 		     cmd->logout_cid, conn->cid);
 
 	/*
@@ -2462,21 +2393,18 @@ int iscsit_logout_removeconnforrecovery(struct iscsit_cmd *cmd, struct iscsit_co
 {
 	struct iscsit_session *sess = conn->sess;
 
-	target_debug("Received explicit REMOVECONNFORRECOVERY logout for"
-		     " CID: %hu on CID: %hu.\n",
+	target_debug("Received explicit REMOVECONNFORRECOVERY logout for CID: %hu on CID: %hu.\n",
 		     cmd->logout_cid, conn->cid);
 
 	if (sess->sess_ops->ErrorRecoveryLevel != 2) {
-		target_err("Received Logout Request REMOVECONNFORRECOVERY"
-			   " while ERL!=2.\n");
+		target_err("Received Logout Request REMOVECONNFORRECOVERY while ERL!=2.\n");
 		cmd->logout_response = ISCSI_LOGOUT_RECOVERY_UNSUPPORTED;
 		iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
 		return 0;
 	}
 
 	if (conn->cid == cmd->logout_cid) {
-		target_err("Received Logout Request REMOVECONNFORRECOVERY"
-			   " with CID: %hu on CID: %hu, implementation error.\n",
+		target_err("Received Logout Request REMOVECONNFORRECOVERY with CID: %hu on CID: %hu, implementation error.\n",
 			   cmd->logout_cid, conn->cid);
 		cmd->logout_response = ISCSI_LOGOUT_CLEANUP_FAILED;
 		iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
@@ -2509,13 +2437,11 @@ iscsit_handle_logout_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 		spin_unlock(&tiqn->logout_stats.lock);
 	}
 
-	target_debug("Got Logout Request ITT: 0x%08x CmdSN: 0x%08x"
-		     " ExpStatSN: 0x%08x Reason: 0x%02x CID: %hu on CID: %hu\n",
+	target_debug("Got Logout Request ITT: 0x%08x CmdSN: 0x%08x ExpStatSN: 0x%08x Reason: 0x%02x CID: %hu on CID: %hu\n",
 		     hdr->itt, hdr->cmdsn, hdr->exp_statsn, reason_code, hdr->cid, conn->cid);
 
 	if (conn->conn_state != TARG_CONN_STATE_LOGGED_IN) {
-		target_err("Received logout request on connection that"
-			   " is not in logged in state, ignoring request.\n");
+		target_err("Received logout request on connection that is not in logged in state, ignoring request.\n");
 		iscsit_free_cmd(cmd, false);
 		return 0;
 	}
@@ -2577,14 +2503,11 @@ int iscsit_handle_snack(
 	hdr			= (struct iscsi_snack *) buf;
 	hdr->flags		&= ~ISCSI_FLAG_CMD_FINAL;
 
-	target_debug("Got ISCSI_INIT_SNACK, ITT: 0x%08x, ExpStatSN:"
-		     " 0x%08x, Type: 0x%02x, BegRun: 0x%08x, RunLength: 0x%08x,"
-		     " CID: %hu\n",
+	target_debug("Got ISCSI_INIT_SNACK, ITT: 0x%08x, ExpStatSN: 0x%08x, Type: 0x%02x, BegRun: 0x%08x, RunLength: 0x%08x, CID: %hu\n",
 		     hdr->itt, hdr->exp_statsn, hdr->flags, hdr->begrun, hdr->runlength, conn->cid);
 
 	if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-		target_err("Initiator sent SNACK request while in"
-			   " ErrorRecoveryLevel=0.\n");
+		target_err("Initiator sent SNACK request while in ErrorRecoveryLevel=0.\n");
 		return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
 					 buf);
 	}
@@ -2613,9 +2536,7 @@ int iscsit_handle_snack(
 		return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
 					 buf);
 	default:
-		target_err("Unknown SNACK type 0x%02x, protocol"
-			   " error.\n",
-			   hdr->flags & 0x0f);
+		target_err("Unknown SNACK type 0x%02x, protocol error.\n", hdr->flags & 0x0f);
 		return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
 					 buf);
 	}
@@ -2703,14 +2624,11 @@ static int iscsit_handle_immediate_data(
 						    cmd->pad_bytes);
 
 		if (checksum != data_crc) {
-			target_err("ImmediateData CRC32C DataDigest 0x%08x"
-				   " does not match computed 0x%08x\n",
+			target_err("ImmediateData CRC32C DataDigest 0x%08x does not match computed 0x%08x\n",
 				   checksum, data_crc);
 
 			if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-				target_err("Unable to recover from"
-					   " Immediate Data digest failure while"
-					   " in ERL=0.\n");
+				target_err("Unable to recover from Immediate Data digest failure while in ERL=0.\n");
 				iscsit_reject_cmd(cmd,
 						ISCSI_REASON_DATA_DIGEST_ERROR,
 						(unsigned char *)hdr);
@@ -2722,8 +2640,7 @@ static int iscsit_handle_immediate_data(
 				return IMMEDIATE_DATA_ERL1_CRC_FAILURE;
 			}
 		} else {
-			target_debug("Got CRC32C DataDigest 0x%08x for"
-				     " %u bytes of Immediate Data\n",
+			target_debug("Got CRC32C DataDigest 0x%08x for %u bytes of Immediate Data\n",
 				     checksum, length);
 		}
 	}
@@ -2806,8 +2723,7 @@ static int iscsit_send_conn_drop_async_message(
 	hdr->param2		= cpu_to_be16(conn->sess->sess_ops->DefaultTime2Wait);
 	hdr->param3		= cpu_to_be16(conn->sess->sess_ops->DefaultTime2Retain);
 
-	target_debug("Sending Connection Dropped Async Message StatSN:"
-		     " 0x%08x, for CID: %hu on CID: %hu\n",
+	target_debug("Sending Connection Dropped Async Message StatSN: 0x%08x, for CID: %hu on CID: %hu\n",
 		     cmd->stat_sn, cmd->logout_cid, conn->cid);
 
 	return conn->conn_transport->iscsit_xmit_pdu(conn, cmd, NULL, NULL, 0);
@@ -2862,8 +2778,7 @@ iscsit_build_datain_pdu(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 	hdr->datasn		= cpu_to_be32(datain->data_sn);
 	hdr->offset		= cpu_to_be32(datain->offset);
 
-	target_debug("Built DataIN ITT: 0x%08x, StatSN: 0x%08x,"
-		     " DataSN: 0x%08x, Offset: %u, Length: %u, CID: %hu\n",
+	target_debug("Built DataIN ITT: 0x%08x, StatSN: 0x%08x, DataSN: 0x%08x, Offset: %u, Length: %u, CID: %hu\n",
 		     cmd->init_task_tag, ntohl(hdr->statsn), ntohl(hdr->datasn), ntohl(hdr->offset),
 		     datain->length, conn->cid);
 }
@@ -2887,8 +2802,7 @@ static int iscsit_send_datain(struct iscsit_cmd *cmd, struct iscsit_conn *conn)
 	 * Be paranoid and double check the logic for now.
 	 */
 	if ((datain.offset + datain.length) > cmd->se_cmd.data_length) {
-		target_err("Command ITT: 0x%08x, datain.offset: %u and"
-			   " datain.length: %u exceeds cmd->data_length: %u\n",
+		target_err("Command ITT: 0x%08x, datain.offset: %u and datain.length: %u exceeds cmd->data_length: %u\n",
 			   cmd->init_task_tag, datain.offset, datain.length,
 			   cmd->se_cmd.data_length);
 		return -1;
@@ -2942,8 +2856,7 @@ iscsit_build_logout_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 	 */
 	switch (cmd->logout_reason) {
 	case ISCSI_LOGOUT_REASON_CLOSE_SESSION:
-		target_debug("iSCSI session logout successful, setting"
-			     " logout response to ISCSI_LOGOUT_SUCCESS.\n");
+		target_debug("iSCSI session logout successful, setting logout response to ISCSI_LOGOUT_SUCCESS.\n");
 		cmd->logout_response = ISCSI_LOGOUT_SUCCESS;
 		break;
 	case ISCSI_LOGOUT_REASON_CLOSE_CONNECTION:
@@ -2961,9 +2874,8 @@ iscsit_build_logout_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 		 * is stopped in iscsit_logout_post_handler_diffcid().
 		 */
 
-		target_debug("iSCSI CID: %hu logout on CID: %hu"
-			     " successful.\n",
-			     cmd->logout_cid, conn->cid);
+		target_debug("iSCSI CID: %hu logout on CID: %hu successful.\n", cmd->logout_cid,
+			     conn->cid);
 		cmd->logout_response = ISCSI_LOGOUT_SUCCESS;
 		break;
 	case ISCSI_LOGOUT_REASON_RECOVERY:
@@ -2984,8 +2896,7 @@ iscsit_build_logout_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 		cr = iscsit_get_inactive_connection_recovery_entry(
 				conn->sess, cmd->logout_cid);
 		if (!cr) {
-			target_err("Unable to locate CID: %hu for"
-				   " REMOVECONNFORRECOVERY Logout Request.\n",
+			target_err("Unable to locate CID: %hu for REMOVECONNFORRECOVERY Logout Request.\n",
 				   cmd->logout_cid);
 			cmd->logout_response = ISCSI_LOGOUT_CID_NOT_FOUND;
 			break;
@@ -2993,8 +2904,7 @@ iscsit_build_logout_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 
 		iscsit_discard_cr_cmds_by_expstatsn(cr, cmd->exp_stat_sn);
 
-		target_debug("iSCSI REMOVECONNFORRECOVERY logout"
-			     " for recovery for CID: %hu on CID: %hu successful.\n",
+		target_debug("iSCSI REMOVECONNFORRECOVERY logout for recovery for CID: %hu on CID: %hu successful.\n",
 			     cmd->logout_cid, conn->cid);
 		cmd->logout_response = ISCSI_LOGOUT_SUCCESS;
 		break;
@@ -3014,8 +2924,7 @@ iscsit_build_logout_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
 	hdr->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
-	target_debug("Built Logout Response ITT: 0x%08x StatSN:"
-		     " 0x%08x Response: 0x%02x CID: %hu on CID: %hu\n",
+	target_debug("Built Logout Response ITT: 0x%08x StatSN: 0x%08x Response: 0x%02x CID: %hu on CID: %hu\n",
 		     cmd->init_task_tag, cmd->stat_sn, hdr->response, cmd->logout_cid, conn->cid);
 
 	return 0;
@@ -3056,8 +2965,7 @@ iscsit_build_nopin_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
 	hdr->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
-	target_debug("Built NOPIN %s Response ITT: 0x%08x, TTT: 0x%08x,"
-		     " StatSN: 0x%08x, Length %u\n",
+	target_debug("Built NOPIN %s Response ITT: 0x%08x, TTT: 0x%08x, StatSN: 0x%08x, Length %u\n",
 		     (nopout_response) ? "Solicited" : "Unsolicited", cmd->init_task_tag,
 		     cmd->targ_xfer_tag, cmd->stat_sn, cmd->buf_ptr_size);
 }
@@ -3076,9 +2984,8 @@ static int iscsit_send_unsolicited_nopin(
 
 	iscsit_build_nopin_rsp(cmd, conn, hdr, false);
 
-	target_debug("Sending Unsolicited NOPIN TTT: 0x%08x StatSN:"
-		     " 0x%08x CID: %hu\n",
-		     hdr->ttt, cmd->stat_sn, conn->cid);
+	target_debug("Sending Unsolicited NOPIN TTT: 0x%08x StatSN: 0x%08x CID: %hu\n", hdr->ttt,
+		     cmd->stat_sn, conn->cid);
 
 	ret = conn->conn_transport->iscsit_xmit_pdu(conn, cmd, NULL, NULL, 0);
 	if (ret < 0)
@@ -3141,8 +3048,7 @@ static int iscsit_send_r2t(
 	hdr->data_offset	= cpu_to_be32(r2t->offset);
 	hdr->data_length	= cpu_to_be32(r2t->xfer_len);
 
-	target_debug("Built %sR2T, ITT: 0x%08x, TTT: 0x%08x, StatSN:"
-		     " 0x%08x, R2TSN: 0x%08x, Offset: %u, DDTL: %u, CID: %hu\n",
+	target_debug("Built %sR2T, ITT: 0x%08x, TTT: 0x%08x, StatSN: 0x%08x, R2TSN: 0x%08x, Offset: %u, DDTL: %u, CID: %hu\n",
 		     (!r2t->recovery_r2t) ? "" : "Recovery ", cmd->init_task_tag,
 		     r2t->targ_xfer_tag, ntohl(hdr->statsn), r2t->r2t_sn, r2t->offset,
 		     r2t->xfer_len, conn->cid);
@@ -3278,8 +3184,7 @@ void iscsit_build_rsp_pdu(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
 	hdr->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
-	target_debug("Built SCSI Response, ITT: 0x%08x, StatSN: 0x%08x,"
-		     " Response: 0x%02x, SAM Status: 0x%02x, CID: %hu\n",
+	target_debug("Built SCSI Response, ITT: 0x%08x, StatSN: 0x%08x, Response: 0x%02x, SAM Status: 0x%02x, CID: %hu\n",
 		     cmd->init_task_tag, cmd->stat_sn, cmd->se_cmd.scsi_status,
 		     cmd->se_cmd.scsi_status, conn->cid);
 }
@@ -3311,13 +3216,10 @@ static int iscsit_send_response(struct iscsit_cmd *cmd, struct iscsit_conn *conn
 		if (padding) {
 			memset(cmd->sense_buffer +
 				cmd->se_cmd.scsi_sense_length, 0, padding);
-			target_debug("Adding %u bytes of padding to"
-				     " SENSE.\n",
-				     padding);
+			target_debug("Adding %u bytes of padding to SENSE.\n", padding);
 		}
 
-		target_debug("Attaching SENSE DATA: %u bytes to iSCSI"
-			     " Response PDU\n",
+		target_debug("Attaching SENSE DATA: %u bytes to iSCSI Response PDU\n",
 			     cmd->se_cmd.scsi_sense_length);
 	}
 
@@ -3359,8 +3261,7 @@ iscsit_build_task_mgt_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
 	hdr->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
-	target_debug("Built Task Management Response ITT: 0x%08x,"
-		     " StatSN: 0x%08x, Response: 0x%02x, CID: %hu\n",
+	target_debug("Built Task Management Response ITT: 0x%08x, StatSN: 0x%08x, Response: 0x%02x, CID: %hu\n",
 		     cmd->init_task_tag, cmd->stat_sn, hdr->response, conn->cid);
 }
 EXPORT_SYMBOL(iscsit_build_task_mgt_rsp);
@@ -3407,9 +3308,7 @@ iscsit_build_sendtargets_response(struct iscsit_cmd *cmd,
 	if (cmd->cmd_flags & ICF_SENDTARGETS_SINGLE) {
 		text_ptr = strchr(text_in, '=');
 		if (!text_ptr) {
-			target_err("Unable to locate '=' string in text_in:"
-				   " %s\n",
-				   text_in);
+			target_err("Unable to locate '=' string in text_in: %s\n", text_in);
 			kfree(payload);
 			return -EINVAL;
 		}
@@ -3568,8 +3467,7 @@ iscsit_build_text_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 	hdr->exp_cmdsn = cpu_to_be32(conn->sess->exp_cmd_sn);
 	hdr->max_cmdsn = cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
-	target_debug("Built Text Response: ITT: 0x%08x, TTT: 0x%08x, StatSN: 0x%08x,"
-		     " Length: %u, CID: %hu F: %d C: %d\n",
+	target_debug("Built Text Response: ITT: 0x%08x, TTT: 0x%08x, StatSN: 0x%08x, Length: %u, CID: %hu F: %d C: %d\n",
 		     cmd->init_task_tag, cmd->targ_xfer_tag, cmd->stat_sn, text_length, conn->cid,
 		     !!(hdr->flags & ISCSI_FLAG_CMD_FINAL),
 		     !!(hdr->flags & ISCSI_FLAG_TEXT_CONTINUE));
@@ -3620,8 +3518,7 @@ static int iscsit_send_reject(
 
 	iscsit_build_reject(cmd, conn, hdr);
 
-	target_debug("Built Reject PDU StatSN: 0x%08x, Reason: 0x%02x,"
-		     " CID: %hu\n",
+	target_debug("Built Reject PDU StatSN: 0x%08x, Reason: 0x%02x, CID: %hu\n",
 		     ntohl(hdr->statsn), hdr->reason, conn->cid);
 
 	return conn->conn_transport->iscsit_xmit_pdu(conn, cmd, NULL,
@@ -3758,8 +3655,7 @@ iscsit_immediate_queue(struct iscsit_conn *conn, struct iscsit_cmd *cmd, int sta
 			goto err;
 		break;
 	default:
-		target_err("Unknown Opcode: 0x%02x ITT:"
-			   " 0x%08x, i_state: %d on CID: %hu\n",
+		target_err("Unknown Opcode: 0x%02x ITT: 0x%08x, i_state: %d on CID: %hu\n",
 			   cmd->iscsi_opcode, cmd->init_task_tag, state, conn->cid);
 		goto err;
 	}
@@ -3858,8 +3754,7 @@ iscsit_response_queue(struct iscsit_conn *conn, struct iscsit_cmd *cmd, int stat
 		ret = iscsit_send_text_rsp(cmd, conn);
 		break;
 	default:
-		target_err("Unknown Opcode: 0x%02x ITT:"
-			   " 0x%08x, i_state: %d on CID: %hu\n",
+		target_err("Unknown Opcode: 0x%02x ITT: 0x%08x, i_state: %d on CID: %hu\n",
 			   cmd->iscsi_opcode, cmd->init_task_tag, state, conn->cid);
 		goto err;
 	}
@@ -3883,8 +3778,7 @@ iscsit_response_queue(struct iscsit_conn *conn, struct iscsit_cmd *cmd, int stat
 		spin_unlock_bh(&cmd->istate_lock);
 		break;
 	default:
-		target_err("Unknown Opcode: 0x%02x ITT:"
-			   " 0x%08x, i_state: %d on CID: %hu\n",
+		target_err("Unknown Opcode: 0x%02x ITT: 0x%08x, i_state: %d on CID: %hu\n",
 			   cmd->iscsi_opcode, cmd->init_task_tag, cmd->i_state, conn->cid);
 		goto err;
 	}
@@ -4040,12 +3934,10 @@ static int iscsi_target_rx_opcode(struct iscsit_conn *conn, unsigned char *buf)
 	default:
 		target_err("Got unknown iSCSI OpCode: 0x%02x\n", hdr->opcode);
 		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-			target_err("Cannot recover from unknown"
-				   " opcode while ERL=0, closing iSCSI connection.\n");
+			target_err("Cannot recover from unknown opcode while ERL=0, closing iSCSI connection.\n");
 			return -1;
 		}
-		target_err("Unable to recover from unknown opcode while OFMarker=No,"
-			   " closing iSCSI connection.\n");
+		target_err("Unable to recover from unknown opcode while OFMarker=No, closing iSCSI connection.\n");
 		ret = -1;
 		break;
 	}
@@ -4130,8 +4022,7 @@ static void iscsit_get_rx_pdu(struct iscsit_conn *conn)
 						  &checksum);
 
 			if (digest != checksum) {
-				target_err("HeaderDigest CRC32C failed,"
-					   " received 0x%08x, computed 0x%08x\n",
+				target_err("HeaderDigest CRC32C failed, received 0x%08x, computed 0x%08x\n",
 					   digest, checksum);
 				/*
 				 * Set the PDU to 0xff so it will intentionally
@@ -4140,9 +4031,7 @@ static void iscsit_get_rx_pdu(struct iscsit_conn *conn)
 				memset(buffer, 0xff, ISCSI_HDR_LEN);
 				atomic_long_inc(&conn->sess->conn_digest_errors);
 			} else {
-				target_debug("Got HeaderDigest CRC32C"
-					     " 0x%08x\n",
-					     checksum);
+				target_debug("Got HeaderDigest CRC32C 0x%08x\n", checksum);
 			}
 		}
 
@@ -4154,8 +4043,7 @@ static void iscsit_get_rx_pdu(struct iscsit_conn *conn)
 		if (conn->sess->sess_ops->SessionType &&
 		   ((!(opcode & ISCSI_OP_TEXT)) ||
 		    (!(opcode & ISCSI_OP_LOGOUT)))) {
-			target_err("Received illegal iSCSI Opcode: 0x%02x"
-				   " while in Discovery Session, rejecting.\n",
+			target_err("Received illegal iSCSI Opcode: 0x%02x while in Discovery Session, rejecting.\n",
 				   opcode);
 			iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
 					  buffer);
@@ -4292,9 +4180,7 @@ int iscsit_close_connection(
 	int conn_logout = (conn->conn_state == TARG_CONN_STATE_IN_LOGOUT);
 	struct iscsit_session	*sess = conn->sess;
 
-	target_debug("Closing iSCSI connection CID %hu on SID:"
-		     " %u\n",
-		     conn->cid, sess->sid);
+	target_debug("Closing iSCSI connection CID %hu on SID: %u\n", conn->cid, sess->sid);
 	/*
 	 * Always up conn_logout_comp for the traditional TCP and HW_OFFLOAD
 	 * case just in case the RX Thread in iscsi_target_rx_opcode() is
@@ -4439,8 +4325,7 @@ int iscsit_close_connection(
 
 	spin_lock_bh(&sess->conn_lock);
 	atomic_dec(&sess->nconn);
-	target_debug("Decremented iSCSI connection count to %d from node:"
-		     " %s\n",
+	target_debug("Decremented iSCSI connection count to %d from node: %s\n",
 		     atomic_read(&sess->nconn), sess->sess_ops->InitiatorName);
 	/*
 	 * Make sure that if one connection fails in an non ERL=2 iSCSI
@@ -4534,8 +4419,7 @@ int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
 
 	if (atomic_read(&sess->nconn)) {
-		target_err("%d connection(s) still exist for iSCSI session"
-			   " to %s\n",
+		target_err("%d connection(s) still exist for iSCSI session to %s\n",
 			   atomic_read(&sess->nconn), sess->sess_ops->InitiatorName);
 		BUG();
 	}
@@ -4582,8 +4466,7 @@ int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
 	if (tpg->tpg_tiqn)
 		tpg->tpg_tiqn->tiqn_nsessions--;
 
-	target_debug("Decremented number of active iSCSI Sessions on"
-		     " iSCSI TPG: %hu to %u\n",
+	target_debug("Decremented number of active iSCSI Sessions on iSCSI TPG: %hu to %u\n",
 		     tpg->tpgt, tpg->nsessions);
 
 	ida_free(&sess_ida, sess->session_index);
@@ -4845,9 +4728,8 @@ int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *tpg, int force)
 		session_count++;
 	}
 
-	target_debug("Released %d iSCSI Session(s) from Target Portal"
-		     " Group: %hu\n",
-		     session_count, tpg->tpgt);
+	target_debug("Released %d iSCSI Session(s) from Target Portal Group: %hu\n", session_count,
+		     tpg->tpgt);
 	return 0;
 }
 
diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index 694b2ec612cd..8308a1947605 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -146,8 +146,7 @@ static struct iscsi_chap *chap_server_open(
 
 	if (!(auth->naf_flags & NAF_USERID_SET) ||
 	    !(auth->naf_flags & NAF_PASSWORD_SET)) {
-		target_err("CHAP user or password not set for"
-			   " Initiator ACL\n");
+		target_err("CHAP user or password not set for Initiator ACL\n");
 		return NULL;
 	}
 
@@ -401,8 +400,7 @@ static int chap_server_compute_hash(
 		target_debug("[server] %s Digests do not match!\n\n", chap->digest_name);
 		goto out;
 	} else
-		target_debug("[server] %s Digests match, CHAP connection"
-			     " successful.\n\n",
+		target_debug("[server] %s Digests match, CHAP connection successful.\n\n",
 			     chap->digest_name);
 	/*
 	 * One way authentication has succeeded, return now if mutual
@@ -501,8 +499,7 @@ static int chap_server_compute_hash(
 	if (initiatorchg_len == chap->challenge_len &&
 				!memcmp(initiatorchg_binhex, chap->challenge,
 				initiatorchg_len)) {
-		target_err("initiator CHAP_C matches target CHAP_C, failing"
-			   " login attempt\n");
+		target_err("initiator CHAP_C matches target CHAP_C, failing login attempt\n");
 		goto out;
 	}
 	/*
@@ -525,8 +522,7 @@ static int chap_server_compute_hash(
 	ret = crypto_shash_update(desc, auth->password_mutual,
 				  strlen(auth->password_mutual));
 	if (ret < 0) {
-		target_err("crypto_shash_update() failed for"
-			   " password_mutual\n");
+		target_err("crypto_shash_update() failed for password_mutual\n");
 		goto out;
 	}
 	/*
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 8f2578bf8621..bf820981b0da 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -72,8 +72,7 @@ static ssize_t lio_target_np_driver_store(struct config_item *item,
 	}
 	np = tpg_np->tpg_np;
 	if (!np) {
-		target_err("Unable to locate struct iscsi_np from"
-			   " struct iscsi_tpg_np\n");
+		target_err("Unable to locate struct iscsi_np from struct iscsi_tpg_np\n");
 		return -EINVAL;
 	}
 
@@ -173,8 +172,7 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 	if (str) {
 		str2 = strstr(str, "]");
 		if (!str2) {
-			target_err("Unable to locate trailing \"]\""
-				   " in IPv6 iSCSI network portal address\n");
+			target_err("Unable to locate trailing \"]\" in IPv6 iSCSI network portal address\n");
 			return ERR_PTR(-EINVAL);
 		}
 
@@ -184,8 +182,7 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 
 		port_str = strstr(str2, ":");
 		if (!port_str) {
-			target_err("Unable to locate \":port\""
-				   " in IPv6 iSCSI network portal address\n");
+			target_err("Unable to locate \":port\" in IPv6 iSCSI network portal address\n");
 			return ERR_PTR(-EINVAL);
 		}
 		*port_str = '\0'; /* Terminate string for IP */
@@ -194,8 +191,7 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 		ip_str = &buf[0];
 		port_str = strstr(ip_str, ":");
 		if (!port_str) {
-			target_err("Unable to locate \":port\""
-				   " in IPv4 iSCSI network portal address\n");
+			target_err("Unable to locate \":port\" in IPv4 iSCSI network portal address\n");
 			return ERR_PTR(-EINVAL);
 		}
 		*port_str = '\0'; /* Terminate string for IP */
@@ -214,8 +210,7 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 	if (ret < 0)
 		return ERR_PTR(-EINVAL);
 
-	target_debug("LIO_Target_ConfigFS: REGISTER -> %s TPGT: %hu"
-		     " PORTAL: %s\n",
+	target_debug("LIO_Target_ConfigFS: REGISTER -> %s TPGT: %hu PORTAL: %s\n",
 		     config_item_name(&se_tpg->se_tpg_wwn->wwn_group.cg_item), tpg->tpgt, name);
 	/*
 	 * Assume ISCSI_TCP by default.  Other network portals for other
@@ -257,8 +252,7 @@ static void lio_target_call_delnpfromtpg(
 		return;
 
 	se_tpg = &tpg->tpg_se_tpg;
-	target_debug("LIO_Target_ConfigFS: DEREGISTER -> %s TPGT: %hu"
-		     " PORTAL: %pISpc\n",
+	target_debug("LIO_Target_ConfigFS: DEREGISTER -> %s TPGT: %hu PORTAL: %pISpc\n",
 		     config_item_name(&se_tpg->se_tpg_wwn->wwn_group.cg_item), tpg->tpgt,
 		     &tpg_np->tpg_np->np_sockaddr);
 
@@ -657,8 +651,7 @@ static ssize_t lio_target_nacl_cmdsn_depth_store(struct config_item *item,
 	if (ret)
 		return ret;
 	if (cmdsn_depth > TA_DEFAULT_CMDSN_DEPTH_MAX) {
-		target_err("Passed cmdsn_depth: %u exceeds"
-			   " TA_DEFAULT_CMDSN_DEPTH_MAX: %u\n",
+		target_err("Passed cmdsn_depth: %u exceeds TA_DEFAULT_CMDSN_DEPTH_MAX: %u\n",
 			   cmdsn_depth, TA_DEFAULT_CMDSN_DEPTH_MAX);
 		return -EINVAL;
 	}
@@ -683,8 +676,7 @@ static ssize_t lio_target_nacl_cmdsn_depth_store(struct config_item *item,
 
 	ret = core_tpg_set_initiator_node_queue_depth(se_nacl, cmdsn_depth);
 
-	target_debug("LIO_Target_ConfigFS: %s/%s Set CmdSN Window: %u for"
-		     "InitiatorName: %s\n",
+	target_debug("LIO_Target_ConfigFS: %s/%s Set CmdSN Window: %u for InitiatorName: %s\n",
 		     config_item_name(wwn_ci), config_item_name(tpg_ci), cmdsn_depth,
 		     config_item_name(acl_ci));
 
@@ -1052,8 +1044,7 @@ static struct se_portal_group *lio_target_tiqn_addtpg(struct se_wwn *wwn,
 	 */
 	tpgt_str = strstr(name, "tpgt_");
 	if (!tpgt_str) {
-		target_err("Unable to locate \"tpgt_#\" directory"
-			   " group\n");
+		target_err("Unable to locate \"tpgt_#\" directory group\n");
 		return NULL;
 	}
 	tpgt_str += 5; /* Skip ahead of "tpgt_" */
@@ -1192,9 +1183,7 @@ static struct se_wwn *lio_target_call_coreaddtiqn(
 		return ERR_CAST(tiqn);
 
 	target_debug("LIO_Target_ConfigFS: REGISTER -> %s\n", tiqn->tiqn);
-	target_debug("LIO_Target_ConfigFS: REGISTER -> Allocated Node:"
-		     " %s\n",
-		     name);
+	target_debug("LIO_Target_ConfigFS: REGISTER -> Allocated Node: %s\n", name);
 	return &tiqn->tiqn_wwn;
 }
 
@@ -1294,9 +1283,7 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
 	if (err)
 		return -EINVAL;
 	if ((op != 1) && (op != 0)) {
-		target_err("Illegal value for enforce_discovery_auth:"
-			   " %u\n",
-			   op);
+		target_err("Illegal value for enforce_discovery_auth: %u\n", op);
 		return -EINVAL;
 	}
 
@@ -1319,9 +1306,7 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
 
 		discovery_tpg->tpg_attrib.authentication = 1;
 		iscsit_global->discovery_acl.node_auth.enforce_discovery_auth = 1;
-		target_debug("LIO-CORE[0] Successfully enabled"
-			     " authentication enforcement for iSCSI"
-			     " Discovery TPG\n");
+		target_debug("LIO-CORE[0] Successfully enabled authentication enforcement for iSCSI Discovery TPG\n");
 	} else {
 		/*
 		 * Reset the AuthMethod key to CHAP,None
@@ -1331,9 +1316,7 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
 
 		discovery_tpg->tpg_attrib.authentication = 0;
 		iscsit_global->discovery_acl.node_auth.enforce_discovery_auth = 0;
-		target_debug("LIO-CORE[0] Successfully disabled"
-			     " authentication enforcement for iSCSI"
-			     " Discovery TPG\n");
+		target_debug("LIO-CORE[0] Successfully disabled authentication enforcement for iSCSI Discovery TPG\n");
 	}
 
 	return count;
diff --git a/drivers/target/iscsi/iscsi_target_datain_values.c b/drivers/target/iscsi/iscsi_target_datain_values.c
index 84ba97e935e1..57e887945de4 100644
--- a/drivers/target/iscsi/iscsi_target_datain_values.c
+++ b/drivers/target/iscsi/iscsi_target_datain_values.c
@@ -23,8 +23,7 @@ struct iscsi_datain_req *iscsit_allocate_datain_req(void)
 
 	dr = kmem_cache_zalloc(lio_dr_cache, GFP_ATOMIC);
 	if (!dr) {
-		target_err("Unable to allocate memory for"
-			   " struct iscsi_datain_req\n");
+		target_err("Unable to allocate memory for struct iscsi_datain_req\n");
 		return NULL;
 	}
 	INIT_LIST_HEAD(&dr->cmd_datain_node);
@@ -63,9 +62,7 @@ void iscsit_free_all_datain_reqs(struct iscsit_cmd *cmd)
 struct iscsi_datain_req *iscsit_get_datain_req(struct iscsit_cmd *cmd)
 {
 	if (list_empty(&cmd->datain_list)) {
-		target_err("cmd->datain_list is empty for ITT:"
-			   " 0x%08x\n",
-			   cmd->init_task_tag);
+		target_err("cmd->datain_list is empty for ITT: 0x%08x\n", cmd->init_task_tag);
 		return NULL;
 	}
 
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 800fe7b6322d..0607cc3b6f07 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -123,9 +123,8 @@ static int iscsit_dataout_within_command_recovery_check(
 	return DATAOUT_NORMAL;
 
 dump:
-	target_err("Dumping DataOUT PDU Offset: %u Length: %d DataSN:"
-		   " 0x%08x\n",
-		   hdr->offset, payload_length, hdr->datasn);
+	target_err("Dumping DataOUT PDU Offset: %u Length: %d DataSN: 0x%08x\n", hdr->offset,
+		   payload_length, hdr->datasn);
 	return iscsit_dump_data_payload(conn, payload_length, 1);
 }
 
@@ -141,9 +140,7 @@ static int iscsit_dataout_check_unsolicited_sequence(
 
 	if ((be32_to_cpu(hdr->offset) < cmd->seq_start_offset) ||
 	   ((be32_to_cpu(hdr->offset) + payload_length) > cmd->seq_end_offset)) {
-		target_err("Command ITT: 0x%08x with Offset: %u,"
-			   " Length: %u outside of Unsolicited Sequence %u:%u while"
-			   " DataSequenceInOrder=Yes.\n",
+		target_err("Command ITT: 0x%08x with Offset: %u, Length: %u outside of Unsolicited Sequence %u:%u while DataSequenceInOrder=Yes.\n",
 			   cmd->init_task_tag, be32_to_cpu(hdr->offset), payload_length,
 			   cmd->seq_start_offset, cmd->seq_end_offset);
 		return DATAOUT_CANNOT_RECOVER;
@@ -152,8 +149,7 @@ static int iscsit_dataout_check_unsolicited_sequence(
 	first_burst_len = (cmd->first_burst_len + payload_length);
 
 	if (first_burst_len > conn->sess->sess_ops->FirstBurstLength) {
-		target_err("Total %u bytes exceeds FirstBurstLength: %u"
-			   " for this Unsolicited DataOut Burst.\n",
+		target_err("Total %u bytes exceeds FirstBurstLength: %u for this Unsolicited DataOut Burst.\n",
 			   first_burst_len, conn->sess->sess_ops->FirstBurstLength);
 		transport_send_check_condition_and_sense(&cmd->se_cmd,
 				TCM_INCORRECT_AMOUNT_OF_DATA, 0);
@@ -175,9 +171,7 @@ static int iscsit_dataout_check_unsolicited_sequence(
 
 		if ((first_burst_len != cmd->se_cmd.data_length) &&
 		    (first_burst_len != conn->sess->sess_ops->FirstBurstLength)) {
-			target_err("Unsolicited non-immediate data"
-				   " received %u does not equal FirstBurstLength: %u, and"
-				   " does not equal ExpXferLen %u.\n",
+			target_err("Unsolicited non-immediate data received %u does not equal FirstBurstLength: %u, and does not equal ExpXferLen %u.\n",
 				   first_burst_len, conn->sess->sess_ops->FirstBurstLength,
 				   cmd->se_cmd.data_length);
 			transport_send_check_condition_and_sense(&cmd->se_cmd,
@@ -186,16 +180,12 @@ static int iscsit_dataout_check_unsolicited_sequence(
 		}
 	} else {
 		if (first_burst_len == conn->sess->sess_ops->FirstBurstLength) {
-			target_err("Command ITT: 0x%08x reached"
-				   " FirstBurstLength: %u, but ISCSI_FLAG_CMD_FINAL is not set. protocol"
-				   " error.\n",
+			target_err("Command ITT: 0x%08x reached FirstBurstLength: %u, but ISCSI_FLAG_CMD_FINAL is not set. protocol error.\n",
 				   cmd->init_task_tag, conn->sess->sess_ops->FirstBurstLength);
 			return DATAOUT_CANNOT_RECOVER;
 		}
 		if (first_burst_len == cmd->se_cmd.data_length) {
-			target_err("Command ITT: 0x%08x reached"
-				   " ExpXferLen: %u, but ISCSI_FLAG_CMD_FINAL is not set. protocol"
-				   " error.\n",
+			target_err("Command ITT: 0x%08x reached ExpXferLen: %u, but ISCSI_FLAG_CMD_FINAL is not set. protocol error.\n",
 				   cmd->init_task_tag, cmd->se_cmd.data_length);
 			return DATAOUT_CANNOT_RECOVER;
 		}
@@ -230,9 +220,7 @@ static int iscsit_dataout_check_sequence(
 		 */
 		if ((be32_to_cpu(hdr->offset) < cmd->seq_start_offset) ||
 		   ((be32_to_cpu(hdr->offset) + payload_length) > cmd->seq_end_offset)) {
-			target_err("Command ITT: 0x%08x with Offset: %u,"
-				   " Length: %u outside of Sequence %u:%u while"
-				   " DataSequenceInOrder=Yes.\n",
+			target_err("Command ITT: 0x%08x with Offset: %u, Length: %u outside of Sequence %u:%u while DataSequenceInOrder=Yes.\n",
 				   cmd->init_task_tag, be32_to_cpu(hdr->offset), payload_length,
 				   cmd->seq_start_offset, cmd->seq_end_offset);
 
@@ -262,9 +250,7 @@ static int iscsit_dataout_check_sequence(
 	}
 
 	if (next_burst_len > conn->sess->sess_ops->MaxBurstLength) {
-		target_err("Command ITT: 0x%08x, NextBurstLength: %u and"
-			   " Length: %u exceeds MaxBurstLength: %u. protocol"
-			   " error.\n",
+		target_err("Command ITT: 0x%08x, NextBurstLength: %u and Length: %u exceeds MaxBurstLength: %u. protocol error.\n",
 			   cmd->init_task_tag, (next_burst_len - payload_length), payload_length,
 			   conn->sess->sess_ops->MaxBurstLength);
 		return DATAOUT_CANNOT_RECOVER;
@@ -288,17 +274,13 @@ static int iscsit_dataout_check_sequence(
 			     conn->sess->sess_ops->MaxBurstLength) &&
 			   ((cmd->write_data_done + payload_length) <
 			     cmd->se_cmd.data_length)) {
-				target_err("Command ITT: 0x%08x set ISCSI_FLAG_CMD_FINAL"
-					   " before end of DataOUT sequence, protocol"
-					   " error.\n",
+				target_err("Command ITT: 0x%08x set ISCSI_FLAG_CMD_FINAL before end of DataOUT sequence, protocol error.\n",
 					   cmd->init_task_tag);
 				return DATAOUT_CANNOT_RECOVER;
 			}
 		} else {
 			if (next_burst_len < seq->xfer_len) {
-				target_err("Command ITT: 0x%08x set ISCSI_FLAG_CMD_FINAL"
-					   " before end of DataOUT sequence, protocol"
-					   " error.\n",
+				target_err("Command ITT: 0x%08x set ISCSI_FLAG_CMD_FINAL before end of DataOUT sequence, protocol error.\n",
 					   cmd->init_task_tag);
 				return DATAOUT_CANNOT_RECOVER;
 			}
@@ -307,26 +289,20 @@ static int iscsit_dataout_check_sequence(
 		if (conn->sess->sess_ops->DataSequenceInOrder) {
 			if (next_burst_len ==
 					conn->sess->sess_ops->MaxBurstLength) {
-				target_err("Command ITT: 0x%08x reached"
-					   " MaxBurstLength: %u, but ISCSI_FLAG_CMD_FINAL is"
-					   " not set, protocol error.",
+				target_err("Command ITT: 0x%08x reached MaxBurstLength: %u, but ISCSI_FLAG_CMD_FINAL is not set, protocol error.",
 					   cmd->init_task_tag,
 					   conn->sess->sess_ops->MaxBurstLength);
 				return DATAOUT_CANNOT_RECOVER;
 			}
 			if ((cmd->write_data_done + payload_length) ==
 					cmd->se_cmd.data_length) {
-				target_err("Command ITT: 0x%08x reached"
-					   " last DataOUT PDU in sequence but ISCSI_FLAG_"
-					   "CMD_FINAL is not set, protocol error.\n",
+				target_err("Command ITT: 0x%08x reached last DataOUT PDU in sequence but ISCSI_FLAG_CMD_FINAL is not set, protocol error.\n",
 					   cmd->init_task_tag);
 				return DATAOUT_CANNOT_RECOVER;
 			}
 		} else {
 			if (next_burst_len == seq->xfer_len) {
-				target_err("Command ITT: 0x%08x reached"
-					   " last DataOUT PDU in sequence but ISCSI_FLAG_"
-					   "CMD_FINAL is not set, protocol error.\n",
+				target_err("Command ITT: 0x%08x reached last DataOUT PDU in sequence but ISCSI_FLAG_CMD_FINAL is not set, protocol error.\n",
 					   cmd->init_task_tag);
 				return DATAOUT_CANNOT_RECOVER;
 			}
@@ -362,13 +338,11 @@ static int iscsit_dataout_check_datasn(
 	}
 
 	if (be32_to_cpu(hdr->datasn) > data_sn) {
-		target_err("Command ITT: 0x%08x, received DataSN: 0x%08x"
-			   " higher than expected 0x%08x.\n",
+		target_err("Command ITT: 0x%08x, received DataSN: 0x%08x higher than expected 0x%08x.\n",
 			   cmd->init_task_tag, be32_to_cpu(hdr->datasn), data_sn);
 		goto recover;
 	} else if (be32_to_cpu(hdr->datasn) < data_sn) {
-		target_err("Command ITT: 0x%08x, received DataSN: 0x%08x"
-			   " lower than expected 0x%08x, discarding payload.\n",
+		target_err("Command ITT: 0x%08x, received DataSN: 0x%08x lower than expected 0x%08x, discarding payload.\n",
 			   cmd->init_task_tag, be32_to_cpu(hdr->datasn), data_sn);
 		goto dump;
 	}
@@ -377,8 +351,7 @@ static int iscsit_dataout_check_datasn(
 
 recover:
 	if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-		target_err("Unable to perform within-command recovery"
-			   " while ERL=0.\n");
+		target_err("Unable to perform within-command recovery while ERL=0.\n");
 		return DATAOUT_CANNOT_RECOVER;
 	}
 dump:
@@ -408,8 +381,7 @@ static int iscsit_dataout_pre_datapduinorder_yes(
 	 */
 	if (conn->sess->sess_ops->DataSequenceInOrder) {
 		if (be32_to_cpu(hdr->offset) != cmd->write_data_done) {
-			target_err("Command ITT: 0x%08x, received offset"
-				   " %u different than expected %u.\n",
+			target_err("Command ITT: 0x%08x, received offset %u different than expected %u.\n",
 				   cmd->init_task_tag, be32_to_cpu(hdr->offset),
 				   cmd->write_data_done);
 			recovery = 1;
@@ -419,14 +391,12 @@ static int iscsit_dataout_pre_datapduinorder_yes(
 		struct iscsi_seq *seq = cmd->seq_ptr;
 
 		if (be32_to_cpu(hdr->offset) > seq->offset) {
-			target_err("Command ITT: 0x%08x, received offset"
-				   " %u greater than expected %u.\n",
+			target_err("Command ITT: 0x%08x, received offset %u greater than expected %u.\n",
 				   cmd->init_task_tag, be32_to_cpu(hdr->offset), seq->offset);
 			recovery = 1;
 			goto recover;
 		} else if (be32_to_cpu(hdr->offset) < seq->offset) {
-			target_err("Command ITT: 0x%08x, received offset"
-				   " %u less than expected %u, discarding payload.\n",
+			target_err("Command ITT: 0x%08x, received offset %u less than expected %u, discarding payload.\n",
 				   cmd->init_task_tag, be32_to_cpu(hdr->offset), seq->offset);
 			dump = 1;
 			goto dump;
@@ -437,8 +407,7 @@ static int iscsit_dataout_pre_datapduinorder_yes(
 
 recover:
 	if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-		target_err("Unable to perform within-command recovery"
-			   " while ERL=0.\n");
+		target_err("Unable to perform within-command recovery while ERL=0.\n");
 		return DATAOUT_CANNOT_RECOVER;
 	}
 dump:
@@ -471,8 +440,7 @@ static int iscsit_dataout_pre_datapduinorder_no(
 	case ISCSI_PDU_TIMED_OUT:
 		break;
 	case ISCSI_PDU_RECEIVED_OK:
-		target_err("Command ITT: 0x%08x received already gotten"
-			   " Offset: %u, Length: %u\n",
+		target_err("Command ITT: 0x%08x received already gotten Offset: %u, Length: %u\n",
 			   cmd->init_task_tag, be32_to_cpu(hdr->offset), payload_length);
 		return iscsit_dump_data_payload(cmd->conn, payload_length, 1);
 	default:
@@ -734,8 +702,7 @@ int iscsit_check_post_dataout(
 		return iscsit_dataout_post_crc_passed(cmd, buf);
 	else {
 		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-			target_err("Unable to recover from DataOUT CRC"
-				   " failure while ERL=0, closing session.\n");
+			target_err("Unable to recover from DataOUT CRC failure while ERL=0, closing session.\n");
 			iscsit_reject_cmd(cmd, ISCSI_REASON_DATA_DIGEST_ERROR,
 					  buf);
 			return DATAOUT_CANNOT_RECOVER;
@@ -758,15 +725,13 @@ void iscsit_handle_time2retain_timeout(struct timer_list *t)
 		return;
 	}
 	if (atomic_read(&sess->session_reinstatement)) {
-		target_err("Exiting Time2Retain handler because"
-			   " session_reinstatement=1\n");
+		target_err("Exiting Time2Retain handler because session_reinstatement=1\n");
 		spin_unlock_bh(&se_tpg->session_lock);
 		return;
 	}
 	sess->time2retain_timer_flags |= ISCSI_TF_EXPIRED;
 
-	target_err("Time2Retain timer expired for SID: %u, cleaning up"
-		   " iSCSI session.\n",
+	target_err("Time2Retain timer expired for SID: %u, cleaning up iSCSI session.\n",
 		   sess->sid);
 
 	iscsit_fill_cxn_timeout_err_stats(sess);
@@ -791,8 +756,7 @@ void iscsit_start_time2retain_handler(struct iscsit_session *sess)
 	if (sess->time2retain_timer_flags & ISCSI_TF_RUNNING)
 		return;
 
-	target_debug("Starting Time2Retain timer for %u seconds on"
-		     " SID: %u\n",
+	target_debug("Starting Time2Retain timer for %u seconds on SID: %u\n",
 		     sess->sess_ops->DefaultTime2Retain, sess->sid);
 
 	sess->time2retain_timer_flags &= ~ISCSI_TF_STOP;
@@ -888,9 +852,7 @@ EXPORT_SYMBOL(iscsit_cause_connection_reinstatement);
 
 void iscsit_fall_back_to_erl0(struct iscsit_session *sess)
 {
-	target_debug("Falling back to ErrorRecoveryLevel=0 for SID:"
-		     " %u\n",
-		     sess->sid);
+	target_debug("Falling back to ErrorRecoveryLevel=0 for SID: %u\n", sess->sid);
 
 	atomic_set(&sess->session_fall_back_to_erl0, 1);
 }
@@ -904,8 +866,7 @@ static void iscsit_handle_connection_cleanup(struct iscsit_conn *conn)
 	    !atomic_read(&sess->session_fall_back_to_erl0))
 		iscsit_connection_recovery_transport_reset(conn);
 	else {
-		target_debug("Performing cleanup for failed iSCSI"
-			     " Connection ID: %hu from %s\n",
+		target_debug("Performing cleanup for failed iSCSI Connection ID: %hu from %s\n",
 			     conn->cid, sess->sess_ops->InitiatorName);
 		iscsit_close_connection(conn);
 	}
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 210530b586ef..54dc01d289cf 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -58,9 +58,7 @@ int iscsit_dump_data_payload(
 
 	buf = kzalloc(length, GFP_ATOMIC);
 	if (!buf) {
-		target_err("Unable to allocate %u bytes for offload"
-			   " buffer.\n",
-			   length);
+		target_err("Unable to allocate %u bytes for offload buffer.\n", length);
 		return -1;
 	}
 	memset(&iov, 0, sizeof(struct kvec));
@@ -124,10 +122,7 @@ static int iscsit_handle_r2t_snack(
 	 */
 	if ((cmd->cmd_flags & ICF_GOT_DATACK_SNACK) &&
 	    (begrun <= cmd->acked_data_sn)) {
-		target_err("ITT: 0x%08x, R2T SNACK requesting"
-			   " retransmission of R2TSN: 0x%08x to 0x%08x but already"
-			   " acked to  R2TSN: 0x%08x by TMR TASK_REASSIGN,"
-			   " protocol error.\n",
+		target_err("ITT: 0x%08x, R2T SNACK requesting retransmission of R2TSN: 0x%08x to 0x%08x but already acked to  R2TSN: 0x%08x by TMR TASK_REASSIGN, protocol error.\n",
 			   cmd->init_task_tag, begrun, (begrun + runlength), cmd->acked_data_sn);
 
 		return iscsit_reject_cmd(cmd, ISCSI_REASON_PROTOCOL_ERROR, buf);
@@ -135,9 +130,7 @@ static int iscsit_handle_r2t_snack(
 
 	if (runlength) {
 		if ((begrun + runlength) > cmd->r2t_sn) {
-			target_err("Command ITT: 0x%08x received R2T SNACK"
-				   " with BegRun: 0x%08x, RunLength: 0x%08x, exceeds"
-				   " current R2TSN: 0x%08x, protocol error.\n",
+			target_err("Command ITT: 0x%08x received R2T SNACK with BegRun: 0x%08x, RunLength: 0x%08x, exceeds current R2TSN: 0x%08x, protocol error.\n",
 				   cmd->init_task_tag, begrun, runlength, cmd->r2t_sn);
 			return iscsit_reject_cmd(cmd,
 					ISCSI_REASON_BOOKMARK_INVALID, buf);
@@ -249,8 +242,7 @@ int iscsit_create_recovery_datain_values_datasequenceinorder_no(
 		 * seq->first_datasn and seq->last_datasn have not been set.
 		 */
 		if (!seq->sent) {
-			target_err("Ignoring non-sent sequence 0x%08x ->"
-				   " 0x%08x\n\n",
+			target_err("Ignoring non-sent sequence 0x%08x -> 0x%08x\n\n",
 				   seq->first_datasn, seq->last_datasn);
 			continue;
 		}
@@ -262,9 +254,8 @@ int iscsit_create_recovery_datain_values_datasequenceinorder_no(
 		 */
 		if ((seq->first_datasn < begrun) &&
 				(seq->last_datasn < begrun)) {
-			target_err("Pre BegRun sequence 0x%08x ->"
-				   " 0x%08x\n",
-				   seq->first_datasn, seq->last_datasn);
+			target_err("Pre BegRun sequence 0x%08x -> 0x%08x\n", seq->first_datasn,
+				   seq->last_datasn);
 
 			read_data_done += cmd->seq_list[i].xfer_len;
 			seq->next_burst_len = seq->pdu_send_order = 0;
@@ -276,9 +267,8 @@ int iscsit_create_recovery_datain_values_datasequenceinorder_no(
 		 */
 		if ((seq->first_datasn <= begrun) &&
 				(seq->last_datasn >= begrun)) {
-			target_err("Found sequence begrun: 0x%08x in"
-				   " 0x%08x -> 0x%08x\n",
-				   begrun, seq->first_datasn, seq->last_datasn);
+			target_err("Found sequence begrun: 0x%08x in 0x%08x -> 0x%08x\n", begrun,
+				   seq->first_datasn, seq->last_datasn);
 
 			seq_send_order = seq->seq_send_order;
 			data_sn = seq->first_datasn;
@@ -346,8 +336,7 @@ int iscsit_create_recovery_datain_values_datasequenceinorder_no(
 	if (!found_seq) {
 		if (!begrun) {
 			if (!first_seq) {
-				target_err("ITT: 0x%08x, Begrun: 0x%08x"
-					   " but first_seq is NULL\n",
+				target_err("ITT: 0x%08x, Begrun: 0x%08x but first_seq is NULL\n",
 					   cmd->init_task_tag, begrun);
 				return -1;
 			}
@@ -356,9 +345,7 @@ int iscsit_create_recovery_datain_values_datasequenceinorder_no(
 			goto done;
 		}
 
-		target_err("Unable to locate struct iscsi_seq for ITT: 0x%08x,"
-			   " BegRun: 0x%08x, RunLength: 0x%08x while"
-			   " DataSequenceInOrder=No and DataPDUInOrder=%s.\n",
+		target_err("Unable to locate struct iscsi_seq for ITT: 0x%08x, BegRun: 0x%08x, RunLength: 0x%08x while DataSequenceInOrder=No and DataPDUInOrder=%s.\n",
 			   cmd->init_task_tag, begrun, runlength,
 			   (conn->sess->sess_ops->DataPDUInOrder) ? "Yes" : "No");
 		return -1;
@@ -392,10 +379,7 @@ static int iscsit_handle_recovery_datain(
 	 */
 	if ((cmd->cmd_flags & ICF_GOT_DATACK_SNACK) &&
 	    (begrun <= cmd->acked_data_sn)) {
-		target_err("ITT: 0x%08x, Data SNACK requesting"
-			   " retransmission of DataSN: 0x%08x to 0x%08x but"
-			   " already acked to DataSN: 0x%08x by Data ACK SNACK,"
-			   " protocol error.\n",
+		target_err("ITT: 0x%08x, Data SNACK requesting retransmission of DataSN: 0x%08x to 0x%08x but already acked to DataSN: 0x%08x by Data ACK SNACK, protocol error.\n",
 			   cmd->init_task_tag, begrun, (begrun + runlength), cmd->acked_data_sn);
 
 		return iscsit_reject_cmd(cmd, ISCSI_REASON_PROTOCOL_ERROR, buf);
@@ -406,8 +390,7 @@ static int iscsit_handle_recovery_datain(
 	 * Note: (cmd->data_sn - 1) will carry the maximum DataSN sent.
 	 */
 	if ((begrun + runlength) > (cmd->data_sn - 1)) {
-		target_err("Initiator requesting BegRun: 0x%08x, RunLength"
-			   ": 0x%08x greater than maximum DataSN: 0x%08x.\n",
+		target_err("Initiator requesting BegRun: 0x%08x, RunLength: 0x%08x greater than maximum DataSN: 0x%08x.\n",
 			   begrun, runlength, (cmd->data_sn - 1));
 		return iscsit_reject_cmd(cmd, ISCSI_REASON_BOOKMARK_INVALID,
 					 buf);
@@ -477,9 +460,7 @@ int iscsit_handle_status_snack(
 	if (!begrun) {
 		begrun = conn->exp_statsn;
 	} else if (conn->exp_statsn > begrun) {
-		target_err("Got Status SNACK Begrun: 0x%08x, RunLength:"
-			   " 0x%08x but already got ExpStatSN: 0x%08x on CID:"
-			   " %hu.\n",
+		target_err("Got Status SNACK Begrun: 0x%08x, RunLength: 0x%08x but already got ExpStatSN: 0x%08x on CID: %hu.\n",
 			   begrun, runlength, conn->exp_statsn, conn->cid);
 		return 0;
 	}
@@ -499,10 +480,7 @@ int iscsit_handle_status_snack(
 		spin_unlock_bh(&conn->cmd_lock);
 
 		if (!found_cmd) {
-			target_err("Unable to find StatSN: 0x%08x for"
-				   " a Status SNACK, assuming this was a"
-				   " protactic SNACK for an untransmitted"
-				   " StatSN, ignoring.\n",
+			target_err("Unable to find StatSN: 0x%08x for a Status SNACK, assuming this was a protactic SNACK for an untransmitted StatSN, ignoring.\n",
 				   begrun);
 			begrun++;
 			continue;
@@ -511,10 +489,7 @@ int iscsit_handle_status_snack(
 		spin_lock_bh(&cmd->istate_lock);
 		if (cmd->i_state == ISTATE_SEND_DATAIN) {
 			spin_unlock_bh(&cmd->istate_lock);
-			target_err("Ignoring Status SNACK for BegRun:"
-				   " 0x%08x, RunLength: 0x%08x, assuming this was"
-				   " a protactic SNACK for an untransmitted"
-				   " StatSN\n",
+			target_err("Ignoring Status SNACK for BegRun: 0x%08x, RunLength: 0x%08x, assuming this was a protactic SNACK for an untransmitted StatSN\n",
 				   begrun, runlength);
 			begrun++;
 			continue;
@@ -539,15 +514,12 @@ int iscsit_handle_data_ack(
 
 	cmd = iscsit_find_cmd_from_ttt(conn, targ_xfer_tag);
 	if (!cmd) {
-		target_err("Data ACK SNACK for TTT: 0x%08x is"
-			   " invalid.\n",
-			   targ_xfer_tag);
+		target_err("Data ACK SNACK for TTT: 0x%08x is invalid.\n", targ_xfer_tag);
 		return -1;
 	}
 
 	if (begrun <= cmd->acked_data_sn) {
-		target_err("ITT: 0x%08x Data ACK SNACK BegRUN: 0x%08x is"
-			   " less than the already acked DataSN: 0x%08x.\n",
+		target_err("ITT: 0x%08x Data ACK SNACK BegRUN: 0x%08x is less than the already acked DataSN: 0x%08x.\n",
 			   cmd->init_task_tag, begrun, cmd->acked_data_sn);
 		return -1;
 	}
@@ -559,8 +531,7 @@ int iscsit_handle_data_ack(
 	cmd->cmd_flags |= ICF_GOT_DATACK_SNACK;
 	cmd->acked_data_sn = (begrun - 1);
 
-	target_debug("Received Data ACK SNACK for ITT: 0x%08x,"
-		     " updated acked DataSN to 0x%08x.\n",
+	target_debug("Received Data ACK SNACK for ITT: 0x%08x, updated acked DataSN to 0x%08x.\n",
 		     cmd->init_task_tag, cmd->acked_data_sn);
 
 	return 0;
@@ -758,8 +729,7 @@ static struct iscsi_ooo_cmdsn *iscsit_allocate_ooo_cmdsn(void)
 
 	ooo_cmdsn = kmem_cache_zalloc(lio_ooo_cache, GFP_ATOMIC);
 	if (!ooo_cmdsn) {
-		target_err("Unable to allocate memory for"
-			   " struct iscsi_ooo_cmdsn.\n");
+		target_err("Unable to allocate memory for struct iscsi_ooo_cmdsn.\n");
 		return NULL;
 	}
 	INIT_LIST_HEAD(&ooo_cmdsn->ooo_list);
@@ -864,8 +834,7 @@ int iscsit_execute_ooo_cmdsns(struct iscsit_session *sess)
 		cmd->i_state = cmd->deferred_i_state;
 		ooo_count++;
 		sess->exp_cmd_sn++;
-		target_debug("Executing out of order CmdSN: 0x%08x,"
-			     " incremented ExpCmdSN to 0x%08x.\n",
+		target_debug("Executing out of order CmdSN: 0x%08x, incremented ExpCmdSN to 0x%08x.\n",
 			     cmd->cmd_sn, sess->exp_cmd_sn);
 
 		iscsit_remove_ooo_cmdsn(sess, ooo_cmdsn);
@@ -979,8 +948,7 @@ int iscsit_execute_cmd(struct iscsit_cmd *cmd, int ooo)
 			lr = iscsit_logout_removeconnforrecovery(cmd, cmd->conn);
 			break;
 		default:
-			target_err("Unknown iSCSI Logout Request Code:"
-				   " 0x%02x\n",
+			target_err("Unknown iSCSI Logout Request Code: 0x%02x\n",
 				   cmd->logout_reason);
 			return -1;
 		}
@@ -988,8 +956,7 @@ int iscsit_execute_cmd(struct iscsit_cmd *cmd, int ooo)
 		return lr;
 	default:
 		spin_unlock_bh(&cmd->istate_lock);
-		target_err("Cannot perform out of order execution for"
-			   " unknown iSCSI Opcode: 0x%02x\n",
+		target_err("Cannot perform out of order execution for unknown iSCSI Opcode: 0x%02x\n",
 			   cmd->iscsi_opcode);
 		return -1;
 	}
@@ -1085,8 +1052,7 @@ static int iscsit_set_dataout_timeout_values(
 	}
 	spin_unlock_bh(&cmd->r2t_lock);
 
-	target_err("Unable to locate any incomplete DataOUT"
-		   " sequences for ITT: 0x%08x.\n",
+	target_err("Unable to locate any incomplete DataOUT sequences for ITT: 0x%08x.\n",
 		   cmd->init_task_tag);
 
 	return -1;
@@ -1117,18 +1083,14 @@ void iscsit_handle_dataout_timeout(struct timer_list *t)
 	na = iscsit_tpg_get_node_attrib(sess);
 
 	if (!sess->sess_ops->ErrorRecoveryLevel) {
-		target_err("Unable to recover from DataOut timeout while"
-			   " in ERL=0, closing iSCSI connection for I_T Nexus"
-			   " %s,i,0x%6phN,%s,t,0x%02x\n",
+		target_err("Unable to recover from DataOut timeout while in ERL=0, closing iSCSI connection for I_T Nexus %s,i,0x%6phN,%s,t,0x%02x\n",
 			   sess->sess_ops->InitiatorName, sess->isid, sess->tpg->tpg_tiqn->tiqn,
 			   (u32)sess->tpg->tpgt);
 		goto failure;
 	}
 
 	if (++cmd->dataout_timeout_retries == na->dataout_timeout_retries) {
-		target_err("Command ITT: 0x%08x exceeded max retries"
-			   " for DataOUT timeout %u, closing iSCSI connection for"
-			   " I_T Nexus %s,i,0x%6phN,%s,t,0x%02x\n",
+		target_err("Command ITT: 0x%08x exceeded max retries for DataOUT timeout %u, closing iSCSI connection for I_T Nexus %s,i,0x%6phN,%s,t,0x%02x\n",
 			   cmd->init_task_tag, na->dataout_timeout_retries,
 			   sess->sess_ops->InitiatorName, sess->isid, sess->tpg->tpg_tiqn->tiqn,
 			   (u32)sess->tpg->tpgt);
@@ -1162,8 +1124,7 @@ void iscsit_handle_dataout_timeout(struct timer_list *t)
 			&r2t_offset, &r2t_length) < 0)
 		goto failure;
 
-	target_debug("Command ITT: 0x%08x timed out waiting for"
-		     " completion of %sDataOUT Sequence Offset: %u, Length: %u\n",
+	target_debug("Command ITT: 0x%08x timed out waiting for completion of %sDataOUT Sequence Offset: %u, Length: %u\n",
 		     cmd->init_task_tag, (cmd->unsolicited_data) ? "Unsolicited " : "", r2t_offset,
 		     r2t_length);
 
@@ -1213,9 +1174,8 @@ void iscsit_start_dataout_timer(
 	if (cmd->dataout_timer_flags & ISCSI_TF_RUNNING)
 		return;
 
-	target_debug("Starting DataOUT timer for ITT: 0x%08x on"
-		     " CID: %hu.\n",
-		     cmd->init_task_tag, conn->cid);
+	target_debug("Starting DataOUT timer for ITT: 0x%08x on CID: %hu.\n", cmd->init_task_tag,
+		     conn->cid);
 
 	cmd->dataout_timer_flags &= ~ISCSI_TF_STOP;
 	cmd->dataout_timer_flags |= ISCSI_TF_RUNNING;
diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
index 8b84ff97b0f0..96fb0ea0ad4c 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.c
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -92,8 +92,7 @@ static int iscsit_attach_inactive_connection_recovery_entry(
 	list_add_tail(&cr->cr_list, &sess->cr_inactive_list);
 
 	sess->conn_recovery_count++;
-	target_debug("Incremented connection recovery count to %u for"
-		     " SID: %u\n",
+	target_debug("Incremented connection recovery count to %u for SID: %u\n",
 		     sess->conn_recovery_count, sess->sid);
 	spin_unlock(&sess->cr_i_lock);
 
@@ -176,8 +175,7 @@ int iscsit_remove_active_connection_recovery_entry(
 	list_del(&cr->cr_list);
 
 	sess->conn_recovery_count--;
-	target_debug("Decremented connection recovery count to %u for"
-		     " SID: %u\n",
+	target_debug("Decremented connection recovery count to %u for SID: %u\n",
 		     sess->conn_recovery_count, sess->sid);
 	spin_unlock(&sess->cr_a_lock);
 
@@ -205,8 +203,7 @@ int iscsit_remove_cmd_from_connection_recovery(
 	struct iscsi_conn_recovery *cr;
 
 	if (!cmd->cr) {
-		target_err("struct iscsi_conn_recovery pointer for ITT: 0x%08x"
-			   " is NULL!\n",
+		target_err("struct iscsi_conn_recovery pointer for ITT: 0x%08x is NULL!\n",
 			   cmd->init_task_tag);
 		BUG();
 	}
@@ -235,8 +232,7 @@ void iscsit_discard_cr_cmds_by_expstatsn(
 		}
 
 		dropped_count++;
-		target_debug("Dropping Acknowledged ITT: 0x%08x, StatSN:"
-			     " 0x%08x, CID: %hu.\n",
+		target_debug("Dropping Acknowledged ITT: 0x%08x, StatSN: 0x%08x, CID: %hu.\n",
 			     cmd->init_task_tag, cmd->stat_sn, cr->cid);
 
 		iscsit_remove_cmd_from_connection_recovery(cmd, sess);
@@ -247,18 +243,15 @@ void iscsit_discard_cr_cmds_by_expstatsn(
 	}
 	spin_unlock(&cr->conn_recovery_cmd_lock);
 
-	target_debug("Dropped %u total acknowledged commands on"
-		     " CID: %hu less than old ExpStatSN: 0x%08x\n",
+	target_debug("Dropped %u total acknowledged commands on CID: %hu less than old ExpStatSN: 0x%08x\n",
 		     dropped_count, cr->cid, exp_statsn);
 
 	if (!cr->cmd_count) {
-		target_debug("No commands to be reassigned for failed"
-			     " connection CID: %hu on SID: %u\n",
+		target_debug("No commands to be reassigned for failed connection CID: %hu on SID: %u\n",
 			     cr->cid, sess->sid);
 		iscsit_remove_inactive_connection_recovery_entry(cr, sess);
 		iscsit_attach_active_connection_recovery_entry(sess, cr);
-		target_debug("iSCSI connection recovery successful for CID:"
-			     " %hu on SID: %u\n",
+		target_debug("iSCSI connection recovery successful for CID: %hu on SID: %u\n",
 			     cr->cid, sess->sid);
 		iscsit_remove_active_connection_recovery_entry(cr, sess);
 	} else {
@@ -282,8 +275,7 @@ int iscsit_discard_unacknowledged_ooo_cmdsns_for_conn(struct iscsit_conn *conn)
 			continue;
 
 		dropped_count++;
-		target_debug("Dropping unacknowledged CmdSN:"
-			     " 0x%08x during connection recovery on CID: %hu\n",
+		target_debug("Dropping unacknowledged CmdSN: 0x%08x during connection recovery on CID: %hu\n",
 			     ooo_cmdsn->cmdsn, conn->cid);
 		iscsit_remove_ooo_cmdsn(sess, ooo_cmdsn);
 	}
@@ -302,8 +294,7 @@ int iscsit_discard_unacknowledged_ooo_cmdsns_for_conn(struct iscsit_conn *conn)
 	}
 	spin_unlock_bh(&conn->cmd_lock);
 
-	target_debug("Dropped %u total unacknowledged commands on CID:"
-		     " %hu for ExpCmdSN: 0x%08x.\n",
+	target_debug("Dropped %u total unacknowledged commands on CID: %hu for ExpCmdSN: 0x%08x.\n",
 		     dropped_count, conn->cid, sess->exp_cmd_sn);
 	return 0;
 }
@@ -322,8 +313,7 @@ int iscsit_prepare_cmds_for_reallegiance(struct iscsit_conn *conn)
 	 */
 	cr = kzalloc(sizeof(struct iscsi_conn_recovery), GFP_KERNEL);
 	if (!cr) {
-		target_err("Unable to allocate memory for"
-			   " struct iscsi_conn_recovery.\n");
+		target_err("Unable to allocate memory for struct iscsi_conn_recovery.\n");
 		return -1;
 	}
 	INIT_LIST_HEAD(&cr->cr_list);
@@ -343,9 +333,7 @@ int iscsit_prepare_cmds_for_reallegiance(struct iscsit_conn *conn)
 
 		if ((cmd->iscsi_opcode != ISCSI_OP_SCSI_CMD) &&
 		    (cmd->iscsi_opcode != ISCSI_OP_NOOP_OUT)) {
-			target_debug("Not performing reallegiance on"
-				     " Opcode: 0x%02x, ITT: 0x%08x, CmdSN: 0x%08x,"
-				     " CID: %hu\n",
+			target_debug("Not performing reallegiance on Opcode: 0x%02x, ITT: 0x%08x, CmdSN: 0x%08x, CID: %hu\n",
 				     cmd->iscsi_opcode, cmd->init_task_tag, cmd->cmd_sn, conn->cid);
 
 			list_del_init(&cmd->i_conn_node);
@@ -376,9 +364,7 @@ int iscsit_prepare_cmds_for_reallegiance(struct iscsit_conn *conn)
 		}
 
 		cmd_count++;
-		target_debug("Preparing Opcode: 0x%02x, ITT: 0x%08x,"
-			     " CmdSN: 0x%08x, StatSN: 0x%08x, CID: %hu for"
-			     " reallegiance.\n",
+		target_debug("Preparing Opcode: 0x%02x, ITT: 0x%08x, CmdSN: 0x%08x, StatSN: 0x%08x, CID: %hu for reallegiance.\n",
 			     cmd->iscsi_opcode, cmd->init_task_tag, cmd->cmd_sn, cmd->stat_sn,
 			     conn->cid);
 
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 99dfe612bdcc..0450408bd9a3 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -117,8 +117,7 @@ static int iscsi_login_check_initiator_version(
 	u8 version_min)
 {
 	if ((version_max != 0x00) || (version_min != 0x00)) {
-		target_err("Unsupported iSCSI IETF Pre-RFC Revision,"
-			   " version Min/Max 0x%02x/0x%02x, rejecting login.\n",
+		target_err("Unsupported iSCSI IETF Pre-RFC Revision, version Min/Max 0x%02x/0x%02x, rejecting login.\n",
 			   version_min, version_max);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_NO_VERSION);
@@ -184,8 +183,7 @@ int iscsi_check_for_session_reinstatement(struct iscsit_conn *conn)
 	if (!sess)
 		return 0;
 
-	target_debug("%s iSCSI Session SID %u is still active for %s,"
-		     " performing session reinstatement.\n",
+	target_debug("%s iSCSI Session SID %u is still active for %s, performing session reinstatement.\n",
 		     (sessiontype) ? "Discovery" : "Normal", sess->sid,
 		     sess->sess_ops->InitiatorName);
 
@@ -312,8 +310,7 @@ static int iscsi_login_zero_tsih_s1(
 	if (!sess->sess_ops) {
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		target_err("Unable to allocate memory for"
-			   " struct iscsi_sess_ops.\n");
+		target_err("Unable to allocate memory for struct iscsi_sess_ops.\n");
 		goto free_id;
 	}
 
@@ -442,8 +439,7 @@ static int iscsi_login_zero_tsih_s2(
 		else
 			mrdsl -= off;
 
-		target_warn("Aligning ISER MaxRecvDataSegmentLength: %lu down"
-			    " to PAGE_SIZE\n",
+		target_warn("Aligning ISER MaxRecvDataSegmentLength: %lu down to PAGE_SIZE\n",
 			    mrdsl);
 
 		if (iscsi_change_param_sprintf(conn, "MaxRecvDataSegmentLength=%lu\n", mrdsl))
@@ -463,8 +459,7 @@ static int iscsi_login_zero_tsih_s2(
 			if (iscsi_change_param_sprintf(conn, "InitialR2T=Yes"))
 				return -1;
 
-			target_debug("Forcing ImmediateData=No + InitialR2T=Yes for"
-				     " T10-PI enabled ISER session\n");
+			target_debug("Forcing ImmediateData=No + InitialR2T=Yes for T10-PI enabled ISER session\n");
 		}
 	}
 
@@ -518,8 +513,7 @@ static int iscsi_login_non_zero_tsih_s2(
 	 * If the Time2Retain handler has expired, the session is already gone.
 	 */
 	if (!sess) {
-		target_err("Initiator attempting to add a connection to"
-			   " a non-existent session, rejecting iSCSI Login.\n");
+		target_err("Initiator attempting to add a connection to a non-existent session, rejecting iSCSI Login.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_NO_SESSION);
 		return -1;
@@ -577,8 +571,7 @@ int iscsi_login_post_auth_non_zero_tsih(
 	 */
 	conn_ptr = iscsit_get_conn_from_cid_rcfr(sess, cid);
 	if (conn_ptr) {
-		target_err("Connection exists with CID %hu for %s,"
-			   " performing connection reinstatement.\n",
+		target_err("Connection exists with CID %hu for %s, performing connection reinstatement.\n",
 			   conn_ptr->cid, sess->sess_ops->InitiatorName);
 
 		iscsit_connection_reinstatement_rcfr(conn_ptr);
@@ -598,8 +591,7 @@ int iscsi_login_post_auth_non_zero_tsih(
 		cr = iscsit_get_inactive_connection_recovery_entry(
 				sess, cid);
 		if (cr) {
-			target_debug("Performing implicit logout"
-				     " for connection recovery on CID: %hu\n",
+			target_debug("Performing implicit logout for connection recovery on CID: %hu\n",
 				     conn->cid);
 			iscsit_discard_cr_cmds_by_expstatsn(cr, exp_statsn);
 		}
@@ -615,8 +607,7 @@ int iscsi_login_post_auth_non_zero_tsih(
 		     sess->sess_ops->InitiatorName);
 
 	if ((atomic_read(&sess->nconn) + 1) > sess->sess_ops->MaxConnections) {
-		target_err("Adding additional connection to this session"
-			   " would exceed MaxConnections %d, login failed.\n",
+		target_err("Adding additional connection to this session would exceed MaxConnections %d, login failed.\n",
 			   sess->sess_ops->MaxConnections);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_ISID_ERROR);
@@ -649,8 +640,7 @@ int iscsit_start_kthreads(struct iscsit_conn *conn)
 	spin_unlock(&iscsit_global->ts_bitmap_lock);
 
 	if (conn->bitmap_id < 0) {
-		target_err("bitmap_find_free_region() failed for"
-			   " iscsit_start_kthreads()\n");
+		target_err("bitmap_find_free_region() failed for iscsit_start_kthreads()\n");
 		return -ENOMEM;
 	}
 
@@ -717,20 +707,17 @@ void iscsi_post_login_handler(
 		spin_lock_bh(&sess->conn_lock);
 		atomic_set(&sess->session_continuation, 0);
 		if (sess->session_state == TARG_SESS_STATE_FAILED) {
-			target_debug("Moving to"
-				     " TARG_SESS_STATE_LOGGED_IN.\n");
+			target_debug("Moving to TARG_SESS_STATE_LOGGED_IN.\n");
 			sess->session_state = TARG_SESS_STATE_LOGGED_IN;
 			stop_timer = 1;
 		}
 
-		target_debug("iSCSI Login successful on CID: %hu from %pISpc to"
-			     " %pISpc,%hu\n",
+		target_debug("iSCSI Login successful on CID: %hu from %pISpc to %pISpc,%hu\n",
 			     conn->cid, &conn->login_sockaddr, &conn->local_sockaddr, tpg->tpgt);
 
 		list_add_tail(&conn->conn_list, &sess->sess_conn_list);
 		atomic_inc(&sess->nconn);
-		target_debug("Incremented iSCSI Connection count to %d"
-			     " from node: %s\n",
+		target_debug("Incremented iSCSI Connection count to %d from node: %s\n",
 			     atomic_read(&sess->nconn), sess->sess_ops->InitiatorName);
 		spin_unlock_bh(&sess->conn_lock);
 
@@ -776,8 +763,7 @@ void iscsi_post_login_handler(
 	spin_lock_bh(&sess->conn_lock);
 	list_add_tail(&conn->conn_list, &sess->sess_conn_list);
 	atomic_inc(&sess->nconn);
-	target_debug("Incremented iSCSI Connection count to %d from node:"
-		     " %s\n",
+	target_debug("Incremented iSCSI Connection count to %d from node: %s\n",
 		     atomic_read(&sess->nconn), sess->sess_ops->InitiatorName);
 	spin_unlock_bh(&sess->conn_lock);
 
@@ -790,8 +776,7 @@ void iscsi_post_login_handler(
 	if (tpg->tpg_tiqn)
 		tpg->tpg_tiqn->tiqn_nsessions++;
 
-	target_debug("Incremented number of active iSCSI sessions to %u on"
-		     " iSCSI Target Portal Group: %hu\n",
+	target_debug("Incremented number of active iSCSI sessions to %u on iSCSI Target Portal Group: %hu\n",
 		     tpg->nsessions, tpg->tpgt);
 	spin_unlock_bh(&se_tpg->session_lock);
 
@@ -976,8 +961,7 @@ int iscsit_get_login_rx(struct iscsit_conn *conn, struct iscsi_login *login)
 	payload_length	= ntoh24(login_req->dlength);
 	padding = ((-payload_length) & 3);
 
-	target_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x,"
-		     " CmdSN: 0x%08x, ExpStatSN: 0x%08x, CID: %hu, Length: %u\n",
+	target_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x, CmdSN: 0x%08x, ExpStatSN: 0x%08x, CID: %hu, Length: %u\n",
 		     login_req->flags, login_req->itt, login_req->cmdsn, login_req->exp_statsn,
 		     login_req->cid, payload_length);
 	/*
@@ -1277,8 +1261,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	spin_lock_bh(&np->np_thread_lock);
 	if (np->np_thread_state != ISCSI_NP_THREAD_ACTIVE) {
 		spin_unlock_bh(&np->np_thread_lock);
-		target_err("iSCSI Network Portal on %pISpc currently not"
-			   " active.\n",
+		target_err("iSCSI Network Portal on %pISpc currently not active.\n",
 			   &np->np_sockaddr);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_SVC_UNAVAILABLE);
@@ -1288,8 +1271,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 
 	conn->network_transport = np->np_network_transport;
 
-	target_debug("Received iSCSI login request from %pISpc on %s Network"
-		     " Portal %pISpc\n",
+	target_debug("Received iSCSI login request from %pISpc on %s Network Portal %pISpc\n",
 		     &conn->login_sockaddr, np->np_transport->name, &conn->local_sockaddr);
 
 	target_debug("Moving to TARG_CONN_STATE_IN_LOGIN.\n");
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 5e7f3baa13bb..4f60ec03c95c 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -88,9 +88,7 @@ int extract_param(
 		return -EINVAL;
 
 	if (len >= max_length) {
-		target_err("Length of input: %d exceeds max_length:"
-			   " %d\n",
-			   len, max_length);
+		target_err("Length of input: %d exceeds max_length: %d\n", len, max_length);
 		return -EINVAL;
 	}
 	memcpy(out_buf, ptr, len);
@@ -181,8 +179,7 @@ int iscsi_target_check_login_request(
 
 	if ((login_req->flags & ISCSI_FLAG_LOGIN_CONTINUE) &&
 	    (login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT)) {
-		target_err("Login request has both ISCSI_FLAG_LOGIN_CONTINUE"
-			   " and ISCSI_FLAG_LOGIN_TRANSIT set, protocol error.\n");
+		target_err("Login request has both ISCSI_FLAG_LOGIN_CONTINUE and ISCSI_FLAG_LOGIN_TRANSIT set, protocol error.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_INIT_ERR);
 		return -1;
@@ -192,8 +189,7 @@ int iscsi_target_check_login_request(
 	req_nsg = ISCSI_LOGIN_NEXT_STAGE(login_req->flags);
 
 	if (req_csg != login->current_stage) {
-		target_err("Initiator unexpectedly changed login stage"
-			   " from %d to %d, login failed.\n",
+		target_err("Initiator unexpectedly changed login stage from %d to %d, login failed.\n",
 			   login->current_stage, req_csg);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_INIT_ERR);
@@ -203,8 +199,7 @@ int iscsi_target_check_login_request(
 	if ((req_nsg == 2) || (req_csg >= 2) ||
 	   ((login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT) &&
 	    (req_nsg <= req_csg))) {
-		target_err("Illegal login_req->flags Combination, CSG: %d,"
-			   " NSG: %d, ISCSI_FLAG_LOGIN_TRANSIT: %d.\n",
+		target_err("Illegal login_req->flags Combination, CSG: %d, NSG: %d, ISCSI_FLAG_LOGIN_TRANSIT: %d.\n",
 			   req_csg, req_nsg, (login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT));
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_INIT_ERR);
@@ -213,8 +208,7 @@ int iscsi_target_check_login_request(
 
 	if ((login_req->max_version != login->version_max) ||
 	    (login_req->min_version != login->version_min)) {
-		target_err("Login request changed Version Max/Nin"
-			   " unexpectedly to 0x%02x/0x%02x, protocol error\n",
+		target_err("Login request changed Version Max/Nin unexpectedly to 0x%02x/0x%02x, protocol error\n",
 			   login_req->max_version, login_req->min_version);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_INIT_ERR);
@@ -222,16 +216,14 @@ int iscsi_target_check_login_request(
 	}
 
 	if (memcmp(login_req->isid, login->isid, 6) != 0) {
-		target_err("Login request changed ISID unexpectedly,"
-			   " protocol error.\n");
+		target_err("Login request changed ISID unexpectedly, protocol error.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_INIT_ERR);
 		return -1;
 	}
 
 	if (login_req->itt != login->init_task_tag) {
-		target_err("Login request changed ITT unexpectedly to"
-			   " 0x%08x, protocol error.\n",
+		target_err("Login request changed ITT unexpectedly to 0x%08x, protocol error.\n",
 			   login_req->itt);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_INIT_ERR);
@@ -239,8 +231,7 @@ int iscsi_target_check_login_request(
 	}
 
 	if (payload_length > MAX_KEY_VALUE_PAIRS) {
-		target_err("Login request payload exceeds default"
-			   " MaxRecvDataSegmentLength: %u, protocol error.\n",
+		target_err("Login request payload exceeds default MaxRecvDataSegmentLength: %u, protocol error.\n",
 			   MAX_KEY_VALUE_PAIRS);
 		return -1;
 	}
@@ -261,8 +252,7 @@ static int iscsi_target_check_first_request(
 	list_for_each_entry(param, &conn->param_list->param_list, p_list) {
 		if (!strncmp(param->name, SESSIONTYPE, 11)) {
 			if (!IS_PSTATE_ACCEPTOR(param)) {
-				target_err("SessionType key not received"
-					   " in first login request.\n");
+				target_err("SessionType key not received in first login request.\n");
 				iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 					ISCSI_LOGIN_STATUS_MISSING_FIELDS);
 				return -1;
@@ -276,8 +266,7 @@ static int iscsi_target_check_first_request(
 				if (!login->leading_connection)
 					continue;
 
-				target_err("InitiatorName key not received"
-					   " in first login request.\n");
+				target_err("InitiatorName key not received in first login request.\n");
 				iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 					ISCSI_LOGIN_STATUS_MISSING_FIELDS);
 				return -1;
@@ -291,8 +280,7 @@ static int iscsi_target_check_first_request(
 			if (!login->leading_connection) {
 				se_nacl = conn->sess->se_sess->se_node_acl;
 				if (!se_nacl) {
-					target_err("Unable to locate"
-						   " struct se_node_acl\n");
+					target_err("Unable to locate struct se_node_acl\n");
 					iscsit_tx_login_rsp(conn,
 							ISCSI_STATUS_CLS_INITIATOR_ERR,
 							ISCSI_LOGIN_STATUS_TGT_NOT_FOUND);
@@ -301,9 +289,7 @@ static int iscsi_target_check_first_request(
 
 				if (strcmp(param->value,
 						se_nacl->initiatorname)) {
-					target_err("Incorrect"
-						   " InitiatorName: %s for this"
-						   " iSCSI Initiator Node.\n",
+					target_err("Incorrect InitiatorName: %s for this iSCSI Initiator Node.\n",
 						   param->value);
 					iscsit_tx_login_rsp(conn,
 							ISCSI_STATUS_CLS_INITIATOR_ERR,
@@ -333,9 +319,7 @@ static int iscsi_target_do_tx_login_io(struct iscsit_conn *conn, struct iscsi_lo
 	login_rsp->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
 	login_rsp->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
-	target_debug("Sending Login Response, Flags: 0x%02x, ITT: 0x%08x,"
-		     " ExpCmdSN; 0x%08x, MaxCmdSN: 0x%08x, StatSN: 0x%08x, Length:"
-		     " %u\n",
+	target_debug("Sending Login Response, Flags: 0x%02x, ITT: 0x%08x, ExpCmdSN; 0x%08x, MaxCmdSN: 0x%08x, StatSN: 0x%08x, Length: %u\n",
 		     login_rsp->flags, (__force u32)login_rsp->itt, ntohl(login_rsp->exp_cmdsn),
 		     ntohl(login_rsp->max_cmdsn), ntohl(login_rsp->statsn), login->rsp_length);
 
@@ -416,8 +400,7 @@ static void iscsi_target_sk_data_ready(struct sock *sk)
 
 	rc = schedule_delayed_work(&conn->login_work, 0);
 	if (!rc) {
-		target_debug("iscsi_target_sk_data_ready, schedule_delayed_work"
-			     " got false\n");
+		target_debug("iscsi_target_sk_data_ready, schedule_delayed_work got false\n");
 	}
 	write_unlock_bh(&sk->sk_callback_lock);
 }
@@ -475,8 +458,7 @@ static int iscsi_target_do_login(struct iscsit_conn *, struct iscsi_login *);
 static bool __iscsi_target_sk_check_close(struct sock *sk)
 {
 	if (sk->sk_state == TCP_CLOSE_WAIT || sk->sk_state == TCP_CLOSE) {
-		target_debug("__iscsi_target_sk_check_close: TCP_CLOSE_WAIT|TCP_CLOSE,"
-			     "returning TRUE\n");
+		target_debug("__iscsi_target_sk_check_close: TCP_CLOSE_WAIT|TCP_CLOSE,returning TRUE\n");
 		return true;
 	}
 	return false;
@@ -682,8 +664,7 @@ static void iscsi_target_sk_state_change(struct sock *sk)
 
 	if (test_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags) ||
 	    test_bit(LOGIN_FLAGS_WRITE_ACTIVE, &conn->login_flags)) {
-		target_debug("Got LOGIN_FLAGS_{READ|WRITE}_ACTIVE=1"
-			     " sk_state_change conn: %p\n",
+		target_debug("Got LOGIN_FLAGS_{READ|WRITE}_ACTIVE=1 sk_state_change conn: %p\n",
 			     conn);
 		if (state)
 			set_bit(LOGIN_FLAGS_CLOSED, &conn->login_flags);
@@ -777,12 +758,10 @@ static int iscsi_target_do_authentication(
 			param->value);
 	switch (authret) {
 	case 0:
-		target_debug("Received OK response"
-			     " from LIO Authentication, continuing.\n");
+		target_debug("Received OK response from LIO Authentication, continuing.\n");
 		break;
 	case 1:
-		target_debug("iSCSI security negotiation"
-			     " completed successfully.\n");
+		target_debug("iSCSI security negotiation completed successfully.\n");
 		login->auth_complete = 1;
 		if ((login_req->flags & ISCSI_FLAG_LOGIN_NEXT_STAGE1) &&
 		    (login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT)) {
@@ -793,15 +772,12 @@ static int iscsi_target_do_authentication(
 		return iscsi_target_check_for_existing_instances(
 				conn, login);
 	case 2:
-		target_err("Security negotiation"
-			   " failed.\n");
+		target_err("Security negotiation failed.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_AUTH_FAILED);
 		return -1;
 	default:
-		target_err("Received unknown error %d from LIO"
-			   " Authentication\n",
-			   authret);
+		target_err("Received unknown error %d from LIO Authentication\n", authret);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_TARGET_ERROR);
 		return -1;
@@ -873,9 +849,7 @@ static int iscsi_target_handle_csg_zero(
 
 	if (ret > 0) {
 		if (login->auth_complete) {
-			target_err("Initiator has already been"
-				   " successfully authenticated, but is still"
-				   " sending %s keys.\n",
+			target_err("Initiator has already been successfully authenticated, but is still sending %s keys.\n",
 				   param->value);
 			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 					ISCSI_LOGIN_STATUS_INIT_ERR);
@@ -884,8 +858,7 @@ static int iscsi_target_handle_csg_zero(
 
 		goto do_auth;
 	} else if (!payload_length) {
-		target_err("Initiator sent zero length security payload,"
-			   " login failed\n");
+		target_err("Initiator sent zero length security payload, login failed\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				    ISCSI_LOGIN_STATUS_AUTH_FAILED);
 		return -1;
@@ -910,9 +883,7 @@ static int iscsi_target_handle_csg_zero(
 
 		if (auth_required) {
 			if (!strncmp(param->value, NONE, 4)) {
-				target_err("Initiator sent AuthMethod=None but"
-					   " Target is enforcing iSCSI Authentication,"
-					   " login failed.\n");
+				target_err("Initiator sent AuthMethod=None but Target is enforcing iSCSI Authentication, login failed.\n");
 				iscsit_tx_login_rsp(conn,
 						ISCSI_STATUS_CLS_INITIATOR_ERR,
 						ISCSI_LOGIN_STATUS_AUTH_FAILED);
@@ -996,9 +967,7 @@ static int iscsi_target_handle_csg_one(struct iscsit_conn *conn, struct iscsi_lo
 	}
 
 	if (!iscsi_conn_authenticated(conn, login)) {
-		target_err("Initiator is requesting CSG: 1, has not been"
-			   " successfully authenticated, and the Target is"
-			   " enforcing iSCSI Authentication, login failed.\n");
+		target_err("Initiator is requesting CSG: 1, has not been successfully authenticated, and the Target is enforcing iSCSI Authentication, login failed.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_AUTH_FAILED);
 		return -1;
@@ -1067,8 +1036,7 @@ static int iscsi_target_do_login(struct iscsit_conn *conn, struct iscsi_login *l
 			}
 			break;
 		default:
-			target_err("Illegal CSG: %d received from"
-				   " Initiator, protocol error.\n",
+			target_err("Illegal CSG: %d received from Initiator, protocol error.\n",
 				   ISCSI_LOGIN_CURRENT_STAGE(login_req->flags));
 			break;
 		}
@@ -1160,8 +1128,7 @@ int iscsi_target_locate_portal(
 	 * See 5.3.  Login Phase.
 	 */
 	if (!i_buf) {
-		target_err("InitiatorName key not received"
-			   " in first login request.\n");
+		target_err("InitiatorName key not received in first login request.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 			ISCSI_LOGIN_STATUS_MISSING_FIELDS);
 		ret = -1;
@@ -1178,8 +1145,7 @@ int iscsi_target_locate_portal(
 		if (!login->leading_connection)
 			goto get_target;
 
-		target_err("SessionType key not received"
-			   " in first login request.\n");
+		target_err("SessionType key not received in first login request.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 			ISCSI_LOGIN_STATUS_MISSING_FIELDS);
 		ret = -1;
@@ -1221,9 +1187,7 @@ int iscsi_target_locate_portal(
 
 get_target:
 	if (!t_buf) {
-		target_err("TargetName key not received"
-			   " in first login request while"
-			   " SessionType=Normal.\n");
+		target_err("TargetName key not received in first login request while SessionType=Normal.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 			ISCSI_LOGIN_STATUS_MISSING_FIELDS);
 		ret = -1;
@@ -1235,9 +1199,7 @@ int iscsi_target_locate_portal(
 	 */
 	tiqn = iscsit_get_tiqn_for_login(t_buf);
 	if (!tiqn) {
-		target_err("Unable to locate Target IQN: %s in"
-			   " Storage Node\n",
-			   t_buf);
+		target_err("Unable to locate Target IQN: %s in Storage Node\n", t_buf);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_SVC_UNAVAILABLE);
 		ret = -1;
@@ -1250,9 +1212,7 @@ int iscsi_target_locate_portal(
 	 */
 	conn->tpg = iscsit_get_tpg_from_np(tiqn, np, &tpg_np);
 	if (!conn->tpg) {
-		target_err("Unable to locate Target Portal Group"
-			   " on %s\n",
-			   tiqn->tiqn);
+		target_err("Unable to locate Target Portal Group on %s\n", tiqn->tiqn);
 		iscsit_put_tiqn_for_login(tiqn);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_SVC_UNAVAILABLE);
@@ -1307,8 +1267,7 @@ int iscsi_target_locate_portal(
 	sess->se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
 			&conn->tpg->tpg_se_tpg, i_buf);
 	if (!sess->se_sess->se_node_acl) {
-		target_err("iSCSI Initiator Node: %s is not authorized to"
-			   " access iSCSI target portal group: %hu.\n",
+		target_err("iSCSI Initiator Node: %s is not authorized to access iSCSI target portal group: %hu.\n",
 			   i_buf, conn->tpg->tpgt);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_TGT_FORBIDDEN);
diff --git a/drivers/target/iscsi/iscsi_target_nodeattrib.c b/drivers/target/iscsi/iscsi_target_nodeattrib.c
index 5b1269fe9184..7a2a92d7d7bb 100644
--- a/drivers/target/iscsi/iscsi_target_nodeattrib.c
+++ b/drivers/target/iscsi/iscsi_target_nodeattrib.c
@@ -48,21 +48,18 @@ int iscsit_na_dataout_timeout(
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
 	if (dataout_timeout > NA_DATAOUT_TIMEOUT_MAX) {
-		target_err("Requested DataOut Timeout %u larger than"
-			   " maximum %u\n",
-			   dataout_timeout, NA_DATAOUT_TIMEOUT_MAX);
+		target_err("Requested DataOut Timeout %u larger than maximum %u\n", dataout_timeout,
+			   NA_DATAOUT_TIMEOUT_MAX);
 		return -EINVAL;
 	} else if (dataout_timeout < NA_DATAOUT_TIMEOUT_MIX) {
-		target_err("Requested DataOut Timeout %u smaller than"
-			   " minimum %u\n",
+		target_err("Requested DataOut Timeout %u smaller than minimum %u\n",
 			   dataout_timeout, NA_DATAOUT_TIMEOUT_MIX);
 		return -EINVAL;
 	}
 
 	a->dataout_timeout = dataout_timeout;
-	target_debug("Set DataOut Timeout to %u for Initiator Node"
-		     " %s\n",
-		     a->dataout_timeout, iscsit_na_get_initiatorname(acl));
+	target_debug("Set DataOut Timeout to %u for Initiator Node %s\n", a->dataout_timeout,
+		     iscsit_na_get_initiatorname(acl));
 
 	return 0;
 }
@@ -74,20 +71,17 @@ int iscsit_na_dataout_timeout_retries(
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
 	if (dataout_timeout_retries > NA_DATAOUT_TIMEOUT_RETRIES_MAX) {
-		target_err("Requested DataOut Timeout Retries %u larger"
-			   " than maximum %u",
+		target_err("Requested DataOut Timeout Retries %u larger than maximum %u",
 			   dataout_timeout_retries, NA_DATAOUT_TIMEOUT_RETRIES_MAX);
 		return -EINVAL;
 	} else if (dataout_timeout_retries < NA_DATAOUT_TIMEOUT_RETRIES_MIN) {
-		target_err("Requested DataOut Timeout Retries %u smaller"
-			   " than minimum %u",
+		target_err("Requested DataOut Timeout Retries %u smaller than minimum %u",
 			   dataout_timeout_retries, NA_DATAOUT_TIMEOUT_RETRIES_MIN);
 		return -EINVAL;
 	}
 
 	a->dataout_timeout_retries = dataout_timeout_retries;
-	target_debug("Set DataOut Timeout Retries to %u for"
-		     " Initiator Node %s\n",
+	target_debug("Set DataOut Timeout Retries to %u for Initiator Node %s\n",
 		     a->dataout_timeout_retries, iscsit_na_get_initiatorname(acl));
 
 	return 0;
@@ -105,22 +99,19 @@ int iscsit_na_nopin_timeout(
 	u32 orig_nopin_timeout = a->nopin_timeout;
 
 	if (nopin_timeout > NA_NOPIN_TIMEOUT_MAX) {
-		target_err("Requested NopIn Timeout %u larger than maximum"
-			   " %u\n",
-			   nopin_timeout, NA_NOPIN_TIMEOUT_MAX);
+		target_err("Requested NopIn Timeout %u larger than maximum %u\n", nopin_timeout,
+			   NA_NOPIN_TIMEOUT_MAX);
 		return -EINVAL;
 	} else if ((nopin_timeout < NA_NOPIN_TIMEOUT_MIN) &&
 		   (nopin_timeout != 0)) {
-		target_err("Requested NopIn Timeout %u smaller than"
-			   " minimum %u and not 0\n",
+		target_err("Requested NopIn Timeout %u smaller than minimum %u and not 0\n",
 			   nopin_timeout, NA_NOPIN_TIMEOUT_MIN);
 		return -EINVAL;
 	}
 
 	a->nopin_timeout = nopin_timeout;
-	target_debug("Set NopIn Timeout to %u for Initiator"
-		     " Node %s\n",
-		     a->nopin_timeout, iscsit_na_get_initiatorname(acl));
+	target_debug("Set NopIn Timeout to %u for Initiator Node %s\n", a->nopin_timeout,
+		     iscsit_na_get_initiatorname(acl));
 	/*
 	 * Reenable disabled nopin_timeout timer for all iSCSI connections.
 	 */
@@ -156,21 +147,18 @@ int iscsit_na_nopin_response_timeout(
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
 	if (nopin_response_timeout > NA_NOPIN_RESPONSE_TIMEOUT_MAX) {
-		target_err("Requested NopIn Response Timeout %u larger"
-			   " than maximum %u\n",
+		target_err("Requested NopIn Response Timeout %u larger than maximum %u\n",
 			   nopin_response_timeout, NA_NOPIN_RESPONSE_TIMEOUT_MAX);
 		return -EINVAL;
 	} else if (nopin_response_timeout < NA_NOPIN_RESPONSE_TIMEOUT_MIN) {
-		target_err("Requested NopIn Response Timeout %u smaller"
-			   " than minimum %u\n",
+		target_err("Requested NopIn Response Timeout %u smaller than minimum %u\n",
 			   nopin_response_timeout, NA_NOPIN_RESPONSE_TIMEOUT_MIN);
 		return -EINVAL;
 	}
 
 	a->nopin_response_timeout = nopin_response_timeout;
-	target_debug("Set NopIn Response Timeout to %u for"
-		     " Initiator Node %s\n",
-		     a->nopin_timeout, iscsit_na_get_initiatorname(acl));
+	target_debug("Set NopIn Response Timeout to %u for Initiator Node %s\n", a->nopin_timeout,
+		     iscsit_na_get_initiatorname(acl));
 
 	return 0;
 }
@@ -182,15 +170,13 @@ int iscsit_na_random_datain_pdu_offsets(
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
 	if (random_datain_pdu_offsets != 0 && random_datain_pdu_offsets != 1) {
-		target_err("Requested Random DataIN PDU Offsets: %u not"
-			   " 0 or 1\n",
+		target_err("Requested Random DataIN PDU Offsets: %u not 0 or 1\n",
 			   random_datain_pdu_offsets);
 		return -EINVAL;
 	}
 
 	a->random_datain_pdu_offsets = random_datain_pdu_offsets;
-	target_debug("Set Random DataIN PDU Offsets to %u for"
-		     " Initiator Node %s\n",
+	target_debug("Set Random DataIN PDU Offsets to %u for Initiator Node %s\n",
 		     a->random_datain_pdu_offsets, iscsit_na_get_initiatorname(acl));
 
 	return 0;
@@ -203,15 +189,13 @@ int iscsit_na_random_datain_seq_offsets(
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
 	if (random_datain_seq_offsets != 0 && random_datain_seq_offsets != 1) {
-		target_err("Requested Random DataIN Sequence Offsets: %u"
-			   " not 0 or 1\n",
+		target_err("Requested Random DataIN Sequence Offsets: %u not 0 or 1\n",
 			   random_datain_seq_offsets);
 		return -EINVAL;
 	}
 
 	a->random_datain_seq_offsets = random_datain_seq_offsets;
-	target_debug("Set Random DataIN Sequence Offsets to %u for"
-		     " Initiator Node %s\n",
+	target_debug("Set Random DataIN Sequence Offsets to %u for Initiator Node %s\n",
 		     a->random_datain_seq_offsets, iscsit_na_get_initiatorname(acl));
 
 	return 0;
@@ -224,16 +208,13 @@ int iscsit_na_random_r2t_offsets(
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
 	if (random_r2t_offsets != 0 && random_r2t_offsets != 1) {
-		target_err("Requested Random R2T Offsets: %u not"
-			   " 0 or 1\n",
-			   random_r2t_offsets);
+		target_err("Requested Random R2T Offsets: %u not 0 or 1\n", random_r2t_offsets);
 		return -EINVAL;
 	}
 
 	a->random_r2t_offsets = random_r2t_offsets;
-	target_debug("Set Random R2T Offsets to %u for"
-		     " Initiator Node %s\n",
-		     a->random_r2t_offsets, iscsit_na_get_initiatorname(acl));
+	target_debug("Set Random R2T Offsets to %u for Initiator Node %s\n", a->random_r2t_offsets,
+		     iscsit_na_get_initiatorname(acl));
 
 	return 0;
 }
@@ -250,9 +231,8 @@ int iscsit_na_default_erl(
 	}
 
 	a->default_erl = default_erl;
-	target_debug("Set use ERL0 flag to %u for Initiator"
-		     " Node %s\n",
-		     a->default_erl, iscsit_na_get_initiatorname(acl));
+	target_debug("Set use ERL0 flag to %u for Initiator Node %s\n", a->default_erl,
+		     iscsit_na_get_initiatorname(acl));
 
 	return 0;
 }
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index a195b45cb28a..4b8429c53904 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -183,8 +183,7 @@ int iscsi_create_default_params(struct iscsi_param_list **param_list_ptr)
 
 	pl = kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);
 	if (!pl) {
-		target_err("Unable to allocate memory for"
-			   " struct iscsi_param_list.\n");
+		target_err("Unable to allocate memory for struct iscsi_param_list.\n");
 		return -ENOMEM;
 	}
 	INIT_LIST_HEAD(&pl->param_list);
@@ -663,8 +662,7 @@ int iscsi_extract_key_value(char *textbuf, char **key, char **value)
 {
 	*value = strchr(textbuf, '=');
 	if (!*value) {
-		target_err("Unable to locate \"=\" separator for key,"
-			   " ignoring request.\n");
+		target_err("Unable to locate \"=\" separator for key, ignoring request.\n");
 		return -1;
 	}
 
@@ -697,16 +695,14 @@ static int iscsi_add_notunderstood_response(
 	struct iscsi_extra_response *extra_response;
 
 	if (strlen(value) > VALUE_MAXLEN) {
-		target_err("Value for notunderstood key \"%s\" exceeds %d,"
-			   " protocol error.\n",
-			   key, VALUE_MAXLEN);
+		target_err("Value for notunderstood key \"%s\" exceeds %d, protocol error.\n", key,
+			   VALUE_MAXLEN);
 		return -1;
 	}
 
 	extra_response = kzalloc(sizeof(struct iscsi_extra_response), GFP_KERNEL);
 	if (!extra_response) {
-		target_err("Unable to allocate memory for"
-			   " struct iscsi_extra_response.\n");
+		target_err("Unable to allocate memory for struct iscsi_extra_response.\n");
 		return -ENOMEM;
 	}
 	INIT_LIST_HEAD(&extra_response->er_list);
@@ -783,8 +779,7 @@ static void iscsi_check_proposer_for_optional_reply(struct iscsi_param *param,
 static int iscsi_check_boolean_value(struct iscsi_param *param, char *value)
 {
 	if (strcmp(value, YES) && strcmp(value, NO)) {
-		target_err("Illegal value for \"%s\", must be either"
-			   " \"%s\" or \"%s\".\n",
+		target_err("Illegal value for \"%s\", must be either \"%s\" or \"%s\".\n",
 			   param->name, YES, NO);
 		return -1;
 	}
@@ -801,8 +796,7 @@ static int iscsi_check_numerical_value(struct iscsi_param *param, char *value_pt
 
 	if (IS_TYPERANGE_0_TO_2(param)) {
 		if ((value < 0) || (value > 2)) {
-			target_err("Illegal value for \"%s\", must be"
-				   " between 0 and 2.\n",
+			target_err("Illegal value for \"%s\", must be between 0 and 2.\n",
 				   param->name);
 			return -1;
 		}
@@ -810,8 +804,7 @@ static int iscsi_check_numerical_value(struct iscsi_param *param, char *value_pt
 	}
 	if (IS_TYPERANGE_0_TO_3600(param)) {
 		if ((value < 0) || (value > 3600)) {
-			target_err("Illegal value for \"%s\", must be"
-				   " between 0 and 3600.\n",
+			target_err("Illegal value for \"%s\", must be between 0 and 3600.\n",
 				   param->name);
 			return -1;
 		}
@@ -819,8 +812,7 @@ static int iscsi_check_numerical_value(struct iscsi_param *param, char *value_pt
 	}
 	if (IS_TYPERANGE_0_TO_32767(param)) {
 		if ((value < 0) || (value > 32767)) {
-			target_err("Illegal value for \"%s\", must be"
-				   " between 0 and 32767.\n",
+			target_err("Illegal value for \"%s\", must be between 0 and 32767.\n",
 				   param->name);
 			return -1;
 		}
@@ -828,8 +820,7 @@ static int iscsi_check_numerical_value(struct iscsi_param *param, char *value_pt
 	}
 	if (IS_TYPERANGE_0_TO_65535(param)) {
 		if ((value < 0) || (value > 65535)) {
-			target_err("Illegal value for \"%s\", must be"
-				   " between 0 and 65535.\n",
+			target_err("Illegal value for \"%s\", must be between 0 and 65535.\n",
 				   param->name);
 			return -1;
 		}
@@ -837,8 +828,7 @@ static int iscsi_check_numerical_value(struct iscsi_param *param, char *value_pt
 	}
 	if (IS_TYPERANGE_1_TO_65535(param)) {
 		if ((value < 1) || (value > 65535)) {
-			target_err("Illegal value for \"%s\", must be"
-				   " between 1 and 65535.\n",
+			target_err("Illegal value for \"%s\", must be between 1 and 65535.\n",
 				   param->name);
 			return -1;
 		}
@@ -846,8 +836,7 @@ static int iscsi_check_numerical_value(struct iscsi_param *param, char *value_pt
 	}
 	if (IS_TYPERANGE_2_TO_3600(param)) {
 		if ((value < 2) || (value > 3600)) {
-			target_err("Illegal value for \"%s\", must be"
-				   " between 2 and 3600.\n",
+			target_err("Illegal value for \"%s\", must be between 2 and 3600.\n",
 				   param->name);
 			return -1;
 		}
@@ -855,8 +844,7 @@ static int iscsi_check_numerical_value(struct iscsi_param *param, char *value_pt
 	}
 	if (IS_TYPERANGE_512_TO_16777215(param)) {
 		if ((value < 512) || (value > 16777215)) {
-			target_err("Illegal value for \"%s\", must be"
-				   " between 512 and 16777215.\n",
+			target_err("Illegal value for \"%s\", must be between 512 and 16777215.\n",
 				   param->name);
 			return -1;
 		}
@@ -875,25 +863,21 @@ static int iscsi_check_string_or_list_value(struct iscsi_param *param, char *val
 		if (strcmp(value, KRB5) && strcmp(value, SPKM1) &&
 		    strcmp(value, SPKM2) && strcmp(value, SRP) &&
 		    strcmp(value, CHAP) && strcmp(value, NONE)) {
-			target_err("Illegal value for \"%s\", must be"
-				   " \"%s\", \"%s\", \"%s\", \"%s\", \"%s\""
-				   " or \"%s\".\n",
+			target_err("Illegal value for \"%s\", must be \"%s\", \"%s\", \"%s\", \"%s\", \"%s\" or \"%s\".\n",
 				   param->name, KRB5, SPKM1, SPKM2, SRP, CHAP, NONE);
 			return -1;
 		}
 	}
 	if (IS_TYPERANGE_DIGEST_PARAM(param)) {
 		if (strcmp(value, CRC32C) && strcmp(value, NONE)) {
-			target_err("Illegal value for \"%s\", must be"
-				   " \"%s\" or \"%s\".\n",
+			target_err("Illegal value for \"%s\", must be \"%s\" or \"%s\".\n",
 				   param->name, CRC32C, NONE);
 			return -1;
 		}
 	}
 	if (IS_TYPERANGE_SESSIONTYPE(param)) {
 		if (strcmp(value, DISCOVERY) && strcmp(value, NORMAL)) {
-			target_err("Illegal value for \"%s\", must be"
-				   " \"%s\" or \"%s\".\n",
+			target_err("Illegal value for \"%s\", must be \"%s\" or \"%s\".\n",
 				   param->name, DISCOVERY, NORMAL);
 			return -1;
 		}
@@ -1032,8 +1016,7 @@ static int iscsi_check_acceptor_state(struct iscsi_param *param, char *value,
 				return -1;
 
 			conn->conn_ops->MaxRecvDataSegmentLength = tmp;
-			target_debug("Saving op->MaxRecvDataSegmentLength from"
-				     " original initiator received value: %u\n",
+			target_debug("Saving op->MaxRecvDataSegmentLength from original initiator received value: %u\n",
 				     conn->conn_ops->MaxRecvDataSegmentLength);
 
 			param_mxdsl = iscsi_find_param_from_key(
@@ -1054,9 +1037,7 @@ static int iscsi_check_acceptor_state(struct iscsi_param *param, char *value,
 		negotiated_value = iscsi_check_valuelist_for_support(
 					param, value);
 		if (!negotiated_value) {
-			target_err("Proposer's value list \"%s\" contains"
-				   " no valid values from Acceptor's value list"
-				   " \"%s\".\n",
+			target_err("Proposer's value list \"%s\" contains no valid values from Acceptor's value list \"%s\".\n",
 				   value, param->value);
 			return -1;
 		}
@@ -1127,8 +1108,7 @@ static int iscsi_check_value(struct iscsi_param *param, char *value)
 		}
 
 /* #warning FIXME: Add check for X-ExtensionKey here */
-		target_err("Standard iSCSI key \"%s\" cannot be answered"
-			   " with \"%s\", protocol error.\n",
+		target_err("Standard iSCSI key \"%s\" cannot be answered with \"%s\", protocol error.\n",
 			   param->name, value);
 		return -1;
 	}
@@ -1138,9 +1118,7 @@ static int iscsi_check_value(struct iscsi_param *param, char *value)
 		comma_ptr = strchr(value, ',');
 
 		if (comma_ptr && !IS_TYPE_VALUE_LIST(param)) {
-			target_err("Detected value separator \",\", but"
-				   " key \"%s\" does not allow a value list,"
-				   " protocol error.\n",
+			target_err("Detected value separator \",\", but key \"%s\" does not allow a value list, protocol error.\n",
 				   param->name);
 			return -1;
 		}
@@ -1148,8 +1126,7 @@ static int iscsi_check_value(struct iscsi_param *param, char *value)
 			*comma_ptr = '\0';
 
 		if (strlen(value) > VALUE_MAXLEN) {
-			target_err("Value for key \"%s\" exceeds %d,"
-				   " protocol error.\n",
+			target_err("Value for key \"%s\" exceeds %d, protocol error.\n",
 				   param->name, VALUE_MAXLEN);
 			return -1;
 		}
@@ -1194,16 +1171,14 @@ static struct iscsi_param *__iscsi_check_key(
 		return NULL;
 
 	if ((sender & SENDER_INITIATOR) && !IS_SENDER_INITIATOR(param)) {
-		target_err("Key \"%s\" may not be sent to %s,"
-			   " protocol error.\n",
-			   param->name, (sender & SENDER_RECEIVER) ? "target" : "initiator");
+		target_err("Key \"%s\" may not be sent to %s, protocol error.\n", param->name,
+			   (sender & SENDER_RECEIVER) ? "target" : "initiator");
 		return NULL;
 	}
 
 	if ((sender & SENDER_TARGET) && !IS_SENDER_TARGET(param)) {
-		target_err("Key \"%s\" may not be sent to %s,"
-			   " protocol error.\n",
-			   param->name, (sender & SENDER_RECEIVER) ? "initiator" : "target");
+		target_err("Key \"%s\" may not be sent to %s, protocol error.\n", param->name,
+			   (sender & SENDER_RECEIVER) ? "initiator" : "target");
 		return NULL;
 	}
 
@@ -1230,15 +1205,13 @@ static struct iscsi_param *iscsi_check_key(
 		return NULL;
 
 	if ((sender & SENDER_INITIATOR) && !IS_SENDER_INITIATOR(param)) {
-		target_err("Key \"%s\" may not be sent to %s,"
-			   " protocol error.\n",
-			   param->name, (sender & SENDER_RECEIVER) ? "target" : "initiator");
+		target_err("Key \"%s\" may not be sent to %s, protocol error.\n", param->name,
+			   (sender & SENDER_RECEIVER) ? "target" : "initiator");
 		return NULL;
 	}
 	if ((sender & SENDER_TARGET) && !IS_SENDER_TARGET(param)) {
-		target_err("Key \"%s\" may not be sent to %s,"
-			   " protocol error.\n",
-			   param->name, (sender & SENDER_RECEIVER) ? "initiator" : "target");
+		target_err("Key \"%s\" may not be sent to %s, protocol error.\n", param->name,
+			   (sender & SENDER_RECEIVER) ? "initiator" : "target");
 		return NULL;
 	}
 
@@ -1527,8 +1500,7 @@ void iscsi_set_connection_parameters(
 	char *tmpptr;
 	struct iscsi_param *param;
 
-	target_debug("---------------------------------------------------"
-		     "---------------\n");
+	target_debug("------------------------------------------------------------------\n");
 	list_for_each_entry(param, &param_list->param_list, p_list) {
 		/*
 		 * Special case to set MAXXMITDATASEGMENTLENGTH from the
@@ -1575,8 +1547,7 @@ void iscsi_set_connection_parameters(
 			target_debug("Set MXDSL from TargetRecvDataSegmentLength\n");
 		}
 	}
-	target_debug("----------------------------------------------------"
-		     "--------------\n");
+	target_debug("------------------------------------------------------------------\n");
 }
 
 void iscsi_set_session_parameters(
@@ -1587,8 +1558,7 @@ void iscsi_set_session_parameters(
 	char *tmpptr;
 	struct iscsi_param *param;
 
-	target_debug("----------------------------------------------------"
-		     "--------------\n");
+	target_debug("------------------------------------------------------------------\n");
 	list_for_each_entry(param, &param_list->param_list, p_list) {
 		if (!IS_PSTATE_ACCEPTOR(param) && !IS_PSTATE_PROPOSER(param))
 			continue;
@@ -1673,6 +1643,5 @@ void iscsi_set_session_parameters(
 			target_debug("RDMAExtensions:               %s\n", param->value);
 		}
 	}
-	target_debug("----------------------------------------------------"
-		     "--------------\n");
+	target_debug("------------------------------------------------------------------\n");
 }
diff --git a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
index a563b780d8e5..e60d69199504 100644
--- a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
+++ b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
@@ -27,9 +27,7 @@ static void iscsit_dump_seq_list(struct iscsit_cmd *cmd)
 
 	for (i = 0; i < cmd->seq_count; i++) {
 		seq = &cmd->seq_list[i];
-		target_debug("i: %d, pdu_start: %d, pdu_count: %d,"
-			     " offset: %d, xfer_len: %d, seq_send_order: %d,"
-			     " seq_no: %d\n",
+		target_debug("i: %d, pdu_start: %d, pdu_count: %d, offset: %d, xfer_len: %d, seq_send_order: %d, seq_no: %d\n",
 			     i, seq->pdu_start, seq->pdu_count, seq->offset, seq->xfer_len,
 			     seq->seq_send_order, seq->seq_no);
 	}
@@ -44,9 +42,8 @@ static void iscsit_dump_pdu_list(struct iscsit_cmd *cmd)
 
 	for (i = 0; i < cmd->pdu_count; i++) {
 		pdu = &cmd->pdu_list[i];
-		target_debug("i: %d, offset: %d, length: %d,"
-			     " pdu_send_order: %d, seq_no: %d\n",
-			     i, pdu->offset, pdu->length, pdu->pdu_send_order, pdu->seq_no);
+		target_debug("i: %d, offset: %d, length: %d, pdu_send_order: %d, seq_no: %d\n", i,
+			     pdu->offset, pdu->length, pdu->pdu_send_order, pdu->seq_no);
 	}
 }
 #else
@@ -129,8 +126,7 @@ static int iscsit_randomize_pdu_lists(
 		}
 		array = kcalloc(seq_count, sizeof(u32), GFP_KERNEL);
 		if (!array) {
-			target_err("Unable to allocate memory"
-				   " for random array.\n");
+			target_err("Unable to allocate memory for random array.\n");
 			return -ENOMEM;
 		}
 		iscsit_create_random_array(array, seq_count);
@@ -149,8 +145,7 @@ static int iscsit_randomize_pdu_lists(
 	if (seq_count) {
 		array = kcalloc(seq_count, sizeof(u32), GFP_KERNEL);
 		if (!array) {
-			target_err("Unable to allocate memory for"
-				   " random array.\n");
+			target_err("Unable to allocate memory for random array.\n");
 			return -ENOMEM;
 		}
 		iscsit_create_random_array(array, seq_count);
@@ -575,8 +570,7 @@ struct iscsi_pdu *iscsit_get_pdu_holder(
 		if ((pdu[i].offset == offset) && (pdu[i].length == length))
 			return &pdu[i];
 
-	target_err("Unable to locate PDU holder for ITT: 0x%08x, Offset:"
-		   " %u, Length: %u\n",
+	target_err("Unable to locate PDU holder for ITT: 0x%08x, Offset: %u, Length: %u\n",
 		   cmd->init_task_tag, offset, length);
 	return NULL;
 }
@@ -599,9 +593,7 @@ struct iscsi_pdu *iscsit_get_pdu_holder_for_seq(
 		pdu = &cmd->pdu_list[cmd->pdu_start];
 
 		for (i = 0; pdu[i].seq_no != cmd->seq_no; i++) {
-			target_debug("pdu[i].seq_no: %d, pdu[i].pdu"
-				     "_send_order: %d, pdu[i].offset: %d,"
-				     " pdu[i].length: %d\n",
+			target_debug("pdu[i].seq_no: %d, pdu[i].pdu_send_order: %d, pdu[i].offset: %d, pdu[i].length: %d\n",
 				     pdu[i].seq_no, pdu[i].pdu_send_order, pdu[i].offset,
 				     pdu[i].length);
 
@@ -618,8 +610,7 @@ struct iscsi_pdu *iscsit_get_pdu_holder_for_seq(
 		if (cmd->pdu_start < cmd->pdu_count)
 			goto redo;
 
-		target_err("Command ITT: 0x%08x unable to locate"
-			   " struct iscsi_pdu for cmd->pdu_send_order: %u.\n",
+		target_err("Command ITT: 0x%08x unable to locate struct iscsi_pdu for cmd->pdu_send_order: %u.\n",
 			   cmd->init_task_tag, cmd->pdu_send_order);
 		return NULL;
 	} else {
@@ -628,15 +619,13 @@ struct iscsi_pdu *iscsit_get_pdu_holder_for_seq(
 			return NULL;
 		}
 
-		target_debug("seq->pdu_start: %d, seq->pdu_count: %d,"
-			     " seq->seq_no: %d\n",
+		target_debug("seq->pdu_start: %d, seq->pdu_count: %d, seq->seq_no: %d\n",
 			     seq->pdu_start, seq->pdu_count, seq->seq_no);
 
 		pdu = &cmd->pdu_list[seq->pdu_start];
 
 		if (seq->pdu_send_order == seq->pdu_count) {
-			target_err("Command ITT: 0x%08x seq->pdu_send"
-				   "_order: %u equals seq->pdu_count: %u\n",
+			target_err("Command ITT: 0x%08x seq->pdu_send_order: %u equals seq->pdu_count: %u\n",
 				   cmd->init_task_tag, seq->pdu_send_order, seq->pdu_count);
 			return NULL;
 		}
@@ -648,8 +637,7 @@ struct iscsi_pdu *iscsit_get_pdu_holder_for_seq(
 			}
 		}
 
-		target_err("Command ITT: 0x%08x unable to locate iscsi"
-			   "_pdu_t for seq->pdu_send_order: %u.\n",
+		target_err("Command ITT: 0x%08x unable to locate iscsi_pdu_t for seq->pdu_send_order: %u.\n",
 			   cmd->init_task_tag, seq->pdu_send_order);
 		return NULL;
 	}
@@ -670,8 +658,7 @@ struct iscsi_seq *iscsit_get_seq_holder(
 	}
 
 	for (i = 0; i < cmd->seq_count; i++) {
-		target_debug("seq_list[i].orig_offset: %d, seq_list[i]."
-			     "xfer_len: %d, seq_list[i].seq_no %u\n",
+		target_debug("seq_list[i].orig_offset: %d, seq_list[i].xfer_len: %d, seq_list[i].seq_no %u\n",
 			     cmd->seq_list[i].orig_offset, cmd->seq_list[i].xfer_len,
 			     cmd->seq_list[i].seq_no);
 
@@ -681,8 +668,7 @@ struct iscsi_seq *iscsit_get_seq_holder(
 			return &cmd->seq_list[i];
 	}
 
-	target_err("Unable to locate Sequence holder for ITT: 0x%08x,"
-		   " Offset: %u, Length: %u\n",
+	target_err("Unable to locate Sequence holder for ITT: 0x%08x, Offset: %u, Length: %u\n",
 		   cmd->init_task_tag, offset, length);
 	return NULL;
 }
diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index f40987cc5793..c9f55f3cf7e3 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -39,16 +39,14 @@ u8 iscsit_tmr_abort_task(
 
 	ref_cmd = iscsit_find_cmd_from_itt(conn, hdr->rtt);
 	if (!ref_cmd) {
-		target_err("Unable to locate RefTaskTag: 0x%08x on CID:"
-			   " %hu.\n",
-			   hdr->rtt, conn->cid);
+		target_err("Unable to locate RefTaskTag: 0x%08x on CID: %hu.\n", hdr->rtt,
+			   conn->cid);
 		return (iscsi_sna_gte(be32_to_cpu(hdr->refcmdsn), conn->sess->exp_cmd_sn) &&
 			iscsi_sna_lte(be32_to_cpu(hdr->refcmdsn), (u32) atomic_read(&conn->sess->max_cmd_sn))) ?
 			ISCSI_TMF_RSP_COMPLETE : ISCSI_TMF_RSP_NO_TASK;
 	}
 	if (ref_cmd->cmd_sn != be32_to_cpu(hdr->refcmdsn)) {
-		target_err("RefCmdSN 0x%08x does not equal"
-			   " task's CmdSN 0x%08x. Rejecting ABORT_TASK.\n",
+		target_err("RefCmdSN 0x%08x does not equal task's CmdSN 0x%08x. Rejecting ABORT_TASK.\n",
 			   hdr->refcmdsn, ref_cmd->cmd_sn);
 		return ISCSI_TMF_RSP_REJECTED;
 	}
@@ -72,8 +70,7 @@ int iscsit_tmr_task_warm_reset(
 	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
 
 	if (!na->tmr_warm_reset) {
-		target_err("TMR Opcode TARGET_WARM_RESET authorization"
-			   " failed for Initiator Node: %s\n",
+		target_err("TMR Opcode TARGET_WARM_RESET authorization failed for Initiator Node: %s\n",
 			   sess->se_sess->se_node_acl->initiatorname);
 		return -1;
 	}
@@ -92,8 +89,7 @@ int iscsit_tmr_task_cold_reset(
 	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
 
 	if (!na->tmr_cold_reset) {
-		target_err("TMR Opcode TARGET_COLD_RESET authorization"
-			   " failed for Initiator Node: %s\n",
+		target_err("TMR Opcode TARGET_COLD_RESET authorization failed for Initiator Node: %s\n",
 			   sess->se_sess->se_node_acl->initiatorname);
 		return -1;
 	}
@@ -115,25 +111,21 @@ u8 iscsit_tmr_task_reassign(
 	struct iscsi_tm *hdr = (struct iscsi_tm *) buf;
 	u64 ret, ref_lun;
 
-	target_debug("Got TASK_REASSIGN TMR ITT: 0x%08x,"
-		     " RefTaskTag: 0x%08x, ExpDataSN: 0x%08x, CID: %hu\n",
+	target_debug("Got TASK_REASSIGN TMR ITT: 0x%08x, RefTaskTag: 0x%08x, ExpDataSN: 0x%08x, CID: %hu\n",
 		     hdr->itt, hdr->rtt, hdr->exp_datasn, conn->cid);
 
 	if (conn->sess->sess_ops->ErrorRecoveryLevel != 2) {
-		target_err("TMR TASK_REASSIGN not supported in ERL<2,"
-			   " ignoring request.\n");
+		target_err("TMR TASK_REASSIGN not supported in ERL<2, ignoring request.\n");
 		return ISCSI_TMF_RSP_NOT_SUPPORTED;
 	}
 
 	ret = iscsit_find_cmd_for_recovery(conn->sess, &ref_cmd, &cr, hdr->rtt);
 	if (ret == -2) {
-		target_err("Command ITT: 0x%08x is still alligent to CID:"
-			   " %hu\n",
+		target_err("Command ITT: 0x%08x is still alligent to CID: %hu\n",
 			   ref_cmd->init_task_tag, cr->cid);
 		return ISCSI_TMF_RSP_TASK_ALLEGIANT;
 	} else if (ret == -1) {
-		target_err("Unable to locate RefTaskTag: 0x%08x in"
-			   " connection recovery command list.\n",
+		target_err("Unable to locate RefTaskTag: 0x%08x in connection recovery command list.\n",
 			   hdr->rtt);
 		return ISCSI_TMF_RSP_NO_TASK;
 	}
@@ -143,23 +135,18 @@ u8 iscsit_tmr_task_reassign(
 	 */
 	if (cr->maxrecvdatasegmentlength !=
 	    conn->conn_ops->MaxRecvDataSegmentLength) {
-		target_err("Unable to perform connection recovery for"
-			   " differing MaxRecvDataSegmentLength, rejecting"
-			   " TMR TASK_REASSIGN.\n");
+		target_err("Unable to perform connection recovery for differing MaxRecvDataSegmentLength, rejecting TMR TASK_REASSIGN.\n");
 		return ISCSI_TMF_RSP_REJECTED;
 	}
 	if (cr->maxxmitdatasegmentlength !=
 	    conn->conn_ops->MaxXmitDataSegmentLength) {
-		target_err("Unable to perform connection recovery for"
-			   " differing MaxXmitDataSegmentLength, rejecting"
-			   " TMR TASK_REASSIGN.\n");
+		target_err("Unable to perform connection recovery for differing MaxXmitDataSegmentLength, rejecting TMR TASK_REASSIGN.\n");
 		return ISCSI_TMF_RSP_REJECTED;
 	}
 
 	ref_lun = scsilun_to_int(&hdr->lun);
 	if (ref_lun != ref_cmd->se_cmd.orig_fe_lun) {
-		target_err("Unable to perform connection recovery for"
-			   " differing ref_lun: %llu ref_cmd orig_fe_lun: %llu\n",
+		target_err("Unable to perform connection recovery for differing ref_lun: %llu ref_cmd orig_fe_lun: %llu\n",
 			   ref_lun, ref_cmd->se_cmd.orig_fe_lun);
 		return ISCSI_TMF_RSP_REJECTED;
 	}
@@ -188,8 +175,7 @@ static void iscsit_task_reassign_remove_cmd(
 	ret = iscsit_remove_cmd_from_connection_recovery(cmd, sess);
 	spin_unlock(&cr->conn_recovery_cmd_lock);
 	if (!ret) {
-		target_debug("iSCSI connection recovery successful for CID:"
-			     " %hu on SID: %u\n",
+		target_debug("iSCSI connection recovery successful for CID: %hu on SID: %u\n",
 			     cr->cid, sess->sid);
 		iscsit_remove_active_connection_recovery_entry(cr, sess);
 	}
@@ -203,8 +189,7 @@ static int iscsit_task_reassign_complete_nop_out(
 	struct iscsi_conn_recovery *cr;
 
 	if (!cmd->cr) {
-		target_err("struct iscsi_conn_recovery pointer for ITT: 0x%08x"
-			   " is NULL!\n",
+		target_err("struct iscsi_conn_recovery pointer for ITT: 0x%08x is NULL!\n",
 			   cmd->init_task_tag);
 		return -1;
 	}
@@ -255,8 +240,7 @@ static int iscsit_task_reassign_complete_write(
 	 */
 	if (cmd->cmd_flags & ICF_GOT_LAST_DATAOUT) {
 		if (!(cmd->se_cmd.transport_state & CMD_T_SENT)) {
-			target_debug("WRITE ITT: 0x%08x: t_state: %d"
-				     " never sent to transport\n",
+			target_debug("WRITE ITT: 0x%08x: t_state: %d never sent to transport\n",
 				     cmd->init_task_tag, cmd->se_cmd.t_state);
 			target_execute_cmd(se_cmd);
 			return 0;
@@ -320,16 +304,14 @@ static int iscsit_task_reassign_complete_read(
 	}
 
 	if (!(cmd->se_cmd.transport_state & CMD_T_SENT)) {
-		target_debug("READ ITT: 0x%08x: t_state: %d never sent to"
-			     " transport\n",
+		target_debug("READ ITT: 0x%08x: t_state: %d never sent to transport\n",
 			     cmd->init_task_tag, cmd->se_cmd.t_state);
 		target_submit(se_cmd);
 		return 0;
 	}
 
 	if (!(se_cmd->transport_state & CMD_T_COMPLETE)) {
-		target_err("READ ITT: 0x%08x: t_state: %d, never returned"
-			   " from transport\n",
+		target_err("READ ITT: 0x%08x: t_state: %d, never returned from transport\n",
 			   cmd->init_task_tag, cmd->se_cmd.t_state);
 		return -1;
 	}
@@ -372,8 +354,7 @@ static int iscsit_task_reassign_complete_scsi_cmnd(
 	struct iscsi_conn_recovery *cr;
 
 	if (!cmd->cr) {
-		target_err("struct iscsi_conn_recovery pointer for ITT: 0x%08x"
-			   " is NULL!\n",
+		target_err("struct iscsi_conn_recovery pointer for ITT: 0x%08x is NULL!\n",
 			   cmd->init_task_tag);
 		return -1;
 	}
@@ -436,8 +417,7 @@ static int iscsit_task_reassign_complete(
 		ret = iscsit_task_reassign_complete_scsi_cmnd(tmr_req, conn);
 		break;
 	default:
-		target_err("Illegal iSCSI Opcode 0x%02x during"
-			   " command reallegiance\n",
+		target_err("Illegal iSCSI Opcode 0x%02x during command reallegiance\n",
 			   cmd->iscsi_opcode);
 		return -1;
 	}
@@ -445,8 +425,7 @@ static int iscsit_task_reassign_complete(
 	if (ret != 0)
 		return ret;
 
-	target_debug("Completed connection reallegiance for Opcode: 0x%02x,"
-		     " ITT: 0x%08x to CID: %hu.\n",
+	target_debug("Completed connection reallegiance for Opcode: 0x%02x, ITT: 0x%08x to CID: %hu.\n",
 		     cmd->iscsi_opcode, cmd->init_task_tag, conn->cid);
 
 	return 0;
@@ -733,10 +712,7 @@ static int iscsit_task_reassign_prepare_write(
 			continue;
 
 		if (r2t->seq_complete) {
-			target_err("Initiator is requesting R2Ts from"
-				   " R2TSN: 0x%08x, but R2TSN: 0x%08x, Offset: %u,"
-				   " Length: %u is already complete."
-				   "   BAD INITIATOR ERL=2 IMPLEMENTATION!\n",
+			target_err("Initiator is requesting R2Ts from R2TSN: 0x%08x, but R2TSN: 0x%08x, Offset: %u, Length: %u is already complete.   BAD INITIATOR ERL=2 IMPLEMENTATION!\n",
 				   tmr_req->exp_data_sn, r2t->r2t_sn, r2t->offset, r2t->xfer_len);
 			spin_unlock_bh(&cmd->r2t_lock);
 			return -1;
@@ -804,18 +780,13 @@ int iscsit_check_task_reassign_expdatasn(
 	 */
 	if (ref_cmd->data_direction == DMA_FROM_DEVICE) {
 		if (tmr_req->exp_data_sn > ref_cmd->data_sn) {
-			target_err("Received ExpDataSN: 0x%08x for READ"
-				   " in TMR TASK_REASSIGN greater than command's"
-				   " DataSN: 0x%08x.\n",
+			target_err("Received ExpDataSN: 0x%08x for READ in TMR TASK_REASSIGN greater than command's DataSN: 0x%08x.\n",
 				   tmr_req->exp_data_sn, ref_cmd->data_sn);
 			return -1;
 		}
 		if ((ref_cmd->cmd_flags & ICF_GOT_DATACK_SNACK) &&
 		    (tmr_req->exp_data_sn <= ref_cmd->acked_data_sn)) {
-			target_err("Received ExpDataSN: 0x%08x for READ"
-				   " in TMR TASK_REASSIGN for previously"
-				   " acknowledged DataIN: 0x%08x,"
-				   " protocol error\n",
+			target_err("Received ExpDataSN: 0x%08x for READ in TMR TASK_REASSIGN for previously acknowledged DataIN: 0x%08x, protocol error\n",
 				   tmr_req->exp_data_sn, ref_cmd->acked_data_sn);
 			return -1;
 		}
@@ -830,9 +801,7 @@ int iscsit_check_task_reassign_expdatasn(
 	 */
 	if (ref_cmd->data_direction == DMA_TO_DEVICE) {
 		if (tmr_req->exp_data_sn > ref_cmd->r2t_sn) {
-			target_err("Received ExpDataSN: 0x%08x for WRITE"
-				   " in TMR TASK_REASSIGN greater than command's"
-				   " R2TSN: 0x%08x.\n",
+			target_err("Received ExpDataSN: 0x%08x for WRITE in TMR TASK_REASSIGN greater than command's R2TSN: 0x%08x.\n",
 				   tmr_req->exp_data_sn, ref_cmd->r2t_sn);
 			return -1;
 		}
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 532f4cff5bed..2d069354f384 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -227,8 +227,7 @@ static void iscsit_set_default_tpg_attribs(struct iscsi_portal_group *tpg)
 int iscsit_tpg_add_portal_group(struct iscsi_tiqn *tiqn, struct iscsi_portal_group *tpg)
 {
 	if (tpg->tpg_state != TPG_STATE_FREE) {
-		target_err("Unable to add iSCSI Target Portal Group: %d"
-			   " while not in TPG_STATE_FREE state.\n",
+		target_err("Unable to add iSCSI Target Portal Group: %d while not in TPG_STATE_FREE state.\n",
 			   tpg->tpgt);
 		return -EEXIST;
 	}
@@ -271,8 +270,7 @@ int iscsit_tpg_del_portal_group(
 	spin_unlock(&tpg->tpg_state_lock);
 
 	if (iscsit_release_sessions_for_tpg(tpg, force) < 0) {
-		target_err("Unable to delete iSCSI Target Portal Group:"
-			   " %hu while active sessions exist, and force=0\n",
+		target_err("Unable to delete iSCSI Target Portal Group: %hu while active sessions exist, and force=0\n",
 			   tpg->tpgt);
 		tpg->tpg_state = old_state;
 		return -EPERM;
@@ -308,8 +306,7 @@ int iscsit_tpg_enable_portal_group(struct iscsi_portal_group *tpg)
 	int ret;
 
 	if (tpg->tpg_state == TPG_STATE_ACTIVE) {
-		target_err("iSCSI target portal group: %hu is already"
-			   " active, ignoring request.\n",
+		target_err("iSCSI target portal group: %hu is already active, ignoring request.\n",
 			   tpg->tpgt);
 		return -EINVAL;
 	}
@@ -356,8 +353,7 @@ int iscsit_tpg_disable_portal_group(struct iscsi_portal_group *tpg, int force)
 
 	spin_lock(&tpg->tpg_state_lock);
 	if (tpg->tpg_state == TPG_STATE_INACTIVE) {
-		target_err("iSCSI Target Portal Group: %hu is already"
-			   " inactive, ignoring request.\n",
+		target_err("iSCSI Target Portal Group: %hu is already inactive, ignoring request.\n",
 			   tpg->tpgt);
 		spin_unlock(&tpg->tpg_state_lock);
 		return -EINVAL;
@@ -371,8 +367,7 @@ int iscsit_tpg_disable_portal_group(struct iscsi_portal_group *tpg, int force)
 		spin_lock(&tpg->tpg_state_lock);
 		tpg->tpg_state = old_state;
 		spin_unlock(&tpg->tpg_state_lock);
-		target_err("Unable to disable iSCSI Target Portal Group:"
-			   " %hu while active sessions exist, and force=0\n",
+		target_err("Unable to disable iSCSI Target Portal Group: %hu while active sessions exist, and force=0\n",
 			   tpg->tpgt);
 		return -EPERM;
 	}
@@ -463,8 +458,7 @@ struct iscsi_tpg_np *iscsit_tpg_add_network_portal(
 	if (!tpg_np_parent) {
 		if (iscsit_tpg_check_network_portal(tpg->tpg_tiqn, sockaddr,
 				network_transport)) {
-			target_err("Network Portal: %pISc already exists on a"
-				   " different TPG on %s\n",
+			target_err("Network Portal: %pISc already exists on a different TPG on %s\n",
 				   sockaddr, tpg->tpg_tiqn->tiqn);
 			return ERR_PTR(-EEXIST);
 		}
@@ -472,8 +466,7 @@ struct iscsi_tpg_np *iscsit_tpg_add_network_portal(
 
 	tpg_np = kzalloc(sizeof(struct iscsi_tpg_np), GFP_KERNEL);
 	if (!tpg_np) {
-		target_err("Unable to allocate memory for"
-			   " struct iscsi_tpg_np.\n");
+		target_err("Unable to allocate memory for struct iscsi_tpg_np.\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -542,8 +535,7 @@ int iscsit_tpg_del_network_portal(
 
 	np = tpg_np->tpg_np;
 	if (!np) {
-		target_err("Unable to locate struct iscsi_np from"
-			   " struct iscsi_tpg_np\n");
+		target_err("Unable to locate struct iscsi_np from struct iscsi_tpg_np\n");
 		return -EINVAL;
 	}
 
@@ -558,9 +550,7 @@ int iscsit_tpg_del_network_portal(
 				tpg_np_child_list) {
 			ret = iscsit_tpg_del_network_portal(tpg, tpg_np_child);
 			if (ret < 0)
-				target_err("iscsit_tpg_del_network_portal()"
-					   " failed: %d\n",
-					   ret);
+				target_err("iscsit_tpg_del_network_portal() failed: %d\n", ret);
 		}
 	} else {
 		/*
@@ -590,8 +580,7 @@ int iscsit_ta_authentication(struct iscsi_portal_group *tpg, u32 authentication)
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if ((authentication != 1) && (authentication != 0)) {
-		target_err("Illegal value for authentication parameter:"
-			   " %u, ignoring request.\n",
+		target_err("Illegal value for authentication parameter: %u, ignoring request.\n",
 			   authentication);
 		return -EINVAL;
 	}
@@ -650,21 +639,18 @@ int iscsit_ta_login_timeout(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if (login_timeout > TA_LOGIN_TIMEOUT_MAX) {
-		target_err("Requested Login Timeout %u larger than maximum"
-			   " %u\n",
-			   login_timeout, TA_LOGIN_TIMEOUT_MAX);
+		target_err("Requested Login Timeout %u larger than maximum %u\n", login_timeout,
+			   TA_LOGIN_TIMEOUT_MAX);
 		return -EINVAL;
 	} else if (login_timeout < TA_LOGIN_TIMEOUT_MIN) {
-		target_err("Requested Logout Timeout %u smaller than"
-			   " minimum %u\n",
-			   login_timeout, TA_LOGIN_TIMEOUT_MIN);
+		target_err("Requested Logout Timeout %u smaller than minimum %u\n", login_timeout,
+			   TA_LOGIN_TIMEOUT_MIN);
 		return -EINVAL;
 	}
 
 	a->login_timeout = login_timeout;
-	target_debug("Set Logout Timeout to %u for Target Portal Group"
-		     " %hu\n",
-		     a->login_timeout, tpg->tpgt);
+	target_debug("Set Logout Timeout to %u for Target Portal Group %hu\n", a->login_timeout,
+		     tpg->tpgt);
 
 	return 0;
 }
@@ -685,8 +671,7 @@ int iscsit_ta_generate_node_acls(
 		     (a->generate_node_acls) ? "Enabled" : "Disabled");
 
 	if (flag == 1 && a->cache_dynamic_acls == 0) {
-		target_debug("Explicitly setting cache_dynamic_acls=1 when "
-			     "generate_node_acls=1\n");
+		target_debug("Explicitly setting cache_dynamic_acls=1 when generate_node_acls=1\n");
 		a->cache_dynamic_acls = 1;
 	}
 
@@ -700,14 +685,12 @@ int iscsit_ta_default_cmdsn_depth(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if (tcq_depth > TA_DEFAULT_CMDSN_DEPTH_MAX) {
-		target_err("Requested Default Queue Depth: %u larger"
-			   " than maximum %u\n",
-			   tcq_depth, TA_DEFAULT_CMDSN_DEPTH_MAX);
+		target_err("Requested Default Queue Depth: %u larger than maximum %u\n", tcq_depth,
+			   TA_DEFAULT_CMDSN_DEPTH_MAX);
 		return -EINVAL;
 	} else if (tcq_depth < TA_DEFAULT_CMDSN_DEPTH_MIN) {
-		target_err("Requested Default Queue Depth: %u smaller"
-			   " than minimum %u\n",
-			   tcq_depth, TA_DEFAULT_CMDSN_DEPTH_MIN);
+		target_err("Requested Default Queue Depth: %u smaller than minimum %u\n", tcq_depth,
+			   TA_DEFAULT_CMDSN_DEPTH_MIN);
 		return -EINVAL;
 	}
 
@@ -730,15 +713,13 @@ int iscsit_ta_cache_dynamic_acls(
 	}
 
 	if (a->generate_node_acls == 1 && flag == 0) {
-		target_debug("Skipping cache_dynamic_acls=0 when"
-			     " generate_node_acls=1\n");
+		target_debug("Skipping cache_dynamic_acls=0 when generate_node_acls=1\n");
 		return 0;
 	}
 
 	a->cache_dynamic_acls = flag;
-	target_debug("iSCSI_TPG[%hu] - Cache Dynamic Initiator Portal Group"
-		     " ACLs %s\n",
-		     tpg->tpgt, (a->cache_dynamic_acls) ? "Enabled" : "Disabled");
+	target_debug("iSCSI_TPG[%hu] - Cache Dynamic Initiator Portal Group ACLs %s\n", tpg->tpgt,
+		     (a->cache_dynamic_acls) ? "Enabled" : "Disabled");
 
 	return 0;
 }
@@ -773,9 +754,8 @@ int iscsit_ta_prod_mode_write_protect(
 	}
 
 	a->prod_mode_write_protect = flag;
-	target_debug("iSCSI_TPG[%hu] - Production Mode Write Protect bit:"
-		     " %s\n",
-		     tpg->tpgt, (a->prod_mode_write_protect) ? "ON" : "OFF");
+	target_debug("iSCSI_TPG[%hu] - Production Mode Write Protect bit: %s\n", tpg->tpgt,
+		     (a->prod_mode_write_protect) ? "ON" : "OFF");
 
 	return 0;
 }
@@ -792,9 +772,8 @@ int iscsit_ta_demo_mode_discovery(
 	}
 
 	a->demo_mode_discovery = flag;
-	target_debug("iSCSI_TPG[%hu] - Demo Mode Discovery bit:"
-		     " %s\n",
-		     tpg->tpgt, (a->demo_mode_discovery) ? "ON" : "OFF");
+	target_debug("iSCSI_TPG[%hu] - Demo Mode Discovery bit: %s\n", tpg->tpgt,
+		     (a->demo_mode_discovery) ? "ON" : "OFF");
 
 	return 0;
 }
@@ -828,9 +807,8 @@ int iscsit_ta_t10_pi(
 	}
 
 	a->t10_pi = flag;
-	target_debug("iSCSI_TPG[%hu] - T10 Protection information bit:"
-		     " %s\n",
-		     tpg->tpgt, (a->t10_pi) ? "ON" : "OFF");
+	target_debug("iSCSI_TPG[%hu] - T10 Protection information bit: %s\n", tpg->tpgt,
+		     (a->t10_pi) ? "ON" : "OFF");
 
 	return 0;
 }
@@ -864,9 +842,8 @@ int iscsit_ta_tpg_enabled_sendtargets(
 	}
 
 	a->tpg_enabled_sendtargets = flag;
-	target_debug("iSCSI_TPG[%hu] - TPG enabled bit required for SendTargets:"
-		     " %s\n",
-		     tpg->tpgt, (a->tpg_enabled_sendtargets) ? "ON" : "OFF");
+	target_debug("iSCSI_TPG[%hu] - TPG enabled bit required for SendTargets: %s\n", tpg->tpgt,
+		     (a->tpg_enabled_sendtargets) ? "ON" : "OFF");
 
 	return 0;
 }
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 26408a9f5546..f64f35083b61 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -81,9 +81,7 @@ struct iscsi_r2t *iscsit_get_r2t_for_eos(
 	}
 	spin_unlock_bh(&cmd->r2t_lock);
 
-	target_err("Unable to locate R2T for Offset: %u, Length:"
-		   " %u\n",
-		   offset, length);
+	target_err("Unable to locate R2T for Offset: %u, Length: %u\n", offset, length);
 	return NULL;
 }
 
@@ -100,9 +98,7 @@ struct iscsi_r2t *iscsit_get_r2t_from_list(struct iscsit_cmd *cmd)
 	}
 	spin_unlock_bh(&cmd->r2t_lock);
 
-	target_err("Unable to locate next R2T to send for ITT:"
-		   " 0x%08x.\n",
-		   cmd->init_task_tag);
+	target_err("Unable to locate next R2T to send for ITT: 0x%08x.\n", cmd->init_task_tag);
 	return NULL;
 }
 
@@ -253,27 +249,23 @@ static inline int iscsit_check_received_cmdsn(struct iscsit_session *sess, u32 c
 	 */
 	max_cmdsn = atomic_read(&sess->max_cmd_sn);
 	if (iscsi_sna_gt(cmdsn, max_cmdsn)) {
-		target_err("Received CmdSN: 0x%08x is greater than"
-			   " MaxCmdSN: 0x%08x, ignoring.\n",
+		target_err("Received CmdSN: 0x%08x is greater than MaxCmdSN: 0x%08x, ignoring.\n",
 			   cmdsn, max_cmdsn);
 		ret = CMDSN_MAXCMDSN_OVERRUN;
 
 	} else if (cmdsn == sess->exp_cmd_sn) {
 		sess->exp_cmd_sn++;
-		target_debug("Received CmdSN matches ExpCmdSN,"
-			     " incremented ExpCmdSN to: 0x%08x\n",
+		target_debug("Received CmdSN matches ExpCmdSN, incremented ExpCmdSN to: 0x%08x\n",
 			     sess->exp_cmd_sn);
 		ret = CMDSN_NORMAL_OPERATION;
 
 	} else if (iscsi_sna_gt(cmdsn, sess->exp_cmd_sn)) {
-		target_debug("Received CmdSN: 0x%08x is greater"
-			     " than ExpCmdSN: 0x%08x, not acknowledging.\n",
+		target_debug("Received CmdSN: 0x%08x is greater than ExpCmdSN: 0x%08x, not acknowledging.\n",
 			     cmdsn, sess->exp_cmd_sn);
 		ret = CMDSN_HIGHER_THAN_EXP;
 
 	} else {
-		target_err("Received CmdSN: 0x%08x is less than"
-			   " ExpCmdSN: 0x%08x, ignoring.\n",
+		target_err("Received CmdSN: 0x%08x is less than ExpCmdSN: 0x%08x, ignoring.\n",
 			   cmdsn, sess->exp_cmd_sn);
 		ret = CMDSN_LOWER_THAN_EXP;
 	}
@@ -344,8 +336,7 @@ int iscsit_check_unsolicited_dataout(struct iscsit_cmd *cmd, unsigned char *buf)
 	u32 payload_length = ntoh24(hdr->dlength);
 
 	if (conn->sess->sess_ops->InitialR2T) {
-		target_err("Received unexpected unsolicited data"
-			   " while InitialR2T=Yes, protocol error.\n");
+		target_err("Received unexpected unsolicited data while InitialR2T=Yes, protocol error.\n");
 		transport_send_check_condition_and_sense(se_cmd,
 				TCM_UNEXPECTED_UNSOLICITED_DATA, 0);
 		return -1;
@@ -353,8 +344,7 @@ int iscsit_check_unsolicited_dataout(struct iscsit_cmd *cmd, unsigned char *buf)
 
 	if ((cmd->first_burst_len + payload_length) >
 	     conn->sess->sess_ops->FirstBurstLength) {
-		target_err("Total %u bytes exceeds FirstBurstLength: %u"
-			   " for this Unsolicited DataOut Burst.\n",
+		target_err("Total %u bytes exceeds FirstBurstLength: %u for this Unsolicited DataOut Burst.\n",
 			   (cmd->first_burst_len + payload_length),
 			   conn->sess->sess_ops->FirstBurstLength);
 		transport_send_check_condition_and_sense(se_cmd,
@@ -368,9 +358,7 @@ int iscsit_check_unsolicited_dataout(struct iscsit_cmd *cmd, unsigned char *buf)
 	if (((cmd->first_burst_len + payload_length) != cmd->se_cmd.data_length) &&
 	    ((cmd->first_burst_len + payload_length) !=
 	      conn->sess->sess_ops->FirstBurstLength)) {
-		target_err("Unsolicited non-immediate data received %u"
-			   " does not equal FirstBurstLength: %u, and does"
-			   " not equal ExpXferLen %u.\n",
+		target_err("Unsolicited non-immediate data received %u does not equal FirstBurstLength: %u, and does not equal ExpXferLen %u.\n",
 			   (cmd->first_burst_len + payload_length),
 			   conn->sess->sess_ops->FirstBurstLength, cmd->se_cmd.data_length);
 		transport_send_check_condition_and_sense(se_cmd,
@@ -418,9 +406,8 @@ struct iscsit_cmd *iscsit_find_cmd_from_itt_or_dump(
 	}
 	spin_unlock_bh(&conn->cmd_lock);
 
-	target_err("Unable to locate ITT: 0x%08x on CID: %hu,"
-		   " dumping payload\n",
-		   init_task_tag, conn->cid);
+	target_err("Unable to locate ITT: 0x%08x on CID: %hu, dumping payload\n", init_task_tag,
+		   conn->cid);
 	if (length)
 		iscsit_dump_data_payload(conn, length, 1);
 
@@ -508,8 +495,7 @@ void iscsit_add_cmd_to_immediate_queue(
 
 	qr = kmem_cache_zalloc(lio_qr_cache, GFP_ATOMIC);
 	if (!qr) {
-		target_err("Unable to allocate memory for"
-			   " struct iscsi_queue_req\n");
+		target_err("Unable to allocate memory for struct iscsi_queue_req\n");
 		return;
 	}
 	INIT_LIST_HEAD(&qr->qr_list);
@@ -583,8 +569,7 @@ int iscsit_add_cmd_to_response_queue(
 
 	qr = kmem_cache_zalloc(lio_qr_cache, GFP_ATOMIC);
 	if (!qr) {
-		target_err("Unable to allocate memory for"
-			   " struct iscsi_queue_req\n");
+		target_err("Unable to allocate memory for struct iscsi_queue_req\n");
 		return -ENOMEM;
 	}
 	INIT_LIST_HEAD(&qr->qr_list);
@@ -907,8 +892,7 @@ void iscsit_handle_nopin_response_timeout(struct timer_list *t)
 		return;
 	}
 
-	target_err("Did not receive response to NOPIN on CID: %hu, failing"
-		   " connection for I_T Nexus %s,i,0x%6phN,%s,t,0x%02x\n",
+	target_err("Did not receive response to NOPIN on CID: %hu, failing connection for I_T Nexus %s,i,0x%6phN,%s,t,0x%02x\n",
 		   conn->cid, sess->sess_ops->InitiatorName, sess->isid, sess->tpg->tpg_tiqn->tiqn,
 		   (u32)sess->tpg->tpgt);
 	conn->nopin_response_timer_flags &= ~ISCSI_TF_RUNNING;
@@ -951,9 +935,8 @@ void iscsit_start_nopin_response_timer(struct iscsit_conn *conn)
 	mod_timer(&conn->nopin_response_timer,
 		  jiffies + na->nopin_response_timeout * HZ);
 
-	target_debug("Started NOPIN Response Timer on CID: %d to %u"
-		     " seconds\n",
-		     conn->cid, na->nopin_response_timeout);
+	target_debug("Started NOPIN Response Timer on CID: %d to %u seconds\n", conn->cid,
+		     na->nopin_response_timeout);
 	spin_unlock_bh(&conn->nopin_timer_lock);
 }
 
@@ -1013,9 +996,8 @@ void __iscsit_start_nopin_timer(struct iscsit_conn *conn)
 	conn->nopin_timer_flags |= ISCSI_TF_RUNNING;
 	mod_timer(&conn->nopin_timer, jiffies + na->nopin_timeout * HZ);
 
-	target_debug("Started NOPIN Timer on CID: %d at %u second"
-		     " interval\n",
-		     conn->cid, na->nopin_timeout);
+	target_debug("Started NOPIN Timer on CID: %d at %u second interval\n", conn->cid,
+		     na->nopin_timeout);
 }
 
 void iscsit_start_nopin_timer(struct iscsit_conn *conn)
@@ -1258,8 +1240,7 @@ void iscsit_print_session_params(struct iscsit_session *sess)
 {
 	struct iscsit_conn *conn;
 
-	target_debug("-----------------------------[Session Params for"
-		     " SID: %u]-----------------------------\n",
+	target_debug("-----------------------------[Session Params for SID: %u]-----------------------------\n",
 		     sess->sid);
 	spin_lock_bh(&sess->conn_lock);
 	list_for_each_entry(conn, &sess->sess_conn_list, conn_list)
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index a5906012c369..20fe346c270a 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -62,9 +62,7 @@ target_emulate_report_referrals(struct se_cmd *cmd)
 	u32 rd_len = 0, off;
 
 	if (cmd->data_length < 4) {
-		target_warn("REPORT REFERRALS allocation length %u too"
-			    " small\n",
-			    cmd->data_length);
+		target_warn("REPORT REFERRALS allocation length %u too small\n", cmd->data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -153,8 +151,7 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 		off = 4;
 
 	if (cmd->data_length < off) {
-		target_warn("REPORT TARGET PORT GROUPS allocation length %u too"
-			    " small for %s header\n",
+		target_warn("REPORT TARGET PORT GROUPS allocation length %u too small for %s header\n",
 			    cmd->data_length, (ext_hdr) ? "extended" : "normal");
 		return TCM_INVALID_CDB_FIELD;
 	}
@@ -283,8 +280,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 	u16 tg_pt_id, rtpi;
 
 	if (cmd->data_length < 4) {
-		target_warn("SET TARGET PORT GROUPS parameter list length %u too"
-			    " small\n",
+		target_warn("SET TARGET PORT GROUPS parameter list length %u too small\n",
 			    cmd->data_length);
 		return TCM_INVALID_PARAMETER_LIST;
 	}
@@ -308,8 +304,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 
 	if (!(l_tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICIT_ALUA)) {
 		rcu_read_unlock();
-		target_debug("Unable to process SET_TARGET_PORT_GROUPS"
-			     " while TPGS_EXPLICIT_ALUA is disabled\n");
+		target_debug("Unable to process SET_TARGET_PORT_GROUPS while TPGS_EXPLICIT_ALUA is disabled\n");
 		rc = TCM_UNSUPPORTED_SCSI_OPCODE;
 		goto out;
 	}
@@ -663,8 +658,7 @@ target_alua_state_check(struct se_cmd *cmd)
 	 * access state: OFFLINE
 	 */
 	if (atomic_read(&lun->lun_tg_pt_secondary_offline)) {
-		target_debug("ALUA: Got secondary offline status for local"
-			     " target port\n");
+		target_debug("ALUA: Got secondary offline status for local target port\n");
 		return TCM_ALUA_OFFLINE;
 	}
 	rcu_read_lock();
@@ -714,8 +708,7 @@ target_alua_state_check(struct se_cmd *cmd)
 	}
 
 	if (rc && rc != TCM_INVALID_CDB_FIELD) {
-		target_debug("[%s]: ALUA TG Port not available, "
-			     "SenseKey: NOT_READY, ASC/rc: 0x04/%d\n",
+		target_debug("[%s]: ALUA TG Port not available, SenseKey: NOT_READY, ASC/rc: 0x04/%d\n",
 			     cmd->se_tfo->fabric_name, rc);
 	}
 
@@ -1036,8 +1029,7 @@ static int core_alua_do_transition_tg_pt(
 		core_alua_update_tpg_primary_metadata(tg_pt_gp);
 	}
 
-	target_debug("Successful %s ALUA transition TG PT Group: %s ID: %hu"
-		     " from primary access state %s to %s\n",
+	target_debug("Successful %s ALUA transition TG PT Group: %s ID: %hu from primary access state %s to %s\n",
 		     (explicit) ? "explicit" : "implicit",
 		     config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item), tg_pt_gp->tg_pt_gp_id,
 		     core_alua_dump_state(prev_state), core_alua_dump_state(new_state));
@@ -1152,8 +1144,7 @@ int core_alua_do_port_transition(
 	spin_unlock(&lu_gp->lu_gp_lock);
 
 	if (!rc) {
-		target_debug("Successfully processed LU Group: %s all ALUA TG PT"
-			     " Group IDs: %hu %s transition to primary state: %s\n",
+		target_debug("Successfully processed LU Group: %s all ALUA TG PT Group IDs: %hu %s transition to primary state: %s\n",
 			     config_item_name(&lu_gp->lu_gp_group.cg_item), l_tg_pt_gp->tg_pt_gp_id,
 			     (explicit) ? "explicit" : "implicit", core_alua_dump_state(new_state));
 	}
@@ -1221,8 +1212,7 @@ static int core_alua_set_tg_pt_secondary_state(
 	tg_pt_gp = rcu_dereference(lun->lun_tg_pt_gp);
 	if (!tg_pt_gp) {
 		rcu_read_unlock();
-		target_err("Unable to complete secondary state"
-			   " transition\n");
+		target_err("Unable to complete secondary state transition\n");
 		return -EINVAL;
 	}
 	trans_delay_msecs = tg_pt_gp->tg_pt_gp_trans_delay_msecs;
@@ -1239,8 +1229,7 @@ static int core_alua_set_tg_pt_secondary_state(
 			ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG :
 			ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA;
 
-	target_debug("Successful %s ALUA transition TG PT Group: %s ID: %hu"
-		     " to secondary access state: %s\n",
+	target_debug("Successful %s ALUA transition TG PT Group: %s ID: %hu to secondary access state: %s\n",
 		     (explicit) ? "explicit" : "implicit",
 		     config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item), tg_pt_gp->tg_pt_gp_id,
 		     (offline) ? "OFFLINE" : "ONLINE");
@@ -1395,15 +1384,13 @@ int core_alua_set_lu_gp_id(struct t10_alua_lu_gp *lu_gp, u16 lu_gp_id)
 	 * The lu_gp->lu_gp_id may only be set once..
 	 */
 	if (lu_gp->lu_gp_valid_id) {
-		target_warn("ALUA LU Group already has a valid ID,"
-			    " ignoring request\n");
+		target_warn("ALUA LU Group already has a valid ID, ignoring request\n");
 		return -EINVAL;
 	}
 
 	spin_lock(&lu_gps_lock);
 	if (alua_lu_gps_count == 0x0000ffff) {
-		target_err("Maximum ALUA alua_lu_gps_count:"
-			   " 0x0000ffff reached\n");
+		target_err("Maximum ALUA alua_lu_gps_count: 0x0000ffff reached\n");
 		spin_unlock(&lu_gps_lock);
 		kmem_cache_free(t10_alua_lu_gp_cache, lu_gp);
 		return -ENOSPC;
@@ -1417,8 +1404,7 @@ int core_alua_set_lu_gp_id(struct t10_alua_lu_gp *lu_gp, u16 lu_gp_id)
 			if (!lu_gp_id)
 				goto again;
 
-			target_warn("ALUA Logical Unit Group ID: %hu"
-				    " already exists, ignoring request\n",
+			target_warn("ALUA Logical Unit Group ID: %hu already exists, ignoring request\n",
 				    lu_gp_id);
 			spin_unlock(&lu_gps_lock);
 			return -EINVAL;
@@ -1663,15 +1649,13 @@ int core_alua_set_tg_pt_gp_id(
 	 * The tg_pt_gp->tg_pt_gp_id may only be set once..
 	 */
 	if (tg_pt_gp->tg_pt_gp_valid_id) {
-		target_warn("ALUA TG PT Group already has a valid ID,"
-			    " ignoring request\n");
+		target_warn("ALUA TG PT Group already has a valid ID, ignoring request\n");
 		return -EINVAL;
 	}
 
 	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 	if (dev->t10_alua.alua_tg_pt_gps_count == 0x0000ffff) {
-		target_err("Maximum ALUA alua_tg_pt_gps_count:"
-			   " 0x0000ffff reached\n");
+		target_err("Maximum ALUA alua_tg_pt_gps_count: 0x0000ffff reached\n");
 		spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 		return -ENOSPC;
 	}
@@ -1685,8 +1669,7 @@ int core_alua_set_tg_pt_gp_id(
 			if (!tg_pt_gp_id)
 				goto again;
 
-			target_err("ALUA Target Port Group ID: %hu already"
-				   " exists, ignoring request\n",
+			target_err("ALUA Target Port Group ID: %hu already exists, ignoring request\n",
 				   tg_pt_gp_id);
 			spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 			return -EINVAL;
@@ -1941,10 +1924,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 		 * with the default_tg_pt_gp.
 		 */
 		if (!tg_pt_gp_new) {
-			target_debug("Target_Core_ConfigFS: Moving"
-				     " %s/tpgt_%hu/%s from ALUA Target Port Group:"
-				     " alua/%s, ID: %hu back to"
-				     " default_tg_pt_gp\n",
+			target_debug("Target_Core_ConfigFS: Moving %s/tpgt_%hu/%s from ALUA Target Port Group: alua/%s, ID: %hu back to default_tg_pt_gp\n",
 				     tpg->se_tpg_tfo->tpg_get_wwn(tpg),
 				     tpg->se_tpg_tfo->tpg_get_tag(tpg),
 				     config_item_name(&lun->lun_group.cg_item),
@@ -1962,8 +1942,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 
 	target_swap_tg_pt_gp(lun, tg_pt_gp, tg_pt_gp_new);
 	spin_unlock(&lun->lun_tg_pt_gp_lock);
-	target_debug("Target_Core_ConfigFS: %s %s/tpgt_%hu/%s to ALUA"
-		     " Target Port Group: alua/%s, ID: %hu\n",
+	target_debug("Target_Core_ConfigFS: %s %s/tpgt_%hu/%s to ALUA Target Port Group: alua/%s, ID: %hu\n",
 		     (move) ? "Moving" : "Adding", tpg->se_tpg_tfo->tpg_get_wwn(tpg),
 		     tpg->se_tpg_tfo->tpg_get_tag(tpg), config_item_name(&lun->lun_group.cg_item),
 		     config_item_name(&tg_pt_gp_new->tg_pt_gp_group.cg_item),
@@ -2004,9 +1983,7 @@ ssize_t core_alua_store_access_type(
 		return ret;
 	}
 	if ((tmp != 0) && (tmp != 1) && (tmp != 2) && (tmp != 3)) {
-		target_err("Illegal value for alua_access_type:"
-			   " %lu\n",
-			   tmp);
+		target_err("Illegal value for alua_access_type: %lu\n", tmp);
 		return -EINVAL;
 	}
 	if (tmp == 3)
@@ -2043,8 +2020,7 @@ ssize_t core_alua_store_nonop_delay_msecs(
 		return ret;
 	}
 	if (tmp > ALUA_MAX_NONOP_DELAY_MSECS) {
-		target_err("Passed nonop_delay_msecs: %lu, exceeds"
-			   " ALUA_MAX_NONOP_DELAY_MSECS: %d\n",
+		target_err("Passed nonop_delay_msecs: %lu, exceeds ALUA_MAX_NONOP_DELAY_MSECS: %d\n",
 			   tmp, ALUA_MAX_NONOP_DELAY_MSECS);
 		return -EINVAL;
 	}
@@ -2074,8 +2050,7 @@ ssize_t core_alua_store_trans_delay_msecs(
 		return ret;
 	}
 	if (tmp > ALUA_MAX_TRANS_DELAY_MSECS) {
-		target_err("Passed trans_delay_msecs: %lu, exceeds"
-			   " ALUA_MAX_TRANS_DELAY_MSECS: %d\n",
+		target_err("Passed trans_delay_msecs: %lu, exceeds ALUA_MAX_TRANS_DELAY_MSECS: %d\n",
 			   tmp, ALUA_MAX_TRANS_DELAY_MSECS);
 		return -EINVAL;
 	}
@@ -2105,8 +2080,7 @@ ssize_t core_alua_store_implicit_trans_secs(
 		return ret;
 	}
 	if (tmp > ALUA_MAX_IMPLICIT_TRANS_SECS) {
-		target_err("Passed implicit_trans_secs: %lu, exceeds"
-			   " ALUA_MAX_IMPLICIT_TRANS_SECS: %d\n",
+		target_err("Passed implicit_trans_secs: %lu, exceeds ALUA_MAX_IMPLICIT_TRANS_SECS: %d\n",
 			   tmp, ALUA_MAX_IMPLICIT_TRANS_SECS);
 		return  -EINVAL;
 	}
@@ -2236,9 +2210,7 @@ ssize_t core_alua_store_secondary_write_metadata(
 		return ret;
 	}
 	if ((tmp != 0) && (tmp != 1)) {
-		target_err("Illegal value for alua_tg_pt_write_md:"
-			   " %lu\n",
-			   tmp);
+		target_err("Illegal value for alua_tg_pt_write_md: %lu\n", tmp);
 		return -EINVAL;
 	}
 	lun->lun_tg_pt_secondary_write_md = (int)tmp;
@@ -2266,8 +2238,7 @@ int core_setup_alua(struct se_device *dev)
 				default_lu_gp);
 		spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
 
-		target_debug("%s: Adding to default ALUA LU Group:"
-			     " core/alua/lu_gps/default_lu_gp\n",
+		target_debug("%s: Adding to default ALUA LU Group: core/alua/lu_gps/default_lu_gp\n",
 			     dev->transport->name);
 	}
 
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 081521f8eb1a..433afdc20dc1 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -189,9 +189,7 @@ static struct config_group *target_core_register_fabric(
 	struct target_fabric_configfs *tf;
 	int ret;
 
-	target_debug("Target_Core_ConfigFS: REGISTER -> group: %p name:"
-		     " %s\n",
-		     group, name);
+	target_debug("Target_Core_ConfigFS: REGISTER -> group: %p name: %s\n", group, name);
 
 	tf = target_core_get_fabric(name);
 	if (!tf) {
@@ -217,8 +215,7 @@ static struct config_group *target_core_register_fabric(
 			 */
 			ret = request_module("iscsi_target_mod");
 			if (ret < 0) {
-				target_debug("request_module() failed for"
-					     " iscsi_target_mod.ko: %d\n",
+				target_debug("request_module() failed for iscsi_target_mod.ko: %d\n",
 					     ret);
 				return ERR_PTR(-EINVAL);
 			}
@@ -231,9 +228,7 @@ static struct config_group *target_core_register_fabric(
 			 */
 			ret = request_module("tcm_loop");
 			if (ret < 0) {
-				target_debug("request_module() failed for"
-					     " tcm_loop.ko: %d\n",
-					     ret);
+				target_debug("request_module() failed for tcm_loop.ko: %d\n", ret);
 				return ERR_PTR(-EINVAL);
 			}
 		}
@@ -245,8 +240,7 @@ static struct config_group *target_core_register_fabric(
 		target_debug("target_core_get_fabric() failed for %s\n", name);
 		return ERR_PTR(-EINVAL);
 	}
-	target_debug("Target_Core_ConfigFS: REGISTER -> Located fabric:"
-		     " %s\n",
+	target_debug("Target_Core_ConfigFS: REGISTER -> Located fabric: %s\n",
 		     tf->tf_ops->fabric_name);
 	/*
 	 * On a successful target_core_get_fabric() look, the returned
@@ -275,17 +269,14 @@ static void target_core_deregister_fabric(
 	struct target_fabric_configfs *tf = container_of(
 		to_config_group(item), struct target_fabric_configfs, tf_group);
 
-	target_debug("Target_Core_ConfigFS: DEREGISTER -> Looking up %s in"
-		     " tf list\n",
+	target_debug("Target_Core_ConfigFS: DEREGISTER -> Looking up %s in tf list\n",
 		     config_item_name(item));
 
-	target_debug("Target_Core_ConfigFS: DEREGISTER -> located fabric:"
-		     " %s\n",
+	target_debug("Target_Core_ConfigFS: DEREGISTER -> located fabric: %s\n",
 		     tf->tf_ops->fabric_name);
 	atomic_dec(&tf->tf_access_cnt);
 
-	target_debug("Target_Core_ConfigFS: DEREGISTER -> Releasing ci"
-		     " %s\n",
+	target_debug("Target_Core_ConfigFS: DEREGISTER -> Releasing ci %s\n",
 		     config_item_name(item));
 
 	configfs_remove_default_groups(&tf->tf_group);
@@ -367,8 +358,7 @@ static int target_fabric_tf_ops_check(const struct target_core_fabric_ops *tfo)
 {
 	if (tfo->fabric_alias) {
 		if (strlen(tfo->fabric_alias) >= TARGET_FABRIC_NAME_SIZE) {
-			target_err("Passed alias: %s exceeds "
-				   "TARGET_FABRIC_NAME_SIZE\n",
+			target_err("Passed alias: %s exceeds TARGET_FABRIC_NAME_SIZE\n",
 				   tfo->fabric_alias);
 			return -EINVAL;
 		}
@@ -378,9 +368,7 @@ static int target_fabric_tf_ops_check(const struct target_core_fabric_ops *tfo)
 		return -EINVAL;
 	}
 	if (strlen(tfo->fabric_name) >= TARGET_FABRIC_NAME_SIZE) {
-		target_err("Passed name: %s exceeds "
-			   "TARGET_FABRIC_NAME_SIZE\n",
-			   tfo->fabric_name);
+		target_err("Passed name: %s exceeds TARGET_FABRIC_NAME_SIZE\n", tfo->fabric_name);
 		return -EINVAL;
 	}
 	if (!tfo->tpg_get_wwn) {
@@ -647,8 +635,7 @@ static void dev_set_t10_wwn_model_alias(struct se_device *dev)
 
 	configname = config_item_name(&dev->dev_group.cg_item);
 	if (strlen(configname) >= INQUIRY_MODEL_LEN) {
-		target_warn("dev[%p]: Backstore name '%s' is too long for "
-			    "INQUIRY_MODEL, truncating to 15 characters\n",
+		target_warn("dev[%p]: Backstore name '%s' is too long for INQUIRY_MODEL, truncating to 15 characters\n",
 			    dev, configname);
 	}
 	/*
@@ -668,9 +655,8 @@ static ssize_t emulate_model_alias_store(struct config_item *item,
 	int ret;
 
 	if (dev->export_count) {
-		target_err("dev[%p]: Unable to change model alias"
-			   " while export_count is %d\n",
-			   dev, dev->export_count);
+		target_err("dev[%p]: Unable to change model alias while export_count is %d\n", dev,
+			   dev->export_count);
 		return -EINVAL;
 	}
 
@@ -729,8 +715,7 @@ static ssize_t emulate_ua_intlck_ctrl_store(struct config_item *item,
 	}
 
 	if (da->da_dev->export_count) {
-		target_err("dev[%p]: Unable to change SE Device"
-			   " UA_INTRLCK_CTRL while export_count is %d\n",
+		target_err("dev[%p]: Unable to change SE Device UA_INTRLCK_CTRL while export_count is %d\n",
 			   da->da_dev, da->da_dev->export_count);
 		return -EINVAL;
 	}
@@ -751,8 +736,7 @@ static ssize_t emulate_tas_store(struct config_item *item,
 		return ret;
 
 	if (da->da_dev->export_count) {
-		target_err("dev[%p]: Unable to change SE Device TAS while"
-			   " export_count is %d\n",
+		target_err("dev[%p]: Unable to change SE Device TAS while export_count is %d\n",
 			   da->da_dev, da->da_dev->export_count);
 		return -EINVAL;
 	}
@@ -860,8 +844,7 @@ static ssize_t pi_prot_type_store(struct config_item *item,
 		return -ENOSYS;
 	}
 	if (da->hw_pi_prot_type) {
-		target_warn("DIF protection enabled on underlying hardware,"
-			    " ignoring\n");
+		target_warn("DIF protection enabled on underlying hardware, ignoring\n");
 		return count;
 	}
 	if (!dev->transport->init_prot || !dev->transport->free_prot) {
@@ -877,8 +860,7 @@ static ssize_t pi_prot_type_store(struct config_item *item,
 		return -ENODEV;
 	}
 	if (dev->export_count) {
-		target_err("dev[%p]: Unable to change SE Device PROT type while"
-			   " export_count is %d\n",
+		target_err("dev[%p]: Unable to change SE Device PROT type while export_count is %d\n",
 			   dev, dev->export_count);
 		return -EINVAL;
 	}
@@ -933,8 +915,7 @@ static ssize_t pi_prot_format_store(struct config_item *item,
 		return -ENODEV;
 	}
 	if (dev->export_count) {
-		target_err("dev[%p]: Unable to format SE Device PROT type while"
-			   " export_count is %d\n",
+		target_err("dev[%p]: Unable to format SE Device PROT type while export_count is %d\n",
 			   dev, dev->export_count);
 		return -EINVAL;
 	}
@@ -963,8 +944,7 @@ static ssize_t pi_prot_verify_store(struct config_item *item,
 		return count;
 	}
 	if (da->hw_pi_prot_type) {
-		target_warn("DIF protection enabled on underlying hardware,"
-			    " ignoring\n");
+		target_warn("DIF protection enabled on underlying hardware, ignoring\n");
 		return count;
 	}
 	if (!da->pi_prot_type) {
@@ -987,8 +967,7 @@ static ssize_t force_pr_aptpl_store(struct config_item *item,
 	if (ret < 0)
 		return ret;
 	if (da->da_dev->export_count) {
-		target_err("dev[%p]: Unable to set force_pr_aptpl while"
-			   " export_count is %d\n",
+		target_err("dev[%p]: Unable to set force_pr_aptpl while export_count is %d\n",
 			   da->da_dev, da->da_dev->export_count);
 		return -EINVAL;
 	}
@@ -1010,8 +989,7 @@ static ssize_t emulate_rest_reord_store(struct config_item *item,
 		return ret;
 
 	if (flag != 0) {
-		target_err("dev[%p]: SE Device emulation of restricted"
-			   " reordering not implemented\n",
+		target_err("dev[%p]: SE Device emulation of restricted reordering not implemented\n",
 			   da->da_dev);
 		return -ENOSYS;
 	}
@@ -1033,8 +1011,7 @@ static ssize_t unmap_zeroes_data_store(struct config_item *item,
 		return ret;
 
 	if (da->da_dev->export_count) {
-		target_err("dev[%p]: Unable to change SE Device"
-			   " unmap_zeroes_data while export_count is %d\n",
+		target_err("dev[%p]: Unable to change SE Device unmap_zeroes_data while export_count is %d\n",
 			   da->da_dev, da->da_dev->export_count);
 		return -EINVAL;
 	}
@@ -1068,8 +1045,7 @@ static ssize_t queue_depth_store(struct config_item *item,
 		return ret;
 
 	if (dev->export_count) {
-		target_err("dev[%p]: Unable to change SE Device TCQ while"
-			   " export_count is %d\n",
+		target_err("dev[%p]: Unable to change SE Device TCQ while export_count is %d\n",
 			   dev, dev->export_count);
 		return -EINVAL;
 	}
@@ -1080,9 +1056,7 @@ static ssize_t queue_depth_store(struct config_item *item,
 
 	if (val > dev->dev_attrib.queue_depth) {
 		if (val > dev->dev_attrib.hw_queue_depth) {
-			target_err("dev[%p]: Passed queue_depth:"
-				   " %u exceeds TCM/SE_Device MAX"
-				   " TCQ: %u\n",
+			target_err("dev[%p]: Passed queue_depth: %u exceeds TCM/SE_Device MAX TCQ: %u\n",
 				   dev, val, dev->dev_attrib.hw_queue_depth);
 			return -EINVAL;
 		}
@@ -1104,14 +1078,12 @@ static ssize_t optimal_sectors_store(struct config_item *item,
 		return ret;
 
 	if (da->da_dev->export_count) {
-		target_err("dev[%p]: Unable to change SE Device"
-			   " optimal_sectors while export_count is %d\n",
+		target_err("dev[%p]: Unable to change SE Device optimal_sectors while export_count is %d\n",
 			   da->da_dev, da->da_dev->export_count);
 		return -EINVAL;
 	}
 	if (val > da->hw_max_sectors) {
-		target_err("dev[%p]: Passed optimal_sectors %u cannot be"
-			   " greater than hw_max_sectors: %u\n",
+		target_err("dev[%p]: Passed optimal_sectors %u cannot be greater than hw_max_sectors: %u\n",
 			   da->da_dev, val, da->hw_max_sectors);
 		return -EINVAL;
 	}
@@ -1133,15 +1105,13 @@ static ssize_t block_size_store(struct config_item *item,
 		return ret;
 
 	if (da->da_dev->export_count) {
-		target_err("dev[%p]: Unable to change SE Device block_size"
-			   " while export_count is %d\n",
+		target_err("dev[%p]: Unable to change SE Device block_size while export_count is %d\n",
 			   da->da_dev, da->da_dev->export_count);
 		return -EINVAL;
 	}
 
 	if (val != 512 && val != 1024 && val != 2048 && val != 4096) {
-		target_err("dev[%p]: Illegal value for block_device: %u"
-			   " for SE device, must be 512, 1024, 2048 or 4096\n",
+		target_err("dev[%p]: Illegal value for block_device: %u for SE device, must be 512, 1024, 2048 or 4096\n",
 			   da->da_dev, val);
 		return -EINVAL;
 	}
@@ -1179,8 +1149,7 @@ static ssize_t alua_support_store(struct config_item *item,
 
 	if (!(dev->transport->transport_flags_changeable &
 	      TRANSPORT_FLAG_PASSTHROUGH_ALUA)) {
-		target_err("dev[%p]: Unable to change SE Device alua_support:"
-			   " alua_support has fixed value\n",
+		target_err("dev[%p]: Unable to change SE Device alua_support: alua_support has fixed value\n",
 			   dev);
 		return -ENOSYS;
 	}
@@ -1219,8 +1188,7 @@ static ssize_t pgr_support_store(struct config_item *item,
 
 	if (!(dev->transport->transport_flags_changeable &
 	      TRANSPORT_FLAG_PASSTHROUGH_PGR)) {
-		target_err("dev[%p]: Unable to change SE Device pgr_support:"
-			   " pgr_support has fixed value\n",
+		target_err("dev[%p]: Unable to change SE Device pgr_support: pgr_support has fixed value\n",
 			   dev);
 		return -ENOSYS;
 	}
@@ -1441,8 +1409,8 @@ static ssize_t target_wwn_vendor_id_store(struct config_item *item,
 		len = strlen(stripped);
 	}
 	if (len < 0 || len > INQUIRY_VENDOR_LEN) {
-		target_err("Emulated T10 Vendor Identification exceeds"
-			   " INQUIRY_VENDOR_LEN: " __stringify(INQUIRY_VENDOR_LEN) "\n");
+		target_err("Emulated T10 Vendor Identification exceeds INQUIRY_VENDOR_LEN: "
+			   __stringify(INQUIRY_VENDOR_LEN) "\n");
 		return -EOVERFLOW;
 	}
 
@@ -1458,8 +1426,7 @@ static ssize_t target_wwn_vendor_id_store(struct config_item *item,
 	 * effects.
 	 */
 	if (dev->export_count) {
-		target_err("Unable to set T10 Vendor Identification while"
-			   " active %d exports exist\n",
+		target_err("Unable to set T10 Vendor Identification while active %d exports exist\n",
 			   dev->export_count);
 		return -EINVAL;
 	}
@@ -1467,8 +1434,7 @@ static ssize_t target_wwn_vendor_id_store(struct config_item *item,
 	BUILD_BUG_ON(sizeof(dev->t10_wwn.vendor) != INQUIRY_VENDOR_LEN + 1);
 	strscpy(dev->t10_wwn.vendor, stripped, sizeof(dev->t10_wwn.vendor));
 
-	target_debug("Target_Core_ConfigFS: Set emulated T10 Vendor Identification:"
-		     " %s\n",
+	target_debug("Target_Core_ConfigFS: Set emulated T10 Vendor Identification: %s\n",
 		     dev->t10_wwn.vendor);
 
 	return count;
@@ -1658,14 +1624,12 @@ static ssize_t target_wwn_vpd_unit_serial_store(struct config_item *item,
 	 * VPD Unit Serial Number that OS dependent multipath can depend on.
 	 */
 	if (dev->dev_flags & DF_FIRMWARE_VPD_UNIT_SERIAL) {
-		target_err("Underlying SCSI device firmware provided VPD"
-			   " Unit Serial, ignoring request\n");
+		target_err("Underlying SCSI device firmware provided VPD Unit Serial, ignoring request\n");
 		return -EOPNOTSUPP;
 	}
 
 	if (strlen(page) >= INQUIRY_VPD_SERIAL_LEN) {
-		target_err("Emulated VPD Unit Serial exceeds"
-			   " INQUIRY_VPD_SERIAL_LEN: %d\n",
+		target_err("Emulated VPD Unit Serial exceeds INQUIRY_VPD_SERIAL_LEN: %d\n",
 			   INQUIRY_VPD_SERIAL_LEN);
 		return -EOVERFLOW;
 	}
@@ -1676,8 +1640,7 @@ static ssize_t target_wwn_vpd_unit_serial_store(struct config_item *item,
 	 * could cause negative effects.
 	 */
 	if (dev->export_count) {
-		target_err("Unable to set VPD Unit Serial while"
-			   " active %d $FABRIC_MOD exports exist\n",
+		target_err("Unable to set VPD Unit Serial while active %d $FABRIC_MOD exports exist\n",
 			   dev->export_count);
 		return -EINVAL;
 	}
@@ -1693,8 +1656,7 @@ static ssize_t target_wwn_vpd_unit_serial_store(struct config_item *item,
 			"%s", strstrip(buf));
 	dev->dev_flags |= DF_EMULATED_VPD_UNIT_SERIAL;
 
-	target_debug("Target_Core_ConfigFS: Set emulated VPD Unit Serial:"
-		     " %s\n",
+	target_debug("Target_Core_ConfigFS: Set emulated VPD Unit Serial: %s\n",
 		     dev->t10_wwn.unit_serial);
 
 	return count;
@@ -2078,8 +2040,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 		return count;
 
 	if (dev->export_count) {
-		target_debug("Unable to process APTPL metadata while"
-			     " active fabric exports exist\n");
+		target_debug("Unable to process APTPL metadata while active fabric exports exist\n");
 		return -EINVAL;
 	}
 
@@ -2108,8 +2069,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 				goto out;
 			}
 			if (strlen(i_port) >= PR_APTPL_MAX_IPORT_LEN) {
-				target_err("APTPL metadata initiator_node="
-					   " exceeds PR_APTPL_MAX_IPORT_LEN: %d\n",
+				target_err("APTPL metadata initiator_node= exceeds PR_APTPL_MAX_IPORT_LEN: %d\n",
 					   PR_APTPL_MAX_IPORT_LEN);
 				ret = -EINVAL;
 				break;
@@ -2122,8 +2082,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 				goto out;
 			}
 			if (strlen(isid) >= PR_REG_ISID_LEN) {
-				target_err("APTPL metadata initiator_isid"
-					   "= exceeds PR_REG_ISID_LEN: %d\n",
+				target_err("APTPL metadata initiator_isid= exceeds PR_REG_ISID_LEN: %d\n",
 					   PR_REG_ISID_LEN);
 				ret = -EINVAL;
 				break;
@@ -2186,8 +2145,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 				goto out;
 			}
 			if (strlen(t_port) >= PR_APTPL_MAX_TPORT_LEN) {
-				target_err("APTPL metadata target_node="
-					   " exceeds PR_APTPL_MAX_TPORT_LEN: %d\n",
+				target_err("APTPL metadata target_node= exceeds PR_APTPL_MAX_TPORT_LEN: %d\n",
 					   PR_APTPL_MAX_TPORT_LEN);
 				ret = -EINVAL;
 				break;
@@ -2222,9 +2180,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 	}
 
 	if (res_holder && !(type)) {
-		target_err("Illegal PR type: 0x%02x for reservation"
-			   " holder\n",
-			   type);
+		target_err("Illegal PR type: 0x%02x for reservation holder\n", type);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -2316,9 +2272,8 @@ static ssize_t target_dev_alias_store(struct config_item *item,
 	ssize_t read_bytes;
 
 	if (count > (SE_DEV_ALIAS_LEN-1)) {
-		target_err("alias count: %d exceeds"
-			   " SE_DEV_ALIAS_LEN-1: %u\n",
-			   (int)count, SE_DEV_ALIAS_LEN - 1);
+		target_err("alias count: %d exceeds SE_DEV_ALIAS_LEN-1: %u\n", (int)count,
+			   SE_DEV_ALIAS_LEN - 1);
 		return -EINVAL;
 	}
 
@@ -2355,9 +2310,8 @@ static ssize_t target_dev_udev_path_store(struct config_item *item,
 	ssize_t read_bytes;
 
 	if (count > (SE_UDEV_PATH_LEN-1)) {
-		target_err("udev_path count: %d exceeds"
-			   " SE_UDEV_PATH_LEN-1: %u\n",
-			   (int)count, SE_UDEV_PATH_LEN - 1);
+		target_err("udev_path count: %d exceeds SE_UDEV_PATH_LEN-1: %u\n", (int)count,
+			   SE_UDEV_PATH_LEN - 1);
 		return -EINVAL;
 	}
 
@@ -2393,8 +2347,7 @@ static ssize_t target_dev_enable_store(struct config_item *item,
 
 	ptr = strstr(page, "1");
 	if (!ptr) {
-		target_err("For dev_enable ops, only valid value"
-			   " is \"1\"\n");
+		target_err("For dev_enable ops, only valid value is \"1\"\n");
 		return -EINVAL;
 	}
 
@@ -2470,9 +2423,7 @@ static ssize_t target_dev_alua_lu_gp_store(struct config_item *item,
 		 * with NULL
 		 */
 		if (!lu_gp_new) {
-			target_debug("Target_Core_ConfigFS: Releasing %s/%s"
-				     " from ALUA LU Group: core/alua/lu_gps/%s, ID:"
-				     " %hu\n",
+			target_debug("Target_Core_ConfigFS: Releasing %s/%s from ALUA LU Group: core/alua/lu_gps/%s, ID: %hu\n",
 				     config_item_name(&hba->hba_group.cg_item),
 				     config_item_name(&dev->dev_group.cg_item),
 				     config_item_name(&lu_gp->lu_gp_group.cg_item),
@@ -2495,8 +2446,7 @@ static ssize_t target_dev_alua_lu_gp_store(struct config_item *item,
 	__core_alua_attach_lu_gp_mem(lu_gp_mem, lu_gp_new);
 	spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
 
-	target_debug("Target_Core_ConfigFS: %s %s/%s to ALUA LU Group:"
-		     " core/alua/lu_gps/%s, ID: %hu\n",
+	target_debug("Target_Core_ConfigFS: %s %s/%s to ALUA LU Group: core/alua/lu_gps/%s, ID: %hu\n",
 		     (move) ? "Moving" : "Adding", config_item_name(&hba->hba_group.cg_item),
 		     config_item_name(&dev->dev_group.cg_item),
 		     config_item_name(&lu_gp_new->lu_gp_group.cg_item), lu_gp_new->lu_gp_id);
@@ -2631,9 +2581,8 @@ static ssize_t target_dev_lba_map_store(struct config_item *item,
 			ret = core_alua_allocate_lba_map_mem(lba_map,
 							     pg_id, alua_state);
 			if (ret) {
-				target_err("Invalid target descriptor %d:%c "
-					   "at line %d\n",
-					   pg_id, state, num);
+				target_err("Invalid target descriptor %d:%c at line %d\n", pg_id,
+					   state, num);
 				break;
 			}
 			pg++;
@@ -2646,8 +2595,8 @@ static ssize_t target_dev_lba_map_store(struct config_item *item,
 		if (pg_num == -1)
 		    pg_num = pg;
 		else if (pg != pg_num) {
-			target_err("Only %d from %d port groups definitions "
-				   "at line %d\n", pg, pg_num, num);
+			target_err("Only %d from %d port groups definitions at line %d\n", pg,
+				   pg_num, num);
 			ret = -EINVAL;
 			break;
 		}
@@ -2731,15 +2680,11 @@ static ssize_t target_lu_gp_lu_gp_id_store(struct config_item *item,
 
 	ret = kstrtoul(page, 0, &lu_gp_id);
 	if (ret < 0) {
-		target_err("kstrtoul() returned %d for"
-			   " lu_gp_id\n",
-			   ret);
+		target_err("kstrtoul() returned %d for lu_gp_id\n", ret);
 		return ret;
 	}
 	if (lu_gp_id > 0x0000ffff) {
-		target_err("ALUA lu_gp_id: %lu exceeds maximum:"
-			   " 0x0000ffff\n",
-			   lu_gp_id);
+		target_err("ALUA lu_gp_id: %lu exceeds maximum: 0x0000ffff\n", lu_gp_id);
 		return -EINVAL;
 	}
 
@@ -2747,8 +2692,7 @@ static ssize_t target_lu_gp_lu_gp_id_store(struct config_item *item,
 	if (ret < 0)
 		return -EINVAL;
 
-	target_debug("Target_Core_ConfigFS: Set ALUA Logical Unit"
-		     " Group: core/alua/lu_gps/%s to ID: %hu\n",
+	target_debug("Target_Core_ConfigFS: Set ALUA Logical Unit Group: core/alua/lu_gps/%s to ID: %hu\n",
 		     config_item_name(&alua_lu_gp_cg->cg_item), lu_gp->lu_gp_id);
 
 	return count;
@@ -2774,8 +2718,7 @@ static ssize_t target_lu_gp_members_show(struct config_item *item, char *page)
 		cur_len++; /* Extra byte for NULL terminator */
 
 		if ((cur_len + len) > PAGE_SIZE) {
-			target_warn("Ran out of lu_gp_show_attr"
-				    "_members buffer\n");
+			target_warn("Ran out of lu_gp_show_attr_members buffer\n");
 			break;
 		}
 		memcpy(page+len, buf, cur_len);
@@ -2835,8 +2778,7 @@ static struct config_group *target_core_alua_create_lu_gp(
 	config_group_init_type_name(alua_lu_gp_cg, name,
 			&target_core_alua_lu_gp_cit);
 
-	target_debug("Target_Core_ConfigFS: Allocated ALUA Logical Unit"
-		     " Group: core/alua/lu_gps/%s\n",
+	target_debug("Target_Core_ConfigFS: Allocated ALUA Logical Unit Group: core/alua/lu_gps/%s\n",
 		     config_item_name(alua_lu_gp_ci));
 
 	return alua_lu_gp_cg;
@@ -2850,8 +2792,7 @@ static void target_core_alua_drop_lu_gp(
 	struct t10_alua_lu_gp *lu_gp = container_of(to_config_group(item),
 			struct t10_alua_lu_gp, lu_gp_group);
 
-	target_debug("Target_Core_ConfigFS: Releasing ALUA Logical Unit"
-		     " Group: core/alua/lu_gps/%s, ID: %hu\n",
+	target_debug("Target_Core_ConfigFS: Releasing ALUA Logical Unit Group: core/alua/lu_gps/%s, ID: %hu\n",
 		     config_item_name(item), lu_gp->lu_gp_id);
 	/*
 	 * core_alua_free_lu_gp() is called from target_core_alua_lu_gp_ops->release()
@@ -2901,30 +2842,25 @@ static ssize_t target_tg_pt_gp_alua_access_state_store(struct config_item *item,
 		return -EINVAL;
 	}
 	if (!target_dev_configured(dev)) {
-		target_err("Unable to set alua_access_state while device is"
-			   " not configured\n");
+		target_err("Unable to set alua_access_state while device is not configured\n");
 		return -ENODEV;
 	}
 
 	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
-		target_err("Unable to extract new ALUA access state from"
-			   " %s\n",
-			   page);
+		target_err("Unable to extract new ALUA access state from %s\n", page);
 		return ret;
 	}
 	new_state = (int)tmp;
 
 	if (!(tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_IMPLICIT_ALUA)) {
-		target_err("Unable to process implicit configfs ALUA"
-			   " transition while TPGS_IMPLICIT_ALUA is disabled\n");
+		target_err("Unable to process implicit configfs ALUA transition while TPGS_IMPLICIT_ALUA is disabled\n");
 		return -EINVAL;
 	}
 	if (tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICIT_ALUA &&
 	    new_state == ALUA_ACCESS_STATE_LBA_DEPENDENT) {
 		/* LBA DEPENDENT is only allowed with implicit ALUA */
-		target_err("Unable to process implicit configfs ALUA transition"
-			   " while explicit ALUA management is enabled\n");
+		target_err("Unable to process implicit configfs ALUA transition while explicit ALUA management is enabled\n");
 		return -EINVAL;
 	}
 
@@ -2955,9 +2891,7 @@ static ssize_t target_tg_pt_gp_alua_access_status_store(
 
 	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
-		target_err("Unable to extract new ALUA access status"
-			   " from %s\n",
-			   page);
+		target_err("Unable to extract new ALUA access status from %s\n", page);
 		return ret;
 	}
 	new_status = (int)tmp;
@@ -3052,9 +2986,7 @@ static ssize_t target_tg_pt_gp_alua_write_metadata_store(
 	}
 
 	if ((tmp != 0) && (tmp != 1)) {
-		target_err("Illegal value for alua_write_metadata:"
-			   " %lu\n",
-			   tmp);
+		target_err("Illegal value for alua_write_metadata: %lu\n", tmp);
 		return -EINVAL;
 	}
 	tg_pt_gp->tg_pt_gp_write_metadata = (int)tmp;
@@ -3145,8 +3077,7 @@ static ssize_t target_tg_pt_gp_tg_pt_gp_id_store(struct config_item *item,
 	if (ret < 0)
 		return -EINVAL;
 
-	target_debug("Target_Core_ConfigFS: Set ALUA Target Port Group: "
-		     "core/alua/tg_pt_gps/%s to ID: %hu\n",
+	target_debug("Target_Core_ConfigFS: Set ALUA Target Port Group: core/alua/tg_pt_gps/%s to ID: %hu\n",
 		     config_item_name(&alua_tg_pt_gp_cg->cg_item), tg_pt_gp->tg_pt_gp_id);
 
 	return count;
@@ -3173,8 +3104,7 @@ static ssize_t target_tg_pt_gp_members_show(struct config_item *item,
 		cur_len++; /* Extra byte for NULL terminator */
 
 		if ((cur_len + len) > PAGE_SIZE) {
-			target_warn("Ran out of lu_gp_show_attr"
-				    "_members buffer\n");
+			target_warn("Ran out of lu_gp_show_attr_members buffer\n");
 			break;
 		}
 		memcpy(page+len, buf, cur_len);
@@ -3266,8 +3196,7 @@ static struct config_group *target_core_alua_create_tg_pt_gp(
 	config_group_init_type_name(alua_tg_pt_gp_cg, name,
 			&target_core_alua_tg_pt_gp_cit);
 
-	target_debug("Target_Core_ConfigFS: Allocated ALUA Target Port"
-		     " Group: alua/tg_pt_gps/%s\n",
+	target_debug("Target_Core_ConfigFS: Allocated ALUA Target Port Group: alua/tg_pt_gps/%s\n",
 		     config_item_name(alua_tg_pt_gp_ci));
 
 	return alua_tg_pt_gp_cg;
@@ -3280,8 +3209,7 @@ static void target_core_alua_drop_tg_pt_gp(
 	struct t10_alua_tg_pt_gp *tg_pt_gp = container_of(to_config_group(item),
 			struct t10_alua_tg_pt_gp, tg_pt_gp_group);
 
-	target_debug("Target_Core_ConfigFS: Releasing ALUA Target Port"
-		     " Group: alua/tg_pt_gps/%s, ID: %hu\n",
+	target_debug("Target_Core_ConfigFS: Releasing ALUA Target Port Group: alua/tg_pt_gps/%s, ID: %hu\n",
 		     config_item_name(item), tg_pt_gp->tg_pt_gp_id);
 	/*
 	 * core_alua_free_tg_pt_gp() is called from target_core_alua_tg_pt_gp_ops->release()
@@ -3559,8 +3487,7 @@ static struct config_group *target_core_call_addhbatotarget(
 	int ret;
 
 	if (strlen(name) >= TARGET_CORE_NAME_MAX_LEN) {
-		target_err("Passed *name strlen(): %d exceeds"
-			   " TARGET_CORE_NAME_MAX_LEN: %d\n",
+		target_err("Passed *name strlen(): %d exceeds TARGET_CORE_NAME_MAX_LEN: %d\n",
 			   (int)strlen(name), TARGET_CORE_NAME_MAX_LEN);
 		return ERR_PTR(-ENAMETOOLONG);
 	}
@@ -3588,9 +3515,7 @@ static struct config_group *target_core_call_addhbatotarget(
 
 	ret = kstrtoul(str, 0, &plugin_dep_id);
 	if (ret < 0) {
-		target_err("kstrtoul() returned %d for"
-			   " plugin_dep_id\n",
-			   ret);
+		target_err("kstrtoul() returned %d for plugin_dep_id\n", ret);
 		return ERR_PTR(ret);
 	}
 	/*
@@ -3673,9 +3598,8 @@ static int __init target_core_init_configfs(void)
 	const struct cred *old_cred;
 	int ret;
 
-	target_debug("TARGET_CORE[0]: Loading Generic Kernel Storage"
-		     " Engine: %s on %s/%s on " UTS_RELEASE "\n",
-		     TARGET_CORE_VERSION, utsname()->sysname, utsname()->machine);
+	target_debug("TARGET_CORE[0]: Loading Generic Kernel Storage Engine: %s on %s/%s on "
+		     UTS_RELEASE "\n", TARGET_CORE_VERSION, utsname()->sysname, utsname()->machine);
 
 	config_group_init(&subsys->su_group);
 	mutex_init(&subsys->su_mutex);
@@ -3729,9 +3653,8 @@ static int __init target_core_init_configfs(void)
 			   subsys->su_group.cg_item.ci_namebuf);
 		goto out_global;
 	}
-	target_debug("TARGET_CORE[0]: Initialized ConfigFS Fabric"
-		     " Infrastructure: " TARGET_CORE_VERSION " on %s/%s"
-		     " on " UTS_RELEASE "\n",
+	target_debug("TARGET_CORE[0]: Initialized ConfigFS Fabric Infrastructure: "
+		     TARGET_CORE_VERSION " on %s/%s on " UTS_RELEASE "\n",
 		     utsname()->sysname, utsname()->machine);
 	/*
 	 * Register built-in RAMDISK subsystem logic for virtual LUN 0
@@ -3790,8 +3713,7 @@ static void __exit target_core_exit_configfs(void)
 	core_alua_free_lu_gp(default_lu_gp);
 	default_lu_gp = NULL;
 
-	target_debug("TARGET_CORE[0]: Released ConfigFS Fabric"
-		     " Infrastructure\n");
+	target_debug("TARGET_CORE[0]: Released ConfigFS Fabric Infrastructure\n");
 
 	core_dev_release_virtual_lun0();
 	rd_module_exit();
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 7e530bdab04e..0317d77331c8 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -66,8 +66,7 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd)
 
 		if ((se_cmd->data_direction == DMA_TO_DEVICE) &&
 		    deve->lun_access_ro) {
-			target_err("TARGET_CORE[%s]: Detected WRITE_PROTECTED LUN"
-				   " Access for 0x%08llx\n",
+			target_err("TARGET_CORE[%s]: Detected WRITE_PROTECTED LUN Access for 0x%08llx\n",
 				   se_cmd->se_tfo->fabric_name, se_cmd->orig_fe_lun);
 			rcu_read_unlock();
 			return TCM_WRITE_PROTECTED;
@@ -95,8 +94,7 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd)
 		 * MappedLUN=0 exists for this Initiator Port.
 		 */
 		if (se_cmd->orig_fe_lun != 0) {
-			target_err("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
-				   " Access for 0x%08llx from %s\n",
+			target_err("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN Access for 0x%08llx from %s\n",
 				   se_cmd->se_tfo->fabric_name, se_cmd->orig_fe_lun,
 				   nacl->initiatorname);
 			return TCM_NON_EXISTENT_LUN;
@@ -164,8 +162,7 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd)
 	rcu_read_unlock();
 
 	if (!se_lun) {
-		target_debug("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
-			     " Access for 0x%08llx for %s\n",
+		target_debug("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN Access for 0x%08llx for %s\n",
 			     se_cmd->se_tfo->fabric_name, se_cmd->orig_fe_lun, nacl->initiatorname);
 		return -ENODEV;
 	}
@@ -208,8 +205,7 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
 		lun = deve->se_lun;
 		if (!lun) {
-			target_err("%s device entries device pointer is"
-				   " NULL, but Initiator has access.\n",
+			target_err("%s device entries device pointer is NULL, but Initiator has access.\n",
 				   tpg->se_tpg_tfo->fabric_name);
 			continue;
 		}
@@ -343,18 +339,14 @@ int core_enable_device_list_for_node(
 		struct se_lun *orig_lun = orig->se_lun;
 
 		if (orig_lun != lun) {
-			target_err("Existing orig->se_lun doesn't match new lun"
-				   " for dynamic -> explicit NodeACL conversion:"
-				   " %s\n",
+			target_err("Existing orig->se_lun doesn't match new lun for dynamic -> explicit NodeACL conversion: %s\n",
 				   nacl->initiatorname);
 			mutex_unlock(&nacl->lun_entry_mutex);
 			kfree(new);
 			return -EINVAL;
 		}
 		if (orig->se_lun_acl != NULL) {
-			target_warn_ratelimited("Detected existing explicit"
-						" se_lun_acl->se_lun_group reference for %s"
-						" mapped_lun: %llu, failing\n",
+			target_warn_ratelimited("Detected existing explicit se_lun_acl->se_lun_group reference for %s mapped_lun: %llu, failing\n",
 						nacl->initiatorname, mapped_lun);
 			mutex_unlock(&nacl->lun_entry_mutex);
 			kfree(new);
@@ -512,8 +504,7 @@ int core_dev_add_lun(
 	if (rc < 0)
 		return rc;
 
-	target_debug("%s_TPG[%u]_LUN[%llu] - Activated %s Logical Unit from"
-		     " CORE HBA: %u\n",
+	target_debug("%s_TPG[%u]_LUN[%llu] - Activated %s Logical Unit from CORE HBA: %u\n",
 		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
 		     lun->unpacked_lun, tpg->se_tpg_tfo->fabric_name, dev->se_hba->hba_id);
 	/*
@@ -545,8 +536,7 @@ void core_dev_del_lun(
 	struct se_portal_group *tpg,
 	struct se_lun *lun)
 {
-	target_debug("%s_TPG[%u]_LUN[%llu] - Deactivating %s Logical Unit from"
-		     " device object\n",
+	target_debug("%s_TPG[%u]_LUN[%llu] - Deactivating %s Logical Unit from device object\n",
 		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
 		     lun->unpacked_lun, tpg->se_tpg_tfo->fabric_name);
 
@@ -605,8 +595,7 @@ int core_dev_add_initiator_node_lun_acl(
 			lun_access_ro, nacl, tpg) < 0)
 		return -EINVAL;
 
-	target_debug("%s_TPG[%hu]_LUN[%llu->%llu] - Added %s ACL for "
-		     " InitiatorNode: %s\n",
+	target_debug("%s_TPG[%hu]_LUN[%llu->%llu] - Added %s ACL for  InitiatorNode: %s\n",
 		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
 		     lun->unpacked_lun, lacl->mapped_lun, lun_access_ro ? "RO" : "RW",
 		     nacl->initiatorname);
@@ -637,8 +626,7 @@ int core_dev_del_initiator_node_lun_acl(
 		core_disable_device_list_for_node(lun, deve, nacl, tpg);
 	mutex_unlock(&nacl->lun_entry_mutex);
 
-	target_debug("%s_TPG[%hu]_LUN[%llu] - Removed ACL for"
-		     " InitiatorNode: %s Mapped LUN: %llu\n",
+	target_debug("%s_TPG[%hu]_LUN[%llu] - Removed ACL for InitiatorNode: %s Mapped LUN: %llu\n",
 		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
 		     lun->unpacked_lun, nacl->initiatorname, lacl->mapped_lun);
 
@@ -649,8 +637,7 @@ void core_dev_free_initiator_node_lun_acl(
 	struct se_portal_group *tpg,
 	struct se_lun_acl *lacl)
 {
-	target_debug("%s_TPG[%hu] - Freeing ACL for %s InitiatorNode: %s"
-		     " Mapped LUN: %llu\n",
+	target_debug("%s_TPG[%hu] - Freeing ACL for %s InitiatorNode: %s Mapped LUN: %llu\n",
 		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
 		     tpg->se_tpg_tfo->fabric_name, lacl->se_lun_nacl->initiatorname,
 		     lacl->mapped_lun);
@@ -890,8 +877,7 @@ int target_configure_device(struct se_device *dev)
 	int ret, id;
 
 	if (target_dev_configured(dev)) {
-		target_err("se_dev->se_dev_ptr already set for storage"
-			   " object\n");
+		target_err("se_dev->se_dev_ptr already set for storage object\n");
 		return -EEXIST;
 	}
 
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index c2a4287361bd..f56baa63a278 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -90,8 +90,7 @@ static int target_fabric_mappedlun_link(
 		return -EINVAL;
 	}
 	if (lun->lun_shutdown) {
-		target_err("Unable to create mappedlun symlink because"
-			   " lun->lun_shutdown=true\n");
+		target_err("Unable to create mappedlun symlink because lun->lun_shutdown=true\n");
 		return -EINVAL;
 	}
 	se_tpg = lun->lun_tpg;
@@ -110,8 +109,7 @@ static int target_fabric_mappedlun_link(
 		return -EINVAL;
 	}
 	if (strcmp(config_item_name(tpg_ci), config_item_name(tpg_ci_s))) {
-		target_err("Illegal Initiator ACL Symlink outside of %s"
-			   " TPGT: %s\n",
+		target_err("Illegal Initiator ACL Symlink outside of %s TPGT: %s\n",
 			   config_item_name(wwn_ci), config_item_name(tpg_ci));
 		return -EINVAL;
 	}
@@ -194,8 +192,7 @@ static ssize_t target_fabric_mappedlun_write_protect_store(
 	/* wp=1 means lun_access_ro=true */
 	core_update_device_list_access(lacl->mapped_lun, wp, lacl->se_lun_nacl);
 
-	target_debug("%s_ConfigFS: Changed Initiator ACL: %s"
-		     " Mapped LUN: %llu Write Protect bit to %s\n",
+	target_debug("%s_ConfigFS: Changed Initiator ACL: %s Mapped LUN: %llu Write Protect bit to %s\n",
 		     se_tpg->se_tpg_tfo->fabric_name, se_nacl->initiatorname, lacl->mapped_lun,
 		     (wp) ? "ON" : "OFF");
 
@@ -285,9 +282,7 @@ static struct config_group *target_fabric_make_mappedlun(
 	 * Make sure user is creating iscsi/$IQN/$TPGT/acls/$INITIATOR/lun_$ID.
 	 */
 	if (strstr(buf, "lun_") != buf) {
-		target_err("Unable to locate \"lun_\" from buf: %s"
-			   " name: %s\n",
-			   buf, name);
+		target_err("Unable to locate \"lun_\" from buf: %s name: %s\n", buf, name);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -750,8 +745,7 @@ static struct config_group *target_fabric_make_lun(
 	int errno;
 
 	if (strstr(name, "lun_") != name) {
-		target_err("Unable to locate \'_\" in"
-			   " \"lun_$LUN_NUMBER\"\n");
+		target_err("Unable to locate \'_\" in \"lun_$LUN_NUMBER\"\n");
 		return ERR_PTR(-EINVAL);
 	}
 	errno = kstrtoull(name + 4, 0, &unpacked_lun);
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 9e619e0028ce..c0fda2769553 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -280,8 +280,7 @@ static char *iscsi_parse_pr_out_transport_id(
 	 *            Reserved
 	 */
 	if ((format_code != 0x00) && (format_code != 0x40)) {
-		target_err("Illegal format code: 0x%02x for iSCSI"
-			   " Initiator Transport ID\n",
+		target_err("Illegal format code: 0x%02x for iSCSI Initiator Transport ID\n",
 			   format_code);
 		return NULL;
 	}
@@ -304,8 +303,7 @@ static char *iscsi_parse_pr_out_transport_id(
 	if (format_code == 0x40) {
 		p = strstr(&buf[4], ",i,0x");
 		if (!p) {
-			target_err("Unable to locate \",i,0x\" separator"
-				   " for Initiator port identifier: %s\n",
+			target_err("Unable to locate \",i,0x\" separator for Initiator port identifier: %s\n",
 				   &buf[4]);
 			return NULL;
 		}
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index e1ac26e2f35a..902e68447c24 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -48,8 +48,7 @@ static int fd_attach_hba(struct se_hba *hba, u32 host_id)
 
 	hba->hba_ptr = fd_host;
 
-	target_debug("CORE_HBA[%d] - TCM FILEIO HBA Driver %s on Generic"
-		     " Target Core Stack %s\n",
+	target_debug("CORE_HBA[%d] - TCM FILEIO HBA Driver %s on Generic Target Core Stack %s\n",
 		     hba->hba_id, FD_VERSION, TARGET_CORE_VERSION);
 	target_debug("CORE_HBA[%d] - Attached FILEIO HBA: %u to Generic\n", hba->hba_id,
 		     fd_host->fd_host_id);
@@ -61,8 +60,7 @@ static void fd_detach_hba(struct se_hba *hba)
 {
 	struct fd_host *fd_host = hba->hba_ptr;
 
-	target_debug("CORE_HBA[%d] - Detached FILEIO HBA: %u from Generic"
-		     " Target Core\n",
+	target_debug("CORE_HBA[%d] - Detached FILEIO HBA: %u from Generic Target Core\n",
 		     hba->hba_id, fd_host->fd_host_id);
 
 	kfree(fd_host);
@@ -164,8 +162,7 @@ static int fd_configure_device(struct se_device *dev)
 		dev_size = (i_size_read(file->f_mapping->host) -
 				       fd_dev->fd_block_size);
 
-		target_debug("FILEIO: Using size: %llu bytes from struct"
-			     " block_device blocks: %llu logical_block_size: %d\n",
+		target_debug("FILEIO: Using size: %llu bytes from struct block_device blocks: %llu logical_block_size: %d\n",
 			     dev_size, div_u64(dev_size, fd_dev->fd_block_size),
 			     fd_dev->fd_block_size);
 		/*
@@ -178,9 +175,7 @@ static int fd_configure_device(struct se_device *dev)
 			dev->dev_attrib.is_nonrot = 1;
 	} else {
 		if (!(fd_dev->fbd_flags & FBDF_HAS_SIZE)) {
-			target_err("FILEIO: Missing fd_dev_size="
-				   " parameter, and no backing struct"
-				   " block_device\n");
+			target_err("FILEIO: Missing fd_dev_size= parameter, and no backing struct block_device\n");
 			goto fail;
 		}
 
@@ -198,16 +193,14 @@ static int fd_configure_device(struct se_device *dev)
 	dev->dev_attrib.hw_queue_depth = FD_MAX_DEVICE_QUEUE_DEPTH;
 
 	if (fd_dev->fbd_flags & FDBD_HAS_BUFFERED_IO_WCE) {
-		target_debug("FILEIO: Forcing setting of emulate_write_cache=1"
-			     " with FDBD_HAS_BUFFERED_IO_WCE\n");
+		target_debug("FILEIO: Forcing setting of emulate_write_cache=1 with FDBD_HAS_BUFFERED_IO_WCE\n");
 		dev->dev_attrib.emulate_write_cache = 1;
 	}
 
 	fd_dev->fd_dev_id = fd_host->fd_host_dev_id_count++;
 	fd_dev->fd_queue_depth = dev->queue_depth;
 
-	target_debug("CORE_FILE[%u] - Added TCM FILEIO Device ID: %u at %s,"
-		     " %llu total bytes\n",
+	target_debug("CORE_FILE[%u] - Added TCM FILEIO Device ID: %u at %s, %llu total bytes\n",
 		     fd_host->fd_host_id, fd_dev->fd_dev_id, fd_dev->fd_dev_name,
 		     fd_dev->fd_dev_size);
 
@@ -353,9 +346,8 @@ static int fd_do_rw(struct se_cmd *cmd, struct file *fd,
 		 */
 		if (S_ISBLK(file_inode(fd)->i_mode)) {
 			if (ret < 0 || ret != data_length) {
-				target_err("%s() returned %d, expecting %u for "
-					   "S_ISBLK\n",
-					   __func__, ret, data_length);
+				target_err("%s() returned %d, expecting %u for S_ISBLK\n", __func__,
+					   ret, data_length);
 				if (ret >= 0)
 					ret = -EINVAL;
 			}
@@ -438,8 +430,7 @@ fd_execute_write_same(struct se_cmd *cmd)
 	ssize_t ret;
 
 	if (cmd->prot_op) {
-		target_err("WRITE_SAME: Protection information with FILEIO"
-			   " backends not supported\n");
+		target_err("WRITE_SAME: Protection information with FILEIO backends not supported\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
@@ -448,8 +439,7 @@ fd_execute_write_same(struct se_cmd *cmd)
 
 	if (cmd->t_data_nents > 1 ||
 	    cmd->t_data_sg[0].length != cmd->se_dev->dev_attrib.block_size) {
-		target_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
-			   " block_size: %u\n",
+		target_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u block_size: %u\n",
 			   cmd->t_data_nents, cmd->t_data_sg[0].length,
 			   cmd->se_dev->dev_attrib.block_size);
 		return TCM_INVALID_CDB_FIELD;
@@ -675,8 +665,7 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	 * single vfs_[writev,readv] call.
 	 */
 	if (cmd->data_length > FD_MAX_BYTES) {
-		target_err("FILEIO: Not able to process I/O of %u bytes due to"
-			   "FD_MAX_BYTES: %u iovec count limitation\n",
+		target_err("FILEIO: Not able to process I/O of %u bytes due to FD_MAX_BYTES: %u iovec count limitation\n",
 			   cmd->data_length, FD_MAX_BYTES);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
@@ -737,13 +726,10 @@ static ssize_t fd_set_configfs_dev_params(struct se_device *dev,
 			ret = kstrtoull(arg_p, 0, &fd_dev->fd_dev_size);
 			kfree(arg_p);
 			if (ret < 0) {
-				target_err("kstrtoull() failed for"
-					   " fd_dev_size=\n");
+				target_err("kstrtoull() failed for fd_dev_size=\n");
 				goto out;
 			}
-			target_debug("FILEIO: Referencing Size: %llu"
-				     " bytes\n",
-				     fd_dev->fd_dev_size);
+			target_debug("FILEIO: Referencing Size: %llu bytes\n", fd_dev->fd_dev_size);
 			fd_dev->fbd_flags |= FBDF_HAS_SIZE;
 			break;
 		case Opt_fd_buffered_io:
@@ -756,8 +742,7 @@ static ssize_t fd_set_configfs_dev_params(struct se_device *dev,
 				goto out;
 			}
 
-			target_debug("FILEIO: Using buffered I/O"
-				     " operations for struct fd_dev\n");
+			target_debug("FILEIO: Using buffered I/O operations for struct fd_dev\n");
 
 			fd_dev->fbd_flags |= FDBD_HAS_BUFFERED_IO_WCE;
 			break;
@@ -771,8 +756,7 @@ static ssize_t fd_set_configfs_dev_params(struct se_device *dev,
 				goto out;
 			}
 
-			target_debug("FILEIO: Using async I/O"
-				     " operations for struct fd_dev\n");
+			target_debug("FILEIO: Using async I/O operations for struct fd_dev\n");
 
 			fd_dev->fbd_flags |= FDBD_HAS_ASYNC_IO;
 			break;
@@ -835,8 +819,7 @@ static int fd_init_prot(struct se_device *dev)
 
 	inode = file->f_mapping->host;
 	if (S_ISBLK(inode->i_mode)) {
-		target_err("FILEIO Protection emulation only supported on"
-			   " !S_ISBLK\n");
+		target_err("FILEIO Protection emulation only supported on !S_ISBLK\n");
 		return -ENOSYS;
 	}
 
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index 02501fd45b24..0edb17711a52 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -138,9 +138,7 @@ core_alloc_hba(const char *plugin_name, u32 plugin_dep_id, u32 hba_flags)
 	list_add_tail(&hba->hba_node, &hba_list);
 	spin_unlock(&hba_lock);
 
-	target_debug("CORE_HBA[%d] - Attached HBA to Generic Target"
-		     " Core\n",
-		     hba->hba_id);
+	target_debug("CORE_HBA[%d] - Attached HBA to Generic Target Core\n", hba->hba_id);
 
 	return hba;
 
@@ -163,9 +161,7 @@ core_delete_hba(struct se_hba *hba)
 	list_del(&hba->hba_node);
 	spin_unlock(&hba_lock);
 
-	target_debug("CORE_HBA[%d] - Detached HBA from Generic Target"
-		     " Core\n",
-		     hba->hba_id);
+	target_debug("CORE_HBA[%d] - Detached HBA from Generic Target Core\n", hba->hba_id);
 
 	module_put(hba->backend->ops->owner);
 
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 843f5903e390..1731fa059d4d 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -45,8 +45,7 @@ static inline struct iblock_dev *IBLOCK_DEV(struct se_device *dev)
 
 static int iblock_attach_hba(struct se_hba *hba, u32 host_id)
 {
-	target_debug("CORE_HBA[%d] - TCM iBlock HBA Driver %s on"
-		     " Generic Target Core Stack %s\n",
+	target_debug("CORE_HBA[%d] - TCM iBlock HBA Driver %s on Generic Target Core Stack %s\n",
 		     hba->hba_id, IBLOCK_VERSION, TARGET_CORE_VERSION);
 	return 0;
 }
@@ -504,8 +503,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 					sbc_get_write_same_sectors(cmd));
 
 	if (cmd->prot_op) {
-		target_err("WRITE_SAME: Protection information with IBLOCK"
-			   " backends not supported\n");
+		target_err("WRITE_SAME: Protection information with IBLOCK backends not supported\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
@@ -516,8 +514,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 
 	if (cmd->t_data_nents > 1 ||
 	    sg->length != cmd->se_dev->dev_attrib.block_size) {
-		target_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
-			   " block_size: %u\n",
+		target_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u block_size: %u\n",
 			   cmd->t_data_nents, sg->length, cmd->se_dev->dev_attrib.block_size);
 		return TCM_INVALID_CDB_FIELD;
 	}
@@ -604,8 +601,7 @@ static ssize_t iblock_set_configfs_dev_params(struct se_device *dev,
 		switch (token) {
 		case Opt_udev_path:
 			if (ib_dev->ibd_bd) {
-				target_err("Unable to set udev_path= while"
-					   " ib_dev->ibd_bd exists\n");
+				target_err("Unable to set udev_path= while ib_dev->ibd_bd exists\n");
 				ret = -EEXIST;
 				goto out;
 			}
@@ -626,8 +622,7 @@ static ssize_t iblock_set_configfs_dev_params(struct se_device *dev,
 			ret = kstrtoul(arg_p, 0, &tmp_readonly);
 			kfree(arg_p);
 			if (ret < 0) {
-				target_err("kstrtoul() failed for"
-					   " readonly=\n");
+				target_err("kstrtoul() failed for readonly=\n");
 				goto out;
 			}
 			ib_dev->ibd_readonly = tmp_readonly;
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index a2d0bc1da2bd..c2c6fd957dff 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -178,9 +178,7 @@ static int target_check_scsi2_reservation_conflict(struct se_cmd *cmd)
 	}
 
 	if (conflict) {
-		target_err("Received legacy SPC-2 RESERVE/RELEASE"
-			   " while active SPC-3 registrations exist,"
-			   " returning RESERVATION_CONFLICT\n");
+		target_err("Received legacy SPC-2 RESERVE/RELEASE while active SPC-3 registrations exist, returning RESERVATION_CONFLICT\n");
 		return -EBUSY;
 	}
 
@@ -225,8 +223,7 @@ target_scsi2_reservation_release(struct se_cmd *cmd)
 
 	target_release_reservation(dev);
 	tpg = sess->se_tpg;
-	target_debug("SCSI-2 Released reservation for %s LUN: %llu ->"
-		     " MAPPED LUN: %llu for %s\n",
+	target_debug("SCSI-2 Released reservation for %s LUN: %llu -> MAPPED LUN: %llu for %s\n",
 		     tpg->se_tpg_tfo->fabric_name, cmd->se_lun->unpacked_lun, cmd->orig_fe_lun,
 		     sess->se_node_acl->initiatorname);
 
@@ -272,8 +269,7 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 			   tpg->se_tpg_tfo->fabric_name);
 		target_err("Original reserver LUN: %llu %s\n", cmd->se_lun->unpacked_lun,
 			   dev->reservation_holder->se_node_acl->initiatorname);
-		target_err("Current attempt - LUN: %llu -> MAPPED LUN: %llu"
-			   " from %s \n",
+		target_err("Current attempt - LUN: %llu -> MAPPED LUN: %llu from %s\n",
 			   cmd->se_lun->unpacked_lun, cmd->orig_fe_lun,
 			   sess->se_node_acl->initiatorname);
 		ret = TCM_RESERVATION_CONFLICT;
@@ -286,8 +282,7 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 		dev->dev_res_bin_isid = sess->sess_bin_isid;
 		dev->dev_reservation_flags |= DRF_SPC2_RESERVATIONS_WITH_ISID;
 	}
-	target_debug("SCSI-2 Reserved %s LUN: %llu -> MAPPED LUN: %llu"
-		     " for %s\n",
+	target_debug("SCSI-2 Reserved %s LUN: %llu -> MAPPED LUN: %llu for %s\n",
 		     tpg->se_tpg_tfo->fabric_name, cmd->se_lun->unpacked_lun, cmd->orig_fe_lun,
 		     sess->se_node_acl->initiatorname);
 
@@ -411,8 +406,7 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 			ret = (registered_nexus) ? 0 : 1;
 			break;
 		default:
-			target_err("Unknown PERSISTENT_RESERVE_OUT service"
-				   " action: 0x%02x\n",
+			target_err("Unknown PERSISTENT_RESERVE_OUT service action: 0x%02x\n",
 				   cdb[1] & 0x1f);
 			return -EINVAL;
 		}
@@ -483,9 +477,8 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 	 * statement.
 	 */
 	if (!ret && !other_cdb) {
-		target_debug("Allowing explicit CDB: 0x%02x for %s"
-			     " reservation holder\n",
-			     cdb[0], core_scsi3_pr_dump_type(pr_reg_type));
+		target_debug("Allowing explicit CDB: 0x%02x for %s reservation holder\n", cdb[0],
+			     core_scsi3_pr_dump_type(pr_reg_type));
 
 		return ret;
 	}
@@ -498,8 +491,7 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 			/*
 			 * Conflict for write exclusive
 			 */
-			target_debug("%s Conflict for unregistered nexus"
-				     " %s CDB: 0x%02x to %s reservation\n",
+			target_debug("%s Conflict for unregistered nexus %s CDB: 0x%02x to %s reservation\n",
 				     transport_dump_cmd_direction(cmd),
 				     se_sess->se_node_acl->initiatorname, cdb[0],
 				     core_scsi3_pr_dump_type(pr_reg_type));
@@ -516,9 +508,7 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 			 */
 
 			if (!registered_nexus) {
-				target_debug("Allowing implicit CDB: 0x%02x"
-					     " for %s reservation on unregistered"
-					     " nexus\n",
+				target_debug("Allowing implicit CDB: 0x%02x for %s reservation on unregistered nexus\n",
 					     cdb[0], core_scsi3_pr_dump_type(pr_reg_type));
 			}
 
@@ -531,9 +521,8 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 			 * allow commands from registered nexuses.
 			 */
 
-			target_debug("Allowing implicit CDB: 0x%02x for %s"
-				     " reservation\n",
-				     cdb[0], core_scsi3_pr_dump_type(pr_reg_type));
+			target_debug("Allowing implicit CDB: 0x%02x for %s reservation\n", cdb[0],
+				     core_scsi3_pr_dump_type(pr_reg_type));
 
 			return 0;
 		}
@@ -543,15 +532,13 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
                 * from all registrants.
                 */
                if (cmd->data_direction == DMA_FROM_DEVICE) {
-			target_debug("Allowing READ CDB: 0x%02x for %s"
-				     " reservation\n",
-				     cdb[0], core_scsi3_pr_dump_type(pr_reg_type));
+			target_debug("Allowing READ CDB: 0x%02x for %s reservation\n", cdb[0],
+				     core_scsi3_pr_dump_type(pr_reg_type));
 
                        return 0;
                }
 	}
-	target_debug("%s Conflict for %sregistered nexus %s CDB: 0x%2x"
-		     " for %s reservation\n",
+	target_debug("%s Conflict for %sregistered nexus %s CDB: 0x%2x for %s reservation\n",
 		     transport_dump_cmd_direction(cmd), (registered_nexus) ? "" : "un",
 		     se_sess->se_node_acl->initiatorname, cdb[0],
 		     core_scsi3_pr_dump_type(pr_reg_type));
@@ -769,8 +756,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 			 */
 			ret = core_scsi3_lunacl_depend_item(deve_tmp);
 			if (ret < 0) {
-				target_err("core_scsi3_lunacl_depend"
-					   "_item() failed\n");
+				target_err("core_scsi3_lunacl_depend_item() failed\n");
 				percpu_ref_put(&lun_tmp->lun_ref);
 				kref_put(&deve_tmp->pr_kref, target_pr_kref_release);
 				goto out;
@@ -882,8 +868,7 @@ int core_scsi3_alloc_aptpl_registration(
 	pr_reg->pr_res_holder = res_holder;
 
 	list_add_tail(&pr_reg->pr_reg_aptpl_list, &pr_tmpl->aptpl_reg_list);
-	target_debug("SPC-3 PR APTPL Successfully added registration%s from"
-		     " metadata\n",
+	target_debug("SPC-3 PR APTPL Successfully added registration%s from metadata\n",
 		     (res_holder) ? "+reservation" : "");
 	return 0;
 }
@@ -902,8 +887,7 @@ static void core_scsi3_aptpl_reserve(
 	dev->dev_pr_res_holder = pr_reg;
 	spin_unlock(&dev->dev_reservation_lock);
 
-	target_debug("SPC-3 PR [%s] Service Action: APTPL RESERVE created"
-		     " new reservation holder TYPE: %s ALL_TG_PT: %d\n",
+	target_debug("SPC-3 PR [%s] Service Action: APTPL RESERVE created new reservation holder TYPE: %s ALL_TG_PT: %d\n",
 		     tpg->se_tpg_tfo->fabric_name, core_scsi3_pr_dump_type(pr_reg->pr_res_type),
 		     (pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
 	target_debug("SPC-3 PR [%s] RESERVE Node: %s%s\n", tpg->se_tpg_tfo->fabric_name,
@@ -956,8 +940,7 @@ static int __core_scsi3_check_aptpl_registration(
 			rcu_read_lock();
 			pr_reg->pr_reg_deve = target_nacl_find_deve(nacl, mapped_lun);
 			if (!pr_reg->pr_reg_deve) {
-				target_err("Unable to locate PR APTPL %s mapped_lun:"
-					   " %llu\n",
+				target_err("Unable to locate PR APTPL %s mapped_lun: %llu\n",
 					   nacl->initiatorname, mapped_lun);
 				rcu_read_unlock();
 				continue;
@@ -1021,18 +1004,16 @@ static void __core_scsi3_dump_registration(
 
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 
-	target_debug("SPC-3 PR [%s] Service Action: REGISTER%s Initiator"
-		     " Node: %s%s\n", tfo->fabric_name, (register_type == REGISTER_AND_MOVE) ?
+	target_debug("SPC-3 PR [%s] Service Action: REGISTER%s Initiator Node: %s%s\n",
+		     tfo->fabric_name, (register_type == REGISTER_AND_MOVE) ?
 		     "_AND_MOVE" : (register_type == REGISTER_AND_IGNORE_EXISTING_KEY) ?
 		     "_AND_IGNORE_EXISTING_KEY" : "", nacl->initiatorname, i_buf);
 	target_debug("SPC-3 PR [%s] registration on Target Port: %s,0x%04x\n", tfo->fabric_name,
 		     tfo->tpg_get_wwn(se_tpg), tfo->tpg_get_tag(se_tpg));
-	target_debug("SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
-		     " Port(s)\n",
+	target_debug("SPC-3 PR [%s] for %s TCM Subsystem %s Object Target Port(s)\n",
 		     tfo->fabric_name, (pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
 		     dev->transport->name);
-	target_debug("SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration:"
-		     " 0x%08x  APTPL: %d\n",
+	target_debug("SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration: 0x%08x  APTPL: %d\n",
 		     tfo->fabric_name, pr_reg->pr_res_key, pr_reg->pr_res_generation,
 		     pr_reg->pr_reg_aptpl);
 }
@@ -1252,10 +1233,7 @@ static int core_scsi3_check_implicit_release(
 		  (!strcmp(pr_res_holder->pr_reg_nacl->initiatorname,
 			  pr_reg->pr_reg_nacl->initiatorname)) &&
 		  (pr_res_holder->pr_res_key == pr_reg->pr_res_key)) {
-		target_err("SPC-3 PR: Unable to perform ALL_TG_PT=1"
-			   " UNREGISTER while existing reservation with matching"
-			   " key 0x%016Lx is present from another SCSI Initiator"
-			   " Port\n",
+		target_err("SPC-3 PR: Unable to perform ALL_TG_PT=1 UNREGISTER while existing reservation with matching key 0x%016Lx is present from another SCSI Initiator Port\n",
 			   pr_reg->pr_res_key);
 		ret = -EPERM;
 	}
@@ -1311,16 +1289,13 @@ static void __core_scsi3_free_registration(
 	rcu_read_unlock();
 
 	spin_lock(&pr_tmpl->registration_lock);
-	target_debug("SPC-3 PR [%s] Service Action: UNREGISTER Initiator"
-		     " Node: %s%s\n",
+	target_debug("SPC-3 PR [%s] Service Action: UNREGISTER Initiator Node: %s%s\n",
 		     tfo->fabric_name, pr_reg->pr_reg_nacl->initiatorname, i_buf);
-	target_debug("SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
-		     " Port(s)\n",
+	target_debug("SPC-3 PR [%s] for %s TCM Subsystem %s Object Target Port(s)\n",
 		     tfo->fabric_name, (pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
 		     dev->transport->name);
-	target_debug("SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration:"
-		     " 0x%08x\n",
-		     tfo->fabric_name, pr_reg->pr_res_key, pr_reg->pr_res_generation);
+	target_debug("SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration: 0x%08x\n", tfo->fabric_name,
+		     pr_reg->pr_res_key, pr_reg->pr_res_generation);
 
 	if (!preempt_and_abort_list) {
 		pr_reg->pr_reg_deve = NULL;
@@ -1514,8 +1489,7 @@ core_scsi3_decode_spec_i_port(
 	list_add_tail(&tidh_new->dest_list, &tid_dest_list);
 
 	if (cmd->data_length < 28) {
-		target_warn("SPC-PR: Received PR OUT parameter list"
-			    " length too small: %u\n",
+		target_warn("SPC-PR: Received PR OUT parameter list length too small: %u\n",
 			    cmd->data_length);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
@@ -1535,8 +1509,7 @@ core_scsi3_decode_spec_i_port(
 	tpdl = get_unaligned_be32(&buf[24]);
 
 	if ((tpdl + 28) != cmd->data_length) {
-		target_err("SPC-3 PR: Illegal tpdl: %u + 28 byte header"
-			   " does not equal CDB data_length: %u\n",
+		target_err("SPC-3 PR: Illegal tpdl: %u + 28 byte header does not equal CDB data_length: %u\n",
 			   tpdl, cmd->data_length);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_unmap;
@@ -1590,8 +1563,7 @@ core_scsi3_decode_spec_i_port(
 			spin_unlock(&dev->se_port_lock);
 
 			if (core_scsi3_tpg_depend_item(tmp_tpg)) {
-				target_err(" core_scsi3_tpg_depend_item()"
-					   " for tmp_tpg\n");
+				target_err(" core_scsi3_tpg_depend_item() for tmp_tpg\n");
 				atomic_dec_mb(&tmp_tpg->tpg_pr_ref_count);
 				ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 				goto out_unmap;
@@ -1615,8 +1587,7 @@ core_scsi3_decode_spec_i_port(
 			}
 
 			if (core_scsi3_nodeacl_depend_item(dest_node_acl)) {
-				target_err("configfs_depend_item() failed"
-					   " for dest_node_acl->acl_group\n");
+				target_err("configfs_depend_item() failed for dest_node_acl->acl_group\n");
 				atomic_dec_mb(&dest_node_acl->acl_pr_ref_count);
 				core_scsi3_tpg_undepend_item(tmp_tpg);
 				ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -1634,20 +1605,17 @@ core_scsi3_decode_spec_i_port(
 		spin_unlock(&dev->se_port_lock);
 
 		if (!dest_tpg) {
-			target_err("SPC-3 PR SPEC_I_PT: Unable to locate"
-				   " dest_tpg\n");
+			target_err("SPC-3 PR SPEC_I_PT: Unable to locate dest_tpg\n");
 			ret = TCM_INVALID_PARAMETER_LIST;
 			goto out_unmap;
 		}
 
-		target_debug("SPC-3 PR SPEC_I_PT: Got %s data_length: %u tpdl: %u"
-			     " tid_len: %d for %s + %s\n",
+		target_debug("SPC-3 PR SPEC_I_PT: Got %s data_length: %u tpdl: %u tid_len: %d for %s + %s\n",
 			     dest_tpg->se_tpg_tfo->fabric_name, cmd->data_length, tpdl, tid_len,
 			     i_str, iport_ptr);
 
 		if (tid_len > tpdl) {
-			target_err("SPC-3 PR SPEC_I_PT: Illegal tid_len:"
-				   " %u for Transport ID: %s\n",
+			target_err("SPC-3 PR SPEC_I_PT: Illegal tid_len: %u for Transport ID: %s\n",
 				   tid_len, ptr);
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
@@ -1672,8 +1640,7 @@ core_scsi3_decode_spec_i_port(
 		}
 
 		if (core_scsi3_lunacl_depend_item(dest_se_deve)) {
-			target_err("core_scsi3_lunacl_depend_item()"
-				   " failed\n");
+			target_err("core_scsi3_lunacl_depend_item() failed\n");
 			kref_put(&dest_se_deve->pr_kref, target_pr_kref_release);
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
@@ -1681,8 +1648,7 @@ core_scsi3_decode_spec_i_port(
 			goto out_unmap;
 		}
 
-		target_debug("SPC-3 PR SPEC_I_PT: Located %s Node: %s"
-			     " dest_se_deve mapped_lun: %llu\n",
+		target_debug("SPC-3 PR SPEC_I_PT: Located %s Node: %s dest_se_deve mapped_lun: %llu\n",
 			     dest_tpg->se_tpg_tfo->fabric_name, dest_node_acl->initiatorname,
 			     dest_se_deve->mapped_lun);
 
@@ -1791,9 +1757,7 @@ core_scsi3_decode_spec_i_port(
 		__core_scsi3_add_registration(cmd->se_dev, dest_node_acl,
 					dest_pr_reg, 0, 0);
 
-		target_debug("SPC-3 PR [%s] SPEC_I_PT: Successfully"
-			     " registered Transport ID for Node: %s%s Mapped LUN:"
-			     " %llu\n",
+		target_debug("SPC-3 PR [%s] SPEC_I_PT: Successfully registered Transport ID for Node: %s%s Mapped LUN: %llu\n",
 			     dest_tpg->se_tpg_tfo->fabric_name, dest_node_acl->initiatorname, i_buf,
 			     (dest_se_deve) ? dest_se_deve->mapped_lun : 0);
 
@@ -1908,8 +1872,7 @@ static int core_scsi3_update_aptpl_buf(
 		}
 
 		if ((len + strlen(tmp) >= pr_aptpl_buf_len)) {
-			target_err("Unable to update renaming APTPL metadata,"
-				   " reallocating larger buffer\n");
+			target_err("Unable to update renaming APTPL metadata, reallocating larger buffer\n");
 			ret = -EMSGSIZE;
 			goto out;
 		}
@@ -1927,8 +1890,7 @@ static int core_scsi3_update_aptpl_buf(
 			reg_count);
 
 		if ((len + strlen(tmp) >= pr_aptpl_buf_len)) {
-			target_err("Unable to update renaming APTPL metadata,"
-				   " reallocating larger buffer\n");
+			target_err("Unable to update renaming APTPL metadata, reallocating larger buffer\n");
 			ret = -EMSGSIZE;
 			goto out;
 		}
@@ -1965,9 +1927,7 @@ static int __core_scsi3_write_aptpl_to_file(
 
 	file = filp_open(path, flags, 0600);
 	if (IS_ERR(file)) {
-		target_err("filp_open(%s) for APTPL metadata"
-			   " failed\n",
-			   path);
+		target_err("filp_open(%s) for APTPL metadata failed\n", path);
 		kfree(path);
 		return PTR_ERR(file);
 	}
@@ -2061,8 +2021,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 	pr_reg = core_scsi3_locate_pr_reg(dev, se_sess->se_node_acl, se_sess);
 	if (!pr_reg) {
 		if (res_key) {
-			target_warn("SPC-3 PR: Reservation Key non-zero"
-				    " for SA REGISTER, returning CONFLICT\n");
+			target_warn("SPC-3 PR: Reservation Key non-zero for SA REGISTER, returning CONFLICT\n");
 			return TCM_RESERVATION_CONFLICT;
 		}
 		/*
@@ -2082,8 +2041,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 					NULL, cmd->orig_fe_lun, isid_ptr,
 					sa_res_key, all_tg_pt, aptpl,
 					register_type, 0)) {
-				target_err("Unable to allocate"
-					   " struct t10_pr_registration\n");
+				target_err("Unable to allocate struct t10_pr_registration\n");
 				return TCM_INSUFFICIENT_REGISTRATION_RESOURCES;
 			}
 		} else {
@@ -2106,18 +2064,14 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 	/* ok, existing registration */
 
 	if ((register_type == REGISTER) && (res_key != pr_reg->pr_res_key)) {
-		target_err("SPC-3 PR REGISTER: Received"
-			   " res_key: 0x%016Lx does not match"
-			   " existing SA REGISTER res_key:"
-			   " 0x%016Lx\n",
+		target_err("SPC-3 PR REGISTER: Received res_key: 0x%016Lx does not match existing SA REGISTER res_key: 0x%016Lx\n",
 			   res_key, pr_reg->pr_res_key);
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out;
 	}
 
 	if (spec_i_pt) {
-		target_err("SPC-3 PR REGISTER: SPEC_I_PT"
-			   " set on a registered nexus\n");
+		target_err("SPC-3 PR REGISTER: SPEC_I_PT set on a registered nexus\n");
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
@@ -2127,9 +2081,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 	 * must also set ALL_TG_PT=1 in the incoming PROUT.
 	 */
 	if (pr_reg->pr_reg_all_tg_pt && !all_tg_pt) {
-		target_err("SPC-3 PR REGISTER: ALL_TG_PT=1"
-			   " registration exists, but ALL_TG_PT=1 bit not"
-			   " present in received PROUT\n");
+		target_err("SPC-3 PR REGISTER: ALL_TG_PT=1 registration exists, but ALL_TG_PT=1 bit not present in received PROUT\n");
 		ret = TCM_INVALID_CDB_FIELD;
 		goto out;
 	}
@@ -2145,9 +2097,8 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 		 */
 		pr_reg->pr_res_generation = core_scsi3_pr_generation(cmd->se_dev);
 		pr_reg->pr_res_key = sa_res_key;
-		target_debug("SPC-3 PR [%s] REGISTER%s: Changed Reservation"
-			     " Key for %s to: 0x%016Lx PRgeneration:"
-			     " 0x%08x\n", cmd->se_tfo->fabric_name,
+		target_debug("SPC-3 PR [%s] REGISTER%s: Changed Reservation Key for %s to: 0x%016Lx PRgeneration: 0x%08x\n",
+			     cmd->se_tfo->fabric_name,
 			     (register_type == REGISTER_AND_IGNORE_EXISTING_KEY) ?
 			     "_AND_IGNORE_EXISTING_KEY" : "", pr_reg->pr_reg_nacl->initiatorname,
 			     pr_reg->pr_res_key, pr_reg->pr_res_generation);
@@ -2275,8 +2226,7 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 	pr_reg = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
 				se_sess);
 	if (!pr_reg) {
-		target_err("SPC-3 PR: Unable to locate"
-			   " PR_REGISTERED *pr_reg for RESERVE\n");
+		target_err("SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RESERVE\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	/*
@@ -2289,9 +2239,7 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 	 * 	 registered with the logical unit for the I_T nexus; and
 	 */
 	if (res_key != pr_reg->pr_res_key) {
-		target_err("SPC-3 PR RESERVE: Received res_key: 0x%016Lx"
-			   " does not match existing SA REGISTER res_key:"
-			   " 0x%016Lx\n",
+		target_err("SPC-3 PR RESERVE: Received res_key: 0x%016Lx does not match existing SA REGISTER res_key: 0x%016Lx\n",
 			   res_key, pr_reg->pr_res_key);
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out_put_pr_reg;
@@ -2331,9 +2279,7 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 		 */
 		if (!is_reservation_holder(pr_res_holder, pr_reg)) {
 			struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
-			target_err("SPC-3 PR: Attempted RESERVE from"
-				   " [%s]: %s while reservation already held by"
-				   " [%s]: %s, returning RESERVATION_CONFLICT\n",
+			target_err("SPC-3 PR: Attempted RESERVE from [%s]: %s while reservation already held by [%s]: %s, returning RESERVATION_CONFLICT\n",
 				   cmd->se_tfo->fabric_name, se_sess->se_node_acl->initiatorname,
 				   pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
 				   pr_res_holder->pr_reg_nacl->initiatorname);
@@ -2352,10 +2298,7 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 		if ((pr_res_holder->pr_res_type != type) ||
 		    (pr_res_holder->pr_res_scope != scope)) {
 			struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
-			target_err("SPC-3 PR: Attempted RESERVE from"
-				   " [%s]: %s trying to change TYPE and/or SCOPE,"
-				   " while reservation already held by [%s]: %s,"
-				   " returning RESERVATION_CONFLICT\n",
+			target_err("SPC-3 PR: Attempted RESERVE from [%s]: %s trying to change TYPE and/or SCOPE, while reservation already held by [%s]: %s, returning RESERVATION_CONFLICT\n",
 				   cmd->se_tfo->fabric_name, se_sess->se_node_acl->initiatorname,
 				   pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
 				   pr_res_holder->pr_reg_nacl->initiatorname);
@@ -2388,8 +2331,7 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 	dev->dev_pr_res_holder = pr_reg;
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 
-	target_debug("SPC-3 PR [%s] Service Action: RESERVE created new"
-		     " reservation holder TYPE: %s ALL_TG_PT: %d\n",
+	target_debug("SPC-3 PR [%s] Service Action: RESERVE created new reservation holder TYPE: %s ALL_TG_PT: %d\n",
 		     cmd->se_tfo->fabric_name, core_scsi3_pr_dump_type(type),
 		     (pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
 	target_debug("SPC-3 PR [%s] RESERVE Node: %s%s\n", cmd->se_tfo->fabric_name,
@@ -2418,9 +2360,7 @@ core_scsi3_emulate_pro_reserve(struct se_cmd *cmd, int type, int scope,
 	case PR_TYPE_EXCLUSIVE_ACCESS_ALLREG:
 		return core_scsi3_pro_reserve(cmd, type, scope, res_key);
 	default:
-		target_err("SPC-3 PR: Unknown Service Action RESERVE Type:"
-			   " 0x%02x\n",
-			   type);
+		target_err("SPC-3 PR: Unknown Service Action RESERVE Type: 0x%02x\n", type);
 		return TCM_INVALID_CDB_FIELD;
 	}
 }
@@ -2477,8 +2417,7 @@ static void __core_scsi3_complete_pro_release(
 	spin_unlock(&dev->t10_pr.registration_lock);
 out:
 	if (!dev->dev_pr_res_holder) {
-		target_debug("SPC-3 PR [%s] Service Action: %s RELEASE cleared"
-			     " reservation holder TYPE: %s ALL_TG_PT: %d\n",
+		target_debug("SPC-3 PR [%s] Service Action: %s RELEASE cleared reservation holder TYPE: %s ALL_TG_PT: %d\n",
 			     tfo->fabric_name, (explicit) ? "explicit" : "implicit",
 			     core_scsi3_pr_dump_type(pr_res_type),
 			     (pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
@@ -2511,8 +2450,7 @@ core_scsi3_emulate_pro_release(struct se_cmd *cmd, int type, int scope,
 	 */
 	pr_reg = core_scsi3_locate_pr_reg(dev, se_sess->se_node_acl, se_sess);
 	if (!pr_reg) {
-		target_err("SPC-3 PR: Unable to locate"
-			   " PR_REGISTERED *pr_reg for RELEASE\n");
+		target_err("SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for RELEASE\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	/*
@@ -2561,9 +2499,7 @@ core_scsi3_emulate_pro_release(struct se_cmd *cmd, int type, int scope,
 	 *	  that is registered with the logical unit for the I_T nexus;
 	 */
 	if (res_key != pr_reg->pr_res_key) {
-		target_err("SPC-3 PR RELEASE: Received res_key: 0x%016Lx"
-			   " does not match existing SA REGISTER res_key:"
-			   " 0x%016Lx\n",
+		target_err("SPC-3 PR RELEASE: Received res_key: 0x%016Lx does not match existing SA REGISTER res_key: 0x%016Lx\n",
 			   res_key, pr_reg->pr_res_key);
 		spin_unlock(&dev->dev_reservation_lock);
 		ret = TCM_RESERVATION_CONFLICT;
@@ -2578,10 +2514,7 @@ core_scsi3_emulate_pro_release(struct se_cmd *cmd, int type, int scope,
 	if ((pr_res_holder->pr_res_type != type) ||
 	    (pr_res_holder->pr_res_scope != scope)) {
 		struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
-		target_err("SPC-3 PR RELEASE: Attempted to release"
-			   " reservation from [%s]: %s with different TYPE "
-			   "and/or SCOPE  while reservation already held by"
-			   " [%s]: %s, returning RESERVATION_CONFLICT\n",
+		target_err("SPC-3 PR RELEASE: Attempted to release reservation from [%s]: %s with different TYPE and/or SCOPE  while reservation already held by [%s]: %s, returning RESERVATION_CONFLICT\n",
 			   cmd->se_tfo->fabric_name, se_sess->se_node_acl->initiatorname,
 			   pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
 			   pr_res_holder->pr_reg_nacl->initiatorname);
@@ -2664,8 +2597,7 @@ core_scsi3_emulate_pro_clear(struct se_cmd *cmd, u64 res_key)
 	pr_reg_n = core_scsi3_locate_pr_reg(cmd->se_dev,
 			se_sess->se_node_acl, se_sess);
 	if (!pr_reg_n) {
-		target_err("SPC-3 PR: Unable to locate"
-			   " PR_REGISTERED *pr_reg for CLEAR\n");
+		target_err("SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for CLEAR\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	/*
@@ -2680,10 +2612,7 @@ core_scsi3_emulate_pro_clear(struct se_cmd *cmd, u64 res_key)
 	 * 	   that is registered with the logical unit for the I_T nexus.
 	 */
 	if (res_key != pr_reg_n->pr_res_key) {
-		target_err("SPC-3 PR REGISTER: Received"
-			   " res_key: 0x%016Lx does not match"
-			   " existing SA REGISTER res_key:"
-			   " 0x%016Lx\n",
+		target_err("SPC-3 PR REGISTER: Received res_key: 0x%016Lx does not match existing SA REGISTER res_key: 0x%016Lx\n",
 			   res_key, pr_reg_n->pr_res_key);
 		core_scsi3_put_pr_reg(pr_reg_n);
 		return TCM_RESERVATION_CONFLICT;
@@ -2759,8 +2688,7 @@ static void __core_scsi3_complete_pro_preempt(
 	pr_reg->pr_res_type = type;
 	pr_reg->pr_res_scope = scope;
 
-	target_debug("SPC-3 PR [%s] Service Action: PREEMPT%s created new"
-		     " reservation holder TYPE: %s ALL_TG_PT: %d\n",
+	target_debug("SPC-3 PR [%s] Service Action: PREEMPT%s created new reservation holder TYPE: %s ALL_TG_PT: %d\n",
 		     tfo->fabric_name, (preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "",
 		     core_scsi3_pr_dump_type(type), (pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
 	target_debug("SPC-3 PR [%s] PREEMPT%s from Node: %s%s\n", tfo->fabric_name,
@@ -2820,8 +2748,7 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 	pr_reg_n = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
 				se_sess);
 	if (!pr_reg_n) {
-		target_err("SPC-3 PR: Unable to locate"
-			   " PR_REGISTERED *pr_reg for PREEMPT%s\n",
+		target_err("SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for PREEMPT%s\n",
 			   (preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "");
 		return TCM_RESERVATION_CONFLICT;
 	}
@@ -3123,8 +3050,7 @@ core_scsi3_emulate_pro_preempt(struct se_cmd *cmd, int type, int scope,
 		return core_scsi3_pro_preempt(cmd, type, scope, res_key,
 					      sa_res_key, preempt_type);
 	default:
-		target_err("SPC-3 PR: Unknown Service Action PREEMPT%s"
-			   " Type: 0x%02x\n",
+		target_err("SPC-3 PR: Unknown Service Action PREEMPT%s Type: 0x%02x\n",
 			   (preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "", type);
 		return TCM_INVALID_CDB_FIELD;
 	}
@@ -3169,8 +3095,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	pr_reg = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
 				se_sess);
 	if (!pr_reg) {
-		target_err("SPC-3 PR: Unable to locate PR_REGISTERED"
-			   " *pr_reg for REGISTER_AND_MOVE\n");
+		target_err("SPC-3 PR: Unable to locate PR_REGISTERED *pr_reg for REGISTER_AND_MOVE\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	/*
@@ -3178,9 +3103,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 * provided during this initiator's I_T nexus registration.
 	 */
 	if (res_key != pr_reg->pr_res_key) {
-		target_warn("SPC-3 PR REGISTER_AND_MOVE: Received"
-			    " res_key: 0x%016Lx does not match existing SA REGISTER"
-			    " res_key: 0x%016Lx\n",
+		target_warn("SPC-3 PR REGISTER_AND_MOVE: Received res_key: 0x%016Lx does not match existing SA REGISTER res_key: 0x%016Lx\n",
 			    res_key, pr_reg->pr_res_key);
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out_put_pr_reg;
@@ -3189,8 +3112,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 * The service active reservation key needs to be non zero
 	 */
 	if (!sa_res_key) {
-		target_warn("SPC-3 PR REGISTER_AND_MOVE: Received zero"
-			    " sa_res_key\n");
+		target_warn("SPC-3 PR REGISTER_AND_MOVE: Received zero sa_res_key\n");
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_put_pr_reg;
 	}
@@ -3212,8 +3134,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	buf = NULL;
 
 	if ((tid_len + 24) != cmd->data_length) {
-		target_err("SPC-3 PR: Illegal tid_len: %u + 24 byte header"
-			   " does not equal CDB data_length: %u\n",
+		target_err("SPC-3 PR: Illegal tid_len: %u + 24 byte header does not equal CDB data_length: %u\n",
 			   tid_len, cmd->data_length);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_put_pr_reg;
@@ -3232,8 +3153,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		spin_unlock(&dev->se_port_lock);
 
 		if (core_scsi3_tpg_depend_item(dest_se_tpg)) {
-			target_err("core_scsi3_tpg_depend_item() failed"
-				   " for dest_se_tpg\n");
+			target_err("core_scsi3_tpg_depend_item() failed for dest_se_tpg\n");
 			atomic_dec_mb(&dest_se_tpg->tpg_pr_ref_count);
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 			goto out_put_pr_reg;
@@ -3245,9 +3165,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	spin_unlock(&dev->se_port_lock);
 
 	if (!dest_se_tpg || !dest_tf_ops) {
-		target_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
-			   " fabric ops from Relative Target Port Identifier:"
-			   " %hu\n",
+		target_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate fabric ops from Relative Target Port Identifier: %hu\n",
 			   rtpi);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_put_pr_reg;
@@ -3260,14 +3178,11 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	}
 	proto_ident = (buf[24] & 0x0f);
 
-	target_debug("SPC-3 PR REGISTER_AND_MOVE: Extracted Protocol Identifier:"
-		     " 0x%02x\n",
+	target_debug("SPC-3 PR REGISTER_AND_MOVE: Extracted Protocol Identifier: 0x%02x\n",
 		     proto_ident);
 
 	if (proto_ident != dest_se_tpg->proto_id) {
-		target_err("SPC-3 PR REGISTER_AND_MOVE: Received"
-			   " proto_ident: 0x%02x does not match ident: 0x%02x"
-			   " from fabric: %s\n",
+		target_err("SPC-3 PR REGISTER_AND_MOVE: Received proto_ident: 0x%02x does not match ident: 0x%02x from fabric: %s\n",
 			   proto_ident, dest_se_tpg->proto_id, dest_tf_ops->fabric_name);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
@@ -3275,8 +3190,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	initiator_str = target_parse_pr_out_transport_id(dest_se_tpg,
 			&buf[24], &tmp_tid_len, &iport_ptr);
 	if (!initiator_str) {
-		target_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
-			   " initiator_str from Transport ID\n");
+		target_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate initiator_str from Transport ID\n");
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
@@ -3284,8 +3198,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	transport_kunmap_data_sg(cmd);
 	buf = NULL;
 
-	target_debug("SPC-3 PR [%s] Extracted initiator %s identifier: %s"
-		     " %s\n",
+	target_debug("SPC-3 PR [%s] Extracted initiator %s identifier: %s %s\n",
 		     dest_tf_ops->fabric_name, (iport_ptr != NULL) ? "port" : "device",
 		     initiator_str, (iport_ptr != NULL) ? iport_ptr : "");
 	/*
@@ -3303,15 +3216,13 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		goto after_iport_check;
 
 	if (!iport_ptr || !pr_reg->isid_present_at_reg) {
-		target_err("SPC-3 PR REGISTER_AND_MOVE: TransportID: %s"
-			   " matches: %s on received I_T Nexus\n",
+		target_err("SPC-3 PR REGISTER_AND_MOVE: TransportID: %s matches: %s on received I_T Nexus\n",
 			   initiator_str, pr_reg_nacl->initiatorname);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
 	if (!strcmp(iport_ptr, pr_reg->pr_reg_isid)) {
-		target_err("SPC-3 PR REGISTER_AND_MOVE: TransportID: %s %s"
-			   " matches: %s %s on received I_T Nexus\n",
+		target_err("SPC-3 PR REGISTER_AND_MOVE: TransportID: %s %s matches: %s %s on received I_T Nexus\n",
 			   initiator_str, iport_ptr, pr_reg_nacl->initiatorname,
 			   pr_reg->pr_reg_isid);
 		ret = TCM_INVALID_PARAMETER_LIST;
@@ -3329,24 +3240,21 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	mutex_unlock(&dest_se_tpg->acl_node_mutex);
 
 	if (!dest_node_acl) {
-		target_err("Unable to locate %s dest_node_acl for"
-			   " TransportID%s\n",
+		target_err("Unable to locate %s dest_node_acl for TransportID%s\n",
 			   dest_tf_ops->fabric_name, initiator_str);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
 
 	if (core_scsi3_nodeacl_depend_item(dest_node_acl)) {
-		target_err("core_scsi3_nodeacl_depend_item() for"
-			   " dest_node_acl\n");
+		target_err("core_scsi3_nodeacl_depend_item() for dest_node_acl\n");
 		atomic_dec_mb(&dest_node_acl->acl_pr_ref_count);
 		dest_node_acl = NULL;
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
 
-	target_debug("SPC-3 PR REGISTER_AND_MOVE: Found %s dest_node_acl:"
-		     " %s from TransportID\n",
+	target_debug("SPC-3 PR REGISTER_AND_MOVE: Found %s dest_node_acl: %s from TransportID\n",
 		     dest_tf_ops->fabric_name, dest_node_acl->initiatorname);
 
 	/*
@@ -3355,8 +3263,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 */
 	dest_se_deve = core_get_se_deve_from_rtpi(dest_node_acl, rtpi);
 	if (!dest_se_deve) {
-		target_err("Unable to locate %s dest_se_deve from RTPI:"
-			   " %hu\n",
+		target_err("Unable to locate %s dest_se_deve from RTPI: %hu\n",
 			   dest_tf_ops->fabric_name, rtpi);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
@@ -3370,8 +3277,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		goto out;
 	}
 
-	target_debug("SPC-3 PR REGISTER_AND_MOVE: Located %s node %s LUN"
-		     " ACL for dest_se_deve->mapped_lun: %llu\n",
+	target_debug("SPC-3 PR REGISTER_AND_MOVE: Located %s node %s LUN ACL for dest_se_deve->mapped_lun: %llu\n",
 		     dest_tf_ops->fabric_name, dest_node_acl->initiatorname,
 		     dest_se_deve->mapped_lun);
 
@@ -3382,8 +3288,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	spin_lock(&dev->dev_reservation_lock);
 	pr_res_holder = dev->dev_pr_res_holder;
 	if (!pr_res_holder) {
-		target_warn("SPC-3 PR REGISTER_AND_MOVE: No reservation"
-			    " currently held\n");
+		target_warn("SPC-3 PR REGISTER_AND_MOVE: No reservation currently held\n");
 		spin_unlock(&dev->dev_reservation_lock);
 		ret = TCM_INVALID_CDB_FIELD;
 		goto out;
@@ -3395,8 +3300,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 * 	Register behaviors for a REGISTER AND MOVE service action
 	 */
 	if (!is_reservation_holder(pr_res_holder, pr_reg)) {
-		target_warn("SPC-3 PR REGISTER_AND_MOVE: Calling I_T"
-			    " Nexus is not reservation holder\n");
+		target_warn("SPC-3 PR REGISTER_AND_MOVE: Calling I_T Nexus is not reservation holder\n");
 		spin_unlock(&dev->dev_reservation_lock);
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out;
@@ -3412,8 +3316,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 */
 	if ((pr_res_holder->pr_res_type == PR_TYPE_WRITE_EXCLUSIVE_ALLREG) ||
 	    (pr_res_holder->pr_res_type == PR_TYPE_EXCLUSIVE_ACCESS_ALLREG)) {
-		target_warn("SPC-3 PR REGISTER_AND_MOVE: Unable to move"
-			    " reservation for type: %s\n",
+		target_warn("SPC-3 PR REGISTER_AND_MOVE: Unable to move reservation for type: %s\n",
 			    core_scsi3_pr_dump_type(pr_res_holder->pr_res_type));
 		spin_unlock(&dev->dev_reservation_lock);
 		ret = TCM_RESERVATION_CONFLICT;
@@ -3489,13 +3392,10 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		dest_pr_reg->pr_res_generation = pr_tmpl->pr_generation++;
 	spin_unlock(&dev->dev_reservation_lock);
 
-	target_debug("SPC-3 PR [%s] Service Action: REGISTER_AND_MOVE"
-		     " created new reservation holder TYPE: %s on object RTPI:"
-		     " %hu  PRGeneration: 0x%08x\n",
+	target_debug("SPC-3 PR [%s] Service Action: REGISTER_AND_MOVE created new reservation holder TYPE: %s on object RTPI: %hu  PRGeneration: 0x%08x\n",
 		     dest_tf_ops->fabric_name, core_scsi3_pr_dump_type(type), rtpi,
 		     dest_pr_reg->pr_res_generation);
-	target_debug("SPC-3 PR Successfully moved reservation from"
-		     " %s Fabric Node: %s%s -> %s Fabric Node: %s %s\n",
+	target_debug("SPC-3 PR Successfully moved reservation from %s Fabric Node: %s%s -> %s Fabric Node: %s %s\n",
 		     tf_ops->fabric_name, pr_reg_nacl->initiatorname, i_buf,
 		     dest_tf_ops->fabric_name, dest_node_acl->initiatorname,
 		     (iport_ptr != NULL) ? iport_ptr : "");
@@ -3590,9 +3490,7 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 	 * CONFLICT status.
 	 */
 	if (cmd->se_dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS) {
-		target_err("Received PERSISTENT_RESERVE CDB while legacy"
-			   " SPC-2 reservation is held, returning"
-			   " RESERVATION_CONFLICT\n");
+		target_err("Received PERSISTENT_RESERVE CDB while legacy SPC-2 reservation is held, returning RESERVATION_CONFLICT\n");
 		return TCM_RESERVATION_CONFLICT;
 	}
 
@@ -3604,8 +3502,7 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	if (cmd->data_length < 24) {
-		target_warn("SPC-PR: Received PR OUT parameter list"
-			    " length too small: %u\n",
+		target_warn("SPC-PR: Received PR OUT parameter list length too small: %u\n",
 			    cmd->data_length);
 		return TCM_PARAMETER_LIST_LENGTH_ERROR;
 	}
@@ -3665,8 +3562,7 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 	 */
 	if (!spec_i_pt && (sa != PRO_REGISTER_AND_MOVE) &&
 	    (cmd->data_length != 24)) {
-		target_warn("SPC-PR: Received PR OUT illegal parameter"
-			    " list length: %u\n",
+		target_warn("SPC-PR: Received PR OUT illegal parameter list length: %u\n",
 			    cmd->data_length);
 		return TCM_PARAMETER_LIST_LENGTH_ERROR;
 	}
@@ -3713,9 +3609,7 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 				sa_res_key, aptpl, unreg);
 		break;
 	default:
-		target_err("Unknown PERSISTENT_RESERVE_OUT service"
-			   " action: 0x%02x\n",
-			   sa);
+		target_err("Unknown PERSISTENT_RESERVE_OUT service action: 0x%02x\n", sa);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -3739,9 +3633,7 @@ core_scsi3_pri_read_keys(struct se_cmd *cmd)
 	u32 add_len = 0, off = 8;
 
 	if (cmd->data_length < 8) {
-		target_err("PRIN SA READ_KEYS SCSI Data Length: %u"
-			   " too small\n",
-			   cmd->data_length);
+		target_err("PRIN SA READ_KEYS SCSI Data Length: %u too small\n", cmd->data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -3795,8 +3687,7 @@ core_scsi3_pri_read_reservation(struct se_cmd *cmd)
 	u32 add_len = 0;
 
 	if (cmd->data_length < 8) {
-		target_err("PRIN SA READ_RESERVATIONS SCSI Data Length: %u"
-			   " too small\n",
+		target_err("PRIN SA READ_RESERVATIONS SCSI Data Length: %u too small\n",
 			   cmd->data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
@@ -3872,8 +3763,7 @@ core_scsi3_pri_report_capabilities(struct se_cmd *cmd)
 	u16 len = 8; /* Hardcoded to 8. */
 
 	if (cmd->data_length < 6) {
-		target_err("PRIN SA REPORT_CAPABILITIES SCSI Data Length:"
-			   " %u too small\n",
+		target_err("PRIN SA REPORT_CAPABILITIES SCSI Data Length: %u too small\n",
 			   cmd->data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
@@ -3939,8 +3829,7 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 	bool all_reg = false;
 
 	if (cmd->data_length < 8) {
-		target_err("PRIN SA READ_FULL_STATUS SCSI Data Length: %u"
-			   " too small\n",
+		target_err("PRIN SA READ_FULL_STATUS SCSI Data Length: %u too small\n",
 			   cmd->data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
@@ -3982,8 +3871,7 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 					&format_code);
 		if (exp_desc_len < 0 ||
 		    exp_desc_len + add_len > cmd->data_length) {
-			target_warn("SPC-3 PRIN READ_FULL_STATUS ran"
-				    " out of buffer: %d\n",
+			target_warn("SPC-3 PRIN READ_FULL_STATUS ran out of buffer: %d\n",
 				    cmd->data_length);
 			spin_lock(&pr_tmpl->registration_lock);
 			atomic_dec_mb(&pr_reg->pr_res_holders);
@@ -4129,9 +4017,7 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 	 * CONFLICT status.
 	 */
 	if (cmd->se_dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS) {
-		target_err("Received PERSISTENT_RESERVE CDB while legacy"
-			   " SPC-2 reservation is held, returning"
-			   " RESERVATION_CONFLICT\n");
+		target_err("Received PERSISTENT_RESERVE CDB while legacy SPC-2 reservation is held, returning RESERVATION_CONFLICT\n");
 		return TCM_RESERVATION_CONFLICT;
 	}
 
@@ -4154,8 +4040,7 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 		ret = core_scsi3_pri_read_full_status(cmd);
 		break;
 	default:
-		target_err("Unknown PERSISTENT_RESERVE_IN service"
-			   " action: 0x%02x\n",
+		target_err("Unknown PERSISTENT_RESERVE_IN service action: 0x%02x\n",
 			   cmd->t_task_cdb[1] & 0x1f);
 		return TCM_INVALID_CDB_FIELD;
 	}
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index a697993dbfaa..25288d8b82c8 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -60,8 +60,7 @@ static int pscsi_attach_hba(struct se_hba *hba, u32 host_id)
 
 	hba->hba_ptr = phv;
 
-	target_debug("CORE_HBA[%d] - TCM SCSI HBA Driver %s on"
-		     " Generic Target Core Stack %s\n",
+	target_debug("CORE_HBA[%d] - TCM SCSI HBA Driver %s on Generic Target Core Stack %s\n",
 		     hba->hba_id, PSCSI_VERSION, TARGET_CORE_VERSION);
 	target_debug("CORE_HBA[%d] - Attached SCSI HBA to Generic\n", hba->hba_id);
 
@@ -76,13 +75,11 @@ static void pscsi_detach_hba(struct se_hba *hba)
 	if (scsi_host) {
 		scsi_host_put(scsi_host);
 
-		target_debug("CORE_HBA[%d] - Detached SCSI HBA: %s from"
-			     " Generic Target Core\n",
+		target_debug("CORE_HBA[%d] - Detached SCSI HBA: %s from Generic Target Core\n",
 			     hba->hba_id,
 			     (scsi_host->hostt->name) ? (scsi_host->hostt->name) : "Unknown");
 	} else
-		target_debug("CORE_HBA[%d] - Detached Virtual SCSI HBA"
-			     " from Generic Target Core\n",
+		target_debug("CORE_HBA[%d] - Detached Virtual SCSI HBA from Generic Target Core\n",
 			     hba->hba_id);
 
 	kfree(phv);
@@ -103,9 +100,8 @@ static int pscsi_pmode_enable_hba(struct se_hba *hba, unsigned long mode_flag)
 		phv->phv_lld_host = NULL;
 		phv->phv_mode = PHV_VIRTUAL_HOST_ID;
 
-		target_debug("CORE_HBA[%d] - Disabled pSCSI HBA Passthrough"
-			     " %s\n",
-			     hba->hba_id, (sh->hostt->name) ? (sh->hostt->name) : "Unknown");
+		target_debug("CORE_HBA[%d] - Disabled pSCSI HBA Passthrough %s\n", hba->hba_id,
+			     (sh->hostt->name) ? (sh->hostt->name) : "Unknown");
 
 		scsi_host_put(sh);
 		return 0;
@@ -116,8 +112,7 @@ static int pscsi_pmode_enable_hba(struct se_hba *hba, unsigned long mode_flag)
 	 */
 	sh = scsi_host_lookup(phv->phv_host_id);
 	if (!sh) {
-		target_err("pSCSI: Unable to locate SCSI Host for"
-			   " phv_host_id: %d\n",
+		target_err("pSCSI: Unable to locate SCSI Host for phv_host_id: %d\n",
 			   phv->phv_host_id);
 		return -EINVAL;
 	}
@@ -241,16 +236,14 @@ pscsi_get_inquiry_vpd_device_ident(struct scsi_device *sdev,
 		page_83 = &buf[off];
 		ident_len = page_83[3];
 		if (!ident_len) {
-			target_err("page_83[3]: identifier"
-				   " length zero!\n");
+			target_err("page_83[3]: identifier length zero!\n");
 			break;
 		}
 		target_debug("T10 VPD Identifier Length: %d\n", ident_len);
 
 		vpd = kzalloc(sizeof(struct t10_vpd), GFP_KERNEL);
 		if (!vpd) {
-			target_err("Unable to allocate memory for"
-				   " struct t10_vpd\n");
+			target_err("Unable to allocate memory for struct t10_vpd\n");
 			goto out;
 		}
 		INIT_LIST_HEAD(&vpd->vpd_list);
@@ -291,9 +284,8 @@ static int pscsi_add_device_to_list(struct se_device *dev,
 	if (!sd->queue_depth) {
 		sd->queue_depth = PSCSI_DEFAULT_QUEUEDEPTH;
 
-		target_err("Set broken SCSI Device %d:%d:%llu"
-			   " queue_depth to %d\n",
-			   sd->channel, sd->id, sd->lun, sd->queue_depth);
+		target_err("Set broken SCSI Device %d:%d:%llu queue_depth to %d\n", sd->channel,
+			   sd->id, sd->lun, sd->queue_depth);
 	}
 
 	dev->dev_attrib.hw_block_size =
@@ -431,8 +423,7 @@ static int pscsi_configure_device(struct se_device *dev)
 	if (!(pdv->pdv_flags & PDF_HAS_CHANNEL_ID) ||
 	    !(pdv->pdv_flags & PDF_HAS_TARGET_ID) ||
 	    !(pdv->pdv_flags & PDF_HAS_LUN_ID)) {
-		target_err("Missing scsi_channel_id=, scsi_target_id= and"
-			   " scsi_lun_id= parameters\n");
+		target_err("Missing scsi_channel_id=, scsi_target_id= and scsi_lun_id= parameters\n");
 		return -EINVAL;
 	}
 
@@ -442,8 +433,7 @@ static int pscsi_configure_device(struct se_device *dev)
 	 */
 	if (!sh) {
 		if (phv->phv_mode == PHV_LLD_SCSI_HOST_NO) {
-			target_err("pSCSI: Unable to locate struct"
-				   " Scsi_Host for PHV_LLD_SCSI_HOST_NO\n");
+			target_err("pSCSI: Unable to locate struct Scsi_Host for PHV_LLD_SCSI_HOST_NO\n");
 			return -ENODEV;
 		}
 		/*
@@ -451,8 +441,7 @@ static int pscsi_configure_device(struct se_device *dev)
 		 * reference, we enforce that udev_path has been set
 		 */
 		if (!(dev->dev_flags & DF_USING_UDEV_PATH)) {
-			target_err("pSCSI: udev_path attribute has not"
-				   " been set before ENABLE=1\n");
+			target_err("pSCSI: udev_path attribute has not been set before ENABLE=1\n");
 			return -EINVAL;
 		}
 		/*
@@ -462,8 +451,7 @@ static int pscsi_configure_device(struct se_device *dev)
 		 */
 		if (!(pdv->pdv_flags & PDF_HAS_VIRT_HOST_ID)) {
 			if (hba->dev_count) {
-				target_err("pSCSI: Unable to set hba_mode"
-					   " with active devices\n");
+				target_err("pSCSI: Unable to set hba_mode with active devices\n");
 				return -EEXIST;
 			}
 
@@ -476,8 +464,7 @@ static int pscsi_configure_device(struct se_device *dev)
 		} else {
 			sh = scsi_host_lookup(pdv->pdv_host_id);
 			if (!sh) {
-				target_err("pSCSI: Unable to locate"
-					   " pdv_host_id: %d\n",
+				target_err("pSCSI: Unable to locate pdv_host_id: %d\n",
 					   pdv->pdv_host_id);
 				return -EINVAL;
 			}
@@ -485,8 +472,7 @@ static int pscsi_configure_device(struct se_device *dev)
 		}
 	} else {
 		if (phv->phv_mode == PHV_VIRTUAL_HOST_ID) {
-			target_err("pSCSI: PHV_VIRTUAL_HOST_ID set while"
-				   " struct Scsi_Host exists\n");
+			target_err("pSCSI: PHV_VIRTUAL_HOST_ID set while struct Scsi_Host exists\n");
 			return -EEXIST;
 		}
 	}
@@ -731,9 +717,7 @@ static ssize_t pscsi_set_configfs_dev_params(struct se_device *dev,
 		switch (token) {
 		case Opt_scsi_host_id:
 			if (phv->phv_mode == PHV_LLD_SCSI_HOST_NO) {
-				target_err("PSCSI[%d]: Unable to accept"
-					   " scsi_host_id while phv_mode =="
-					   " PHV_LLD_SCSI_HOST_NO\n",
+				target_err("PSCSI[%d]: Unable to accept scsi_host_id while phv_mode == PHV_LLD_SCSI_HOST_NO\n",
 					   phv->phv_host_id);
 				ret = -EINVAL;
 				goto out;
@@ -742,9 +726,8 @@ static ssize_t pscsi_set_configfs_dev_params(struct se_device *dev,
 			if (ret)
 				goto out;
 			pdv->pdv_host_id = arg;
-			target_debug("PSCSI[%d]: Referencing SCSI Host ID:"
-				     " %d\n",
-				     phv->phv_host_id, pdv->pdv_host_id);
+			target_debug("PSCSI[%d]: Referencing SCSI Host ID: %d\n", phv->phv_host_id,
+				     pdv->pdv_host_id);
 			pdv->pdv_flags |= PDF_HAS_VIRT_HOST_ID;
 			break;
 		case Opt_scsi_channel_id:
@@ -752,8 +735,7 @@ static ssize_t pscsi_set_configfs_dev_params(struct se_device *dev,
 			if (ret)
 				goto out;
 			pdv->pdv_channel_id = arg;
-			target_debug("PSCSI[%d]: Referencing SCSI Channel"
-				     " ID: %d\n",
+			target_debug("PSCSI[%d]: Referencing SCSI Channel ID: %d\n",
 				     phv->phv_host_id, pdv->pdv_channel_id);
 			pdv->pdv_flags |= PDF_HAS_CHANNEL_ID;
 			break;
@@ -762,8 +744,7 @@ static ssize_t pscsi_set_configfs_dev_params(struct se_device *dev,
 			if (ret)
 				goto out;
 			pdv->pdv_target_id = arg;
-			target_debug("PSCSI[%d]: Referencing SCSI Target"
-				     " ID: %d\n",
+			target_debug("PSCSI[%d]: Referencing SCSI Target ID: %d\n",
 				     phv->phv_host_id, pdv->pdv_target_id);
 			pdv->pdv_flags |= PDF_HAS_TARGET_ID;
 			break;
@@ -772,9 +753,8 @@ static ssize_t pscsi_set_configfs_dev_params(struct se_device *dev,
 			if (ret)
 				goto out;
 			pdv->pdv_lun_id = arg;
-			target_debug("PSCSI[%d]: Referencing SCSI LUN ID:"
-				     " %d\n",
-				     phv->phv_host_id, pdv->pdv_lun_id);
+			target_debug("PSCSI[%d]: Referencing SCSI LUN ID: %d\n", phv->phv_host_id,
+				     pdv->pdv_lun_id);
 			pdv->pdv_flags |= PDF_HAS_LUN_ID;
 			break;
 		default:
@@ -868,13 +848,11 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 					 rw ? REQ_OP_WRITE : REQ_OP_READ);
 				bio->bi_end_io = pscsi_bi_endio;
 
-				target_debug("PSCSI: Allocated bio: %p,"
-					     " dir: %s nr_vecs: %d\n",
-					     bio, (rw) ? "rw" : "r", nr_vecs);
+				target_debug("PSCSI: Allocated bio: %p, dir: %s nr_vecs: %d\n", bio,
+					     (rw) ? "rw" : "r", nr_vecs);
 			}
 
-			target_debug("PSCSI: Calling bio_add_pc_page() i: %d"
-				     " bio: %p page: %p len: %d off: %d\n",
+			target_debug("PSCSI: Calling bio_add_pc_page() i: %d bio: %p page: %p len: %d off: %d\n",
 				     i, bio, page, len, off);
 
 			rc = bio_add_pc_page(pdv->pdv_sd->request_queue,
@@ -882,9 +860,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 			target_debug("PSCSI: bio->bi_vcnt: %d nr_vecs: %d\n", bio_segments(bio),
 				     nr_vecs);
 			if (rc != bytes) {
-				target_debug("PSCSI: Reached bio->bi_vcnt max:"
-					     " %d i: %d bio: %p, allocating another"
-					     " bio\n",
+				target_debug("PSCSI: Reached bio->bi_vcnt max: %d i: %d bio: %p, allocating another bio\n",
 					     bio->bi_vcnt, i, bio);
 
 				rc = blk_rq_append_bio(req, bio);
@@ -1015,8 +991,7 @@ static enum rq_end_io_ret pscsi_req_done(struct request *req,
 	u8 *cdb = cmd->priv;
 
 	if (scsi_status != SAM_STAT_GOOD) {
-		target_debug("PSCSI Status Byte exception at cmd: %p CDB:"
-			     " 0x%02x Result: 0x%08x\n",
+		target_debug("PSCSI Status Byte exception at cmd: %p CDB: 0x%02x Result: 0x%08x\n",
 			     cmd, cdb[0], scmd->result);
 	}
 
@@ -1027,8 +1002,7 @@ static enum rq_end_io_ret pscsi_req_done(struct request *req,
 		target_complete_cmd_with_length(cmd, scsi_status, valid_data);
 		break;
 	default:
-		target_debug("PSCSI Host Byte exception at cmd: %p CDB:"
-			     " 0x%02x Result: 0x%08x\n",
+		target_debug("PSCSI Host Byte exception at cmd: %p CDB: 0x%02x Result: 0x%08x\n",
 			     cmd, cdb[0], scmd->result);
 		target_complete_cmd(cmd, SAM_STAT_CHECK_CONDITION);
 		break;
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 7d83a4ed93da..974b6527f1ce 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -42,8 +42,7 @@ static int rd_attach_hba(struct se_hba *hba, u32 host_id)
 
 	hba->hba_ptr = rd_host;
 
-	target_debug("CORE_HBA[%d] - TCM Ramdisk HBA Driver %s on"
-		     " Generic Target Core Stack %s\n",
+	target_debug("CORE_HBA[%d] - TCM Ramdisk HBA Driver %s on Generic Target Core Stack %s\n",
 		     hba->hba_id, RD_HBA_VERSION, TARGET_CORE_VERSION);
 
 	return 0;
@@ -53,8 +52,7 @@ static void rd_detach_hba(struct se_hba *hba)
 {
 	struct rd_host *rd_host = hba->hba_ptr;
 
-	target_debug("CORE_HBA[%d] - Detached Ramdisk HBA: %u from"
-		     " Generic Target Core\n",
+	target_debug("CORE_HBA[%d] - Detached Ramdisk HBA: %u from Generic Target Core\n",
 		     hba->hba_id, rd_host->rd_host_id);
 
 	kfree(rd_host);
@@ -96,8 +94,7 @@ static void rd_release_device_space(struct rd_dev *rd_dev)
 	page_count = rd_release_sgl_table(rd_dev, rd_dev->sg_table_array,
 					  rd_dev->sg_table_count);
 
-	target_debug("CORE_RD[%u] - Released device space for Ramdisk"
-		     " Device ID: %u, pages %u in %u tables total bytes %lu\n",
+	target_debug("CORE_RD[%u] - Released device space for Ramdisk Device ID: %u, pages %u in %u tables total bytes %lu\n",
 		     rd_dev->rd_host->rd_host_id, rd_dev->rd_dev_id, page_count,
 		     rd_dev->sg_table_count, (unsigned long)page_count * PAGE_SIZE);
 
@@ -153,8 +150,7 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 		for (j = 0; j < sg_per_table; j++) {
 			pg = alloc_pages(GFP_KERNEL, 0);
 			if (!pg) {
-				target_err("Unable to allocate scatterlist"
-					   " pages for struct rd_dev_sg_table\n");
+				target_err("Unable to allocate scatterlist pages for struct rd_dev_sg_table\n");
 				return -ENOMEM;
 			}
 			sg_assign_page(&sg[j], pg);
@@ -203,8 +199,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 	if (rc)
 		return rc;
 
-	target_debug("CORE_RD[%u] - Built Ramdisk Device ID: %u space of"
-		     " %u pages in %u tables\n",
+	target_debug("CORE_RD[%u] - Built Ramdisk Device ID: %u space of %u pages in %u tables\n",
 		     rd_dev->rd_host->rd_host_id, rd_dev->rd_dev_id, rd_dev->rd_page_count,
 		     rd_dev->sg_table_count);
 
@@ -221,8 +216,7 @@ static void rd_release_prot_space(struct rd_dev *rd_dev)
 	page_count = rd_release_sgl_table(rd_dev, rd_dev->sg_prot_array,
 					  rd_dev->sg_prot_count);
 
-	target_debug("CORE_RD[%u] - Released protection space for Ramdisk"
-		     " Device ID: %u, pages %u in %u tables total bytes %lu\n",
+	target_debug("CORE_RD[%u] - Released protection space for Ramdisk Device ID: %u, pages %u in %u tables total bytes %lu\n",
 		     rd_dev->rd_host->rd_host_id, rd_dev->rd_dev_id, page_count,
 		     rd_dev->sg_table_count, (unsigned long)page_count * PAGE_SIZE);
 
@@ -260,8 +254,7 @@ static int rd_build_prot_space(struct rd_dev *rd_dev, int prot_length, int block
 	if (rc)
 		return rc;
 
-	target_debug("CORE_RD[%u] - Built Ramdisk Device ID: %u prot space of"
-		     " %u pages in %u tables\n",
+	target_debug("CORE_RD[%u] - Built Ramdisk Device ID: %u prot space of %u pages in %u tables\n",
 		     rd_dev->rd_host->rd_host_id, rd_dev->rd_dev_id, total_sg_needed,
 		     rd_dev->sg_prot_count);
 
@@ -304,8 +297,7 @@ static int rd_configure_device(struct se_device *dev)
 
 	rd_dev->rd_dev_id = rd_host->rd_host_dev_id_count++;
 
-	target_debug("CORE_RD[%u] - Added TCM MEMCPY Ramdisk Device ID: %u of"
-		     " %u pages in %u tables, %lu total bytes\n",
+	target_debug("CORE_RD[%u] - Added TCM MEMCPY Ramdisk Device ID: %u of %u pages in %u tables, %lu total bytes\n",
 		     rd_host->rd_host_id, rd_dev->rd_dev_id, rd_dev->rd_page_count,
 		     rd_dev->sg_table_count, (unsigned long)(rd_dev->rd_page_count * PAGE_SIZE));
 
@@ -471,8 +463,7 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		}
 		len = min((u32)m.length, src_len);
 		if (len > rd_size) {
-			target_debug("RD[%u]: size underrun page %d offset %d "
-				     "size %d\n",
+			target_debug("RD[%u]: size underrun page %d offset %d size %d\n",
 				     dev->rd_dev_id, rd_page, rd_offset, rd_size);
 			len = rd_size;
 		}
@@ -560,8 +551,7 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 		case Opt_rd_pages:
 			match_int(args, &arg);
 			rd_dev->rd_page_count = arg;
-			target_debug("RAMDISK: Referencing Page"
-				     " Count: %u\n",
+			target_debug("RAMDISK: Referencing Page Count: %u\n",
 				     rd_dev->rd_page_count);
 			rd_dev->rd_flags |= RDF_HAS_PAGE_COUNT;
 			break;
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 8c4bb62e96fc..20756a92a2af 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -280,9 +280,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags,
 	sense_reason_t ret;
 
 	if ((flags & 0x04) || (flags & 0x02)) {
-		target_err("WRITE_SAME PBDATA and LBDATA"
-			   " bits not supported for Block Discard"
-			   " Emulation\n");
+		target_err("WRITE_SAME PBDATA and LBDATA bits not supported for Block Discard Emulation\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 	if (sectors > cmd->se_dev->dev_attrib.max_write_same_len) {
@@ -320,8 +318,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags,
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 
 		if (!dev->dev_attrib.emulate_tpws) {
-			target_err("Got WRITE_SAME w/ UNMAP=1, but backend device"
-				   " has emulate_tpws disabled\n");
+			target_err("Got WRITE_SAME w/ UNMAP=1, but backend device has emulate_tpws disabled\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 		cmd->execute_cmd = sbc_execute_write_same_unmap;
@@ -472,8 +469,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	 * been failed with a non-zero SCSI status.
 	 */
 	if (cmd->scsi_status) {
-		target_debug("compare_and_write_callback: non zero scsi_status:"
-			     " 0x%02x\n",
+		target_debug("compare_and_write_callback: non zero scsi_status: 0x%02x\n",
 			     cmd->scsi_status);
 		*post_ret = 1;
 		if (cmd->scsi_status == SAM_STAT_CHECK_CONDITION)
@@ -674,8 +670,7 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char protect,
 	if (!cmd->t_prot_sg || !cmd->t_prot_nents) {
 		if (unlikely(protect &&
 		    !dev->dev_attrib.pi_prot_type && !cmd->se_sess->sess_prot_type)) {
-			target_err("CDB contains protect bit, but device + fabric does"
-				   " not advertise PROTECT=1 feature bit\n");
+			target_err("CDB contains protect bit, but device + fabric does not advertise PROTECT=1 feature bit\n");
 			return TCM_INVALID_CDB_FIELD;
 		}
 		if (cmd->prot_pto)
@@ -713,8 +708,7 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char protect,
 			return TCM_NO_SENSE;
 		fallthrough;
 	default:
-		target_err("Unable to determine pi_prot_type for CDB: 0x%02x "
-			   "PROTECT: 0x%02x\n",
+		target_err("Unable to determine pi_prot_type for CDB: 0x%02x PROTECT: 0x%02x\n",
 			   cmd->t_task_cdb[0], protect);
 		return TCM_INVALID_CDB_FIELD;
 	}
@@ -734,8 +728,7 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char protect,
 	if (protect)
 		cmd->data_length = sectors * dev->dev_attrib.block_size;
 
-	target_debug("%s: prot_type=%d, data_length=%d, prot_length=%d "
-		     "prot_op=%d prot_checks=%d\n",
+	target_debug("%s: prot_type=%d, data_length=%d, prot_length=%d prot_op=%d prot_checks=%d\n",
 		     __func__, cmd->prot_type, cmd->data_length, cmd->prot_length, cmd->prot_op,
 		     cmd->prot_checks);
 
@@ -748,16 +741,14 @@ sbc_check_dpofua(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
 	if (cdb[1] & 0x10) {
 		/* see explanation in spc_emulate_modesense */
 		if (!target_check_fua(dev)) {
-			target_err("Got CDB: 0x%02x with DPO bit set, but device"
-				   " does not advertise support for DPO\n",
+			target_err("Got CDB: 0x%02x with DPO bit set, but device does not advertise support for DPO\n",
 				   cdb[0]);
 			return -EINVAL;
 		}
 	}
 	if (cdb[1] & 0x8) {
 		if (!target_check_fua(dev)) {
-			target_err("Got CDB: 0x%02x with FUA bit set, but device"
-				   " does not advertise support for FUA write\n",
+			target_err("Got CDB: 0x%02x with FUA bit set, but device does not advertise support for FUA write\n",
 				   cdb[0]);
 			return -EINVAL;
 		}
@@ -883,8 +874,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 		case WRITE_SAME_32:
 			sectors = transport_get_sectors_32(cdb);
 			if (!sectors) {
-				target_err("WSNZ=1, WRITE_SAME w/sectors=0 not"
-					   " supported\n");
+				target_err("WSNZ=1, WRITE_SAME w/sectors=0 not supported\n");
 				return TCM_INVALID_CDB_FIELD;
 			}
 
@@ -896,8 +886,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 				return ret;
 			break;
 		default:
-			target_err("VARIABLE_LENGTH_CMD service action"
-				   " 0x%04x not supported\n",
+			target_err("VARIABLE_LENGTH_CMD service action 0x%04x not supported\n",
 				   service_action);
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
@@ -916,9 +905,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 		 * Currently enforce COMPARE_AND_WRITE for a single sector
 		 */
 		if (sectors > 1) {
-			target_err("COMPARE_AND_WRITE contains NoLB: %u greater"
-				   " than 1\n",
-				   sectors);
+			target_err("COMPARE_AND_WRITE contains NoLB: %u greater than 1\n", sectors);
 			return TCM_INVALID_CDB_FIELD;
 		}
 		if (sbc_check_dpofua(dev, cmd, cdb))
@@ -974,8 +961,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 
 		if (!dev->dev_attrib.emulate_tpu) {
-			target_err("Got UNMAP, but backend device has"
-				   " emulate_tpu disabled\n");
+			target_err("Got UNMAP, but backend device has emulate_tpu disabled\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 		size = get_unaligned_be16(&cdb[7]);
@@ -1057,9 +1043,8 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 		end_lba = dev->transport->get_blocks(dev) + 1;
 		if (((cmd->t_task_lba + sectors) < cmd->t_task_lba) ||
 		    ((cmd->t_task_lba + sectors) > end_lba)) {
-			target_err("cmd exceeds last lba %llu "
-				   "(lba %llu, sectors %u)\n",
-				   end_lba, cmd->t_task_lba, sectors);
+			target_err("cmd exceeds last lba %llu (lba %llu, sectors %u)\n", end_lba,
+				   cmd->t_task_lba, sectors);
 			return TCM_ADDRESS_OUT_OF_RANGE;
 		}
 
@@ -1124,8 +1109,7 @@ sbc_execute_unmap(struct se_cmd *cmd)
 
 	/* First UNMAP block descriptor starts at 8 byte offset */
 	ptr = &buf[8];
-	target_debug("UNMAP: Sub: %s Using dl: %u bd_dl: %u size: %u"
-		     " ptr: %p\n",
+	target_debug("UNMAP: Sub: %s Using dl: %u bd_dl: %u size: %u ptr: %p\n",
 		     dev->transport->name, dl, bd_dl, size, ptr);
 
 	while (size >= 16) {
@@ -1214,8 +1198,7 @@ sbc_dif_generate(struct se_cmd *cmd)
 				sdt->ref_tag = cpu_to_be32(sector & 0xffffffff);
 			sdt->app_tag = 0;
 
-			target_debug("DIF %s INSERT sector: %llu guard_tag: 0x%04x"
-				     " app_tag: 0x%04x ref_tag: %u\n",
+			target_debug("DIF %s INSERT sector: %llu guard_tag: 0x%04x app_tag: 0x%04x ref_tag: %u\n",
 				     (cmd->data_direction == DMA_TO_DEVICE) ? "WRITE" : "READ",
 				     (unsigned long long)sector, sdt->guard_tag, sdt->app_tag,
 				     be32_to_cpu(sdt->ref_tag));
@@ -1240,8 +1223,7 @@ sbc_dif_v1_verify(struct se_cmd *cmd, struct t10_pi_tuple *sdt,
 	csum = cpu_to_be16(crc);
 
 	if (sdt->guard_tag != csum) {
-		target_err("DIFv1 checksum failed on sector %llu guard tag 0x%04x"
-			   " csum 0x%04x\n",
+		target_err("DIFv1 checksum failed on sector %llu guard tag 0x%04x csum 0x%04x\n",
 			   (unsigned long long)sector, be16_to_cpu(sdt->guard_tag),
 			   be16_to_cpu(csum));
 		return TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
@@ -1253,8 +1235,7 @@ sbc_dif_v1_verify(struct se_cmd *cmd, struct t10_pi_tuple *sdt,
 
 	if (cmd->prot_type == TARGET_DIF_TYPE1_PROT &&
 	    be32_to_cpu(sdt->ref_tag) != (sector & 0xffffffff)) {
-		target_err("DIFv1 Type 1 reference failed on sector: %llu tag: 0x%08x"
-			   " sector MSB: 0x%08x\n",
+		target_err("DIFv1 Type 1 reference failed on sector: %llu tag: 0x%08x sector MSB: 0x%08x\n",
 			   (unsigned long long)sector, be32_to_cpu(sdt->ref_tag),
 			   (u32)(sector & 0xffffffff));
 		return TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
@@ -1262,8 +1243,7 @@ sbc_dif_v1_verify(struct se_cmd *cmd, struct t10_pi_tuple *sdt,
 
 	if (cmd->prot_type == TARGET_DIF_TYPE2_PROT &&
 	    be32_to_cpu(sdt->ref_tag) != ei_lba) {
-		target_err("DIFv1 Type 2 reference failed on sector: %llu tag: 0x%08x"
-			   " ei_lba: 0x%08x\n",
+		target_err("DIFv1 Type 2 reference failed on sector: %llu tag: 0x%08x ei_lba: 0x%08x\n",
 			   (unsigned long long)sector, be32_to_cpu(sdt->ref_tag), ei_lba);
 		return TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
 	}
@@ -1353,8 +1333,7 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 
 			sdt = paddr + i;
 
-			target_debug("DIF READ sector: %llu guard_tag: 0x%04x"
-				     " app_tag: 0x%04x ref_tag: %u\n",
+			target_debug("DIF READ sector: %llu guard_tag: 0x%04x app_tag: 0x%04x ref_tag: %u\n",
 				     (unsigned long long)sector, sdt->guard_tag, sdt->app_tag,
 				     be32_to_cpu(sdt->ref_tag));
 
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 7c5c117389cc..f8e6698eede1 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -62,8 +62,7 @@ spc_find_scsi_transport_vd(int proto_id)
 	case SCSI_PROTOCOL_SRP:
 		return SCSI_VERSION_DESCRIPTOR_SRP;
 	default:
-		target_warn("Cannot find VERSION DESCRIPTOR value for unknown SCSI"
-			    " transport PROTOCOL IDENTIFIER %#x\n",
+		target_warn("Cannot find VERSION DESCRIPTOR value for unknown SCSI transport PROTOCOL IDENTIFIER %#x\n",
 			    proto_id);
 		return 0;
 	}
@@ -1212,8 +1211,7 @@ static sense_reason_t spc_emulate_request_sense(struct se_cmd *cmd)
 	memset(buf, 0, SE_SENSE_BUF);
 
 	if (cdb[1] & 0x01) {
-		target_err("REQUEST_SENSE description emulation not"
-			   " supported\n");
+		target_err("REQUEST_SENSE description emulation not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -2125,8 +2123,7 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 	*opcode = NULL;
 
 	if (opts > 3) {
-		target_debug("TARGET_CORE[%s]: Invalid REPORT SUPPORTED OPERATION CODES"
-			     " with unsupported REPORTING OPTIONS %#x for 0x%08llx from %s\n",
+		target_debug("TARGET_CORE[%s]: Invalid REPORT SUPPORTED OPERATION CODES with unsupported REPORTING OPTIONS %#x for 0x%08llx from %s\n",
 			     cmd->se_tfo->fabric_name, opts, cmd->se_lun->unpacked_lun,
 			     sess->se_node_acl->initiatorname);
 		return TCM_INVALID_CDB_FIELD;
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index aa1c099fa92e..09bc8afe5252 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -87,8 +87,7 @@ static bool __target_check_io_state(struct se_cmd *se_cmd,
 	 */
 	spin_lock(&se_cmd->t_state_lock);
 	if (se_cmd->transport_state & (CMD_T_COMPLETE | CMD_T_FABRIC_STOP)) {
-		target_debug("Attempted to abort io tag: %llu already complete or"
-			     " fabric stop, skipping\n",
+		target_debug("Attempted to abort io tag: %llu already complete or fabric stop, skipping\n",
 			     se_cmd->tag);
 		spin_unlock(&se_cmd->t_state_lock);
 		return false;
@@ -236,8 +235,7 @@ static void core_tmr_drain_tmr_list(
 		list_del_init(&tmr_p->tmr_list);
 		cmd = tmr_p->task_cmd;
 
-		target_debug("LUN_RESET: %s releasing TMR %p Function: 0x%02x,"
-			     " Response: 0x%02x, t_state: %d\n",
+		target_debug("LUN_RESET: %s releasing TMR %p Function: 0x%02x, Response: 0x%02x, t_state: %d\n",
 			     (preempt_and_abort_list) ? "Preempt" : "", tmr_p, tmr_p->function,
 			     tmr_p->response, cmd->t_state);
 
@@ -382,8 +380,7 @@ int core_tmr_lun_reset(
 		tmr_nacl = tmr_sess->se_node_acl;
 		tmr_tpg = tmr_sess->se_tpg;
 		if (tmr_nacl && tmr_tpg) {
-			target_debug("LUN_RESET: TMR caller fabric: %s"
-				     " initiator port %s\n",
+			target_debug("LUN_RESET: TMR caller fabric: %s initiator port %s\n",
 				     tmr_tpg->se_tpg_tfo->fabric_name, tmr_nacl->initiatorname);
 		}
 	}
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 90d59ac5e4aa..9992714af597 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -134,8 +134,7 @@ void core_tpg_add_node_to_devs(
 				lun_access_ro = false;
 		}
 
-		target_debug("TARGET_CORE[%s]->TPG[%u]_LUN[%llu] - Adding %s"
-			     " access for LUN in Demo Mode\n",
+		target_debug("TARGET_CORE[%s]->TPG[%u]_LUN[%llu] - Adding %s access for LUN in Demo Mode\n",
 			     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
 			     lun->unpacked_lun, lun_access_ro ? "READ-ONLY" : "READ-WRITE");
 
@@ -159,8 +158,7 @@ target_set_nacl_queue_depth(struct se_portal_group *tpg,
 	acl->queue_depth = queue_depth;
 
 	if (!acl->queue_depth) {
-		target_warn("Queue depth for %s Initiator Node: %s is 0,"
-			    "defaulting to 1.\n",
+		target_warn("Queue depth for %s Initiator Node: %s is 0, defaulting to 1.\n",
 			    tpg->se_tpg_tfo->fabric_name, acl->initiatorname);
 		acl->queue_depth = 1;
 	}
@@ -209,8 +207,7 @@ static void target_add_node_acl(struct se_node_acl *acl)
 	list_add_tail(&acl->acl_list, &tpg->acl_node_list);
 	mutex_unlock(&tpg->acl_node_mutex);
 
-	target_debug("%s_TPG[%hu] - Added %s ACL with TCQ Depth: %d for %s"
-		     " Initiator Node: %s\n",
+	target_debug("%s_TPG[%hu] - Added %s ACL with TCQ Depth: %d for %s Initiator Node: %s\n",
 		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
 		     acl->dynamic_node_acl ? "DYNAMIC" : "", acl->queue_depth,
 		     tpg->se_tpg_tfo->fabric_name, acl->initiatorname);
@@ -293,17 +290,14 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 	if (acl) {
 		if (acl->dynamic_node_acl) {
 			acl->dynamic_node_acl = 0;
-			target_debug("%s_TPG[%u] - Replacing dynamic ACL"
-				     " for %s\n",
+			target_debug("%s_TPG[%u] - Replacing dynamic ACL for %s\n",
 				     tpg->se_tpg_tfo->fabric_name,
 				     tpg->se_tpg_tfo->tpg_get_tag(tpg), initiatorname);
 			mutex_unlock(&tpg->acl_node_mutex);
 			return acl;
 		}
 
-		target_err("ACL entry for %s Initiator"
-			   " Node %s already exists for TPG %u, ignoring"
-			   " request.\n",
+		target_err("ACL entry for %s Initiator Node %s already exists for TPG %u, ignoring request.\n",
 			   tpg->se_tpg_tfo->fabric_name, initiatorname,
 			   tpg->se_tpg_tfo->tpg_get_tag(tpg));
 		mutex_unlock(&tpg->acl_node_mutex);
@@ -362,8 +356,7 @@ void core_tpg_del_initiator_node_acl(struct se_node_acl *acl)
 	core_tpg_wait_for_nacl_pr_ref(acl);
 	core_free_device_list_for_node(acl, tpg);
 
-	target_debug("%s_TPG[%hu] - Deleted ACL with TCQ Depth: %d for %s"
-		     " Initiator Node: %s\n",
+	target_debug("%s_TPG[%hu] - Deleted ACL with TCQ Depth: %d for %s Initiator Node: %s\n",
 		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
 		     acl->queue_depth, tpg->se_tpg_tfo->fabric_name, acl->initiatorname);
 
@@ -399,8 +392,7 @@ int core_tpg_set_initiator_node_queue_depth(
 	 */
 	target_shutdown_sessions(acl);
 
-	target_debug("Successfully changed queue depth to: %d for Initiator"
-		     " Node: %s on %s Target Portal Group: %u\n",
+	target_debug("Successfully changed queue depth to: %d for Initiator Node: %s on %s Target Portal Group: %u\n",
 		     acl->queue_depth, acl->initiatorname, tpg->se_tpg_tfo->fabric_name,
 		     tpg->se_tpg_tfo->tpg_get_tag(tpg));
 
@@ -550,8 +542,7 @@ int core_tpg_register(
 		}
 	}
 
-	target_debug("TARGET_CORE[%s]: Allocated portal_group for endpoint: %s, "
-		     "Proto: %d, Portal Tag: %u\n",
+	target_debug("TARGET_CORE[%s]: Allocated portal_group for endpoint: %s, Proto: %d, Portal Tag: %u\n",
 		     se_tpg->se_tpg_tfo->fabric_name,
 		     se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg) ?
 		     se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg) : NULL,
@@ -567,8 +558,7 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 	struct se_node_acl *nacl, *nacl_tmp;
 	LIST_HEAD(node_list);
 
-	target_debug("TARGET_CORE[%s]: Deallocating portal_group for endpoint: %s, "
-		     "Proto: %d, Portal Tag: %u\n",
+	target_debug("TARGET_CORE[%s]: Deallocating portal_group for endpoint: %s, Proto: %d, Portal Tag: %u\n",
 		     tfo->fabric_name, tfo->tpg_get_wwn(se_tpg) ? tfo->tpg_get_wwn(se_tpg) : NULL,
 		     se_tpg->proto_id, tfo->tpg_get_tag(se_tpg));
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 65a7d8fb52ec..4bfce006eefd 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -63,8 +63,7 @@ int init_se_kmem_caches(void)
 			sizeof(struct se_session), __alignof__(struct se_session),
 			0, NULL);
 	if (!se_sess_cache) {
-		target_err("kmem_cache_create() for struct se_session"
-			   " failed\n");
+		target_err("kmem_cache_create() for struct se_session failed\n");
 		goto out;
 	}
 	se_ua_cache = kmem_cache_create("se_ua_cache",
@@ -78,32 +77,28 @@ int init_se_kmem_caches(void)
 			sizeof(struct t10_pr_registration),
 			__alignof__(struct t10_pr_registration), 0, NULL);
 	if (!t10_pr_reg_cache) {
-		target_err("kmem_cache_create() for struct t10_pr_registration"
-			   " failed\n");
+		target_err("kmem_cache_create() for struct t10_pr_registration failed\n");
 		goto out_free_ua_cache;
 	}
 	t10_alua_lu_gp_cache = kmem_cache_create("t10_alua_lu_gp_cache",
 			sizeof(struct t10_alua_lu_gp), __alignof__(struct t10_alua_lu_gp),
 			0, NULL);
 	if (!t10_alua_lu_gp_cache) {
-		target_err("kmem_cache_create() for t10_alua_lu_gp_cache"
-			   " failed\n");
+		target_err("kmem_cache_create() for t10_alua_lu_gp_cache failed\n");
 		goto out_free_pr_reg_cache;
 	}
 	t10_alua_lu_gp_mem_cache = kmem_cache_create("t10_alua_lu_gp_mem_cache",
 			sizeof(struct t10_alua_lu_gp_member),
 			__alignof__(struct t10_alua_lu_gp_member), 0, NULL);
 	if (!t10_alua_lu_gp_mem_cache) {
-		target_err("kmem_cache_create() for t10_alua_lu_gp_mem_"
-			   "cache failed\n");
+		target_err("kmem_cache_create() for t10_alua_lu_gp_mem_cache failed\n");
 		goto out_free_lu_gp_cache;
 	}
 	t10_alua_tg_pt_gp_cache = kmem_cache_create("t10_alua_tg_pt_gp_cache",
 			sizeof(struct t10_alua_tg_pt_gp),
 			__alignof__(struct t10_alua_tg_pt_gp), 0, NULL);
 	if (!t10_alua_tg_pt_gp_cache) {
-		target_err("kmem_cache_create() for t10_alua_tg_pt_gp_"
-			   "cache failed\n");
+		target_err("kmem_cache_create() for t10_alua_tg_pt_gp_cache failed\n");
 		goto out_free_lu_gp_mem_cache;
 	}
 	t10_alua_lba_map_cache = kmem_cache_create(
@@ -111,8 +106,7 @@ int init_se_kmem_caches(void)
 			sizeof(struct t10_alua_lba_map),
 			__alignof__(struct t10_alua_lba_map), 0, NULL);
 	if (!t10_alua_lba_map_cache) {
-		target_err("kmem_cache_create() for t10_alua_lba_map_"
-			   "cache failed\n");
+		target_err("kmem_cache_create() for t10_alua_lba_map_cache failed\n");
 		goto out_free_tg_pt_gp_cache;
 	}
 	t10_alua_lba_map_mem_cache = kmem_cache_create(
@@ -120,8 +114,7 @@ int init_se_kmem_caches(void)
 			sizeof(struct t10_alua_lba_map_member),
 			__alignof__(struct t10_alua_lba_map_member), 0, NULL);
 	if (!t10_alua_lba_map_mem_cache) {
-		target_err("kmem_cache_create() for t10_alua_lba_map_mem_"
-			   "cache failed\n");
+		target_err("kmem_cache_create() for t10_alua_lba_map_mem_cache failed\n");
 		goto out_free_lba_map_cache;
 	}
 
@@ -292,8 +285,7 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 
 	se_sess = kmem_cache_zalloc(se_sess_cache, GFP_KERNEL);
 	if (!se_sess) {
-		target_err("Unable to allocate struct se_session from"
-			   " se_sess_cache\n");
+		target_err("Unable to allocate struct se_session from se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	transport_init_session(se_sess);
@@ -325,9 +317,7 @@ int transport_alloc_session_tags(struct se_session *se_sess,
 	rc = sbitmap_queue_init_node(&se_sess->sess_tag_pool, tag_num, -1,
 			false, GFP_KERNEL, NUMA_NO_NODE);
 	if (rc < 0) {
-		target_err("Unable to init se_sess->sess_tag_pool,"
-			   " tag_num: %u\n",
-			   tag_num);
+		target_err("Unable to init se_sess->sess_tag_pool, tag_num: %u\n", tag_num);
 		kvfree(se_sess->sess_cmd_map);
 		se_sess->sess_cmd_map = NULL;
 		return -ENOMEM;
@@ -352,14 +342,12 @@ transport_init_session_tags(unsigned int tag_num, unsigned int tag_size,
 	int rc;
 
 	if (tag_num != 0 && !tag_size) {
-		target_err("init_session_tags called with percpu-ida tag_num:"
-			   " %u, but zero tag_size\n",
+		target_err("init_session_tags called with percpu-ida tag_num: %u, but zero tag_size\n",
 			   tag_num);
 		return ERR_PTR(-EINVAL);
 	}
 	if (!tag_num && tag_size) {
-		target_err("init_session_tags called with percpu-ida tag_size:"
-			   " %u, but zero tag_num\n",
+		target_err("init_session_tags called with percpu-ida tag_size: %u, but zero tag_num\n",
 			   tag_size);
 		return ERR_PTR(-EINVAL);
 	}
@@ -1016,8 +1004,7 @@ void target_qf_do_work(struct work_struct *work)
 		list_del(&cmd->se_qf_node);
 		atomic_dec_mb(&dev->dev_qf_count);
 
-		target_debug("Processing %s cmd: %p QUEUE_FULL in work queue"
-			     " context: %s\n",
+		target_debug("Processing %s cmd: %p QUEUE_FULL in work queue context: %s\n",
 			     cmd->se_tfo->fabric_name, cmd,
 			     (cmd->t_state == TRANSPORT_COMPLETE_QF_OK) ? "COMPLETE_OK" :
 			     (cmd->t_state == TRANSPORT_COMPLETE_QF_WP) ? "WRITE_PENDING"
@@ -1393,9 +1380,7 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 	if (cmd->unknown_data_length) {
 		cmd->data_length = size;
 	} else if (size != cmd->data_length) {
-		target_warn_ratelimited("TARGET_CORE[%s]: Expected Transfer Length:"
-					" %u does not match SCSI CDB Length: %u for SAM Opcode:"
-					" 0x%02x\n",
+		target_warn_ratelimited("TARGET_CORE[%s]: Expected Transfer Length: %u does not match SCSI CDB Length: %u for SAM Opcode: 0x%02x\n",
 					cmd->se_tfo->fabric_name, cmd->data_length, size,
 					cmd->t_task_cdb[0]);
 		/*
@@ -1421,8 +1406,7 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 
 		if (cmd->data_direction == DMA_TO_DEVICE) {
 			if (cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) {
-				target_err_ratelimited("Rejecting underflow/overflow"
-						       " for WRITE data CDB\n");
+				target_err_ratelimited("Rejecting underflow/overflow for WRITE data CDB\n");
 				return TCM_INVALID_FIELD_IN_COMMAND_IU;
 			}
 			/*
@@ -1432,8 +1416,7 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 			 * is introduced tree-wide.
 			 */
 			if (size > cmd->data_length) {
-				target_err_ratelimited("Rejecting overflow for"
-						       " WRITE control CDB\n");
+				target_err_ratelimited("Rejecting overflow for WRITE control CDB\n");
 				return TCM_INVALID_CDB_FIELD;
 			}
 		}
@@ -1496,8 +1479,7 @@ transport_check_alloc_task_attr(struct se_cmd *cmd)
 		return 0;
 
 	if (cmd->sam_task_attr == TCM_ACA_TAG) {
-		target_debug("SAM Task Attribute ACA"
-			     " emulation is not supported\n");
+		target_debug("SAM Task Attribute ACA emulation is not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -1514,8 +1496,7 @@ target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb, gfp_t gfp)
 	 * for VARIABLE_LENGTH_CMD
 	 */
 	if (scsi_command_size(cdb) > SCSI_MAX_VARLEN_CDB_SIZE) {
-		target_err("Received SCSI CDB with command_size: %d that"
-			   " exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
+		target_err("Received SCSI CDB with command_size: %d that exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
 			   scsi_command_size(cdb), SCSI_MAX_VARLEN_CDB_SIZE);
 		ret = TCM_INVALID_CDB_FIELD;
 		goto err;
@@ -1528,8 +1509,7 @@ target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb, gfp_t gfp)
 	if (scsi_command_size(cdb) > sizeof(cmd->__t_task_cdb)) {
 		cmd->t_task_cdb = kzalloc(scsi_command_size(cdb), gfp);
 		if (!cmd->t_task_cdb) {
-			target_err("Unable to allocate cmd->t_task_cdb"
-				   " %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
+			target_err("Unable to allocate cmd->t_task_cdb %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
 				   scsi_command_size(cdb),
 				   (unsigned long)sizeof(cmd->__t_task_cdb));
 			ret = TCM_OUT_OF_RESOURCES;
@@ -1654,8 +1634,7 @@ transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *sgl,
 	 * passes for the original expected data transfer length.
 	 */
 	if (cmd->se_cmd_flags & SCF_OVERFLOW_BIT) {
-		target_warn("Rejecting SCSI DATA overflow for fabric using"
-			    " SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC\n");
+		target_warn("Rejecting SCSI DATA overflow for fabric using SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -2649,9 +2628,8 @@ static void target_complete_ok_work(struct work_struct *work)
 	return;
 
 queue_full:
-	target_debug("Handling complete_ok QUEUE_FULL: se_cmd: %p,"
-		     " data_direction: %d\n",
-		     cmd, cmd->data_direction);
+	target_debug("Handling complete_ok QUEUE_FULL: se_cmd: %p, data_direction: %d\n", cmd,
+		     cmd->data_direction);
 
 	transport_handle_queue_full(cmd, cmd->se_dev, ret, false);
 }
@@ -3278,8 +3256,7 @@ __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
 	spin_lock_irqsave(&cmd->t_state_lock, *flags);
 	cmd->transport_state &= ~(CMD_T_ACTIVE | CMD_T_STOP);
 
-	target_debug("wait_for_tasks: Stopped wait_for_completion(&cmd->"
-		     "t_transport_stop_comp) for ITT: 0x%08llx\n",
+	target_debug("wait_for_tasks: Stopped wait_for_completion(&cmd->t_transport_stop_comp) for ITT: 0x%08llx\n",
 		     cmd->tag);
 
 	return true;
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index 825039a5be08..faa7a3ffec68 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -146,8 +146,7 @@ int core_scsi3_ua_allocate(
 	list_add_tail(&ua->ua_nacl_list, &deve->ua_list);
 	spin_unlock(&deve->ua_lock);
 
-	target_debug("Allocated UNIT ATTENTION, mapped LUN: %llu, ASC:"
-		     " 0x%02x, ASCQ: 0x%02x\n",
+	target_debug("Allocated UNIT ATTENTION, mapped LUN: %llu, ASC: 0x%02x, ASCQ: 0x%02x\n",
 		     deve->mapped_lun, asc, ascq);
 
 	return 0;
@@ -252,9 +251,7 @@ bool core_scsi3_ua_for_check_condition(struct se_cmd *cmd, u8 *key, u8 *asc,
 	spin_unlock(&deve->ua_lock);
 	rcu_read_unlock();
 
-	target_debug("[%s]: %s UNIT ATTENTION condition with"
-		     " INTLCK_CTRL: %d, mapped LUN: %llu, got CDB: 0x%02x"
-		     " reported ASC: 0x%02x, ASCQ: 0x%02x\n",
+	target_debug("[%s]: %s UNIT ATTENTION condition with INTLCK_CTRL: %d, mapped LUN: %llu, got CDB: 0x%02x reported ASC: 0x%02x, ASCQ: 0x%02x\n",
 		     nacl->se_tpg->se_tpg_tfo->fabric_name,
 		     dev_ua_intlck_clear ? "Releasing" : "Reporting",
 		     dev->dev_attrib.emulate_ua_intlck_ctrl, cmd->orig_fe_lun, cmd->t_task_cdb[0],
@@ -314,9 +311,7 @@ int core_scsi3_ua_clear_for_request_sense(
 	spin_unlock(&deve->ua_lock);
 	rcu_read_unlock();
 
-	target_debug("[%s]: Released UNIT ATTENTION condition, mapped"
-		     " LUN: %llu, got REQUEST_SENSE reported ASC: 0x%02x,"
-		     " ASCQ: 0x%02x\n",
+	target_debug("[%s]: Released UNIT ATTENTION condition, mapped LUN: %llu, got REQUEST_SENSE reported ASC: 0x%02x, ASCQ: 0x%02x\n",
 		     nacl->se_tpg->se_tpg_tfo->fabric_name, cmd->orig_fe_lun, *asc, *ascq);
 
 	return (head) ? -EPERM : 0;
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 30fd6d0f3e10..23b4f75e74ea 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -157,8 +157,7 @@ static int target_xcopy_parse_tiddesc_e4(struct se_cmd *se_cmd, struct xcopy_op
 	}
 
 	if (cscd_index != xop->stdi && cscd_index != xop->dtdi) {
-		target_debug("XCOPY 0xe4: ignoring CSCD entry %d - neither src nor "
-			     "dest\n",
+		target_debug("XCOPY 0xe4: ignoring CSCD entry %d - neither src nor dest\n",
 			     cscd_index);
 		return 0;
 	}
@@ -172,8 +171,7 @@ static int target_xcopy_parse_tiddesc_e4(struct se_cmd *se_cmd, struct xcopy_op
 				XCOPY_NAA_IEEE_REGEX_LEN)) {
 			xop->op_origin = XCOL_SOURCE_RECV_OP;
 			xop->src_dev = se_cmd->se_dev;
-			target_debug("XCOPY 0xe4: Set xop->src_dev %p from source"
-				     " received xop\n",
+			target_debug("XCOPY 0xe4: Set xop->src_dev %p from source received xop\n",
 				     xop->src_dev);
 		}
 	}
@@ -190,8 +188,7 @@ static int target_xcopy_parse_tiddesc_e4(struct se_cmd *se_cmd, struct xcopy_op
 				XCOPY_NAA_IEEE_REGEX_LEN)) {
 			xop->op_origin = XCOL_DEST_RECV_OP;
 			xop->dst_dev = se_cmd->se_dev;
-			target_debug("XCOPY 0xe4: Set xop->dst_dev: %p from destination"
-				     " received xop\n",
+			target_debug("XCOPY 0xe4: Set xop->dst_dev: %p from destination received xop\n",
 				     xop->dst_dev);
 		}
 	}
@@ -212,15 +209,13 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 	*sense_ret = TCM_INVALID_PARAMETER_LIST;
 
 	if (offset != 0) {
-		target_err("XCOPY target descriptor list length is not"
-			   " multiple of %d\n",
+		target_err("XCOPY target descriptor list length is not multiple of %d\n",
 			   XCOPY_TARGET_DESC_LEN);
 		*sense_ret = TCM_UNSUPPORTED_TARGET_DESC_TYPE_CODE;
 		return -EINVAL;
 	}
 	if (tdll > RCR_OP_MAX_TARGET_DESC_COUNT * XCOPY_TARGET_DESC_LEN) {
-		target_err("XCOPY target descriptor supports a maximum"
-			   " two src/dest descriptors, tdll: %hu too large..\n",
+		target_err("XCOPY target descriptor supports a maximum two src/dest descriptors, tdll: %hu too large..\n",
 			   tdll);
 		/* spc4r37 6.4.3.4 CSCD DESCRIPTOR LIST LENGTH field */
 		*sense_ret = TCM_TOO_MANY_TARGET_DESCS;
@@ -250,9 +245,7 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 			cscd_index++;
 			break;
 		default:
-			target_err("XCOPY unsupported descriptor type code:"
-				   " 0x%02x\n",
-				   desc[0]);
+			target_err("XCOPY unsupported descriptor type code: 0x%02x\n", desc[0]);
 			*sense_ret = TCM_UNSUPPORTED_TARGET_DESC_TYPE_CODE;
 			goto out;
 		}
@@ -272,8 +265,7 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 						&xop->remote_lun_ref);
 		break;
 	default:
-		target_err("XCOPY CSCD descriptor IDs not found in CSCD list - "
-			   "stdi: %hu dtdi: %hu\n",
+		target_err("XCOPY CSCD descriptor IDs not found in CSCD list - stdi: %hu dtdi: %hu\n",
 			   xop->stdi, xop->dtdi);
 		rc = -EINVAL;
 		break;
@@ -308,9 +300,7 @@ static int target_xcopy_parse_segdesc_02(struct xcopy_op *xop, unsigned char *p)
 
 	desc_len = get_unaligned_be16(&desc[2]);
 	if (desc_len != 0x18) {
-		target_err("XCOPY segment desc 0x02: Illegal desc_len:"
-			   " %hu\n",
-			   desc_len);
+		target_err("XCOPY segment desc 0x02: Illegal desc_len: %hu\n", desc_len);
 		return -EINVAL;
 	}
 
@@ -347,15 +337,13 @@ static int target_xcopy_parse_segment_descriptors(struct xcopy_op *xop,
 	*sense_ret = TCM_INVALID_PARAMETER_LIST;
 
 	if (offset != 0) {
-		target_err("XCOPY segment descriptor list length is not"
-			   " multiple of %d\n",
+		target_err("XCOPY segment descriptor list length is not multiple of %d\n",
 			   XCOPY_SEGMENT_DESC_LEN);
 		*sense_ret = TCM_UNSUPPORTED_SEGMENT_DESC_TYPE_CODE;
 		return -EINVAL;
 	}
 	if (sdll > RCR_OP_MAX_SG_DESC_COUNT * XCOPY_SEGMENT_DESC_LEN) {
-		target_err("XCOPY supports %u segment descriptor(s), sdll: %u too"
-			   " large..\n",
+		target_err("XCOPY supports %u segment descriptor(s), sdll: %u too large..\n",
 			   RCR_OP_MAX_SG_DESC_COUNT, sdll);
 		/* spc4r37 6.4.3.5 SEGMENT DESCRIPTOR LIST LENGTH field */
 		*sense_ret = TCM_TOO_MANY_SEGMENT_DESCS;
@@ -377,9 +365,7 @@ static int target_xcopy_parse_segment_descriptors(struct xcopy_op *xop,
 			desc += XCOPY_SEGMENT_DESC_LEN;
 			break;
 		default:
-			target_err("XCOPY unsupported segment descriptor"
-				   "type: 0x%02x\n",
-				   desc[0]);
+			target_err("XCOPY unsupported segment descriptortype: 0x%02x\n", desc[0]);
 			*sense_ret = TCM_UNSUPPORTED_SEGMENT_DESC_TYPE_CODE;
 			goto out;
 		}
@@ -548,9 +534,8 @@ static int target_xcopy_setup_pt_cmd(
 					xop->xop_data_nents, NULL, 0))
 		return -EINVAL;
 
-	target_debug("Setup PASSTHROUGH_NOALLOC t_data_sg: %p t_data_nents:"
-		     " %u\n",
-		     cmd->t_data_sg, cmd->t_data_nents);
+	target_debug("Setup PASSTHROUGH_NOALLOC t_data_sg: %p t_data_nents: %u\n", cmd->t_data_sg,
+		     cmd->t_data_nents);
 
 	return 0;
 }
@@ -608,8 +593,7 @@ static int target_xcopy_read_source(
 		goto out;
 	}
 
-	target_debug("XCOPY-READ: Saved xop->xop_data_sg: %p, num: %u for READ"
-		     " memory\n",
+	target_debug("XCOPY-READ: Saved xop->xop_data_sg: %p, num: %u for READ memory\n",
 		     xop->xop_data_sg, xop->xop_data_nents);
 
 	rc = target_xcopy_issue_pt_cmd(&xpt_cmd);
@@ -829,15 +813,13 @@ static sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop)
 	}
 
 	if (se_cmd->data_length < (XCOPY_HDR_LEN + tdll + sdll + inline_dl)) {
-		target_err("XCOPY parameter truncation: data length %u too small "
-			   "for tdll: %hu sdll: %u inline_dl: %u\n",
+		target_err("XCOPY parameter truncation: data length %u too small for tdll: %hu sdll: %u inline_dl: %u\n",
 			   se_cmd->data_length, tdll, sdll, inline_dl);
 		ret = TCM_PARAMETER_LIST_LENGTH_ERROR;
 		goto out;
 	}
 
-	target_debug("Processing XCOPY with list_id: 0x%02x list_id_usage: 0x%02x"
-		     " tdll: %hu sdll: %u inline_dl: %u\n",
+	target_debug("Processing XCOPY with list_id: 0x%02x list_id_usage: 0x%02x tdll: %hu sdll: %u inline_dl: %u\n",
 		     list_id, list_id_usage, tdll, sdll, inline_dl);
 
 	/*
@@ -859,8 +841,7 @@ static sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop)
 
 	if (xop->src_dev->dev_attrib.block_size !=
 	    xop->dst_dev->dev_attrib.block_size) {
-		target_err("XCOPY: Non matching src_dev block_size: %u + dst_dev"
-			   " block_size: %u currently unsupported\n",
+		target_err("XCOPY: Non matching src_dev block_size: %u + dst_dev block_size: %u currently unsupported\n",
 			   xop->src_dev->dev_attrib.block_size,
 			   xop->dst_dev->dev_attrib.block_size);
 		xcopy_pt_undepend_remotedev(xop);
@@ -928,14 +909,12 @@ static sense_reason_t target_rcr_operating_parameters(struct se_cmd *se_cmd)
 
 	p = transport_kmap_data_sg(se_cmd);
 	if (!p) {
-		target_err("transport_kmap_data_sg failed in"
-			   " target_rcr_operating_parameters\n");
+		target_err("transport_kmap_data_sg failed in target_rcr_operating_parameters\n");
 		return TCM_OUT_OF_RESOURCES;
 	}
 
 	if (se_cmd->data_length < 54) {
-		target_err("Receive Copy Results Op Parameters length"
-			   " too small: %u\n",
+		target_err("Receive Copy Results Op Parameters length too small: %u\n",
 			   se_cmd->data_length);
 		transport_kunmap_data_sg(se_cmd);
 		return TCM_INVALID_CDB_FIELD;
@@ -1025,13 +1004,11 @@ sense_reason_t target_do_receive_copy_results(struct se_cmd *se_cmd)
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
-	target_debug("Entering target_do_receive_copy_results: SA: 0x%02x, List ID:"
-		     " 0x%02x, AL: %u\n",
+	target_debug("Entering target_do_receive_copy_results: SA: 0x%02x, List ID: 0x%02x, AL: %u\n",
 		     sa, list_id, se_cmd->data_length);
 
 	if (list_id != 0) {
-		target_err("Receive Copy Results with non zero list identifier"
-			   " not supported\n");
+		target_err("Receive Copy Results with non zero list identifier not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
 
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 9ab560d9f520..2372f08b91c3 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -44,15 +44,13 @@ static void _ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
 		     se_cmd->t_data_nents, se_cmd->data_length, se_cmd->se_cmd_flags);
 
 	for_each_sg(se_cmd->t_data_sg, sg, se_cmd->t_data_nents, count)
-		target_debug("%s: cmd %p sg %p page %p "
-			     "len 0x%x off 0x%x\n",
-			     caller, cmd, sg, sg_page(sg), sg->length, sg->offset);
+		target_debug("%s: cmd %p sg %p page %p len 0x%x off 0x%x\n", caller, cmd, sg,
+			     sg_page(sg), sg->length, sg->offset);
 
 	sp = cmd->seq;
 	if (sp) {
 		ep = fc_seq_exch(sp);
-		target_debug("%s: cmd %p sid %x did %x "
-			     "ox_id %x rx_id %x seq_id %x e_stat %x\n",
+		target_debug("%s: cmd %p sid %x did %x ox_id %x rx_id %x seq_id %x e_stat %x\n",
 			     caller, cmd, ep->sid, ep->did, ep->oxid, ep->rxid, sp->id,
 			     ep->esb_stat);
 	}
@@ -149,8 +147,7 @@ int ft_queue_status(struct se_cmd *se_cmd)
 
 	rc = fc_seq_send(lport, cmd->seq, fp);
 	if (rc) {
-		target_info_ratelimited("%s: Failed to send response frame %p, "
-					"xid <0x%x>\n",
+		target_info_ratelimited("%s: Failed to send response frame %p, xid <0x%x>\n",
 					__func__, fp, ep->xid);
 		/*
 		 * Generate a TASK_SET_FULL status to notify the initiator
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index cc772793149e..852c2bccf759 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -161,9 +161,7 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 			       FC_TYPE_FCP, f_ctl, fh_off);
 		error = fc_seq_send(lport, seq, fp);
 		if (error) {
-			target_info_ratelimited("%s: Failed to send frame %p, "
-						"xid <0x%x>, remaining %zu, "
-						"lso_max <0x%x>\n",
+			target_info_ratelimited("%s: Failed to send frame %p, xid <0x%x>, remaining %zu, lso_max <0x%x>\n",
 						__func__, fp, ep->xid, remaining, lport->lso_max);
 			/*
 			 * Go ahead and set TASK_SET_FULL status ignoring the
@@ -225,12 +223,7 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 		 */
 		buf = fc_frame_payload_get(fp, 1);
 		if (buf)
-			target_err("%s: xid 0x%x, f_ctl 0x%x, cmd->sg %p, "
-				   "cmd->sg_cnt 0x%x. DDP was setup"
-				   " hence not expected to receive frame with "
-				   "payload, Frame will be dropped if"
-				   "'Sequence Initiative' bit in f_ctl is"
-				   "not set\n",
+			target_err("%s: xid 0x%x, f_ctl 0x%x, cmd->sg %p, cmd->sg_cnt 0x%x. DDP was setup hence not expected to receive frame with payload, Frame will be dropped if'Sequence Initiative' bit in f_ctl isnot set\n",
 				   __func__, ep->xid, f_ctl, se_cmd->t_data_sg,
 				   se_cmd->t_data_nents);
 		/*
-- 
2.40.3

