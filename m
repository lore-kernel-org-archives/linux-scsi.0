Received: from smtp.eurecom.fr (smtp.eurecom.fr [193.55.113.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80AE1A8F9C
	for <linux-scsi@vger.kernel.org>; Fri, 13 Dec 2024 23:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.55.113.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734130818; cv=none; b=BRyRpygCv2/UsGwC7ifoQQUQ+QXmviT+3VHfbs9PSRC4hRZwEVIRDgNI8aVZxKrGzvdB23asUV69543iyGZm/WJSUg6L3DrlviJCiadm47jl6ATK/TNsTvrqn3SOR1WGqTEFe9tzVLMmhFEIXCpOhHJidf0W2NHm75QtEB8dINk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734130818; c=relaxed/simple;
	bh=NdhWejI8xQAV/WGum03aynETYQWy4/5YWf3BRE/On0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tERoKtm8OlaCCoIOvCZvSHYOgtuipfAnJ4YnM+jimnBf2V6/1legUxcM4I9J2HzEW7FvWXiiPMrTx4RptRiaXfOImPrU9IsuRzbNkIbpgJg4wC4Er9/pAENteWVY7GM2a/gUaqrUT+kew7cdzfzLztbGYIAskqWszYtERA0CvXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eurecom.fr; spf=pass smtp.mailfrom=eurecom.fr; dkim=pass (1024-bit key) header.d=eurecom.fr header.i=@eurecom.fr header.b=ucG9K0No; arc=none smtp.client-ip=193.55.113.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eurecom.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eurecom.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=eurecom.fr header.i=@eurecom.fr header.b="ucG9K0No"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=eurecom.fr; i=@eurecom.fr; q=dns/txt; s=default;
  t=1734130815; x=1765666815;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NdhWejI8xQAV/WGum03aynETYQWy4/5YWf3BRE/On0Q=;
  b=ucG9K0NoA6p6oX7bIud5Jfr1qwgM0p+Xm+U7i8rD0yZPLUlATtwqVz6W
   Jvv5lB0iBOrcf8Ss0eM73rUM3rWe4G03WEw/V0wMuHPxtDhZGwtXPWsv7
   J18mumeifXLYOIkcg0C4/1bsK79OiOhFZzSzzmP2EYCopxY/zzh4dkhbo
   I=;
X-CSE-ConnectionGUID: AylprzwASYuHzttJjQZREg==
X-CSE-MsgGUID: OWOKxpq+TwqGhdEA7oqHcw==
X-IronPort-AV: E=Sophos;i="6.12,232,1728943200"; 
   d="scan'208";a="28179946"
Received: from waha.eurecom.fr (HELO smtps.eurecom.fr) ([10.3.2.236])
  by drago1i.eurecom.fr with ESMTP; 14 Dec 2024 00:00:14 +0100
Received: from localhost.localdomain (88-183-119-157.subs.proxad.net [88.183.119.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtps.eurecom.fr (Postfix) with ESMTPSA id 44F482C19;
	Sat, 14 Dec 2024 00:00:14 +0100 (CET)
From: Ariel Otilibili <ariel.otilibili-anieli@eurecom.fr>
To: linux-scsi@vger.kernel.org
Cc: Ariel Otilibili <ariel.otilibili-anieli@eurecom.fr>,
	Hannes Reinecke <hare@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/1] drivers/scsi: remove dead code
Date: Fri, 13 Dec 2024 23:57:29 +0100
Message-ID: <20241213225852.62741-2-ariel.otilibili-anieli@eurecom.fr>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241213225852.62741-1-ariel.otilibili-anieli@eurecom.fr>
References: <20241213225852.62741-1-ariel.otilibili-anieli@eurecom.fr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

* reported by Coverity ID 1602240
* ldev_info is always true, therefore the branch statement is never called.

Fixes: 081ff398c56cc ("scsi: myrb: Add Mylex RAID controller (block interface)")
Cc: Hannes Reinecke <hare@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: Ariel Otilibili <ariel.otilibili-anieli@eurecom.fr>
---
 drivers/scsi/myrb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 363d71189cfe..dc4bd422b601 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1627,8 +1627,6 @@ static int myrb_ldev_sdev_init(struct scsi_device *sdev)
 	enum raid_level level;
 
 	ldev_info = cb->ldev_info_buf + ldev_num;
-	if (!ldev_info)
-		return -ENXIO;
 
 	sdev->hostdata = kzalloc(sizeof(*ldev_info), GFP_KERNEL);
 	if (!sdev->hostdata)
-- 
2.47.1

