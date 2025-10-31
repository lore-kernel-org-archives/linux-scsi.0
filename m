Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B8E1B87EB
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 09:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761904614; cv=none; b=RhefpqgJbH2uc9xrJQjWdnwtZ7DKRnmeGkLXbeNHdXlbEu3Mij3XvBlY6ECiiZ595KfBk7ccP813CWlJ1r7r11Zh7OVSHOqUKyzawysPG2DaYb9ei0jKhERcwD9L5N3Yiqs+kK7Uchvk174JdljJz1UcDeXM01c4a/26vSBXUPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761904614; c=relaxed/simple;
	bh=ldgiTE1+WfNO67cXfKx9bMBKR1YnSv3eCRgRrAzuHhE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=muh4EHuOuhpdgPZyYKRPuEN5GHCwKVCOM4ke94BoPFzYiQJzDNzHS1Ft+/fhftBvBvgWWGLMWikgnMJKLU53CIQ1CF5HaXFGabzxEN9UQVqZiS8p3DiLAXYiE0zCfQb+egWhG6N4L4SRQJr7QG0SepDXHuGGw9wcNdzw0alm2Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NNpDFLOa; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NNpDFLOa"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47112edf9f7so16293325e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 02:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761904610; x=1762509410; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3bPU3/5Pxj1TxQKWifL2WudwJgCQmHNErHe+zXLH5o8=;
        b=NNpDFLOajqthrCf56Verhgs210m5NM19a2qsS6KFxOcU51w22ZSF9sfAkNPrTpNN8t
         TOvywD3NNC9amqV26mcZtgQHuUr9nGQHzo/jM2+kMiAlmmXp5roBFUANBtx04LF7iN/A
         I7Hfeho4TxCtgd95qCuEkY056/BphbvjlirTRDRsg46RqCMyYAp813CQEuDqnUdjlwqQ
         6rueQq6rpl2KM3xO5eSfUTPFcPEmwdCiLP9TEis3IsgdPvg7T575v2TR2bhtReEPZ3SZ
         hNcQhKYIoWqSH48e7nijOidpf0l7E2ZdTvnLX0tcFRPGhlQYqcOArfZMDaHKayfBKW+I
         oi0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761904610; x=1762509410;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3bPU3/5Pxj1TxQKWifL2WudwJgCQmHNErHe+zXLH5o8=;
        b=tccIKv0+pze5xrIamQ1R3hGlq0MQjZGVP09vZ/tga0NHUTryjQlj7CIdyIodduqs8J
         Fx8sl9iWcdBN/l5/0OHfAwHlMaDw5UIT4zV/5UyArzm3SY/1joOWl5BmXO13A6BeO/BD
         Il5VaMa7GRfbLp8g26IwN1gQcHfe+Bl5A4F/eXtd1uNErrHVftzyk7dC3U3PP7sHWgV6
         GELwNrnbiYIGuXobHHY4f06TWYKOhy0EdxiZPhwaaShY1tbfEexdkfLFg0zF5nk6rbgx
         9Qnukln+J/Goi8rAmaj3N4g4GfVwpV22X02sGbYOT00qcryyHebbnJANO2F/YymRLjcx
         ktMA==
X-Forwarded-Encrypted: i=1; AJvYcCVmq9ux1KXO58gIDCc4ZbkTDYjkPGbtkrMTFcAsqukZwCh2dIjOHLNPSfyTiF1uE+ZSCeXLnGevT0PV@vger.kernel.org
X-Gm-Message-State: AOJu0YyQRhhg+dWxa/zqlmHU9nqrMeVzYpCFICS5PzkOWo4pPt8Hbs0h
	LsMoNIzqsQsvHfyJ4KC+G4esfSastXW5CWBxSCu2h/15WiwEtv2wiJNZAR0ngw0AGEM=
X-Gm-Gg: ASbGncsaLga2/WiakNbWSey7++LBTNuoU5vrNvSaIS2MuaxWnL3zJjVIKELRWBmyDt/
	s5y5POMoW5pnOHmfa9Mf+CfPXnoo8BK/XtroHmYDIA6YrkLoAQKjouziPzOIXtx3rBUihJAO39O
	4zGz31jYoS+/sIkg4BHlxak4cGLPCnJFo4PNYw+AqLjPGxHv+xwXcSehYogWK07FEHhBBwM1O13
	b2SObNX1x8wZja4ir79JC8rLTbw0GjeaiyGoyt9N4KYmlZKiO/telK2fw39q2E2tSqQkWV6Q7XH
	n986tfXizfVOpw9HHRlS76mlkfxy3oZ30F00/gLeEORQKScrbPra3HGmi20dtteeQkYr1FCNNth
	/EOyBN/j/JKCia6NOyN2BoRZTQR7R2PpKeMuRfQcc9eznXqpr/yeyIpDsra7q+Eq6hTWSWxZeA2
	L+QH8y+rK+zUXZejM+HwvoghrsW5hLu4Wp7+Q=
X-Google-Smtp-Source: AGHT+IFyRuZN/n5OYMLrd5h0/msKKVDJ/0GdrhxcdKbBKZ0pCApS9XRHdA3/X74/yf666BTYeEO6SA==
X-Received: by 2002:a05:600d:8312:b0:477:326c:b32f with SMTP id 5b1f17b1804b1-477326cb6ebmr10174905e9.11.1761904610282;
        Fri, 31 Oct 2025 02:56:50 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4772899fdfbsm81572335e9.4.2025.10.31.02.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 02:56:50 -0700 (PDT)
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
Subject: [PATCH 0/4] replace old wq(s), added WQ_PERCPU to alloc_workqueue
Date: Fri, 31 Oct 2025 10:56:39 +0100
Message-ID: <20251031095643.74246-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

=== Current situation: problems ===

Let's consider a nohz_full system with isolated CPUs: wq_unbound_cpumask is
set to the housekeeping CPUs, for !WQ_UNBOUND the local CPU is selected.

This leads to different scenarios if a work item is scheduled on an
isolated CPU where "delay" value is 0 or greater then 0:
        schedule_delayed_work(, 0);

This will be handled by __queue_work() that will queue the work item on the
current local (isolated) CPU, while:

        schedule_delayed_work(, 1);

Will move the timer on an housekeeping CPU, and schedule the work there.

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.

This lack of consistency cannot be addressed without refactoring the API.

=== Recent changes to the WQ API ===

The following, address the recent changes in the Workqueue API:

- commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
- commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

The old workqueues will be removed in a future release cycle.

=== Introduced Changes by this series ===

1) [P 1]  Replace uses of system_wq and system_unbound_wq

    system_unbound_wq is to be used when locality is not required.

    Because of that, system_unbound_wq has been replaced with
	system_dfl_wq, to make clear it should be used when locality
	is not required.

2) [P 2-3-4] WQ_PERCPU added to alloc_workqueue()

    This change adds a new WQ_PERCPU flag to explicitly request
    alloc_workqueue() to be per-cpu when WQ_UNBOUND has not been specified.

Thanks!


Marco Crivellari (4):
  scsi: replace use of system_unbound_wq with system_dfl_wq
  scsi: qla2xxx: WQ_PERCPU added to alloc_workqueue users
  scsi: scsi_dh_alua: WQ_PERCPU added to alloc_workqueue users
  scsi: scsi_transport_fc: WQ_PERCPU added to alloc_workqueue users

 drivers/scsi/device_handler/scsi_dh_alua.c | 2 +-
 drivers/scsi/qla2xxx/qla_os.c              | 4 ++--
 drivers/scsi/scsi_transport_fc.c           | 5 +++--
 drivers/scsi/scsi_transport_iscsi.c        | 2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

-- 
2.51.0

