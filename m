Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2503330B511
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2025 14:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759157589; cv=none; b=jDfcHYZpNPLvAqxZPIytq2aMyU6py0nvSCMyD0Ngydpzx1Z8mNkPI4DUMQ9YPrIJkbgGXR0nz2vxpph7RZEIdS/r6DtqGz6NopJiV+X4ayomasCA+7Igp1fArA9pPmogH9mFE0bW09ZaYdTvjowOsR2TYoBwJVHg7JTOABM2uW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759157589; c=relaxed/simple;
	bh=sJPonIxLs45IDD+f0gaR/9kAKAU6Sbdq8vFGNRrKEQ8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Dwa4ZTgrAXDfJHHAnjbpGojBq8DIAmYOGkGoAM6wrmOUJjYH39aaZctJFc27CpM1pGml7nnhX1MKfgO/+SkCUsz7AtTEJGRncloBP0eKfpSFIlYNcS3Ax1JP6KiAaU7hJ0SYtifPkrSxpOcndMEoJ9WshHyVWrhvNewvjBp3Ghc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=ckdsN/t8; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="ckdsN/t8"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id JWhZQ87Iqv8ZfMZ2; Mon, 29 Sep 2025 10:53:05 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=WSDr2G5sX0nNA84Qw5mqsSNJwd5al2hxSzSr+vuxAtE=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=ckdsN/t8eiEorDdbKbHx
	uP978KYUT+UtVb5h3x+nKS8J6SJYzmeoxiD1Iugn27hv6sFPicdkDVS7NzpgW13y03o+pe8LOFUPQ
	Xs/ZYzuOdyMzcvl0qUjKdLh0JfWATGOQaMW0tRMSkhG8G2/GffNJ0ydAnqHUykwXaDrfgKnYWE=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14216671; Mon, 29 Sep 2025 10:53:05 -0400
Message-ID: <0e8ccc6c-b397-4d56-86fa-d92c7bc3cfc6@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 29 Sep 2025 10:53:05 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v2 16/16] scsi: qla2xxx: improve safety of cmd lookup by
 handle
Content-Language: en-US
X-ASG-Orig-Subj: [PATCH v2 16/16] scsi: qla2xxx: improve safety of cmd lookup by
 handle
From: Tony Battersby <tonyb@cybernetics.com>
To: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Dmitry Bogdanov <d.bogdanov@yadro.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>
References: <e95ee7d0-3580-4124-b854-7f73ca3a3a84@cybernetics.com>
In-Reply-To: <e95ee7d0-3580-4124-b854-7f73ca3a3a84@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1759157585
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 7289
X-Barracuda-BRTS-Status: 1
X-ASG-Debug-ID: 1759157585-1cf43947df3c0630001-ziuLRu

(target mode)

The driver associates two different structs with numeric handles and
passes the handles to the hardware.  When the hardware passes the
handle back to the driver, the driver consults a table of void * to
convert the handle back to the struct without checking the type of
struct.  This can lead to type confusion if the HBA firmware misbehaves
(and some firmware versions do).  So verify the type of struct is what
is expected before using it.

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

v1 -> v2: shorten code comment due to the removal of unsafe code from
the prior v1 patch "scsi: qla2xxx: fix oops during cmd abort".

 drivers/scsi/qla2xxx/qla_dbg.c    |   2 +-
 drivers/scsi/qla2xxx/qla_target.c | 109 ++++++++++++++++++++++++------
 2 files changed, 90 insertions(+), 21 deletions(-)

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
index a59742ca51ec..d82c7022f3d7 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4000,7 +4000,8 @@ static int qlt_prepare_srr_ctio(struct qla_qpair *qpair,
 
 /* ha->hardware_lock supposed to be held on entry */
 static void *qlt_ctio_to_cmd(struct scsi_qla_host *vha,
-	struct rsp_que *rsp, uint32_t handle, void *ctio)
+	struct rsp_que *rsp, uint32_t handle, uint8_t cmd_type,
+	const void *ctio)
 {
 	void *cmd = NULL;
 	struct req_que *req;
@@ -4023,29 +4024,97 @@ static void *qlt_ctio_to_cmd(struct scsi_qla_host *vha,
 
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
+	/*
+	 * We passed a numeric handle for a cmd to the hardware, and the
+	 * hardware passed the handle back to us.  Look up the associated cmd,
+	 * and validate that the cmd_type and exchange address match what the
+	 * caller expects.  This guards against buggy HBA firmware that returns
+	 * the same CTIO multiple times.
+	 */
+
+	cmd = req->outstanding_cmds[h];
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
@@ -4074,7 +4143,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 
 	ctio_flags = le16_to_cpu(ctio->flags);
 
-	cmd = qlt_ctio_to_cmd(vha, rsp, handle, ctio);
+	cmd = qlt_ctio_to_cmd(vha, rsp, handle, TYPE_TGT_CMD, ctio);
 	if (unlikely(cmd == NULL)) {
 		if ((handle & ~QLA_TGT_HANDLE_MASK) == QLA_TGT_SKIP_HANDLE &&
 		    (ctio_flags & 0xe1ff) == (CTIO7_FLAGS_STATUS_MODE_1 |
@@ -6836,7 +6905,7 @@ static void qlt_handle_abts_completion(struct scsi_qla_host *vha,
 	struct qla_tgt_mgmt_cmd *mcmd;
 	struct qla_hw_data *ha = vha->hw;
 
-	mcmd = qlt_ctio_to_cmd(vha, rsp, pkt->handle, pkt);
+	mcmd = qlt_ctio_to_cmd(vha, rsp, pkt->handle, TYPE_TGT_TMCMD, pkt);
 	if (mcmd == NULL && h != QLA_TGT_SKIP_HANDLE) {
 		ql_dbg(ql_dbg_async, vha, 0xe064,
 		    "qla_target(%d): ABTS Comp without mcmd\n",
-- 
2.43.0


