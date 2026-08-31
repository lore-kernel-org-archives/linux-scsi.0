Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7133529D294
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 17:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788199120; cv=none; b=VD+ULsesrD0eLHM7xMCqbo/r8aNdIfbLP13qTxc/Emfdc2Uk4Tl8NHZOg50e3ZQ4jEOzpwzQhFceBm6waogZWxla5PQC43PpaMyeX08SvvjrPqvZo1l9qDqceXm5m5atHspJnBiasBo8QYZqV+h/h8vwGb0z71z68QEAYlLju1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788199120; c=relaxed/simple;
	bh=ap8iH+7EMBgA9ZasbgH0UoK98GKVBiKKQAl5CUev7O4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MgQb0JA2Ooln2jr/MBgDNqFVV4Q7MHgtH00fjdewGl7jbCGWYUXKyYk1vdtS5RMbAeReZahch9K+8Hf9wgNM3GBj14EOITcpeAy4fHcPCGqggwiqfYCiiC0gzMsx+szqFZvn+I0sRXA1Xzp6OBnIpfMaJoHDBAR/ER8DfWQ8hn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=t0teu51k; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="t0teu51k"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hYcDY6mLLz1XM0p5;
	Mon, 31 Aug 2026 17:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1788199115; x=1790791116; bh=D5PFLpde6zSV/O/kyGgh6OKSMAmbFz7cZ+s
	AEFQnjhw=; b=t0teu51k2qaImLtakwQb2fIh5pf1ACTvzx/fotdFblshaSyY/Ta
	dA6PDV0x9Dvxz6E/fuDeeLIdSi/vSjPCjIJocBmnzjm1txs3fugrvYuWtlW8L5/m
	bG/sjSVCOoSkHkJsPKj9rbgKQ6pGN8a9J8/ysQDRCmTkUpLS5FmParjf8OlJSpXa
	bY7fmsjj0QvFJogoV1/8QqIEQ2VsYQaOw2k2iGOvxbxsSIRc+0uCmBPxo6ShwEz7
	N77RUdumPwxrbzGR/bGqIWGnWFxVCevQku1pdJC6ACLqmW+6VCpfYkF8iDdP1pIU
	Xn92RJ0WSzbkA4m01AyYytA3H4FIHh368tg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UP_ZqCoHgMr2; Mon, 31 Aug 2026 17:58:35 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hYcDV26Bcz1XM6JZ;
	Mon, 31 Aug 2026 17:58:33 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/2] scsi: core: Optimize the SCSI printk() variants
Date: Mon, 31 Aug 2026 10:58:17 -0700
Message-ID: <cover.1788198780.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

The SCSI logging functions currently allocate a temporary 128-byte
buffer via kmalloc(..., GFP_ATOMIC). This design has several drawbacks:
 - Runtime memory allocation and freeing overhead on logging paths.
 - Truncation of log messages to 127 characters.
 - Discarded log messages if the buffer allocation fails under memory
   pressure.

This patch series eliminates temporary buffer allocations from
scsi_logging.c by formatting messages directly using struct va_format
(%pV) and dev_printk(), as well as formatting hex buffers directly
with %*ph.

To ensure formatting and logging behavior remain free of regressions,
the first patch introduces a comprehensive KUnit test suite for the
SCSI logging functions. The second patch refactors scsi_logging.c to use
the direct formatting helpers.

Please consider applying this series.

Thanks,

Bart.

Changes compared to v1:
 - Expanded a single patch into a series of two patches by adding a
   patch with unit tests.
 - Restored a newline in a format string that was missing from v1.

Bart Van Assche (2):
  scsi: core: Add KUnit tests for scsi_logging.c
  scsi: core: Eliminate scsi_log_{reserve,release}_buffer()

 drivers/scsi/Kconfig             |   9 +
 drivers/scsi/scsi_logging.c      | 285 +++++++++------------
 drivers/scsi/scsi_logging_test.c | 422 +++++++++++++++++++++++++++++++
 3 files changed, 547 insertions(+), 169 deletions(-)
 create mode 100644 drivers/scsi/scsi_logging_test.c

