Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66851CF8F
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 20:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719952861; cv=none; b=cGO5Ts0iGxy5eXVAlHL31KKXUQs0AkeMx+mfKZiZMQ4MxDMwMtdllMorY0BN9/qoN/Bq098BW0ZM8kwmEWR2I8t7OUEiByWJzX6uk1r9LY79vfnrO/gYWjItQ4BYfPfOe8MprbPj+/JyTji1YZIp9RYoiVDbamwWTLQZWGJ6at0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719952861; c=relaxed/simple;
	bh=S3wM9PajBzYQgi0LoidUjTckCys+4zo612WXg2RlSfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VkI0ZofHOvCKHIdNHBbaSoEo/umdUoiTjz8tF6gY9qSPtRSDmxBev2M3wiW/octoflKc6JH8B1+GzbX3Dl7kRUhCjc73lw9mxX4K2h1aURAG/322wjorS0V1/a/3Z/wp9v25Os2ZWRnyp+UWk87wY9RF/YymesLH60KHr8+cx44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cI6AxE3y; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cI6AxE3y"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WDFDW1ZbGz6Cnv3Q;
	Tue,  2 Jul 2024 20:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1719952857; x=1722544858; bh=u8vyIdNqTfQetHj3csxR2EevsWOm6YM1Ss3
	GYgU+mnA=; b=cI6AxE3ygCDq4xX4PfWZ9CpGDbBuAPSFqa+VXEY+ueVrDOBMuat
	77ZMZMEbuce6CsjH2ItM6B0WbesBhSfrKsT7x/PesODA6kKhCJ//JXQSocFGe7Mj
	FRd0yy6Ghb2Wv0HPvu+bA8KZSaeFLVefh1O8KgaGX1CwiubV7g/R06y29FMwBqQy
	K4n1X06/A6qXafyCILJZf1aHcQJA3ORSSeFjoweXwsQhablGi3ALGu6Kp8Mu97rb
	PIt0GSuRlgGBuH8QeqgUF8RZtaJIKFo7d26LjFUxfGaFzlVirsT9cmvomvXSCf7Z
	+kBRbvpevZo0DE1NBaWWRkiJJVo8I/ZHbAA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TZMI_aG78KDJ; Tue,  2 Jul 2024 20:40:57 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WDFDT20xgz6Cnk9X;
	Tue,  2 Jul 2024 20:40:56 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 0/9] UFS patches for kernel 6.11
Date: Tue,  2 Jul 2024 13:39:08 -0700
Message-ID: <20240702204020.2489324-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

Please consider this series of UFS driver patches for the next merge wind=
ow.

Thanks,

Bart.

Changes compared to v3:
 - In patch 9/9, enable MCQ before reading the maximum number of active c=
ommands
   (MAC).
 - Added two refactoring patches: "Inline is_mcq_enabled()" and "Move the
   ufshcd_mcq_enable() call".

Changes compared to v2:
 - In patch 1/7, remove more duplicate declarations.

Changes compared to v1:
 - Based upon reviewer feedback, a new patch that renames the
   MASK_TRANSFER_REQUESTS_SLOTS constant has been added.
 - Because there is no agreement about these patches, the following three
   patches have been left out: "Make ufshcd_poll() complain about unsuppo=
rted
   arguments", "Make the polling code report which command has been compl=
eted"
   and also "Check for completion from the timeout handler".

Bart Van Assche (9):
  scsi: ufs: Declare functions once
  scsi: ufs: Initialize struct uic_command once
  scsi: ufs: Remove two constants
  scsi: ufs: Rename the MASK_TRANSFER_REQUESTS_SLOTS constant
  scsi: ufs: Initialize hba->reserved_slot earlier
  scsi: ufs: Inline is_mcq_enabled()
  scsi: ufs: Move the ufshcd_mcq_enable() call
  scsi: ufs: Inline ufshcd_mcq_vops_get_hba_mac()
  scsi: ufs: Make .get_hba_mac() optional

 drivers/ufs/core/ufs-mcq.c     |  24 +++++--
 drivers/ufs/core/ufshcd-priv.h |  15 +----
 drivers/ufs/core/ufshcd.c      | 112 +++++++++++++++++----------------
 include/ufs/ufshcd.h           |  13 ++--
 include/ufs/ufshci.h           |   3 +-
 5 files changed, 83 insertions(+), 84 deletions(-)

