Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2740305074
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760472100; cv=none; b=aWd20RK4WCryvhnZO5Up5aVcLRgiZZctdI7r8wS/t9tut/nrXd5JwugO0v+WX9PtbfHzE4/DNdVEBFdBCXijRY0ekFdzWCTAsIx/5LyXZ/FzwPBik2S7RKYAQDDw5xLMLpGXqfVFkttxDWyVSxB7o8HsLi9mrRniyqmzFHdyAQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760472100; c=relaxed/simple;
	bh=C9MH48dGfr7HoA80zT/brhxHdWDVQU/DM9C6VLCzWqU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c3QByT2Rxnx2LiZTIipVOigtgnBHLwklV9rWtWzA57YC1q6bUgfEYmiIQLZ6gM2ZoTUwsp/N9LsAs1WhnN7fXn4j3/YitRpnLYGqWVT0fkf3H/5zgkUMBkjzsydEdKqsoEEJfy/dAX2DDDlrxOpQfA0JxA19AFKi28pu4QbGU1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DPvjJega; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DPvjJega"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cmQ8d3f3XzlgqTt;
	Tue, 14 Oct 2025 20:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1760472096; x=1763064097; bh=oSpDK409TRtXW9Qzdhm0CnrwgWTzO9Uzu81
	uB8efbTY=; b=DPvjJegadyWVR7a+JVPLBKD2kb8zx/X37/DIHct6XlvjOt/X2ep
	Wc/TO0fz6ULY6ot/YkNoGUKtC4oQMJlCClDQB26hE18kq6SDBMyZaFUvoEWjpAx4
	qbFjWw1ZLb4/2/Nn8ijjo0peuL0lkQygN6uYxC2lFcsJvSyV4OuoNHRi3RncMjXU
	26oyriIwu4S7fgRiJGTlQLbR863NHUSiaVUteR19J3xmKFt+9cLTDdm43zC6KQ7r
	1KZ53L6ZFmkdKRbkn49vym4SjcinmNkQDFKztk6eDLOh7pE8vqq/0Xf/ZeRNj7S6
	I7sPpUoMOn7wxzIAo0WwBrk9ofEhlza9JtA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id P9aftmXkyyYj; Tue, 14 Oct 2025 20:01:36 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQ8Y25l1zlgqyf;
	Tue, 14 Oct 2025 20:01:32 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/8] Eight small UFS patches
Date: Tue, 14 Oct 2025 13:00:52 -0700
Message-ID: <20251014200118.3390839-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series includes two bug fixes for this development cycle and s=
ix
small patches that are intended for the next merge window. If applying th=
e
first two patches only during the current development cycle would be
inconvenient, postponing all patches until the next merge window is fine =
with
me.

Please consider including these patches in the upstream kernel.=20

Thanks,

Bart.

Bart Van Assche (8):
  ufs: core: Fix a race condition related to the "hid" attribute group
  ufs: core: Reduce link startup failure logging
  ufs: core: Improve documentation in include/ufs/ufshci.h
  ufs: core: Change the type of uic_command::cmd_active
  ufs: core: Remove UFS_DEV_COMP
  ufs: core: Move the ufshcd_enable_intr() declaration
  ufs: core: Remove a goto label from ufshcd_uic_cmd_compl()
  ufs: core: Simplify ufshcd_mcq_sq_cleanup() using guard()

 drivers/ufs/core/ufs-mcq.c         |  6 ++----
 drivers/ufs/core/ufs_trace.h       |  1 -
 drivers/ufs/core/ufs_trace_types.h |  1 -
 drivers/ufs/core/ufshcd-priv.h     |  2 ++
 drivers/ufs/core/ufshcd.c          | 17 ++++++-----------
 include/ufs/ufshcd.h               |  3 +--
 include/ufs/ufshci.h               |  3 +++
 7 files changed, 14 insertions(+), 19 deletions(-)

