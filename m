Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701F254707C
	for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 05:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790486846; cv=none; b=nsoWUF2DiyJoasq8lIqW7SGoTWwoFvufimjROf91KRfz5x8hK/7P6BSW5DqowNsqF+b2ckO0cNmHvz3UPAchUh4MwitvbuvgWxHL/OvSN6DrtkEf4JkKqRY343h9ajQL9KZWOEQhtrxyndu1JHVOkkKkTIee+z+EPpxBk6LyVaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790486846; c=relaxed/simple;
	bh=w5SnuJXMb58patoI09tCXXiANZSOGrZ7WFBS7FaJq+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJ5IHmsnbrGA915RdHk678L1bS5ZsdxiQCCKILLZ1RMZppIafOgzzQULoKbqQ3ls1UXBeD2iUmgUrMcfNHMu0WwnKGWWMatG4DY1u27bM+cq3D4UiaPWqXA63GDlm3nWvHXye6YSmHXM/QfSM4MKOsA8/8JiFpBYdYJ6thZJ+kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KQxtrSco; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KQxtrSco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7BB1F00893;
	Sun, 27 Sep 2026 05:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790486845;
	bh=PvBnvZBsEKuSNzB9iG6vuPoO/6NixGL4wBPZ7h2plWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KQxtrScoOIKcWMaQe229JasN15KnEuPPlFpww8LucTCcOJ+Olj5Hrlqxkg9omVQQE
	 ltLEtdsfpcV+Qhq79p7JlzcZB0N6BN5cTcUvNxgXjPgSA2d5Am7irykpwIuWSJzDzh
	 QGnuwTuQqfadYggk99jPBaNAvC9rgsvHyDxxW0blyEE9LlaIHL6Yaga5nbPQZg08t3
	 xiR9n2lJMp/F+Kh4qi8ncT9JT9ybZ05qaKADwSld6DvwamUeZXAIsgRS/Fnn0TSIau
	 63+X/CU+mH1Fhd3hDe9piQyQqS/CIev1LrxyTYBGmdw90inx9M9IDF8uwP8ucPmiyv
	 VXK37K4PLFH4Q==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v9 11/11] scsi: scsi_debug: Validate the access parameters of WRITE ATOMIC (16)
Date: Sun, 27 Sep 2026 07:27:02 +0200
Message-ID: <20260927052650.567035-24-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260927052650.567035-13-cassel@kernel.org>
References: <20260927052650.567035-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1989; i=cassel@kernel.org; h=from:subject; bh=w5SnuJXMb58patoI09tCXXiANZSOGrZ7WFBS7FaJq+4=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2rFSolHi0/ffziwGzJ3WyZ3/z0hNvF7697X/WiT0tc jprLwUJd5SyMIhxMciKKbL4/nDZX9ztPuW44h0bmDmsTCBDGLg4BWAiztWMDK8P+RnaJ3tfci5t qPU6vdu4XW9rs7/gtfT9uxf85BaQyGVkuBi2ePfSkkwhK7HgH7x7l8xn8eqSeDTNaGV4WFl/yrt XjAA=
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
index 11f2565fb676..e4ad689da45e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6252,6 +6252,10 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
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

