Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D872BD91C;
	Mon,  5 May 2025 22:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485216; cv=none; b=p5aehRpWTKlcZgk6Ynosbqiajc5YgSeY6jBpAXE2ET/P03qjRh0fBHc2P1zSC/maTebQA4MZOaU6UdVspxvMDx6Rt0+Pu+iw8O8NRXr0bUN1WUQ4kZuM4KfcMRn9Rlj/THHsb6uIwFb9wt+woOcoDO2s2D/BteH1LUXRZMXP9rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485216; c=relaxed/simple;
	bh=/IS8kiC5PDBV56uRbOcCm/cQDPQTsRPpKMG4+IvaPB8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eBrS+eJS91VW2HjX442jQP5rGcXNMgAOXtQ2woki0CXa6WXhB/xum8E3e8pA0+VIkVu4T7V/R9ZRr5eL1raa4kIx6uyEfKYYqNRfZaDE5vQb35C1VoM0Uxb+vWpazELD8+KB3PjjkT+r7fV0wuIujNFWvG1AxI/GOPIu6WkrQTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C8+7qA2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C8+7qA2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA75C4CEEF;
	Mon,  5 May 2025 22:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485216;
	bh=/IS8kiC5PDBV56uRbOcCm/cQDPQTsRPpKMG4+IvaPB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C8+7qA2VddmOA54s7Z5eOpVEvc8SjWaYPw+70irh7gs3OGc2QAN9YKmtbjg6X6jMu
	 DajTtjV2HVeTIubObUS7nj1JaHQIudZ8RV8FAEOKbyy1w8A7m7jo0GberVzU/c/1YA
	 deBkS/VCpQ7cMVDul3i0zpF0nm4ld0Mh7iJkuMP52YeNrkl7zr6BsutZU/JpqSVJxu
	 sobmUrHeIUTeqhgfnfqJ6hlWJhULtPbm0IgCyBM5c+h24ngH322O5DzoLwyCptOWzc
	 jIHs/X1xiiqRfmAO383SeA9rz3k5T91xGxP3zHo93Z/Zey6zfR0XZs7QfFkHvl1S5Z
	 LiRIzIyCNkROA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Joel Granados <joel.granados@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 215/486] scsi: logging: Fix scsi_logging_level bounds
Date: Mon,  5 May 2025 18:34:51 -0400
Message-Id: <20250505223922.2682012-215-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
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
index 093774d775346..daa160459c9b3 100644
--- a/drivers/scsi/scsi_sysctl.c
+++ b/drivers/scsi/scsi_sysctl.c
@@ -17,7 +17,9 @@ static struct ctl_table scsi_table[] = {
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

