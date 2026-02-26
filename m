Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF930368953;
	Thu, 26 Feb 2026 17:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772126021; cv=none; b=N9OwF08woSvXoYPw1SD8vvRjogyMLxDvYzF8XmemtfyGmw3yeNfJVnyKxWCL10mAhHHQ4gypiRkxKyyna1nZ5yyNRprl0Ij6XBQGREvtOx7r/8apGKdq+GlHEbpjE4VkbLjbmJ7mN7X4jDxXO/DKwnmsKPVahjmM4ZxJcFndDlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772126021; c=relaxed/simple;
	bh=b7Byh7AKmIrPB6JnsHWQxCom1SBCJiTuJvCA4ZoANxU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sI+0aNGFOIG6JVdsaYKTVHuP6YFRvPfHTrCLz0Why+wOyZwKhWAza4zfbJ4iLjrXWhmF+/JmjDH/tPrS6q1ulBLlZPbE9WLwmI5U7xX8CP5yAMF8Toe8RAZS1ch3dh17wI1OJ0ULues/GvxZJsvehdQPzD+x4Rghlb/Kw2gz5UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=os8x+1Li; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="os8x+1Li"
Received: from VelichayshiyPC.Dlink (unknown [178.69.152.134])
	by mail.ispras.ru (Postfix) with ESMTPSA id 35E23407617A;
	Thu, 26 Feb 2026 17:13:29 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 35E23407617A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1772126009;
	bh=/GZydmRwpoky6IbFYodD1KRJPAHPKTTbYzddIMSkiiY=;
	h=From:To:Cc:Subject:Date:From;
	b=os8x+1LiGigSPG/omStujELOqHYhM5IW9ZkbAgeHKRoR7VK3sTFZW5u5nGUsw/GiI
	 tJrVH5EyQClCBz6WA5M+B9GBdYfAIWA0FQfCwcBdHbnv4Dte/BR0GM7kqEOvve6oCq
	 JFJLELd3biw53ASRSSDV2kTYlEAbVAe4AjCFonZU=
From: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
To: a.velichayshiy@ispras.ru,
	Don Brace <don.brace@microchip.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kevin Barnett <kevin.barnett@microsemi.com>,
	Scott Benesh <scott.benesh@microsemi.com>,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH] scsi: smartpqi: add safety checks for RAID 50/60 stripe size value
Date: Thu, 26 Feb 2026 20:11:46 +0300
Message-ID: <20260226171205.353635-1-a.velichayshiy@ispras.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add zero check for 'rmd->layout_map_count' and overflow check when
computing 'rmd->stripesize' as the product of 'rmd->blocks_per_row' and
'rmd->layout_map_count'. Using the check_mul_overflow() macro prevents
potential overflow of a 32-bit type, which could produce incorrect data in
subsequent calculations, including division-by-zero errors.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 6c223761eb54 ("smartpqi: initial commit of Microsemi smartpqi driver")
Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index fe549e2b7c94..42c2c137a819 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2824,12 +2824,14 @@ static int pqi_calc_aio_r5_or_r6(struct pqi_scsi_dev_raid_map_data *rmd,
 	u64 tmpdiv;
 #endif
 
-	if (rmd->blocks_per_row == 0) /* Used as a divisor in many calculations */
+	/* Used as a divisors in many calculations */
+	if (rmd->blocks_per_row == 0 || rmd->layout_map_count == 0)
 		return PQI_RAID_BYPASS_INELIGIBLE;
 
 	/* RAID 50/60 */
 	/* Verify first and last block are in same RAID group. */
-	rmd->stripesize = rmd->blocks_per_row * rmd->layout_map_count;
+	if (check_mul_overflow(rmd->blocks_per_row, rmd->layout_map_count, &rmd->stripesize))
+		return PQI_RAID_BYPASS_INELIGIBLE;
 #if BITS_PER_LONG == 32
 	tmpdiv = rmd->first_block;
 	rmd->first_group = do_div(tmpdiv, rmd->stripesize);
-- 
2.43.0

