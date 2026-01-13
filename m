Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF21A2C3266
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 14:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768316245; cv=none; b=ruOnFov5/s5PTbq7qFQrGmPbtyoNYsl2bmBEc32F6eJL1ryZ8Ex9Bpph1IV3+qqJWPkMZQm1QCB/PETUhhD4Ph2NIIeJF/+6eN0cU4UUHhTi4I4QPeZQ9EtgVmYVpGvWiQumWC4Tm4+h4wOoK/IqGdiFbCl+jhAR+EMpJJpXFkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768316245; c=relaxed/simple;
	bh=JkhvLC5J3/ByLcBxuC9nR+WqQsVC+JllxZdmDZB3+o8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RRE2TCHgS8EFIwUjmWmLpOoJkPoLpEC8yv71j5++vNN5Ue+XtoluQ8hdNdlmX1Ubs/8FyWYXANrbsnvyG1/W91cARhaKejFXhPpL1kQp6iqv/vZzACewL58dKipY/S9m8YkEUSWSJ1Ddrtk8ov0kj8wlP747QovRRvIdwCiv3C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Cl2/F/HY; arc=none smtp.client-ip=209.85.128.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Cl2/F/HY"
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-4779adb38d3so52301775e9.2
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 06:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768316242; x=1768921042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0aTvAr1gUcADfL4GDDEP86r73OtKJHoDxRoL3RshDXY=;
        b=Cl2/F/HYKvUSHt+HlLjWzM6Jqgm1E0fg5nZG08lswTfyQkA1EenCDbUQ0J9xkGQn/q
         PhEeMjKisjHimu8KEvwF+HbcFxni8WkdQeyo4eMz3Z36CwgXWj4eI8UUlGqlHa852e7z
         4iqtX14BpB3qjPeH2fT8hHNf23EcgXR+ZT8BMkqQeCqzqKmAm5n5VwZ2c6KLtZ2G9JcD
         Gk2J89SayhC0ETz4Zhj/KvbWpg+ORiaUApaMyvHf1L9sMyuPc7M6P/l1+HCEuLY6a5W4
         19MUYRI6rZMkQwFjibkEVQttckiED5O5ZEw/LXsoeYmqezpUejSqfLDl9p5AIUKtIU1u
         0n7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768316242; x=1768921042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0aTvAr1gUcADfL4GDDEP86r73OtKJHoDxRoL3RshDXY=;
        b=b7ECLdczShaqnc4xgJRGV41dGm2mvxghbL1qE9pYJF20Y5L/FDjZwIUCwqypkhwekM
         dECoptwFY74LACNrqz8NF3Ow5qlbJv/tAOS0fV+MsIw/9IdE64ikjcaZ7pNDJn52E2+p
         oJuNonEwziczAJEKTVzWtbL4lzHhqbVDEbZQ8PA0tc+XoAqcivvFmdzCMh4/MbIANIbl
         wJ6LkRS3ZaXpTOpEuu0V2oP08nsNwiFLtTf5V/OjnnRY8JniM2xuLDuK8S5yE1yHydmY
         jMt+gr+KhudE6TmszJLkVlAa4ZIj1OB1V6bXnWGVapHx3YIr8Hirc7wGgXBdfIOsI0Qj
         3JSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWX+9Rq7v0wzLOHRm+7UIxrYCcEg19IQH/+p2KwbnImNUY4gc50F1Z0c7Y+g9TEkuEbwzHum52beBK8@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6NUyRxpMwfxrw+HrTTSvUMjRuGzdP2E2CEcNG+AdFkNtRiJXM
	KnfPM7tELdVJRmZyvMYf+gxGUD2HtlL7Uox5FXuv6TxUhrN4ZMMK0qFr7kGF6atoOTE=
X-Gm-Gg: AY/fxX7KTAq6OKuhzb7vb6oBEo/hjh0hWxxt2djGi71qFHN5RJLzimnrRPbKResfzXm
	tV14ea9TTCd4IVeUlUYMti3rHG4JJJUjNg6Ljn5AZNAeA8/7EQB3Ut488em2EYOb/e41c8bY6E+
	YuTelAV03fgDOvz3p6JKK7J8VgHx9RBqppwcZ6Hc7lIXt7G33z4OTijqlzFYVK72zyP7bvKh13E
	QIz0OlN2DfnwANrEEjLhceEU2QsUYLZ+3Mi10G3RIRB36gu4rZ4w5ypQfwtY6MisCjaxvQxxnxU
	G7QCWqECYxH/N4Ejj6AKwGaqijchAcMOj6GP1GPo3s9c0H+XV1x+W6jO1243LjpwIeLpwGW3aj7
	UTJ1Jrv7UZO0K01NbfQef1u6dOn4KBmGjbCyYnu7wWq83iM+dohO2+bcmQJQSfRpjF4aQnOWJec
	MZIIm5Pn4w7dBVHYUtdJhU7pu11IUvzF7bxW0=
X-Google-Smtp-Source: AGHT+IEmifR2V2qsCCKDhF7TtW4lDyqRYQgAVIIVPUscIKnOYxWvD6YPD+5xUu47DUK68kvULGa9cA==
X-Received: by 2002:a05:600c:8b84:b0:47e:e20e:bbbf with SMTP id 5b1f17b1804b1-47ee20ebdfbmr1897995e9.24.1768316242039;
        Tue, 13 Jan 2026 06:57:22 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ecf6a5466sm128498565e9.11.2026.01.13.06.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 06:57:21 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/3] scsi: qla2xxx: add WQ_PERCPU to alloc_workqueue users
Date: Tue, 13 Jan 2026 15:57:10 +0100
Message-ID: <20260113145711.242316-3-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260113145711.242316-1-marco.crivellari@suse.com>
References: <20260113145711.242316-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This continues the effort to refactor workqueue APIs, which began with
the introduction of new workqueues and a new alloc_workqueue flag in:

   commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
   commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

The refactoring is going to alter the default behavior of
alloc_workqueue() to be unbound by default.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU. For more details see the Link tag below.

In order to keep alloc_workqueue() behavior identical, explicitly request
WQ_PERCPU.

Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 2fff68935338..b00ae7a664da 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1901,7 +1901,7 @@ static int tcm_qla2xxx_register_configfs(void)
 		goto out_fabric;
 
 	tcm_qla2xxx_free_wq = alloc_workqueue("tcm_qla2xxx_free",
-						WQ_MEM_RECLAIM, 0);
+						WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!tcm_qla2xxx_free_wq) {
 		ret = -ENOMEM;
 		goto out_fabric_npiv;
-- 
2.52.0

