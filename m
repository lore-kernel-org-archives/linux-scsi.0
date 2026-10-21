Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792555580;
	b=dH2LnpswgpCYfChD9UoLHU8l7BDdVdLaTTPlaeuOUDXKLWeUVNd1CT9eWJKl01V/07+H
	 cqgb7LCXcLPwJf45Jx7GjOuXXeG8dtLYqEU4O7pFIOpx84ku+6hYyJ/QB0KYos7gVzysK
	 QiW4u2hpEPJUjvIGe29HxC2UOx8b3nFp/dyIJQcCKijA+adwDItMLly0VxQ+GvLIZrgwJ
	 zRFqnokrKQr9MM/NEnuQhL1xT+tCggEoNevv/sQ7RosgUGYr+90iCAstVF1d6hIOqee1G
	 d3IQqulfRSa0cezDLTa6qAP7yIVLuAHphw9Bv0D6tTY8mtSxMJMNNIMLtlK+WftF77Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792555580;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=SfY/SEah692s3Y5+TnEOtAVmjoLjea2BnPP2RXOzKdo=;
	b=tctZmopX1KrJpyyhED2AeMHdchAJcKvwtFIt5xTtz+nSKr44HNiMGEB6C+rJTGOocyvY
	 bGuIyFrOyIscXncy84gF8PnudBYRyasaxIoIz2Uq5qmL3Al8WQX4svN6tVbYoHwndahCt
	 DMZSpIhhpJNvnAQypnunO4odzit6QVAdejDX9O8c1Jcp/odCJD8eomp9NwWv4j3Jm+0M+
	 HLIEqGWpcPJIJ4j/vr4KaHO0rmWO44APZjGl/xyjc4fcjWL5163kFou0NyHdPv8EVLJvL
	 HsK5EKg68okGt0Pr+m7FBUh5hw9BcPpysW09aMxiuk+rwDzUeAM7RsgNsc3S2QBJmxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=cSUa00z+;
	arc=none smtp.remote-ip=209.85.216.72
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CA3606A32A
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 04:06:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06CA3606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=cSUa00z+
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ad3fc547bfso333397a91.2
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 21:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792555579; x=1793160379; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SfY/SEah692s3Y5+TnEOtAVmjoLjea2BnPP2RXOzKdo=;
        b=cSUa00z+oP6RfVR7byNTBDWLgBqaNf4ATrzW+iemZrn+llX0sRAb2V4Cr1rKVieCTW
         tIwFLo0G6j+PWAVh4NQhCog8qT3BxKOsQDvlWwZPReRBfhiEFQEud1VO4UgtOewZn9BZ
         tPiOe+LUu7l+4a6G0fdbbuz6j2r4p8an+KT8V5p0UHY4PLHqW20YtpdfYzSo7hGsErC+
         J1lCXK8MsL4wR62qIhhhqh/V4LvNzntdvPzyqnTQnuPV0GtP89ueXJifAYt+/zNrvwAH
         Nd2C7T/lnCldXyKjW0zCwAsEuYxUrlk6WiW9iQx3WQnbRMQioXZ0J4GHxXMZeU225k8R
         k9xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792555579; x=1793160379;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SfY/SEah692s3Y5+TnEOtAVmjoLjea2BnPP2RXOzKdo=;
        b=BW+QDaCCeV2FOlIxwkp35o1T56wHjkuG4/Y+tKlzsKU3laKVS0eq5yooOKMpIkv9Bq
         eUIXzhUJ7dngTCkaSb6rQnAWOoT09n3bxb/qROu2w5iL4ZZMCzNYWrwfLv4HyQYbnwHX
         3IMNjtwa8POrcmMT4Cv//pMWr+LzYU4vY34+PPsyj+Ppy7AZ6Nnx0pUkizM5mp7TVAhe
         eVmMBa/bilQBCz3hzd0nrMISkk8iT9fZMviRODLgNjyIR9RaD+xZ1J4fP/BBDiB4AitF
         L9VYQCOizDf/qRn+c4Zts/yV60YFkbmWLI4Oky1i4HEkE15cGs1Gpmq6dBJnjBHhsgR2
         9exA==
X-Forwarded-Encrypted: i=1; AKwUvBy4IuC316P3O4sqgWoYsdbY4VswiHV9qPl86aLI4DxqVVs4aV58yu5ftlYY1Rh7VRk4KR+KHbCPURPm@vger.kernel.org
X-Gm-Message-State: AFq9FYKTBiLHOxw7LrM9qLT0zLCyqlvFYqa/ffvaojfUUegoryuZeUyH
	1rxq3IAnq1U0POQEHoS1p98XDe+GfIxCyS+3FNCFL8coMvOpzs3E7xSQRlkFYonu9JUlxLiItwX
	nnJy/T0BkZqK/LTtF2Ugxhw==
X-Received: from pjgp5.prod.google.com ([2002:a17:90a:4285:b0:3ab:fd4b:afa8])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3c92:b0:3ac:9717:afd1 with SMTP id 98e67ed59e1d1-3ad86cdc6e8mr779320a91.63.1792555579181;
 Tue, 20 Oct 2026 21:06:19 -0700 (PDT)
Date: Wed, 21 Oct 2026 12:06:13 +0800
In-Reply-To: <20261021040615.3566831-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261021035450.3488805-1-stanleyjhu@google.com> <20261021040615.3566831-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261021040615.3566831-2-stanleyjhu@google.com>
Subject: [PATCH v4 4/6] scsi: ufs: core: Fix double release in ufshcd_eh_timed_out()
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In SDB mode, a command that times out during a power management
operation can be released twice:

1. The command times out while its normal completion is running.
2. The completion path clears BIT(rq->tag) in hba->outstanding_reqs and
   releases the command. It has not called scsi_done() yet, so
   SCMD_STATE_COMPLETE is still clear.
3. ufshcd_eh_timed_out() recovers the link, sees SCMD_STATE_COMPLETE
   clear, clears BIT(rq->tag) in hba->outstanding_reqs without checking
   whether it was still set, and releases the same command a second
   time.

Return SCSI_EH_DONE when ufshcd_clear_outstanding_reqs() returns 0, as
another path has already claimed the command.

Fixes: 01d5e237b339 ("scsi: ufs: core: Handle PM commands timeout before SCSI EH")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 68b53f89f8c6..ff5977f7da68 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9660,12 +9660,10 @@ static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
 	 */
 	if (!test_bit(SCMD_STATE_COMPLETE, &scmd->state)) {
 		if (!hba->mcq_enabled) {
-			unsigned long flags;
 			struct request *rq = scsi_cmd_to_rq(scmd);
 
-			spin_lock_irqsave(&hba->outstanding_lock, flags);
-			__clear_bit(rq->tag, &hba->outstanding_reqs);
-			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+			if (!ufshcd_clear_outstanding_reqs(hba, BIT(rq->tag)))
+				return SCSI_EH_DONE;
 		}
 
 		if (ufshcd_is_scsi_cmd(scmd)) {
-- 
2.56.0.212.g129ede20d9-goog

