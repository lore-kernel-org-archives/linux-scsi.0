Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A836F1BAEEA;
	Wed, 25 Sep 2024 11:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727264870; cv=none; b=Y5jJae8HL1BQHN1G9P77SlhLyE07VANxm10SiIDHXCFm2K5YsZE9mmCAJOqZO6u4zJ3mrSX3cg7hLXAHW/9ATgAp+OLcnBGHkCiJADwYRMpAIcB8QlbSirNHX8B+QxIibimEdnUK8WeFEt1hWPHXMYwyG9GS2kgrwSCQQO+5Fgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727264870; c=relaxed/simple;
	bh=NhHZRBYnwIut6ZhQ/JAyiNEf4wWFRZ+8+zGqXiUIiBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5YoFjfNKJBcRS5G/bDXy+QMp7FaQ3JJ6q+GXvbehEADqo8IaUBZpUiead5a1Ry+Cj0puq2FPc3TArS0UKwWv+jChhoj5dx8ooQa2O/VbcldBnyrcCtEXm8KNN7g3UZWvcAZrgiZ8/kPxdSIeS+8yaAiURr0JsjZjosb4njJJhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TJmeBKLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TJmeBKLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E045C4CEC7;
	Wed, 25 Sep 2024 11:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727264870;
	bh=NhHZRBYnwIut6ZhQ/JAyiNEf4wWFRZ+8+zGqXiUIiBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJmeBKLqXuUNgCRCnap0eIfSbJlUwcvpr6IGCG1R13Kh1Uac9VFO+YjBMFzFJdXE3
	 nmJo7D4upt7QnKbA7fZ/kiTlAbifqkUiVV9GDVH4EXbiPsf12uYVX9JryTmA0RJgbc
	 npI2vH7BvFRZhVceaiw+WL3GbY8Z+O/bi6t3IWa4VFiqZUsjyzVO2G7cmoGBqBlC8y
	 JBI+mn5w1KO0VBHkk06BZnFK3KO9XbFOSp83rLb6VFHcwhKvfjQ5nKUBS+OwhisF0A
	 1RtKy0ZscM+wDAQtaP7TyB8ASLEXyrizWMSghvglKLlv0P1U8ocIqwz/zulL6XOATc
	 dDn0pI3vLX3LA==
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
Subject: [PATCH AUTOSEL 6.11 166/244] scsi: smartpqi: correct stream detection
Date: Wed, 25 Sep 2024 07:26:27 -0400
Message-ID: <20240925113641.1297102-166-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240925113641.1297102-1-sashal@kernel.org>
References: <20240925113641.1297102-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11
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
index 9166dfa1fedc3..f18799afe9de2 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5933,7 +5933,7 @@ static bool pqi_is_parity_write_stream(struct pqi_ctrl_info *ctrl_info,
 	int rc;
 	struct pqi_scsi_dev *device;
 	struct pqi_stream_data *pqi_stream_data;
-	struct pqi_scsi_dev_raid_map_data rmd;
+	struct pqi_scsi_dev_raid_map_data rmd = { 0 };
 
 	if (!ctrl_info->enable_stream_detection)
 		return false;
-- 
2.43.0

