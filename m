Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3416379978
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 07:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769670458; cv=none; b=GTFFs52BHckKATQ8db7dg36MwG5Ewfr7FN4yfROkaWtS+FzcVSl8gP/dyNSqMuoeQSR/vRTtV0ufpAh50iOO70Br1Q8F3i6k7xf+gMFyULa0iLbkZWYoZ50V/F/z6jk5fcIMU5EYyR55Z9RqAgu5HWeZrmIVsZdDdaTCcR6JneM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769670458; c=relaxed/simple;
	bh=cKG+sXr+1ziofqpBsJjwfmGfj2KJzaG2xyY+bHw/yFo=;
	h=Date:Mime-Version:Message-ID:Subject:From:Cc:Content-Type; b=O8S54FbK5fSGiKTuKGRmyMW0vPW/gh35cjfTH3QR5JHrSpIBfVUdAyBjoaVHHdL3CRKbTEcDIT8+3/RRa7twBY4tBh1OGJju/j0YDcAex21iMWDmUHefamdKdVFuWwByIdWjUJ8nXCbI1/aa0GjcXOHEohDYB16BgHc51ZpfnXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--thomasyen.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qmiQr36Z; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--thomasyen.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qmiQr36Z"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6124a9fb86so1425567a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 23:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769670456; x=1770275256; darn=vger.kernel.org;
        h=cc:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GqQ9jDDf7KcRrhdcWeUtqgvD39js2kt0QEInAi/KKEU=;
        b=qmiQr36ZDaE+svI/zAHJI+4mTt6T6b8cKZ+amYo9jMv3D+IGYmu0YbLcLinVVf2mWR
         S0zrfVI+dGUa/O4Qm2qv5yv7NA+JhmJgKRB8goSXN9gwLWDLe+jU39hTY7od1aKM+8fU
         rjXpSGBp+jXhLf48ZTXS3HpAJDELX5SQePRqwwJ13+KstAJK/LTKvj3Jz7C+9LYiEfoe
         qT+sX7mrzIVsR7+AodJibPRJQDdgrqqgKdgTMCtIgr1KkaNi55NZWRlfL2GR/vZvcZXn
         IUjMrz7Ew/hvInpSzCm251yHR4Z3tq/btmnGcjonizl+KwnTt6vTsE2KhN665GnHTdEL
         0OTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769670456; x=1770275256;
        h=cc:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GqQ9jDDf7KcRrhdcWeUtqgvD39js2kt0QEInAi/KKEU=;
        b=ZG1FqSBJ1gGoMbcY9sYNAF5bCaez87gmv6iuodXcImhwlT6961iQnvZZnkTcpsTKYK
         tn3TukVfMZ6SZsKKAuSQtcd9XxyonUCYM/iUxvIuOyHzoMoRPpOVDBoGqVCqrW21L+2M
         qk307wlmCrlwGMDoRRCven+HTU6t6XNHC9VaMe3K46p1nkb01JVnG2nq7qTBu0RzgYJd
         RbbDvNpaYGRRrEM4ahaNDuTqdOrEXei9PTxzn60+hp1cHa51Mc+YXNqQ9FMfvCYpbL/p
         GRp03l5rURHxuihTJvyjyFgpJfcspN0rDDaonQs+qNPK/W2k/X44t0kv+YPkUHjasij+
         5qFg==
X-Forwarded-Encrypted: i=1; AJvYcCUeji7jG9Onja1OoZ57UZCnasOaptvx+aZ/JBP7kNQcrIfQ0mKSryqU2Q1ZnOS/1CjmUoUzyEbKUBYS@vger.kernel.org
X-Gm-Message-State: AOJu0Yw41XaHxsYT5QQop/I5WoxYfbvNKDmRZ4lUuOSkqMkPWnKqwWb2
	Vrs1/GBJ2EVYdLmPRHVg6Ju2hLvQ7YijQafVmy0w9/ftELK12HGwj0dJfMapYtjiRSR038KIWMt
	2q+ay3ZnD/QIYZP+Ztw==
X-Received: from pffx27.prod.google.com ([2002:aa7:93bb:0:b0:823:f96:63b3])
 (user=thomasyen job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:7585:b0:81e:b2ba:5b36 with SMTP id d2e1a72fcca58-823692fd797mr6468252b3a.63.1769670456140;
 Wed, 28 Jan 2026 23:07:36 -0800 (PST)
Date: Thu, 29 Jan 2026 15:06:47 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129070657.678532-1-thomasyen@google.com>
Subject: [PATCH v3 1/1] scsi: ufs: core: Flush exception handling work when
 RPM level is zero
From: Thomas Yen <thomasyen@google.com>
Cc: Thomas Yen <thomasyen@google.com>, Stable Tree <stable@vger.kernel.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Peter Wang <peter.wang@mediatek.com>, 
	Bean Huo <beanhuo@micron.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	"open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Ensure that the exception event handling work is explicitly flushed
during suspend when the runtime power management level is set to
UFS_PM_LVL_0.

When the RPM level is zero, the device power mode and link state both
remain active. Previously, the UFS core driver bypassed flushing
exception event handling jobs in this configuration. This created a race
condition where the driver could attempt to access the host controller
to handle an exception after the system had already entered a deep
power-down state, resulting in a system crash.

Explicitly flush this work and disable auto BKOPs before the suspend
callback proceeds. This guarantees that pending exception tasks complete
and prevents illegal hardware access during the power-down sequence.

Signed-off-by: Thomas Yen <thomasyen@google.com>
Cc: Stable Tree <stable@vger.kernel.org>
---
v3:
 - Add logic to disable BKOPs.
v2:
 - Add Cc: stable tag.
 - Reformat commit message text for better line wrapping.
---
 drivers/ufs/core/ufshcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0369043ca010..8c88dd5c2cca 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9997,6 +9997,8 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	if (req_dev_pwr_mode == UFS_ACTIVE_PWR_MODE &&
 			req_link_state == UIC_LINK_ACTIVE_STATE) {
+		ufshcd_disable_auto_bkops(hba);
+		flush_work(&hba->eeh_work);
 		goto vops_suspend;
 	}
 

base-commit: a48ca06cf343423faa01c573aeafba9fa5f92577
-- 
2.53.0.rc1.225.gd81095ad13-goog

