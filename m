Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23F42DCBE3
	for <linux-scsi@vger.kernel.org>; Sat, 26 Sep 2026 18:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790446648; cv=none; b=rxBB1kCeEmNi4LTY/KdDb9GUXEDTM9mdNP3HQiBtN9yQLOtXJVwH74W9dsCixYBXlzgRMBkak81L0+AF648Kd3Hzd09gXgCei5th+zY+4P+N2F33xA9yhI+rcDMliop51LfSd3AuhfUrOlSNHmynnn+bYVCK3Duvpz3JxAuFu/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790446648; c=relaxed/simple;
	bh=XDtJLFNrVC/gjO5jWzLnxGgD4utjKUeEcRiXboMy3Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAqDAKaZmEVb33gnhv9982EbLrMs+L0BsyrMRIlNNyC3XjTiUvpsw4kopLr9wib/5AnWxakGlsDRuXFQGwGqrheB22laTgO8LW9cWUS/ZEiCWJk5ia7PVrw4acj8nTeNUhx2HZkh3Sifd/KkmRYiEnpeGhplZGi4oTQ7MjcfO0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2I6q09h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2I6q09h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB431F00893;
	Sat, 26 Sep 2026 18:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790446647;
	bh=MjKWYQp7OTkcFt8MK/rsKmXJNGkeFToYigwaSB4EUeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U2I6q09hwwgIExgLfVLUNFhU3kBIXSZxB3rn4g6DN7LOza5ZhTdVvGk1pDfkgj/av
	 kFUR6bbxpqtUsLdbEQIxrwVvikENdIwGIdXBs76Z2kKRKPcMi09OAlLDcjyoTmQFjn
	 3NNii188323bC735W5YeE+o5iL8Zbh/WDkAzldUWjlATh8A/eniQxzCUdOOSSobUcQ
	 AZzgxrDck5VfAnwzeMhBi90Jja8csgTZ9n0Mi3j0pieLHzd6H2DGpFeA1oadK714+2
	 zxwfnXyD5XZQklC67qy35mxkcTJ+SeW4t2GvX2QVb1TQxDwaYYgdypJxi+151pAR+V
	 rDh2qc3DgBmIw==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v8 09/11] scsi: scsi_debug: Refuse a short WRITE ATOMIC (16) before writing it
Date: Sat, 26 Sep 2026 20:17:12 +0200
Message-ID: <20260926181702.508975-22-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260926181702.508975-13-cassel@kernel.org>
References: <20260926181702.508975-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2138; i=cassel@kernel.org; h=from:subject; bh=XDtJLFNrVC/gjO5jWzLnxGgD4utjKUeEcRiXboMy3Y4=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ28Mg3ZnB2hJUtcEtzMJZ2lRTw4F9qP0ex+511Zo/p/ hUfddU7SlkYxLgYZMUUWXx/uOwv7nafclzxjg3MHFYmkCEMXJwCMJFtDgz/65kWHvSUtmxunHPY +uMSLuNNfx9OFogyneX05t9sXqWAOIb/pd3Pp76/6L9ZYmmzSPza77sOcKzZ6TJ766ufV8VDjeb I8gAA
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
index f59c4f11c851..c0bcf8155fc8 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6247,6 +6247,10 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
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

