Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD2B488205
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 15:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672663; cv=none; b=aNE1WT4ZXcJ5NjP6pPX3iElOIb1hXxbR0sq+GvGGT+NIiAvij/ubDItknZi6uc5NOnbM8xX0xMNS03yHtCWhkagD5LnXz38fZTJxGD4/ODlEM8yVCBq1qi9Vp/ldlj+ggk2LXT8Yhdq7+LPovnAaebSqfb9pg4jF6VPmlOxVcgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672663; c=relaxed/simple;
	bh=aFAkwGVymWc5TenHMAGuq1hla/zDP7PO35LNgtf4pos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcq2uwAF8TfT9HpGh0mInmw3qEhnbiecVRP1yBdOzt7l3xG8Z+4FXqT4wu2cZZt07sLecfzipACY0QExC46Wexreg9c10l2SwX/8cijb71J9wlgUKhXa5UL/bXDyhaVMu49FStEt3o8qRdwZAoj1fWa25tF2nq235erq/MxWcF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=UqLwq7RP; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UqLwq7RP"
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-38dc4553f62so12263a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:44:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672662; x=1788277462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JkVoYQSp+1UtfoOYHZpq5J0m3B8d8WiwQN9c0UprTrs=;
        b=gEgLl8DFNIgTVIHvh0gLm9/svQrOa2tevTY1IQ5fbU69JoFOz7vD5up/27SmwPtEZ4
         WIu7YOsVPpWDnUCxrDMS2TOfoGv6BJqabjCowV2hUlS8v0yZoT7Wyo7v/LSjzTZ7Xjj/
         EHLeNFopa3eYwAPLtq2G1m73wxkSosTQL3WbibZwkLPASkkm8aZUHGrmxWOSXLJCO0E8
         +lokk4ooDUVViGkkObI+iJdyG1rPkLLSWDrUZhAsHxOh2QVNhgOb1c2b0Y3pYJ4Dxa0u
         NKqQ7rpHVX6oIIuAR0z41A7oGMZ4ZESR/HzqprEOH8gOHam9Dw2IHirQM/AxRE14dXGw
         R9tQ==
X-Gm-Message-State: AFuF++l9lTQEAnNzGIT+y47MKm6N5QuM/drISG/8ek4wYmBol1oCujCH
	cqP3MXjryk6ZLGrdPuowf0Zpj/WkJaAz2XI0d71kBuzPXwIxnQOl0Ea8XwxE03H+onOJiAdWFLS
	jH0SPjpjqxHEcg3evDCbOxq/MwKBIAyqqQ3ys9+F37dZw2TUCJuoVUlwzK9jh5PqTTgQrz62rgP
	qYKpVggI+LaImkalVTvFd/I+aTQhTF1yFYcZI4/sJQjQXRjgT5yPw4EEufnSRtqd7UeKTvgZAnM
	MYXvb9cGZyYHM9TQCv3IxlK
X-Gm-Gg: AR+sD11VBXyoOrkP5eohILoE3rdNOdB9+VZ2VfFWDVyfZ7j77YF3SsLu9hT8KtYGAc4
	CsnaRoK4jmBVmGE2oqO3+46whCr+rlh8/tj0+ZUuTx/LEVdWL8VZoSGLWVutjscsQ3VKYTCE07s
	wAr4Cvqs6C69MMuhVV7wCgi8tYS0EBqW1D7T5mWCx6TL4ZW/O6id9rFFeuz9cRIyVzP1myQyCfp
	8oPgDruQcJnFEF4nt2qvxHQM244ZfXDJwYvyN9jLL+tLvu3/+25qP9ky3RJEAtMKuUV2EfRaHES
	zLJek11E64GV9Sw0JKJItJlUqqjWP655MAOZ1gSsY7xQw+IcgHwL7j83NHaue+7CZjou628MBIy
	zrBArfMeVIFxgFMRZS2j4cqdSrYfBqTmlP0uBQo4hKBBqQcWIztfZgtlMHRiieC6YvGjeqyvGJ1
	T6qDlcmnVU5moANh7yJRfT80PWM6hJ8NAjLi29ZxwJ33Q=
X-Received: by 2002:a17:90b:3892:b0:392:ca3b:370a with SMTP id 98e67ed59e1d1-3966d139180mr211515a91.2.1787672661467;
        Tue, 25 Aug 2026 08:44:21 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39668a6b255sm84184a91.12.2026.08.25.08.44.21
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 08:44:21 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e475f83a2so8616558a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787672659; x=1788277459; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JkVoYQSp+1UtfoOYHZpq5J0m3B8d8WiwQN9c0UprTrs=;
        b=UqLwq7RPjm0ldGSZEF4G/aF0FoyqQN0DFuQ6IHl1aqChI5LjTUd3l4aqJkaFvKEbbJ
         uMSbvYYzGVeJwK6GB02d7X/2yNjsc79fe+tJsBmGel9dFcwWFDriQInetcW32VMELMdh
         t3Q7CeGyWbrp8C4zQTjqFDUmiiawzsfuJNVDk=
X-Received: by 2002:a17:90a:d2ce:b0:393:1d92:db5 with SMTP id 98e67ed59e1d1-3966d3dc5ecmr129258a91.10.1787672659534;
        Tue, 25 Aug 2026 08:44:19 -0700 (PDT)
X-Received: by 2002:a17:90a:d2ce:b0:393:1d92:db5 with SMTP id 98e67ed59e1d1-3966d3dc5ecmr129116a91.10.1787672658914;
        Tue, 25 Aug 2026 08:44:18 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9209fafsm63445311eec.23.2026.08.25.08.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:44:18 -0700 (PDT)
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
Subject: [PATCH v2 03/17] mpi3mr: Fix I/O block counter leak on admin request post failure
Date: Wed, 26 Aug 2026 02:33:57 +0530
Message-ID: <20260825210411.301535-4-chandrakanth.patil@broadcom.com>
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

The per device I/O block counter is raised before a task management
request is posted and only lowered once the request completes. If the
post itself fails the counter stays raised and I/O to that device
remains blocked.

Lower it on the failure path as well.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
v2:
 - No changes from v1.
 drivers/scsi/mpi3mr/mpi3mr_app.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 1cd1c38dcd56..a4fe10a05cb3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2782,6 +2782,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		dprint_bsg_err(mrioc,
 		    "%s: posting bsg request is failed\n", __func__);
 		rval = -EAGAIN;
+		if (block_io && stgt_priv)
+			atomic_dec(&stgt_priv->block_io);
 		goto out_unlock;
 	}
 	wait_for_completion_timeout(&mrioc->bsg_cmds.done,
-- 
2.52.0

