Received: from mail-qt1-f227.google.com (mail-qt1-f227.google.com [209.85.160.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085592F8EBC
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 15:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672728; cv=none; b=e3ZaoTzbd5WedFLfEvZGwJ7ioyMp/5p+i05aH9myGwyxUvA97+XirglI1mxq6BFMgfoRI9ddB0Kk+L6wf7HdLjbbolRtD7bBJsMrLBej/RyLd32WrANaKWWLmbSqgWTA0hHbeuCkCdUFHQz6O1Xj6SHo05S85najYuJ4PwX4Ftw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672728; c=relaxed/simple;
	bh=ZCoXJsTcyEbLp74mM/5vDdGVS8n54dL1MnSLmhb6Vqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=po1g2mUYLACX2jBrWJZnWKBY2Z95P6Vpynym1GLpMBXO9B7Qm2qC8/vLGsBl4SIljTmQF2rf0/uSvHjsjhfEe/OL/MfSarjhvEmt85f/KQlv5nXM4Ggwz49n1CFUC39fDmiMb3Hf8+ixdRr+dzfwSjiByR3Y3O1T4iLhLEpFHQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=CfMMU8Xa; arc=none smtp.client-ip=209.85.160.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="CfMMU8Xa"
Received: by mail-qt1-f227.google.com with SMTP id d75a77b69052e-51c2a76536bso52637981cf.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:45:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672726; x=1788277526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tyjVlflOddZXAxAxmPzh6N5268snVXPgItJ9dBJnqyU=;
        b=ocKYedDUq0N8gN/THQxzQju4tXJZMgfRqIFQ15IhN5LebMhrvrrfkwDlTn6bpLE27E
         ecFzXXLJuvSLc3GxqiznBSWZSD93qUe+Xb4Fh/OG4JUJkkyvF/SW6tpHgCb/pTHpjAbJ
         KorYX5F8MLMXZy4uW1lKNd/KyjBzSg4+Fl0W6mCmzKAE4WPUknYhAF8xbunF/Ou4A/Dq
         pe/dTzf5Cyrv/F5JcmEPOW6V7e4uMP3spUcDkPpTRhCAciC41eqCYeKP+hhJ/qWPS3Kh
         RAtVOfhO1uVJNFoqC3gfHhuLPXaQY+TnPqwyGxOpjZm4rj0k/mqpWRvkwiw1ncnKdN/X
         cFFg==
X-Gm-Message-State: AFuF++k9XRUK6XcMeFGBtNXH7UAwzVpWGYWnvbppUV/hIvaPd1IqfB7X
	EKMMqYslXcvtSHzbMu1sQmWYz0ycQY8uFdrMEi8q6z5Nk1BBgHA5RGs0H61VZLXDjnAE21DoPdN
	/SmRzXR1VW/0yqdQunRBoy+6uNY/WKkGKNQTQtr8M16biiImlwxK9nqiXrdCl8XRxhxqlaeVVA9
	81EUx8Z86ncWUcM9l9uENqPpuiQLz19IorB4vENw6u7UaVxrtLJa3dFBUC4YsiwjHPpUrUOnK8b
	rPmDUm1z8tfk5L4tXXTW521
X-Gm-Gg: AR+sD10Sv5zvrkSd3oaxepTjkyN1ugEXocGuJwoY3CywBQdvvecHYegHBLo2PZ7msW3
	lWPFkwi9LvDb98B1u86FBY539QCWuViLMs+d/IhUh5EIH2c8EGO+pCS53V2G+c4O5Fb9u1TBmDZ
	XwgY4kA3ZXjEyznc/sqT0s+TYR1B4o2cU1kNt7tJZIhMp9owQjmaeToteD2eW+SIGEEA+FfxE78
	B44b40brj/NvO8d3/n2HLaU2RJkoPgnwvgynjpZOvD/l5pY1fBFIzbZJHzgBqOpZYSx/J1/LJ1n
	yADfP3mIK8iugD33EbN1iXmLmoZrhgFmeExwftIS6D6eQdDimeY82pES8LAcSe8nngMP9frbMPz
	c6Y8ihlJAPy2Y72e9tKJA1yb6ne8aMiE+6f0qq/igCxAJY+xoHByUZ7ouOhIARQHUKk4iL0q66c
	94Z1s2u9ATozR7hUGJgkAZHSsPH0HHuef3tHk+Y8eqKrY=
X-Received: by 2002:a05:622a:5915:b0:52d:8743:bc52 with SMTP id d75a77b69052e-52e09ce9d5emr295604981cf.34.1787672725518;
        Tue, 25 Aug 2026 08:45:25 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id d75a77b69052e-52e0995bb61sm662721cf.6.2026.08.25.08.45.24
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 08:45:25 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38ecc48b3c2so8422869a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787672723; x=1788277523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tyjVlflOddZXAxAxmPzh6N5268snVXPgItJ9dBJnqyU=;
        b=CfMMU8XaJHXUy8FNB65CBIeJqioE+IcVStqqYU3o7enIadVjTIAID1uHE/bRhaGI+A
         oUFiCXzytX4yEnKVjP5FiKCaP0PnrFypw7VvB0qtNoK8nDEm+aw4gJ1XHJduWSiDL7iV
         6e3QUagQ1FoY4bl1MA7QaqL+TQA0wIL0CbAqE=
X-Received: by 2002:a17:90b:3fc4:b0:38f:dec8:f7e9 with SMTP id 98e67ed59e1d1-3966d443146mr115634a91.12.1787672723424;
        Tue, 25 Aug 2026 08:45:23 -0700 (PDT)
X-Received: by 2002:a17:90b:3fc4:b0:38f:dec8:f7e9 with SMTP id 98e67ed59e1d1-3966d443146mr115426a91.12.1787672722707;
        Tue, 25 Aug 2026 08:45:22 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9209fafsm63445311eec.23.2026.08.25.08.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:45:22 -0700 (PDT)
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
Subject: [PATCH v2 16/17] mpi3mr: Fix use-after-free of the firmware event workqueue
Date: Wed, 26 Aug 2026 02:34:10 +0530
Message-ID: <20260825210411.301535-17-chandrakanth.patil@broadcom.com>
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

The enqueue path reads the workqueue pointer before taking the event
lock, while the remove path clears that pointer and destroys the
workqueue while holding it. The enqueue can therefore reach
queue_work() after the workqueue is gone.

Move the check inside the lock.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
v2:
 - No changes from v1.
 drivers/scsi/mpi3mr/mpi3mr_os.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 543e9b8e3fc3..e97e343b14fa 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -233,10 +233,11 @@ static void mpi3mr_fwevt_add_to_list(struct mpi3mr_ioc *mrioc,
 {
 	unsigned long flags;
 
-	if (!mrioc->fwevt_worker_thread)
-		return;
-
 	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
+	if (!mrioc->fwevt_worker_thread) {
+		spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+		return;
+	}
 	/* get fwevt reference count while adding it to fwevt_list */
 	mpi3mr_fwevt_get(fwevt);
 	INIT_LIST_HEAD(&fwevt->list);
-- 
2.52.0

