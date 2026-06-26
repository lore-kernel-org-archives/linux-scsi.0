Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC4C2EDD6C
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 11:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782474534; cv=none; b=FODG9QwK2+4YknjxAEcLl7FQfXutLozIiHCaENY1aNqllt8R6PaEjYYPQu5+JOcqWhZT0KWYEoIc8CcW813TzIcZQy7rVYuuQYpxvNef6IlXJ9/0AlmPzdh6sQLVKwagq23lMoT5okNSuXrqAG4QZEIra4JbwV3LsxmPOL2RE4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782474534; c=relaxed/simple;
	bh=sh6hp4j2y76LeQZs0/1ZMuuq1jMG2T8TMH5lP3UxY3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyHjY5ICQOlGTjPDQft6Ul4vlQ8ABaTLBhhbSHpdVCE/a0wSGKZnK9U+ZkqhEEuqAtvJ1vHycqK73L/34pcFqKdQM29COSQJmJsrXsPMLtSjnxY+pUZv2N7WK+mfmwxfibGEenO54MgWFFpFSR2WByqSYGhZJg++OlCp5Og2WG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=BGLviiBk; arc=none smtp.client-ip=209.85.214.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BGLviiBk"
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-2c7ee3952ebso10262365ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 04:48:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782474533; x=1783079333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mRA5douPrXDV+h3aiu8j0H6tos65fPiI6+3rYRij0QY=;
        b=hN77UDZ4mHM3Ktr7UAhpRP4dfHXwf65UjTTf/WuBj5Tnnhv1YA8J+R5XAPiROiYbh+
         +78RjDwDtc7uXc+2xuT5LutGrRKcqHcNiKQJ578uok3Hv1moBJN1N3TFxpHR2FCpytA1
         vn1HH3/tj9AJBzClDlH9iZRpieWxcq6b3b6YdzZYgY6h9kphnT/hXqE2uHC4L1t5N3kL
         UEkRR2mNWejCexo/zvT1yZgEWMhd+KHGvhHRKQQS9qTb0M1E1pHUPeDtyZ1W7L02smNx
         54fMAtq6yfZ/a9/rIg+Srr5+LDL0zDrD/TYqYBLc7fCZQ3D8ni86iUyza4m34rMTS4kY
         UZIA==
X-Gm-Message-State: AOJu0Yzo1Srn1eQbmIoDS70dDMh73eufoPV38StSPneGgDfN00Wqe7YX
	ekSytpwPsbL05V1PtgyzrlMGWQwVDcaGUDAUbPppclApisG0FlbRJazvxu9iNoj6ko5RlcQSEVs
	vM+GKHZwGM9cXnt9Lzkw6H8G85OgefCMlr0/RxOrJCj2S4o/jkgjxQtDtH5RuV7XaEJrtMLQvWy
	sZYmsuS0WB4r+AnVhED3z2vbrXZCgObPeldeR4crv+ZxGi8N0j31jeXYdBWv2QwZNCoMGBzQkfM
	txXYt1+1vAcm1B+
X-Gm-Gg: AfdE7cnG7HWCfbss4cDypXVcVVzCNEwAT7oMBIV2WPArWsU3VC6Z5tFSueij3bvwvAr
	XG/5nzdM5VTMkF9gFhdYnbrGECxGhM3JwHVjr8luiYNGZSRClsWWwUv/UmHg8u9+P6PF71fE7LR
	uPy48FKs3VKOMA/+rbHsF/blYKxNQneeL1H56fhYjio5qgnvn/F0wgI4SzdekOZV66Kd7cwdtRN
	XuH/6IBwg0fMwR4T7ILykGB1mzHKnYx7y+BNZ7/sAesoUrMNjx0DN8HzMxU10u1BshZjcLpAJFH
	ywWppYP+dPCGNobhDZ7PO8VaSYzPi2qUnFLbBqf1P7eV7nTYVg38hM/i20WiHWFPqABmz04TinZ
	ep8c8S7qkjFw14Tq6PGibm4S/p5YAAKf3p+44Ayy2iEqL67j9jzMNe1Cq3v2/D38UcgTzbiSqfo
	6QmKPMb6Uzw888g6dLZXRnvW5Tut/jg420aFnMNaJAhOgDAA==
X-Received: by 2002:a17:903:196b:b0:2c7:9e67:c5c6 with SMTP id d9443c01a7336-2c7fc75cbf8mr72043235ad.19.1782474532774;
        Fri, 26 Jun 2026 04:48:52 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-11.dlp.protect.broadcom.com. [144.49.247.11])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2c7f637d5e9sm4788035ad.40.2026.06.26.04.48.52
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2026 04:48:52 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-30c50cd6cbcso1101957eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 04:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1782474531; x=1783079331; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mRA5douPrXDV+h3aiu8j0H6tos65fPiI6+3rYRij0QY=;
        b=BGLviiBkoUpETUolbfvamMiKHqm37tcZXAuE+xAnIc/FazW9tgz3B5p1ueTqpu7fGu
         ACBwl9Td4A7mFgDnbJmQuDtDsyO35qqHcpG4Y6KitBGMaeGBsOz5AlkFJBYG7RRncvV8
         1wNor6ZsZ+CxTpMrvMo7TP7M2HFYCYTRonGhw=
X-Received: by 2002:a05:7300:578f:b0:30c:6018:4993 with SMTP id 5a478bee46e88-30c84b2b1c2mr7069757eec.7.1782474530923;
        Fri, 26 Jun 2026 04:48:50 -0700 (PDT)
X-Received: by 2002:a05:7300:578f:b0:30c:6018:4993 with SMTP id 5a478bee46e88-30c84b2b1c2mr7069735eec.7.1782474530219;
        Fri, 26 Jun 2026 04:48:50 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c58831asm18844838eec.13.2026.06.26.04.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 04:48:49 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 07/10] mpi3mr: Fix firmware event reference leak during cleanup
Date: Fri, 26 Jun 2026 17:11:06 +0530
Message-ID: <20260626114109.43685-8-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
References: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

During firmware event cleanup, when an event is currently
executing or pending at the SCSI mid-layer,the driver sets
a discard flag and exits the cleanup routine early.
This early exit skips the normal cancel path,resulting in the
firmware event reference count not being decremented,leading
to a reference leak.

Fix this by releasing the firmware event reference before
returning from the early-exit path.

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index e361fbb8f723..b60afaeef68d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -399,6 +399,7 @@ void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mrioc)
 		 */
 		if (current_work() == &fwevt->work || fwevt->pending_at_sml) {
 			fwevt->discard = 1;
+			mpi3mr_fwevt_put(fwevt);
 			return;
 		}
 
-- 
2.47.3

