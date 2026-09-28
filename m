Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EC5411F8D
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 07:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790580096; cv=none; b=KzNiC7N+gQOujfT2XtwbnvK739i1mocO1bG+dZ+/xYS9Ibl/Yec0wGVJi4m3VAbheEHodkpl2a7lq2VVEOgRk+VAPvYfsTvBvOiRqNZe97baiEgYM0zk0aK6I923E9dCexj/r4iP+cr1NHbWYp5y30s4xdRbiZqT5fNUSKSjWlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790580096; c=relaxed/simple;
	bh=iwp7920RUASa+ElioPKGBCaqucvuBQzWweeZp2CHnLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIHCm8CrAxvvLV7bjfqdoR1ABllxHrE8PRlY6lil1uEOfrqOLR9b4HqrgWLrYZLvR4q4V1oPx6feuxLICqi0DglI/Tldkhe9bOmbYUgrpOw8TIbjohsyfgRPBz+maCBiDauMKASGl5sIiTTKtoBaDlO8UgsaOB893+cVgeKJFUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C0d7fIFU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C0d7fIFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6351F000FF;
	Mon, 28 Sep 2026 07:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790580095;
	bh=Hm/WbzD9ZeifcpbtRib5vJyupk+ZPd/JShbgPCMeRYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C0d7fIFU5Dc4yetaFBIGwLIKmwXZTD8VPgHlod9TGyLZw5qYfp5YIKDOnALASQcD8
	 P1C6J5MaEne240TsfPTtgFZqx7fo5RseaZFtS+Bkqv6d3YjnG0ogwz7lImZP5mch3G
	 52tQOKbBAbxNWlHgaLG++OJxoE4xqs+AD+Rh68b9Kq/DSZ0/wag3/b+1LH4dtLh4uq
	 sdNj/oIPnHj3E4FcAZehUk65AwlzALRrNLpla4pzIsNb/mGpg/OuhSmdMVTVIEMEYm
	 LFewl4lbDwWAP1uw4H79l0/+WcWKrBfO8xcnRl/dVIcS9nqJSKTbEsmBohVPqOkRLz
	 sYxb/JZlpCDFA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v10 10/12] scsi: scsi_debug: Refuse a short WRITE ATOMIC (16) before writing it
Date: Mon, 28 Sep 2026 09:21:13 +0200
Message-ID: <20260928072102.725566-24-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928072102.725566-14-cassel@kernel.org>
References: <20260928072102.725566-14-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2138; i=cassel@kernel.org; h=from:subject; bh=iwp7920RUASa+ElioPKGBCaqucvuBQzWweeZp2CHnLQ=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2iabvbOgy6dn0z2HfVh52/TIWXh4vCWcuj3flKzdOV 8+eLKrYUcrCIMbFICumyOL7w2V/cbf7lOOKd2xg5rAygQxh4OIUgImELmT4H6YeEyf0/u2VdQcd W/uSDA9LMj64zfGiZpJ9Vck3l0MbtRn+KWs8/+Wb2NF4dVKim6un7La/NgEei5N+e/MxPrq9Mn8 2BwA=
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
index f83440ab7966..8c8b409f921a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6248,6 +6248,10 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
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

