Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C032D781F
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 14:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768316246; cv=none; b=TOPi/O7ml3cQOqjtJjaFzL1BUMysqu9c/ojtZXxgkYku9f8+5vRIs3r4A/lLL+YgWRx0bD5sIL6e2Dvq9x3gOeRjy5jzKl1tDmD7qX+MIwhGWlLoIyPB0HsUujnXOH5CDYCyi0DReMS3yUgtrVQ7s1vdMADyFtwf3CfkiQultOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768316246; c=relaxed/simple;
	bh=XbPRJVIj9NvQT1soNjv88NN1qqiSs0zpG0pE3SN42WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gNuMydztHWhYcgS8/Whc1hbxxNY/qfs6NI7U81htWINohdLOrWjseivG4eaNkZKuuDaKKI0LNHny1S/nHe43JS95yrTXRMcTeqfX3d4nB/HHW3UGE9SVaaBuUkeB0FvpSglMWkq1eYhJs2WQDuZuOrIGsTfB09oVH8H2sj0enzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HdVAkFkW; arc=none smtp.client-ip=209.85.128.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HdVAkFkW"
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-47edd9024b1so4079305e9.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 06:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768316243; x=1768921043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5NtCKpXMmiGkCvj3M00veC7KRMP5TEp6tH8n8g+k5pQ=;
        b=HdVAkFkWREM8HU94XGBLv07nf095z+MmvSuLvmPV7tbj65cVGiGREph8Tq9DJ90CRG
         lEeLIHmQGfxlsbSmIEpkjSACSHzs3D8PbGeiyLU5npAXWvgS8YBIOB3W140jJUYjmgcX
         Pj3lHseOcAdbadVWPxRiH1dz9NjgNXxsqMzgrNRNbPnKxnSzfAGLNkDg2dgtuo4kTAHm
         lt68RCwnyhXZHEBgRjkyIdFGrMcS/QB1CZclRDSmb+9cZuOTgrsKlifeJ4O7ZISAEFgp
         SNOvJiW9A4V8D1/Q7CpJjA9PF6uw7g3LiWECA+0Kup2tvKux10v5YwS3UdBMe/v2QaBs
         WZ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768316243; x=1768921043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5NtCKpXMmiGkCvj3M00veC7KRMP5TEp6tH8n8g+k5pQ=;
        b=r9+ukdH6GUNwrSuL3ptQKPMfARyPk05ZbaxaLu4vY9jViO6b86NuC0GpfoUnQdderL
         csKf9pWKVcJFW6hvAWi4Vsplj75FRm74N1GViF0vJcjWe5KvmNt81bQAVlBfbcLjStCV
         U9u93ICr19Fsd8RSNRdVW6QX8Qgjf8Zt+hXbzjYItlSP7fjbAn9MsmJo5HIjfqo0wsgV
         jF1d4sk2Zccr3rGv8NKUEFOh0cm3+A+mCsBoMnyv0ZQ+q6bf4+758+aHZ8HR7infTgiu
         zb2KHd69Iq/PAsXKHhqVuelLhnX0qNEuVg2hrYLGvgAD+iE//nQr7qfGgbb8etkEgQLB
         Hx+w==
X-Forwarded-Encrypted: i=1; AJvYcCXDGb4RbVCqQKvvGECdjXprjgu3REGs3MRvhQQkn9bRTVztWdOnC4G76yg7nurxhILvlbk6dMlDZp+s@vger.kernel.org
X-Gm-Message-State: AOJu0YxpvLrOO1q18hkgBNXNOWWNL1k7e2f0CSYXhFUfPdAre4HGtX68
	vJyHTW7ffv1n8jkgtMn5+o6qYc/qGecwLr8UVMrGUo0qxBzU33gFmqvJwopGgz8tO/w=
X-Gm-Gg: AY/fxX7+TYGuRc9KOOjlCzouNK2tIUHxLa6H0INDF6y5LiNDhYxzMEqTGnhx/XUnwQK
	pf/PKKOsPKTuOWNGs6KsC5PMGbMEdsYgFEOSCyeQDzsUrSPbfxkmp41NMWRLToK8HzJdCeZMOA7
	tYPwUqUkskZajnGhbIiwl355HWJavdE7n5XIu4flHlLELSGqNitcZUiMIc/rw67OBoNpDrRoIPF
	yqQ2cLHGb351oOUHQrsiQUQOUTRD1UtpsPWP5ji+RgUIC5eVK4a4tMgentR8J8ETADO1DYOwb4X
	0PQangMkeqe6Ev5j2bKiGJUoUtTHr8EH9C4ZJO1T/DU1SShOl+22YYk8/kWXv8olOE5GQqCM9Kv
	3bNUZHI36hp0ddpv/kYU/ibRKIcKrarVcnXLZUr78prkMD1kKlSpMVDAsEwI6Oy1TzA25hCCL7X
	vrP2qJh86/pL6PgQHyNMINbRHmRb3bd0eGDa8=
X-Google-Smtp-Source: AGHT+IF0UlDyV1YXD8L+RJcw39FdxGSjXzq9BCkjijCcXDCnvi3CO0LC4Q8UaY4OS3Rl6HHdf9zpKQ==
X-Received: by 2002:a05:600c:1392:b0:46e:4586:57e4 with SMTP id 5b1f17b1804b1-47d84b32ef1mr258980645e9.24.1768316243240;
        Tue, 13 Jan 2026 06:57:23 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ecf6a5466sm128498565e9.11.2026.01.13.06.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 06:57:22 -0800 (PST)
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
Subject: [PATCH 3/3] scsi: qla2xxx: target: add WQ_PERCPU to alloc_workqueue users
Date: Tue, 13 Jan 2026 15:57:11 +0100
Message-ID: <20260113145711.242316-4-marco.crivellari@suse.com>
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
 drivers/scsi/qla2xxx/qla_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index d772136984c9..ef3a5fac2b48 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -8390,7 +8390,7 @@ int __init qlt_init(void)
 		goto out_plogi_cachep;
 	}
 
-	qla_tgt_wq = alloc_workqueue("qla_tgt_wq", 0, 0);
+	qla_tgt_wq = alloc_workqueue("qla_tgt_wq", WQ_PERCPU, 0);
 	if (!qla_tgt_wq) {
 		ql_log(ql_log_fatal, NULL, 0xe06f,
 		    "alloc_workqueue for qla_tgt_wq failed\n");
-- 
2.52.0

