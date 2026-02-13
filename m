Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B031274B3B
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2026 19:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771010548; cv=none; b=M7EMvxlxvloDphL6A3BNLbnVA2gzZOJGHJ3UVJ1A6yl4L50mGUwYtLkf1pwWLREiCnB7HfYxudc3MbUUfmz6DzO6HaWjldMhIIUpv3sgYXJusUO0g9eMB7fgJ8/lIQnLS8+vUpkJPc7PWCP65wV5dmtZBwojprp0j8YROB6e9ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771010548; c=relaxed/simple;
	bh=lRAN5b2s8qIPY0Klj1P6SKq3/Ipitbr21jiXQae+3nw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rg7mPGXXkobKsZaJFEtC1BpCRWveHOEvbFXG6HZjHEmHh4GmbsCgwPYV40wTiSD8Y5IXfiSASWmcCcfwZpNiPozyAIU4zVL2NHWX38doEshXntQmZ0fCGasd/HT/FFxjaIvoqZufsX6mPyTLaT8S8j5x8vp7FnsRfgk+OWnQOr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--salomondush.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2uK2D5U0; arc=none smtp.client-ip=74.125.82.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--salomondush.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2uK2D5U0"
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2ba68ed568bso815137eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2026 11:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771010546; x=1771615346; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E+HQuoE8UnGrCMiVyAiZ9ndoG4yhkaEaK1xHNudOJZk=;
        b=2uK2D5U0gL/2yFHTyu4fYu41/rduFxzcvOeeDFhfXhJZnc+4EUTrdOXwWa3M1J9B3f
         PhRmtF1gUQbPYxLFGiTozhNy+2QYWueBhWLpcylq2v2wjbr5Ni2bshyhoVyRCM751b3U
         UMHOiNkgINivBc/ukq8LOf+88rv8lyEibDWBCij3eAIFuiffqZXx20y29UU8LbW5NY0I
         7qatuBYtn9twIDqcgbrwNvy4cYx86flBcEcz5bsuCNDVEVjm2UgTVBUUDAWJhAfWCple
         7E9qNWBB2gVZ+d/j6uC6TCDQnHDSXAqTslMfl4mLkrUFztm1EpYf9KrGnKXUnUy2ruAB
         Dyhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771010546; x=1771615346;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E+HQuoE8UnGrCMiVyAiZ9ndoG4yhkaEaK1xHNudOJZk=;
        b=TSp6iEJX3j1xyWuRlw9H4vzD+lPHyKaW1CPAL0+vL4V2kARfOUPAX2JbBqGJEwXMle
         cAyCfO2UJy2BWZONC2IoWG0TPK7dUalmwEpug6ZDLh7xgA9FRPfLcBp7e1lDLjO2t290
         WHKJKMJjpdetzo63XW0PATyeG3Fp1N4c/IffwP1BVCk+hQc+JdG8dedHpASVYeeUGiTc
         Qa/5Rv5lfEgj56P3BkAP0lcVxdUZKsLyEayA4ZuQebgyCAfs+ybQ/vLj/drcNsW9Xb47
         L4SvSC1Mjwz7R+ZgKD+xlzHxkJb1q8nrXIxAbuuvW6hJbqKX5LaUPP/0bAc8ykxlmYsc
         Uk2w==
X-Forwarded-Encrypted: i=1; AJvYcCUVIhrIzO9AkzAsA75f25tze2/QRb1+Vem/r6kl+GF99pOi2i27HClEzUXLjrtgQmQq2uuFqJ96Hi+x@vger.kernel.org
X-Gm-Message-State: AOJu0YyGDd+ktyCVa73d8lNNpim1n6SHACNeQEXa2WThvOVfN7VqwUDz
	uTMlmXnHcYhcJP6gXmMBqwgiDMDiOM0xn3DujKbS0Bql9+xRIlXtZhOVfRriElh0Euo2x+Wwe2q
	7P70w7+Eh+CagTTyhs48BSSE9YQ==
X-Received: from dybfe28.prod.google.com ([2002:a05:7300:bf9c:b0:2ba:88ba:e0f5])
 (user=salomondush job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:ca1:b0:2b8:3b47:8951 with SMTP id 5a478bee46e88-2bac71d4b02mr507084eec.1.1771010545892;
 Fri, 13 Feb 2026 11:22:25 -0800 (PST)
Date: Fri, 13 Feb 2026 19:22:14 +0000
In-Reply-To: <05c3fac5-b604-496b-b0eb-5b2dbd68e66c@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <05c3fac5-b604-496b-b0eb-5b2dbd68e66c@kernel.org>
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260213192214.437871-1-salomondush@google.com>
Subject: [PATCH v2] scsi: pm8001: Fix use-after-free in pm8001_queue_command()
From: Salomon Dushimirimana <salomondush@google.com>
To: dlemoal@kernel.org
Cc: James.Bottomley@HansenPartnership.com, damien.lemoal@opensource.wdc.com, 
	jinpu.wang@cloud.ionos.com, john.g.garry@oracle.com, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, salomondush@google.com
Content-Type: text/plain; charset="UTF-8"

Commit e29c47fe8946 ("scsi: pm8001: Simplify pm8001_task_exec()")
refactors pm8001_queue_command(), however it introduces a potential
cause of a double free scenario when it changes the function to return
-ENODEV in case of phy down/device gone state.

In this path, pm8001_queue_command updates task status and calls
task_done to indicate to upper layer that the task has been handled.
However, this also frees the underlying sas task. A -ENODEV is then
returned to the caller. When libsas sas_ata_qc_issue receives this error
value, it assumes the task wasn't handled/queued by LLDD and proceeds to
clean up and free the task again, resulting in a double free.

Since pm8001_queue_command handles the sas task in this case, it should
return 0 to the caller indicating that the task has been handled.

Fixes: e29c47fe8946 ("scsi: pm8001: Simplify pm8001_task_exec()")
Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 6a8d35aea93a..645524f3fe2d 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -525,8 +525,9 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
 		} else {
 			task->task_done(task);
 		}
-		rc = -ENODEV;
-		goto err_out;
+		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		pm8001_dbg(pm8001_ha, IO, "pm8001_task_exec device gone\n");
+		return 0;
 	}
 
 	ccb = pm8001_ccb_alloc(pm8001_ha, pm8001_dev, task);
-- 
2.53.0.273.g2a3d683680-goog

