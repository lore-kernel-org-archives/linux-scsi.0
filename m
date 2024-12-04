Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9334921B40B;
	Wed,  4 Dec 2024 17:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331720; cv=none; b=EX7Ji3N2zWwgBEvRXRzhLbHW+bxTJmGa4WWe2EX58AXjX5Msg7XiA2/R6lzKLtrF8o0ntblNIv2UVzLMcFXYunPjven4yoRyF3wxog5ohoy6TX1Kxo1GXL6yuyuLI4FyFMz0RWxRuLAuzFpEcw5P7NgglNKKlFqQgGkJD3bpc7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331720; c=relaxed/simple;
	bh=ejwqXtfZhaJZhU3e0xVZPqtpKhJ91R3VRW/yQO2jiRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bfmjO8GRYWO3JP++cTtBa3ohFbC5IPt1WfRglDCWrFzqKMhpAjcVajoZ93kCGWEmeq4heJPQ6aCYXXI2Grz2GAIvuT7SShEY83WmWGIAb7gBdd/DjokQsop4DTuRxPWk1q/nkEGgK/4QgTMqERnJT+O9o7q4Y31+G1yl+RH4wVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q6oG4Jd0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q6oG4Jd0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C47C4CEDF;
	Wed,  4 Dec 2024 17:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331720;
	bh=ejwqXtfZhaJZhU3e0xVZPqtpKhJ91R3VRW/yQO2jiRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6oG4Jd0Y8X+C8xRowQdBvxlLCQAAP4FU0E8DAKs9cZu/9pq8VK+7HmWCOJJwdH7f
	 Q1+MlxkEESolOEO6uVNfekqNGB1KuLglGt4jSFLtTwuISgvJ9A7Q5ElR3dg0xGk12p
	 klIeUa9SGl7Tab4X5GH3gHG/9oyJWBEwCT2V1UhGZ21Kg1/Uo21PMoAxtlxl+rrgd4
	 FURrLOmsDkCYpqzhV91jB13k26DCWSm6u4vk6v0SS/NfNgBOKhB7PWJHFYA4ipdeQG
	 ZYb2axLPEokqOsiB0dr8mcG3YN8z9fiu805IypFwOzpU8MP4VE1cL9Wrp1VINxB8mQ
	 0gA+LmD1WHa2g==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 17/24] scsi: st: Don't modify unknown block number in MTIOCGET
Date: Wed,  4 Dec 2024 10:49:37 -0500
Message-ID: <20241204155003.2213733-17-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204155003.2213733-1-sashal@kernel.org>
References: <20241204155003.2213733-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.63
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
index 212a402e75358..1537f4a9347f9 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3757,7 +3757,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
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

