Received: from mail-yw1-f228.google.com (mail-yw1-f228.google.com [209.85.128.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6DC2F6169
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2025 09:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758535027; cv=none; b=Hc98cRQv7y2pksZZkoBmxpkDy+ZPvHDYdxmAt6avr2yev01hbyhF/ftOdbcU/C1755dismNS0qfbLypiiyAT4G3xSLozGdPqfJjeCNVE0I9BJ6iKA73Ee3uV3zxhkja7OXJJtu9omBRHEURJLHXwNNch1XcPwM1QS0FtmEBrDoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758535027; c=relaxed/simple;
	bh=L828E0tg+R73r5MDDRnBLhRmnL6Gids4YjMY5C4CGZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVZdgqbQR1Z5JRJstLOmyk6nkd9t2qr2K1S/qOwouLJSGi+g131iGGE3c8MnbWRdCIc9ftJ1JmQ45wjNyzDilpxjMo2mz9aVYqRBKcWf9f4t/lM3ZF18O+sPqoN8IH4c0A0zgA9iLgwnharOfL9UgGZdQTIsCLMKwFf/hm5DYAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=bYE3nmqd; arc=none smtp.client-ip=209.85.128.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bYE3nmqd"
Received: by mail-yw1-f228.google.com with SMTP id 00721157ae682-72ce9790acdso39301137b3.0
        for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2025 02:57:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758535024; x=1759139824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HhX0yK4rrpKD0+953Nf0dVCcj47hZgJa4faG237Iwzk=;
        b=OM/AIsIcctOR7fTHS096xI4WhXG2+WXK/CbttA+HJx+epAVGFEx371zfssRuhBFXMc
         +Fe2a1rRkstTdrO7MHVJ7vgTpEmLtooMV+KsUyLPKXNoE627mZQ8uUNNvQ0oaJ/ThNL1
         +XJaX7kMg9vx03VK12NU1jP5Kn5+E292gR5fXp2FfXv6FsLroNSMLHEexqsHpBcSn8g4
         RSYPwHloTnziHMre7d/5qljDyd2I6qMOj2HiZ+10LqIeMWIGSNRVFO7S8XtNMElcG6+7
         V+9eAB/relkels2IlFj341ENSQUc3JRPVr712QOXc5cvOG25qiG8lJT4nCTKzZrYZJdJ
         jPHg==
X-Gm-Message-State: AOJu0YwT/GhxXsP/A18dDjmk7AvBVS2419QYajdYVaI+JYMKDyW5a7va
	RPr4ZKQSkbDjPK5Q4P1fxYNiI1mgZ3olORoAvA8QhwS9p3SHyY3XOFa6WIMU4CFDVNh0nB6kaNU
	OKmhGxY0O9youmn+uPY0TdhwRojRkqT0hi7iGwyDpdMikduZGha2z/6SwPQf7YRabjF1PGDLrPU
	8d2100jVlidPdyKoBJCiYyabVgWGT32UZFh/SznQru2TzcygFHgnvAxBsQqBfAhSdJmZIZ6znj2
	ZUw5x/n7QZ8P89f
X-Gm-Gg: ASbGnctyTrYp5whsFFceXMQykgFYWd68sFy0UQdo6kdUqwU3Ei/6HfV396PvWJqkwrL
	9Llw762QE+NSHj9lylfEqPIwOd/LtMU6BnMu1Z8Ga/kf1nIAj3Bf9DQCYqLkFJ6h7vB8Ixje96Q
	LE8M947/NQkJvqFT6xjGqDMollHMo0yt1PRa6Meco/LRSWtDRreOEeYdvi5nE+ophxj3WLehkwY
	L4BnZkKLv8oZOgGBZzu6bQHJU8MvJhhmGPXh0qnvJNePEMAogE210NGKx/DlzaBknRUJGVkKnAD
	d9H1JsbFfumIszNLz+2BjaH/I2Wjf7+hIZQ5l1PHoe6gq/JFyyJ0OkYtOOYjiIBLxPp0Aplhbh3
	datkWPTtEp9leQ43LG32Xogwa7VqCO9oCvcw3A5k4Fzymi1/OQlGLMxzDEKaFrp/PMT48z30QCC
	ylVQ==
X-Google-Smtp-Source: AGHT+IHZ2ietFCmB/1C7HloOfHu/B7idEWb2SfASD4dNWNLn9FrJKSjRz9P25c1Jh4klYQ1gjzRV4Ix47Va9
X-Received: by 2002:a05:690c:88:b0:71f:e154:7aa2 with SMTP id 00721157ae682-73d3c0170dbmr95558257b3.25.1758535024366;
        Mon, 22 Sep 2025 02:57:04 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-101.dlp.protect.broadcom.com. [144.49.247.101])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-7397196275asm5407917b3.30.2025.09.22.02.57.04
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Sep 2025 02:57:04 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-24457f59889so48598865ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2025 02:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1758535023; x=1759139823; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HhX0yK4rrpKD0+953Nf0dVCcj47hZgJa4faG237Iwzk=;
        b=bYE3nmqdBI+pQJ3xqHL22TtnmKAC4nFV6rL8vBz0J5t2wSCWd+KU3lX2aypQquBTyQ
         TYdu2ANBpAvx7dJU8K0N3CxaJrz4+aatxLMg4IiJaJAEWjnIKedjBeq1v7apdtUsf5ao
         74R1zshtljB0YtjblcciHBC4rRRdNOHLAMwRI=
X-Received: by 2002:a17:902:e84c:b0:24b:640:ab6d with SMTP id d9443c01a7336-269ba538bb4mr185497315ad.49.1758535022717;
        Mon, 22 Sep 2025 02:57:02 -0700 (PDT)
X-Received: by 2002:a17:902:e84c:b0:24b:640:ab6d with SMTP id d9443c01a7336-269ba538bb4mr185496835ad.49.1758535022090;
        Mon, 22 Sep 2025 02:57:02 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77f4594a76bsm1034584b3a.62.2025.09.22.02.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 02:57:01 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 2/4] mpt3sas: suppress unnecessary IOCLogInfo on CONFIG_INVALID_PAGE
Date: Mon, 22 Sep 2025 15:21:11 +0530
Message-ID: <20250922095113.281484-3-ranjan.kumar@broadcom.com>
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

Avoid unconditional IOCLogInfo prints for CONFIG_INVALID_PAGE.
Log only if MPT_DEBUG_REPLY is enabled or when loginfo
represents other errors. This reduces uncessary logging without losing
useful error reporting.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index bd3efa5b46c7..0d652db8fe24 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1420,7 +1420,13 @@ _base_display_reply_info(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 
 	if (ioc_status & MPI2_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE) {
 		loginfo = le32_to_cpu(mpi_reply->IOCLogInfo);
-		_base_sas_log_info(ioc, loginfo);
+		if (ioc->logging_level & MPT_DEBUG_REPLY)
+			_base_sas_log_info(ioc, loginfo);
+		else {
+			if (!((ioc_status & MPI2_IOCSTATUS_MASK) &
+			MPI2_IOCSTATUS_CONFIG_INVALID_PAGE))
+				_base_sas_log_info(ioc, loginfo);
+		}
 	}
 
 	if (ioc_status || loginfo) {
-- 
2.47.3

