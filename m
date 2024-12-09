Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4B8153814;
	Mon,  9 Dec 2024 17:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733763832; cv=none; b=FeMaD4zpM3fiJ6aUcJ9SGXSGfm3uNaIYbcPDt92SgSvZ+nAaJ3gFsNpNTNuiAHptyz4+i7xYcOm2bKrtfvIndquqx5OufK2RbWj/RMsEmtLZyOxfEXbKlsS89quqlKWYsDIKKe9OIHSet6KrufDkB96P8AKBjoSTeJk8Ly9fmKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733763832; c=relaxed/simple;
	bh=pDMotxxAEfmtrMG6MLfN/X4Rpw+KCwDjiko2Kn3T9xQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ECDhsNznOiFPISu2Fik+d97O5jAAOfknY3zmX8qqgVEvfBzRbU/lRovcVruyNySADES/A8Sqqt/la6W6wolC6NX5c4YvJNLaLNhJ77LnPS4aWqenC/59ovMjFvJ6wN+S5xwePDZm1V0GXYEV+io6jmdQMLw+PUtQX6ZMa4PlcDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.ipa.basealt.ru (unknown [178.76.204.78])
	by air.basealt.ru (Postfix) with ESMTPSA id 27C48233BE;
	Mon,  9 Dec 2024 20:03:48 +0300 (MSK)
From: Vasiliy Kovalev <kovalev@altlinux.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <jejb@linux.ibm.com>,
	Damien Le Moal <damien.lemoal@wdc.com>,
	linux-scsi@vger.kernel.org,
	lvc-project@linuxtesting.org,
	kovalev@altlinux.org,
	nickel@altlinux.org,
	gerben@altlinux.org,
	dutyrok@altlinux.org
Subject: [PATCH 5.10.y 3/3] scsi: sd: Fix sd_do_mode_sense() buffer length handling
Date: Mon,  9 Dec 2024 20:03:30 +0300
Message-Id: <20241209170330.113179-4-kovalev@altlinux.org>
X-Mailer: git-send-email 2.33.8
In-Reply-To: <20241209170330.113179-1-kovalev@altlinux.org>
References: <20241209170330.113179-1-kovalev@altlinux.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <damien.lemoal@wdc.com>

commit c749301ebee82eb5e97dec14b6ab31a4aabe37a6 upstream.

For devices that explicitly asked for MODE SENSE(10) use, make sure that
scsi_mode_sense() is called with a buffer of at least 8 bytes so that the
sense header fits.

Link: https://lore.kernel.org/r/20210820070255.682775-4-damien.lemoal@wdc.com
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
---
 drivers/scsi/sd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f2dfd9853d3432..2f2ca287887603 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2649,6 +2649,13 @@ sd_do_mode_sense(struct scsi_disk *sdkp, int dbd, int modepage,
 		 unsigned char *buffer, int len, struct scsi_mode_data *data,
 		 struct scsi_sense_hdr *sshdr)
 {
+	/*
+	 * If we must use MODE SENSE(10), make sure that the buffer length
+	 * is at least 8 bytes so that the mode sense header fits.
+	 */
+	if (sdkp->device->use_10_for_ms && len < 8)
+		len = 8;
+
 	return scsi_mode_sense(sdkp->device, dbd, modepage, buffer, len,
 			       SD_TIMEOUT, sdkp->max_retries, data,
 			       sshdr);
-- 
2.33.8

