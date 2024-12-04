Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F732111AA;
	Wed,  4 Dec 2024 17:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331633; cv=none; b=njcG1o9efXrmLN+F4Vlj+DvDFCan+HfWENhncGX5F7U2InFENU8pkOnqa+6aoVCfV7d1L7a9zXk1tMYS/pP/+GsSHz9GpQGhYmejQWEPZKMJzbJ+WDZ/Af/UmkACaCanSurpBli4ytIQKDKU3vEF7kgNikqzvyCKwjsGSi84vN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331633; c=relaxed/simple;
	bh=TbC2tijX1+gmVrGjKwaz2toPdWdkdhjBlUFUoblJ4PI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZBdv6gu7jehHLcuuTczu4JLyo4izA3BYGsptK6t4klF98M/SF1zFCDASWgkrfGP1amUep8absb4gbqCh9GsP6p8F3gM6H8lhbeyyDklpliuJiFUAQtxJ9hPeLiitra6TXv68k+UAXG+Hi3BwAKK6ZAvQqZQ72khmHEyCCDAz94Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c53u1cNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c53u1cNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D891C4CECD;
	Wed,  4 Dec 2024 17:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331633;
	bh=TbC2tijX1+gmVrGjKwaz2toPdWdkdhjBlUFUoblJ4PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c53u1cNaR/z43Klv9CNUnG6eq7fva7zE2bprMB/87J8EzwFPnPqPHNDzMF34lfOyV
	 lBxzG/FUl3NCrHrQXQZ65UuvLsnVM/kOCRzEMXisCXS7GnHgUz4RqyUh9i4Js0iKyZ
	 KVYDk4adBQ8Lice7Aw++cKVhMeGDc58AGIWDeA+SEXybSh02eNsWJYUveenlIRPiRh
	 uG9Khot5g6wFfFMT3v8A7QG47eFrWK6Yz5BREhplN3nwxAsBrNzq6CPAMs0iQzjmAt
	 KCNkRuvXER7SRO69N8pkPpl7sHZieOosFAyNuajPfHG9JbCojtcW2M7fGwgOgmMR2j
	 D3BaT/bO5i0Pg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.11 24/33] scsi: st: Don't modify unknown block number in MTIOCGET
Date: Wed,  4 Dec 2024 10:47:37 -0500
Message-ID: <20241204154817.2212455-24-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204154817.2212455-1-sashal@kernel.org>
References: <20241204154817.2212455-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11.10
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
index d50bad3a2ce92..9f480a1b4a81a 100644
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

