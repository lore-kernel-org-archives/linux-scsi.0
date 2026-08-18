Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808CC483BF1
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 17:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075879; cv=none; b=CvlZZGGdbVhdSTwvE5B20APdNxgfTfeUVrur7uTvcr8ST76Yp9/R23ukiPd4HbH1giQR84sSV1Lpr1f26z46UHUd+5y02fnSw4xhBF+ZWcsmrbl1hspsEvJeKc3xPyYlCg492waPdi/XFkGX+PKrJnqNB+giTu9rfLkEkdRWgSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075879; c=relaxed/simple;
	bh=1YdlDX1yC4GyRdGV9eVZPtjDEBHghqNYFflAKra0SPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHoDmr+h/EHXBY79i1iJHAXi2ZSPfdiv+RsvvVKvvtC6VXrgmQUyGq+T63VyavSCXPuX/AtI6YK1JHdXykVYC1IeJMrshD+y2SguSa7jNA4sjqilDtSarFNDhxpvfwllZUowHXK4fKA1JzJ5OGVCN3+xiv+CTQdDiWqt5POUUaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=a6xUwM6y; arc=none smtp.client-ip=209.85.215.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="a6xUwM6y"
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cb5b8572b70so70654a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075878; x=1787680678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vm2YqyHuC9luQnEtHR2jJrzt2/BdG7FreZLC+GeOZLU=;
        b=SzF+6uVd/DIcndMuhw1uWWtn5qT2eYVSy94LLBC+1KyM9xwE/vJ0eLhiZl9zcikqls
         gLNi/xXL2Nz2duntvjml2ORnBLki/WWcCljLYHaLa6ljdFrYs9RkLsA2yo4vseUsm0YF
         BWPwRoTOK+m1ykPv+NlbR4G4wflQfA5OQttLUVHB2BP7ZYOciRQ4LcA1D1mEbtBZPtdU
         mGGfpIaJddgoKdRWVlkyOQ045aaZBFpv2FJR9m4z8Lliz8NZ+RPDThNtZemTmBgpj+vY
         EiHyZj+wGjmI03QHB1WM7fjl4v9psvcbenO//mHKNQZ9sEFCenTMj3w6+x6NNrhGuma5
         36Rg==
X-Gm-Message-State: AOJu0Yz3Sz2dPdVSk4srpsuBiDjg0EPTutjU48j+XyFCjC10BbO8C0Xc
	5JUTXhTo1aDEDk9/82uhUfIHmIDq+rKrg3G8CwOE3oTirk4d4PUAZsDDiPnoCEcAYyhPEbY4hq/
	ygAKqSZ3U5l8sFYNjTVVFP5GIvePdk6mcHt2+qnRSrzbqGumAOm9eg7jWtxS3M+c1ZGNDlBSkDi
	w1xAFig2ZYqUP2XYNHPHUN/ugrEmWBtO5KfFJP7Su3kF+ABvtO4yLfhWmQtaWI8fQHMK+BUU9+I
	C+9CzZaH3OStUpUx4APeDaB
X-Gm-Gg: AR+sD11MuwewVWZF53WxYKF+sQ4QomUm6g5FutnVDRtnHOSRlgqYtkdQR61a2xmDn9R
	Hgf6AmM27cOjgAqx5ZhOKyfrsdgZR7CkYhP9JMnYOcKcxo16Fvi3UI3GXWlSn5GDRbpYZyeXjsG
	u1IPPQQpqFeJ7JrmxnS+OGcNI15XTAQw+lhTX/JMnjA+Cwnua46HCDWv220oX7ape8O8R/h3gbA
	GS8lw4VALuUFCEWYb1dHdRS/UIMr+kfGgFCz94bWwCqNMV2tsFv+c40r0jk8vS78fxAwbLxK5Gr
	rVJ3U2lOXoMFrCoeNbfXPi1J0s5kMeuMojtsBirmZJP0Ja0VFXjXOpkUeCkdnu8hUsQjCLOj90U
	KCUTgr/RlP5tTENG8q4wqCQV7bCSbLUeNPUbnvdv6fy1roxxm4UFE96EZhoCRaAbu/BfS/j25v1
	Qiup/q7vls4z0TNkBlBNSncrZ5crp291UdPm2t9dM4jCQ=
X-Received: by 2002:a05:6a00:8f08:b0:84a:2c46:3fdb with SMTP id d2e1a72fcca58-851cd9af412mr137314b3a.5.1787075877689;
        Tue, 18 Aug 2026 10:57:57 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-851b3d0f6a2sm1423239b3a.0.2026.08.18.10.57.57
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:57:57 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3950b1371a7so256955a91.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787075876; x=1787680676; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vm2YqyHuC9luQnEtHR2jJrzt2/BdG7FreZLC+GeOZLU=;
        b=a6xUwM6yj2dAE5v3Ntf0DKKsoluXREOoEkekK2VDCPpzoWrVyCr6HdK+4chieKNohT
         mLJBv5yF/uua8An6KtOAXmJP08eWmj2fLAkMYHmF/IOdXzwaKh2qKWO0I6BFb2gPNz3L
         D2S1kwhh2i8ZL+xwrdsMPcV9BSwvcet04f7Gc=
X-Received: by 2002:a17:90b:5645:b0:383:5a16:bd70 with SMTP id 98e67ed59e1d1-3955a7f8e97mr14559612a91.16.1787075875821;
        Tue, 18 Aug 2026 10:57:55 -0700 (PDT)
X-Received: by 2002:a17:90b:5645:b0:383:5a16:bd70 with SMTP id 98e67ed59e1d1-3955a7f8e97mr14559535a91.16.1787075875302;
        Tue, 18 Aug 2026 10:57:55 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14153187de4sm16741958c88.15.2026.08.18.10.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:57:54 -0700 (PDT)
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
Subject: [PATCH 13/17] mpi3mr: Fix buffer overflow in the BSG target device map
Date: Wed, 19 Aug 2026 04:44:22 +0530
Message-ID: <20260818231426.58105-14-chandrakanth.patil@broadcom.com>
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

The size of the target device map buffer is held in a u16 while the
number of devices it is derived from is not bounded to fit. With enough
devices the size wraps, a short buffer is allocated, and the loop that
fills it writes past the end.

Do the calculation in size_t.

Fixes: fb428a2005fc ("scsi: mpi3mr: Fix issues in mpi3mr_get_all_tgt_info()")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
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
