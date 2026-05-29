Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD888834;
	Fri, 29 May 2026 01:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780017988; cv=none; b=Y9VP/uxiWazu4iNxH9EuhkTmWAbKbps7mg2NPX4KEQkorJJGMh64i5sg5VTXVc1Iw3Tb3VawhfGTE6MvU2ng3uzhTjXMUB4KtyT4PDC8nzk/PUzChFANG5bmimL3tv+gx6C8n42D+/M7Au6gdyUd073SwMrSh2RaX6BLQtXBjuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780017988; c=relaxed/simple;
	bh=A6jOFu3Ky9NEYtgpNyQIfXbOORWaLkn2b/tyjgDpK9A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=J/tDsaapFB48R7z9WavTSSmuM6by6eOPd+QuMU3YqzPfHmAPeMO8I4/zS/pSpWpy45KUBnavza7VAf15Gbar+BaoTEFjpT5elONZ2hJD/AqkW6qiLldO0s2zkjF1vJcPB21k3ASQ114+wTOA8/BI44bUMIp0kGYN4ZLYg9OrCrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxNeg_6xhqOWIOAA--.34781S3;
	Fri, 29 May 2026 09:26:23 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDx6+A+6xhqV2yUAA--.20589S2;
	Fri, 29 May 2026 09:26:22 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangtianyang@loongson.cn
Subject: [PATCH] scsi: megaraid_sas: Add dma read memory barrier during complete command poll
Date: Fri, 29 May 2026 09:26:20 +0800
Message-Id: <20260529012620.815886-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDx6+A+6xhqV2yUAA--.20589S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Control dependencies do not guarantee load order across the condition,
allowing a CPU to predict and speculate memory reads.

Add a dma read barrier before reading the complete SMID entry in
structure reply_des and after the condition its contents depend on to
ensure the read order is determinsitic.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 2699e4e09b5b..6ec6e5fa71ce 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3589,6 +3589,8 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 	while (d_val.u.low != cpu_to_le32(UINT_MAX) &&
 	       d_val.u.high != cpu_to_le32(UINT_MAX)) {
 
+		/* Read SIMD after ReplyFlags and d_val.word check */
+		dma_rmb();
 		smid = le16_to_cpu(reply_desc->SMID);
 		cmd_fusion = fusion->cmd_list[smid - 1];
 		scsi_io_req = (struct MPI2_RAID_SCSI_IO_REQUEST *)

base-commit: e8c2f9fdadee7cbc75134dc463c1e0d856d6e5c7
-- 
2.39.3

