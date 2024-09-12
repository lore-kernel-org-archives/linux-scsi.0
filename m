Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABC91C32E4
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 22:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726180236; cv=none; b=BxYxqlr+Z4kAXoms2z5eT4dY12088Rjy9Zso9xh4Th17z0lThO+xZ4S8jBfglF3y9BSAIlvnK/c2pH5BazGx5XXzAagVVMnhtCQYvg4WpAqdYTBd/Rj8uJE+uGrdRbY01wQ50I2tw7BXEmZbCDhhA/yMtyAzVv9SdWPY1tgG2zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726180236; c=relaxed/simple;
	bh=LFjvKFnE4HkoAuCP7brnB+MY6stxPPZ5n1/nxvFHJf0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oYyq2IVDnXDMeksgupogfenPm+IGflmGy6ikY4kZQ5ivPUrvVjPschIvBCaVgGX/FpEKRBmF9fQBewQMJOcM/O/L1Y5sMPZXfKfjXRtwZXCtpsexi5o58p5e6TRsKtcMgyQ994LVMYtNqvF/GDbORo4iSLKiooaK1dk+sz9knzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=J3SORNH4; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="J3SORNH4"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X4XFk5S4Qz6ClY9d;
	Thu, 12 Sep 2024 22:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1726180232; x=1728772233; bh=JgvpWC+JW5nk8tgE77pWQZ+t3CSReGSyb9w
	O7rfeEt8=; b=J3SORNH47kAcx47ush39uVuMs5Y2XacIJLodualR5AqfbRLbG/J
	IrijtCa2h/Ie7ZcirKchXrT9b1w8OMeWRxbCQFM//cJjyNJ0OQ/FVwBISs/97Y5/
	FSaUvNSzwEUdsoBqPknzgJvMO9OkTb/V43I+xA8IEFcOzHtyUXm/jYSDVi+Ywq/L
	cPDMaDGV3GhXXrs4/SHjdUGJ60KDb/uhJaxFyR89TtI0MwUQNTiI+cV+K1BgE+qQ
	L2PkvEMrouX6FNGpImXbIMKLivaWyIZrCA5gSPGQVXEzgwFMTK0jW1MZmP5Dhc0P
	YInws+OTmri1bS+zMngsG8zNmqSdoncO6ZQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FiLVCVKd3Ehr; Thu, 12 Sep 2024 22:30:32 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X4XFh3rzbz6ClY9R;
	Thu, 12 Sep 2024 22:30:32 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 0/4] Clean up the UFS driver UIC code
Date: Thu, 12 Sep 2024 15:30:01 -0700
Message-ID: <20240912223019.3510966-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
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

Changes compared to v3 of this patch series:
 - Added a WARN_ON_ONCE() call.

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

