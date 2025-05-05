Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264C129C323;
	Mon,  5 May 2025 22:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746483576; cv=none; b=l5VaBfxXR712z0gXuQUEDdbRwgMrbkWuc9p8fBW4ISniLEBiU96YWx4RMby9EYVpWHZaSkZtbqPq9T/dzrln1mn3rzDQ18ZmII7pH88JukWGDAtmxiSy/VstKMjp8i/gy4oF3xz1Rf+0WTsN514rUXmiARPU7qyBhBvIUXr3K80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746483576; c=relaxed/simple;
	bh=FvE2Wv9NM2nY8hJdeQioiu6AOqzWxKC36ZtGlXvNpW4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HRGoeh9bhRWekwM6aWUPoZxTKV+tzMoR8EFQKMZ28MudHo3F0ZF76sci78Zr2BxEKU4RcW2kq2DnqP3xce/q2Wt27LMsks/ew+k/MKT6n8MGzQJxCosB53EP1BLEe0lKqecPmUhXArqaMtxUyKcfdKSOz1cTb6AA0QG7wiapbhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lqjXJzeP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lqjXJzeP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36C8C4CEEE;
	Mon,  5 May 2025 22:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746483575;
	bh=FvE2Wv9NM2nY8hJdeQioiu6AOqzWxKC36ZtGlXvNpW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqjXJzePR0orrqcpV4Y5HZnnoJcn+ux5dreCdoIk9f7bu7roKR2g7kL9C/ZpaEAhz
	 CwbMBfpxEbX7P9l2GhZ3twfKSgYdjJFyjO4VmniCu1Rm938qbQXM91Zu8j8AK2CRqV
	 AHW7tzWLbwi+U0KnXY1//SYO741XDGQzRgPkyxZrPinQFjlNDABgd8fjFty1OZTMtc
	 yXCZDCE9XJ7DCQ8VuPJKkmN6oesLhdnDYw2JtC09KdUETdrqHe6gN13R1q4LOfZJQA
	 IdyaZ0YTsvL3FVbqiJosbhj++MGwGOUFydwuDV9ebKE+OXQjrY8vbhYZNuXcJBly34
	 v30rIIsYyQEpw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 123/642] scsi: st: ERASE does not change tape location
Date: Mon,  5 May 2025 18:05:39 -0400
Message-Id: <20250505221419.2672473-123-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
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
index 2a18ba51427ac..4add423f2f415 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2897,7 +2897,6 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			timeout = STp->long_timeout * 8;
 
 		DEBC_printk(STp, "Erasing tape.\n");
-		fileno = blkno = at_sm = 0;
 		break;
 	case MTSETBLK:		/* Set block length */
 	case MTSETDENSITY:	/* Set tape density */
-- 
2.39.5

