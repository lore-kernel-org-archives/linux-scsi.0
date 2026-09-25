Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DCE1DDC38
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 07:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790320684; cv=none; b=DlNgkixlEWP6EMsLTKohHeHTkK7YhKyHjsL50jcNYgKQT2UPBwYCiHOaSEw7S2OGx/A/YfiatgsDQ3hCPKiGEu0xzi4NETQ9WOManIUTTF46kzccPLZNn/+qlE8eNM9qINB3zf65JMFoP711az4R+1HI0e3P22deoefh7KmnerI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790320684; c=relaxed/simple;
	bh=DNXXmXZZcTK2k8h9Oqe7vT+8Jjghyb0JCfelB8tNEaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIGFjw9nOpa8oj/X9543KpYm9yxPM9alivFqDCKYEg3rxdm6m2ig7QkXEQ/xaHGz5EF2TLz69qEw69J6BrZpB9XEeDo8EqUrWHJFY8B9G97cBcHpHYeb8HM65ySYKW9ReqU5PU7Ooza38V8Gl2ilnVWJ6d+h16ofiQmoG9k6SA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bHr94gMs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bHr94gMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7462F1F00893;
	Fri, 25 Sep 2026 07:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790320683;
	bh=VVPqIn4GasYOFt4RYVmiU9NBCYwNCfyWRlwpn3LTXR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bHr94gMsUxl+X1EZ/xx2/6ZjaaQDffUV7dM+HtOIYDwcGwvdPWhwe0CXccUJEz3Qn
	 Ws6FwbkDFWhP7BX0JCJfbC+w1SUD2FP9i8MlvxVaCEx3zdcb2cJJe3t/g/CbjOqEet
	 rsEWRjM5kRlk3570QbzSUBYgY50O/DIixKwE3/RITH1SdiN+mrsWaDutccBqe3MPHA
	 e0gJ4eRQ/QHwd1uUf7Xheii6z0XM5oIFay19xEM0W/+9+AxJ9Fezw0VYZVnpbfRmgX
	 goX4Sr2ZtwoV6MioUAoe08fWxujHt8t8SlryRfyn3WKL3HWJZ7LdjGr7TbY9xQ2Gas
	 5Q5FSI6EbVM4Q==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v7 09/11] scsi: scsi_debug: Refuse a short WRITE ATOMIC (16) before writing it
Date: Fri, 25 Sep 2026 09:17:36 +0200
Message-ID: <20260925071726.140915-22-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260925071726.140915-13-cassel@kernel.org>
References: <20260925071726.140915-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2205; i=cassel@kernel.org; h=from:subject; bh=DNXXmXZZcTK2k8h9Oqe7vT+8Jjghyb0JCfelB8tNEaw=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLK2KQifmtMQs3rditKlmjsrClgT/C9bTP/sm8XewiqgJ r/XSKW/o5SFQYyLQVZMkcX3h8v+4m73KccV79jAzGFlAhnCwMUpABPhv8nIcOPWqQU8X7bKc/LX PlOXF+kuZ756r77k9c0PnQbZ74MsvBkZ9pV8+MdzJDP3ncx7B9O71nP6TxTfi1fY8plzlpnoh9n cTAA=
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

Changes since v6: the comment is reworded, as Damien suggested.
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

