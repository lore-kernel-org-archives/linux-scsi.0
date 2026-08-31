Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0B935C69F;
	Mon, 31 Aug 2026 02:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141948; cv=none; b=ZnWymE8OVzYtca0DaXZ0gU/E1QueyyyCh6gXdZtBNl26D/pbhJHosm3Vr1RG7+Styfi6eDwhNSbalj4aDsnvF0NLtdc0qFrQaG74/k/k+FtFylDrVm1MMMZBr2RsmPZ7rXNp4pC9OhEKu4omngexUfKOHDKuIAyXAOF2UHvdBjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141948; c=relaxed/simple;
	bh=aniMHomtNRiybiTm9qmt1bbUmYk2bJon40xjoPETuaw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opkPcUsOk1FzgGJba8nB56cWMgOPdpoUMKmp2LQ9lGB6LV2NUl/j96NSQ2mZixanUFdcfc1b7ZGfgit7Ba1SWTGuItE9pHMIAYiWV5AEu9KojcT6iwX7X7Uyc7tP4mEKjolDNchx2l1h0JDnAel320M8MsNt6vNGSrk/0oe9LMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S24FKZAX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S24FKZAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50DE1F000E9;
	Mon, 31 Aug 2026 02:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788141947;
	bh=GmKRJhMjMSX4APigNgrN8PgSWVi01i8DN3Nci0Few5w=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=S24FKZAXQCyEjNuu7FztMqVbncVNAupX1YPGKOviIcdGRsJdp8w7fxToewztHPRcA
	 RDcm+GWEUDCNg7SusvDQVjlSnhLQJ0zeemSRfCBSW2sSCczMvJlbI1ooCTx4f+95U4
	 foVY9M6sagnFgs280x3FnVyfviVhehIHOq3cnl5IgNoltPxHSI4YGauTIEgnKwN02F
	 pASAvPrIcsleA85Q1CuKkBpkzN56k5BAzb4w4AvUJI3yzAJUTHXlEWUBYJ019Z9sbt
	 RP0+/KrNvTC7nz5KB2gvMYE604e6V9BSxUUz4nuNEgSqOVg88vJ7Nd7PfFa4sxIdFp
	 +0Wb7lPYwr7Ww==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 27/37] scsi: stex: use 16-bits defined sense codes
Date: Mon, 31 Aug 2026 11:04:41 +0900
Message-ID: <20260831020451.585944-28-dlemoal@kernel.org>
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

Refactor the stex driver to use scsi_set_sense() and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/stex.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 6aeeb338633d..056ff0eb5455 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -401,8 +401,7 @@ static struct status_msg *stex_get_status(struct st_hba *hba)
 static void stex_invalid_field(struct scsi_cmnd *cmd,
 			       void (*done)(struct scsi_cmnd *))
 {
-	/* "Invalid field in cdb" */
-	scsi_build_sense(cmd, 0, ILLEGAL_REQUEST, 0x24, 0x0);
+	scsi_set_sense(cmd, 0, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB);
 	done(cmd);
 }
 
-- 
2.55.0

