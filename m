Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377732BEC3A;
	Mon, 24 Nov 2025 18:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764008548; cv=none; b=FUwYqr6mXNuO2u5oRH2gf82K/wTaGdU6YEaeJICc/BcPhxS/m7uURQ3N42IsqNsOoH2Msd30HQfoMtjojA5vZhOHAMPRG2GV//LK5bLzVtgEiwMdw27iLNHZR8hkyi5wTHf8AHUk7G/ccM7NqqfNLMb6vqE1FgRFMFwHYzHe8Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764008548; c=relaxed/simple;
	bh=knUnB1Fd7cRbDXio3Uw98H9CG37EwlCHBjIoOfyIEVo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uMP6QZn5OU0C/L7wTLe6+dHHgIqo3+67KpkZAFz0TiajqyZSeELhuYdLoE8pt0103vIkj16OYgMwcWeeB1X8wBNiT4xZypuGjTJ4h0Z2OoYtxpE71glJVhqlIhgnsfw2QX0pjLwx0oG8m3sr8CTyRERatz2HLfY+N/ub8gLPAyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pW4E5A+L; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pW4E5A+L"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4dFZ174cVQzlgqVQ;
	Mon, 24 Nov 2025 18:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1764008538; x=1766600539; bh=m3SJ6N9BE2mpq64gRQmr5sbRsPBag4iwWkt
	SCwBv2IM=; b=pW4E5A+LInpC4sFKiN5iPbT57sULKIs8bhXKD45hwm1WatrwkNU
	QiKwbbeC4uLrbBoiKF7VK4S0sPwVr3tJMzsC4C7nW5MDoknFjokc7ezptTWmJnP5
	JzYhxgoQ7R+Zr6l9p/pPGQ+5oUtx9CmAD2p5K51/O20e5KB+Yj+6w5GLLxd1ZURP
	knHHaUHVY/nAVLYh8EH6RoqqVvGVQND+ETUHkItlFQqLQa7X4V4LjeWG4q0TD1rW
	oMd/zkgSNP/HjvtBhv4Cw9aAkT32MWGWJjtv2IOjg4M/zkMpQabbZarbnxssrW6E
	9THiIDGYBMNQXKToDIUpc5Eiu67QG8feJNw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wT3lUb14wuHL; Mon, 24 Nov 2025 18:22:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4dFZ122ngMzlgqTs;
	Mon, 24 Nov 2025 18:22:13 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/5] Increase SCSI IOPS
Date: Mon, 24 Nov 2025 10:21:55 -0800
Message-ID: <20251124182201.737160-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series increases scsi_debug IOPS by 5% on my test setup by dis=
abling
SCSI budget management if it is not needed. This patch series improves th=
e
performance of many SCSI LLDs, including the UFS and ATA drivers.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v1:
 - Fixed a hang during LUN scanning for ATA devices.

Bart Van Assche (5):
  block: Introduce __blk_mq_tagset_iter()
  block: Introduce blk_mq_tagset_iter()
  libata: Stop using cmd->budget_token
  scsi: core: Generalize scsi_device_busy()
  scsi: core: Improve IOPS in case of host-wide tags

 block/blk-mq-tag.c         | 51 ++++++++++++++++++++++++++++----------
 drivers/ata/libata-scsi.c  | 18 +++++---------
 drivers/scsi/scsi.c        |  6 ++---
 drivers/scsi/scsi_lib.c    | 38 ++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c   | 18 +++++++++++++-
 include/linux/blk-mq.h     |  2 ++
 include/scsi/scsi_device.h |  5 +---
 7 files changed, 104 insertions(+), 34 deletions(-)

