Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D521B1E0B66;
	Mon, 20 Jan 2025 16:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737392101; cv=none; b=Zr8WYR6h/rE8YwXcoI4vuK1Y36DQR3yIPi6jDy95lmOcDdUlJ6XibAdCJaNU31M27qMLSnk0DJk+AC4OgcKsoxvlCaF1g19+wl0EFuG7qXXgoNOXdkjD54uEA+mqkomsVY6rCQx3H9+XemGGwPkFr3daauNC1pLSnoExmUBpEnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737392101; c=relaxed/simple;
	bh=EIQgPWUyPWoQ1pyt2dYvP2yKpltv26NAMY254fVjGPA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dr0GFsC5eD6gjmBndBVSHIgCxVdhL12M6Lg1Sj+cC5gIdFtCCeMu97AVlM2PPB77I32+erdpxMPZt0EaskbhUpXbdY32QBHtSk/HXgnHneFFxAhnORtFkdhzPCsp8/OLnsafveuv2xVJqRACZ2b00rdIk0tztY5qYBx1frs3n10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ethancedwards.com; spf=pass smtp.mailfrom=ethancedwards.com; dkim=pass (2048-bit key) header.d=ethancedwards.com header.i=@ethancedwards.com header.b=WSeZkiEp; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ethancedwards.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ethancedwards.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ethancedwards.com header.i=@ethancedwards.com header.b="WSeZkiEp"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4YcGfJ4yKVz9t6D;
	Mon, 20 Jan 2025 17:54:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=MBO0001; t=1737392089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LS+MZG6fzjs7nxyUtXWsT4ov/e2VyX4vAlGsW6xC8Ww=;
	b=WSeZkiEpiH98uSVuU0s7xTbcv6GZJ1hBAp13hQtd9Eyu4sBIR6KDVWRc+JmEgnaRWm+ejR
	NCx2P7o1SPCoNOJWanAX1jLfGA8PSR3sFj+sz9RmJzyZpbfYgor2b8mwFFIx5lC9unS/uV
	fWmbmsSXZxuCJsroyy581WoLsn9yh2Vj0hckVVGwvlwwlK4uUsysF5R64aT1ZQkU2g1pm3
	SwQN/TwSrQOaPOAtrTuinl3f+wqW6nVCR0iqFcVUPKAzsiud2lpLYY6ZQlaZMBs2DBD2xI
	AY44WqgPzgrdkbYEwFWlAdaymTUwsvGZget3Ui43DhJjUCV702pinRS/P/GnAA==
From: Ethan Carter Edwards <ethan@ethancedwards.com>
To: manoj@linux.ibm.com
Cc: linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Ethan Carter Edwards <ethan@ethancedwards.com>,
	Uma Krishnan <ukrishn@linux.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: cxlflash: change kzalloc to kcalloc
Date: Mon, 20 Jan 2025 11:53:55 -0500
Message-ID: <20250120165411.32256-1-ethan@ethancedwards.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We are replacing any instances of kzalloc(size * count, ...) with
kcalloc(count, size, ...) due to risk of overflow [1].

[1] https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments

Link: https://github.com/KSPP/linux/issues/162
Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
---
 drivers/scsi/cxlflash/superpipe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index b375509d1470..fc26e62e0dbf 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -785,8 +785,8 @@ static struct ctx_info *create_context(struct cxlflash_cfg *cfg)
 	struct sisl_rht_entry *rhte;
 
 	ctxi = kzalloc(sizeof(*ctxi), GFP_KERNEL);
-	lli = kzalloc((MAX_RHT_PER_CONTEXT * sizeof(*lli)), GFP_KERNEL);
-	ws = kzalloc((MAX_RHT_PER_CONTEXT * sizeof(*ws)), GFP_KERNEL);
+	lli = kcalloc(MAX_RHT_PER_CONTEXT, sizeof(*lli), GFP_KERNEL);
+	ws = kcalloc(MAX_RHT_PER_CONTEXT, sizeof(*ws), GFP_KERNEL);
 	if (unlikely(!ctxi || !lli || !ws)) {
 		dev_err(dev, "%s: Unable to allocate context\n", __func__);
 		goto err;
-- 
2.48.0

