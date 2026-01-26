Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E903EBF12
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2026 03:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769397587; cv=none; b=NqUWxfiqWbArliBladYXXfkErSLfiT0Q6JvH91NFHp/6PEqpqEJJ32NDzUAMXduaSvTp5WQcu/BhcI+Nf3Uf4YiV4cqboQEMi3G1X1kUoQG2o9X1jHtPawFH++inFxORwgAqkhaLsUXZ2bi/S5QVf8/Aan0Pn6eXcaUbrZuFnQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769397587; c=relaxed/simple;
	bh=KkgrRt/tazgCm9YVHO6D5hEY9Hx4T/GzdiqYhZoLhLk=;
	h=Date:Mime-Version:Message-ID:Subject:From:Cc:Content-Type; b=abymRZWu/Bz7O3stiVhTjntgII1cb5dI5cqurGZahWf0VkEl3LtXKX7rljHnP/8haqzaTNXvzLehQ4h59HFZBp0plpF0GYqzjCe4oUPvPnE5t2TktiEyCrCMqgS5fS7sSiSyQdN4EJwiFlCbnzdTbS5HU1WuDQE2XTr9Dbca6Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--thomasyen.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZdpRZ6AV; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--thomasyen.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZdpRZ6AV"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a784b2234dso73686155ad.1
        for <linux-scsi@vger.kernel.org>; Sun, 25 Jan 2026 19:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769397584; x=1770002384; darn=vger.kernel.org;
        h=cc:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gcCuKusoA/00VOO+KPUKBQ28Re2pog/ilG38/RbjoZk=;
        b=ZdpRZ6AVEn4S9/tjLTPxIpuzqtNltUKTzySXBRRsmReR4Rw01yCYDHZuetYN3S6Y/2
         L6Tts/PvBzmrULE61V1kQze1uOdGoF8vvJrG2yqgIVadpG3vsk7qjal2NrHfOswQ8Bk/
         PgnNN7jflGpETzP3TJwxFmF/xx7Xb5EUwbZlEALa/17tqMUQkkpQMAu/GuLLdp5NWxWB
         5LFyGxXShM2ZpLEhEaDHbMc+UhwMqXQfV/545KVlFvW4KmDRUTGYItDOEgMqDCp/FH2t
         s6+oQ0xw3l6hyseE4mpx+xQ/gEgecPXqOBItPoR5S822voQeiX343qBDIPmP3KCysOO6
         LS7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769397584; x=1770002384;
        h=cc:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gcCuKusoA/00VOO+KPUKBQ28Re2pog/ilG38/RbjoZk=;
        b=mPBhq1d/zJ+HJXdPKK9PWJbjLoQ/HP+IPjb0jduWpfCGS6t/SpbcbUDwYuXwCHh1/M
         lQFimdtpqeQPd7tNSTVlvw4lLTkB9Xp/yJv+yJuV9EqwFXZy8bJARd65ZShR7yTlWIMe
         MvU3t19GvoWBYP5bRD9RA4ttYm63c0hf7szZ2oXElLlxb8r7eIJYEQssf1qWrqHaAhhP
         0sDc4bgkuRWv+oOz8Vi+fjk8nadcrFavm1BvmxtazDrFqtfXrSBV0I0mCVywRGY24rjy
         xr3udl1xjkZLqEkN8Z6X6W8pHEz9BH3V0KtJy/oQIfUbHvGbgix2wkBKrj9u6ZMBeN4Q
         ZhRw==
X-Forwarded-Encrypted: i=1; AJvYcCW0JE/u6+fno+G19hJXtQ3AhL2lzTRuYNsvX4M/x7VjaVPEnotE3F8cBx+WhWYYsYZeemqz8OP38edo@vger.kernel.org
X-Gm-Message-State: AOJu0YxoQlqJyCCNDEWLUqTRUTUt4MUqs5MDnomiLV5HdnB584MGPx9G
	DGAzlSa3YGg2uXIlJDxyYuDX9gvjL+ZvazbudHRtnCwx6pMJLqhNlieMcrDjGu8YYqAG3Rbsvnc
	6nhkId4cHP6/6ppHr9Q==
X-Received: from plge5.prod.google.com ([2002:a17:902:cf45:b0:2a0:835a:fa57])
 (user=thomasyen job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ceca:b0:295:5da6:600c with SMTP id d9443c01a7336-2a8451f9260mr33078155ad.2.1769397584006;
 Sun, 25 Jan 2026 19:19:44 -0800 (PST)
Date: Mon, 26 Jan 2026 11:19:15 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260126031921.2511736-1-thomasyen@google.com>
Subject: [PATCH 1/1] scsi: ufs: core: Flush exception handling work when RPM
 level is zero
From: Thomas Yen <thomasyen@google.com>
Cc: Thomas Yen <thomasyen@google.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Peter Wang <peter.wang@mediatek.com>, 
	Bean Huo <beanhuo@micron.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	"open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Ensure that the exception event handling work (&hba->eeh_work) is
explicitly flushed during suspend when the runtime power management
level (rpm_lvl) is set to UFS_PM_LVL_0.

When the RPM level is zero, the device power mode remains active and the
link remains in an active state. In this specific configuration, the UFS
core driver previously bypassed the flushing of exception event
handling jobs. This created a race condition where the driver could
attempt to access the host controller to handle an exception after the
system had already entered a deep power-down state, leading to a system
crash.

By explicitly flushing this work before the suspend callback proceeds,
pending exception handling tasks are guaranteed to complete, preventing
illegal hardware access during the power-down sequence.

Signed-off-by: Thomas Yen <thomasyen@google.com>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0369043ca010..3a0e6c9ba86a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9997,6 +9997,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	if (req_dev_pwr_mode == UFS_ACTIVE_PWR_MODE &&
 			req_link_state == UIC_LINK_ACTIVE_STATE) {
+		flush_work(&hba->eeh_work);
 		goto vops_suspend;
 	}
 

base-commit: a48ca06cf343423faa01c573aeafba9fa5f92577
-- 
2.52.0.457.g6b5491de43-goog

