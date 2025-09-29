Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786DB308F3C
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2025 14:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759157300; cv=none; b=snKbczCLjpjsiWIH+fa66593DFy6ZQpNjJ1tZMriz0j3u7ZbQMYaMSzm1Vau4l8/Ou25hH5NlqKr1zOLLcSxjhOlKo2GgQFaOYy6zRNpaL31JP7G0IOYc/AtXUYiBF+uWTARWVL5vbLzxR5OlchITVMxJQQ+Ge/Ce036NIXtFAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759157300; c=relaxed/simple;
	bh=473f40mtSQM+0OzQVl4Ru5p88sAyTwDhs9qPxor6Ucw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=L0Ru9/MfR6QCJnoW9yUI1WYaQbZTZGKns1gysN8h5Nksc75Cv0VKzm4P10aJlC0ky7eeZS5tAljpuV0M62UIjFLaGGgUUucQSsFQm9+ISPSHP6Cmlduy7ORFhZwN3HzfVBh18cEtXjrTRFBsL/AzAZmfRG5GScQfOGUc4XvZBX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=Ppu7l86P; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="Ppu7l86P"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id d6l4Wcka9sFtCnlB; Mon, 29 Sep 2025 10:48:17 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=RVGMr1m30rPoyckhzK4yiD/uiBeD7Nfmj5riwnj1OQ4=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=Ppu7l86PvalLm6Kdyi1a
	GOjvZ0zDGxlB3lbi8FPwG2BGiCTFEf4z6qcDBYh4oYMN4+tCI1zuo8hLOLEd//GkPuoweu0zE2owh
	NVN0kPkMT8BAIgHm8tPI9Z9Hi6eDbdGz+Aayr5PO77aafY7qZZz0FK815WX1H9AbuzAozT0xNI=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14216615; Mon, 29 Sep 2025 10:48:16 -0400
Message-ID: <54c50cf9-6d27-48f0-930d-d1f1098da692@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 29 Sep 2025 10:48:16 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [SCST PATCH v2 13/16] scsi: qla2xxx: add cmd->rsp_sent
Content-Language: en-US
X-ASG-Orig-Subj: [SCST PATCH v2 13/16] scsi: qla2xxx: add cmd->rsp_sent
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
 <a87efa80-b76c-4165-be57-775f73ba9a2c@cybernetics.com>
In-Reply-To: <a87efa80-b76c-4165-be57-775f73ba9a2c@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1759157297
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 909
X-Barracuda-BRTS-Status: 1
X-ASG-Debug-ID: 1759157297-1cf43947df3c0520001-ziuLRu

This patch applies to the out-of-tree SCST project, not to the Linux
kernel.  Apply when importing the upstream patch with the same title.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

v1 -> v2: no changes

 qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c b/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c
index e5bf210d3..fb5956346 100644
--- a/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c
+++ b/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c
@@ -685,6 +685,8 @@ static void sqa_qla2xxx_free_cmd(struct qla_tgt_cmd *cmd)
 
 	cmd->state = QLA_TGT_STATE_DONE;
 	cmd->trc_flags |= TRC_CMD_DONE;
+	if (unlikely(!cmd->rsp_sent))
+		scst_set_delivery_status(scst_cmd, SCST_CMD_DELIVERY_FAILED);
 	scst_tgt_cmd_done(scst_cmd, scst_work_context);
 
 	TRACE_EXIT();
-- 
2.43.0


