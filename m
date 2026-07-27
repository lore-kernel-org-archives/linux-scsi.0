Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E605738D3E0;
	Mon, 27 Jul 2026 01:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785116620; cv=none; b=N5FWfpUxfsaWgYLjhOlm3VCXs5f+2aUE8jGkhUg0RDnEq4uZSQ2xVVbq2vcDNJ8Lk9RWkSt4AnEAhOF3C6Fzz0pCKaf2kMgWKJQE90mIFvSPZHY/EKDcFWTxKUyFmCC6gOmPGz4hDEFS4s5WwuRj9gffiBnwhK9QsPAcb6GMKD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785116620; c=relaxed/simple;
	bh=32OMK8AiZBc3G1sCee+gVd5XQcfCBFT/feubwgiEl08=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iGWn+7SxXiJLHG+sbCAls7ExWeHrGQarqYtJQxJ5FrKKxpbXtLXUZN6n6fC2Je3oAUj6OayqGatI1G/OCl6Bz46oPnfD5DZrZWC1BhqjcYimQXPabpQow3ugnWUBTnhnx4ct2N2DxfV6Z92UlglKKwfOfl+79kvQTD/UdaAuTEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ASLMk/hU; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ASLMk/hU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=n7
	x10hLGteiPHO3JEPH9PTNbIU0zYrXrt72SaNZrXq8=; b=ASLMk/hUgQMJtufdH2
	9p4m+yGTmg0TWhxc376h0fdMYtGmdU6c3s0VDSP918Boh44HH5l4Vba5V/rYPFio
	h2LkqdXbkxMPb3BTMmNDTsjHiHf4Bg7ZvNIicPbTCE5C3HDBDd3qbpLfQFLQAQiM
	OEHLfnP4dmOQov2VS0FhT2UGc=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgDXnw0_t2Zq_LNqJw--.32185S2;
	Mon, 27 Jul 2026 09:41:20 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com
Cc: axboe@kernel.dk,
	bvanassche@acm.org,
	csander@purestorage.com,
	fujita.tomonori@lab.ntt.co.jp,
	io-uring@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	rc@rexion.ai,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v2 0/2] scsi: bsg: fix io_uring passthrough issues
Date: Mon, 27 Jul 2026 09:41:15 +0800
Message-Id: <20260727014117.1742202-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgDXnw0_t2Zq_LNqJw--.32185S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruF47ur4UCw1fKFyrCr17ZFb_yoWkurg_ur
	yvkFyrJw18JF47uay09FyaqrZ0k3y8XF1rKF95t3y3Xw17J3ZxXFs5trs3ZrnrWan7Xr13
	Jws5X3s7Cr1DtjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbomh3UUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwgEywmpmt0FgMAAA3Z

Hi,

Two fixes for the BSG io_uring passthrough path. This is v2 of:

Link: https://lore.kernel.org/r/20260720032338.461681-1-yangxiuwei@kylinos.cn (v1)

Patch 1: the shared SQE is still user-writable on the inline path, so
fields can change between check and use (request_len overflowing
scmd->cmnd). READ_ONCE the fields we validate or consume, and pass
stable map arguments into scsi_bsg_map_user_buffer().

Builds on Rahul Chandelkar's earlier TOCTOU patches:
Link: https://lore.kernel.org/r/20260527105931.3950913-1-rc@rexion.ai
Link: https://lore.kernel.org/r/20260527191817.142769-1-rc@rexion.ai

Patch 2: IO_URING_F_NONBLOCK only needs BLK_MQ_REQ_NOWAIT for request
allocation; map user buffers with GFP_KERNEL.

Changes in v2:
- Also READ_ONCE max_response_len (Caleb).

Please review.

Thanks,
Yang Xiuwei

Rahul Chandelkar (1):
  scsi: bsg: fix TOCTOU in io_uring passthrough command setup

Yang Xiuwei (1):
  scsi: bsg: map io_uring user buffers with GFP_KERNEL

 drivers/scsi/scsi_bsg.c | 51 ++++++++++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

-- 
2.25.1

