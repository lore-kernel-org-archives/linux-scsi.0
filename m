Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52291898FB;
	Thu, 12 Dec 2024 22:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734041982; cv=none; b=T4RXlE2ncwaA7YByj29JBY3q6h3mHUKwd7XxEMy4p1rw/V5rK2pJ74LgzL/x+otYxmd08zWYkqxPrjWfTzp89euXlw2G3cmTAnw2xe4bbcxam2Xkh5KHc6SjCct6IsirMIUO5fku7SQuQiskYm7F6I/vZGaFEhQ5DImbDJBtJPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734041982; c=relaxed/simple;
	bh=Qeg6OJQQ6kun3/JAf5Pb3BaIG7UVY+QE1ngviEjCeNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uduh1SPrVSndLGdpJ+MyoQnnO7rxV/CkJw44CvICGfb6gV6kPbeSrfH+Tmp0LPAlcY7S+zRsHWws7fpIuLRleN5QltkQ/dmbdRkpSwHzr7kr4jHTuVxzGthlaRLnZh/ueUJN2vg5m9/Vg+7nGFpbZJorAZtU1YKSM6SNzQJwFRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from localhost.localdomain (unknown [95.90.243.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id E616561E64783;
	Thu, 12 Dec 2024 23:18:30 +0100 (CET)
From: Paul Menzel <pmenzel@molgen.mpg.de>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <JBottomley@Parallels.com>,
	Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>,
	Sreekanth Reddy <Sreekanth.Reddy@lsi.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] scsi: mpt3sas: Set ioc->manu_pg11.EEDPTagMode directly to 1
Date: Thu, 12 Dec 2024 23:18:12 +0100
Message-ID: <20241212221817.78940-2-pmenzel@molgen.mpg.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241212221817.78940-1-pmenzel@molgen.mpg.de>
References: <20241212221817.78940-1-pmenzel@molgen.mpg.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, the code does:

    if (x == 0) {
    	x &= ~0x3;
	x |= 0x1;
    }

Zeroing bits 0 and 1 of a variable that is 0 is not necessary. So
directly set the variable to 1.

Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 87fcafce947c..2cd0bb606d88 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5629,8 +5629,7 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 	if (!ioc->is_gen35_ioc && ioc->manu_pg11.EEDPTagMode == 0) {
 		pr_err("%s: overriding NVDATA EEDPTagMode setting from 0 to 1.\n",
 		    ioc->name);
-		ioc->manu_pg11.EEDPTagMode &= ~0x3;
-		ioc->manu_pg11.EEDPTagMode |= 0x1;
+		ioc->manu_pg11.EEDPTagMode = 0x1;
 		mpt3sas_config_set_manufacturing_pg11(ioc, &mpi_reply,
 		    &ioc->manu_pg11);
 	}
-- 
2.45.2

