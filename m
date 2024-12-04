Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80F522C701;
	Wed,  4 Dec 2024 17:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331830; cv=none; b=dbO2M0f/HyLwnZdin/dW0NntWKEHz6KWa0r6ukr6JDo+iKzmNkMGJZ8HcTxhzM8Prc6IWR2aaTCnFJVCILl6GaKFWvguxesLxebFDsLQy5W7w+aYwwyJXEjXQTtHscz03MC9xnpejE5ORyZYDeTKwhAJRVM9VJxMQg1rWCrZIOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331830; c=relaxed/simple;
	bh=RKt8PGOX2o74B6MP2HbnDDk9X1DcmY4pc35+Ul/fVsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uqyQ37bShibx+1H+siv/Bbb3hTH0e90te06o6kjFYieKd2OALRHP8/j5X7yVNeht1CI9Remh0bKL5YKyo2WY0oHHSaN3Z0sziPc0xIyTlGz9TE6RJUeaxXDk0RkwNZuqDKfy6DVl1dlJ5bQ5tlAtTeXh+40SvlKlGoTDC7xD8tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aAvFgzHY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aAvFgzHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D14C4CED6;
	Wed,  4 Dec 2024 17:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331830;
	bh=RKt8PGOX2o74B6MP2HbnDDk9X1DcmY4pc35+Ul/fVsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aAvFgzHYIDlLOJYVzEhipQsGkf3fnigAn3BRyknh0YV3AbZhirypysJPWjECX9zTh
	 ++yJNJnzzOzoMpzcjBjo45Dswtj3P9I/wdVDOZq7b18I6wSpxOU4qxwMRwz1PrUlMr
	 TrDt4Zv+XYYtLeBM7ZWmHpyNf93IVImroM14f+qALALrpMYeOCNAJZXN7Xclycaw6A
	 B9IkhBMVspZq42Japmh6icCEsM/x46ikOWIpfaSyE0F9tPraS+hjqisawhrr3RbX6D
	 a80DR6kfuYIfbj/AgwX8sdwHsWpwAN+VeAvFKzxNYehEkEWiOKc1hfTOHmAx5odn4s
	 jvQV8LFvjhZuw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 4/6] scsi: st: Don't modify unknown block number in MTIOCGET
Date: Wed,  4 Dec 2024 10:52:23 -0500
Message-ID: <20241204155226.2215336-4-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204155226.2215336-1-sashal@kernel.org>
References: <20241204155226.2215336-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 4.19.324
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
index 5078db7743cd0..c6b341415a125 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3752,7 +3752,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
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

