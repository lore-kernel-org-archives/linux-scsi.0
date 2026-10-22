Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792640698;
	b=WPLBd6e24XyIyml74qMRYIaPX6BQlAYrRrc7HFL4h3LU6W4d7S+urCdQ3UDmRblGS+Y/
	 qImnbyh5N3PJfMOk22WemfEkXYMHNTlro8KsYl+yiqHEQxBL6gND7Ak9imEr7eJF2+lFM
	 uKPtnaHQOzAI89aW5nJ22O9Qvh3hcU4tU5TQytr2yCpT7FHH4Wd/9hdGhqnw8sLjJM2xD
	 WZRAQ6HbaXHj13Zjw2N7WCb400PvBL/HGrkFLYnCosUuMvBr6h5vcNIjKUBrVHFAgNTzO
	 vKSIfILSLtpiJZ33sPP9Tmgk+ql/ersz9NOm48is8tmVw3TW5qKdmEGtvw/sfP9bCaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792640698;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=+TrhtkhDFVvIhKjfwyEiGtODopfUQQu0bSw6HzfCj64=;
	b=uNf7OzFYsaU98Ma9LrwTX14r2L7gej5q6xQPfsGjsT5BXcQkNRrcEKEJhCQa78wLzRRR
	 qaqF4IhRI2W7UHz4JTcF6z5m5jJACDH3G1p89y5emhdCYMw4oHU+/6b3PeYwIaN2dL7nX
	 DnaEHzNDwuGW1Q4dvRMHhTeSzWXihgu2HU9zOatcYgKv9rCJfsFR+AmU20kqO/FqMcWqE
	 hRrXOCacbbe8gjdeg5mjo0pxnV+6wNKERPoxDCOLMogpY528fBJelHvZ0GOmwvrw1JeRJ
	 xZuvxTuG1GH0ikAeIVkoW8YSOuAjLhIMDvySs1osDcp2S8A5+GpdRal2z/xhLfftF/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=L5YZ4T5F;
	arc=none smtp.remote-ip=209.85.214.198
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA8A606A329
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 03:44:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EDA8A606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=L5YZ4T5F
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2df8484f12cso12723595ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 20:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792640697; x=1793245497; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+TrhtkhDFVvIhKjfwyEiGtODopfUQQu0bSw6HzfCj64=;
        b=L5YZ4T5FMwlMRd7geS0utbQnmXwYSMoYkAjK43frJeyBoNyqNNRv6QvGnRvU5T0TQD
         FhzuyMJcUWrVzBL9ZUbDX7D67coXKwtr0/LGBEkZHA+6tQfeewJa7jp4BGmB4pNzgU5+
         C4GRznlc0NUn3ZYs5O+UCpKeRn9s8cVGKsInd7fNK+LBlSFFfOX1dICydnFNDzJ2ilpj
         dHhL89cktc3IgEOfphV4F2YTbHacWKevDpZZeF9jGmj6aPF7S2HX1/IQfp5CU4rtWN+V
         tGSPfcutKmgtWaNXz6ryGJ6blzxAZw560O7MonhaBEZKK4Gc6nXTF+T5PQ4DxcrnD6XE
         iHNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792640697; x=1793245497;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+TrhtkhDFVvIhKjfwyEiGtODopfUQQu0bSw6HzfCj64=;
        b=ecj3aqMxmK0JETNtmjomUKhwSxLHGWQxWE32Bg37UyXm10fWiEdYjSpCtJNRXyR/P/
         jJ5HetyAfVZ6RZAjehL93bgRrCqKGcs4o0miCXd1Hx3t5jhhfUyBxrTqAwX8j3ptcsrc
         NPH+m1ZbaKUk8yUYd1e02GkVQWvj7BxHJGML3ChQ5tSKXHuu7kXEVR3Cus6Jgy4CXhE1
         3AFP+1df8J9dVI5XbjOULZryD8xErPyWizI/rVIjiZ4nkmUN2SmJSbqmtip25blqb1jw
         Ur1RrH9S02lApgEInhIn87JcOAoDJcK7HvYCZ+7MLcLzoGZp77LOiFZisa19cV/R2LRi
         7yog==
X-Forwarded-Encrypted: i=1; AKwUvByncF3WRpHOomSt+slrHEK4jSVYfwk2iRNDpBdGWg5P4vKHV8QYxEWiWKBxdglJ53vjuF/I5tUY5USI@vger.kernel.org
X-Gm-Message-State: AFq9FYLkd3JMYs4bZP/iqYchaKTlPhFr2DKVzi56GxjBe60qumEVHS1k
	hctxukX2aEg7NAURL3tRbYE0evRlm2uBLJaQr/rtKL2FCHJA5TXpSR5eowxBJgOP1LXmof+vB2W
	9+rhPPf6oSdBilotnlofgkg==
X-Received: from plsm24.prod.google.com ([2002:a17:902:bb98:b0:2e5:ce48:124c])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2405:b0:2e2:cebe:d811 with SMTP id d9443c01a7336-2ea43fe0efemr30804745ad.46.1792640697160;
 Wed, 21 Oct 2026 20:44:57 -0700 (PDT)
Date: Thu, 22 Oct 2026 11:44:43 +0800
In-Reply-To: <20261022034443.3034432-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261022034443.3034432-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <20261022034443.3034432-7-stanleyjhu@google.com>
Subject: [PATCH v5 6/6] scsi: ufs: core: Do not release a reserved request in ufshcd_abort()
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In SDB mode, aborting a timed-out device management request drops a
clock hold that the request never took:

1. ufshcd_dev_man_lock() takes one ufshcd_hold() for the whole device
   management command. ufshcd_queue_reserved_command() submits the
   request without taking a hold of its own.
2. The request times out and ufshcd_abort() clears its slot with
   ufshcd_clear_cmd().
3. ufshcd_abort() claims BIT(tag) in hba->outstanding_reqs and calls
   ufshcd_release_scsi_cmd(), which calls ufshcd_release() for a hold
   the request never took.
4. When ufshcd_dev_man_unlock() drops the hold from step 1,
   hba->clk_gating.active_reqs goes below zero.

Release the command only if it is a SCSI command.

Fixes: 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/2060a8da-581b-46d1-a510-779f4df716cd@acm.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 87efa2925867..141ad1be4848 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8226,7 +8226,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 * Clear the corresponding bit from outstanding_reqs since the command
 	 * has been aborted successfully.
 	 */
-	if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)))
+	if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)) &&
+	    ufshcd_is_scsi_cmd(cmd))
 		ufshcd_release_scsi_cmd(hba, cmd);
 
 	err = SUCCESS;
-- 
2.56.0.218.g1ec904b173-goog

