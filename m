Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E303333755
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 09:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761904617; cv=none; b=PvTmuFCrILqBEbmo/PNPSoPyBBOgrfBN5+7qw1LOP34FOwbJqbelY7oL3iloLsBo7G857CyqzFwApN4HlLML4YG+YYHhCij0BibC4y4ZJ940MTHxa6WXj/Up5dG99Q/X6gR9gEUsFpGlcN26xN9bY0URJPbRuP6pPcE61FSYABk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761904617; c=relaxed/simple;
	bh=YsRvqvzwy42IvsqDkcBl0YyIAOhXzGMpxsJ8NofpaA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fnoiXVTzwakTK0UZq5fpoZXIrNbv77K1ILw328W+hhbUFqMHVCWcJMehOupuMLNG67Ni+E3/0B797dwdDRtk4V7o7V63yd5BzEaNFRj6GNqimzke1lUv2LEFNQQhLkfsLY0kyJWzc0O3o5R8C5Y31U3Kk1fmrr+uox6UKQSjAQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L9W+SN3I; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L9W+SN3I"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3ece1102998so1428263f8f.2
        for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 02:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761904614; x=1762509414; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wj5wFR8hbemxjJEZ74XNLCfMf4UXzmASpi1RkT2VDLs=;
        b=L9W+SN3IK4LSuka3+vex1h2xg/fdpPfQEEsTE02E84HyN3F6FMqD0U9pn9c7kZIfUJ
         n4Epv8Ru4Z7qPM3BdlV1KxrlCoHlq1Ztn7SK+nBd9Bqy5Tq06ToIFQibS6pE8urj2cq8
         RcgCS+6VKJrG+t+ur0VCIwzAIGesvfZFTA1QVzh0aCXQl2sBOb38n8wWgglvKZRN6Z9h
         X7TKjUnq5aj0fXa28K7YIapdb0KQ6TLQHUVGLykssWj0XeEhuoKYqukWCE48twwwW480
         8Ghf7vaa1J+cs4GEvxAV4n7VfetDYHpSjcHgh2lvcGHO2i7fO5SOECYm6552Oot+tEUG
         Qc6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761904614; x=1762509414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wj5wFR8hbemxjJEZ74XNLCfMf4UXzmASpi1RkT2VDLs=;
        b=cLXLg/s6CIyiumj+2BCgVnAmu0FplCdiMRQg9MShFpN0FEId/tfgFpQeykqOdvoQFR
         smAR5d/huP77DBbupM2DC1v2TsRl++yB6dcKM9t20+xKVeDze8HsGZjcsW1LU9omGv91
         N/iyS7g/8/2EPQXZKZnvjmW0QbYzwOGDXYnXDzqrvAR2nssl5Aixjh3ID3Xkp3/9HFlF
         qEk5UiQY44AGBNEWFkVloZJW3Uj0r+Cxdyd7bum5pqO4XqIu6IZFR55SZ2skPBJ8quGj
         eujJGaByQi5KVbavtFwu3v+ltzNWhTo0/crJOu6ijfIO7hyypi30p88I2Ty60orO9TQ8
         ArfA==
X-Forwarded-Encrypted: i=1; AJvYcCVfk9MhtB4txityiGZ9dUwXmY2ZyxG+5qQ8FX20ZcSlt9pQduDqOnqDRRT7nrgTC2b5NCSbWNajwjZS@vger.kernel.org
X-Gm-Message-State: AOJu0Ywrz0my9XxsQB1TWBzr/Pv3zJ6UnWhdWEVruty0Iyp49zJQZU2h
	QJFpUmA0O2QoIuZSbRDuruQd/ITPQz4wlwryEwwLtonhF09Q4DYJeohjNFovbzN+soM=
X-Gm-Gg: ASbGnctZvqRW8iYkONIVfu83KAH8OqUW4PjaU9SFvL5nYmtE0q2kuhLOjKED7XcOoCs
	JqThVEuqNeAwQMs9EIIGc1H2x3k1/aYLeyDmloJ5rH8dGTVCa7fV7XDkqGkzyak11Mn3HEV/uix
	L/945shpiP3L+pm8vx4QWu4iqJGFTx9Whb0eU+GnoRI+Mh5stYC+NKLyNuacGIQBEZcNMhP+l/y
	M9OLOQg3XiKd3UNj8zuKhowREaHtWmsnyThUVGhQSsdYuRdWK/akGcq9IcpnDDEB3YrjOFvhBpU
	GIcLLyTs5QU+NMUYBw8iSQd5tGnP0nSEWtq9H79ggPs3ayhhzWemugA+/CXx4IH735Xlj9fiajF
	Fs0/u3k5TPxDJsP9h25WImh8Lz+/4wqg2O4pnQ5cEzxtAlunls+5h7YiCohG0mN0azm8LglyXXY
	Iiyy7KmjjbcnOhvm/UGgY81JTB
X-Google-Smtp-Source: AGHT+IGvgD1iUrqYLeXYES3g/5f/GyDFaDz9O3/AmAhZTEp0SFV6QYXUW5hz3hGfRU8tFX97XX6G3Q==
X-Received: by 2002:a05:6000:220f:b0:426:d582:14a3 with SMTP id ffacd0b85a97d-429bd671cbbmr1825694f8f.9.1761904613645;
        Fri, 31 Oct 2025 02:56:53 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4772899fdfbsm81572335e9.4.2025.10.31.02.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 02:56:53 -0700 (PDT)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4/4] scsi: scsi_transport_fc: WQ_PERCPU added to alloc_workqueue users
Date: Fri, 31 Oct 2025 10:56:43 +0100
Message-ID: <20251031095643.74246-5-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251031095643.74246-1-marco.crivellari@suse.com>
References: <20251031095643.74246-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.
This lack of consistentcy cannot be addressed without refactoring the API.

alloc_workqueue() treats all queues as per-CPU by default, while unbound
workqueues must opt-in via WQ_UNBOUND.

This default is suboptimal: most workloads benefit from unbound queues,
allowing the scheduler to place worker threads where they’re needed and
reducing noise when CPUs are isolated.

This change adds a new WQ_PERCPU flag to explicitly request
alloc_workqueue() to be per-cpu when WQ_UNBOUND has not been specified.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU.

Once migration is complete, WQ_UNBOUND can be removed and unbound will
become the implicit default.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 drivers/scsi/scsi_transport_fc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 3a821afee9bc..987befb02408 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -441,7 +441,8 @@ static int fc_host_setup(struct transport_container *tc, struct device *dev,
 	fc_host->next_vport_number = 0;
 	fc_host->npiv_vports_inuse = 0;
 
-	fc_host->work_q = alloc_workqueue("fc_wq_%d", 0, 0, shost->host_no);
+	fc_host->work_q = alloc_workqueue("fc_wq_%d", WQ_PERCPU, 0,
+					  shost->host_no);
 	if (!fc_host->work_q)
 		return -ENOMEM;
 
@@ -3088,7 +3089,7 @@ fc_remote_port_create(struct Scsi_Host *shost, int channel,
 
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	rport->devloss_work_q = alloc_workqueue("fc_dl_%d_%d", 0, 0,
+	rport->devloss_work_q = alloc_workqueue("fc_dl_%d_%d", WQ_PERCPU, 0,
 						shost->host_no, rport->number);
 	if (!rport->devloss_work_q) {
 		printk(KERN_ERR "FC Remote Port alloc_workqueue failed\n");
-- 
2.51.0

