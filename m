Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51DF76026;
	Mon, 17 Aug 2026 01:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786930857; cv=none; b=ZIvxuRCTpTvEvQWR+XSscKqvvGOI/UZa6jeyieL9NhMHFcf8QgfBeBjBnzXmxE15zBNapq6gjVMpBSOPM26CweYP7aFSVJioXl6v/Yzlekf1yCdaNo+twpwz74BuNyB73+2YLKPAyC2KgKCKxkYHcuCV/Q0KLr9WjzQKSILHVWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786930857; c=relaxed/simple;
	bh=fsrFasTqjrh5yXlh31yAOvm51YJc8y6RjYKthPPQ76k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Iu6x39DsC5R506U7MlGqs3pzhXoKfwCucDO9Ly828Htwmk8psSnDw9gtmkmaXr8esQissQpRlnRN/5BQaPdzSapM0v0ae4mZ5vLDzklVpn1N3wW3D8lwAm0T7/vAwJ0lH8CW+u+jB8ZGF0zP2XYd247X0fIXUEy7/1BrpoWAyh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=XFV4aqOU; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="XFV4aqOU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=dg
	dJ1FfQ3kBEMkjlqJ0aXGgYodXmUYCRWyfW4sy2SXg=; b=XFV4aqOUQ/GLoH6FMb
	zK7j/nzbi+F8KRn5AAU78+BPttjnPEIrE4UjR0O6lH0nw3r/vkYlfzQ2TQWHIIgl
	SJ1R0+0wf5tcVhcpN6vvEwBtZYc+ucLg2p731mkuBkxQdW2kWTsz47lCTnByWsZ3
	cnOKDtGtOfZOSvfekMMT4kmBc=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgDH5w5yZoJqQVejLg--.13488S2;
	Mon, 17 Aug 2026 09:40:03 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: axboe@kernel.dk,
	bvanassche@acm.org,
	csander@purestorage.com,
	fujita.tomonori@lab.ntt.co.jp,
	io-uring@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	rc@rexion.ai,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v3 0/2] scsi: bsg: io_uring passthrough TOCTOU and mapping
Date: Mon, 17 Aug 2026 09:39:57 +0800
Message-Id: <20260817013959.165425-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgDH5w5yZoJqQVejLg--.13488S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFW7KF1UKw4xtw1UXF4rAFb_yoWDArb_Cr
	yDCFyrGw40qF4UCayIkF1Svryqy3yrJF1FgF95trW3Ww13J3ZxXFsxGrZ3XrnxX3Z3Xr13
	Jw1rX3Z2yrn8tjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUboKuUUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6hTxgmqCZnT6kgAA3f

Hi,

Two patches for the BSG io_uring passthrough path.

1/2: fix TOCTOU on the shared SQE.

Builds on Rahul Chandelkar's earlier TOCTOU patches:
Link: https://lore.kernel.org/r/20260527105931.3950913-1-rc@rexion.ai
Link: https://lore.kernel.org/r/20260527191817.142769-1-rc@rexion.ai

2/2: IO_URING_F_NONBLOCK only needs BLK_MQ_REQ_NOWAIT for request
allocation. Map user buffers with GFP_KERNEL.

Changes in v3:
- Reword 1/2 commit message.
Link: https://lore.kernel.org/r/20260727014117.1742202-1-yangxiuwei@kylinos.cn

Changes in v2:
- Also READ_ONCE max_response_len (Caleb).
Link: https://lore.kernel.org/r/20260720032338.461681-1-yangxiuwei@kylinos.cn

Rahul Chandelkar (1):
  scsi: bsg: fix TOCTOU in io_uring passthrough command setup

Yang Xiuwei (1):
  scsi: bsg: map io_uring user buffers with GFP_KERNEL

 drivers/scsi/scsi_bsg.c | 51 +++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

-- 
2.25.1

