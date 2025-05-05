Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF722857C7;
	Mon,  5 May 2025 22:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746483926; cv=none; b=MP1002kXupcofCcCrAQqplCbV/lQhfRGehPUoNo2nWcG5v7/twDQG2deYxHsQiyh0CQqrDGZ+OnquNBLSoKWQlMybDXYCzSeMFvNuP7tT/s2Fk5RQ/nLoNT/p7arpj2aRON/z9PNPaaTmmuRjaJ6vJN5U4nVbCFl461wNTPHsik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746483926; c=relaxed/simple;
	bh=LzWpQRSxTR2XZMghCGMtBsEgcWSm2tLWJE4dvtpSdzU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lU0cgRJJ480BEizWpSJizuW+bE7+Iiytw9Xdf2nJrVM83v/rnNwjJESmxA6mjTQBU8kYyC3Z+ltF7m3x3c+k8srqNkwrlU0XeIrl7JALIsFTKLnDqDr3JFykolovDNfi/dtfzEvf6kTzMvs9HUyP8NWg/wc6fB9k/4cXUDtFGbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AP2Z+yhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AP2Z+yhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D26C4CEED;
	Mon,  5 May 2025 22:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746483926;
	bh=LzWpQRSxTR2XZMghCGMtBsEgcWSm2tLWJE4dvtpSdzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AP2Z+yhzghY4R59LsnFwXC3udAzsxPOFox17IJk71A1+XmUvFj8Kwh1uIpRvW+c3Y
	 hHuDOzqAricrhwC83ye2bAftHzJ6rksl6QqThpcCbMDRp6JD4phrmz1vOnUqiw/n9L
	 yG9VrbMuKlBGKdeZ/rVIf6QsoaDKBcQaZ0BiohWPSYYHY2z07CP+F1XCrUop/w5uI+
	 MH1sSfJACGDV8Se0oNOdY01mowLKJT3Yq18OBOgcuiJy2tjqtGpBmjx3YDBEfvQw5n
	 ixaFoWP1aUKDLX3fl5X9N6nWQabAsI0FAgUjNcqXO1TifwxJEjflOGpaq/7b40AhMP
	 VJa5X3lsAFUrQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Joel Granados <joel.granados@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 272/642] scsi: logging: Fix scsi_logging_level bounds
Date: Mon,  5 May 2025 18:08:08 -0400
Message-Id: <20250505221419.2672473-272-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
Content-Transfer-Encoding: 8bit

From: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>

[ Upstream commit 2cef5b4472c602e6c5a119aca869d9d4050586f3 ]

Bound scsi_logging_level sysctl writings between SYSCTL_ZERO and
SYSCTL_INT_MAX.

The proc_handler has thus been updated to proc_dointvec_minmax.

Signed-off-by: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
Link: https://lore.kernel.org/r/20250224095826.16458-5-nicolas.bouchinet@clip-os.org
Reviewed-by: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_sysctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysctl.c b/drivers/scsi/scsi_sysctl.c
index be4aef0f4f996..055a03a83ad68 100644
--- a/drivers/scsi/scsi_sysctl.c
+++ b/drivers/scsi/scsi_sysctl.c
@@ -17,7 +17,9 @@ static const struct ctl_table scsi_table[] = {
 	  .data		= &scsi_logging_level,
 	  .maxlen	= sizeof(scsi_logging_level),
 	  .mode		= 0644,
-	  .proc_handler	= proc_dointvec },
+	  .proc_handler	= proc_dointvec_minmax,
+	  .extra1	= SYSCTL_ZERO,
+	  .extra2	= SYSCTL_INT_MAX },
 };
 
 static struct ctl_table_header *scsi_table_header;
-- 
2.39.5

