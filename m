Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794470414;
	b=WxMAQ3herhvusKGTYh9g8+aO90MC0yUAmHGnpfiXzBbg/LgdRQQoARnGzZRlrA/McBm7
	 CRRtwmQzMY3+WZSkljwZ3877cV6FJEiSyHRTP/CaW6BV0dHPV/CuVZjaHdnb/f3vVcqQQ
	 fpr5oa/iWV/YjuYYAeKPY0gnEcFBf1UVpoYDNiP4o71P8yS6k/tXsmd8TBEg9Jx2giVNq
	 tfYQ/9bNQq/5MO8Ep4XPaI16opdMR2XEM+L1l/0yY9BgiP0ECaNmne0SQHVu8ExohHJrz
	 M5t6+cQ8wctuj7fXq53pobSIRWzzbcOXUqMNAhlUWjo+fnxJB8QDiq9rgIHmRuktEeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794470414;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:Sender:X-CM-SenderInfo;
	bh=Ajl0gKKTFleSPGqZRRPCCGN0afkFMTAwCtmLfUkA4SI=;
	b=WrjRMcmhyHwDZDwn2VLj7SDg95LFA0yZXBnjwIVXVyOgZnA7bXbWa8ZqCso8eSfZLwHY
	 Y/YLI9/G/VI0frTY8L8wTLll/SSZSEo/eXxzb8ZhVeMX22pUIi3N+L8Wk8zAhLkNhLR3u
	 5n2VTtcTsbkdPElUhJy3N4WSDdDoFbM4lYQU2MFa2Cu1PGWd5X+RNtsdE9KQNI+rtH0k/
	 kOV8Mkp1/JINiUkYmQUdCOZpHifv09+0XxZ5jcUKJudY1RCEm7u1GznCQ+NYH0yiBlgMj
	 e3agwj5wf4lmKgn3RBB23HsITFjKutPaUYzGtYBt9wclvs2d8mtVDvONaGP4wvJtpEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=XNHAYpRe;
	arc=none smtp.remote-ip=220.197.31.4
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39391606A881
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 08:00:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39391606A881
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=XNHAYpRe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Aj
	l0gKKTFleSPGqZRRPCCGN0afkFMTAwCtmLfUkA4SI=; b=XNHAYpReGhB66E0qm/
	+PIIwJ5SCltIXrxVqzJ+Mh/SCu7x34+8KXtD3S9OmfO9ZhEKbc85oCtAXmaQjoV3
	m95sigkon4QNkhh+F9XMCU2PGkq5W9PNTpbLSE01OlD1CINN22osRq5Ix9RMpH2J
	AQqhr9vKxbSUGFk/1QHVA/GXU=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgB3ppvXcfVqYQ7NFQ--.53224S2;
	Thu, 12 Nov 2026 15:59:20 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 0/2] scsi: lpfc: fix unload flag test and SFP mailbox free
Date: Thu, 12 Nov 2026 15:59:17 +0800
Message-Id: <20261112075919.1247605-1-yangxiuwei@kylinos.cn>
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
X-CM-TRANSID:QCgvCgB3ppvXcfVqYQ7NFQ--.53224S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU4zBTUUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6hiqO2r1cdixxwAA3j

Two independent fixes, found while reviewing lpfc patches
for a driver update.

Yang Xiuwei (2):
  scsi: lpfc: Test FC_UNLOADING in load_flag
  scsi: lpfc: Free the SFP mailbox unless the wait timed out

 drivers/scsi/lpfc/lpfc_els.c       | 11 +++--------
 drivers/scsi/lpfc/lpfc_nportdisc.c | 18 +++++++++---------
 2 files changed, 12 insertions(+), 17 deletions(-)


base-commit: 9d66f26fefacebfeed15de31c1123451a17ff119
-- 
2.25.1

