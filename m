Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD07F22307D;
	Wed,  4 Dec 2024 17:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331766; cv=none; b=UXfOLiBl6KHSnYKx0Mkgm4G4CFed/Cemwg6VU/pNtFNbV34y1XDi6OZNN7AoQPAVL8DK469UG3xSS/tUEfxzwfOMtzm23H4VHeRVk0Feinx0YNHZOXckm2IEGP048zHkVEc/jzkU5dXa0g/AH4x1rG9/K/jXFSkAOe0uO2hP8os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331766; c=relaxed/simple;
	bh=sX2ifxhR1NkCXq8Qfn5BbG3f3qkL7/tt4eJWtxFyX8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AwyBTnwTcwEfBtW/473eBqO+xTrNC07rnPJGekQLLa2hv+UuXxS73DZ35EG8U4IHs8wegmjGa4oP6Y5TZLvufIA+myA/cp/Oa92bh6qYS0R59ZPXKvHp3maIDi5Az74+kj4dglXJQdveMiPSXQPj9+sI62wfjEILawny1TK0Pew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QXM9D9zh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QXM9D9zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0D4C4CEE0;
	Wed,  4 Dec 2024 17:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331766;
	bh=sX2ifxhR1NkCXq8Qfn5BbG3f3qkL7/tt4eJWtxFyX8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXM9D9zhM6tJdX5MjsVGs/MvI1pPxsGuBI8Xev1wZzQAM5wYAxkzBfaMtbZwZItkA
	 7RjnpW/FGTniiiXiQcUIVdKu1BcXJYAeCE8x9iBWDpKsZuhQosdsLPekWF7vAUp0Lc
	 yF0Ap0goFubW/S7NAKq7Hf4K9XVYVMgNmkwNgwxjpXAcG4BLjG7A83Z9wTvRu3GJVv
	 88zSr4OrSdfrPytBGmWFx32QDjJ+u1JK4mgNGonvo+lcymUwEFe6BeNwuiQXfmCSU+
	 t3r1IKHAWOsy+Lh6sQl9qEWm5le5m0a4nOgQUQgClEiGbh1QqOCQ7CnTHyVY/CR5Jl
	 ZXMhnGN4OW/9g==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 09/15] scsi: st: Don't modify unknown block number in MTIOCGET
Date: Wed,  4 Dec 2024 10:50:48 -0500
Message-ID: <20241204155105.2214350-9-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204155105.2214350-1-sashal@kernel.org>
References: <20241204155105.2214350-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.119
Content-Transfer-Encoding: 8bit

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

[ Upstream commit 5bb2d6179d1a8039236237e1e94cfbda3be1ed9e ]

Struct mtget field mt_blkno -1 means it is unknown. Don't add anything to
it.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219419#c14
Link: https://lore.kernel.org/r/20241106095723.63254-2-Kai.Makisara@kolumbus.fi
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index b90a440e135dc..b91da7b51814a 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3754,7 +3754,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 		    ((STp->density << MT_ST_DENSITY_SHIFT) & MT_ST_DENSITY_MASK);
 		mt_status.mt_blkno = STps->drv_block;
 		mt_status.mt_fileno = STps->drv_file;
-		if (STp->block_size != 0) {
+		if (STp->block_size != 0 && mt_status.mt_blkno >= 0) {
 			if (STps->rw == ST_WRITING)
 				mt_status.mt_blkno +=
 				    (STp->buffer)->buffer_bytes / STp->block_size;
-- 
2.43.0

