Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792484483;
	b=nhko/Tfpv580P3Bc5GBrbEPJEkro8xUBUc111fP4XbNnT6pKkqkM6RMecML0yjl6Jrup
	 rtMpjPzSFeu3XPUiR170NhiO9C9hAMoQFV+XQL49fDeZTvt+mk5to+escUEUsNfA8Z7g9
	 CWZfEml5OUP2M2VMHWplOb/Qoa5QT3+i5TyA4w/GhZgHDfvKQjRCTedIuDXkq7vHDXB+h
	 T1dZqdzaYGO4SFSgtUkGduQc0I46amjBaptFJsOy98kavj0iHabaR11oE/omyqRFZ7QzR
	 Ik5elVyYvnk9VgU/CXRpOCsfij34IF2IVFo1z16bNUL6GdG36zUgJ+Oik8TVHBI3oIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792484483;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=Y0S2/1HTQXjT7j6wQIYRpSV26ZEjZ5U4TjqBh9LMm6s=;
	b=Y0YCuHsw9p2VtOc6Dr+Gx0aPsaIsR0KdjYESv643rRUc1PEErNoh3/Eoy2Kc1ZhEl2SP
	 AghkQLrAa0jzkPc0kZ53R7IpJ6BZeFW9lKSBQVMNhwgV+9uY37bUBBfIPZhqYzTMx9cFA
	 fVvbm+2MSb9v0SU3lisJGruN2I86TMkpEXiot49qlcmPxGrZHXFEHmDu/OWxZu3IjUDxx
	 2iO5Cm5Hb2wkz/8ah5xek9/TQY+OBoVaezRqs2uvzP4tQ5w9bliowURMAiU3TpnIAL14R
	 s3+xB6yR5zcyPVKx+IhdKpSPJk37evO4qFf3IUomqV+nWRUE2fKGVsqsE4jKJQKe6nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=NIlruYmw;
	arc=none smtp.remote-ip=209.85.210.200
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8397360A2607
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 08:21:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8397360A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=NIlruYmw
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8a03834d8ffso4013536b3a.3
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 01:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792484483; x=1793089283; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y0S2/1HTQXjT7j6wQIYRpSV26ZEjZ5U4TjqBh9LMm6s=;
        b=NIlruYmwjbEE6hjnJ33S+zXOLPmcQLJDErdhDRBEDCb3kF2A9sX7NUITVUGIL5TNDW
         ecTIMM6NdFKmyJT7aVJ4YLansxWpZL9v7YBlfVimFCN3jjyFgUjV+gpsEMJ7jGO6aPAo
         xW4sMgoeE9fQ9yZI6SFiHx35epu3MZoSUPByg/BTM7yQkScU6czeOWzlJQHj2KbQ5GxL
         uN8iTk/WikJDiMI863/+SOhBQCabPHFuGXUEh/4zx1FKxEBg9k3V9Fpx4aGcs+dRTr43
         ufEI40eNlrcYwUNEitEQ50Su+DlCI3LvoHtvANmsOeG5+s7tDdTD/AsTDsh8IWGco/vK
         vz0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792484483; x=1793089283;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y0S2/1HTQXjT7j6wQIYRpSV26ZEjZ5U4TjqBh9LMm6s=;
        b=HVdMVaJ3ompAE7nq4lj7n5Tm0jvmCBP4x5j3IZdGWXmAAwhN7Fj2s2bfbtC744uUtc
         MjRSQnmBJxM7sMNjKHeoaQ0+eDCxkZRMBcuG0Of53ZosEzCy+Zdt8dBAo3bL1+Mf0TB6
         9dQC/yuGMxjrBL6lI+ZwJQcJQlR5OwIJfaWGAIdj1MZu1q+C3PyDmsMIa7To286CeYML
         8NpmaP2WOsJ55D8oHzW8CNYdp39D/6boTCr8pEq/F/CH3rYbCK7AaNz4cCU75nr3WBdW
         RqOW4NiW52Cdz+78VZVuBXRzl5j5gy+JX9PlkRoyUp09m8RKA72wJ+D90r4T+Iv2wh3g
         Sgew==
X-Forwarded-Encrypted: i=1; AKwUvByGaB6M2mS7w7b1abpRHudnoj8VBHHawQU9RFD87F4jNaRrE8oUva7XqBSD4M6nfQRtdoluF42qy/u6@vger.kernel.org
X-Gm-Message-State: AFq9FYJa3UREsbEGrVL3vW4Fp2p3AdcDwmPw/vHJ3UaDfrEiejfpK9rQ
	TF395af+KNqYUH1KYCJ9baiccFS25fjpS9C7N0PZBSKroCZN6duAL3LDC6V4P+62ugn28RaGIFi
	TS4wfg0veVhE9y+ReQvlNOg==
X-Received: from pfbhw24.prod.google.com ([2002:a05:6a00:8918:b0:89e:a4f5:3f5])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:8009:b0:882:8aea:fbc with SMTP id d2e1a72fcca58-8a04ba04bcdmr8600296b3a.16.1792484482530;
 Tue, 20 Oct 2026 01:21:22 -0700 (PDT)
Date: Tue, 20 Oct 2026 16:21:08 +0800
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
Message-ID: <20261020082110.3511797-6-stanleyjhu@google.com>
Subject: [PATCH v3 5/7] scsi: ufs: core: Fix double release in ufshcd_eh_timed_out()
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
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 03efbd85bba9..111f5805f178 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9653,7 +9653,8 @@ static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
 		if (!hba->mcq_enabled) {
 			struct request *rq = scsi_cmd_to_rq(scmd);
 
-			ufshcd_clear_outstanding_reqs(hba, BIT(rq->tag));
+			if (!ufshcd_clear_outstanding_reqs(hba, BIT(rq->tag)))
+				return SCSI_EH_DONE;
 		}
 
 		if (ufshcd_is_scsi_cmd(scmd)) {
-- 
2.56.0.212.g129ede20d9-goog

