Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.71.155.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793759624;
	b=uxaHj1lTL2216+0KGdbzoQR1rJ+QwhUinrkA8jcDU8n3huwKnm5HjeYLKEaeVZcG+5XA
	 tN+1kU5xv4+dXt0T0jzYv3MTLutkfHU0Dp1cYZdqyGokIeQw44mlTinhpu8+HmKOIBNv2
	 zQDPCXam4fzhDVJkeHHbf7Zao4iDJk+dvt1QZh/nBg6bHAUTL5T9RlMtpLsbuT8n2gMxh
	 WdHQfBq/LiGMmCRCSkiLwEAnUqubIu2g1on5uNNVz4aBnfAqfzNUumDJiSFEhdkWJqBv+
	 dmB4hT5sPmVB7SWdnD4PwqVhgoAKWCF7ozWHtpFAlQ305O8Wi7cNLDJ8nZXcapxecCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793759624;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-HM-Tid:X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=W90/fzigIZrF66zbEA40KjZhqN8nQyO7WtdLMhP/IrA=;
	b=VSkuNduHwFcqIak8ihAVWjacz2fHWe3NL5PU+mMFLx99S4sKmCnYBtvphalJbgyfPjl4
	 c1pN+ksH4REUNNTMN5YRl9txirIkaRDtcxYAGIAqjV3R7uoja6p8Y1vX6PaK+gtLPEEkc
	 gExvc8UxUnAUn7asW/9cm5YENunuB1fSUyDvj/IkBVrAD5rY0iXq6CmMRXW3SO4TBFo97
	 5AkqVeXjEW+to/QfIi/cTxGTnd+xMElflvP8ejtC2H5ZuUuyogbCmaRJ+KhX40U5Ngwjr
	 8qBmK0ZtcSdvRU3BEJq8fgNfwVBbz/cwbwVokYwgQ82L/6qn3TJSK1bYmHK01VwiWhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=Q3iXgp0Z;
	arc=none smtp.remote-ip=101.71.155.101
Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039D0606A32E;
	Wed,  4 Nov 2026 02:33:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 039D0606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=Q3iXgp0Z
Received: from lgs.. (unknown [101.76.249.61])
	by smtp.qiye.163.com (Hmail) with ESMTP id 5367d073a;
	Wed, 4 Nov 2026 10:33:38 +0800 (GMT+08:00)
From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
To: Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] scsi: aic7xxx: Fix potential critical section table leak
Date: Wed,  4 Nov 2026 10:33:35 +0800
Message-ID: <20261104-db9e3c75b3-scsi-aic7xxx-1@mail.sdu.edu.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104-db9e3c75b3-scsi-aic7xxx-0@mail.sdu.edu.cn>
References: <20261104-db9e3c75b3-scsi-aic7xxx-0@mail.sdu.edu.cn>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1a467a78b03a1kunm4ff2f44e1636dd
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCT0MfVkxJGRlNGkpJTUxMSlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWUtVS1VLVUtZBg
	++
DKIM-Signature: a=rsa-sha256;
	b=Q3iXgp0ZW02+uIUmlf3o5WQCmi5PQvYxo9Ds3s8K/ZLVoiBSDJpb2HDz3FdRjrOmktq4iE2HGXWkxLJ9rBtn8dHONkU8lkRscL2bBqyVOCz2ndB9SXuvTwVmMaMbNh5Pd5xIZ4rJlUb0ROTHCNxiKt+2G83zYARahoOSCgP56dU=; s=default; c=relaxed/relaxed; d=mail.sdu.edu.cn; v=1;
	bh=W90/fzigIZrF66zbEA40KjZhqN8nQyO7WtdLMhP/IrA=;
	h=date:mime-version:subject:message-id:from;

ahc_loadseq() allocates a critical section table, but ahc_free()
does not release it. Free the table after shutting down the
controller and releasing its platform resources.

This issue was found by our static analysis tool under development.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
---
Build-tested the changed object with x86_64 GCC W=1, using defconfig
with the driver dependencies enabled. No hardware/kernel runtime test or full linked-kernel
build.
OpenAI Codex assisted with source review, patch implementation and
commit-message drafting. The submitter has reviewed the changes.

 drivers/scsi/aic7xxx/aic7xxx_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index b9761f9f0bbc..7959f96576ca 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -4514,6 +4514,7 @@ ahc_free(struct ahc_softc *ahc)
 #endif
 	kfree(ahc->name);
 	kfree(ahc->seep_config);
+	kfree(ahc->critical_sections);
 	kfree(ahc);
 	return;
 }
