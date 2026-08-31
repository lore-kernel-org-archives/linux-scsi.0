Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A54357D09;
	Mon, 31 Aug 2026 02:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141945; cv=none; b=eGsEFdRwOLzbUDTR7nD3bap02EKUYuqXZz5iBux7QZSbnOa9xBsrYwym2bCMatIsQzrYVC57RuKh34bu7Dlou8aSiSTHZ/aSnhtAuEMe337adgrf8nwUM2qkcvIgPn/d13MDVvOva6nOuatx/FcXlEAOfzvOLk4dxf34jsGNfyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141945; c=relaxed/simple;
	bh=gcjMW3ubVT6P31ovg6jJSK0VI7MAZ31/Nf0v7YPd+dI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnUJMgzZHSmann6eM2cBaFjZof0oyPNUmlPyzn2g9xru3d6ibmmHyIhDgYw45OlX9CajlsWygxQu6FW/zFG0JN+HRkQkRJaLajc5AHS+NPB7NMUv3Yffssct8LtXxCpOTptZw3VrZsdolDVFWdPmQYl3CIuoj0zuYbdtaESDgHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HXJKiJ5l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HXJKiJ5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20FD1F00A3E;
	Mon, 31 Aug 2026 02:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788141943;
	bh=kAYHHp/LsBL3rsDwvCzc9nieAEGXN6oNnsCLaWoi958=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=HXJKiJ5lU/kHAmE80R+76D5OtyTr5HyTl+OahXJp2vrl2tTVn5w5RAebI7efdBVM/
	 cBLnc2cCTvcwLa+o7+ieB8AKFfb4vWtbbJbDQr/rYzdI+8XydGmw+3z41Gk2xxoNms
	 llKcKOfLkn9EH0CDTOhPh0QManwl7lauoB5MMARz3ZEXLSwdmKYViCFKoVmBd7LGEJ
	 oUpGDtNCqSHh/y0lXArNua87m1rZKKgNkDAPWS2mmPgb5hYLYQP7pm4ctFc0OWyaNM
	 dOg8+HoruypKKgoLtZh5F1kpeotafr18bR0kDXPu3d8BAn+T1UPQK6KgjsgkufJ7m6
	 gE/w2YR2ahGNA==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 25/37] scsi: ps3rom: use 16-bits defined sense codes
Date: Mon, 31 Aug 2026 11:04:39 +0900
Message-ID: <20260831020451.585944-26-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831020451.585944-1-dlemoal@kernel.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
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

