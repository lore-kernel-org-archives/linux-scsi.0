Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AEE3A6F04
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 17:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075858; cv=none; b=GjFxlqn2+pvaPmcFqrZc9cOcDaPuU2aenmBR3SCwHioDHMOeNq0Y1dRmgRwyEUqZjixuQ/zwr5t+ZObMaEbzc3ROSBYEsLtoKiFD0QVMtM8iVjIyPmgR2pXVzjJh2Tu6O8t23ZW6qNKd2tOAUaOlROQwZFnrDgvauAtduleeN58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075858; c=relaxed/simple;
	bh=llzHxE75OFVX1S3xZW2OXbZREwAr7sKuGWhmSgIo9uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJIWunklfPKLgCpg0ComebsEduercEIxAwadTxu8H6oO2tObWYJsRQAdGvKZAZJ/2dO9w/HMGBKW/oDgth6jJmKvLeuSoR/bDNZgZORH4tWUayNMQTjMXby6LT/KPlBC8iXXPwrkP1qNdCUjuClInOhkgKfOhehUgRP0MTAmPsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=d2ABrdgJ; arc=none smtp.client-ip=209.85.215.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="d2ABrdgJ"
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-c9eefcf9175so48084a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075857; x=1787680657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zwvBN392iDHT8rjQvMUZXbHMzP/jsU/b2E0Z90f5tUo=;
        b=sRajgoyUIu2K/OGrxeNgYuIYlf2qiV/W6FaRxA6/h+1mhPTSoQmZcwWQTb0pks87Tw
         b/rm7bYN2ckOidi1wXN44ZtCfnnW1jzpLAtXtZa+EzeInOJXfpzTD6K6hZen2efS53s2
         yq41vYcPawtkYr4zHPn6WapFhyl/RbWTKLAicEdnfcyLz9vy/TBdpFcNiWvktYJ7DdpR
         71Zp5SCDY8rcIL6JzHIjIaGNGxCzNSEUrrWxM1rKRsRjvkl+szISZsCCMdgrdeknM+g5
         7vJOx74QxeFcwjT0t4HP+SIstxkTamyr1XCuhVheFL80SngWQ/y6Q2P1SbaGpIA5cN/1
         CecA==
X-Gm-Message-State: AOJu0Yzejs70GCJst0iTCOzhFelUH22fsdv8nIOoM+ax7EHKrN9p+/FK
	D3les5iRbH6iDCCnf0V+IVU5goYYekOGYEK7c1QY3ZlULiGFaOzsdSUsRi/t63LRdNQpSFMIdgb
	rFIo2CZ1HQAaKMu7TOgxNvCsOZvQZ0sxt2Yfnlg8TfgoXttBIcesMbd6vIjHowiX0Yc/Qq336Ll
	Ci41YGBbP9jhPbH4wVLO0iHyYLR6TA4RNN5+NAQtYPfokvx2zOXPHIlcRbVtlfy83FD+8QHbAjV
	7e3gd6mMW95PpoYCfSqMI3U
X-Gm-Gg: AR+sD12m2ru151g+Zpo5M6kOvuNebaOzhFSILN8MrFaCei2THSObEmsrmhqh/bZrnbJ
	70ktQDoQ+KBlbIto4Rvk21UMW/zZJraVvjER6QxICkSwgvPzxMWf2nJCas4zanHoGW8ZDIEsOm2
	IUf4NkxUgvXCaeIqvK2M0fmC17C4mPhJYX5rk1EWb6k4qhOovyn+smHS6IzAxHvmObYNXiuk8rI
	gMnDukTApWOei2Oeax1Ay3uf/+EBv/njpudGVh/y/uBGffQdtY7ptReusi/z7+5clqICyWH19+0
	kK5ogM6wO0htYtmcaL5J204wnjEYxoarxuym//t8RYbT4Ju0WJC14nOSGs/iK6RpU7qQCLiaM3m
	JW5c4pGKSxnzKCu1J0cxu5zNcvxESqnW8fc8aZm7r0jl7WMTO2JTiDWXaODOeduDM0As1DL97aC
	26AVKBtU3HJloIhPy6YrKj8C1f2xzwTALPKH8hOINLwNo=
X-Received: by 2002:a05:6a21:3384:b0:3c3:64cb:9b99 with SMTP id adf61e73a8af0-3cc719c78e4mr49825197637.6.1787075857099;
        Tue, 18 Aug 2026 10:57:37 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cc15040eef8sm95475a12.7.2026.08.18.10.57.36
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:57:37 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e7b87ce77so365986a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787075855; x=1787680655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zwvBN392iDHT8rjQvMUZXbHMzP/jsU/b2E0Z90f5tUo=;
        b=d2ABrdgJjkSBGxFKi345/4FgY24o54J7W40OytfM3I6clteytznOs4PMJWdGExKtb1
         iA2NvLGtxNriCP5RoWIjx5oOS/GWiBkqSVH/Au0Al2bpRDH+sW/A5n/QmRjZ7Vby7TRo
         vhiD1x6t6UjIEjOKIX2g2M7bphpB43AnpTICw=
X-Received: by 2002:a17:90b:1c0a:b0:38a:c3f:3b87 with SMTP id 98e67ed59e1d1-3933b8721acmr33143977a91.12.1787075855211;
        Tue, 18 Aug 2026 10:57:35 -0700 (PDT)
X-Received: by 2002:a17:90b:1c0a:b0:38a:c3f:3b87 with SMTP id 98e67ed59e1d1-3933b8721acmr33143888a91.12.1787075854545;
        Tue, 18 Aug 2026 10:57:34 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14153187de4sm16741958c88.15.2026.08.18.10.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:57:33 -0700 (PDT)
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
Subject: [PATCH 09/17] mpi3mr: Fix target device reference leak in device removal handshake
Date: Wed, 19 Aug 2026 04:44:18 +0530
Message-ID: <20260818231426.58105-10-chandrakanth.patil@broadcom.com>
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

The device removal handshake looks up the target device to update its
state but never drops the reference that the lookup takes.

Drop it once the state has been updated.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 15207eed7edc..9af236e70624 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2522,6 +2522,9 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
 		tgtdev->state = MPI3MR_DEV_REMOVE_HS_STARTED;
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 
+	if (tgtdev)
+		mpi3mr_tgtdev_put(tgtdev);
+
 	if (drv_cmd)
 		goto issue_cmd;
 	do {
