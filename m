Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0543BAF87;
	Mon,  5 May 2025 23:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487348; cv=none; b=IMvfXLRuIwxrjUfJtyHtEsg8u2JRleA9Kh8ms864QjlewWd77JWg27hSm/9gEK1varDLkPazs3LI/t+PQkjQpfKlOBjd3lBglSo8tWaYShd6K9LJZ3TJGmh3cA7zV9Kh0+h+JYLarmvmJGh/AKBlfxRm3kcltTMfY3NMwhPbYQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487348; c=relaxed/simple;
	bh=Q+v7VZoENNlzJV9ZQLNwya7jNn5yUDxBD4kC0ULM0Ag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LiWOCdVAPGsC6l1JGIieMqMcwscpJ7U6kTFt0ifdHC+blPnE6fvbwaT9rfRYZFUrHUKPYj+IQbV9hfb+oXP3YQYzRlZl3aJL+DmTYsPOnVY+wK8l8qWZORQ7/Bgdsc3LlsqGOMwwnwLeQOCuVtoVQ7sDFTG1XF1lr5t3ix97wO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PJIRJgvn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PJIRJgvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE06CC4AF09;
	Mon,  5 May 2025 23:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746487346;
	bh=Q+v7VZoENNlzJV9ZQLNwya7jNn5yUDxBD4kC0ULM0Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJIRJgvniun6llULIUJUaYzUefx6eahx75hu+f/sct8FxF+Lt80T4sk5N+VQLgAAP
	 aA7WG9jZeMTrWrdjUqPiHl8JKiaCWVk3DOUkjQ5Yk0h7YQqnHe76C8BuT81xz6/eeo
	 j5zlVwhdek6EBqOGXnyllTuh6/T7J7Rqka1nO+r8oPSGRWhQIXPBPAzmaJN8Xb7yAV
	 GtFm+pIxY6MmWExhzD45ROhxzdEdDDFUp4NCoKAk29jVA0dFGaZfDzxC3VMrrceFwC
	 6yqak+j+vjhKJ+XVCiknzN/y7dso4DRqAMRQf3awk1KgTWUBaIvbOM4o+tZVV/kcHg
	 HGWagZSCutsqg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 20/79] scsi: st: ERASE does not change tape location
Date: Mon,  5 May 2025 19:20:52 -0400
Message-Id: <20250505232151.2698893-20-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505232151.2698893-1-sashal@kernel.org>
References: <20250505232151.2698893-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.293
Content-Transfer-Encoding: 8bit

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

[ Upstream commit ad77cebf97bd42c93ab4e3bffd09f2b905c1959a ]

The SCSI ERASE command erases from the current position onwards.  Don't
clear the position variables.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://lore.kernel.org/r/20250311112516.5548-3-Kai.Makisara@kolumbus.fi
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 8f927851ccf86..3f798f87e8d98 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2889,7 +2889,6 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			timeout = STp->long_timeout * 8;
 
 		DEBC_printk(STp, "Erasing tape.\n");
-		fileno = blkno = at_sm = 0;
 		break;
 	case MTSETBLK:		/* Set block length */
 	case MTSETDENSITY:	/* Set tape density */
-- 
2.39.5

