Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BAE4503B
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 21:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720473453; cv=none; b=CGId9I6vmg9Ex45a9JBOiYtLSuBgiP9fBvfgszml4avqDupypBUo980/9fnmo7MGnEiWh6S8p9j9Mgs2qVCSgeCsnzN/xD8K7jMAgGvJQMOZUpQD+suvXNU1A3uOvBDpnrt9jgEQhX2eHNMQdmR1sgk1M6KidCaSEmzbstcw9xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720473453; c=relaxed/simple;
	bh=kTQ23NRh54ZSeLyLqmNXFh1ZrojP+FyycWDU3ZDi81s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MFPoP9z+KAUo/6FE+PSoacRh5SQsR0xkaM6Ws23WKn7In8TYxQ+usRDF6VT1j5inJ62BoWWndWJVDr8Y3PhCMRxUZxwt4fLoYzzuNxnLT2vwXVufwHlYJSX4EXaBNhM9o46SdzqMMIK30Sf3xHQj6I1hB3hn7pxXPkH0IS48fLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uE7hb7T1; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uE7hb7T1"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WHxlt46Rlz6Cnk9T;
	Mon,  8 Jul 2024 21:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1720473447; x=1723065448; bh=itcwCiQqiLrWrZbU69wBqPMULILF3UTw9G6
	XZDRTjXY=; b=uE7hb7T1VVCXbiiRLK2+OVtFLzIA0q+PUAS515lk+e9x3/burBT
	mZT409OnPIqTbiFEgwan9agYIwTX6DuSmvyDqeG7tQoPgNc3Ud2HTh9q91wvCug7
	HwYBUpiYLEjWCvOiQDZSwV+uAp2DIWKnhD5wfNi+y6LLw7VmJ7PyUB8++xZvOdXw
	nNvgp1EvOOejKuE/VlfITwhjukXP/giPnuOldTEzsC3SzByx1F7F9+L7uDfa94pr
	8H5pIUVF1zbktqDuRaal8vyNtCxkFq5894fGgHqKFN7aqy/Wii+g6x/rBuV38tNv
	etVDb+Wp4d9BP8vUFe9TPyaneHPPPhhP63g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KTI7NqcrC1wb; Mon,  8 Jul 2024 21:17:27 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WHxlp2WD2z6Cnk9N;
	Mon,  8 Jul 2024 21:17:26 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5 00/10] UFS patches for kernel 6.11
Date: Mon,  8 Jul 2024 14:15:55 -0700
Message-ID: <20240708211716.2827751-1-bvanassche@acm.org>
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

Thank you,

Bart.

Changes compared to v4:
 - Included changes for the MediaTek driver in patch "Inline is_mcq_enabl=
ed()".
   Dropped the Reviewed-by tags from that patch.
 - Added a patch that moves the "hba->mcq_enabled =3D true" assignment in=
to
   ufshcd_mcq_enable(). Later patches have been modified such that
   hba->mcq_enabled assignments only happen inside ufshcd_mcq_enable() an=
d
   ufshcd_mcq_disable().

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

Bart Van Assche (10):
  scsi: ufs: Declare functions once
  scsi: ufs: Initialize struct uic_command once
  scsi: ufs: Remove two constants
  scsi: ufs: Rename the MASK_TRANSFER_REQUESTS_SLOTS constant
  scsi: ufs: Initialize hba->reserved_slot earlier
  scsi: ufs: Inline is_mcq_enabled()
  scsi: ufs: Move the "hba->mcq_enabled =3D true" assignment
  scsi: ufs: Move the ufshcd_mcq_enable() call
  scsi: ufs: Inline ufshcd_mcq_vops_get_hba_mac()
  scsi: ufs: Make .get_hba_mac() optional

 drivers/ufs/core/ufs-mcq.c      |  31 +++++++--
 drivers/ufs/core/ufshcd-priv.h  |  15 +----
 drivers/ufs/core/ufshcd.c       | 109 ++++++++++++++++----------------
 drivers/ufs/host/ufs-mediatek.c |   6 +-
 include/ufs/ufshcd.h            |  13 ++--
 include/ufs/ufshci.h            |   3 +-
 6 files changed, 90 insertions(+), 87 deletions(-)

