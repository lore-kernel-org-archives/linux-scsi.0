Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6256321D5A4;
	Wed,  4 Dec 2024 16:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331522; cv=none; b=NNdVipCj2t+6RbUgRB7IdMFf1Agj0PAGOI9F0E8oRjmDM8ZGhpk4vuA6/BMU5DJdD1u7V0EaEBO306eWi4TsEtV0Dp8q6mAORCTdwKAlfzk5zrvJqFwIhux2JUfeTQ7TEuxJvrH8VSL76UlSZEfCj5X4GZ/GummV1hu7cqPGuaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331522; c=relaxed/simple;
	bh=el6qKyrnX/lE8G/cCrHEpJDI7Uq57SiUfsByr0a5lDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FseyZCgfDVWwudn5wiAN1ZJavymiVaiM0KKHZ4LNzItEdjzdzVVhDb0QWTgvF5xDCmGKe9CELzYIYndUkW6NJJdyP5yYEAbCOIYey8r/xhDesjkb2v3kZTkaDhrSEmu7fdJMukMEpN1ceqiT5CFWdee9+RjANmoJ1kOsWaamXkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KsnGEtTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KsnGEtTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5F3C4CECD;
	Wed,  4 Dec 2024 16:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331522;
	bh=el6qKyrnX/lE8G/cCrHEpJDI7Uq57SiUfsByr0a5lDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KsnGEtTFFar2sVluE/EwsCWSt76igwHMFZ80CqWMIUJhDEJPp+B65K0EnlRVZMeMm
	 kmZN9nCRjhSMTwzei1mCH59wO4Mr3nes1OaWyg6Y9rMP2SR+DFm6f6PqtRis7hDLyN
	 oZkXVjdRkVE68VNwMOIL0AMhWCrVJd21XJx77wMcPaWR5vcFra8l4qUx03JRoWHWLX
	 UTkraoXA2bZ7vN1UKTW8KR9VnPKihDDiNmw0DmTScY5W260Q0H/mOD5nJF+v7/P+kN
	 /C9ezjcRxpSoZfmYzay7yov354Ipj4OaU8k8HGqVgL+GnLZN/1kOBdHx6ihWNfEg9a
	 7GL3s4VT6Q/jA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 26/36] scsi: st: Don't modify unknown block number in MTIOCGET
Date: Wed,  4 Dec 2024 10:45:42 -0500
Message-ID: <20241204154626.2211476-26-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204154626.2211476-1-sashal@kernel.org>
References: <20241204154626.2211476-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.1
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
index beb88f25dbb99..8d27e6caf0277 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3756,7 +3756,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
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

