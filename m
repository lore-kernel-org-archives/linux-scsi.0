Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA8F25A340
	for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2025 16:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762790537; cv=none; b=U1Xc4SVVodRZmYNtwX19RhU9LAMQrer55I5exjNLBb80t/ozBRu+bgcXuv5JWtrPlqdcwdUKr8yq2lU0zxq16CULQWTYZqCss6D7FHNbltBqQ3V9w0aVBHwWQrXOKbQgdDvh7yONoPdpvX4Gms27oBIiAR0elXm2mUFVtpTMWSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762790537; c=relaxed/simple;
	bh=p/1qhH6xmniK+PfATBXgJ42s1VF2p1s4AgqIm+wOw8A=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Baeq5S+61NJ9eWC2Yie2oDYAZ0GEUPhX4BE2Z2tT+cKaQIn7/yIBUE3iXQUHvDIB7c+b+qLsbtRJIiFHkGaze98LaCELwZxGOneUK2/ZLywgEsCKTxbUVQzUxmCBny4xVOtkjZuPElN3TMW9j77WMTqxrrNQn70vtINvtHhRdxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=V/CodVWD; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="V/CodVWD"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id GNrnMqdFLTCmJdO0; Mon, 10 Nov 2025 11:02:13 -0500 (EST)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=c8zRG11co9dumla/LDYfv4z7smyuYYWJRicANGOJ9h8=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=V/CodVWDY2WFjsvV/a0o
	IgQqI+w9mw2OuF2LNOubsuKsmuS0/dBDsKIBJNnebsIk3EZlthCXTfhu8PJLatOgQfQOEysQ0lR0S
	MO4b6EOyZGoR91HGIPI6/tnNWcD9aV2MRn4Yyt7CadW5gUtKn2jBzznCBONaeSHtVivgcwCejw=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14272472; Mon, 10 Nov 2025 11:02:13 -0500
Message-ID: <d4b0203f-7817-4517-9789-5866bb24fad7@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 10 Nov 2025 11:02:13 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v3 13/16] scsi: qla2xxx: add cmd->rsp_sent
Content-Language: en-US
X-ASG-Orig-Subj: [PATCH v3 13/16] scsi: qla2xxx: add cmd->rsp_sent
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
X-Barracuda-Start-Time: 1762790533
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 1551
X-Barracuda-BRTS-Status: 1
X-ASG-Debug-ID: 1762790533-1cf439139110cf20001-ziuLRu

(target mode)

Add cmd->rsp_sent to indicate that the SCSI status has been sent
successfully, so that SCST can be informed of any transport errors.
This will also be used for logging in later patches.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

v2 -> v3: no changes

v1 -> v2: no changes

 drivers/scsi/qla2xxx/qla_target.c | 4 ++++
 drivers/scsi/qla2xxx/qla_target.h | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index c2876b442a08..a71000b122ce 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4075,6 +4075,10 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 
 	if (cmd->state == QLA_TGT_STATE_PROCESSED) {
 		cmd->trc_flags |= TRC_CTIO_DONE;
+
+		if (likely(status == CTIO_SUCCESS))
+			cmd->rsp_sent = 1;
+
 	} else if (cmd->state == QLA_TGT_STATE_NEED_DATA) {
 		cmd->state = QLA_TGT_STATE_DATA_IN;
 
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 97aa6d9cfc27..ab2285c40573 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -882,6 +882,10 @@ struct qla_tgt_cmd {
 	unsigned int conf_compl_supported:1;
 	unsigned int sg_mapped:1;
 	unsigned int write_data_transferred:1;
+
+	/* Set if the SCSI status was sent successfully. */
+	unsigned int rsp_sent:1;
+
 	unsigned int q_full:1;
 	unsigned int term_exchg:1;
 	unsigned int cmd_sent_to_fw:1;
-- 
2.43.0


