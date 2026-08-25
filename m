Received: from mail-qk1-f228.google.com (mail-qk1-f228.google.com [209.85.222.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863DB449B3B
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 15:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672713; cv=none; b=BR5xksgg7Sa8ULMsrhHP8gri8MB+xDoLacAHOLjeOqZeXiKB24+iHcHwGaMB0KKSIF6QccQXuukOHQOVTjLitZDdNJcJ4Cnl8RgGAruU/M4m2ZveWJGp9aU8ocj6al/0fdcTRRrgiPbvqh4LGXHcZsANKmd13qFq0/I7Mu7Sgtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672713; c=relaxed/simple;
	bh=BhY1eSPa4XHwIyXw8M8J8tQMyq+0EQXcDulpM9oU2PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFe0CfCeYR26QIhJ5PHEqWtFwHihj+Lqwpmo9QemANtJKnpm8tRBM6LQh9mx3GDKlPx3rlW9Oeozj3YXfj2vIaXV9IO2+HjsIi97vI56KW7ZsX3lUYGV21EZFthoCX49hQxPNwuDMSJtyMvuw8LMyZNIA5RD5wmbtacsz8y+aUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=eOBzhTRH; arc=none smtp.client-ip=209.85.222.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="eOBzhTRH"
Received: by mail-qk1-f228.google.com with SMTP id af79cd13be357-936e393176fso223240585a.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:45:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672711; x=1788277511;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u38u/nyeaBO34n8uFE5PRDfAAcSLZkffixSCZhsmrFM=;
        b=ScZc6KEQ0qEgHemZLn1xsIY2cv3hKi7L/C4sly5HirXBd8eclb4xYUhFNJwWOyN8wM
         vdW4T58lKnZPqdzYWZ6mOqazN0jSRUt2uPMkzG/TSS6lCa6UBExnb+JpUY/1pANtCmhP
         E9bfwfXyxXFH/XbY0Q7mw8Dppo9/w9E8ERgieyheoHoZ2SZgMyOva08r0xf4f/RWmO89
         ghmrOozo3sGICgFzuvOOCBbrMG2RXvjNSlgNxWueuhP6IwFBZgI2pzULlMRavGY+3q6f
         9LGXq+hI29PiPnYPpCz1aN4DYrPGQrATzeLmy3dMFX/FWV3eZnA7VKca/KhfE4UQT6zL
         FPQA==
X-Gm-Message-State: AFuF++kOdT92mXJrYr7rghhyeZkJGGOQaxp1aV3eUztUpRdFKAKN6CUf
	D/2cikoR7RTjdenI/Mg9CYN0+dzkrOpxC2kOsoxnLFyWuy6NE6LDfO+zmQmFLrHPCAnmbTYDt1c
	Wb0pF69xuqDb79rEo+rXe4LQNYvWbOskWnSZG3qbNER97otWYtBy4O+g9uvR3T+j44gnMZnYI1D
	nrwc52DGRq/cdugnXV2zs42eAaZ5ROnIBwJiq4HfMGdLILH3qPe/cZIku/2Nqlbf/9hDiFnFE7J
	/nH2GqAbaIG1ReLcN6ZdyeA
X-Gm-Gg: AR+sD129A21CsoP7So4BnXBkh25lAXr/z5mgais/ogJQqpLYRqvBgFnMjdw/NZ2I3f6
	I8pa74l/iqb6Sxn/3Ug0fMNH/kWDBz891ZkY5vLwoLuZuESS3lZS9E8IfSieXOGyR38itAy/VSf
	R4hTKYH/qIlq3kCnplt3MLYuYIEjtlX1jXPBNVBlG9UqyiMV84IhEdT53OdoIcmj9wU+1ge1P+n
	ImSNmZ4PH/nvbrE0E8Co6xWiTcCcXgYQBybWcPE07X3orwJjdCmm1NHbMoYeiEcsdb3Ii83OJ80
	seT0Tln+Nmslol/3Df+OKMpyzmqt93W3B8ix6rofMB8O/zqxPHiSd8VXQnKzBrQ7DakuQT2DsCj
	2fvIKMNx3btetDA5kl3+bv5TqaQqALiHvXmxKoDQFsoVZcGvl9Y9+d8oQoIYbNrf2y6+6kLs2MC
	q53JTvsBN2UObQ3VyOI963MzlNgD9AorGYhRHeKasE4/svGA==
X-Received: by 2002:a05:620a:3d03:b0:937:37d4:5dbb with SMTP id af79cd13be357-9376fa5f689mr606283585a.27.1787672711146;
        Tue, 25 Aug 2026 08:45:11 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-121.dlp.protect.broadcom.com. [144.49.247.121])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-9377e4974b3sm1023085a.8.2026.08.25.08.45.10
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 08:45:11 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c856470fe9fso3938521a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787672709; x=1788277509; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u38u/nyeaBO34n8uFE5PRDfAAcSLZkffixSCZhsmrFM=;
        b=eOBzhTRHCBfLnk3Zbh4K+/v6inXKKxUBeuFgQ2eZYXCK2G+lXbpzCPj4mDyvT4fd7T
         wvA+Yampeo24piccnKqR4QY/dAKI04i185AlcuygauoQSDHJCBp0coklwcxMPDt7ESt+
         O4veqtL4nPrGxECtnGpRYPJf8ZY69jxzSTZEw=
X-Received: by 2002:a17:903:b0c:b0:2d3:160b:c01f with SMTP id d9443c01a7336-2d6dcaae0dcmr160242695ad.6.1787672708990;
        Tue, 25 Aug 2026 08:45:08 -0700 (PDT)
X-Received: by 2002:a17:903:b0c:b0:2d3:160b:c01f with SMTP id d9443c01a7336-2d6dcaae0dcmr160240895ad.6.1787672708183;
        Tue, 25 Aug 2026 08:45:08 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9209fafsm63445311eec.23.2026.08.25.08.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:45:07 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	sumit.saxena@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH v2 13/17] mpi3mr: Fix buffer overflow in the BSG target device map
Date: Wed, 26 Aug 2026 02:34:07 +0530
Message-ID: <20260825210411.301535-14-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The size of the target device map buffer is held in a u16 while the
number of devices it is derived from is not bounded to fit. With enough
devices the size wraps, a short buffer is allocated, and the loop that
fills it writes past the end.

Do the calculation in size_t.

Fixes: fb428a2005fc ("scsi: mpi3mr: Fix issues in mpi3mr_get_all_tgt_info()")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
v2:
 - No changes from v1.
 drivers/scsi/mpi3mr/mpi3mr_app.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index cd772b2cb98a..f5b48c95cf05 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1466,7 +1466,8 @@ static long mpi3mr_bsg_pel_enable(struct mpi3mr_ioc *mrioc,
 static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 	struct bsg_job *job)
 {
-	u16 num_devices = 0, i = 0, size;
+	u16 num_devices = 0, i = 0;
+	size_t size;
 	unsigned long flags;
 	struct mpi3mr_tgt_dev *tgtdev;
 	struct mpi3mr_device_map_info *devmap_info = NULL;
@@ -1492,8 +1493,8 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 		return 0;
 	}
 
-	kern_entrylen = num_devices * sizeof(*devmap_info);
-	size = sizeof(u64) + kern_entrylen;
+	kern_entrylen = (uint32_t)num_devices * sizeof(*devmap_info);
+	size = sizeof(u64) + (size_t)kern_entrylen;
 	alltgt_info = kzalloc(size, GFP_KERNEL);
 	if (!alltgt_info)
 		return -ENOMEM;
-- 
2.52.0

