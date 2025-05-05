Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F03E35D7BF;
	Mon,  5 May 2025 22:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485907; cv=none; b=Gj9dWiSxloFA0L8UPTvXiUM/S97WYehTrElt+ggZaNbLFTc43nF7owZSYopdrKodiDGQRrVOKGnT35E1AyFlTae2nTDOHQzJm0nPDMzTriRZ3pxeiM/aJ2KOFi9RPukymZNNkbyEjN6+LwEGTmDdClkN6QXmO8d5kb24uLcYRYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485907; c=relaxed/simple;
	bh=QTl/bFmcjYT6RvFJZuAeXHESyiMLhcUNbI0/Y+RFxOA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oFAYtIsuD75CB2PngNdjXNsIJwpj9LQ6/NK2iDiCFUS3H89YZvU5bVsUb8DevcIEuJfjzAV9gNU5m0DFRkWbjvgNB88z9tfVVZ4tEwHvEpvqMTIczk7GxPaYqBrG4/My6Fm6z5ycI35spJ9xoQ8Phx2rLekr6D10lWGQVAp4FE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ymklz+QC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ymklz+QC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EBEC4CEE4;
	Mon,  5 May 2025 22:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485906;
	bh=QTl/bFmcjYT6RvFJZuAeXHESyiMLhcUNbI0/Y+RFxOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ymklz+QCJIyr7MWE1zcccJWh1MvwQFIkWo2+56WdfV5ADwJQyC42MEOynb3gMHvZ0
	 uFOcvQKvzGMkxu8IiI6Y0zOdY5K/oVCdqZPJYJRLP5zszMYADaIRJUHvqpDLBRlZRX
	 AJ6uzxfpYtbp7JjbHeurIt9Q7VSfuCY6h398wbO15B1za3lMaeMcjsbav1iriz2Ujy
	 vGlx8eceQd4ld1T+G8hq47OWZmH7VCwxxdWOxuQfXBXquaxMSQNPnuiKzsjV3eHi2o
	 7RIXhqhLRt0z8BPUzmhLmXMaqn624y07WkI6zqioZfqwlGUAnUOk8zTKFDQsaDQwOO
	 mfCI/5F9McOyA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 059/294] scsi: st: ERASE does not change tape location
Date: Mon,  5 May 2025 18:52:39 -0400
Message-Id: <20250505225634.2688578-59-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505225634.2688578-1-sashal@kernel.org>
References: <20250505225634.2688578-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
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
index 293074f30906f..fb193caa4a3fa 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2895,7 +2895,6 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			timeout = STp->long_timeout * 8;
 
 		DEBC_printk(STp, "Erasing tape.\n");
-		fileno = blkno = at_sm = 0;
 		break;
 	case MTSETBLK:		/* Set block length */
 	case MTSETDENSITY:	/* Set tape density */
-- 
2.39.5

