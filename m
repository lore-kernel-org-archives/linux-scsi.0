Received: from mail-pf1-f227.google.com (mail-pf1-f227.google.com [209.85.210.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE0935AC12
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 23:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790723751; cv=none; b=d239TxRoJAXEHv6e748J3gsEJiNuEdDA8QmiLgmyXCFxRMOJZlDN6Z+MN+/OZ1BqIFIP8wFa8pKr2kntw3Lx8+SSh/mptpVnHbBidETf2zy5IRj79ww6w9Sc044ZTtCOJE7FGzxJCax7x7/5iQUpz8EGl/LYlsV9WM4NkKzWtUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790723751; c=relaxed/simple;
	bh=k/tXTXbO7IiKtw2AaFqQLU7gf/Q604o+tCj5shm3tbA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IfyFhUY4+cKvm8q18UuZKbWIloyC9+9x+bYzNRD7VGA4W4K3fS7xUT4+wE7ZrI8ZKcSruTT4lQhBMmxgx4M5Fu41qL1V9nIXmpfYgUmt81davIyB0kXCAUenPB870o+KAaxBNEPEChcy04ncV3QX0JP09DekimhFQ0SFNEgla2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=I7Ne3GEa; arc=none smtp.client-ip=209.85.210.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="I7Ne3GEa"
Received: by mail-pf1-f227.google.com with SMTP id d2e1a72fcca58-8819033dbadso1090964b3a.0
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 16:15:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790723749; x=1791328549;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mb0Xuw2hsRE9Rh0sEojEm3qW3tIg9er9OBi3tNQNZUc=;
        b=M85kIhPfwOdga3pNAfQXH+vbfF8GRuLVjQ/7asf/iP8nGksI1UhDKyxvr17KVV6VJ8
         FM+LR1gW56M//HgU0J5fCGEGMXtG6N+UpxfEroelWysQ8O36U4nYihjcGz5LfZETZOQl
         srUCvjsM2A8i72KO2yF7242v928LgGKsiz/i8AmpH1JhxjffjZKbudcCXo5nupFOoCNB
         9RzNklsYZfcI/pD+l02zG/MSM8jJMehoVmkQM/nYfDaHTkiszjBowR95L0lnMjRtodgS
         v2lVKX+2ncnvgecZPmvnwGO5QtDhv0zfsvtPYgEunDkeNEaPRggIz80JdL8kkb6oRd8Q
         8Xsw==
X-Forwarded-Encrypted: i=1; AKwUvByFOGo4PyUaQ4/5xqra6Zx2sVkzjMZg1WPfLQGKmKkesUrW9a6TBcFZTP+IBII2ZY+tYgwigv6jy+K5@vger.kernel.org
X-Gm-Message-State: AFuF++leBRxeoRilUKnIEBgdCkJ9WMWUAQ7Ur5r9Z/QOwpLgd7W6Yxnw
	mrtc4V4PeAxUONUhme1eT0R2sZf30DbvjZ7EnzWdoQHqF4CGocC5TPG/MeyGjCWTiHgUEVv3P1O
	IxOEyGvUbzO3gsvI5xNUqtSHPL4DGjTWHIaYUzO19z4WVdIi03XAQuCA/9dzJ9vo+Glp2k/nrtg
	+Rp1vYXHB6q93oOKd3oRsM3woZmVFhSCvMkViS+9+cfaJaZx4jGxU4zv9/teoD/NYYB380lm0Cd
	Hv7gjUrfgvB
X-Gm-Gg: AYBFou1VSqoT2EML8bdFMvMfmUSXq+TXX+44BZQl4qO9ApR0AZxbZ8mBTwDjO4Bu/LJ
	cdwtwc+4BMEHX8ScI0FkI111Hbl4YykC+5jWV6+gtupzgYLfA0yF/f+Zwh3NpwRYb6rLWwYd0Tm
	iCs81ponRrS7tJg022bmqgX1BlgZ1HvDP2KAwPws4SyXrFG9/jIlqI4yrn07xKiBpg+qgTBKMUZ
	gFCGHzNcmScpRMm02WOX5+0sHuWPhGvvLgdmktea5sDo6fSDYszlWlIsTlhjuGSCaAxKppLq+nL
	d9GNrvRM5UlhxJGvM6lEqokb3P372lUr33c4x5lvD5xzKdCrYO2hjdHjrWGHsrDjk7HOY+/Mj/p
	T4q5GkpIR5KKnqCwdj+ugVAbIXo5YTp1yp2skKKzO9ukazsq5YIkdaaD1W8WkfkCdBnhtig1fa1
	tY5c55DhlMiuCO5DqIy60ck9YP1ieo59S7hQ==
X-Received: by 2002:a05:6a21:9216:b0:3de:6cc7:6533 with SMTP id adf61e73a8af0-3de9538b557mr446190637.52.1790723748842;
        Tue, 29 Sep 2026 16:15:48 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cc7d2d54b8asm500653a12.5.2026.09.29.16.15.48
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2026 16:15:48 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38ecc48b3c2so10184141a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 16:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790723747; x=1791328547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mb0Xuw2hsRE9Rh0sEojEm3qW3tIg9er9OBi3tNQNZUc=;
        b=I7Ne3GEaWWxejTiKWAFPnjS8wqJF6NJJKbB+JflzS1bpDKhbPqEf22WmNBmUSd9YtR
         UxaznW6G2aALaC5CqVakifTlssm3PyzWC3qdnLUTSTjnE6zA/AJ6GW1hNIDXWn/kn9K1
         UQtyhZ1Rty5PGl09LWT8+e0WVKYJtiMCCgE8U=
X-Forwarded-Encrypted: i=1; AKwUvBxvZMc9nIOnKUQucLITcWLfFekAUpcGirTlHyX06rUcdKAZPO193r5LN42J0KZtK+cqa5AozYO5Zffv@vger.kernel.org
X-Received: by 2002:a17:90b:4aca:b0:39e:4c80:44be with SMTP id 98e67ed59e1d1-3a4bfe52dcamr673036a91.33.1790723746872;
        Tue, 29 Sep 2026 16:15:46 -0700 (PDT)
X-Received: by 2002:a17:90b:4aca:b0:39e:4c80:44be with SMTP id 98e67ed59e1d1-3a4bfe52dcamr673021a91.33.1790723746358;
        Tue, 29 Sep 2026 16:15:46 -0700 (PDT)
Received: from matt-workstation.dhcp.broadcom.net ([192.19.38.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4cb1919ecsm67743a91.1.2026.09.29.16.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 16:15:45 -0700 (PDT)
From: Matt Wang <matt.wang@broadcom.com>
To: vishal.bhakta@broadcom.com,
	bcm-kernel-feedback-list@broadcom.com,
	linux-scsi@vger.kernel.org
Cc: Matt Wang <matt.wang@broadcom.com>
Subject: scsi: vmw_pvscsi: clamp on e->dataLen in pvscsi_complete_request
Date: Wed, 30 Sep 2026 07:15:39 +0800
Message-ID: <20260929231539.630963-1-matt.wang@broadcom.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

When calculating the residual bytes, clamp dataLen to the buffer length
before the subtraction. This prevents an overflow if the device sends a
larger value than expected.

Signed-off-by: Matt Wang <matt.wang@broadcom.com>
---
 drivers/scsi/vmw_pvscsi.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 151cac9f9..8e2c1b20f 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -548,6 +548,8 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 	struct completion *abort_cmp;
 	u32 btstat = e->hostStatus;
 	u32 sdstat = e->scsiStatus;
+	u64 data_len = e->dataLen;
+	u32 data_trans = 0;
 
 	ctx = pvscsi_get_context(adapter, e->context);
 	cmd = ctx->cmd;
@@ -590,15 +592,16 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 			 * returns zero dataLen with non zero data - do not set
 			 * residual count in that case.
 			 */
-			if (e->dataLen && (e->dataLen < scsi_bufflen(cmd)))
-				scsi_set_resid(cmd, scsi_bufflen(cmd) - e->dataLen);
+			if (data_len && (data_len < scsi_bufflen(cmd)))
+				scsi_set_resid(cmd, scsi_bufflen(cmd) - data_len);
 			cmd->result = (DID_OK << 16);
 			break;
 
 		case BTSTAT_DATARUN:
 		case BTSTAT_DATA_UNDERRUN:
 			/* Report residual data in underruns */
-			scsi_set_resid(cmd, scsi_bufflen(cmd) - e->dataLen);
+			data_trans = min_t(u64, data_len, scsi_bufflen(cmd));
+			scsi_set_resid(cmd, scsi_bufflen(cmd) - data_trans);
 			cmd->result = (DID_ERROR << 16);
 			break;
 
-- 
2.52.0

