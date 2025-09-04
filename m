Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AFED1A9F82;
	Thu,  4 Sep 2025 09:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756978589; cv=none; b=cntpiGgKudILhGEdR/ocoNEMemFYUHiDjfhgxDrwBcY2UqGRWAY1j7AQh5XfNAn+U9obX8QoOgfFAno/PhiMkK4kcDVLebTJePtl4mX4NKUDMIGbSFWCXQQF5bE6BpIr4uvE+CFmmgYH8tTrG8o6sikzn6pA3dksbrD/LWHlpKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756978589; c=relaxed/simple;
	bh=DcicNNUfFZKj/Yr+O+tHFbD8gezJ6gELfrIdlSYHVeY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t3wCExuqPOmicLSHkqWfZbrGSi7EUQJHmeFgov5Vk4MSCUAwgRrOEaokDd/vVyVu1uodjiJz6yYQ/eeYAUfQ6JB7bDBlux0I+kySms7V4o6S3U9pu79iKMVTNDam0KyAmwJMlf8UTgsyxN6z/8luHNn4TcvQ5NvN+KosM9OmmJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=WtsHWGYY; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="WtsHWGYY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=fJ
	bLh6waA+QrGunKjnxkbrkEAjiU744DKZaf6sYLl2M=; b=WtsHWGYYedINvrPyra
	+c2WHl1uU2g1Gm0DMiuqw5iETRXFdNGON51o471PHnFFvVY/GPaJpmLuCaufl8KU
	IeQzPx/ftIM1I6HJobUY3uiAGkbdvSzjHLEy20ZqpFn4xuyxEs3ylYt/JrdZkzy/
	r912aG3lkPkoL0MT34S0r7lNI=
Received: from neo-TianYi510Pro-15ICK.. (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wDXz3yEXbloOb6fGg--.11019S2;
	Thu, 04 Sep 2025 17:36:07 +0800 (CST)
From: liuqiangneo@163.com
To: anil.gurumurthy@qlogic.com,
	sudarsana.kalluru@qlogic.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qiang Liu <liuqiang@kylinos.cn>
Subject: [PATCH] [SCSI] bfa: Remove self-assignment code
Date: Thu,  4 Sep 2025 17:35:58 +0800
Message-ID: <20250904093600.175762-1-liuqiangneo@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXz3yEXbloOb6fGg--.11019S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr4Utr4kJF1fKry7Aw45trb_yoWfAwb_Kr
	WvqFWxuw10yw47Gw18Wr1I9Fy2vry7Gr4kurn2qFyfCayIqFn5Jr1DZrZxZ3W8GF4DKF97
	Xayxtr10v348JjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1gyZUUUUUU==
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/1tbiXwe+YWi5VRf9IAAAsJ

From: Qiang Liu <liuqiang@kylinos.cn>

The variable num_cqs is of type u8 and does not require be16_to_cpu
conversion, so the redundant  code is removed.

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
---
 drivers/scsi/bfa/bfa_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index a99a101b95ef..2559df8baa05 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -1282,7 +1282,6 @@ bfa_iocfc_cfgrsp(struct bfa_s *bfa)
 	struct bfi_iocfc_cfgrsp_s	*cfgrsp	 = iocfc->cfgrsp;
 	struct bfa_iocfc_fwcfg_s	*fwcfg	 = &cfgrsp->fwcfg;
 
-	fwcfg->num_cqs	      = fwcfg->num_cqs;
 	fwcfg->num_ioim_reqs  = be16_to_cpu(fwcfg->num_ioim_reqs);
 	fwcfg->num_fwtio_reqs = be16_to_cpu(fwcfg->num_fwtio_reqs);
 	fwcfg->num_tskim_reqs = be16_to_cpu(fwcfg->num_tskim_reqs);
-- 
2.43.0

