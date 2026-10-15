Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8114C10F5
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 08:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792052398; cv=none; b=dtXfdCFtV+70Rd5oFEfuUC/1TH2PUsQxmGbIF2Fwn8a6eH6v1KjdzbXAzsYl2bS0ZtPxpjWePybOC3XnIQ+TAL9EdDnLr9JmOxFZVOCTvemQJugK0CrEap1TCPOQe3CJGF8PKoOWNg0y9tyvybAzBScL0QZY9S6bKriGeFs4HFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792052398; c=relaxed/simple;
	bh=cLnGrFj4fZ5QbMee1ofZJxYlwDb4ml+Hkm+YEE7tfAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayOagNORRARjLrL9QQlJU0GwjRUJqQQ5C31QeTg1qT6aolmx32fzR8gDEeovf0I2cTDvkA3Qx8ctJ6MVZO2b2ot/KbJgG6HkPW2FOajbEgklaHSoZkjYG0PceKDvq0+XGv13dQMV01DqZathIhtkOclIyNXezwH3G7ZCSMBMnbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=pC1zgxG3; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="pC1zgxG3"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3ac451e128cso1569292a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 01:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792052395; x=1792657195; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HG1zhfPiMXRFUFNZwJgHDsR7OhzfKqj2uZPWv/pDLsM=;
        b=pC1zgxG3Bqw/RRp2/Et4Cvqg/mdyORE6JqhA8Qj/5Ci64YxumBvVkA3YyXmRIh6Nar
         yqQ6suPM8GT/kSiHHO41ZEC9CjGywaLi8BoRpMSWF/Wq3VtIfkTPdpz25OZwcame5I8x
         xwuiaf28KyLSwTIBKIrwZwE1N/7ZAKRYJG2lD+1A1+xO4IXqTMhqcmlNBrQN9QDlUWXH
         wWd3zqlhQSMG8F2CMxi9aSUIC6UsmehIuMYJ39j6duZSYiiwFl6MJzRCcTftAes1NzzY
         4YH7St6O+Fp5ZmfO1ai2EtNqjN1MjmnEe3P9dMdcKOOUe7Y6wFIEsrzZEJiYaVmuoRyJ
         Xnzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792052395; x=1792657195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HG1zhfPiMXRFUFNZwJgHDsR7OhzfKqj2uZPWv/pDLsM=;
        b=KkmgjdASGqtdPq83aX2hzyoCmlm8QHjlPBcM1glmKmLRdrzMwNL2GnzjG+svALrfAY
         Ta99RP0+pkneKdEJGYkcdh/PlgrNL1XI+oXyC/eWmoQnYQplzzxSRUujSixVC052Eo+6
         RcHTZ0ZHiNvOhOZ7YHUHohtYuuZ9JM9fs3GZLRWvWkrTlY2kChICFYjKFSK92EMEQkmT
         CTJvL5VQVQpAOsQL9B+7WE0PABdNpQKf0CiOo8POTx5cqFsgVYvelntnbSVC41YbWGAY
         1PVPfFXrXmC84xba/LQwjhaJ7XV0tc3ypQMeDbSpdSUzuWBmYaf1rzkXLFuPLwEvHnzY
         t8rQ==
X-Gm-Message-State: AFq9FYJaZemZp89xIOdbUon7Qc5f5Djm2OMLsjvK/Y3V2X0sy4htmU8Y
	HN8Ia7AOuGGNV77DiisK80I1n0eWtnBvPv2u+gVKJeBxYjYowG6fqJDwkqOmTmihTDA=
X-Gm-Gg: AYBFou3+KPLhU4FTteHmY8k5/ib0ZL4TOVC3XvUfAE5YqUK6u9E3Zq7jTGCUbMETkBy
	VSdp1lOtcAr8/VrtR44fPzSVdosGZQPt7AbQmWVZ7sWEEIG5Y60Yhx8FHHpkbmLUymGljTRXQn1
	Gw+7s3c9+/9RGStcLEunrCpPJG25lDd+eUdbksUPVa9MyHq+CaO3GZKHrgYocLGEbUJKMMgUdwA
	jcJS9R9hfTclCtagSWtNG2zffXAczRBMmpD45kaXGSppTEFsn36kt/6/mNdtrhy15Y76RWYHc3S
	C0N0+i/XSHtRqIkG8owY2IUGbrOSZwuy/ukCAaxrsj8sX1FCbZcw7a0iS3SZm+DjGdvynGqkK4i
	4LztrcLpCrN/2AM8tGoBLBL83SHd/CrmpAfIG0jkY1HD9h8fptjk/zL8j8lf1RjACcYK3QZoAr6
	TXs11yykIgQK394N1+rd9OHI/z3rTOabwqXVC/flKxeVCk+xMVsuSF1aGrOWJ7OJu0bRPzxKPwY
	N0uh1ODZAvT/V+r
X-Received: by 2002:a17:90b:2d86:b0:39e:359f:8539 with SMTP id 98e67ed59e1d1-3ab3a90b5f4mr13911476a91.15.1792052395457;
        Thu, 15 Oct 2026 01:19:55 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac943e755bsm3319784a91.2.2026.10.15.01.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 01:19:55 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v2 3/5] scsi: aic94xx: validate the EDB index in asd_get_tmf_resp_tasklet()
Date: Thu, 15 Oct 2026 17:19:32 +0900
Message-ID: <20261015081935.4168771-4-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015081935.4168771-1-yhlee@isslab.korea.ac.kr>
References: <20261015081935.4168771-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

asd_get_tmf_resp_tasklet() extracts the empty data buffer index from the
done list status block exactly as asd_get_response_tasklet() does:

	int  edb_id = ((resp_sb->flags & 0x70) >> 4)-1;

and indexes seq->edb_arr[] with it unchecked:

	edb = asd_ha->seq.edb_arr[edb_id + escb->edb_index];
	ascb->tag = *(__be16 *)(edb->vaddr+4);

The field is three bits, so the value runs from -1 to 6, and the first
ESCB has edb_index 0, which makes seq->edb_arr[-1] reachable arithmetic.
asd_invalidate_edb() at the end of the function uses the same value
again.

Apply the same check as the preceding patch and return res, which is
TMF_RESP_FUNC_FAILED at that point, the way the lookup failure above it
already does.

The caveats are the ones on that patch: the sequencer is firmware loaded
with request_firmware() and nothing in the tree describes what it may put
in this field, so this is not a claim of a reachable out-of-bounds
access, and a response dropped here leaves its ESCB uninvalidated and
unreposted.

Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/aic94xx/aic94xx_tmf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index 28ac92b041fe3..1ee6009d83051 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -282,6 +282,12 @@ static int asd_get_tmf_resp_tasklet(struct asd_ascb *ascb,
 		return res;
 	}
 
+	if (edb_id < 0 || edb_id >= ASD_EDBS_PER_SCB) {
+		ASD_DPRINTK("edb_id is %d! resp_sb->flags is 0x%x\n",
+			    edb_id, resp_sb->flags);
+		return res;
+	}
+
 	edb = asd_ha->seq.edb_arr[edb_id + escb->edb_index];
 	ascb->tag = *(__be16 *)(edb->vaddr+4);
 	fh = edb->vaddr + 16;
-- 
2.43.0

