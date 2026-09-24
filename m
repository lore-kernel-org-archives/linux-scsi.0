Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3456366055
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 11:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790248918; cv=none; b=aQavxGXHfIXCSalQsJABdlRTmwYIlMDuBdj0mqBlHdqkPCm/hzk74UnAAmyrvt+p5gXcSuVq97T0DY23vLP14CBSLNT7D9kV2pbuw0suFESV/RLsnYQg3lTU5nX9NZvAnGED8aVqqDYHndH8iZAxOG+IxrHfAQnky6kDIiq0Ukk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790248918; c=relaxed/simple;
	bh=8uOL2XVYEiwKAWOp+8ehi1si8K4Zf30OcEiibVf7HsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJIIma8Dc1/6p2oIzDjeFZ8nUy7vfkjZ5YRCkFgjNufE3BTXvIhwBDbLQcKeeSpWfnu1TK55LVF7ND2Hv9B5FAipWOGx+PHtSh0DrJL94i8lryV1rA2GO2HX366ARpCn7M7EqJaiSbf1Mks1bcjmDiTu6iE+Fywjz2tAt5NFLBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WyikyCNt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WyikyCNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B3B1F00893;
	Thu, 24 Sep 2026 11:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790248916;
	bh=5rN8ZFVF+dl9Inh50EKp7pc9gGDQt7riQGmLytMYiyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WyikyCNtKIvTlHds5BbWU9nsa6tmHtqzkdIqD73M7sCDY5pnQmnOcYY07p4cMAe/g
	 ZAXnEEgz3sCLaDIiyEH2KGAaBuXix8BeIxzITNrtKyAh+3qgNAa6yqRm/6kiItKQo9
	 F2gq2fxs1lrAVPKLXS45FGOgzg8ND4YiAjq7cB8PyKm7EAFfxa88XIgpwOBepmEObd
	 +HsbbNKBRERnDUC/LtuSJvhUyosoZj2PeLqZLEom04uOMLjY5RvAa8kajtZNw8+F13
	 THznUg/EkGYuU/c/2Yv9t7j6K1i0Y2V91C5nGSaPlc5wjhi9hVu+mVMJRLJaRGZCpJ
	 ocr9ACE4seNeg==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v6 09/11] scsi: scsi_debug: Refuse a short WRITE ATOMIC (16) before writing it
Date: Thu, 24 Sep 2026 13:21:37 +0200
Message-ID: <20260924112127.3815255-22-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924112127.3815255-13-cassel@kernel.org>
References: <20260924112127.3815255-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2125; i=cassel@kernel.org; h=from:subject; bh=8uOL2XVYEiwKAWOp+8ehi1si8K4Zf30OcEiibVf7HsY=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLK2su+xTpvZv/lCcRCT/q6bH45vYLj46VKCYIB3d/IES T73wGUzOkpZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjAR5jhGht4tS3dP7cmTK/gU Nydk0XWF479nTA5ufObSofnu5++pVRaMDH8eHG9+P8vLTsvy0xqrF6bFv7IjGh+tmfu3IPVIC0/ WVWYA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

A write whose data-out buffer is shorter than its transfer length is
short. An ordinary write transfers what the buffer holds and reports the
rest as a residual, but an atomic write cannot be short: SBC-6 r02
(T10/BSR INCITS 587), 4.28.1, requires each atomic write operation to
write either all of its data or none of it, and 4.28.2 requires one that
cannot complete to leave the LBAs that it specifies unaltered.

resp_atomic_write() does fail a short WRITE ATOMIC (16) with DID_ERROR,
but only after do_device_access() has returned, and do_device_access()
copies one logical block at a time, so by then the blocks that the
buffer did hold have been written. An eight block WRITE ATOMIC (16) with
a buffer of four fails having overwritten the first four.

Check the length of the buffer before writing anything, and fail the
command with the same DID_ERROR as before.

Assisted-by: LLM
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug sector_size=512 physblk_exp=3 dev_size_mb=128 \
      atomic_wr=1 lbpu=1

issuing a WRITE ATOMIC (16) of eight blocks through SG_IO with a buffer
of four blocks of 0xaa. It fails with DID_ERROR before and after this
patch, but before it the first four blocks read back as 0xaa afterwards,
and after it all eight read back as they were. A WRITE ATOMIC (16) with
a full buffer writes all eight blocks, as before.

New in v6.
---
 drivers/scsi/scsi_debug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index af1b27b48867..3b112ad58489 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6242,6 +6242,10 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		}
 	}
 
+	/* A failed atomic write must not have written any of its data */
+	if (scsi_bufflen(scp) < len * sdebug_sector_size)
+		return DID_ERROR << 16;
+
 	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
-- 
2.55.0

