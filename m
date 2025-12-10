Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0B81DEFF5
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 14:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765377231; cv=none; b=ahtFAHsCe2QyafSYbMuvUVBEeV7MltetdqwZsMGJSQ/Y8NYl0JMER4G3FTMnf/xDU/SmIwSwYO3a/w44at4SfJW4tEEeEhhgA/yPYBiqMh6pxGhVLo7XweYAzpVQJ5bYlH9Iy5M/U3D7UPwaoKjl1LyHg3z4wGiZcC07yRFMjg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765377231; c=relaxed/simple;
	bh=bIrH+y2DdhStwXru8w/AKXvbbVuUr8TFTqBlEKgnhqg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pw3PbGzhAqmuheLWzF+Bnk8n6ai3LqSUfKJxeNAWr+nhjGckAknDDk2o3lgthF40rIPYTOlA3Oli7scuzZzMrORReQ/cL7wR6zYO4q78g8+U5gM9yQvTXnqNB+R2P4AoMgWoZM94eqx5sEgGZoEdPl/uP8u4K8R5aqxpnxzCyuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S3apXUEw; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S3apXUEw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765377226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0f817kW4HFm1dNploquNc0Ckb0Ah24GWbKrCn0aQ8JM=;
	b=S3apXUEw2enoFTJ7chfnpqdb3AfbO7UOvAnFL1E0OKUH3bYaFn1BOd0WYOGlgWoo01vQlk
	2Ce9fxIczwhYE+sYJWGOkT3/6QFjcz+mAyjRDA1j+KIGCZgm4Q4QYMuYqwO3oclKQ93pO0
	RiiXhxNVsWQeJajxPFOhywpNQ993hGo=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: pmcraid: Replace cpu_to_be64 + le64_to_cpu with swab64
Date: Wed, 10 Dec 2025 15:33:21 +0100
Message-ID: <20251210143322.596158-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace cpu_to_be64(le64_to_cpu()) with swab64() to simplify
pmcraid_prepare_cancel_cmd().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/scsi/pmcraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 33f403e307eb..68c2a10453fe 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -1213,7 +1213,7 @@ static void pmcraid_prepare_cancel_cmd(
 	 * cdb[2]..cdb[9] is Big-Endian format. Note that length bits in
 	 * IOARCB address are not masked.
 	 */
-	ioarcb_addr = cpu_to_be64(le64_to_cpu(cmd_to_cancel->ioa_cb->ioarcb.ioarcb_bus_addr));
+	ioarcb_addr = swab64(cmd_to_cancel->ioa_cb->ioarcb.ioarcb_bus_addr);
 
 	/* Get the resource handle to where the command to be aborted has been
 	 * sent.
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

