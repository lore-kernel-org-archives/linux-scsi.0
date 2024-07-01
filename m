Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB402F9DF
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jul 2024 18:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719857070; cv=none; b=bG+ItSJ5ei9JzznS4FkUaAiyXD881mrLGdAenaxPbvjk7HYKMmNq+5qhhe3oxK2Rpl6Lr+d2b6nkw+UtF4/0WxOgRw65VpBG1+1UOBDGovNPVSjA9buHj+bOlpTVeEaDzrt9k+XlZpLs+kZAzQs9F4jI5za0GCbmbXgTxWOJTIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719857070; c=relaxed/simple;
	bh=Yq1YllaMhNoNUBHcFEf4F1BLUFt5OffNpZxUwdVUHjs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lf4auXH+s3RfpqCmmUABomX2ucczjBs0SHNpOIwMruIytMdm7ubMUZ4mx4+bjj9rXKnHRhneCYFt0Dw7t5mRNMplH7kfHYyrONhMd+WZ7Iq8dNfz9hQpoQNJKN6li7pPOJKc4VCdKoDYjgbMQhCTzTJ3MKbLAAU9a3z+N1/2syM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=udheyjBE; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="udheyjBE"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WCYpN2RdyzllCRq;
	Mon,  1 Jul 2024 18:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1719857067; x=1722449068; bh=MNwKftbtp/chgFzgYR+aPwzbYY2+AtSlex9
	txTX8qdE=; b=udheyjBE4CXeo5c7jWU9WdUR8b6kYqmZ5ANEz0tG8adTLz8Quly
	5UolivKRWEDMzN3+tBuPgnmOqPVaziJIEVc0R0Fmhcuw1yWEYV6754qG5PI/rrcd
	/DQKS/fJiMDvfaf5PL5RPMjhs/4yC4RpkGJaIPQFQdVeJlzSkUlesEKhEYx3M0ZP
	IwYEb5uYZRN9EXND1kxodKOB9QUUIYGEW4C30S8/wes7Da4DmoPqWT2VQTUgo9P5
	ZTEw/Eh5Fs9/oVHcFfiVsRTkovFdLEME8fvkHJH4jnxFr2UAn74mH78TxHKKcaYX
	PUBozcPz4lFLFhL5b2Q2KzK4k3jbc7yIg0Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZZzIuNEBFoFy; Mon,  1 Jul 2024 18:04:27 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WCYpL6Jwbzlffm0;
	Mon,  1 Jul 2024 18:04:26 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/7] UFS patches for kernel 6.11
Date: Mon,  1 Jul 2024 11:03:28 -0700
Message-ID: <20240701180419.1028844-1-bvanassche@acm.org>
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

Bart Van Assche (7):
  scsi: ufs: Declare functions once
  scsi: ufs: Initialize struct uic_command once
  scsi: ufs: Remove two constants
  scsi: ufs: Rename the MASK_TRANSFER_REQUESTS_SLOTS constant
  scsi: ufs: Initialize hba->reserved_slot earlier
  scsi: ufs: Inline ufshcd_mcq_vops_get_hba_mac()
  scsi: ufs: Make .get_hba_mac() optional

 drivers/ufs/core/ufs-mcq.c     | 19 ++++++---
 drivers/ufs/core/ufshcd-priv.h | 14 -------
 drivers/ufs/core/ufshcd.c      | 73 ++++++++++++++++------------------
 include/ufs/ufshcd.h           |  8 ++--
 include/ufs/ufshci.h           |  3 +-
 5 files changed, 55 insertions(+), 62 deletions(-)

