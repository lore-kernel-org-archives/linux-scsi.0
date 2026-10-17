Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483E63B9956
	for <linux-scsi@vger.kernel.org>; Sat, 17 Oct 2026 08:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792226651; cv=none; b=NtyyKPKmQAkfPjn7r11JR0NnNnKLWmBi0eYUXP3fYN0Dn9EfsAxJSehZ+Rx9r+MaD4oMZnSi/rV9y7M3YDkGX37/3gK1u78cbYfi/EwOxivOH9qDZop9DP2RfF+7yMxlA9U9Y9pWY0un/wn+AJ+ctbKUGT1TKph1gz/9m8Ze6wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792226651; c=relaxed/simple;
	bh=Q/X/QgkPV9GRHvc0llHqXagnyq759chf6kmMWWc+gqI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E+/Ct70SUQCp5h62QjrcB1ZGDd2+/5erdBJ0CdXEWwppKpcSVrSTnnnwjTuQaZIddheNqpEPp+Fr8qfpcDitUnk472Of0POGGRkra3a8R4gLg6LXEwyfU8/CQrDqCBRmN6SWjTuDfyDRdHExays1gs3JgGy27cDlsKKPfN/r0vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jaQrOPMK; arc=none smtp.client-ip=209.85.215.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jaQrOPMK"
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc7e0321ec1so769910a12.0
        for <linux-scsi@vger.kernel.org>; Sat, 17 Oct 2026 01:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792226650; x=1792831450; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oJtE2MOebaI4Aow6a4In64UuLQH5fsqvaP48yIJtyGs=;
        b=jaQrOPMK5/nkBS+4JNVuIMbjhmSao4kWuxclO+19454HM+zEc8jrj1pzgLCiW2l+L4
         EFUjRXWCpkd5kHjUx2gzR/RpbPeZFW5mO4ItC5uTQmmc7nQd1323+te98EivGsuBziJ8
         xIFE8lz6C1643wEn+36lUXnpeQcWaB+KpQ/MUzVAjb3mNq49WAuGUzaU8csAMR8KGX6N
         cCppdcLbrURgYL1+2EbxshwhHT/+wy1U64XIGJVxSXVHUCmR3ZDNBzJfI3gCORJmcsrV
         a+TDJd+WGLTS1jXtkqkcNpkR+tvLY/ZjwzOi4X5KRz5ZcmwFjrI7HuOoBF2NyXulzVjN
         oHtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792226650; x=1792831450;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oJtE2MOebaI4Aow6a4In64UuLQH5fsqvaP48yIJtyGs=;
        b=ur1jgqHu+y9JCGc8RBt/DhG8tqhQANKjujXTf6smylpF0BbGDBioBHeXNAS8ogOoWj
         C6s90zP9YcaERwK+8dVYJ47XjG3mKOz8UZ54RIb03kmilWFVQD9HUKSlhGJJqqj149M1
         Rhkbe5YBANgQPxYSCpFJIeTPRmczmWXXWfT9Dzf/xqdnuZrqkTDldq9jasR1xGyAvhur
         DKaNTOxr5HD80v1wPBokNINISX13dnUMjzZR0tXBvuRCFdNiWhGLC7+QY+a3V2iKEE/7
         U8Wllv/6TLgttAavAt2Aj6nD8xLUIC0U9/QvsjEOHAjYxClCnJPpakFEOLRXB0UYsY/j
         NC2A==
X-Forwarded-Encrypted: i=1; AKwUvBwqyB95nOyRGNkg/8StuodEn97n/jPCy4+PZluDLg3Hojd4w7uVa2nkVZyzzzGS5n3KvaT+1a1q8rcr@vger.kernel.org
X-Gm-Message-State: AFq9FYIDab3gqCef59klrWxdRFqnaRnaZiEGHtYPOKF4aeVKZdtq+H6L
	BJMwGb2o3FJRQ5RFhH2JWCEjVLeElRQEsUBtcndAyxO6OQ7EhXQoIAxjjI+vyA739QHFkSl3p9+
	m2unJujcVVB/Eq+EXsHhLtQ==
X-Received: from pfbky37.prod.google.com ([2002:a05:6a00:6f65:b0:8a0:582e:68f2])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6f89:b0:3d8:1f68:59ac with SMTP id adf61e73a8af0-3e225fe8c5cmr1674818637.23.1792226649454;
 Sat, 17 Oct 2026 01:44:09 -0700 (PDT)
Date: Sat, 17 Oct 2026 16:44:01 +0800
In-Reply-To: <20261017084403.875420-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261017084403.875420-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261017084403.875420-3-stanleyjhu@google.com>
Subject: [PATCH v2 2/4] scsi: ufs: core: Fix double completion in ufshcd_clear_lu_cmds()
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In SDB mode, ufshcd_clear_lu_cmds() clears the request slot in the
controller and completes the request, but leaves its bit set in
hba->outstanding_reqs. ufshcd_poll() treats a request whose bit is set
in hba->outstanding_reqs and clear in the doorbell register as finished,
so the next ufshcd_poll() completes the same request again and unmaps
its DMA buffers twice.

Clear the bit with ufshcd_clear_outstanding_reqs() before completing the
request, and complete it only if the bit was still set. If ufshcd_poll()
has already completed the request, the bit is already clear and
ufshcd_clear_lu_cmds() skips it.

Fixes: f18fac1e2b72 ("scsi: ufs: core: Rework ufshcd_eh_device_reset_handler()")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 71f4b9d0a850..531309c7fb79 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7986,7 +7986,8 @@ static bool ufshcd_clear_lu_cmds(struct request *req, void *priv)
 		return true;
 	}
 
-	ufshcd_compl_one_cqe(hba, tag, NULL);
+	if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)))
+		ufshcd_compl_one_cqe(hba, tag, NULL);
 	return true;
 }
 
-- 
2.56.0.176.g3575e65682-goog

