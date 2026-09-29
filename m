Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AA235AC12
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 23:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790723713; cv=none; b=YoxyxwGvdKRZyeFY7/ruLHztih/XbG2G11punEi1cYRSmtU0GtZNOeR3T6D0DgedulaeU6QcJbjufVQlRBnHoRRwhaOJlxa8gzuyFOcxNCTazYi3mw8DAjX5tFluh2Xsx07SPHk3TC544FS7MsUNR/ArV141i3DzVKbBV1WtcoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790723713; c=relaxed/simple;
	bh=U9gDFEFDzdGj4kMNgz23Fk6nUAULbdkRWVUrxCN/aUw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LgRgeEl7sj/H7iStiVR2BV8pvC75pwT2LIybKsCWzICdCfkpmCor2usdHdlCa2EGHOh6n60MIxNdmUzTRocG/UtoW/vsNnohWBnKDshn5lVuOIs74aKhTMTZ+fY7KxsKiRG17mIxHW/qKC3PWwyHtWKcHW5me21PA7CgdaQr8UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Wk4q2Mmr; arc=none smtp.client-ip=209.85.215.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Wk4q2Mmr"
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cc7baeea5ffso313894a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 16:15:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790723711; x=1791328511;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gPiE3QWjmwTsVpl3XFuxTwOhK5xMwryQhv8LE68/7Gw=;
        b=zZcjTDFn/Mz9s0843fPamhjsQi5ghwqiM6A13L5fKXHoTCLxfOLIwMSKQSke6lLchW
         XSq2HjP28vSyghBHgOwW7lg4S6M1+o5r+2Gd08ep+vRVsFwAwq1rBsEUVWAj1ZQrRzMK
         vpfpAsuTYAtih6K3hlwhyXUOjNWjAuVERH64B3BKoqPgI1gmR5uQZ7NeiZsWavM+uCBl
         6CbuTkZ5Env97Tgvp6Wv3RJ1gQJ0w/XTzsdRpIpw+BkOBlr0XbNWW2noKRjTVqcL3VCP
         RmzbSrI+eB3jORofWLf5XrRNXc2BGqyP0WDSyGFnMpEOStJNh4WRlm7ArytIyzore0KU
         IBhA==
X-Forwarded-Encrypted: i=1; AKwUvBw9PhPqJ4+g8A5QDscEZTmgJIJqbPt9LMQ03Stp8Og7kay/Lon55zsguj6GKPb8w1Lz7pYDbLA1/WPl@vger.kernel.org
X-Gm-Message-State: AFuF++mP4GgQ+nF/u0+N937Hl0w/KFupyrU75JuK8jwscuBVr1fVGp85
	Fr0xPZY3g6Wx7g5cwxu4Qnf0z1SAra/amDKJMChR/+BJFsCF8jSNNRgLTvkiWxcnkZToJ48FuDI
	bu9RYssuc8xu3i/RjpX+Q6bMBgVIYeKf4R/Xif4m92rtBuIX2LC2QiAeMt86uqeTYmdgwGospjy
	01DH3cG0E3F8Zc9JQXUCih62kxK+apYNLy6QxCClvZfiRTIt1IDHjRqrW+dBGXdbnEnqSYl/41P
	LwkZS1ZjThR
X-Gm-Gg: AYBFou2PiVQIngI62rk3mUgtY33g629TY93LxrCJnc2ZKGCodB3B8+5WwmUZT1dzdeX
	0VbMil4Ltk5kDwMKXjP9EzFceITk4syHaiN648VonXimKNK1ksHZ66QN1hQBVmPgtiOuZP2NZcU
	TEHQCjdptfhyDKnoFyjfOxVH96CR2kWjMTLGdlSpo5Rdo01KLEFxHRTyd3oRXTbeU6UPE2SZoF7
	bn82tNoJQRMeAbQTxK5rakxV5zelhwNabxDiPOml5t2LonS31BtzV5umlz2Th/Q92Ggq6IIy2MX
	o/7pOEm2kqkJgNAHYOLVdP6KVj7ufx1XSk5dIPO+QDcPWNntwnnT7qaz7BzytzqIChJMxLX1Rck
	4gQF79OMVZ/KU0DPpWXAdgvINXl4wsFJwikPC4XEx+5xD0Nq7ZkKio3PwE47fqW8SlFqsE7YjqZ
	CUvVVpJgdiQCzEscmAVfpN0tauNxyNkXqyOA==
X-Received: by 2002:a05:6a21:700a:b0:3dd:a197:735b with SMTP id adf61e73a8af0-3de952fe794mr432900637.52.1790723711315;
        Tue, 29 Sep 2026 16:15:11 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cc7d2d54b8asm499639a12.5.2026.09.29.16.15.10
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2026 16:15:11 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8861a49f2bdso744961b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 16:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790723709; x=1791328509; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gPiE3QWjmwTsVpl3XFuxTwOhK5xMwryQhv8LE68/7Gw=;
        b=Wk4q2MmrzNeT8oOiMUKYHxKy1Ei2eVjaC4s8Rfgb+ke/KEiawTVSDnhRX08iRZJ5Sl
         FCgi41Q6usE761atr3xJqgOaCbZGqcVejQS07BmWQBujYLV53SQ/6+JuL5lqeZ7KRa0Y
         ma+GlXNul4+A1F+ky8vFGfAkihaX+Nph/IT5A=
X-Forwarded-Encrypted: i=1; AKwUvBwcjZHueQrrOJ1WKGy/vJ0q1O1Fz5T7a90xE/VbvVyDC77JlcpGuLR664kEmeoPlGaK9FojRSQSdQPu@vger.kernel.org
X-Received: by 2002:a05:6a00:759b:b0:886:cbcf:b431 with SMTP id d2e1a72fcca58-886cbcfb6b3mr481119b3a.14.1790723709423;
        Tue, 29 Sep 2026 16:15:09 -0700 (PDT)
X-Received: by 2002:a05:6a00:759b:b0:886:cbcf:b431 with SMTP id d2e1a72fcca58-886cbcfb6b3mr481100b3a.14.1790723708876;
        Tue, 29 Sep 2026 16:15:08 -0700 (PDT)
Received: from matt-workstation.dhcp.broadcom.net ([192.19.38.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88685653bacsm565675b3a.0.2026.09.29.16.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 16:15:08 -0700 (PDT)
From: Matt Wang <matt.wang@broadcom.com>
To: vishal.bhakta@broadcom.com,
	bcm-kernel-feedback-list@broadcom.com,
	linux-scsi@vger.kernel.org
Cc: Matt Wang <matt.wang@broadcom.com>
Subject: scsi: vmw_pvscsi: add boundary check for cmd_map access.
Date: Wed, 30 Sep 2026 07:14:59 +0800
Message-ID: <20260929231459.630938-1-matt.wang@broadcom.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The context value provided by the device in a completion is used to
index into cmd_map to find the command that was completed. To prevent
out of bounds access or completion of an inactive context, check that
the context value is in-bounds and that it maps to an active context.

Signed-off-by: Matt Wang <matt.wang@broadcom.com>
---
 drivers/scsi/vmw_pvscsi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 151cac9f9..49d1950a7 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -201,6 +201,9 @@ static u64 pvscsi_map_context(const struct pvscsi_adapter *adapter,
 static struct pvscsi_ctx *
 pvscsi_get_context(const struct pvscsi_adapter *adapter, u64 context)
 {
+	if (unlikely(context == 0 || context > adapter->req_depth)) {
+		return NULL;
+	}
 	return &adapter->cmd_map[context - 1];
 }
 
@@ -550,6 +553,11 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 	u32 sdstat = e->scsiStatus;
 
 	ctx = pvscsi_get_context(adapter, e->context);
+	if (ctx == NULL || ctx->cmd == NULL) {
+		dev_err_ratelimited(&adapter->dev->dev,
+				    "Can not find mapping for context %llu", e->context);
+		return;
+	}
 	cmd = ctx->cmd;
 	abort_cmp = ctx->abort_cmp;
 	pvscsi_unmap_buffers(adapter, ctx);
-- 
2.52.0

