Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FE43A6F04
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 17:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075799; cv=none; b=WVqmuxZweiI4VrDNSLl2QJARsm4i1CRFjBv18Dq+7VeVunmGW98hHNONYs52NRKAXbGWnvxYTpYXLOcABEARDes9b26k2xshUQUQafawXEco8Ih/UCacHBDEst3vK5ahD4FpQOXjAkHhYVo7YWPaF5Sy0e0aSGz3VQxG6iuk+/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075799; c=relaxed/simple;
	bh=WtJZbbNgIt/aOMg7MVtTo88/jhhaC9s9Y8XX+W5eUXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFKtR1rZZl5BDeN0W9gkcb1Fc9iYN7cLUV9Q0Ztk7BVif0fV53aMlId8ylCTX0l6rBV5TzFoqmudQ+F5ImubrtgxnQA1Z9pC7IK8rk7kP57XYQmkW9qpv6ZMWO96IjOOSxoRq2OdFZCLmVAHDFsT4x1Shq7k0p3lZtQ4it95Oh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=IUH0etdA; arc=none smtp.client-ip=209.85.216.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="IUH0etdA"
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-39266382df6so182484a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:56:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075798; x=1787680598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8vijHrHMSC86Fgt8ou62qfC2tAW5dapTP1UAefJKOPI=;
        b=jsaxiX7TI4PTMcjlY6mzDN5POqRo4gzqH2zbIfDr1iiFwyAY8H+CeMoEDOURcvlElh
         sEFAB5jHgiRv9gvq7NPiUuSZOg9Y3Ka+sP4tCxmeYAZnPUcSBjIRhVWiTeX+TyzeSruY
         V9scCq2n71aPsv2x5bDhwzN/rVd8dPhrmiTOMjQMcdhboyXyEb4bLyIKh57HKcV2FWlD
         qWCZzyRCpslTU5VV+Ah1XlsYijtHT3F/QL3huj5cEs+7dN9rHrw35nir7XR3HfyLShDk
         JCMXxDa5ppUWcYNjAnfp3JjDFsTZFS9KoaqPDqPHNWCwLWwjiXKi6H7NRok0OVexRLc0
         ab5g==
X-Gm-Message-State: AOJu0YwlW9o2Q3vH7Mn4NTxCqVQYVDX1CATc32hZICFEZLV//QQ7Dw1z
	EwGGzJH2wtQgzg5VVc2U+A5t490jruDOigzxz79iNXs7ZD8vR7dTfiSbNb9Txa4tz9sLUXbdMS0
	XonBiWk45pIAfZmchB3IjdfU/ikF8qp/0fcmCRd6oC4cB8CpF9V6f9QnPKeZAk7nPRDY/Zd7tS3
	zwSXzsQrOp6iL7k4OIabXPDnSz8DZsLdZt1QADRhRCcYWggHSWD/Kem/Vy+OzzRUCOfN5aufSMS
	7s+3ROwZbZuoQaaggQVvZUx
X-Gm-Gg: AR+sD13YHOig+tlQDPuDqItBMROCojFogOmyg13PKsJdAp305nhABs58De+Q/N94/e+
	uxFv6d9p7JTEq5Y4dzBtQ+NHEAkhAVTLUGoULCdk0/loZ4neCi17TE7raIT4DmStOJuMX6D5ZVy
	L/kPVblkfj9veNdIxJOh7skw7/Am4AQsirsz9IOlImn35fR7BXRG7RBrNn2ZK0xdWNkj6z7jZ36
	7o/quJBrPbiLLTibIEkFnd2n/0Yefx2RtaXgoXXca2y7C0Xj5Z7S49Xm2yQYxZj3iv97s/KPuAN
	tS6RjVpp8C30yTJQUYBxINQHKcpr44bA9CdRQTvKz0ZTS8T2XP7axcosUjfAx+ZRVVVKqGwT4IB
	dEHaWwxWaVxdig3jGKXBh70DrL7hcK/WSUB4+eQYzUctDngLA5qfSxiBmsKak2WNinFs0Eg1fv9
	Y8c2g0XZ0rO8ZHkKRJC7fG/jnaBaOXR3tola4hMU/28n0=
X-Received: by 2002:a17:90b:314a:b0:37f:fdc8:71b4 with SMTP id 98e67ed59e1d1-3955a3dadefmr12503671a91.2.1787075797440;
        Tue, 18 Aug 2026 10:56:37 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-19.dlp.protect.broadcom.com. [144.49.247.19])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39531ddcf26sm4228379a91.4.2026.08.18.10.56.36
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:56:37 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3931cd2e4cbso209495a91.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787075796; x=1787680596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8vijHrHMSC86Fgt8ou62qfC2tAW5dapTP1UAefJKOPI=;
        b=IUH0etdARJ2r2MOzzWiZsW6ddSsT14dydvLRL85v0pTDZdxX23XBfk4N/THRQgclbY
         AmrN7TUKWMg7WcaW4bLDQvlP/6oEnHio/ZONE4A+Mho0FO8edaKHPWh9c6PoHMQ0Pma4
         EcZQ8nga+4jBjBidGIXnEFM83Oh+PohYe5sY0=
X-Received: by 2002:a17:90b:388d:b0:395:4de5:1054 with SMTP id 98e67ed59e1d1-3955a7ebd62mr12739178a91.16.1787075795905;
        Tue, 18 Aug 2026 10:56:35 -0700 (PDT)
X-Received: by 2002:a17:90b:388d:b0:395:4de5:1054 with SMTP id 98e67ed59e1d1-3955a7ebd62mr12739089a91.16.1787075795264;
        Tue, 18 Aug 2026 10:56:35 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14153187de4sm16741958c88.15.2026.08.18.10.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:56:34 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	ranjan.kumar@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 01/17] mpi3mr: Fix buffer overflow in BSG passthrough request copy
Date: Wed, 19 Aug 2026 04:44:10 +0530
Message-ID: <20260818231426.58105-2-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The size of an incoming BSG request is checked using a variable that is
narrower than the field it is read from, so large values wrap and pass
the check. The copy that follows then uses the full value and writes
past the request buffer.

Widen the variable and copy only the amount that was checked.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 1353a8ff9c85..8e5d24793efd 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2384,7 +2384,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	long rval = -EINVAL;
 	struct mpi3mr_ioc *mrioc = NULL;
 	u8 *mpi_req = NULL, *sense_buff_k = NULL;
-	u8 mpi_msg_size = 0;
+	u32 mpi_msg_size = 0;
 	struct mpi3mr_bsg_packet *bsg_req = NULL;
 	struct mpi3mr_bsg_mptcmd *karg;
 	struct mpi3mr_buf_entry *buf_entries = NULL;
@@ -2538,7 +2538,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 				rval = -EINVAL;
 				goto out;
 			}
-			memcpy(mpi_req, sgl_iter, buf_entries->buf_len);
+			memcpy(mpi_req, sgl_iter, mpi_msg_size);
 			break;
 		default:
 			invalid_be = 1;
