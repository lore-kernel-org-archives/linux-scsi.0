Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146CC3E51D3
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 08:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790670385; cv=none; b=IEc4gQtyobh2v708VFpi7gTZHmMIwEsmfxZa7TxybX72RY+6W7V0v76tGZuzV8eSWgW8Vt6YHtyX9gxF0Jsw8sonQTg6YTcn3pSXzKu2Hmv6oPDbCk7Ds9sXQCohcMcuoCfun43p1IB7tpFCPXSdEL88nLzixTszUQg4uz6BGnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790670385; c=relaxed/simple;
	bh=kNn8aGGsldIU/id/2VOvdBYXiObUGFtNgBNkFkhlqVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpiSozOZ3FNXPEOK3cke2yLpZLTEylVkjERnzImqiwJW79IJfX0zl6wML23ksPygoIxjUe/H+W/jYa30CHRfHMM/KwDTj4ZTylr+yJmCHeiudoC1DGqyO1PnAkFHou+bj9lG1tIom7/sKvoq735bSQQqNSeS44jiPClxaP2xY+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JIhiTgON; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JIhiTgON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E141F000FF;
	Tue, 29 Sep 2026 08:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790670383;
	bh=NO1BpzEoXDsRYtCyLvzHwo85LEGSXSKwgeMMPzUsuE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JIhiTgONkODp4oZmH41h0ZbKbuCzOXCOeu7HRz75QjdAmIA2oCnriyEHl4VD2IKR1
	 HVrJzkERk3A2gf+ta6fFVYtaRAie4p11YHTDwXirKXa8wYKqPjUkY/i35SfMVRZZw7
	 eBgu21GEfCYhqJODb28XZep9hFOxHqeQISaGtZRbLh/EbNg6fSh50Xsohk3cR8LDFF
	 EvOmlboygdUm0cARbBBhIFu6L0tfvbjtlGnhVI16Pa3viF52rTrfcRp15Lqtn0ORjL
	 R5L8dIUUUpP+zSpNiTGRAXwM9p527SJX6/CAW13ybiMxRTyYiCWbfwUBPZF4tHfRfH
	 czz74Te12oAQg==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v11 13/13] scsi: scsi_debug: Validate the access parameters of WRITE ATOMIC (16)
Date: Tue, 29 Sep 2026 10:25:10 +0200
Message-ID: <20260929082456.857423-28-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929082456.857423-15-cassel@kernel.org>
References: <20260929082456.857423-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2009; i=cassel@kernel.org; h=from:subject; bh=kNn8aGGsldIU/id/2VOvdBYXiObUGFtNgBNkFkhlqVg=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2l751WCYscXcV37uLDqrcjJFzn13J/7FMvfZxuBvjN /0tz2slOkpZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjCRKXsZ/hnyRvme33v9oYz7 nnrbbcwvJM59azaZzNYu+KouZ+mGCBlGhsVe0y64HK5w/SFhZSPVZ51WHiOXJWEcpxD9d/KFGQU ruQE=
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
index 87ef71f18f2a..e679df1993aa 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6256,6 +6256,10 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		}
 	}
 
+	ret = check_device_access_params(scp, lba, len, true);
+	if (ret)
+		return ret;
+
 	/*
 	 * Short atomic writes are not allowed: SBC-6 4.28.2 requires an
 	 * atomic write that cannot complete to leave its LBAs unaltered, and
-- 
2.55.0

