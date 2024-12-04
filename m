Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8625228D69;
	Wed,  4 Dec 2024 17:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331804; cv=none; b=oh5RlsgysZW9z7dIKm9KCeFAxY/m3w6ynr/bc9scfy4lonWXngmYsxa72AVUApc+eq/8sHg3dLllE59nTxo7WQOGaIKnajcGGk7ItDl2Bmd3bizUVjHZOCZ7YBzmxHBVlLaUiWHdVYo/FF9bYgSo0GhhU0ohG3TVuFmiXHBGARc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331804; c=relaxed/simple;
	bh=uyo7OjNeBjgVtE6zq3cx6d7eVkm/3V7gArCtEQpjnuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BqxmH2DBI0zNyJDrSHY0LWOd5g87nuZKHdOkplDxpijpEnXw/dCh8LUxZ/sx3jkY1rWJctyviNpNPHY9NxQa5SwrBh8iaHNo/CB886YWVoRCX3Su0bFq657L4gJBqkF7c+Jo5/zr53zph4ObKLqvsC9uolYXzpdrSR7DDEH9HZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hCD002tu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hCD002tu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA221C4CED6;
	Wed,  4 Dec 2024 17:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331804;
	bh=uyo7OjNeBjgVtE6zq3cx6d7eVkm/3V7gArCtEQpjnuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hCD002tuy4U8WLbrU4fTp5d5GlZBxmV9m8tDA4BNMTlAp5Gt194r+2mOdztWQzwBq
	 3BPGpAPNf70ioBltb7IPIPKP4g8Ng5jruAqsh4QhBzkrdkB1JTuA941U2E0bKgaPw8
	 QFhgNetnjuq5PUUCTurtUUTfwhI2738r6YSxYUALoIF43goDV/JpdtqVGrRLfmnuyv
	 G2CFUDdRPoVKEq4nJgEQcbPPg1zLkJ8C0gQgUXgytCajylYjvtxiDZbC9c1bK8qkO4
	 KaIvk1oBvtjJv9XxNSxQ3nOEt7Tsh4/mHixlzl1cheS2FhXRMW/rOy2ivdvIk7YC29
	 wN8fknxc+ezNQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 6/9] scsi: st: Don't modify unknown block number in MTIOCGET
Date: Wed,  4 Dec 2024 10:51:52 -0500
Message-ID: <20241204155157.2214959-6-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204155157.2214959-1-sashal@kernel.org>
References: <20241204155157.2214959-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.230
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
index 19bc8c923fce5..c08518258f001 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3755,7 +3755,7 @@ static long st_ioctl_common(struct file *file, unsigned int cmd_in, void __user
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

