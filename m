Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C0B377ECF
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 21:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776461440; cv=none; b=thPGt62jxo/xS7sgh0eVWUPwbSNmCORgDqNMMLXGCVOv+hPJ4SicTM6D0KFoirVDNefxlqiIfEkzmqdGzzeIGmawWtQhct3a/ZGWdp0vG/z89rCrtptunS9T6gowIsDFkWPPE++9MlBcepJE5s14FvtbnbQcj9OUBkVpv/o9ivA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776461440; c=relaxed/simple;
	bh=3HmqTC0Cd2mnmkdsAd9V/pvZ45f3koolDrzuSFUe47I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T6RKPsj9vhOl+KmzzWsfm2VhgnTZmraZfFLeg8WH71S++vCWzyNXjt+4INaIN75Ib/wFPiiwlKERjH1td5r48a8Fsi90yS1xJuCvbqpbZnnraNSzyjX43CEm70kvhhzw+h5Y5jtYe4lIyEzXiEuVkKLosss+Ky5Nb47wGnmwpIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ryl9Uajt; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ryl9Uajt"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fy7My2XcDzlfl6P;
	Fri, 17 Apr 2026 21:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1776461436; x=1779053437; bh=otn4syaPBeGeyTg4fGthx1X5bnDDcahUh0R
	USf2Uw58=; b=ryl9UajtQ1wKNKI565oQbeYbAuXKtrfnjAl/AXxcOiTtqhH8qKF
	D6PStVtRrAjbb10EuzcLjii/j4GxiRrVySmJWoYTGayLFIO7W4H079qSitjNQ+Yj
	3foGsDmuMdrtKOB8mYBJXCVrmbkx8hYF2yEwM0EbeVzanHQcf7Y/G5WSG8IWuS9C
	JXi2fp8SI1qLw240DBpWprzEjBZE1ffOt0Y/CC7DZZH+P2NBRxO4i2XC3JHKL7gU
	JYaa/+91K36MY277LBYSDbDEiLeZkU89FT5CDfe7bjw51L7DYFhibJRXGKDyus2G
	jBwT0s65GLh7YCmnf7DHTCkiGYZt+MfPXnw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7_0m7LrmKhcs; Fri, 17 Apr 2026 21:30:36 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fy7Mw1K4mzlfl7l;
	Fri, 17 Apr 2026 21:30:35 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/3] ufs: core: Optimize the UIC command implementation
Date: Fri, 17 Apr 2026 14:30:19 -0700
Message-ID: <20260417213027.3506742-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series reduces the number of readl() calls while processing UI=
C
commands. Please consider this patch series for the next merge window.

Thanks,

Bart.

Bart Van Assche (3):
  ufs: core: Inline two functions related to UIC commands
  ufs: core: Complain if UIC argument 2 is invalid
  ufs: core: Optimize ufshcd_add_uic_command_trace()

 drivers/ufs/core/ufshcd.c | 49 +++++++--------------------------------
 1 file changed, 9 insertions(+), 40 deletions(-)

