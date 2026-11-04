Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=47.88.81.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793762317;
	b=nzTGtp7xrXf1Hw4CxxfK2livWXGDs0ifwRjvlOKo1ohKwvXHH2dRFgFFi2Cy3dxD+GHf
	 GPZLDiicaaLWbrT0vjroi4AWdBbwRwj4wNtsiMCM+ygV6uw6nc7M22oG1NDtWKVcFPS9T
	 SBDBDUb5Snqvaxj6wDR0y69MZ2Mbcb2KC/tBO2JmbJI1wwU6DSauvdDQv+7fJFc3JHvBn
	 rxTPIxLdMgtemXs3gANDsjKhDA6D9HR/4borer5f2kF2r/F/Q2AguLlg+irHigaTh//3e
	 TMbQw7aF85svwEtC1aEq8iWb+zJK/aGVVOvk2757dbGizWvfrUP7IAyKW4h2xR1BDtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793762317;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-HM-Tid:X-HM-MType:
	 X-HM-Spam-Status:DKIM-Signature;
	bh=H9pyR4Jxa+2vB2d3/CN/QgRIWGA9Oobvr0fdD8bWXvA=;
	b=vPq4bWOyGS+uLfg0up09mTksdCv98xdlUSJFkdfY4cgJ6i8nqoTREcaJ9JY6rySTNaNk
	 mE35tSntyjAMEsBnDEAsxkdmx2galFl3mMfu7IBdlkq8it8vkYGTtvoQPlarb025f4uoS
	 BeCy06x5amHweUi8c/25nO1ts7rs+sCLl/bYZcj65lU4a0v2oNPXzHLRDgLfMyWszo/Rj
	 sQZei6yYCibHXGyXccrAmjEWzHn7LFKG9XUGUWjqYaOlz7siCeaYWEqvBPH8odoODCkaZ
	 18OhP064c4m2R9k0oRqjJUAlQiBu5vZnyskBSVG+WQwE7qKwAa7IfVsrdtliutP/1BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=leap-io-kernel.com;
	spf=pass smtp.mailfrom=leap-io-kernel.com;
	dkim=pass header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.a=rsa-sha256 header.s=default header.b=jxAAko3U;
	arc=none smtp.remote-ip=47.88.81.144
Received: from mail-m81144.netease.com (mail-m81144.netease.com [47.88.81.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FF5606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 03:18:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86FF5606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.a=rsa-sha256 header.s=default header.b=jxAAko3U
Received: from localhost.localdomain (unknown [222.130.22.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 536a2cd3e;
	Wed, 4 Nov 2026 11:18:23 +0800 (GMT+08:00)
From: Dongdong Hao <doubled@leap-io-kernel.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: dlemoal@kernel.org,
	hare@kernel.org,
	hare@suse.de,
	doubled@leap-io-kernel.com,
	yjzhang@leap-io-kernel.com,
	kezijie@leap-io-kernel.com,
	jzzhang@leap-io-kernel.com,
	baikefan@leap-io-kernel.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: leapraid: Fix init_cmd_priv error handling
Date: Wed,  4 Nov 2026 11:18:23 +0800
Message-Id: <20261104031823.198733-1-doubled@leap-io-kernel.com>
X-Mailer: git-send-email 2.25.1
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
X-HM-Tid: 0aa1a4909f3c03aekunm9b50e10641d831
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZTEJLVh1MGUJOTRodTkwZHVYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkhLVUlJVUlPSVlXWRYaDxIVHRRZQVlPS0hVSk
	tJT09PSFVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=jxAAko3UAjk2PYa5KkjsYrQf4qgRTGb+Azcm6igG8gOEcP06afyU9L1JuR6hyhNSqR5jhBdrix0wnonzTwqSbLhDVjg7gAlSNYjkakF/02uL0Py2qqvURxoKJRgJMMhNYd9RY9KU5j0KTT76fLh0PSwd7KrSKMQ5hhUIWo//8oGJpqZHI0OE/k3ewRL+ikAn0Xn7ElfXdD8v5sKJgeuCjIe6dqxFEGfWjE21CF7u0v4dJwiABxzs37xsQa76ea8yICgZz9omF5Qt49IyDcQWVPFlH2zD7vtJ243AZdiWFC0EBSwaTsKIPJdm0NnPnQzxhQQr77OzHTYjhJMI8XbVWQ==; c=relaxed/relaxed; s=default; d=leap-io-kernel.com; v=1;
	bh=H9pyR4Jxa+2vB2d3/CN/QgRIWGA9Oobvr0fdD8bWXvA=;
	h=date:mime-version:subject:message-id:from;

leapraid_init_cmd_priv() ignores the return value of
leapraid_internal_init_cmd_priv() and always returns success. If
dma_pool_alloc() fails, io_tracker->chain remains NULL, but the SCSI
midlayer considers the command successfully initialized.

A subsequent I/O requiring more than LEAPRAID_SGL_INLINE_THRESHOLD
DMA-mapped scatter-gather entries dereferences the NULL chain buffer
while building the chained SGL, causing a kernel crash.

Return the result of leapraid_internal_init_cmd_priv() so that allocation
failures propagate to the SCSI midlayer and abort initialization of the
affected request.

Signed-off-by: Dongdong Hao <doubled@leap-io-kernel.com>
---
 drivers/scsi/leapraid/leapraid_os.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/leapraid/leapraid_os.c b/drivers/scsi/leapraid/leapraid_os.c
index da597eb99377..0f3219c4f438 100644
--- a/drivers/scsi/leapraid/leapraid_os.c
+++ b/drivers/scsi/leapraid/leapraid_os.c
@@ -938,9 +938,8 @@ static int leapraid_init_cmd_priv(struct Scsi_Host *shost,
 	struct leapraid_io_req_tracker *io_tracker;
 
 	io_tracker = scsi_cmd_priv(scmd);
-	leapraid_internal_init_cmd_priv(adapter, io_tracker);
 
-	return 0;
+	return leapraid_internal_init_cmd_priv(adapter, io_tracker);
 }
 
 static int leapraid_exit_cmd_priv(struct Scsi_Host *shost,
-- 
2.25.1

