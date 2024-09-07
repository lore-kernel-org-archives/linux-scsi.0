Received: from smtp.smtpout.orange.fr (smtp-30.smtpout.orange.fr [80.12.242.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7928537F5;
	Sat,  7 Sep 2024 06:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725691000; cv=none; b=uLJwSuncSW0wmOZk5ueRWvzLbCPPxqqZ033IrxyLTF60GCAoSvwauECnjonVHwa6gWTnFmfbTYztSnGAzfOoiPxe0dOQqTYD0z5fw90fCqA9VAfM0Ek3+xZwkmGZR3h66UAUS51/StQMWJa6O1Cwr4YRfdFtObYORclAcFbPn24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725691000; c=relaxed/simple;
	bh=S8uBneI7PpV05fm7xVEpV7bYxOY1zUNfKM8lVvwCKyw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Cx7B1we06j5ztNupUh/wtOSVpjVeGsoPhQkLqIiF1KQAh7yTT7OfFRorW1xQx8mw3/RZTcAB/Rv/BQRG9m6XbB9KlmtcG7JdBBziDV64RgXPrvwgcjCUSY+1RQIyV6Q+cgVGdOJH6q1G0BDzK66d4MA9ygXIW0YEiIUOPdhd5Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=tIVan0CG; arc=none smtp.client-ip=80.12.242.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="tIVan0CG"
Received: from fedora.home ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id mouss9ADDJokxmousseWhW; Sat, 07 Sep 2024 08:27:28 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1725690448;
	bh=UXFZxJayFVmRBjL/YPnjN27oAjTntbi+iSfWBhiI8ug=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=tIVan0CGAvSAm6oQdCCvHTvobKSxinMOQ5ciJwly1/qJ1aO6rcgyzEOI3/0qg6aVC
	 HMejnHSYGV+20xtw7WnnN6/02QMsU6m/7r5Ns7PslzvH6vJOUaNzn1HZhxm2ZXlxJ5
	 PaVi0PoCMQ6baUq5jsq5SjZqDh1P91t1/idnIdfqp8dmHPPWCIlKeoI9yFPBXjcq5Y
	 Sgs0ToJpwGptReAdqhbt1Xu/WKpG12Dohwd7N6YFANC1msStX2bQsd9qlbxTDtJ4nQ
	 Nd9PhCgIk/5XO/jTcpiMhlWA5+Rd73WscZAyVNHHwG2hJ5PM9Y7qKyKcm7flYwqs2M
	 eczI/V/b3TuMQ==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 07 Sep 2024 08:27:28 +0200
X-ME-IP: 90.11.132.44
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: scsi_debug: Remove a useless memset()
Date: Sat,  7 Sep 2024 08:27:22 +0200
Message-ID: <6296722174e39a51cac74b7fc68b0d75bd0db2a3.1725690433.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'arr' is kzalloc()'ed, so there is no need to call memset(.., 0, ...) on
it. It is already cleared.

This is a follow up of commit b952eb270df3 ("scsi: scsi_debug: Allocate the
MODE SENSE response from the heap").

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/scsi_debug.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a9d8a9c62663..d95f417e24c0 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2760,7 +2760,6 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	else
 		bd_len = 0;
 	alloc_len = msense_6 ? cmd[4] : get_unaligned_be16(cmd + 7);
-	memset(arr, 0, SDEBUG_MAX_MSENSE_SZ);
 	if (0x3 == pcontrol) {  /* Saving values not supported */
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, SAVING_PARAMS_UNSUP, 0);
 		return check_condition_result;
-- 
2.46.0

