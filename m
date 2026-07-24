Received: from mail-oo1-f99.google.com (mail-oo1-f99.google.com [209.85.161.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27C1421229
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 10:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889189; cv=none; b=J62lDI2IqnxTe+0Ubf97d7zmDFvw73sN4tQOh/cO6hS4zWq0Fy9LhWeCOmUzwqh7fD9Z0jQfu0PlJz2WVXilWqkxFRNjEPgenujRZAiA2AxMvhF2Q92bNtoqxR8mKeEjGZvv1ICius3nDSqD9Bsjr016ABEEcdMMcIF+N3iDVS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889189; c=relaxed/simple;
	bh=AGk0MJGEpzshXszGBCvSYECLjox5oIF+9Y8PhOpIIXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ij5Wxt2S8vYIoy3VgwjLyQOzbC/KVlueI4lEo97TcorlW3Fge9420yqDVn0iRs1648wtkqYUheMzf59sLevVmxD7BSziELwUneqqOPwCXDbmZr6iSgeR8r2tm21a4v8z4UHI0AvlRBhFwSFCO210kyvc9jTzDiRIFEQj8rPsCTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=bLVJ9W5Q; arc=none smtp.client-ip=209.85.161.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bLVJ9W5Q"
Received: by mail-oo1-f99.google.com with SMTP id 006d021491bc7-6a198cdc4e4so85397eaf.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:33:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784889185; x=1785493985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dns3KcC8wp75jV+EFmchfrXNPHbBikOrwHZMHJQta/c=;
        b=ABM1sOL/dskttgggBZOIzG9V2e7bB9TspJBHA3UHEmQIGUCAc4sRtz8jeYFGckuKPh
         HT/iXLKYjSEmzDNk1aJoF5sMERI22BocQZKyUsb9OJiBtzKu4xWe+UFloZ+CXHPtNi4g
         +FhnJqPeoOPuGF4eLm6bueNippgIsAwnXDgcgcixHWA/5/hEXEwNSYC3Oy6Del8/QPuH
         gvxjJA/NnL4SUbTkxIAw3mtViHSs5ZDSDypUOPDaNk8CDRbcA7OP4ywbPbxHQ3N7Oflh
         EuRIx/S2k/3A7bQA5nXXmoi1gX2ppQjkC6z3cT1MxACXYU1JTIy90e8Rv6bhxkpwSqYd
         02cA==
X-Gm-Message-State: AOJu0YznVbUAdEMbiXNEFQDFh4mN8S/XIukEK2+t01v6rpxAZ35DP3JO
	Kxh1BvE63WPdgupyxS3DUeMsjaTSeG9gUo65cxObCt7IeSYHf7MNrg9qMOSVM13JsneI4jyFdln
	UjQbIjwt2DQtUfD3e4tNHvXzQeHebzys0I+nZAaUW6ShvpjHm14JSb72OCsdAUvgLqtq+cRcNGg
	aSCst3PLw4eigDbFo5O5BX8U8D2lDHheY1fffki3Kg2aFCMPaPp68TsczG4A3cBWaDPKlj3AqQN
	6tIxy5iVkb7HkjP
X-Gm-Gg: AR+sD10HXNNPrEc/+1MrNkfNBzfA38ou/TK04/dJBu817XQj2djdmrUv7qzpTvV9adZ
	VDduL+j6C3l+v/EHFgVVjUTA4f+huX7g3dAFtBoORUzAst2qSWxJX0MoAjFeZXFRjetu2I7MCLh
	Tr5yrz8P1JmkfS0+BMgOLVWY6YCWrZIFMhrfOXFkkhhqndXBn/E9y6xnr+Iu9lnawzQA1SsAa91
	BLeYUSocpE5KJcgrYFpMXobl6ZvO/RopcWefdibI5F4l8H2oPgpU3qpMSduNxdsj7REaJN50rAn
	NcNzBgS+xSjqrROi4+8f50RW1bTH0TPetR6cgGNd9CkjazF1a+Ylh4Ei6ZIZ82Nqwbx3WmX2eZQ
	PWqgfh/5xDOCPlftAnXsFC2HfLNQxLcD//k9BMrtG8f3SH7ITfv9CbxsI2O9Gv2QRIRMuXsWK+l
	+YEmBtW5jHtp4UqW8AaFlehvI5v1IYWDh+MYw=
X-Received: by 2002:a05:6820:80c6:b0:6a1:4347:8ffa with SMTP id 006d021491bc7-6aad40d7c84mr3285143eaf.36.1784889185170;
        Fri, 24 Jul 2026 03:33:05 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 006d021491bc7-6aa7780a210sm511193eaf.8.2026.07.24.03.33.04
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2026 03:33:05 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cb74d5db64eso344305a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784889183; x=1785493983; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dns3KcC8wp75jV+EFmchfrXNPHbBikOrwHZMHJQta/c=;
        b=bLVJ9W5Q14M7l84ieHZM93Qiwtd1bDBUdtet5cnEYp7pZiHL1JJVeKB0anyOZJVQVm
         lTfvqh/HtGdzc0q42mMYroMTrDIg0aglSU/7N8nlOzCEfbkXfh0sMZPhi+QqIgKj+0uY
         Hl+cTmzTL3qdzE9cfWHa2wouYZlWOf4/QsmBI=
X-Received: by 2002:a05:6a21:594:b0:3b4:6cae:4a50 with SMTP id adf61e73a8af0-3c44b000e1dmr6956821637.20.1784889182892;
        Fri, 24 Jul 2026 03:33:02 -0700 (PDT)
X-Received: by 2002:a05:6a21:594:b0:3b4:6cae:4a50 with SMTP id adf61e73a8af0-3c44b000e1dmr6956788637.20.1784889182340;
        Fri, 24 Jul 2026 03:33:02 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e1cf8fasm30233211eec.31.2026.07.24.03.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 03:33:01 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v3 10/10] mpi3mr: Driver version update to 8.18.0.8.50
Date: Fri, 24 Jul 2026 15:55:05 +0530
Message-ID: <20260724102505.115136-11-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
References: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Update driver version to 8.18.0.8.50

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 1d11d7c69536..c6bbd6b33cfe 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -56,8 +56,8 @@ extern struct list_head mrioc_list;
 extern int prot_mask;
 extern atomic64_t event_counter;
 
-#define MPI3MR_DRIVER_VERSION	"8.17.0.3.50"
-#define MPI3MR_DRIVER_RELDATE	"09-January-2026"
+#define MPI3MR_DRIVER_VERSION	"8.18.0.8.50"
+#define MPI3MR_DRIVER_RELDATE	"26-June-2026"
 
 #define MPI3MR_DRIVER_NAME	"mpi3mr"
 #define MPI3MR_DRIVER_LICENSE	"GPL"
-- 
2.47.3

