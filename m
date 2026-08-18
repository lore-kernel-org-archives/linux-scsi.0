Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829D545FFAC
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 17:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075889; cv=none; b=hI3m1pbGGmdo7Xtw8A/Qfqizd4/FrEnW9CNYBM0kz05LWTZ6r65k/oCsmLS/tkkelrAPS4x/y3NfwwxFUzopTuLII4OtoTF9EVvkyreYCl7ieKFX6DPfO7n5n4soDwYqh/ZNxidYyejkCgRVNq8G4Scz62HPVE/g/Qb7mYGSLtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075889; c=relaxed/simple;
	bh=mSbawKXXPjuZLTU27QDuWueCRuNFRXdrnHAcA1YCCas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aglxa66PumIofo/GOK7l/fEKfhcxirukCuU0l6NNzlpCt8YJh6F3/zLDSskIHPvb3i6lhy1xoL87bkNelo/RU4jDYkEaYUkNAGmMmH5RUTfLxVnUGJX952sFtlY+L0BWUjPYQKkSWZzbdUqpTyfcKdTnbTA3xOVqMGvQjulb85M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=gt+aXoBc; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gt+aXoBc"
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2d0407aedd6so1358825ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:58:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075888; x=1787680688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XeGZBi+OMSJHYZZIDmy+cJqrHbHxON1XMtWp0zSFDHE=;
        b=PLaJyeMvoJuO60mGrQ22Jl+ZdkTovLM+zd5feqDhvZhKnPxyowZrgdKHp5nyvatbNW
         v5U+En5NItlZ2BrN3XQZb90MgL1VCKXC8lhgdl5aW2LR3tOTJZ1rI4g9ao8/z2E6r5ML
         ds5VMiT8cqZO6dcxhx1m+pd0i4id0FWtTx7r9WwPKv/GXUyWpIa3bpEtQYQ9+u8bR3oy
         47G4MR4lKMgX/9q7YbsuvBJougOhnFrWPaRAT+/VgtwOZXqHDypgTgRJCTwSXEC0bBXv
         TI1UveONwDPk91gnXvAv7opPrXBZznK7qjvW7jwt7/vfQ6Uex14ddxUkI1zB0Gc+GJil
         /B7Q==
X-Gm-Message-State: AOJu0YwX9OVmaCMKUrKrH5z1YrB7RotBVf7MxsknMS+r+Sx7+k0jO6uf
	+j5tazxklz3HZ4gGrvKUrBGdf8XlrbO8uFumkh5lkrDbH18YZ5/i473JH/w0S/EBrrhXXfiXnDZ
	OXA0eGZX+tRh3J4UhVBwCJJS7SWFRNJjeoarDBB6rFdgXfNPToNbPfgrzlivuRDYrRuQG3Xh94Z
	EyulMoDM1kHWThtbWmjhbvQCrUMWqqSzwT6KEOVkRa/INKTD993T2nI6QCyC1/ll0Gy6LauYdVL
	31LUM/0cl2jQ9LlTU4/GVqg
X-Gm-Gg: AR+sD10qv0FeMjFPYnbFKB3UJNf0+homizGCGQppBJWE9k95P05TLn6ExOATeXTIBtE
	EGOYTSGeChbihZ8zIWMQlB2wV1Wa6j70y1nnBCkyQQrdmtc+EV0PPbBmBbFJwVU+GFjXWEJ/g/V
	VUJ2vHGtT2/gnqxx7VQVkf99OZ8UOpM+kfPX4wCj5kwodC8qDABWSjynjLNV81zf9toa7jOCenH
	KfjJHSBEg31y1Xpj1KXZn8P6q3OSuiMQztry22lOGkrHdhLNRL9lqs9+yi+os6/GFkx8x3P/gAW
	8KyhF/qmLv3EriSu1fYxLrf+HnC3xx9nTLHMUxj4MYpnDX/53pX2QhH7uXfsZoD/eWZ8pKG3qyX
	R38iYveOo4Mgf0kjx681SF81Jx/K+ZBipJQZVW7SRqs7LuhoJhWiOEUasfpNwW0B9HnKG3nOR4e
	b5wH8lsqMhGcCTtlCBJ5Z1jkR5QtyxKeshawzN8PGd7W0=
X-Received: by 2002:a17:90b:1b47:b0:38e:5964:97a8 with SMTP id 98e67ed59e1d1-3933e63167amr36523194a91.16.1787075887710;
        Tue, 18 Aug 2026 10:58:07 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-19.dlp.protect.broadcom.com. [144.49.247.19])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3954d28d59esm2729742a91.3.2026.08.18.10.58.07
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:58:07 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38ea32e57e2so312639a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787075886; x=1787680686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XeGZBi+OMSJHYZZIDmy+cJqrHbHxON1XMtWp0zSFDHE=;
        b=gt+aXoBcNS8DW2L9Zg4eWQNWKyk0Q54Vz/KkybcgxclzvRc1Jv+JwxjgoIgZDgWHXK
         +uFDTS73zOD4IVXbIhOnuvowTYoCjwUBhG66TklI2ua/UYpzcADWbncMjeMxoffTrowx
         VI8gYKCqswQh5XmBM5F/cjnXUclfGGh6aUmrA=
X-Received: by 2002:a17:90b:2e8f:b0:38f:5869:387b with SMTP id 98e67ed59e1d1-3933cb718fcmr40793345a91.9.1787075885932;
        Tue, 18 Aug 2026 10:58:05 -0700 (PDT)
X-Received: by 2002:a17:90b:2e8f:b0:38f:5869:387b with SMTP id 98e67ed59e1d1-3933cb718fcmr40793284a91.9.1787075885404;
        Tue, 18 Aug 2026 10:58:05 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14153187de4sm16741958c88.15.2026.08.18.10.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:58:04 -0700 (PDT)
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
Subject: [PATCH 15/17] mpi3mr: zero out diagnostic buffer status memory
Date: Wed, 19 Aug 2026 04:44:24 +0530
Message-ID: <20260818231426.58105-16-chandrakanth.patil@broadcom.com>
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

Memory allocated for the BSG diagnostic buffer status is not zero'd
before it is copied back to user space. Several fields in this
structure are reserved and never written by the driver. Use kzalloc
instead of kmalloc to zero out the allocated memory.

Fixes: 78b506984ebe ("scsi: mpi3mr: Add ioctl support for HDB")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index f5b48c95cf05..0cdcb8d236d3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1244,7 +1244,7 @@ static long mpi3mr_bsg_query_hdb(struct mpi3mr_ioc *mrioc,
 
 	length = (sizeof(*hbd_status) + ((MPI3MR_MAX_NUM_HDB - 1) *
 		    sizeof(*hbd_status_entry)));
-	hbd_status = kmalloc(length, GFP_KERNEL);
+	hbd_status = kzalloc(length, GFP_KERNEL);
 	if (!hbd_status)
 		return -ENOMEM;
 	hbd_status_entry = &hbd_status->entry[0];
