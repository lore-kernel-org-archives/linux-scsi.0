Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8233B5DED;
	Mon, 17 Aug 2026 08:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786954117; cv=none; b=oN2Nfl/O2DC0LCVQca2h2OSUK5wUEKbZwXnAGZsl9JOI/iF83jTwcRyz7NpYip59YPD34RR0woAabreP5zYy9201dCSEHYz1bmSCb/e8iwAGy7b8PURla1I7+9p5nrRJUpKzRyYSN0ZDf/VRiUy30yxsZf9tXSAaoXb7IF6wy1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786954117; c=relaxed/simple;
	bh=7aaHk2NGIhj2niWdluF9fOrKZdCdtIVfkgTqLTia5Cs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=h1QLrf62oUdI+bymunw9wS6tKAwwgMIcygTxuE8Uo1blo7MITQUMpQf2g9M19JG29+qaa5adpo2fPrtPp2bhk3O4wF2lZav6EQjDiYk+Viq9qQqFuaHzoZ0N1RyCIWtkBRhsusl2dyNRTY5Tm+NxztWIg9eac1RIiM35kfGVvBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=lzVLJNLT; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="lzVLJNLT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Nc
	6rA2CHJoIg7i1iYalEg5ebAhZZM81OrJjyQONul/U=; b=lzVLJNLT0P0Twa8FfV
	xtVohQOknjN6t66q4oTCiamRrIXSAuJ2NrB6CfHCpsTXqYDWbB1x9yqNgtd0YXRc
	eTdjEXF5iNvPMp7bIytNorYJDlH5ts8RZ7YTFq6i2wZoi0tHgqIOdh/sG5Spbchg
	wx4w1c0DrKzQvCu7TzBGjokjI=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wBnnvpFwYJqCVRqOA--.71S2;
	Mon, 17 Aug 2026 16:07:37 +0800 (CST)
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
Subject: [PATCH v4 0/3] scsi: bsg: io_uring passthrough fixes
Date: Mon, 17 Aug 2026 16:07:27 +0800
Message-Id: <20260817080730.967879-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnnvpFwYJqCVRqOA--.71S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cw17ZrWxXrWUGFyxJw1kXwb_yoW8Wr1DpF
	4aga13Wr15Gw1xJFZ3Ga1xua4Yqan5Xr17Ww43Kw1fuFWDZrnFvw4Ivr409a4jv39FkryU
	ZrnxWrnF93WjqwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UD8nOUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwgq9TmqCwUogpgAA3e

Hi,

Three patches for the BSG io_uring passthrough path.

1/3: cap sense copy to max_response_len (and stop stuffing that
limit into scmd->sense_len). Noted by sashiko on v3:
Link: https://lore.kernel.org/linux-scsi/20260817015247.B9CF61F000E9@smtp.kernel.org/

2/3: fix TOCTOU on the shared SQE.

Builds on Rahul Chandelkar's earlier TOCTOU patches:
Link: https://lore.kernel.org/r/20260527105931.3950913-1-rc@rexion.ai
Link: https://lore.kernel.org/r/20260527191817.142769-1-rc@rexion.ai

3/3: IO_URING_F_NONBLOCK only needs BLK_MQ_REQ_NOWAIT for request
allocation. Map user buffers with GFP_KERNEL.

Changes in v4:
- Add 1/3 sense copy fix; put it first so TOCTOU does not need to
  READ_ONCE max_response_len for a single PDU store.
- Reorder: sense, TOCTOU, GFP_KERNEL.
Link: https://lore.kernel.org/r/20260817013959.165425-1-yangxiuwei@kylinos.cn

Changes in v3:
- Reword TOCTOU commit message.
Link: https://lore.kernel.org/r/20260727014117.1742202-1-yangxiuwei@kylinos.cn

Changes in v2:
- Also READ_ONCE fields used across check/use (Caleb).
Link: https://lore.kernel.org/r/20260720032338.461681-1-yangxiuwei@kylinos.cn

Yang Xiuwei (2):
  scsi: bsg: cap io_uring sense copy to max_response_len
  scsi: bsg: map io_uring user buffers with GFP_KERNEL

Rahul Chandelkar (1):
  scsi: bsg: fix TOCTOU in io_uring passthrough command setup

 drivers/scsi/scsi_bsg.c | 54 +++++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 24 deletions(-)

-- 
2.25.1

