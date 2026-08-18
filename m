Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060913A6F04
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 17:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075831; cv=none; b=dtnPWuoS2UoDh3TM7raUGG74TtVmxMTTAJ2L2iE9DCM9M3UMFH+bSTnAapdta8nmfldFaZoIzDPVBVFmOjPNnYivhUrWGlLL8yuz7ecml0A1g6kh4oJKse3K4bZChRy9hgX1HPpgy+xyPnhAx8GWw1sKKVqA9CdMapwRYZq9Vr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075831; c=relaxed/simple;
	bh=4WLsmhuT2/sBD6iiD7KIzZoJpW57pILWm3YDDiRKYLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xr+Sy85AqI7ehxjvcTCSV2EF661OJYAi45IAP50unl46PK0rQb8H8f0+hhEoGo6j4BUullAXmnO6IQplzK4eID43odAj86IlcGI9BWo+sLLe2QNg4m84cjFcwzxC5bmZtM59DT0+1k+kdCu02VTJCWwD+4icFyKj0yNd59WMX9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=A+V9QNvf; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="A+V9QNvf"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2cab973140bso1504235ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075829; x=1787680629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0welNGLnSzj6GH2q7tOoR9Bm1ydVZQ6nc93z1ta7Hto=;
        b=IZBPJzUeR+GB0R3sWqBHXZeqUWemcWSnpw9pxqzRbpnzloX1de17opw6wzAIm64cK7
         in+rEeaPHIgv7n/uTR3yqcRrHuz3xQ493NSH33JbdxSwECfNz/2Drso19ohYGIwRF/wh
         1Y2c7ntRsEL4DtNWb+/tkPECpbXKPJZhN5NHsPZACghAiNy5LhVsAf59lyp9MaA3R1DU
         WcoFlywYXsk9FWflIE6Vn73MKP32ETeBkdWiAcF0tQQ1tv6flkwxm/WdoYDhUCvOYxAp
         0jA1GqP146Ycm443Jj5spU2RIbbtiKHqP+Xma0Y+5ksyinXWzvwIzbBUaFkzbOJ6h4tj
         2gaQ==
X-Gm-Message-State: AOJu0YyFd2apiYYV9kYaB4ri3n8SA+YSFulIs5EUOdFsRrCIdv5XY5GK
	/Dfo9rOHhmYqA1m4827VuuhFyNAN6gYeyHjcUr5/61glevsygLz+seEZ5S5sx9aOrpRrfeIG06S
	If4UomA/0y62Qhu5n1vbMe/P6PSyD1gwj1kz/PzxeR/8BaE3iXjQ8fXVlzEi0cfoyMXJC6gq2/z
	5muuL8nXBdEdporP69Ow0aFaoulpsZAXZo3dYU0qhKQILd9DvD8+GFlf657fpgTDr9LMa3DezHd
	G4mevjGAWSPJiv7JaYe6v1+
X-Gm-Gg: AR+sD13dU/m2oXZSv01sxhtneJFUpFlofYE63eDCU43Aj2w2j1KLvKyX9k5GbLzj90O
	I9pWSHfeCQz/XUaTyQw2kE5USDs1ETFygKSeEHlYslHRVo5gSUT0urDLMeVASAki0Nv254wxiBG
	LJlDSEF16GXP/O3PN5jfItimitEa4illrqz6c00C94qFIKdgKTQA2zoxE+Fi0U6z5/WM5l7dWKh
	uRJqqQRsMB3ONEPMbIfq8us80v9YgaZ2i+E6BFosfVjOoPk+2DPlBFiJsga1SrToNTS6qkN4ekD
	TXo/DBmFQ5r/TBBU52EiYio148gLm4j+kjiWl+YVG5OQINqwXgZXLSzDR6dyonyBkInidL+Jwb1
	3SK3NpVUGwqrvMmnZoQg0xim1xSbmGzYZhJREG0Gg/XaTKYseIM2a66oUkE6CjLzGFYlvyO+WIC
	oeGfHmAr3RJzbb+N8LtGZrszErvpuB9lnUAZqSsNn5FG0=
X-Received: by 2002:a17:90b:184b:b0:37f:eafd:3505 with SMTP id 98e67ed59e1d1-3933b74d94dmr44190414a91.6.1787075829088;
        Tue, 18 Aug 2026 10:57:09 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39531ddcf26sm4228893a91.4.2026.08.18.10.57.08
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:57:09 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38f97b3f853so275010a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787075827; x=1787680627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0welNGLnSzj6GH2q7tOoR9Bm1ydVZQ6nc93z1ta7Hto=;
        b=A+V9QNvfnHhM+hM/yJZHF19aEKK1Jp0vF/kJTIVitlPX2kL3kQiTVj80WRB7Otqu/j
         LoQLQ9Pmxs/hy+l12eQGEVxsKeDmcydAsRvqFo86fBS5n32o2kP+O5VRpDIPL/qrbAsS
         /bM9JTbDnC3B1nff3PEvwgQqrYBslsBTKv0Ao=
X-Received: by 2002:a17:90b:48c1:b0:38e:2517:5d1f with SMTP id 98e67ed59e1d1-3933b792c20mr43066897a91.9.1787075827128;
        Tue, 18 Aug 2026 10:57:07 -0700 (PDT)
X-Received: by 2002:a17:90b:48c1:b0:38e:2517:5d1f with SMTP id 98e67ed59e1d1-3933b792c20mr43066805a91.9.1787075826547;
        Tue, 18 Aug 2026 10:57:06 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14153187de4sm16741958c88.15.2026.08.18.10.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:57:05 -0700 (PDT)
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
Subject: [PATCH 04/17] mpi3mr: Fix target device reference leak in BSG task management
Date: Wed, 19 Aug 2026 04:44:13 +0530
Message-ID: <20260818231426.58105-5-chandrakanth.patil@broadcom.com>
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

The target device lookup takes a reference, but it is only dropped
inside a branch that also requires the SCSI target data to be set up.
When it is not, the reference is leaked.

Drop the reference whenever the lookup succeeded.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index a4fe10a05cb3..94b992acb233 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2745,10 +2745,12 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	}
 	if (block_io) {
 		tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
-		if (tgtdev && tgtdev->starget && tgtdev->starget->hostdata) {
-			stgt_priv = (struct mpi3mr_stgt_priv_data *)
-			    tgtdev->starget->hostdata;
-			atomic_inc(&stgt_priv->block_io);
+		if (tgtdev) {
+			if (tgtdev->starget && tgtdev->starget->hostdata) {
+				stgt_priv = (struct mpi3mr_stgt_priv_data *)
+				    tgtdev->starget->hostdata;
+				atomic_inc(&stgt_priv->block_io);
+			}
 			mpi3mr_tgtdev_put(tgtdev);
 		}
 	}
