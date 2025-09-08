Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD21227BB5
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 19:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757358502; cv=none; b=WpZ5AxuZ8AIgyWi7+m5qr6wHi8GRftGVt1fylPuTV5juMe+yZPQuIsAI63k/rT9GuqdS9dR7JIdHw7Aw4fXG3zVfCnq217VlEuV6MQFdYJWDElh+2ndr2MSOgl+/dQ0/LsB4J3YIc60BeLSaB+XT41XKooB5iZ4QeTR0KOY+zUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757358502; c=relaxed/simple;
	bh=W2Ha5XaVAhazdZtvMhjRuTcLEHdWk8g/kfM601FF/D4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=uho2tEOvIv5CKIZZ+VrBylcjkcY+PWoWTCtJm2ms5FVC193pXWmxUcpyv3HFtSPsAoQh7N2kdnK0oKa3noId+kNb6goDCwf8MT6agBx2kao2aFY3cnIaHNbq143TRE7DOpp36+ino2cO/r+BB8D1EIcNm7njbigwW3PTsVQeKG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=eJ33w9Ba; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="eJ33w9Ba"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id CLN3GQbMVs9j0E7s; Mon, 08 Sep 2025 15:08:19 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=WLMFO4TOq0GkmRwZLTraaJmtSz1oIWOrLzcu8pAmhXA=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=eJ33w9Ba2NwHRceqWhHq
	Ds72Mil/4HnvXkr7ENbD7lKgCPOmyoraHgxAUNrIXLhxdCUh0CflYHod1G91BP4hXUi7nWyIeP5dn
	cAz1RJV6+zG+jPo9cvxiM/gJdfLILL4WH+VaeDo6sq0MuGX0KnIBr950EpoOjlPYTreIlpps7o=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14188671; Mon, 08 Sep 2025 15:08:19 -0400
Message-ID: <d8138d1a-5166-4c98-b5c4-4ad08a843d09@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 8 Sep 2025 15:08:19 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [SCST PATCH 12/15] scsi: qla2xxx: add cmd->rsp_sent
Content-Language: en-US
X-ASG-Orig-Subj: [SCST PATCH 12/15] scsi: qla2xxx: add cmd->rsp_sent
From: Tony Battersby <tonyb@cybernetics.com>
To: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
 <366f8fb5-376d-4426-9f27-6bef23a624b2@cybernetics.com>
In-Reply-To: <366f8fb5-376d-4426-9f27-6bef23a624b2@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1757358499
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 0
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 883
X-ASG-Debug-ID: 1757358499-1cf43947df30c6f0001-ziuLRu

This patch applies to the out-of-tree SCST project, not to the Linux
kernel.  Apply when importing the upstream patch with the same title.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
 qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c b/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c
index 3c2d59b6f..d3a978610 100644
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


