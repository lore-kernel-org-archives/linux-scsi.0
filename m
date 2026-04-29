Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C0C2F745C;
	Wed, 29 Apr 2026 15:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777475798; cv=none; b=Ro5QzPmKhT9OCnQmN696ZAYREgMB+aLnAI0N+mMta+t4FY48pDTQ5ODEJTi9Igm6p5ex97o0jKZZIyg4cIWtz5/2JfmBsqykJlFgQWR5meakYiSLIPVCixl4649MoEKdxay9tvtQNJvXim5a+1EuMPtaqgXtnSShhUXmdJXb/Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777475798; c=relaxed/simple;
	bh=hDm09YBYrAz6Ma5GI1suFLSOqs30AeX8Z5+RgIebBbY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=m2BfNQ8rdvxnCc+7utpVcZBYQi8Md2UBFHnP8OgtVznO65ehXu4bced5hr6aqLps9lNkkZfZIRCefHX0ihnF2c9Nhq1Jb7xxOTpvHAJjKrQXiDQbr/ik0JZ3rHJFDhdu+w9sOV3zFe2dj/PbhV8Ekb9DsWy6ZDAVpgP5MTctyZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kjaYYV3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kjaYYV3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6924C2BCB8;
	Wed, 29 Apr 2026 15:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777475797;
	bh=hDm09YBYrAz6Ma5GI1suFLSOqs30AeX8Z5+RgIebBbY=;
	h=From:To:Cc:Subject:Date:From;
	b=kjaYYV3kdG0UT4lwZ83UTsKMhrkx6wo7QlCdtAcytYMU2gqPnyB2b1xoqoW5wfXFD
	 aGzC6sUhThA5J70uD1Y/30tSr0Dq0aAvw5g2SyBSATAMjrq8dSkVFe695JilgiDiRw
	 6dGtAomtHnf6CME390YW39JOjQqm2F9yAzKzl3c4oTGl5pqS2btN7vPdMYuQ2Ou0lf
	 5Bmx8TZBi21RONsCiB+Ngc6w9Kz/eehHwPA5cx9YQuNP4/g7leHC5uY5ZwqlvqmMzK
	 TbTOQoImFACJ1tQKWqZr6sNpKTkHmuNVNASkXPa2fWNI5AqQ+0a+Fzrwc+NiCdYxcH
	 ssuloN5FK9VGA==
From: Arnd Bergmann <arnd@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Hannes Reinecke <hare@suse.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	John Garry <john.g.garry@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: advansys: drop ISA_DMA_API remnants
Date: Wed, 29 Apr 2026 17:15:37 +0200
Message-Id: <20260429151623.3899875-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

Support for ISA bus mastering was removed a few years ago, and the VLB
mode does not use the ISA DMA API, so drop the dependency and the
header inclusion.

Fixes: 9b4c8eaa68d0 ("advansys: remove ISA support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
There are only a couple of ISA_DMA_API users remaining in the tree
after the ethernet driver spring cleaning, so I noticed this one.

There is now only one SCSI driver remaining that uses ISA DMA,
the aha1542 ISA support, which is also the only ISA DMA bus master
driver in the tree now
---
 drivers/scsi/Kconfig    | 1 -
 drivers/scsi/advansys.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index fc8e8b0bfa39..c3042393af23 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -474,7 +474,6 @@ config SCSI_ADVANSYS
 	tristate "AdvanSys SCSI support"
 	depends on SCSI
 	depends on (ISA || EISA || PCI) && HAS_IOPORT
-	depends on ISA_DMA_API || !ISA
 	help
 	  This is a driver for all SCSI host adapters manufactured by
 	  AdvanSys. It is documented in the kernel source in
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index fcf059bf41e8..5cdbf2bdb13d 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -36,7 +36,6 @@
 #include <linux/dmapool.h>
 
 #include <asm/io.h>
-#include <asm/dma.h>
 
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
-- 
2.39.5

