Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284EE190073;
	Wed, 25 Sep 2024 12:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727266568; cv=none; b=oQU+WaO/y9uw9jau2lEMh4A4wm/wn7CRq5vENe3fe1GBA43zYd0O0GdVslbAI7MDaWhc9I82crvvfO0zMpaLwUDbmvqfBMESCy0ZIWDOtWTSe34Om/NNlm7/ksrm5rF7/8Rvzw8oaBb1jzbMKxHmYGOgF2LL2f/b/EsKzLPfv/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727266568; c=relaxed/simple;
	bh=TlX0taoMF24AJh7bkV3o20uw/wE8d2sqob15TW/2epI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUxOmxRFxyWu7p4z14nMEBebUfV29K8IobrTRV7XzOh5oQHDZmyucs55vzEfBAetu3x8Fhm7ujx3YXDGoLbN5pLJiLEbKNftBvvGNkfKK+QSycc4LYKwigccEm9X+YZUfevbgLWhiInAb6E8BMhDBn6UpaNLvIz+dXCdHQOkHOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lf78eReE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lf78eReE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF27C4CEC3;
	Wed, 25 Sep 2024 12:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727266568;
	bh=TlX0taoMF24AJh7bkV3o20uw/wE8d2sqob15TW/2epI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lf78eReEznQnGzaR0hrjL4YBoQ3EAJIniTuzUYbg4/hhwlMrxcLNQmhUT30+hEp7g
	 9DKimay2NGV4gyYw1cjkikC2RAGiL1OEsnb2V1tHHcSLWrg01Iw+mOCpm/oudTceon
	 N0HEQSkVgPtSHqJwawAHIbwSp85tNz2HOi2m/lhL3nle6Jgl1x32Sn7LhAgCwywX7Y
	 GcZ+U87VqJvQ7k5cfd9XwPSiGeRqlyhiwQHfJbIcGXvCxpIzpi7/cm08hqTe9XYz4Z
	 JOnLIQqFvWHQ2TklTpETKQ3xx9ih9weo6ffEznqReAu9YQqNmNVbcIirJw4jTIG2J2
	 x3f80MXnE4rdg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>,
	Scott Benesh <scott.benesh@microchip.com>,
	Scott Teel <scott.teel@microchip.com>,
	Mike McGowen <mike.mcgowen@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 098/139] scsi: smartpqi: correct stream detection
Date: Wed, 25 Sep 2024 08:08:38 -0400
Message-ID: <20240925121137.1307574-98-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240925121137.1307574-1-sashal@kernel.org>
References: <20240925121137.1307574-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.52
Content-Transfer-Encoding: 8bit

From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>

[ Upstream commit 4c76114932d1d6fad2e72823e7898a3c960cf2a7 ]

Correct stream detection by initializing the structure
pqi_scsi_dev_raid_map_data to 0s.

When the OS issues SCSI READ commands, the driver erroneously considers
them as SCSI WRITES. If they are identified as sequential IOs, the driver
then submits those requests via the RAID path instead of the AIO path.

The 'is_write' flag might be set for SCSI READ commands also.  The driver
may interpret SCSI READ commands as SCSI WRITE commands, resulting in IOs
being submitted through the RAID path.

Note: This does not cause data corruption.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Link: https://lore.kernel.org/r/20240827185501.692804-3-don.brace@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 868453b18c9ae..8ce8713522ffe 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5934,7 +5934,7 @@ static bool pqi_is_parity_write_stream(struct pqi_ctrl_info *ctrl_info,
 	int rc;
 	struct pqi_scsi_dev *device;
 	struct pqi_stream_data *pqi_stream_data;
-	struct pqi_scsi_dev_raid_map_data rmd;
+	struct pqi_scsi_dev_raid_map_data rmd = { 0 };
 
 	if (!ctrl_info->enable_stream_detection)
 		return false;
-- 
2.43.0

