Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC950205AB6
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 19:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757358325; cv=none; b=LmW9jmVtLc+8tYD+21yzlmxX4PHCQTexQHnHGhupT8jtGA0Ico8gLdCNh+6fnkj8sHdVzTZfYfHpeQWdUyfIBWv7HlP+CUvg0L1W1TfaMqPsZdgpA+veBNW1EpQxT01nUXMX3mnS/92V3SzqbKco9PHI0DZ+WLuXPVvjvkIlYDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757358325; c=relaxed/simple;
	bh=tZSNfigLca7zvNJlFawRwc/92FdL0vCgBdOheNTW3BA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=t5oLMveNgJvGbWig4UkdC8DCDI4/X5i+Fgy754mSJma2vU1riOQ/5o01nV7odL+J+LBuIGTjGnis2gNwMSgAQR1kqRuiX660Agyv6eVIuezCNRqCViI3DG9bSUNihdxDimUpmTzZZk0vVhnL4xi/1jI3P7LMXLv8FAWaO5TbQ5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=Wo4z7ds+; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="Wo4z7ds+"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id 60ulr7ePOEx7LDfx; Mon, 08 Sep 2025 15:05:22 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=EkPFE4p+Ecuk6YQC9uEfEle8erFPJs5rbx23sckMNus=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=Wo4z7ds+zQxYS/KqbKtP
	dT6Syvuewq5uOwXuvfqzGgQ6mNic3W0DWIncG6LPWQ0NWR7TmyNaQrJt2YjiLAuW4JN6cFYpVXUnc
	RbEsuPucECenAPAWj/T9qrKLCuDPy4EYyCMeoQ3kxsn1fiHDDrR9q3dO2Cs7wD2EqB8559Ow68=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14189155; Mon, 08 Sep 2025 15:05:22 -0400
Message-ID: <beb60661-ff0b-499c-a059-237bcc6a2551@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 8 Sep 2025 15:05:22 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [SCST PATCH 11/15] scsi: qla2xxx: fix invalid memory access with big
 CDBs
Content-Language: en-US
X-ASG-Orig-Subj: [SCST PATCH 11/15] scsi: qla2xxx: fix invalid memory access with big
 CDBs
From: Tony Battersby <tonyb@cybernetics.com>
To: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
 <93f444c0-bd88-4adc-9e97-bd15edf2a0bf@cybernetics.com>
In-Reply-To: <93f444c0-bd88-4adc-9e97-bd15edf2a0bf@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1757358322
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 2088
X-ASG-Debug-ID: 1757358322-1cf43947df30c630001-ziuLRu

This patch applies to the out-of-tree SCST project, not to the Linux
kernel.  Apply when importing the upstream patch with the same title.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
 qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c b/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c
index 76d3685a4..3c2d59b6f 100644
--- a/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c
+++ b/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c
@@ -420,16 +420,15 @@ static int sqa_qla2xxx_handle_cmd(scsi_qla_host_t *vha,
 	TRACE_DBG("sqatgt(%ld/%d): Handling command: length=%d, fcp_task_attr=%d, direction=%d, bidirectional=%d lun=%llx cdb=%x tag=%d cmd %p ulpcmd %p\n",
 		vha->host_no, vha->vp_idx, data_length, task_codes,
 		data_dir, bidi, cmd->unpacked_lun,
-		atio->u.isp24.fcp_cmnd.cdb[0],
+		cdb[0],
 		atio->u.isp24.exchange_addr, cmd, cmd->scst_cmd);
 
 
 	cmd->scst_cmd = scst_rx_cmd(scst_sess,
 		(uint8_t *)&atio->u.isp24.fcp_cmnd.lun,
 		sizeof(atio->u.isp24.fcp_cmnd.lun),
-		atio->u.isp24.fcp_cmnd.cdb,
-		sizeof(atio->u.isp24.fcp_cmnd.cdb) +
-		(atio->u.isp24.fcp_cmnd.add_cdb_len * 4),
+		cdb,
+		cmd->cdb_len,
 		SCST_ATOMIC);
 
 	if (cmd->scst_cmd == NULL) {
@@ -1552,7 +1551,6 @@ static int sqa_xmit_response(struct scst_cmd *scst_cmd)
 		scst_to_tgt_dma_dir(scst_cmd_get_data_direction(scst_cmd));
 	cmd->offset = scst_cmd_get_ppl_offset(scst_cmd);
 	cmd->scsi_status = scst_cmd_get_status(scst_cmd);
-	cmd->cdb = (unsigned char *) scst_cmd_get_cdb(scst_cmd);
 	cmd->lba = scst_cmd_get_lba(scst_cmd);
 	cmd->trc_flags |= TRC_XMIT_STATUS;
 
@@ -1635,7 +1633,6 @@ static int sqa_rdy_to_xfer(struct scst_cmd *scst_cmd)
 	cmd->dma_data_direction =
 		scst_to_tgt_dma_dir(scst_cmd_get_data_direction(scst_cmd));
 
-	cmd->cdb = scst_cmd_get_cdb(scst_cmd);
 	cmd->sg = scst_cmd_get_sg(scst_cmd);
 	cmd->sg_cnt = scst_cmd_get_sg_cnt(scst_cmd);
 	cmd->scsi_status = scst_cmd_get_status(scst_cmd);
-- 
2.43.0


