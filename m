Received: from mail.cybernetics.com (mail.cybernetics.com [173.71.130.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902502F068C
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2025 14:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.71.130.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759156455; cv=none; b=izh+rn67zRvw26jmZIKeHm4K24BTXJRreKfPAj1YMGFKZLGdtIsD/qlhAkW2KbHRvG4NTxJF75+e5t/qUmiyIjuTvV53vCJVZVuSpyuh/3x1CgZ1KN0AE/W/ApZos4til5e9oy/ALkyNJ4D2ozniK4TKQDJIee4CGLSDGpWo6Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759156455; c=relaxed/simple;
	bh=Z2ilCQDDE/XtnpjyqiPe9uZRksaXELFeV02+WM3O91c=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=GrocQoI9KZHKqfI2nlhWKaNm6Fa0mjfcY8QkBp8NcdiqjjDfwCW0ufQoMf8PLrZDU4JxVTe+e6t3mfSUatPhrDZRUIyqqEJr/DoxbrbsYEf8FPkjlQqZn3F1nMLfT/ZDCy/xFc199WUnFcN24Mbs2xWaxR0tWI59wDnGpnuiIrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=gOPbjgd8; arc=none smtp.client-ip=173.71.130.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="gOPbjgd8"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id OZbgXEGwDVITtZUf; Mon, 29 Sep 2025 10:34:12 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=+JjZ3aSF7tR0NNcdHJQPEjQoQxYEsBRmcyR29O/vUSY=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=gOPbjgd8ne6prDroUyhB
	7fOGoU2whkYqgaIA5wRYovL8fWJ/WjAh8mSoqK3JMv/OYVEScGXDLZnN2TvS9/09hOjqKJmrDGYRW
	skxi2oFDAu6J+ooU04Y2CPu/jEfVYkdo86iI+fk1tJ1LxYizwOrni27R9O1qtwsWo3A2K4rWv0=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14216610; Mon, 29 Sep 2025 10:34:12 -0400
Message-ID: <5bfdcedd-9bff-4de8-98a8-aa5ec87ca96e@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 29 Sep 2025 10:34:12 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v2 04/16] scsi: qla2xxx: use reinit_completion on
 mbx_intr_comp
Content-Language: en-US
X-ASG-Orig-Subj: [PATCH v2 04/16] scsi: qla2xxx: use reinit_completion on
 mbx_intr_comp
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
X-Barracuda-Start-Time: 1759156452
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 0
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 1361
X-ASG-Debug-ID: 1759156452-1cf43947df3c01a0001-ziuLRu

If a mailbox command completes immediately after
wait_for_completion_timeout() times out, ha->mbx_intr_comp could be left
in an inconsistent state, causing the next mailbox command not to wait
for the hardware.  Fix by reinitializing the completion before use.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

v1 -> v2: no changes

 drivers/scsi/qla2xxx/qla_mbx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 32eb0ce8b170..1f01576f044b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -253,6 +253,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	/* Issue set host interrupt command to send cmd out. */
 	ha->flags.mbox_int = 0;
 	clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+	reinit_completion(&ha->mbx_intr_comp);
 
 	/* Unlock mbx registers and wait for interrupt */
 	ql_dbg(ql_dbg_mbx, vha, 0x100f,
@@ -279,6 +280,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 			    "cmd=%x Timeout.\n", command);
 			spin_lock_irqsave(&ha->hardware_lock, flags);
 			clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
+			reinit_completion(&ha->mbx_intr_comp);
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 			if (chip_reset != ha->chip_reset) {
-- 
2.43.0


