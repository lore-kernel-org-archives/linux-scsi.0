Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDD71494DF;
	Mon,  9 Dec 2024 17:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733763830; cv=none; b=Dg05gO8q6FvHbqWDxsuCde5vrQet1XraFDfy/071Daxcn77VaYUaWO6b6EBoACOMs+7uWHtT8WTjQRq+XyfKr7fEi1J+aIjsaJOf/dJbOT/kSAKtNiLsX49PPl2nxpCb7rbWpL7TGDXFhlQrwhWBpDjgBIOsXwUHA3Mt/X/2NPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733763830; c=relaxed/simple;
	bh=wDecW75NcTiJZUzJAILHL8g1YoTibEFXYZY1BnW6o48=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BEwky1Pu1cxXPMVO6OBo1eEXlSq3dXz8PcFOmAyt3MqhwyRqjcKAQI65YnUxosiCuvzOoAxRhXzN0ynVyasRiHSrJqfnP8QM/0Tyb8xuW4C8FDWFX+9kWZz8nCbr1ij5F7UzpUQYL/qrxTp9n6159pgNGWdkjrn71Msz8YJMeH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.ipa.basealt.ru (unknown [178.76.204.78])
	by air.basealt.ru (Postfix) with ESMTPSA id B17212333A;
	Mon,  9 Dec 2024 20:03:43 +0300 (MSK)
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
Subject: [PATCH v2 5.10.y 0/3] scsi: Backport fixes for CVE-2021-47182
Date: Mon,  9 Dec 2024 20:03:27 +0300
Message-Id: <20241209170330.113179-1-kovalev@altlinux.org>
X-Mailer: git-send-email 2.33.8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The patch titled "scsi: core: Fix scsi_mode_sense() buffer length handling"
addresses CVE-2021-47182, fixing the following issues in `scsi_mode_sense()`
buffer length handling:  

1. Incorrect handling of the allocation length field in the MODE SENSE(10)
   command, causing truncation of buffer lengths larger than 255 bytes.  

2. Memory corruption when handling small buffer lengths due to lack of proper
   validation.  

CVE announcement in linux-cve-announce:  
https://lore.kernel.org/linux-cve-announce/2024041032-CVE-2021-47182-377e@gregkh/  
Fixed versions:  
- Fixed in 5.15.5 with commit e15de347faf4  
- Fixed in 5.16 with commit 17b49bcbf835  

Official CVE entry:  
https://cve.org/CVERecord/?id=CVE-2021-47182

---
v2: To ensure consistency and completeness of the fixes, this backport
includes all 3 patches from the series [1].
In addition to the first patch that addresses the CVE, the second and
third patches are included, which prevent further regressions and align
with the fixes already backported and proposed for backporting [2] to
the stable 5.15 kernel.

[1] https://lore.kernel.org/all/20210820070255.682775-1-damien.lemoal@wdc.com/
[2] https://lore.kernel.org/all/20241209165340.112862-1-kovalev@altlinux.org/

[PATCH 5.10.y 1/3] scsi: core: Fix scsi_mode_sense() buffer length handling
[PATCH 5.10.y 2/3] scsi: core: Fix scsi_mode_select() buffer length handling
[PATCH 5.10.y 3/3] scsi: sd: Fix sd_do_mode_sense() buffer length handling

