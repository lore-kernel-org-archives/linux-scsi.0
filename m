Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4072D3168EF
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 15:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672722; cv=none; b=gHknPyQztOWdbjilNKQDsyWyBvIrz+t1zJjAOVDrQ5W9tPhzNsGpB5JKlehVRS+AgJhLQdcRzkxpghW7Hv4vy5mAmtm4varWEx97GXD/TligEUqOcGVVeEVkMAztaUbMU3+yyoJbdL1fpmhj4Kc5oi3yvxy9Nm15aaldccPkkTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672722; c=relaxed/simple;
	bh=4gyJJ9p25k+oqHkdQU+ya/Rbn15Pi2XvXFdUuP/cNdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvXfFPswIi4uCbewh81kLxZ4DSvl8qU+88KawbVP/dKaXdc6P+TFb22AOQDsF4DZoAGYSPGej4Fs0ZP6AnoLg+pcSYlvetYUSCmb4gjvhx4mvWJZDJCXrAq9QdgCXaoQZPTAM0AKP5QCCMK9FS6gLCMdbqq/c8jgcbkVrSSMGXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=AThWAw+Q; arc=none smtp.client-ip=209.85.215.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="AThWAw+Q"
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-c9aea40d799so3030782a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:45:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672720; x=1788277520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=siE+m2ryXog4NPKvNKmot/lmJjP0qzo/GlYgFYFLJu4=;
        b=gVv4zp+9XQJq6q+tL3QxCOuzGZlyETLQNI3CN7P74CJCPz/hjXjkLuh7jqKv49U1tf
         R1Gw7Hc/YFiuvQBN837sS3VfopisRItx0g84L3WdIp6F2/sZr+kyl5lz/McmkwTBtn9f
         i2PKRa7ySCUnqstPNC5L8YL2xYqhEwQi8l4zrQJSxUlDps9ggp2XmWDLDW72XvyTvh1H
         vmrP9oYzjXHaL+H7CtOtWqeBZCm3Cm772Cr1eBwFxRq3QktEZSrGo5z9UGKQWp7kLkuq
         7iompoKva05kqan7g6Uke7G2D2yB2Dm4c/052oZHFb1twzosy04jqIHKH3I0TCVaN0PF
         vXxQ==
X-Gm-Message-State: AFuF++lYZJFP9+XQLx4D9ZwSMKQeQ2v/5pg4l7LA2rpV18Z3lKDlAhK7
	ZcQyOb9f8AKtdyEqGx6IUk4pZHgyxnwyDjRwbj9TXzdueIX53lsb/n3G06+sSeOU6wkzdm8cqts
	aI5SbOZSGBqCwYuJ8EESkQmQ1dX274UxQ6BtqMHRhMz7oKLoL5Cpvk6AejEwhfBUGyjuwF2cBCl
	NcLATb0n/VDu90XM6sh7O+6k0G/6fFQHJfGBq5o+O/xshbUW8e+hncpg3wjDt8NA9SfbvGRN1sL
	vbBZ7rdoRw+R3yoJK/OZvqe
X-Gm-Gg: AR+sD10QZk7fGiLBIJ9iXG087+s3Am5nBTa5Jg8Fidr6JLjhVp4NuHe7tP1kBX9/Ji4
	zuUj4FWQnHIDLAljMpXZAxAfJocxalzGQupQnBakNJXB/dii12M+tWY53GHIgjCGGNF6v4dobpP
	EA0iDd4lII1I6xS226ZETYbZoLg1LgGBPn/Rx2Ty3YvEItGtrIvgfzmSLx6F0cUygHe9dOnAGD9
	F8Ll7JONQA7JzrNPUMCXgTHH2LoXU4SB7s4soqTDvymD/UcZGb0I5WoqaiNy55eqnXPFpxzNmE9
	QrMZh3sO5YNUIZEY3IerICpPVDnQhSELwiBNv/b8OI6pytfkUQArH/2OptlJXB0JcpUdqRE0iVl
	5vNHrRtI7K27PmFTLTpEUl/5HYdCpX1ySzCEaHKTWOU8Q79X/lIsD7w/Z8iSqchFulOXS3t+EGB
	NKRSdfWnj6pbG2z8NqydHTsZgb7PyH66C6UL4Foz3d/oQ=
X-Received: by 2002:a17:90b:4b0f:b0:37f:e1b6:4c7d with SMTP id 98e67ed59e1d1-3966d1d9579mr184546a91.6.1787672720351;
        Tue, 25 Aug 2026 08:45:20 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39645aceff1sm1528552a91.7.2026.08.25.08.45.19
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 08:45:20 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-381250979d5so5286662a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787672718; x=1788277518; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=siE+m2ryXog4NPKvNKmot/lmJjP0qzo/GlYgFYFLJu4=;
        b=AThWAw+QHXZD7qVCJkiM46cmv/vIMHZtYBE03bnUMkaCqbRL+B7ySOXk/IXVeFXV7t
         e/35aVoY28b3VjYPgDp7TvQ9OeX4HLZ4IigVAZw4Ief0XvLfR4BYs94ReL9T2PFHIwZG
         gKTwcqAtzGJrAZSck5F43yASJgy3QzrZsP7Bs=
X-Received: by 2002:a17:90b:5543:b0:396:41d1:cbc7 with SMTP id 98e67ed59e1d1-3966d13eb75mr261646a91.3.1787672718482;
        Tue, 25 Aug 2026 08:45:18 -0700 (PDT)
X-Received: by 2002:a17:90b:5543:b0:396:41d1:cbc7 with SMTP id 98e67ed59e1d1-3966d13eb75mr261516a91.3.1787672717877;
        Tue, 25 Aug 2026 08:45:17 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9209fafsm63445311eec.23.2026.08.25.08.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:45:17 -0700 (PDT)
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
Subject: [PATCH v2 15/17] mpi3mr: zero out diagnostic buffer status memory
Date: Wed, 26 Aug 2026 02:34:09 +0530
Message-ID: <20260825210411.301535-16-chandrakanth.patil@broadcom.com>
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

Memory allocated for the BSG diagnostic buffer status is not zero'd
before it is copied back to user space. Several fields in this
structure are reserved and never written by the driver. Use kzalloc
instead of kmalloc to zero out the allocated memory.

Fixes: 78b506984ebe ("scsi: mpi3mr: Add ioctl support for HDB")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
v2:
 - No changes from v1.
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
-- 
2.52.0

