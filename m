Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB16831E110
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 18:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757357583; cv=none; b=QpeVeHIzwSWaLAsEg1aFUqRX0l6B0R3TJkgZSen0XOvUSwb/9Zzh6ZYXVtUg5htGmkEeM07Alom/R5Ts3cAkurSHGknIy/tuB8XhXNh2Wa2JduB9NgFiErMEYcLa2CjHuq6zIg90QMTO0d3GCLNUXZyarQ4DCeu7ocaFu4Mqc0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757357583; c=relaxed/simple;
	bh=OPynoWlf+TtliqB9Jn+lbK/6f+T6n+fWvl2d8xr8jvo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=oj5EUJkmcDKwDdj83u4VqaiOIqSQhDdGxjsfgdulSjhLT0nB0SA4LBDG16DaZef+roKq0SYEu9VKIaHNyFBADhF9IIMW5Iv9oYqb6HvoxaG5F+MjQzOPX4MiO+Jzskkpb7sMOmGm5ZHnkv82Ci9XVB0eAE/aV1Yf+IsAtyf4DzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=UMc0baAQ; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="UMc0baAQ"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id yDLdLq42OM4eha9T; Mon, 08 Sep 2025 14:53:00 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=YvO2yZSm6FDx3HPo7HFr8bH+Vs2f6ZhSFZIHMDWyqIc=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=UMc0baAQkmeGnLm4bPtI
	Kr3pzj/nYs2+vPWPFP5g5spLfhKQpyygA6c9PFDz2Pdl1P2OOj8f2aZaSdKQ01pQ/VLbaAd5ElC0Y
	BdqXhf8tHzz8dqZHs8lBW9T6fKPYGyTw4FUbmDSWkdBcp9I32M641G28kuLs3U2luH8SQmgNmY=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14189085; Mon, 08 Sep 2025 14:53:00 -0400
Message-ID: <05e68829-aee4-49cf-902b-fd0c2b6d2d13@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 8 Sep 2025 14:53:00 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 05/15] scsi: qla2xxx: remove code for unsupported hardware
Content-Language: en-US
X-ASG-Orig-Subj: [PATCH 05/15] scsi: qla2xxx: remove code for unsupported hardware
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
X-Barracuda-Start-Time: 1757357580
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 0
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 2693
X-ASG-Debug-ID: 1757357580-1cf43947df30c330001-ziuLRu

(target mode)

As far as I can tell, CONTINUE_TGT_IO_TYPE and CTIO_A64_TYPE are message
types from non-FWI2 boards (older than ISP24xx), which are not supported
by qla_target.c.  Removing them makes it possible to turn a void * into
the real type and avoid some typecasts.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 32 +++++--------------------------
 1 file changed, 5 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 1e81582085e3..df5c9aac5617 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3913,7 +3913,8 @@ static void *qlt_ctio_to_cmd(struct scsi_qla_host *vha,
  * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
  */
 static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
-    struct rsp_que *rsp, uint32_t handle, uint32_t status, void *ctio)
+	struct rsp_que *rsp, uint32_t handle, uint32_t status,
+	struct ctio7_from_24xx *ctio)
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct se_cmd *se_cmd;
@@ -3934,11 +3935,8 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 	if (cmd == NULL)
 		return;
 
-	if ((le16_to_cpu(((struct ctio7_from_24xx *)ctio)->flags) & CTIO7_FLAGS_DATA_OUT) &&
-	    cmd->sess) {
-		qlt_chk_edif_rx_sa_delete_pending(vha, cmd->sess,
-		    (struct ctio7_from_24xx *)ctio);
-	}
+	if ((le16_to_cpu(ctio->flags) & CTIO7_FLAGS_DATA_OUT) && cmd->sess)
+		qlt_chk_edif_rx_sa_delete_pending(vha, cmd->sess, ctio);
 
 	se_cmd = &cmd->se_cmd;
 	cmd->cmd_sent_to_fw = 0;
@@ -4007,7 +4005,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 			    *((u64 *)&crc->actual_dif[0]),
 			    *((u64 *)&crc->expected_dif[0]));
 
-			qlt_handle_dif_error(qpair, cmd, ctio);
+			qlt_handle_dif_error(qpair, cmd, crc);
 			return;
 		}
 
@@ -5816,26 +5814,6 @@ static void qlt_response_pkt(struct scsi_qla_host *vha,
 	}
 	break;
 
-	case CONTINUE_TGT_IO_TYPE:
-	{
-		struct ctio_to_2xxx *entry = (struct ctio_to_2xxx *)pkt;
-
-		qlt_do_ctio_completion(vha, rsp, entry->handle,
-		    le16_to_cpu(entry->status)|(pkt->entry_status << 16),
-		    entry);
-		break;
-	}
-
-	case CTIO_A64_TYPE:
-	{
-		struct ctio_to_2xxx *entry = (struct ctio_to_2xxx *)pkt;
-
-		qlt_do_ctio_completion(vha, rsp, entry->handle,
-		    le16_to_cpu(entry->status)|(pkt->entry_status << 16),
-		    entry);
-		break;
-	}
-
 	case IMMED_NOTIFY_TYPE:
 		ql_dbg(ql_dbg_tgt, vha, 0xe035, "%s", "IMMED_NOTIFY\n");
 		qlt_handle_imm_notify(vha, (struct imm_ntfy_from_isp *)pkt);
-- 
2.43.0


