Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B034A21
	for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 05:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790486842; cv=none; b=mQGnJOyAhcLXkaADuaHYKf2aMSd44wjMYwdbMTPLQ+xV+yHUuFDqm29N8Ajb4rdQNf5VQLcyZQKQTUSoyLb7HfneHCpper+UuJUVYa8+FXVEty4PqUi5xgoD5hNueNPyCpwHznAFvY1MqTmz0YZEtFEg0yqtzU0k69UY+orUgsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790486842; c=relaxed/simple;
	bh=JzmA3Q2BVEa8eyn7VB9CdYPujXV+fJf52MUxn/3RJEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mi1GhFyX4uYOi/lE6mMHFEOKslc22d/kPdnqSMNCEq07dUMMBUnPHKGhhWY+sS6a5fNhu8t4hDT+7nl+kBvNjr3JLWxi1nYegWhz0LytkniEsawWPKAn2UkErAv6Uj5zDAx/pZN+7EvQJokzWv5C2GUsJReyBLaOL2Rx3EqEDSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hiY2f1KY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hiY2f1KY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18031F00893;
	Sun, 27 Sep 2026 05:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790486841;
	bh=AkC4b0boTBafXDnhe2PlSIs9ANqj6Cnt+lAin48hYRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hiY2f1KYe878DPWWayBM6lyymzkbH1UmYKaX93NmOM0jICgUqh3uuinF8DgbDmXJz
	 xH9uBK+snL9gbuh0idYG35Oc5injuWz6QEZ21KtxVQp0Seskog3ueKYP7xMHTMhKMp
	 ZiSDw6Jk8GppO7N0gRNBomJhWluO5FoLt5nRPfL6fSVkfncju6novr7iazd6WvX/fE
	 QiHp5WE9FyGFDgOrxrhTlDeKOka0h8SXZSaKqZ9V5fW+VBC0vOZ/MjXp3u2KD1CFe7
	 kX7PFxJPhA7TD9fNI/cwHynGkAz4iygK1yJwqHalB6Q3aYSch+1ExbqdElh3RRcS5s
	 IUEBr1XmUHqNQ==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v9 09/11] scsi: scsi_debug: Refuse a short WRITE ATOMIC (16) before writing it
Date: Sun, 27 Sep 2026 07:27:00 +0200
Message-ID: <20260927052650.567035-22-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260927052650.567035-13-cassel@kernel.org>
References: <20260927052650.567035-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2138; i=cassel@kernel.org; h=from:subject; bh=JzmA3Q2BVEa8eyn7VB9CdYPujXV+fJf52MUxn/3RJEM=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2rFQQ3f7+xLM9fL8tbFd6yBruPs99VnJWbVhxc2z0t kkzVh7q6ChlYRDjYpAVU2Tx/eGyv7jbfcpxxTs2MHNYmUCGMHBxCsBEossYGfpdvXamHlU9X1+V NGf/JIsta4/8CBWJsc8uSqnVuBn5UomRYf6jR/PjjDXm7RYzOTZL5NVphubWsq3G0nUWPY9YGI+ d4wQA
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
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
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
---
 drivers/scsi/scsi_debug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d18f0d71aab6..1753b7b087b3 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6246,6 +6246,10 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		}
 	}
 
+	/* Short atomic writes are not allowed. */
+	if (scsi_bufflen(scp) < len * sdebug_sector_size)
+		return DID_ERROR << 16;
+
 	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
-- 
2.55.0

