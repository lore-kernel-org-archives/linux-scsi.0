Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C3435C6A1
	for <linux-scsi@vger.kernel.org>; Sat, 26 Sep 2026 18:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790446652; cv=none; b=LwoNPnTr3QDXrP1JEXnR2vWRRTLBz/OTk5SqpBiH7vawGGk27NByOZcFq+EGa32eEaCpGFM+yU9pg1gO5Q1gMGiOOCs9jfzO6m0vC19/UE85uvmhYec4v+MegCKTVMoqEeHDhvrJfgDBvvi02c3TzftE0SrOWTsZUSM7tTNi6PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790446652; c=relaxed/simple;
	bh=vu3cm1mUibIa7BybWuIYaFtAY4Fzl1F0eupn0E43yos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVW+sk6gvrb8ONKNT8qiJ/o+LX2O+/DmThwHp2ip+bh/szsY4KA02HToa4lpJ3GhmoWv70wKL1CJGCrFHpYUEBrvf6mWmyhJ0f8QHZTLq/rhaVwj/tisxol/rdWAER+nKuUJb6CIeMNtkgSrTGOp9a+aChQBAKqtOruXBUnexpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B/R82/15; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B/R82/15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97DB1F00893;
	Sat, 26 Sep 2026 18:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790446651;
	bh=Qg9jbtMSc1jH34Y1/Z493AK4QWjhz3ZtlcuLTFiz0bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/R82/15anIYZ7NwX2nmWFDj7AKY9qDmfhNujIOCgFUu452430uGSv0dyEYISvPfs
	 fApCNcIzoaRDmXdw4rRZZuzpmDZFFqWt5+QNHCAfmahDngP2XddaRV8YkOAkqJurvN
	 T+kOml5kg8lj31XgPObxuYzVhGzvyOtFr8rQpfbhf3ub7S0mVKYDqXj7XweK+M5ZcF
	 5as8+aF35pSUtonJV7rewwh6B7EuJ8aWbj2HMvqIAexHHObT71tIAz1Ne/T3knoYX1
	 Yw/LR1Df57AhYgNXki+tiUiYRzm9JFez25c7fxQGoJemg5ErRAo94Z1bK87llHO85H
	 nrF49HQD6+hDw==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v8 11/11] scsi: scsi_debug: Validate the access parameters of WRITE ATOMIC (16)
Date: Sat, 26 Sep 2026 20:17:14 +0200
Message-ID: <20260926181702.508975-24-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260926181702.508975-13-cassel@kernel.org>
References: <20260926181702.508975-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1989; i=cassel@kernel.org; h=from:subject; bh=vu3cm1mUibIa7BybWuIYaFtAY4Fzl1F0eupn0E43yos=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ28Mg/n8li80ZX+sS1FINy5QkXz7A8ddhwNNzI69Qm5 YDqzQFfOkpZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjCRD2EM/0v/Pvrk2M3Zmjoz 721mqQrTQrvmFpduj2M5lmr9OlZphxkZ3sT1RUo2fnwa9kn3ZMO0mgQ7m+q1x4T+L2t1Xp2SZLy LFwA=
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
index 0ae0a6ac3baa..ef2daef1b599 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6253,6 +6253,10 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
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

