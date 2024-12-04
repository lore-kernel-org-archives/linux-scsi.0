Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58508226750;
	Wed,  4 Dec 2024 17:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331788; cv=none; b=X7Kjt1Bg4ZslmUnFTI2m36rqywXo0GPNkzOnj2oWTKMsGAsCOOe5luFXthGwLzpJAITq2GzGS+IbTo+WSfdkwsopMzy6kr1D+SWyeTnwrfsyzwmpXwDiKC4691v7vVZtDMX5oqjT3qIvfgaTtmImcl2Rvhp0FNpabxoAeVZAxWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331788; c=relaxed/simple;
	bh=b3q143f0WN8SOp3K98ejxkw4u7S9SDRMRRBB3LDdzG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FQ6pFz1PZEgNisUK6XiiteRbOeviaEI44k8hqe32CPDDOk9NkxMAXpo2DR4zDDpcLTE0iFqBnd8sRJ5EA0AMngj0vZx4E94xLUVCoWEofqZ4SNHgplwbS8r4T+Guvtc+o0SMKamlLuAyIwr5sbOMkMZvSAjbpp1iHSuzoD9a7Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GFPwMKsO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GFPwMKsO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F75C4CED1;
	Wed,  4 Dec 2024 17:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331788;
	bh=b3q143f0WN8SOp3K98ejxkw4u7S9SDRMRRBB3LDdzG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFPwMKsOEwoRzhE0Cy22bNe32CrLzEWlwgtJbNS7i9YefdThhGWTxe2WBigYEleOV
	 a8uTxP3EoR7Gzr6Xgw0JghAqtzn6YyxLuZDAboXJK+tW9ZuGYT72OSoEKW7fS6NhKu
	 0kHXtxEANN0+bwwE1QYqNNc+NDtQnrAR8JmaofDlbENSy2pU2vKR7V87OR+vHaVIJp
	 0UF3zyyE/a73re+JP13q3+azqtElEFZq/Sz4dVB6W/C6T7JV51fvv+t2E2LRLfuusT
	 AmD80RF94lcYy/dcCZWHG+pcSv0at3xpBEU1/WWVgg/XnqjaIsTE13YJc2SbvoQRGX
	 Oua4vOACsov7g==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 6/9] scsi: st: Don't modify unknown block number in MTIOCGET
Date: Wed,  4 Dec 2024 10:51:36 -0500
Message-ID: <20241204155141.2214748-6-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204155141.2214748-1-sashal@kernel.org>
References: <20241204155141.2214748-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.173
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
index 9933722acfd96..861038a1cbd48 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3751,7 +3751,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
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

