Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F3A2882AA
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2026 19:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771010894; cv=none; b=WIK3sZ4hLfaOpRL5XYavFP4Of9dln3efmOBbYgwLT++IYj5cz4t/TMq5T+DIIVe4wtIzLxV0wifMqEs8SbSFyjUKe271jufVGYxGM7Zv8ga2+w/d189t929lRcbTB+xfdDJdZ6yFaDu2Z63gt7DO33+MI7dhFqAowiydazwlKfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771010894; c=relaxed/simple;
	bh=UjPW0uVC2RWu7xh9+kmvnIIFZpqlM8pLv8XfawnKCxM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G3DvzEcY/SI+iWPPQ3gGSQkjdf2hRdDL8wpFSjBFbPq8+fpGdHM+UoziQwKh7P7JhvTvolfY3FRXuCJ33WFVUL3oEhHPKgSI8xtfH2EMxoXTjmYpsyETGSWmgpgSH4h+6cVS0RDGUrnWP68w7Hi7VJHteYWa+aL/f6SYjP5ciLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--salomondush.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yhkimedf; arc=none smtp.client-ip=74.125.82.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--salomondush.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yhkimedf"
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2ba87c0e198so1127848eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2026 11:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771010891; x=1771615691; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2WKcVaD9Ft2wlm83LrNWA0nU10pfi9iyt0eM/oNmk6A=;
        b=Yhkimedfc5pWyHBEPS8viZNbgwcANmvNsnXClEyGjdnqknLXbJXCgwbUSBkhzOxI8j
         IWtTzAhgMOr+5BsKJvojdjI31va/hohENQ9e4nPrynIaJ/BqxEXFym26FiOPhS8o3I8p
         HgcdQFVHM51GD4U0ID9jZp888M+cZIfti7i9+vREGVMMAGOnRmwg/z49msDVXK/Bwc/o
         5csxgT38/pYdyYtWkCmTschv9jPRGaJHXgNmmr+vY0wLO4DOgI3oIx/ia1SfV1bFMiBC
         PKLW7Y4Bp9tBSy3ME2ubyIth8JkNPYr8A0li+cgUqiI5S7ItuO5YCmfQqZY2PojA+SG9
         1Z9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771010891; x=1771615691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2WKcVaD9Ft2wlm83LrNWA0nU10pfi9iyt0eM/oNmk6A=;
        b=XUmrSBfvYC3Sh6OvhlstSSOB6ZDe60Rw09m2BLgIy0jYqo4XXpNS9XOKjuLB/frwcq
         NwRXzATHUbI6ZGXv+JJwewKKX1pgmBCQgp/f310JP5u4wiqzqfZJCP+9b5gQgSZVZV9Y
         wZjmn0U/+GMJ2EpyYHhhXp1nWbiilAS+kcAHLYpF2QHi7I0rYiBpQ3D0Ro8xmgLImvS3
         GnvCwNrGH4NNBb16THm7j7y5ZLvkMEkTQUvvZAaFrdcQw/6AA/oUYPCGiei4blvZXHuF
         nqmOfNDawsAApy037yBmFW3H2dl8icYRRCn2noKSOp3D2mycB8Dde2+czHocJWYYhZu0
         Q+iA==
X-Forwarded-Encrypted: i=1; AJvYcCVYidkECaaBd4Z5B1P+LZNkL0riPxaAiXLt7ZEHwJnQ70Yw8dQOzTIQP2IRr66e2fv6frlSp+KQqUMN@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9R/NDaCTsnkPil9HZHh15y5EnVTUgQqp6jMtmSNNSqkZUxziB
	DJzZ0oZdQtJ7iTVvmMesQUfiIpKJ0rrsxLsct1e7f6px0TjP5WsmjZ5M2SMjUascXv3Miu/iiRs
	bSGZQxYcZkNIzLTOhLMVuPYCuPQ==
X-Received: from dybmf43.prod.google.com ([2002:a05:7301:92b:b0:2ba:a6e4:cb81])
 (user=salomondush job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:23cc:b0:2ba:769b:813e with SMTP id 5a478bee46e88-2baba13689dmr1357345eec.38.1771010891196;
 Fri, 13 Feb 2026 11:28:11 -0800 (PST)
Date: Fri, 13 Feb 2026 19:28:06 +0000
In-Reply-To: <20260213192214.437871-1-salomondush@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260213192214.437871-1-salomondush@google.com>
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260213192806.439432-1-salomondush@google.com>
Subject: [PATCH v3] scsi: pm8001: Fix use-after-free in pm8001_queue_command()
From: Salomon Dushimirimana <salomondush@google.com>
To: salomondush@google.com
Cc: James.Bottomley@HansenPartnership.com, damien.lemoal@opensource.wdc.com, 
	dlemoal@kernel.org, jinpu.wang@cloud.ionos.com, john.g.garry@oracle.com, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com
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
Changelog since v2:
- Added this changelog section

Changelog since v3:
- Added debug messsage to signal device gone issue

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

