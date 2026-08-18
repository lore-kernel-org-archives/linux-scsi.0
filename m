Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8173A6F04
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 17:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075823; cv=none; b=NEuPyn7wQquPQv/pq16alZunaVh5LQFDvggBO3FbTZAtsJZWHrRccnqsQnIcHYyVNm1cieRS4KtLmh71n7o5q5CiFrq7CETQHFbN6eEz7hbopR4b3k7u2hyTTnh9Q0fd+1C47N6ThU/NPkZn66tYBW08Dv5/yBywv0NGl9CqH4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075823; c=relaxed/simple;
	bh=d/0ygElOpnfe8BHJ5ogGY6feuVqknQ14gzFbFJmJzMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgvFMVurw8B3OkVpHvTxXIgvLszlOD0YgW2cWRLYU8DpleOQ1chGKbVgpU/RU24xsnH91FCmAaP2sEsXU3jTlz9d2nTogBbZBRte5Uo/+VSAczwXaMQY92MJpRFsaOjc2G5bLVTYIysEcfLF9kfl8LxorBBS4dxrNR4dw628q38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=HEAM1WKq; arc=none smtp.client-ip=209.85.210.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="HEAM1WKq"
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-8485ef63b68so170429b3a.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075821; x=1787680621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cbi681PCBHwtVFlW3rwwR7ihb0boh1UvIQ+C7BHwV+A=;
        b=DOJ28fQ3yI1H15d9+3qJPQRhjuYxbtLAf0KmdSuJatjivdfJ1M6SGG63kRIkfpK8zr
         8Rwl3KTpXzQibClZmg27XTCjz/pe16ItqccVDlycQ/tXGMw0uyMKNjCR2LyBQHeq/7ZF
         IDmYSgraglT4hWvcT/1onf343M3DnmCMKjCzMHMcQ2ATI6AJL5aJ6eU2oKAGMJ/QGP8F
         cQlBMWit48TPL5ovKEIUKFqns9M0fnO48jX7SPurVY1y/0+g/RYDpKv6ep55zPrn1P97
         UY8JL+txx3d2XreT710A6i7aCopGI7WbdWj8oSlgpdQUU4/LvR7QsAZNgPpK9067V98l
         smCQ==
X-Gm-Message-State: AOJu0YygSdoBp766wPeFjn0NLcvcqBoWl/DzJKSBrbyGRFM4zYLRTxvu
	7ifjYLFMmFLfOSDZFbcBkmO+SE8gIsYfnS85rbDAdIUbVc6U2LnKOUq9z3K17R2fftoDU29Swez
	hyOtlgFhP+1eTm1fAj4X/Mkl4rWAdpP9n5vIJ+RiGvNACyVVFVVGU1GnbbpG7UY+qM0hawQRcdq
	HqAMuBIfR0Hs55wMILXCPElTLQ8lKhiY4407Wdf2HkvgJpTY0N2pawB90iH4paTMXFDqXDi2FxC
	O7+aPHtL0UFWeN3V5EjY+Qh
X-Gm-Gg: AR+sD112w/ld0ppL8Q+wD0ba/QUg2J/sGqAlW6Zkcyqex3/mGURarrjvJFXJmOSjh9p
	JQlmjgfDVSsnBAEuXvrCI7sCHNiHTkYmket0Mosgq7hX4EEh98Rllk030M7Z/mNwfWCO8CZSwCC
	819u7Jp3fA3ipEsa38DMPAU+/JIPDvAKCRHjH+mT2BDB3bG8kmBQXdfkQBYoEQ4smEeAU0ySXm6
	aHoc9nCE6H+sCnGQFqUxR1Cnb0/DgR+0Vj2ZL9GuzswWZWrK49L4JHWrSSo3XkPtYfoBYf8C2Dc
	mYbxE/8tkB+vXFQb3pbwqi7Zt95Wkb2R5eyS8pnVk2v/XWUsl+suNpi1BSe10lsg4G8LJtoFwwy
	s7NDQVL6nNRgwRSx3778S7jMTjsTTMwue/DaTzW+tIh80BlHFxMN2+OcA0LOrmnEqlzy+MPJfs8
	1g+VLN0QCzQJbuNtZFfRV72psIVgRs064yVihEVz5VYMM=
X-Received: by 2002:a05:6a00:1742:b0:847:9745:2f8f with SMTP id d2e1a72fcca58-851cd860850mr203998b3a.18.1787075821155;
        Tue, 18 Aug 2026 10:57:01 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-19.dlp.protect.broadcom.com. [144.49.247.19])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-851b6fd9ad9sm1248818b3a.5.2026.08.18.10.57.00
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:57:01 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38f5ac7354dso250389a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787075819; x=1787680619; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cbi681PCBHwtVFlW3rwwR7ihb0boh1UvIQ+C7BHwV+A=;
        b=HEAM1WKqti/ZaGtBQsHjrNm02uILpJ+gYPwWdqNTnVXdtt6DC+D2c854ZZfUe21wnI
         BQjMu7hTZFA1TtAQCwJ2YqtOsw9q2Fw98VQiSjsyW69QX1yZ6mWfduBGuD5UllPqf4Mj
         ge0AWXXh9ggAmjTSX8C8FWa8pGfcjJVNzfPQY=
X-Received: by 2002:a17:90b:1d48:b0:37f:bfd6:8b40 with SMTP id 98e67ed59e1d1-3955a5e0040mr14500577a91.5.1787075819180;
        Tue, 18 Aug 2026 10:56:59 -0700 (PDT)
X-Received: by 2002:a17:90b:1d48:b0:37f:bfd6:8b40 with SMTP id 98e67ed59e1d1-3955a5e0040mr14500478a91.5.1787075818458;
        Tue, 18 Aug 2026 10:56:58 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14153187de4sm16741958c88.15.2026.08.18.10.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:56:58 -0700 (PDT)
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
Subject: [PATCH 03/17] mpi3mr: Fix I/O block counter leak on admin request post failure
Date: Wed, 19 Aug 2026 04:44:12 +0530
Message-ID: <20260818231426.58105-4-chandrakanth.patil@broadcom.com>
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

The per device I/O block counter is raised before a task management
request is posted and only lowered once the request completes. If the
post itself fails the counter stays raised and I/O to that device
remains blocked.

Lower it on the failure path as well.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 1cd1c38dcd56..a4fe10a05cb3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2782,6 +2782,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		dprint_bsg_err(mrioc,
 		    "%s: posting bsg request is failed\n", __func__);
 		rval = -EAGAIN;
+		if (block_io && stgt_priv)
+			atomic_dec(&stgt_priv->block_io);
 		goto out_unlock;
 	}
 	wait_for_completion_timeout(&mrioc->bsg_cmds.done,
