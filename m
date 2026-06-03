Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18EB4A13A2
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jun 2026 22:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780527172; cv=none; b=Cjx2G1YNpDNY7tcMa76mjZV7QbeWFeR3x5BmYRqgMFAtiZf/gXX12eo3wqGOiZVBSnAk//I+YQKk7oMIgbimpexiKqlWS1W7M+0l/MP24ZZ82Vzjb3zwI0xUeAc1fMFAy+RmsEfJTqIrdNPcUczh/KWIslq5/Nyeb9gmLiEgxK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780527172; c=relaxed/simple;
	bh=qjorpjoies0yCKhFL/o3qCWHKHXvk50YcoRHmto6qrw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ER8vwkNk2QujJjuWSV6luBEdObc3CGwYjuUGRzjXEldf6hNVz3WM+iP+6Trqa1qmlz9MGswkRtfd04cBQGnmFUMc7KKtYiVTyMZB+E+QQCD208j4IjcIY0ofSsrxgmjJtdHUG7WrbKMsJj1W1IBEDxVoNAmAfjnfjMwqBVBXHgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=f1TfE3MU; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="f1TfE3MU"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-9157f7c1c0eso13717085a.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jun 2026 15:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780527167; x=1781131967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vbl8rnY4ongUXS+ZU4aTOUz0VCkVMDkx1IEbiyAfVIE=;
        b=f1TfE3MU2neqpHVSmwonONBGUQv55Lf+6gZc0tH/iwIyUCJAyTM8pFtfnGvdLHaOse
         8bCcgntR7zH0/Wrl551qXI7tsIDvUD+nI9fmr+VVtAWCEZyPaRR40mUs7kp9Y5SzX8Xl
         ZDcCVEFYwHCVFHKS1DJaLyByj33eDtmDM2dlSkR0fapx8imvDlCM7dtIISke7xEPUwrK
         Yf8nSVgQn+w18HvL5ibxEPfSSdAlHcTjnbJnI1oJzzpd9RVzx6AdaCKwmSftf6LXeuiu
         nBwAiixiXifv2EOEkqnKmw3hn25nI3V70R23xWB1bjxtFq6fxqK77fs6Ay65p4agSoKX
         Kovw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780527167; x=1781131967;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vbl8rnY4ongUXS+ZU4aTOUz0VCkVMDkx1IEbiyAfVIE=;
        b=V4AFo8QGYVz0xV05OUJmjKtosncCPJJaM8JZL295BJP8a1Oe+Fwa2p+l50rupUtYlw
         dU4Nof/A9ikEng1lLE9e/88L3iiFdtu48Ga1KnRsclaeJlLsTt9CaC4/SFSxXRp1v76D
         Kbu5jsJeYkPfgWW/DFouFJzzyhp1Ar5VDhXpxLTqZF3D1PMQE4eEzF+sdQB/OmJAd4HA
         Zv0PlrkaiiSuqf42cgRxHX0n2WMcZMDzSVCabSrrEhc72i5jLzd9mx1hptiJzJ7ytqgB
         S6D4MRNOTiFli4Cnd/CtDm00jatUu+RX2LcyDtXEo85+e/4LLijAiz07Oj4h9aNmpElr
         Dkfw==
X-Forwarded-Encrypted: i=1; AFNElJ+kepx3S6D605MUGxkYAbCKwn5HQwm+Hb0YFQ1NpZDXWIge+7VLdRbTgQCMk+OsU8wSUv7GGTsxY5j6@vger.kernel.org
X-Gm-Message-State: AOJu0YyP3b1SplD5cY5uQZtKw096yHa7OpDrWi/eIS2FjQjHbtfSsGee
	zVEqcM3qtpO22jjHuPXXttgnWTmvfYArpVeDRzbPAudfDne2vqG7U/pDte+9ScZiQLo=
X-Gm-Gg: Acq92OEXolu8yD67T/66gVWBTCoHQX5qup77gW8Kr7yRfHvs7sjgcZn1rSm3xeSUQKz
	rxc/uao2Jj6qQerFmBbpjtgc4K9tQbRcLT+LMhBgBCGiYJOIz/eNtq/25YXmVEH9xmQLzPFH1Mr
	uNIhclQeFsQbANB29JilhSKfFU+T6i93kTRsWZexufdzafN+XBRl14dMRFze3Mtel+HItPZ/RvR
	3oclD7a3OFgTg/bwKij4+W4wmKjif5imZgQGJMdasdpJ8OeYC3kXlUjme8jTtzdNEM+drXYFNlG
	IxArp7veJ+JWMlkMrO/IDariVLXhRaUFgKyjGx8RDAdiMfKIDkFmlwisBAXid0U2YfbGl0SPNH1
	432M4jGGVnDjqx5DEpi77/mfQcOm5Gw4noaqtdHxuU1akdTnbp97Zic5G2+MURHFmNVUHHUYC/K
	rajiQJD2Zw3mt1LwUemHWdbzRFw35ou6//Pi4ZCg==
X-Received: by 2002:a05:620a:7081:b0:914:7b4f:cf5b with SMTP id af79cd13be357-9158a6a84bdmr940589385a.16.1780527166747;
        Wed, 03 Jun 2026 15:52:46 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-9158a411333sm400540785a.46.2026.06.03.15.52.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 15:52:46 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: scsi_debug: avoid REPORT ZONES short-buffer overflow
Date: Wed,  3 Jun 2026 22:52:38 +0000
Message-ID: <20260603225239.102803-1-sam.moelius@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

REPORT ZONES allocation length is the initiator's receive buffer size,
not a minimum valid response size.  Short allocation lengths are valid:
an initiator may request only the first few bytes of the response before
issuing a larger request.

scsi_debug currently derives the number of descriptors from
alloc_len - RZONES_DESC_HD and allocates only alloc_len bytes.  For a
nonzero allocation length smaller than the report header, that
subtraction underflows and the handler can write header fields or zone
descriptors past the allocated buffer.

Keep accepting short allocation lengths, but allocate enough internal
space for the report header and only emit descriptors that fit after the
header.  Limit the transfer back to the initiator to the requested
allocation length.  Non-PARTIAL short requests still return the normal
leading report-length field, so 4-byte length probes continue to work.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
 drivers/scsi/scsi_debug.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1515495fd9ea..6084257dabe1 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5895,7 +5895,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 {
 	unsigned int rep_max_zones, nrz = 0;
 	int ret = 0;
-	u32 alloc_len, rep_opts, rep_len;
+	u32 alloc_len, arr_len, rep_opts, rep_len;
 	bool partial;
 	u64 lba, zs_lba;
 	u8 *arr = NULL, *desc;
@@ -5919,9 +5919,14 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
-	rep_max_zones = (alloc_len - 64) >> ilog2(RZONES_DESC_HD);
+	if (alloc_len > RZONES_DESC_HD)
+		rep_max_zones = (alloc_len - RZONES_DESC_HD) >>
+				ilog2(RZONES_DESC_HD);
+	else
+		rep_max_zones = 0;
+	arr_len = RZONES_DESC_HD + rep_max_zones * RZONES_DESC_HD;
 
-	arr = kzalloc(alloc_len, GFP_ATOMIC | __GFP_NOWARN);
+	arr = kzalloc(arr_len, GFP_ATOMIC | __GFP_NOWARN);
 	if (!arr) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
 				INSUFF_RES_ASCQ);
-- 
2.43.0

