Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792555578;
	b=kyp9b/NMlfoxEu7NTZeT9jSrPWnzAuwdlX0SbLyfmwIn4g5JIRYe41vjypnIPrjKq+M4
	 R2pZf3eKHGh762HHPe149OEeS0opr+5nlMENJO6+xlJ8n8MTb9SMU3RBalGulbWuNp6g4
	 Y4ZhaQvT90vyS0HVRdmWOfujlC0xV6Y4S/G0ApCWec1cKAWXEzHAPRPgISO+vwiqc6F6r
	 s2ZS1cvl1NbckPwLdWABDU/b7lpgvNnqN14ofw/RExq21O85FwHwWZOq4IX+o8kYWdK8z
	 fU+wVC3oPbeua1wM8KNFTsXQGcV7f9TCN+pegkVr0V3C8Wv4Y7ED0aMhAZ8QhUG2SfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792555578;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=DuIIAaqvvnxnspDSWao0NwbDdlTo4WVnKM1pf0MR9Tg=;
	b=0l3cAvVzDJ1uEj6md5vEhtrMY/szl9P4QujJz9g3S97SY6kGf+EVJYStAArPaS3kGAjS
	 iOj48eS9jw8shDGLtyNpiKS4s7t+si9piBaZrL1nvYZu+6SiBCudo2vRdIxQ9tJ1DpDgZ
	 dVEoEH+DUkL2NSU0UFTMa/Y737EjCg2ubZT+VDCJltsS5HoI1ohimcsgX57Knpy7bntei
	 s3rhboCI0PmRTLBatjHWMcdlk9yhsPsBqFAuTYhwr/DRyxiZO2Xh4GLq+RRfF29RxJJc8
	 KnBwtjaUYEMQK8O6hyf3bLENPQCuaKfi+uXjzMH7LKrRDNQXbflerRfgMKATQOUaDYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=unIDJ2h4;
	arc=none smtp.remote-ip=209.85.216.72
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E0F606A31A
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 04:06:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11E0F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=unIDJ2h4
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ab1e771632so1182723a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 21:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792555577; x=1793160377; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DuIIAaqvvnxnspDSWao0NwbDdlTo4WVnKM1pf0MR9Tg=;
        b=unIDJ2h4mOfkqFxqH3okz7KXv4lbAgWEleztl+pN62Ubi1LrgJzjSoXmnPnhxsLbkq
         YF5bfHN/1SAYZiXFOv+oGOQHWvwW/S3Yzo2YwBxzT+zOXo3PRb/vu2U2QTDCaISFO7NB
         D/qpm2+bpo0Z3jnK5ERwseNNmgu30aR9de4Ikbc2xHxxqky/NAUqL34zsi77hHYQbMkC
         Sn675aeAc0IQWwTuHFnlPoigTRc+XdcBMBL7hFU3nJvMJRXsbEu3eX7fwE9Fy9BQleMa
         LdiHlpHeETqifb3QTMoFYMOhkuwHT8t74ex5S/+DojXdzaucKfCXpxa9AHXp4hvmtkbm
         26WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792555577; x=1793160377;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DuIIAaqvvnxnspDSWao0NwbDdlTo4WVnKM1pf0MR9Tg=;
        b=t3078u8tfs6a3OhT75RJYkxlG3pBHxt8Ji8cSCd9VU/2dqPNr2P9baRid6X9WT2Kem
         Flh0/Ewxw/3SBdXVKRHl7rLONeoJn6lV/qmAavHqmCVG6u2k69T0CI0fVCfoL54jxOl8
         roI9UwwiRrA0rxR7ZWoKTzQ9fctNCUEhqas6NeWoBYmxX0ks7zUlDEb9E2qrJZj34BJ0
         Eh/L2Eoe2XzMdSdykl/5Oqy/PGKPkugbVpdnRtVAqE7BgDZ0OUTjb9wJYmSwDaXfafrt
         RY7Wao1+9oQtj5Jd7T5O2Wu/efL4bhfQAMylY1g3G3q0pyOsPaseyrm7FJEP4sdDKUmJ
         PDJA==
X-Forwarded-Encrypted: i=1; AKwUvBwJZVt6YY+WiQv9xnVlnYiy+rgyJpt0OZO3xuJ5rhDS85MQ6lQab7fnhGJC5AqDc4rFYLp1qjTWDw/+@vger.kernel.org
X-Gm-Message-State: AFq9FYJdBNhBeoCQmanNFjQB54UQ/2RYhoL0HRzb+aQEj7ZKxIxDP357
	eJQgJl1yCogGnLbdIYmk/hdhFxZPojWV82e2fT9v/P4zlJJnZ3qwCn4rEVmU8e7RRBNthWuuQRt
	xrqx+/W6WeuZOw+iaFjl7MQ==
X-Received: from pltk5.prod.google.com ([2002:a17:902:6945:b0:2e9:5442:b91a])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:54cb:b0:3a4:7195:ecba with SMTP id 98e67ed59e1d1-3ad86eed516mr440687a91.20.1792555577258;
 Tue, 20 Oct 2026 21:06:17 -0700 (PDT)
Date: Wed, 21 Oct 2026 12:06:12 +0800
In-Reply-To: <20261021035450.3488805-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261021035450.3488805-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261021040615.3566831-1-stanleyjhu@google.com>
Subject: [PATCH v4 3/6] scsi: ufs: core: Fix double completion in ufshcd_clear_lu_cmds()
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
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1db572f84971..68b53f89f8c6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7987,7 +7987,8 @@ static bool ufshcd_clear_lu_cmds(struct request *req, void *priv)
 		return true;
 	}
 
-	ufshcd_compl_one_cqe(hba, tag, NULL);
+	if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)))
+		ufshcd_compl_one_cqe(hba, tag, NULL);
 	return true;
 }
 
-- 
2.56.0.212.g129ede20d9-goog

