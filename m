Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792484477;
	b=PxCNSnNHvJGQrzJkiYKMuhY8dy6DiVE4Y87snmp+x2qqsxPKAibTfACEywGkYWbngG+v
	 1bYUjuGDn7KFe2fe9vhNwS2WtQkJSZAy0rGEqztMyCpf1ZUDvkBdXyMXgOYMr1di3RnXC
	 abeh5lyPTbTJ8/SyCH5QGcnf4zjsbLw9rS2SUGFv01r/jLyw/vzQisoGyMFn5t4ZYUC7L
	 Jn+UGiFjSVkhzMsAaSRkR6pq4VeBNMbKa8e9G2stBD/slnK1nDFVu0FRIL7/M3Q3ywzYq
	 QFGCsw8Cys38TXr/NC78FgNvVhTvXNtl1PNdALdQEVz3gQGawESImtWh5dFOKL9JLnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792484477;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=bOhEbwUJi4bXgBOzn/aZFjCG5VkWoZITBEOlQpgBdNY=;
	b=VkoYDQJLcP2mbZ2uB2GMLwzEMXXGuDPhlJMNd1rBOghxkMwSk6GgxZKeOjY47ZgHu7Kx
	 8mlh4s8wiVSDMPaTDoAajILScDULn3DaHX7EEX7ReHp4t+PnVEJ1OSd+QGJBz2lTUyTY5
	 GKdQSZk5nZ56hg1P3dDdQKfGSI9NM8E14S4yQZNphOB2aXT+2cX30kYJQeGQpnDbhBoQb
	 1GN8tSDNzdxkX5rOGf5LaPb/v4Q3GB3yvaLNOOHQXDKdL2IOARnT48kJhQtUeO4Q2+Cy+
	 7L/k8X4Ip3YIAvGXGoGZkzfNt1TRtVUjILBCe2Ffj/PJailXw3hpiNgcUuqkuka1bow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=aTucjw2V;
	arc=none smtp.remote-ip=209.85.215.198
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F50C606A339
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 08:21:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F50C606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=aTucjw2V
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cd68bf391e1so1189021a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 01:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792484476; x=1793089276; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bOhEbwUJi4bXgBOzn/aZFjCG5VkWoZITBEOlQpgBdNY=;
        b=aTucjw2VtKDFdi7pkuoZ62aDzE6C64Ax1Z5eZ2+K7Xr/uKODTA92T8b6hRUf5OOWLT
         g7C8vU5/QKIJhd0iOHHa2BnjmAtmq0brRZRqNOUE0+GcwXQMlHvjzC3L3Cm3320rdVeE
         4rtKYnHUQmyMyhFiJPUzq68OARmJI9/nxlrwzMF+y1HYZ+nQa6uR7Xtzv1hj8ymMDVWC
         8Z3drGn30uu8HoIVSCbQWK7dtByxw6Mv+OHL3Yn9CkQ8HXGcpD0yXZzS1sNz7PMGPySH
         /5trrg5xmsW1ck1fJ/TQ37K4mQa5YbiT10Vr16W7yPilg5N7SdfDeAr3TSx9pqoyCRwc
         2bZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792484476; x=1793089276;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bOhEbwUJi4bXgBOzn/aZFjCG5VkWoZITBEOlQpgBdNY=;
        b=hCxEDRC1XlndcK5RibXOlBJmGRvD7rGYksjc/41s6ykJTM3W2768KBK9Dw0OwVkWJq
         O04LpQynRtfls3hLybWKVpkp3HrblDbqqW4JhEtB5SHUC2OC5svNSnnEeZYDu8C0Gti5
         Pkq3bCNPzRTuAZbDjHGilhR0AcmOWmgv3WJ65+J8bIajHFE+V9RSQMty4NRDTLp5BmW3
         lMXyXuR98nRFEs4Ph2+Ss7CB/tgp2K1YIJLBnOyIcjOkAJogqxCTvjSO/7WtLZ1xX6sn
         ISnhyk89HGykBimw9cYfsDafVMy24LfPvb9M+NVcK63co3n/Ts0f/RV2FGfueJAMIxgc
         3ipg==
X-Forwarded-Encrypted: i=1; AKwUvBw1P4PWBPgq2SkRnSUkxRlXKxT2BVOLD8pqyFdVJ3Ec3vGoW2dsY46EHQbK7Cv0jFGpPFWvfvleID5J@vger.kernel.org
X-Gm-Message-State: AFq9FYItZHTRMMjrHSwwuCMGwHF4O7aksgswAVg31ExvagCzb8qeJPTk
	gup9RW+r6J1pScqztLRICUsQfSqSfvdfn5pWEFWae5dnKV/7jDD1sysXKhPKv74JOHJh7sPK5kI
	Z4tMuHBNMN3gw3Goiz1qJxQ==
X-Received: from pgby11-n1.prod.google.com ([2002:a05:6a02:650b:10b0:cd6:1088:b8f3])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3a87:b0:3de:5ca1:dfd9 with SMTP id adf61e73a8af0-3e225d756c0mr7289397637.13.1792484476084;
 Tue, 20 Oct 2026 01:21:16 -0700 (PDT)
Date: Tue, 20 Oct 2026 16:21:05 +0800
In-Reply-To: <20261020082110.3511797-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261020082110.3511797-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261020082110.3511797-3-stanleyjhu@google.com>
Subject: [PATCH v3 2/7] scsi: ufs: core: Add a helper for clearing hba->outstanding_reqs
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

ufshcd_poll() and ufshcd_abort() each have their own copy of the code
that clears bits in hba->outstanding_reqs under hba->outstanding_lock.

Move that code into ufshcd_clear_outstanding_reqs() and its locked
variant __ufshcd_clear_outstanding_reqs(), and use them in both
functions. No functional change.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/3779e125-9acc-42c8-9489-51b9e3c6716d@acm.org
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
v3: Add __must_hold() and use guard(spinlock_irqsave) (Bart Van Assche).

 drivers/ufs/core/ufshcd.c | 39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 12aafcf1f9b3..1b28dbba03a9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6052,6 +6052,29 @@ static void ufshcd_clear_polled(struct ufs_hba *hba,
 	}
 }
 
+static unsigned long __ufshcd_clear_outstanding_reqs(struct ufs_hba *hba,
+						     unsigned long mask,
+						     bool from_irq)
+	__must_hold(&hba->outstanding_lock)
+{
+	unsigned long completed_reqs = mask & hba->outstanding_reqs;
+
+	if (from_irq) {
+		/* Do not complete polled requests from interrupt context. */
+		ufshcd_clear_polled(hba, &completed_reqs);
+	}
+	hba->outstanding_reqs &= ~completed_reqs;
+
+	return completed_reqs;
+}
+
+static unsigned long ufshcd_clear_outstanding_reqs(struct ufs_hba *hba,
+						   unsigned long mask)
+{
+	guard(spinlock_irqsave)(&hba->outstanding_lock);
+	return __ufshcd_clear_outstanding_reqs(hba, mask, false);
+}
+
 /*
  * Return: > 0 if one or more commands have been completed or 0 if no
  * requests have been completed.
@@ -6071,12 +6094,9 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 
 	spin_lock_irqsave(&hba->outstanding_lock, flags);
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
-	if (queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT) {
-		/* Do not complete polled requests from interrupt context. */
-		ufshcd_clear_polled(hba, &completed_reqs);
-	}
-	hba->outstanding_reqs &= ~completed_reqs;
+	completed_reqs =
+		__ufshcd_clear_outstanding_reqs(hba, ~tr_doorbell,
+						queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT);
 	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
 
 	if (completed_reqs)
@@ -8111,7 +8131,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
 	unsigned long flags;
 	int err = FAILED;
-	bool outstanding;
 	u32 reg;
 
 	ufshcd_hold(hba);
@@ -8206,11 +8225,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 * Clear the corresponding bit from outstanding_reqs since the command
 	 * has been aborted successfully.
 	 */
-	spin_lock_irqsave(&hba->outstanding_lock, flags);
-	outstanding = __test_and_clear_bit(tag, &hba->outstanding_reqs);
-	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
-
-	if (outstanding)
+	if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)))
 		ufshcd_release_scsi_cmd(hba, cmd);
 
 	err = SUCCESS;
-- 
2.56.0.212.g129ede20d9-goog

