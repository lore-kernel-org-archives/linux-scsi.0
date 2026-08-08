Received: from mail-oo1-f99.google.com (mail-oo1-f99.google.com [209.85.161.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB7C3B5E07
	for <linux-scsi@vger.kernel.org>; Sat,  8 Aug 2026 09:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786182584; cv=none; b=fsgcCw/TeAZNeIIvUVBO1rvoYqwEfi29qG5b7bJHoLpMIGVUFvg3jrNoYCHcLUNujDvFvr8EXqJWWo3/JH5ddWax827bf/sikHV8l7OgWxt3TspOQ+7IfDvxvx9UvA9neH3QqqBIryxk3gumCULr0xlo85a4ZoP8z8DDrqDXpWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786182584; c=relaxed/simple;
	bh=5fCc8Hz1+3EpWipECt1SFJoyqPYhlz7oBxDYPJouCoA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RyCs8JeWd3B/JHeMA24o9D1XNCWj2+RhMcADBShX4YdMdBN6ZBu0tW2ft/K0g774DdmGo2TY5eehB/GO+QQgx7dfjOCcCnYlwwCkPbfO9jBjRsNBhCyjZRsSUtTOz1U7uB5XHCl61jOgLbeAEpXpeLhGzs6ZUxWvPmQvRj09E5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=U+9FN2qw; arc=none smtp.client-ip=209.85.161.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="U+9FN2qw"
Received: by mail-oo1-f99.google.com with SMTP id 006d021491bc7-6aea94f96c4so180119eaf.2
        for <linux-scsi@vger.kernel.org>; Sat, 08 Aug 2026 02:49:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786182579; x=1786787379;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=46v6GKyUY59OjS/DWCGSKrPxuxkyo1FIyqZlYLTCPwI=;
        b=RYzyjOAt0I3fAArxyfzK5qnrfekRA5BQvqQygjL0bnzQtoOUO5+DpUkdG1kAF4kuV8
         pHYOSaKOn36wOKI2UcFjmrhpJTe0qIJmwmmsRANiNyCmB2+QkZzgGgGildwx0Bo0x7Uq
         +csoDN2LWHz0pTyf5I5bGAYmuE9/6abLfI22ZMhLyrh3yVboqNDaCwmbrGH5FUofrMah
         knm9Kv1wtrnHmPVODNQsCatgV1B7AyU/SlqjUKGg8P15AEdsSXqVaYmu5gEO9ilAFGsZ
         poPQ3iePluTm7RtAFhM9WaCirXcgccVIpTLRZcGySpoRYFyXMOfu3DXdQ8v52ht0R2sM
         Ly9g==
X-Gm-Message-State: AOJu0YwYkMXepMm0UShK26s/RJmex/Q0T7ceawbu51GUAraqi1b+9Kdh
	sQMJdiJh76omPbVDBHIbaX3+ugDHvEikzvAZloUZPz8ni2ihCy/tU7ysnrpN8JZTowzRbxjIfQP
	KPUO3D2St1gK9nZALiydh1mD5gldGvH76tXTJXRoWOE62S1HjV2FFOqlcJiHWlJkRd1KWB7Dnxd
	pWbT8EAJLdQYgTcu+uJpH3ICrqXdSHcXJrXGUqNNTKcQ16pjqXerW70YiGmMhREuOQtv540Jkw8
	Sg9Allh5k1Hu0gfurrzI4wj
X-Gm-Gg: AR+sD13kDfZpWZ22ks12dr9S/ESM86Vq3JNyF2r6YU69DgeSr+pJ4KZjoMPLs1zAd7P
	gBYIzN/tKkMpNEk7Cg/kOMT+mThmuEQ6E9fYO5udUuMOIeYU0EprBvksDBtVtIQJvBCqdK/UyLC
	PHfd6dVpo2QaajFS+I3zEcy1SkU/xjQ8HQHdBhsgEBUnVJjrAm+ZowC1GnB2+e+HHzFri2PkfVl
	trPUCBymflONEef3mpteZPSR4kwY4G6mfzMMAddUZRSbU4Q31cu1wVF/+dlZaHApMrivo5T+ADI
	5KINV2s3EwCUylwMjIomcw8mNcrmMEOzxjF0QGtz9Fa4+dqZxHHv6fbTGrJkaNC0402PHyxGl/N
	R78Ydqje1H/uR7GO6mNgamYmc1km4yiNDjHC1VGeP5SJboaCQcuj2RZ9DSbik0IQYVdmv2ISBH3
	OROy77itLemFDyMIYcGjUCO8vPJBtcpH1dwDcDAjDRv+w=
X-Received: by 2002:a05:6820:810:b0:6ac:9756:c70c with SMTP id 006d021491bc7-6ae96ec7b08mr12446132eaf.20.1786182578818;
        Sat, 08 Aug 2026 02:49:38 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 006d021491bc7-6b0489f2bb0sm11039eaf.15.2026.08.08.02.49.37
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Aug 2026 02:49:38 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d004f13426so6120335ad.3
        for <linux-scsi@vger.kernel.org>; Sat, 08 Aug 2026 02:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1786182576; x=1786787376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=46v6GKyUY59OjS/DWCGSKrPxuxkyo1FIyqZlYLTCPwI=;
        b=U+9FN2qwAJyOMTabtFxh1Fxxf/pvQ4zGg4z0T5MU68G/xa7Rivq0dEXVMeqMLojaQ3
         ZQsB0zCn8VwV9MEroK7VPdOHv7+Jb5WhbTizEU1wgu6ngrjRvUFIa7xXnLjzLaBis2Uo
         6aNhNlE25F7v+ttA7ktU+TG8ZDQsAsep3a/lc=
X-Received: by 2002:a05:6a21:69c:b0:3b4:6a23:6ba with SMTP id adf61e73a8af0-3cb85efb370mr37428144637.26.1786182576449;
        Sat, 08 Aug 2026 02:49:36 -0700 (PDT)
X-Received: by 2002:a05:6a21:69c:b0:3b4:6a23:6ba with SMTP id adf61e73a8af0-3cb85efb370mr37428103637.26.1786182575807;
        Sat, 08 Aug 2026 02:49:35 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14101a5ee91sm14631478c88.11.2026.08.08.02.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 02:49:35 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Laurence Oberman <loberman@redhat.com>,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH] scsi: mpt3sas: Avoid freeing unallocated PCIe SGL buffers
Date: Sat,  8 Aug 2026 20:40:10 +0530
Message-ID: <20260808151010.185603-1-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

_base_release_memory_pools() unconditionally frees every
ioc->pcie_sg_lookup[] entry, including ones the setup loop never
allocated after a partial failure, causing a "bad dma" warning on
debug kernels or a NULL pointer dereference otherwise.

Fixes: dbec4c9040ed ("scsi: mpt3sas: lockless command submission")
Reported-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 79052f2accbd..11bcb8440e1c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5870,6 +5870,8 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 
 	if (ioc->pcie_sgl_dma_pool) {
 		for (i = 0; i < ioc->scsiio_depth; i++) {
+			if (!ioc->pcie_sg_lookup[i].pcie_sgl)
+				continue;
 			dma_pool_free(ioc->pcie_sgl_dma_pool,
 					ioc->pcie_sg_lookup[i].pcie_sgl,
 					ioc->pcie_sg_lookup[i].pcie_sgl_dma);
-- 
2.52.0

