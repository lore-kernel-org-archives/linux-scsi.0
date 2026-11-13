Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.254.49.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794579503;
	b=yw8p/ZnrnggDaRXAYwwIO3EvRKQtXHSW4aNYC1fL/gd9jxfQTj/MUkxMXgVaKKZ1aFBX
	 /uryQUyVn34/ocQcW6kGBvDOoYpqOKoyxLdVcLRS6utZWs20ihKFnvLhvvXhqwVFEuqHJ
	 Fbd79wMc+UcieJDrRZRQQdfJtSDX4qizMUhQT8NYN9IfsbmkCooJd6N4+O7VTaAckBGSp
	 TYPgaQwsYQoCuCWRK7WVyv39Uij4uA6N2gCc12/8fW/YHzvThYgRf2tT2PyCqv8b7MPFZ
	 xQ/zh+VTjXPdPEl/7DHCt9mMGB6vW3oR5vgUQsenSl7a3Sd4I060F3RaWSLyxqUYV3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794579503;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-HM-Tid:
	 X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=Qyaz6anDff1m+MJvuXWZ96yVXjlV1uDHskr+l2C3XH4=;
	b=HZrK/EJNQ97HpDcvGKdBPbaMCV11rytUvOzRsQCqEY3XlzYGSD1D2ahrsjm7TwZ0HgXj
	 6MjcDjuRN/aJdz/JZFIktJIG86wrd0wKzDsXu0Ffi5mCbuQYqRtEeGEkrPV/Guf1FiHZ2
	 Lx2SIdDSWR2xfF9zBRYmdrsI6VHk7F7ZNJWFjOJrgA2ep1XP6honk3dyngSGjtee6ebgK
	 dPGPj9hAD5AcXBwp8pIPcjnC7KkC2LayqxQ0frALGDjyifBqMD5xgZP7Y0iw+4ISGrwBe
	 CWS0hobSLJMLatMHvUM9ozvPzbxGEA+BWvePSDRDIxb6vuDuegh7Yw53AJD/oHy7gzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=GVTXFRTx;
	arc=none smtp.remote-ip=45.254.49.197
Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BDA606A327;
	Fri, 13 Nov 2026 14:18:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60BDA606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=GVTXFRTx
Received: from lgs.. (unknown [101.76.249.61])
	by smtp.qiye.163.com (Hmail) with ESMTP id 549b5a85f;
	Fri, 13 Nov 2026 22:18:18 +0800 (GMT+08:00)
From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: mptfusion: Fix potential chain array leaks on attach failure
Date: Fri, 13 Nov 2026 22:18:17 +0800
Message-ID: <20261113-4e14e563a1-scsi-mptfusion@mail.sdu.edu.cn>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1d546053f03a1kunm3ca48f3b489c1
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDGh9OVh8aH01KTEpPTE9IGVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWUtVS1VLVUtZBg
	++
DKIM-Signature: a=rsa-sha256;
	b=GVTXFRTx7Bve1nZHClc++QOnG0w5Z4HiQ9ltEkl3xCElP/SJpoAeHCmZ7+Z78xbd57dabwMygzYtrMFzL/l76ZzNxLfaCGbADj9SP4oExeXe+PR724DmwzcHu+RBYYQ5qYHcd+GobAb1AdM+zVh+BiupMxeRxoXUmBQm3bEuM7k=; c=relaxed/relaxed; s=default; d=mail.sdu.edu.cn; v=1;
	bh=Qyaz6anDff1m+MJvuXWZ96yVXjlV1uDHskr+l2C3XH4=;
	h=date:mime-version:subject:message-id:from;

initChainBuffers() can allocate some chain control arrays before IOC
bring-up fails. mpt_attach() then frees the adapter without releasing
those arrays.

Free the chain control arrays before freeing the adapter on this path.
This also handles partial allocation failures without invoking teardown
that requires a fully initialized adapter.

This issue was found by our static analysis tool under development.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
---
 drivers/message/fusion/mptbase.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 3a431ffd3e2e..a0592404472c 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -2015,6 +2015,9 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 		destroy_workqueue(ioc->reset_work_q);
 		ioc->reset_work_q = NULL;
 
+		kfree(ioc->ChainToChain);
+		kfree(ioc->RequestNB);
+		kfree(ioc->ReqToChain);
 		kfree(ioc);
 		return r;
 	}

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0

