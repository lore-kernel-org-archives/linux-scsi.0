Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA3C378D9A;
	Sat,  5 Sep 2026 03:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788578603; cv=none; b=SzgBs/tfahfjJllzVdCFo/QH/fKU26GNgQFYRwzNwSL5F9APuJsIvnGWN/BpsdnDJPsmIvTuhSlsu5PwwoM04C5X4iWIc0TCmFtehPjtrvyD0WXNg018Wudyw75Z7tUCvJGNfphpI0vEsqlyIT58aWBX6M0TnX0AZhYj9Jn1KTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788578603; c=relaxed/simple;
	bh=gcjMW3ubVT6P31ovg6jJSK0VI7MAZ31/Nf0v7YPd+dI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLMtZjf36RmUQQdvjVUMMiJmYvO19OyEaYn6l4Oy4V99YJOBXEgBXxzgndYWmkSmhYsORQ+UUtOD+kutSooGM6aWiOiMUKFAXKbLPle+TTEb0nayM3D6Kada5Y7a7z0m/rw0TWrFm0wO+61YNyXqSA3MnIyqjkW+iumXFsihQZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QWQ4Hvee; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QWQ4Hvee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62541F00A3D;
	Sat,  5 Sep 2026 03:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788578602;
	bh=kAYHHp/LsBL3rsDwvCzc9nieAEGXN6oNnsCLaWoi958=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=QWQ4HveeoTbqYiUYNg4S8Msq5sxeCziA7aSDzPcgJIbNRwou+kPx+Z6VW+7iFz2iS
	 euPr3++ODsBjspxUO4pa6ubc898KgQCYIYJZNWJBxu/HmSx6NLNCQqdpm/RKzneY/p
	 idqO2sq0P310JuDPcqE9Y6CNGMZOB8tlDgwda1Ngf9Jo1eq3FrkuNMiJQXvivzZqaW
	 c53wer0kzSPYfdDxXIMLrUl34lG12e3/uDo8+QkFJkm4v2Imge6vQEZf/XGMucGpbR
	 yX1ES53Y9uXKPCwOpgT9hwAYhpka7rUa+ofTpW1XlJb8+CmXTLTM2iOxZroK+o3m01
	 ovdonIP29aUWQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v4 25/40] scsi: ps3rom: use 16-bits defined sense codes
Date: Sat,  5 Sep 2026 12:22:09 +0900
Message-ID: <20260905032224.509860-26-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260905032224.509860-1-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the PS3 DVD driver to use scsi_set_sense() and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/ps3rom.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index a9c727d22931..c63c581b493c 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -233,7 +233,8 @@ static enum scsi_qc_status ps3rom_queuecommand_lck(struct scsi_cmnd *cmd)
 	}
 
 	if (res) {
-		scsi_build_sense(cmd, 0, ILLEGAL_REQUEST, 0, 0);
+		scsi_set_sense(cmd, 0, ILLEGAL_REQUEST,
+			       NO_ADDITIONAL_SENSE_INFORMATION);
 		cmd->result = res;
 		priv->curr_cmd = NULL;
 		scsi_done(cmd);
@@ -316,7 +317,7 @@ static irqreturn_t ps3rom_interrupt(int irq, void *data)
 		goto done;
 	}
 
-	scsi_build_sense(cmd, 0, sense_key, asc, ascq);
+	scsi_set_sense(cmd, 0, sense_key, scsi_sense_code(asc, ascq));
 
 done:
 	priv->curr_cmd = NULL;
-- 
2.55.0

