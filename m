Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288D73F23C0;
	Mon,  7 Sep 2026 02:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749076; cv=none; b=FuQjA3s129nzS8bPwhhoc2S8jCkuNeyjBuawe+njTvQqu6ErxWPUw7RHUajy3bf29Oyf2uglGDW+a4UAQ0cr390JxgiEIvnIIrZl8EkOsduTkmVDVyiJjIEQ2XhjhDdtF/66K/TskRf9nrTlrvf4kq9AKIGGSAwVc5l4I52XlSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749076; c=relaxed/simple;
	bh=gcjMW3ubVT6P31ovg6jJSK0VI7MAZ31/Nf0v7YPd+dI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1uIN/TB3jLzIunU6NHScwmMmFy/TQQzmRdMG7hwxLvUEkGiwwcOaNhikq9fB5RrTE+izIxd9QkA2iAt3WOMTkJEwOQb75Yft6mnTkGk0x3IRFl37ALhX+t4BI15FgMBRrKJRfSz6douUd7JYgcxOHPD7uEcWcggXJS6LA6wOmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QRVIUvSo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QRVIUvSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB031F00A3A;
	Mon,  7 Sep 2026 02:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749074;
	bh=kAYHHp/LsBL3rsDwvCzc9nieAEGXN6oNnsCLaWoi958=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=QRVIUvSoEDp15MwXtEU90qectmAGEoaH8E5hGD0N44JGPLW9PHmyteWGNFOSaS1Vy
	 s6E5eYhc9p9yyL0Co+AEf9sJDmOIqNXO8EFH3YJ600mdWpxJzK8TC/HywR6n0bFFa0
	 TMUWiwsFZrJQife2YHp0Z36s3gzRKO0M3MFXhbV5MuLODl0WDNXsdo3u6nG8Oa0FIK
	 klCmkbw9FoT/2lzv7PFKcPUyTd9Hw2n8/F0QUap7Ym/i0pkuyRgCAzS4NBE2O6JY41
	 ZlIPTFpac0Dgk8KqNEnah4XyyvWQAPt3lkdr6fcxCSvssglYI78iSH//A40pbigHH/
	 7Kg3baiSxt30Q==
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
Subject: [PATCH v5 25/40] scsi: ps3rom: use 16-bits defined sense codes
Date: Mon,  7 Sep 2026 11:43:28 +0900
Message-ID: <20260907024343.1046387-26-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907024343.1046387-1-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
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

