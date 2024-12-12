Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C9D1898FB;
	Thu, 12 Dec 2024 22:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734041932; cv=none; b=MqJh6djmWNtXorLxvhr2E4U4Uls12ZKiQaaTLaFDNqNJHc3DThLjGrDBlnMbcFXyBGv3gBN9ltMs8JnmaUYmJHDEpK22YItz1iNkp9aLb3o8VbPA47gmE4N12j/zxHhaEHSXP8E3E1+psszrr9Gvl3YLm11wrmZtsPQvwU3f5lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734041932; c=relaxed/simple;
	bh=sZfmLxjjAk+fSgpJKFvlCso0AgsEIDWxkc/IsHfSgqM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OnK/ELqY7+zSRKrJv68O8xbA0M2NWtxmHD7hHShwh4+HG5YlM+kw6faTRwekCd66OmMgQVY5V4VXDlu9S4EiIN1xaY04ZfF61CNmkha4z3moGGITeza6yQsCWwNbvDE6yabzU0jc1wyJ1L946Sjbx11nY0+1E40jPhEHjk1/Pos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from localhost.localdomain (unknown [95.90.243.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id CD2E561E646F9;
	Thu, 12 Dec 2024 23:18:26 +0100 (CET)
From: Paul Menzel <pmenzel@molgen.mpg.de>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] scsi: mpt3sas: Add details to EEDPTagMode error message
Date: Thu, 12 Dec 2024 23:18:11 +0100
Message-ID: <20241212221817.78940-1-pmenzel@molgen.mpg.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Linux 5.15 logs the error below

    mpt3sas_cm0: overriding NVDATA EEDPTagMode setting

on a Dell PowerEdge T440 with the card below.

    5e:00.0 Serial Attached SCSI controller [0107]: Broadcom / LSI SAS3008 PCI-Express Fusion-MPT SAS-3 [1000:0097] (rev 02)

It’s not clear to a user what this error is about. As a first step to
improve this, add the values to the error message.

Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index ed5046593fda..87fcafce947c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5627,7 +5627,7 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 	if (rc)
 		return rc;
 	if (!ioc->is_gen35_ioc && ioc->manu_pg11.EEDPTagMode == 0) {
-		pr_err("%s: overriding NVDATA EEDPTagMode setting\n",
+		pr_err("%s: overriding NVDATA EEDPTagMode setting from 0 to 1.\n",
 		    ioc->name);
 		ioc->manu_pg11.EEDPTagMode &= ~0x3;
 		ioc->manu_pg11.EEDPTagMode |= 0x1;
-- 
2.45.2

