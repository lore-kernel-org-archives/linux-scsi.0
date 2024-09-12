Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418F7370
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 00:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726101073; cv=none; b=JYAST/cS88BAwho1/313wdLRxMHhw6/tAsINd58CFG2mlPipPwubI7adx3Ai7fbvrQdLNAGEu6mmdjqiDGBYOoXm1WxAEiiX+2MDwxSE+88Z4Z2G3IzgqcWpZIATU/HhdOgdaESwI1n4lcUiciYH/z9nm4vM7mCLpy5Kiq624PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726101073; c=relaxed/simple;
	bh=xUov07mhACrM9x9GMLOu76f388kKtGsfHJ9jcK48Eq4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z4AgCLuI2N/AOhAJxtZmPpS7NfthpupzQkNhR6DIWpLS05DgVA+XzMCOjD75q++LX/ozum5xTDn6uIlRD3DVYJRDYWvqqw31ikeSC3tzkThJV6mobjNIRsXEuZ5i2FbVliZQHb/72wxTm+tayVID7FTc9VKtZENeylk80h2GN3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rE8H2EKb; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rE8H2EKb"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X3yzM4B0Rz6ClY9P;
	Thu, 12 Sep 2024 00:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1726101069; x=1728693070; bh=f7ZZM/LpHBgoDcCOcWfBueu3tLCtjUPyERS
	3rg16W7g=; b=rE8H2EKbwAk0TToK2IlwQAz/uw7LVUmDWf+IqGM2pyc/SXa/e4F
	IU2FLmbBASumi5AsQYRjPTN0S54YJWgswT5rr0g5o3d/I6aYd2SBQYCuxYZXJekY
	eh3VFYUUffnViCF3RKsZn7HHsiqwHtp+FlQpd82nmpyvEDz49yw88V75Y8prtCdn
	7LRKXTyu40SmxYC8hvjhCXK7KYQxrsh0Cpo60/S/O4ek1snDeKjXCK9kEVBHAlMs
	nyjy5sqyR5xXabhkOhlVqHhflWiJHyEuyeaRkOCXEgiQqofR5OqDgmhEiq6yUGXZ
	roabxG9HVFWOv2zHfptn4tD8H49FquyN41w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Z8FMDjAqQUy6; Thu, 12 Sep 2024 00:31:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X3yzK1x2lz6ClY9K;
	Thu, 12 Sep 2024 00:31:09 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/4] Clean up the UFS driver UIC code
Date: Wed, 11 Sep 2024 17:30:45 -0700
Message-ID: <20240912003102.3110110-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series includes four patches that modify the UFS driver UIC
code without modifying the behavior of that code.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v2 of this patch series:
 - Dropped patch "Change the approach for power change UIC commands".
 - Added patch "Make ufshcd_uic_cmd_compl() easier to analyze".

Changes compared to v1 of this patch series:
 - A patch that improves the struct ufs_hba documentation has been added.
 - Patch 2/2 has been split into two patches.
 - Instead of leaving the UIC completion interrupt enabled, disable it if
   UFSHCD_QUIRK_DISABLE_UIC_INTR_FOR_PWR_CMDS has been set.

Bart Van Assche (4):
  scsi: ufs: core: Improve the struct ufs_hba documentation
  scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier to read
  scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier to analyze
  scsi: ufs: core: Always initialize the UIC done completion

 drivers/ufs/core/ufshcd.c | 38 ++++++++++++++++++++------------------
 include/ufs/ufshcd.h      |  7 ++++---
 2 files changed, 24 insertions(+), 21 deletions(-)

