Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3AB645;
	Sun, 26 Jan 2025 06:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737874092; cv=none; b=hUilLWK0z4Ytb3sGzHIpMlTa46sIA9BkVj2C7+vJYLB6zBW/CccM14oqhM0AdTMwIz9fK7oqh/SQqbYKganpiSV5PJM02aY0gUnnfTM8mAzNb7V+Vyuhc0mNiy24YZA9C0KrQErM4/V2P5M2cuEgpnemqwxUNCR5V7/2B3AYmdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737874092; c=relaxed/simple;
	bh=4DUMo8e/XQ0mx+hk8lW0mkpgwBRZJpCqwRTQj70WPLI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=heghZKWaeAREWfu8TacMwpB/q5o3wRybp3oN91EAy04IOkbzaI/DktyMF9O+tgXMb732cqT9A8HUPA5+ztbB1TbZQKsBK55H0wDYffgEyLu61HUYAB316/jEkGfznpv9HS+hM7lYQvdgT4mwxUjnhrq/wq80db2SHZCx3ZXy+1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=dvQowER1; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dvQowER1"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737874090; x=1769410090;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4DUMo8e/XQ0mx+hk8lW0mkpgwBRZJpCqwRTQj70WPLI=;
  b=dvQowER1RXKzlRT0WckjM9W7xpyfzyY+CA2wBFfScKJvDPgbZojFkweD
   WJpw8GnTei/7BqzVtBoHBFAGg4bH3S3oOQKf+KSOlxig2QlHejFLBzPAF
   ByX34WWR0adZjxJPgVKc3wIgaqwTO3A1srxCEvFe3OZaJ6+P6Wut/49zx
   FHaQQXUnDYiAG/S1n9Mt34Z5a9krjeihKbyZunnuyoPjC9loa5xHyeCwh
   mK6cdpFegdaUVO8SdrIs9B/dgIzqUUSjxcUvDPO3z48Wz0GndsLuCBeS7
   35JJ6B1lx3nw0BFcjuAYW0u7Mjt/6wZZ8lrMZ078PHCyF2jL1St1TFeWn
   A==;
X-CSE-ConnectionGUID: BC8wUdE4T1KfS1lGAEqTlQ==
X-CSE-MsgGUID: E9P17xtFTsKwBiUO5ttYrQ==
X-IronPort-AV: E=Sophos;i="6.13,235,1732550400"; 
   d="scan'208";a="37344155"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jan 2025 14:48:09 +0800
IronPort-SDR: 6795cd0d_Sd4Cc9TL9TTax/sKvPysj9viTivG8FsakGP9vt1inCeA/d0
 HRUkfZ9by4S25gOj6qrjgplX+Ar4t+ayGr7zUOw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Jan 2025 21:50:06 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Jan 2025 22:48:08 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 0/2] Fixes for UFS clock gating initialization
Date: Sun, 26 Jan 2025 08:45:19 +0200
Message-Id: <20250126064521.3857557-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Martin hi,

This patch series addresses two issues related to the UFS clock gating
mechanism. The first patch ensures that the `clk_gating.lock` is used
only after it has been properly initialized.

The second patch fixes an issue where `clk_gating.state` is toggled even
if clock gating is not allowed, which can lead to crashes.

Changes since v2:
 - Add patch #2 (Geert)
 - Initialize clk_gating.lock unconditionally (Bart)

Changes since v1:
 - move the spin_lock_init(&hba->clk_gating.lock) call from
   ufshcd_init_clk_gating() just before the ufshcd_hba_init() call in
   ufshcd_init() (Bart)

Avri Altman (2):
  scsi: ufs: core: Ensure clk_gating.lock is used only after
    initialization
  scsi: ufs: Fix toggling of clk_gating.state when clock gating is not
    allowed

 drivers/ufs/core/ufshcd.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

-- 
2.25.1

