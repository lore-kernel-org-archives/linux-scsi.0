Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C23234040A;
	Mon,  1 Jun 2026 21:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780347744; cv=none; b=kiGbeqnOdZj5GY+DrL7ZtoEGJE3ImLdXfIpMuoIQigfhqAxTec98651qR7MTo1oUZwRyDLRmnza4XZYb956hsBwHfCH/v+9XBuFtiPajsvZNolosLSNYH46DT4ikXdCSljSHG2meamJ/eBdmWPT9eJtZrONTmD8af+/y/VY04sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780347744; c=relaxed/simple;
	bh=dMRFXgKM0oAZJe5BUdnjNrY0AlMyzud095tJOfp/LrM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tMQYA2ZVH154Ze0QfkpswitLd8Lz6nB+Dn7YS53dI+OTp3FAvrT674vJ37dYO3mIuLAcohDfxXTd5sVqAXQR09hnAWtcxBlN9rKSiijNdEIs08ApkbtBbGiCMDj6wDMuwCyp9a3Mia+9oTe99RNwPD90+4NSm2VPvbdNRN6Tz+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m7cF1wVq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m7cF1wVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E231F0089B;
	Mon,  1 Jun 2026 21:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780347741;
	bh=dhHDzTaRt4tVRwXL1Kkjv1F0WaMgt+ak/RKZttErGyA=;
	h=From:To:Cc:Subject:Date;
	b=m7cF1wVq4j/uPeNA35GE8K/Ozo/nxTZxwfrePFL3LqOUmD7xbAN4RThf8xU/EVY/H
	 69tZPcvfptuh2P3zq2tAA32HwptDKYDmvtDp1GjhxGxik5KADabAOE1LbshOD/fBqm
	 MxFrmoH9ifDOtyAq8x7YD6JbqpnAoUR4gpXZI+MAzcRqNAErYnqcEsoe0BD1iGJLUJ
	 uUKQ/KFmmEv7VTddaqIChnsePFDkImuJlpdeWr5K2d/tDHyzlF451PgkTkbFPdH+/B
	 /q3mI5xtulX34AJlY4UdaFJWIW/jyqgKf2e+lYOWP5L6JXrFd5UIeT5hzUsbabJU+a
	 DPqeEPOByX/kw==
From: Arnd Bergmann <arnd@kernel.org>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <error27@gmail.com>,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: megaraid_mbox: avoid double kfree()
Date: Mon,  1 Jun 2026 23:02:04 +0200
Message-Id: <20260601210216.846809-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

Smatch found a double-free after my recent change:

	drivers/scsi/megaraid/megaraid_mbox.c:3474 megaraid_cmm_register()
	error: double free of 'adp' (line 3468)

Since the object is no longer allocated in megaraid_cmm_register(),
remove the kfree() as well.

Fixes: c1f7275b613b ("scsi: megaraid_mbox: Reduce stack usage in megaraid_cmm_register()")
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/megaraid/megaraid_mm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 60db48dc8f3a..e572665903d2 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -998,8 +998,6 @@ mraid_mm_register_adp(mraid_mmadp_t *adapter)
 
 	dma_pool_destroy(adapter->pthru_dma_pool);
 
-	kfree(adapter);
-
 	return rval;
 }
 
-- 
2.39.5

