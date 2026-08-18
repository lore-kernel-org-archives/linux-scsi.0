Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6E73A6F04
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 17:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075815; cv=none; b=WXWZavb5KBfRDgck63mpDYMHp2BsniYKouSmLEGq6xNm6cFDHtOhktUOi/MHenugB+9loAZdiPYx+4PQuSELvyyrgyLD23hgoilwa9jJyGD/q59cLSgTC0fSifvCkEh0GTxNj5daGkS+eX7EPI3sedB35/fcp2Iojg5axE5Fp0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075815; c=relaxed/simple;
	bh=aTyzsVyuGcv0Gcdnky53ROEJHGdkie8V+7Ax2T8Kc1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fg5aWp1Zbq0x1fEcCZpwj7F0klUiHQnojfdt3wSF6zd2nXObYcszArSK2wmOv3m12A4m0GA7zZ5fhsOuuPFsXnXjc8nldQeYL0SnnHRhR2NMADT4Y8HmAc1mlt89jmhgXhtZgcqi9l+LCmfNp6AV/Q7+KRCS5p8BRHmlhYzhHLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=DHt83Izl; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="DHt83Izl"
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-38e08baf860so230842a91.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:56:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075813; x=1787680613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mUVcjWxCZQLetHdmo18G3B08J4ko9ROQ7mymaSfSrHQ=;
        b=HjjsnTB9n93ubqQr6Dudh/m+CfGhm/mpOXNlSGtH12MHqOLZIft+BMMC3yjfEKG2el
         qzXUoaJAvIz9mbHBOS0g7t8gVVxhvaMRoa9jSIqKv403IuKkC6FIE1AfB/Z6H3qRkDUy
         rhSCBfssvjOZ0iEr1WnX8l9IdjT3iHIpc2sbYQUClRSHJyHcZqd6e7U1RatEJ/wrengv
         JWLWfzRKddw+Q7NKDZbCPz+MszXGVaon7Lc/dirU58PP8qdsf6neD4oYTI3RrwZEwTGR
         YACz7EmjK43qpiiZBMr1hYPuvB+fXIMSKarG4PJ5CwWvmfu0yQKZmMxHYTM4shzn47q1
         u2Hw==
X-Gm-Message-State: AOJu0YzYigd4soWhVsLoZO1/Y+bF0abstBRH5TrvCXYhNNZL6YGNOJxt
	D5LsCP1KHrqxrjCIFIIArztUqxTe1mIwIFsrsHJOCdXa4cvDxgXEM1l2xS52tBo2aSVP4+d+J8D
	HXnxn2K52ZQCe5kYKn5LoUMly1YrwGHOmCDniRDxwVXjVdw7DuCvh1BNlGc/nwpV5lhJkMTYtqs
	G8qdg8yyf3g8Zrs/YLJJ4/2Im5WyUed2oQ81V61NGDv0xKR4b45Afu0FuXl1d6IWHddWxcg7FD7
	Cyp5wfeBa7b0S8hAIEmyXzg
X-Gm-Gg: AR+sD111gXjDSrC7oXpI+3M+ViAx2gqqOHY06skfrOMK/0qgcL2e3S406I+x/E01A84
	7QKi4Twei1FqV3rvCVymB51rGRfXDEO4TT8y6q2uNadzGdstttEzfTL+Jw28iSOpiph9+bQscPE
	6Vrm4OxV8KbbM7PzBmj6aZcQdAn2xjaRHsm+FBSWvm2J4QhrYdXLpayrRaO0scJoS/MYm9PDH3h
	nSiaG0j5fI821QCwJtljUZ1ffmCpFKDPSgrAQ/zVvKD7roy8DYKW0pL0uA8DkpypWFQmeJ8buV5
	6XdCNZHVIzIjhe2jX/yGwmeXn/pJEGo2O8wY7pjXsh0LpHt2Xe6gW/ibXqY4rdhW/zApX9h2Vvk
	E9aBwwtbXXesdwucBRzsEPfITr2OQD2DU8SamEDucW/MspVC6PYYj5Yxlfiq6kC6vfAbdVc85aV
	+5HtMhnK00oBhVieq8y5pyoWRWbW+dyV0B29HU8BXsPSg=
X-Received: by 2002:a17:90b:5624:b0:38e:7f1b:efa with SMTP id 98e67ed59e1d1-3933e5c4f30mr41916755a91.11.1787075812992;
        Tue, 18 Aug 2026 10:56:52 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3954d38aaecsm2637462a91.10.2026.08.18.10.56.52
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:56:52 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cbee6bb8408so66569a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787075811; x=1787680611; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mUVcjWxCZQLetHdmo18G3B08J4ko9ROQ7mymaSfSrHQ=;
        b=DHt83Izl901XPlTBN7kr50INUEtEGocTmHsJAw1WQ5xewt00RHlgJPWS3NUL3qLmUU
         YFDw/owiZP+HWFfiw5KjeOPVr419WqlmsIyqkndeWad11+Drv3UWKRk8LC11u/6WKPre
         5Y//g3jPkcHti6/WclPNHHQFL1iKEGA2hvZaw=
X-Received: by 2002:a05:6a21:7a9b:b0:3b3:2703:115 with SMTP id adf61e73a8af0-3cc71d45a9amr43503848637.16.1787075811145;
        Tue, 18 Aug 2026 10:56:51 -0700 (PDT)
X-Received: by 2002:a05:6a21:7a9b:b0:3b3:2703:115 with SMTP id adf61e73a8af0-3cc71d45a9amr43503756637.16.1787075810505;
        Tue, 18 Aug 2026 10:56:50 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14153187de4sm16741958c88.15.2026.08.18.10.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:56:49 -0700 (PDT)
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
Subject: [PATCH 02/17] mpi3mr: Fix out-of-bounds read when copying BSG MPI requests
Date: Wed, 19 Aug 2026 04:44:11 +0530
Message-ID: <20260818231426.58105-3-chandrakanth.patil@broadcom.com>
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

The MPI request is copied out of the caller supplied payload without
first checking that the requested amount is actually present, so the
copy can read past the end of the payload buffer.

Check the range before copying.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 8e5d24793efd..1cd1c38dcd56 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2538,6 +2538,14 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 				rval = -EINVAL;
 				goto out;
 			}
+			if (sgl_iter + mpi_msg_size >
+			    dout_buf + job->request_payload.payload_len) {
+				dprint_bsg_err(mrioc, "%s: MPI request buf exceeds dout_buf\n",
+					       __func__);
+				mutex_unlock(&mrioc->bsg_cmds.mutex);
+				rval = -EINVAL;
+				goto out;
+			}
 			memcpy(mpi_req, sgl_iter, mpi_msg_size);
 			break;
 		default:
