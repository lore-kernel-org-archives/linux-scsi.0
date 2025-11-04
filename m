Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E5527E04C
	for <linux-scsi@vger.kernel.org>; Tue,  4 Nov 2025 10:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762250677; cv=none; b=IwdTOYpI0lrnqQkz/H8Qbg8YqQm4C7qbTJlooQYaVwy93dyqjZP9ypbgIeJuDYabfIwSIM1zIsEmJ602yRuBE9Db+5/4yHw25hhqopnoBe22GNm1V7gq+HHrVgk9NQjoEjABMMr6FOP81rj0H/D8RfKyYXk4Urv1r6oiporeQgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762250677; c=relaxed/simple;
	bh=eEGcDJ58Tsm1y1EgJZwfHrcdc1srAfpz+GODk4y/mHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRS8RHja5bqQowlOI3xixpg7MnU+vGvrsUv0bmWtv8/kpLbaUrRCUkHxOpxHvN8Ur6Jeqh3owgnje8+ayY2RL6foU3Gat9vkfxs6AuTz+8GetCvlaqnT8oW2OIv7DkB9I9il9hJg/NYBbfQ3xmLcxr4jc7eg3NL6DGvhdl8YXCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n70YsyZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n70YsyZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEDEC116D0;
	Tue,  4 Nov 2025 10:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762250677;
	bh=eEGcDJ58Tsm1y1EgJZwfHrcdc1srAfpz+GODk4y/mHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n70YsyZPnE2gygjuAroTQyuiaHbHI6CwvD9Cx5WHR8wl+tfNASwKKZXI18SkWsdMj
	 Qx4LzOfOetYuBSM56WRFkzy6rI2kU1c7CCS7l/L2le/Kg4dmaCjVCuMx3gVeHLWT2y
	 BeSw/2+GS5h206pM4rRl4uJZcxGD3rKVdJX+o89k+rZXZ7shSiZo4AvcuaBZ9cFtrX
	 lknbsbfWVWDb6mhLPqhReufVKINzjx9VlGcZujPcZF3KYDxC+Y/y/BmnfKj8K1DCi8
	 cN1Xw9g3FYqwVJg3uZGFTEAI3/VswB5cEVKv3o6mfJNIsZJzvkbbgJsjuYICYfCSMD
	 5QseoFs9v+7tQ==
From: Hannes Reinecke <hare@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 3/4] fnic: missing initialisation for wq_copy_base
Date: Tue,  4 Nov 2025 11:04:23 +0100
Message-ID: <20251104100424.8215-4-hare@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251104100424.8215-1-hare@kernel.org>
References: <20251104100424.8215-1-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the conversion to multiqueue the 'wq_copy_base' value were left
uninitialized for MSI and INTx interrupts, causing the driver to issue
a message 'FCPIO_SUCCESS icmnd completion on the wrong queue' and finally
running out of command tags as the completions would be accounted on
the wrong queue.

Fixes: 8a8449ca5e33 ("scsi: fnic: Modify ISRs to support multiqueue (MQ)")

Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/fnic/fnic_isr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
index 7ed50b11afa6..e16b76d537e8 100644
--- a/drivers/scsi/fnic/fnic_isr.c
+++ b/drivers/scsi/fnic/fnic_isr.c
@@ -350,6 +350,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
 		fnic->cq_count = 3;
 		fnic->intr_count = 1;
 		fnic->err_intr_offset = 0;
+		fnic->copy_wq_base = fnic->rq_count + fnic->raw_wq_count;
 
 		FNIC_ISR_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 			     "Using MSI Interrupts\n");
@@ -376,6 +377,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
 		fnic->wq_copy_count = 1;
 		fnic->cq_count = 3;
 		fnic->intr_count = 3;
+		fnic->copy_wq_base = fnic->rq_count + fnic->raw_wq_count;
 
 		FNIC_ISR_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 			     "Using Legacy Interrupts\n");
-- 
2.43.0

