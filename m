Received: from mail-m15567.qiye.163.com (mail-m15567.qiye.163.com [101.71.155.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A2435949
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2025 02:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759200824; cv=none; b=mRvfT9yRK6NiPg+8+hs7awdhYP6EwSO7njgVx2oGToCEnjR3+9xLgsqTxPGwdnP+6PzqnmIjy1AlVd8loESCHVeLi0Zh/lf9BI+JBH+rSdujmIQhT3jKw4cMxnmBCjDyLH79RVk2Q41d3s2SXOQdi+RIY0ABDUVH3ajTN/qh6/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759200824; c=relaxed/simple;
	bh=vim1+SkEHdYxJsut4bRrfNhLFSLM/VqMx//YtF+P80s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=r/MnOBqLugnbyqyJF95rcLuNZpSTR6jmnYylQAVU5NbcVKoIzjOh4UlkJUDewfzud31kreRV9/jOAXKyE93AEI3ielddkyCRc1cznmUTCYUTCkL+LfP8l8By2zdwgsLQeHVbwNrNBB0n99QsaYvl+oqYkxDdHF4D2aXf62iNSQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn; spf=pass smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=101.71.155.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 10f599f3d;
	Tue, 30 Sep 2025 10:53:29 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH] scsi: ips: Fix potential NULL pointer dereference of scb->scsi_cmd
Date: Tue, 30 Sep 2025 10:53:19 +0800
Message-Id: <20250930025319.386560-1-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a99988a12a70229kunma12a3b63169188
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDS08YVkpNQx0aSxkZTUxOTVYVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0lPT09IVUpLS1
	VKQktLWQY+

The 'if ((scb->scsi_cmd) && (ips_is_passthru(scb->scsi_cmd)))' check
uses an AND logic, so in the else branch (handling non-PASSTHRU
commands) scb->scsi_cmd was not checked for NULL. This may lead to NULL
pointer dereference and potentially cause a kernel panic when processing
invalid SCSI commands.

Adding an early return if scb->scsi_cmd is NULL. Maintaining all
existing functionality for valid commands.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
 drivers/scsi/ips.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 94adb6ac02a4..091c13a21c3a 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -3129,7 +3129,10 @@ ips_done(ips_ha_t * ha, ips_scb_t * scb)
 	if (!scb)
 		return;
 
-	if ((scb->scsi_cmd) && (ips_is_passthru(scb->scsi_cmd))) {
+	if (!scb->scsi_cmd)
+		return;
+
+	if (ips_is_passthru(scb->scsi_cmd)) {
 		ips_cleanup_passthru(ha, scb);
 		ha->num_ioctl--;
 	} else {
@@ -3184,18 +3187,14 @@ ips_done(ips_ha_t * ha, ips_scb_t * scb)
 
 			switch (ret) {
 			case IPS_FAILURE:
-				if (scb->scsi_cmd) {
-					scb->scsi_cmd->result = DID_ERROR << 16;
-					scsi_done(scb->scsi_cmd);
-				}
+				scb->scsi_cmd->result = DID_ERROR << 16;
+				scsi_done(scb->scsi_cmd);
 
 				ips_freescb(ha, scb);
 				break;
 			case IPS_SUCCESS_IMM:
-				if (scb->scsi_cmd) {
-					scb->scsi_cmd->result = DID_ERROR << 16;
-					scsi_done(scb->scsi_cmd);
-				}
+				scb->scsi_cmd->result = DID_ERROR << 16;
+				scsi_done(scb->scsi_cmd);
 
 				ips_freescb(ha, scb);
 				break;
-- 
2.20.1

