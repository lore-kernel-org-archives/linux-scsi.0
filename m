Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BF4287245
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2025 09:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758535029; cv=none; b=AGhvYIwXafw7ZFjBO0wXRBvBX7NkwvImzYjYR/+JjBxfSCEjm/or2oSOSzkmPSHVp+FszQXnE2KrZ1TQp9H8lyg6sXJKgv4uaCQm184OKUZoKXO5/5gHUwxp25zGw+sAnOKTwdZCQxmcuw0LeYE6a+2lErKZt4IKtsTFmqygqSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758535029; c=relaxed/simple;
	bh=7Kyr7zJkHSEnG4d3ZWK72epc5y+j/X3wcZUDrGH6odE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rufLQ0djvA0/mIr8yCf5gLZhrCyLca0l6ZExX69LJjIPhBjONH/8fDCBVATlpqbcJGSNhVt5MW40N7Hg6aNEPdyU2bPvszke64AQWgqB3FZxmaJQwC5R6tbbuEqBdlx9jx90iD92KtBCaeLa23yH61/yv214lpFxFPAfpovnFCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=AMdcJYBp; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="AMdcJYBp"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-271d1305ad7so18484545ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2025 02:57:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758535028; x=1759139828;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lz1haHidYfFiIu4re4Y+9Qw4DPFnjXNS+BrfhdqvarE=;
        b=dFoqCS7beaRf0Ezr2/BMNrR23PYVxONPt1f5ZT6+w4iekUU6UYYUS8TdiGz6hqQQa1
         33NlL15cJJ/gY/xwIZ/XeP1ic7l9FIcHgDlM9F+i8VmQh9P+A4uMNJCRkEqYOLZMWvR5
         ZTg6UxpIC1D7+PKejO+obyS9fVmljcN2CWrjQjWSXbxg1mQZhtPY0YfuAJGFqeYUcgr5
         gCV5fwrarpPAKTa0ZUE4M2HVATNOaiToEx4xbLMg5FHYYco4k5GXvept+9LbThPwYsVM
         a3w1KdYYcn1wxLHYCSHvEvJcpAYlxdSIRAynL3T9H0RQ090QF+H+QhVgw12MIJ9s7/Rf
         ZBow==
X-Gm-Message-State: AOJu0Ywf5LegjjlHLnQUoSwaCIJb3wHJPRic4+CwZXPYp4gwmCtMsZku
	ZvSjntRzlYFmU1+KusdlCD+ATd1tArrK7R2tLUVpiCmdmnr84cQLaoAADc2ngYkH6cby6HWNp3J
	JvvD7vWgIKM+s2Ql3oBR1RG2YcsQzi+eQKSjYLPFbVmkTi5aPCwnhl3wdJa9ai3i8cQlHzrXmgP
	gYbySKGTM+5cCxgMiUtrVKfWT7M6A87OmEyzooeTJ6cRmpq08rOXRZJ+2q5b0b6/ML1JN8TdNEW
	dUeOJzCdguAYWZ+
X-Gm-Gg: ASbGncvt7CcTc1jU8K5ssVR09s8yB2zk1V9BwLwu/6P54iOPdsd6f5Y1s59k03s+Oum
	Gm9OJfQ7it2txYzitXZJJz9kdstXwihx4Xnz2ZOePIklyDMkAKrH9EWTnC8eMmLpxFZH/rOZLbe
	iCvDrKzlTGQz5jpLS7mPW3zh6L67RqiVKheWsz7EruOFeec4VUB/IJSxPg27fBPhEEfMRZHEh9A
	MazXACXdRldk7SxBt/Banc8etWRU3tkP9BTmL5XJyxtuKXHn9YJ3AfU7OUwdbZZAc0dtCvQk7XX
	DNgJjC3nW+Ccxk7P8303Q33k7KYMybpW19DC+788lC33cMDh/jGz/26w98fDr8ZMX++wyQPCR7O
	n3xyxM9a86A33mgcztLWMaN+9FNkguGYy9h0KdweQnYrep+/9OhK01T8+lAEwxOseYTzDcgBZ3x
	Kv+Q==
X-Google-Smtp-Source: AGHT+IHGHAFBZhvQmf2oO6DBK1ha+e27JfTwIRwQka0bDuAX7kPANAt/7voTwlVuRnCtmJFXypZTB5+cU03P
X-Received: by 2002:a17:902:8c8e:b0:267:bd8d:19e with SMTP id d9443c01a7336-269ba45a535mr118668965ad.22.1758535027612;
        Mon, 22 Sep 2025 02:57:07 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-118.dlp.protect.broadcom.com. [144.49.247.118])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-269802bae5fsm7950395ad.63.2025.09.22.02.57.07
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Sep 2025 02:57:07 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-32ea7fcddd8so8265411a91.3
        for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2025 02:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1758535025; x=1759139825; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lz1haHidYfFiIu4re4Y+9Qw4DPFnjXNS+BrfhdqvarE=;
        b=AMdcJYBpQte+h0W3vEiz61/QvOsWyorDKcIRCnvnKd4NIUTWSEH/RoiS1Ytf6ahdBv
         2HWLcNPCNCeEqZPfh4r8XU8h7vUq4k17Ss9HcYEXyhtLpliBHv4++iFV9azQjM2w1b16
         kTRUxsIXZxXUhiEwh/A92iNupTASqWJXbzL/c=
X-Received: by 2002:a17:90b:2248:b0:32e:3f93:69da with SMTP id 98e67ed59e1d1-33097fdc7afmr16925660a91.6.1758535025434;
        Mon, 22 Sep 2025 02:57:05 -0700 (PDT)
X-Received: by 2002:a17:90b:2248:b0:32e:3f93:69da with SMTP id 98e67ed59e1d1-33097fdc7afmr16925629a91.6.1758535024845;
        Mon, 22 Sep 2025 02:57:04 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77f4594a76bsm1034584b3a.62.2025.09.22.02.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 02:57:04 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 3/4] mpt3sas: Add support for 22.5 Gbps SAS link rate
Date: Mon, 22 Sep 2025 15:21:12 +0530
Message-ID: <20250922095113.281484-4-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250922095113.281484-1-ranjan.kumar@broadcom.com>
References: <20250922095113.281484-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Add handling for MPI26_SAS_NEG_LINK_RATE_22_5 in
_transport_convert_phy_link_rate(). This maps the new
22.5 Gbps negotiated rate to SAS_LINK_RATE_22_5_GBPS,
to get correct PHY link speeds.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 66fd301f03b0..f3400d01cc2a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -166,6 +166,9 @@ _transport_convert_phy_link_rate(u8 link_rate)
 	case MPI25_SAS_NEG_LINK_RATE_12_0:
 		rc = SAS_LINK_RATE_12_0_GBPS;
 		break;
+	case MPI26_SAS_NEG_LINK_RATE_22_5:
+		rc = SAS_LINK_RATE_22_5_GBPS;
+		break;
 	case MPI2_SAS_NEG_LINK_RATE_PHY_DISABLED:
 		rc = SAS_PHY_DISABLED;
 		break;
-- 
2.47.3

