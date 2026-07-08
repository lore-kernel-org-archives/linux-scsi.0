Received: from mail-qt1-f225.google.com (mail-qt1-f225.google.com [209.85.160.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B724D8DA3
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 18:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783536060; cv=none; b=PxV8HldEYnVBLbdAqZvWEHwgE6KZavsdamhjidJkbMC2V3VSJw8vrAhD2IBPGnetpeVpSonNs7luYm+NAhzYW8i2jfG9jECmwc+UONmRRnJh3YEpI+PGdFxqVq49bnq54oDuZJfIbUpl9jera2n0qVbpw2iUxfF2oyu7BkLJQpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783536060; c=relaxed/simple;
	bh=AGk0MJGEpzshXszGBCvSYECLjox5oIF+9Y8PhOpIIXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWxhiednTwpfsBM5lB2spg3Rw1OGb4nFyCXcfaQXgizrXPWqnt4bTaE3QGzyDAIZsW5zeu+fXnWkrnyfGoqCVgZA5jGWHu59VfBhinuCvP5i8Fpl3CA7IpYpTLrbdfp8P7SsZMOoz0vpXVU7cyoTLiLyr15jSZ1SYWfauJkW6aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Xl1BilgF; arc=none smtp.client-ip=209.85.160.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Xl1BilgF"
Received: by mail-qt1-f225.google.com with SMTP id d75a77b69052e-51c928bf172so950221cf.3
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2026 11:40:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783536059; x=1784140859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dns3KcC8wp75jV+EFmchfrXNPHbBikOrwHZMHJQta/c=;
        b=L00DkSdX8BTSLTpZGu75pQmPljkkJvMFLAZ3HmklcKPDBPqUZlQagMgaXM5UhGgPh2
         AciWL5yMFtGR9ftVLAWo8HRto17/0369qkm1RntpD86dM3/m9YMAHAj6L4hZlY3dv3mn
         PE6qLdpLsslQvkcMnAMaEKHR1E7awsFKJOw5SOnCQJBl2YfLoaPzPei0s3UVthPyP+N/
         mWsFVgTIa2DXhf2P4YrVD1WkGlSGw2sObs0grr38I1WFHpH85UqLewhoRRGN/giT8kBx
         vcKE/ocixuzN7qqzupMcAAcpUnLodmEUyELhJHTpt2qaUMfd5T6LiE+Rv3HND4utlt1o
         T1LA==
X-Gm-Message-State: AOJu0YxOLo95+EECCY2JbqqG9UQLaDoT7W8yTGLlChwt2NCPRXWN0TOU
	hfTDXqOmEjVnYiiCtoA5EXCt2dcaVsnqbrGVhQngfcEPTx85LpGUIFcOkKibhV5WePSFcpMAqmh
	BYhVC1cvndtcKV3VG/gCflgTzUPTHTqRkhOg6ZFJDLR0RpOWDiZE+pXWTpuPDnDdMDy91vweCHD
	1rAOV7TyCoJSzGTsRgaJ1ynXaQjAMCqNYEFLRi/DiYLRswN3hCmodi/6VRM6iJ1XWaWSlnFw0Mu
	L3mNUk1IiJmYW2R
X-Gm-Gg: AfdE7ckQUesrl1d77NW+r7IpF6c0lzpzanl9VxdaIb2BhIdc6DQrc80FSvS9o1tSRqr
	bZhMxZxTmXkr6tshKcbGmmoZrLn9xT46W+OX3bscx/R4vKNfwGVKaJpbbtRVkmgm9gcEuKc5d6j
	Y/Gd3la1piXWFHp2K6oWsfFmg8luHBOjYjZ6441qaC4gb2J54X1QBd6dd1iGPHFr05VNT5x9FxN
	UFRcgzEEmjWQM6r6XrgXzqb3Vr2POm6cTz47o4qKFn+p1gEVDGKm1rL0T2YrpYsBJ5J9X0MaN0z
	Nq4Huvba9IoixiBCAENSAARMj8x24AqgH4WzhoWmBXg1gvcjFMK/7AN3bBf8EwcDrOo45562P1E
	QX0OjRuUmW8js4FO9/CPLr/q1+lSqohnsEH+aP7mgVPjP8wOJ0y2k6kB67gzSVwKkKn8xunmDxu
	ePavLLiS2yVa4RhCPu53dJ6GIBXqvcHD+PrkEZjpkE+JfSsw==
X-Received: by 2002:a05:622a:294:b0:516:d699:a99b with SMTP id d75a77b69052e-51c8b3b4725mr48646361cf.40.1783536058477;
        Wed, 08 Jul 2026 11:40:58 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-11.dlp.protect.broadcom.com. [144.49.247.11])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-8fee9b71d5fsm1626516d6.11.2026.07.08.11.40.58
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jul 2026 11:40:58 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38869800848so249370a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2026 11:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1783536057; x=1784140857; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dns3KcC8wp75jV+EFmchfrXNPHbBikOrwHZMHJQta/c=;
        b=Xl1BilgFn3iR31EMGZYIYk2+NY4nD7G8Zo1rUCcjKfSgRujG4VDtE9I6ohgzZcsJtG
         5bj3LxmW+H0ysjlvb8I1wudPrxuGYtnahcDLP9e8BJaYuvsSJhdmUHhDLHMB67buchAT
         W9rkcPf/ZF/4uWjKistOSTl2cFntXsb9/fP9c=
X-Received: by 2002:a17:90b:3ecd:b0:388:1927:fb1d with SMTP id 98e67ed59e1d1-3893fb74d16mr3492681a91.12.1783536056406;
        Wed, 08 Jul 2026 11:40:56 -0700 (PDT)
X-Received: by 2002:a17:90b:3ecd:b0:388:1927:fb1d with SMTP id 98e67ed59e1d1-3893fb74d16mr3492655a91.12.1783536055864;
        Wed, 08 Jul 2026 11:40:55 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3117d847e17sm19820599eec.18.2026.07.08.11.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 11:40:55 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 10/10] mpi3mr: Driver version update to 8.18.0.8.50
Date: Thu,  9 Jul 2026 00:03:05 +0530
Message-ID: <20260708183305.244485-11-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
References: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
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

