Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC2038D6B8;
	Mon, 20 Jul 2026 03:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784517867; cv=none; b=jOZE17R2DlECPU0GdmlXg7YAZ0KyiiQRK6o645pOMYPqDRekZCVC1LFnil3wvIEVeC79mpkanCxms7veJD4psz89FwcWqlVB18wWz3tTj7owcBdNJiglpLkj61UrPDLmhU4Wft3RC2b2WQM2mPkmbsW0t8OzmICaFMhVhOPOlTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784517867; c=relaxed/simple;
	bh=9AIldpakpaDdyKD+FVqD/neNBgryxmwUPhRRbJ41WEI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UqgxxSazdMi3eO54xWfqyOJtZ0HfhufdOtTn8NJi0zPgdfarJwqjcL8LTyk2XosyL9EdkzJ3XMjN995nHH/yVn4cDf9mecbXxB2bYwpXgz9XktMja5KQfJ8gznMqow8brH2LjNOoSd1CsJMPXyypADNvLya+QMytiNsFlgdQJs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=YL/jXZgP; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="YL/jXZgP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=b5
	fosquQDt+G3nhBImZazI725GmegFGtfga5w+eIUlw=; b=YL/jXZgPJujNRlHot+
	ELeL5KRz+qXjeJEwAj96lRefKXHFW6U0bR7R6m++ln5niitv/qvH73sYcja+mNFE
	tE6JG2fvS2LXVlJSpNENRjF9QVKsiuqeDuHxc8FFHfdiRqejAk4jFIGKCuZc/j1M
	tkzrD5BSgOdi0IK2FUFvOyzoQ=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAH9nK8lF1qF6ikKA--.13720S2;
	Mon, 20 Jul 2026 11:23:41 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: rc@rexion.ai,
	axboe@kernel.dk,
	fujita.tomonori@lab.ntt.co.jp,
	bvanassche@acm.org,
	linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH 0/2] scsi: bsg: fix io_uring passthrough issues
Date: Mon, 20 Jul 2026 11:23:36 +0800
Message-Id: <20260720032338.461681-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAH9nK8lF1qF6ikKA--.13720S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Jr18tr15Jr4kZw48KrW5GFg_yoW8JF18pF
	W5tw43Gr4fGr1xJFs3Gay8ZFyFgws5urW7GFsIgwn5ZrZ0k3Wq9ryIg3WkuFyUAr92kry0
	qryqgr98Gw1UKwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UkCz_UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6R5G1mpdlL65ewAA34

Hi,

Two fixes for the BSG io_uring passthrough path.

Patch 1 addresses a TOCTOU where the shared SQE can change request_len
between validation and copy_from_user(), overflowing scmd->cmnd. This
is a v3 of Rahul Chandelkar's series, taking over after no follow-up to
v2. Relative to v2, READ_ONCE is limited to fields used for validation
and buffer mapping, as requested in review.

Link: https://lore.kernel.org/r/20260527105931.3950913-1-rc@rexion.ai
Link: https://lore.kernel.org/r/20260527191817.142769-1-rc@rexion.ai

Patch 2 uses GFP_KERNEL for user-buffer mapping. IO_URING_F_NONBLOCK
still sets BLK_MQ_REQ_NOWAIT so request-tag allocation does not block;
mapping itself may sleep and need not use GFP_NOWAIT.

Changes for patch 1 since Rahul's v2:
- READ_ONCE only request/request_len and dout/din xfer fields.
- Pass stable map arguments into scsi_bsg_map_user_buffer().

Please review.

Thanks,
Yang Xiuwei

Rahul Chandelkar (1):
  scsi: bsg: fix TOCTOU in io_uring passthrough command setup

Yang Xiuwei (1):
  scsi: bsg: map io_uring user buffers with GFP_KERNEL

 drivers/scsi/scsi_bsg.c | 47 +++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

-- 
2.25.1

