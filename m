Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D64637EFF1;
	Thu,  3 Sep 2026 03:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788406990; cv=none; b=aeFm7BCMz2o+n6liu9vH/huaDSL0P3QGzTGFoyQqI1dKoM5YcBguXXXpG8PPvosZfAMil41WKmq24iPcbQiUaoRgniLfSPLMIaksCCaPS2IxIvd8y+U1tjCDIZHx/asYPEamUtpVzwPcoEFX+Tmk5M2s/dLOnXAnyWtntaFy+aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788406990; c=relaxed/simple;
	bh=gcjMW3ubVT6P31ovg6jJSK0VI7MAZ31/Nf0v7YPd+dI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8k4Pxs6ya/G9OTzuiMu3abj2HKNM5LEHsDsHhEx6ZpxYPK0lHE0FhIqEbXcLmkbG4FJIA2ym8C3QlyJL6kLcHBxKqoELiX9Cc6FYXsnWdsJTPWcU2l4Iijk0H6T4667bwl1ZW3mvIfO/2B7EApyU078OAQvuubXwuLLaHqXVdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DWKc4aio; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DWKc4aio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6377C1F00ACA;
	Thu,  3 Sep 2026 03:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788406980;
	bh=kAYHHp/LsBL3rsDwvCzc9nieAEGXN6oNnsCLaWoi958=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=DWKc4aioUEEtXwPsvRaAYU7E5U9RiMnruEvJfn0fhBd+MkKZmGU6APwIPMl4whjDr
	 cM9kptFVRfjrzBf922r1pilMDLHknGxs5IkzeHXJlGr5NGtJEudCViy3zKLBTeBYbo
	 6mONZVGecsxyFAJxrl8kVXMmI8dYf+6NZgi/2bfPpOP5SEraVQKo1P3abhqhzkbwT3
	 8j5VC2HdarZOQgi5YlqR/a6q4rag2umTKm1P9CJ8jCh9h08VOmHkD6j8loX8f72387
	 7wZ62i/BtDKN2cUAuWNlRrrGZCZOu17S4LJ1wpjUP2/jxtdc2lmbs2n7FpZ6YmhAdY
	 F7njuOwq7vvMw==
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
Subject: [PATCH v2 25/40] scsi: ps3rom: use 16-bits defined sense codes
Date: Thu,  3 Sep 2026 12:41:46 +0900
Message-ID: <20260903034201.112211-26-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903034201.112211-1-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
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

