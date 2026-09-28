Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECC0442FD1
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 07:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790580100; cv=none; b=iFPvAduMEjykd4iwpb0wmPmAXrCuF+elLOJdlXXrZZ5RBCoipApk/qCHHZiI36FR6xVJnJfDQiBwbaH0JL64n/IHOkQyqaOd9sLpQvM8x+INsTRuRrMDkwCvUz/2ObbBxqck+IhfhCajaJCfK5vXOEKIXG/ClUgGHbM87q3l9Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790580100; c=relaxed/simple;
	bh=RWb5CazgG7u+M1ntv/K7Kr1dKrMr5tModU9tdcwaPBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaFau4/8auRS2tNls5ufM4JSrQd4dsTCRgRq32bh+2s4M//UKc3mPMMJ25oPRDtRJrCxj1VnhM7uteKs8Aj95DZLBQjQsj8pDdtB4syNyVdidoHzW/Tecez6IJKj3VV8zETyyekQLimbl4SPbcsY8boZYmi4ECAfReAfEfqkS9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pk69LxmY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pk69LxmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF3D1F000FF;
	Mon, 28 Sep 2026 07:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790580099;
	bh=GdDLbkvRfR/z09hnHl7sxoFUT1rhYHuL0oSbrFepud0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pk69LxmYd+bexGLSvC/7A497q01GA2P4xhXD+UIBVopUGjdodIP9+oqx274CoNtx+
	 eBxZhDzHMR+mLCXoU+jxyFzEPK9/CD9wZ5KljFYcBRVRTOjPkrLPFw41YKeh//sik6
	 LEduF3CP0cqjMfDC51fym5ORASLQnJKdkPvffZ8X2yQ4OcBqP1c1QGpjJ3I44CZIOx
	 XtqxIU7VOROZ51yhkS6MHOCG1FWWsh2zB6vboTf6Xsza3kJtvRL0bKRzhjD367HDiS
	 OlvGNu2yBuaDFtwCoARRuFbqD9RZJRbM0Ruu1kqmEihyGPNguanQ8Yokmu+0vKIv8G
	 jUvAaFZFKksJQ==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v10 12/12] scsi: scsi_debug: Validate the access parameters of WRITE ATOMIC (16)
Date: Mon, 28 Sep 2026 09:21:15 +0200
Message-ID: <20260928072102.725566-26-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928072102.725566-14-cassel@kernel.org>
References: <20260928072102.725566-14-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1989; i=cassel@kernel.org; h=from:subject; bh=RWb5CazgG7u+M1ntv/K7Kr1dKrMr5tModU9tdcwaPBs=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2iaY3tlzTfXQmxDCPeerviV3PTtW1LjZI9JtwZfsGa S7Ro85OHaUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZjIJQOG/8FBNirxkf8rq/9e i/u7bHPAjMLPenmzcva+uv/hzE1XrTZGhk4TzUXqRZs2vL+Uce7c3zDRr4fehDl5X6w2OWrzWMv pMgsA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

resp_atomic_write() validates the fields that are specific to an atomic
write, but never the range that the command addresses. Every other
command that writes user data calls check_device_access_params() first,
which rejects a transfer that ends beyond the capacity of the device,
one whose length exceeds the size of the store, and any write to a write
protected device.

Call check_device_access_params(). The zone checks that it ends with are
unreachable, as atomic writes and ZBC emulation are mutually exclusive.

Assisted-by: LLM
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.garry@linux.dev>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug sector_size=512 physblk_exp=3 dev_size_mb=128 \
      atomic_wr=1

The device has a capacity of 262144 logical blocks. A WRITE ATOMIC (16)
of eight blocks at LBA 262140 is now terminated with ILLEGAL REQUEST /
LOGICAL BLOCK ADDRESS OUT OF RANGE; before this patch it completed with
GOOD status, having written eight blocks at LBA 0 instead.

With the wp module parameter set to 1, a WRITE ATOMIC (16) is now
terminated with DATA PROTECT / LOGICAL UNIT SOFTWARE WRITE PROTECTED,
which is what an ordinary WRITE(16) has always returned; before this
patch it completed with GOOD status and wrote the data.
---
 drivers/scsi/scsi_debug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8fc515a7a7e1..f4aa4cd401e9 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6254,6 +6254,10 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		}
 	}
 
+	ret = check_device_access_params(scp, lba, len, true);
+	if (ret)
+		return ret;
+
 	/* Short atomic writes are not allowed. */
 	if (scsi_bufflen(scp) < len * sdebug_sector_size)
 		return DID_ERROR << 16;
-- 
2.55.0

