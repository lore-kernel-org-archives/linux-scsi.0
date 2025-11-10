Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D192749E0
	for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2025 15:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762789974; cv=none; b=UCCfXq2CoZmaOE/IsHtP0wCQTyTjVBBzX+AOM7NSvjJRn78cestjNpMmhbuNT74CB94AIL3KerYi6NwymV8JRbvp5OCLMl1SE3p1RKrQ3NUJf7abrhK+HvDD+Yoos49rqLPKokgZWHz4zsrS4rU3ASrXPnpFf7OkmleqsGSVQss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762789974; c=relaxed/simple;
	bh=EacGFIAMHCxTCWrK6DvfS6+8MkMCjXdrGnli80zNq1g=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=oYa78FN0nXl6LOA5ctXC0O24a04a9KhFGP12zDVnJpBG2olnRFvj9RPrK0+6CuMp8aa3ppd+TmRt5dSUJFpZI3LRnAhk3lsPiRuhAUByH9sMT7isJysTjsqDaC/QWJH5xE0Qiv2hHUpCY0qJpE1lqLtjxQJuwujV2ucMgq7rzCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=A+DHQIJV; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="A+DHQIJV"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id mnzLNpMLSm3w5soT; Mon, 10 Nov 2025 10:52:49 -0500 (EST)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=yjsCdL8ouw87tHf4qzCFGr3AYXHhR8tAd+jfwFAtwug=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=A+DHQIJV7qil2JN+4b9+
	OWEo5FjBtiOupVH4nFS3UEzfJ3ZtjTFoR3A9OD20jJ9DXDTXf1EFiBVpthBuIhGtugoK+A5f7h1XF
	Wa6gW+W7kQpBIebFVxXXz0ZwLfbQzBQekyVe+kZqBkHxZcQ11kjwmbA123ihOyDYOi0+l2K264=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14272391; Mon, 10 Nov 2025 10:52:49 -0500
Message-ID: <cb006628-e321-4e30-a60b-08b37b8685a5@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 10 Nov 2025 10:52:49 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v3 05/16] scsi: qla2xxx: remove code for unsupported hardware
Content-Language: en-US
X-ASG-Orig-Subj: [PATCH v3 05/16] scsi: qla2xxx: remove code for unsupported hardware
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
References: <aaea0ab0-da8b-4153-9369-60db7507ff7a@cybernetics.com>
In-Reply-To: <aaea0ab0-da8b-4153-9369-60db7507ff7a@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1762789969
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 2743
X-ASG-Debug-ID: 1762789969-1cf439139110ccc0001-ziuLRu

(target mode)

As far as I can tell, CONTINUE_TGT_IO_TYPE and CTIO_A64_TYPE are message
types from non-FWI2 boards (older than ISP24xx), which are not supported
by qla_target.c.  Removing them makes it possible to turn a void * into
the real type and avoid some typecasts.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

v2 -> v3: no changes

v1 -> v2: no changes

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


