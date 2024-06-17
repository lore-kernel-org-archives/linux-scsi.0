Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E50E18F2E1
	for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2024 21:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718658538; cv=none; b=UtFrRzvZztBxOSNnJ+8itNNxu60Mgd1R6ph8cCqpy1CWONG9uKmzYgbeACEFkJZtNJGxwMbg6B2gCBDdUL8p8wz8LqqnxZAzJpp3QjhQTr9xwGjvYVWCGvaHW5SBng2UWKG1Lc94+q3TpTsO/DCFuDfXIIuYASqGHlJZ4W/hPHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718658538; c=relaxed/simple;
	bh=m8UOXWGFx9EfDGiX4fvpq/zjXGfJ4Iy+l894lhjWcxY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=e30CFDu1reLg7IjvY87IA5XZ2DzKqesZJUeu6z//A5e8ZcPc+LAm8Wpg9+7TX0e9YXzvHxDftIbZI1z423h+4RKz8dBiCNl5fgHSVB6Vjxk7+A+hnTzoHZxMuyH8ASGnFXMzggTDJSXJUdNX4tRwIQNPrHhilbNKa6H9orSf2iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JFpRLlLH; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JFpRLlLH"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W32Yh44Rlz6Cnk97;
	Mon, 17 Jun 2024 21:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:mime-version
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1718658535; x=1721250536; bh=qLFv5
	5wX8qcFNHf8gxhmUQ4hxnf2pgcrgob8RlhaQYg=; b=JFpRLlLH0SW/9aWyLhfw5
	U+IVBY4wXmroj8rEzd4QkBaP56/yrOZKjpYTaZMrp+oXlUPhSysIcGyqrB7Wpdl1
	otzC8LlLayE2kHSCs5p9ryk+VNifxYiEK8/SmZKmRtZV7mIbHTbzivam8eiWgO7H
	j2Vag7ReTAEycRcoteG/EdaRAftf1B9KBoESPp6FSX9npk3hOwN3Qu37I8T3ScQh
	MTRlO0mGZ/AD1rxpYK+J5A4OUHMRw9nKLry04VYM+mhl7YvDoim8amiV7sy9VEfi
	N7i8GuyxS9VM3MMWiFlYEMJxt7PA+pQw4PioMbUyjwgTCiGennkjkROMsLel08zu
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bbF8WVjim3Vt; Mon, 17 Jun 2024 21:08:55 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W32Yg0GW1z6Cnk95;
	Mon, 17 Jun 2024 21:08:54 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/8] UFS patches for kernel 6.11
Date: Mon, 17 Jun 2024 14:07:39 -0700
Message-ID: <20240617210844.337476-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Martin,

Please consider this series of UFS driver patches for the next merge wind=
ow.

Thanks,

Bart.

Bart Van Assche (8):
  scsi: ufs: Initialize struct uic_command once
  scsi: ufs: Remove two constants
  scsi: ufs: Inline ufshcd_mcq_vops_get_hba_mac()
  scsi: ufs: Make .get_hba_mac() optional
  scsi: ufs: Declare ufshcd_mcq_poll_cqe_lock() once
  scsi: ufs: Make ufshcd_poll() complain about unsupported arguments
  scsi: ufs: Make the polling code report which command has been
    completed
  scsi: ufs: Check for completion from the timeout handler

 drivers/ufs/core/ufs-mcq.c      |  45 +++++++----
 drivers/ufs/core/ufshcd-priv.h  |  14 +---
 drivers/ufs/core/ufshcd.c       | 131 ++++++++++++++++++++------------
 drivers/ufs/host/ufs-mediatek.c |   2 +-
 drivers/ufs/host/ufs-qcom.c     |   2 +-
 include/ufs/ufshcd.h            |  11 ++-
 include/ufs/ufshci.h            |   2 +-
 7 files changed, 126 insertions(+), 81 deletions(-)

