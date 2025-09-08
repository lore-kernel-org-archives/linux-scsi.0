Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C57237A4F
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 19:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757358807; cv=none; b=WvERFI45/DO22VV89FxVyYdtjUpiP7L0ilO34yHO5KRDj44MjLA+EOD+HlyctlAvxt26aSbn3Lzz7xxguuKOjVIFDpO8ry0dNKp8BTlu7j6IkiSOenyUzBmLu15g84aIjcF8q+eNoK23E3RAydCztuch1HvVu4QrIAJ5NjPyDDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757358807; c=relaxed/simple;
	bh=//1icLJ4ufJR4zCDs7H+TQmn4zGQ4AglrZhJLSCiZ6U=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=kj7qFqKhbvVwAJclOc4lFQ0rJ2vDijx9A1Sb/aPTv6+B/FQaOXGKrSOFhh3p5X351qsCWIAqHxqIXJUbgXC402ZwYjQwxay8ncpmm+bxloaWdLoKCH9zgxgzttNOAWrpp9H1EDlYM096gjr+uy+t4VX5nL8tQhX9hrAzgGd7wEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=Fx4j3R0K; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="Fx4j3R0K"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id wjE6MEAjW9ovgQN8; Mon, 08 Sep 2025 15:13:24 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=d1Ngc6m13lU4oNOnZg0ml+HN5EGsBnGsre7eO+PZdUA=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=Fx4j3R0K7rvWQLh0usy3
	/GD0tF4nXWVDOvGmlIijSEeNtd0Xuq8/mJLamG2ktQXJASGxBzUTFNkT6O9VYViVqlWOZnzTTcRhH
	AoSOaTdi+p+9/a1MHM4c9lgGmW19RBIaq+/5ITrPLzDeUHhAOeGiWScIjxGnGmnucKGomaOGE4=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14188817; Mon, 08 Sep 2025 15:13:24 -0400
Message-ID: <7f80b39f-1237-49a2-8161-8e2c43826d03@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 8 Sep 2025 15:13:24 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 15/15] scsi: qla2xxx: improve safety of cmd lookup by handle
Content-Language: en-US
X-ASG-Orig-Subj: [PATCH 15/15] scsi: qla2xxx: improve safety of cmd lookup by handle
From: Tony Battersby <tonyb@cybernetics.com>
To: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
In-Reply-To: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1757358804
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 7494
X-ASG-Debug-ID: 1757358804-1cf43947df30c830001-ziuLRu

(target mode)

The driver associates two different structs with numeric handles and
passes the handles to the hardware.  When the hardware passes the
handle back to the driver, the driver consults a table of void * to
convert the handle back to the struct without checking the type of
struct.  This can lead to treating one type of struct as a different
type if the HBA firmware misbehaves (and some firmware versions do).  So
verify the type of struct is what is expected before using it.

But we can also do better than that.  Also verify that the exchange
address of the message sent from the hardware matches the exchange
address of the command being returned.  This adds an extra guard against
buggy HBA firmware that returns duplicate messages multiple times
(which has also been seen) in case the driver has reused the handle for
a different command of the same type.

These problems were seen on a QLE2694L with firmware 9.08.02 when
testing SLER / SRR support.  The SRR caused the HBA to flood the
response queue with hundreds of bogus entries.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c    |   2 +-
 drivers/scsi/qla2xxx/qla_target.c | 115 ++++++++++++++++++++++++------
 2 files changed, 96 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 9f56bec26231..a7e3ec9bba47 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -54,7 +54,7 @@
  * | Misc                         |       0xd303       | 0xd031-0xd0ff	|
  * |                              |                    | 0xd101-0xd1fe	|
  * |                              |                    | 0xd214-0xd2fe	|
- * | Target Mode		  |	  0xe086       |		|
+ * | Target Mode		  |	  0xe089       |		|
  * | Target Mode Management	  |	  0xf09b       | 0xf002		|
  * |                              |                    | 0xf046-0xf049  |
  * | Target Mode Task Management  |	  0x1000d      |		|
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 70e1810d4996..a2f880ceb8d6 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3993,7 +3993,8 @@ static int qlt_prepare_srr_ctio(struct qla_qpair *qpair,
 
 /* ha->hardware_lock supposed to be held on entry */
 static void *qlt_ctio_to_cmd(struct scsi_qla_host *vha,
-	struct rsp_que *rsp, uint32_t handle, void *ctio)
+	struct rsp_que *rsp, uint32_t handle, uint8_t cmd_type,
+	const void *ctio)
 {
 	void *cmd = NULL;
 	struct req_que *req;
@@ -4016,29 +4017,103 @@ static void *qlt_ctio_to_cmd(struct scsi_qla_host *vha,
 
 	h &= QLA_CMD_HANDLE_MASK;
 
-	if (h != QLA_TGT_NULL_HANDLE) {
-		if (unlikely(h >= req->num_outstanding_cmds)) {
-			ql_dbg(ql_dbg_tgt, vha, 0xe052,
-			    "qla_target(%d): Wrong handle %x received\n",
-			    vha->vp_idx, handle);
-			return NULL;
-		}
-
-		cmd = req->outstanding_cmds[h];
-		if (unlikely(cmd == NULL)) {
-			ql_dbg(ql_dbg_async, vha, 0xe053,
-			    "qla_target(%d): Suspicious: unable to find the command with handle %x req->id %d rsp->id %d\n",
-				vha->vp_idx, handle, req->id, rsp->id);
-			return NULL;
-		}
-		req->outstanding_cmds[h] = NULL;
-	} else if (ctio != NULL) {
+	if (h == QLA_TGT_NULL_HANDLE) {
 		/* We can't get loop ID from CTIO7 */
 		ql_dbg(ql_dbg_tgt, vha, 0xe054,
 		    "qla_target(%d): Wrong CTIO received: QLA24xx doesn't "
 		    "support NULL handles\n", vha->vp_idx);
 		return NULL;
 	}
+	if (unlikely(h >= req->num_outstanding_cmds)) {
+		ql_dbg(ql_dbg_tgt, vha, 0xe052,
+		    "qla_target(%d): Wrong handle %x received\n",
+		    vha->vp_idx, handle);
+		return NULL;
+	}
+
+	cmd = req->outstanding_cmds[h];
+
+	/*
+	 * Some places in the code set outstanding_cmds[h] to NULL and force
+	 * the command to complete early without waiting for the CTIO.  In that
+	 * case we would get cmd == NULL.  But in the rare case that the
+	 * detached handle is reused for a different command before we get the
+	 * CTIO for the detached cmd, we might find the wrong command here
+	 * instead.  So compare the cmd_type and exchange_address to make sure
+	 * that the cmd matches the CTIO.  If they don't match, return NULL and
+	 * ignore the CTIO.
+	 *
+	 * This also guards against buggy HBA firmware that returns the same
+	 * CTIO multiple times.
+	 */
+
+	if (unlikely(cmd == NULL)) {
+		if (cmd_type == TYPE_TGT_CMD) {
+			__le32 ctio_exchange_addr =
+				((const struct ctio7_from_24xx *)ctio)->
+				exchange_address;
+
+			ql_dbg(ql_dbg_tgt_mgt, vha, 0xe053,
+			    "qla_target(%d): tag %u: handle %x: cmd detached; ignoring CTIO (handle %x req->id %d rsp->id %d)\n",
+			    vha->vp_idx, le32_to_cpu(ctio_exchange_addr), h,
+			    handle, req->id, rsp->id);
+		} else {
+			ql_dbg(ql_dbg_tgt_mgt, vha, 0xe053,
+			    "qla_target(%d): cmd detached; ignoring CTIO (handle %x req->id %d rsp->id %d)\n",
+			    vha->vp_idx, handle, req->id, rsp->id);
+		}
+		return NULL;
+	}
+
+	if (unlikely(((srb_t *)cmd)->cmd_type != cmd_type)) {
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xe087,
+		    "qla_target(%d): handle %x: cmd detached; ignoring CTIO (cmd_type mismatch)\n",
+		    vha->vp_idx, h);
+		return NULL;
+	}
+
+	switch (cmd_type) {
+	case TYPE_TGT_CMD: {
+		__le32 ctio_exchange_addr =
+			((const struct ctio7_from_24xx *)ctio)->
+			exchange_address;
+		__le32 cmd_exchange_addr =
+			((struct qla_tgt_cmd *)cmd)->
+			atio.u.isp24.exchange_addr;
+
+		BUILD_BUG_ON(offsetof(struct ctio7_from_24xx,
+				      exchange_address) !=
+			     offsetof(struct ctio_crc_from_fw,
+				      exchange_address));
+
+		if (unlikely(ctio_exchange_addr != cmd_exchange_addr)) {
+			ql_dbg(ql_dbg_tgt_mgt, vha, 0xe088,
+			    "qla_target(%d): tag %u: handle %x: cmd detached; ignoring CTIO (exchange address mismatch)\n",
+			    vha->vp_idx, le32_to_cpu(ctio_exchange_addr), h);
+			return NULL;
+		}
+		break;
+	}
+
+	case TYPE_TGT_TMCMD: {
+		__le32 ctio_exchange_addr =
+			((const struct abts_resp_from_24xx_fw *)ctio)->
+			exchange_address;
+		__le32 cmd_exchange_addr =
+			((struct qla_tgt_mgmt_cmd *)cmd)->
+			orig_iocb.abts.exchange_address;
+
+		if (unlikely(ctio_exchange_addr != cmd_exchange_addr)) {
+			ql_dbg(ql_dbg_tgt_mgt, vha, 0xe089,
+			    "qla_target(%d): ABTS: handle %x: cmd detached; ignoring CTIO (exchange address mismatch)\n",
+			    vha->vp_idx, h);
+			return NULL;
+		}
+		break;
+	}
+	}
+
+	req->outstanding_cmds[h] = NULL;
 
 	return cmd;
 }
@@ -4067,7 +4142,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 
 	ctio_flags = le16_to_cpu(ctio->flags);
 
-	cmd = qlt_ctio_to_cmd(vha, rsp, handle, ctio);
+	cmd = qlt_ctio_to_cmd(vha, rsp, handle, TYPE_TGT_CMD, ctio);
 	if (unlikely(cmd == NULL)) {
 		if ((handle & ~QLA_TGT_HANDLE_MASK) == QLA_TGT_SKIP_HANDLE &&
 		    (ctio_flags & 0xe1ff) == (CTIO7_FLAGS_STATUS_MODE_1 |
@@ -6817,7 +6892,7 @@ static void qlt_handle_abts_completion(struct scsi_qla_host *vha,
 	struct qla_tgt_mgmt_cmd *mcmd;
 	struct qla_hw_data *ha = vha->hw;
 
-	mcmd = qlt_ctio_to_cmd(vha, rsp, pkt->handle, pkt);
+	mcmd = qlt_ctio_to_cmd(vha, rsp, pkt->handle, TYPE_TGT_TMCMD, pkt);
 	if (mcmd == NULL && h != QLA_TGT_SKIP_HANDLE) {
 		ql_dbg(ql_dbg_async, vha, 0xe064,
 		    "qla_target(%d): ABTS Comp without mcmd\n",
-- 
2.43.0


