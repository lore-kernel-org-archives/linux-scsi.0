Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E164D2D3732
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2025 15:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762527727; cv=none; b=d+g9X8EaeMhVwOreZeUcDMXhyR6dCZSThhZl5BLDcE67iMjnqZUx7GASau95NGkgdkEO0HhBFdRbKp7XfKE5RPLZBcp/o+M9HtvV5OuIFq7E9c6XkO+bieLRzkQVloTiyoqqIeUt9wWDAy+KdEXxTBSiCkKGgOJOBo16GIB5UDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762527727; c=relaxed/simple;
	bh=XC6uugmYTns1ck5ScAPME/ugmqQ79XugolqBUdQiaaA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Qgn8k+Qh6wWvtq1kF6ssi3vn0556NJtDjAahyCP8D5TXVgmDOpjBinuwJDMpKXK1CPejFIdt98YAdXaxhigYEEiq6v72q9Dvzas7bQAik91U+uLhYcryI+O3dd/PpgAo91EseJrDhdlm93LuJeOHVHFNluKw/rabqO2WS/Fgmtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MkZzb8ZV; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MkZzb8ZV"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3ece1102998so505909f8f.2
        for <linux-scsi@vger.kernel.org>; Fri, 07 Nov 2025 07:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762527723; x=1763132523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OBlq9mhdG4UQ7VoB/xIAxo028Yzo6gXak7ypBzFAJHE=;
        b=MkZzb8ZVrd0NvUaW4eKcCKi68gbhTZsLZ6viXxySLpBx9uTy2gSqYbO6bcq7A97bP7
         bWvsoCFkqhzB34ckd6j/GSwlchqvfNFoOyiKrEOBoEXNgR8CcwmEan/dbDnju9Uc6TUI
         vjyxDKrerlmCIw146ThUhG/d0vvYMfZ2SFp1IUZMlnOci8DTRwERIccg6jnqowZZI077
         pp/u4bZD8gplgfQ2S7QN7slKMNmNrvc9DbHmJyaEcxEOIO92sXOJkACbZ84kkOI2WRaM
         R8rC583Tb5uBT/jOiTjnBUExK0YjIxhGNdOx/jWslDmCL20xTfAVCKhNV19imXm4I7Cp
         nIAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762527723; x=1763132523;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OBlq9mhdG4UQ7VoB/xIAxo028Yzo6gXak7ypBzFAJHE=;
        b=cUy+ATSXXTdeN12o8PjY9Qz5uzmeBPGxiJ5dtCAQbD+rj4nY9Rcv/gWodVtZ/Fnw62
         jbhNKSVKAARKZn2HRr82t21m1+gKjsRbtF5baGbCRVjRTL/KWH7W2Zr5L9+5uQkFGCpM
         HwRHKzJe7jqG59f8WBwp8pM+q4eu6xclu8P5NT/DNS/+mvFMJMP1tBGfqgf2QYCasZEU
         VJ5TtAWAIxkbwOR14zXWh/Rp5eBF+YPIrsr6Ln36O5Kysdr47tGkMDZjKiE4gDapWoUI
         AD1caeObSHR2D+u4F6H4RtXfOFOpHnajiAg9+h+rCCULvYGRO99AA2nml74IS8gKRVC2
         BCWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXK3sFstDiillU6ztMeocwpGaVbbs7V4IATBIcbr+6zo3A1t8nkPF0y/yPc8F4oISxR1unEcLunRFVv@vger.kernel.org
X-Gm-Message-State: AOJu0YyiECrZJGxn70FERDNGgr5G4ZySsoTTmhT1l8U9NvehYDNFpPbd
	JfbOTF0EWlc27zfmU6e7cnSwjvhQ9oXXs0Zuan/KRBtXWTZ+0APWysjFWbEMQXxotl0=
X-Gm-Gg: ASbGnctTjqhJXCkr4krsqV1VNZqY90gHljtsHJI1t0FNVKT2m4ITGwkdPn+YDLlB15d
	LC66M48+8h7Z/SUr0+Z/uUc2NZEWIdyJXM8yJi76sTysoMPfdBN6kXfuBkJy+j+SjvBtj5At6F3
	MlnfUMNcWY0EeYRGOrEE90Hftw1g9pDt8yMZ2QDbMYvwOTeA5NYto+GOQ11VovnIACmB45cPD7l
	iF3KII4A39GOrAAue1RlpZ5FIVPwAX3CiHJxF65O+fYxEoA/4H7lvhPToQUoKhIKz5kWVd0Blhh
	6WVOoSw5Gs+ItR9P1Y30YXahIscskUPr7RKsSbv511t4gH7jUXxsGTB8Fbxp3mgbY3u6uU0sEyi
	B+YgzKk8ibAkWRpd0clXwYqTw6X5NxGaU/N+eXMIW3sI0ZwBWIOwkU1DzfOuDcDsoTu/R64qlvB
	aFfpaLh5kBPPZxvI1pycoX3TL2
X-Google-Smtp-Source: AGHT+IEsAcAscbIMilLctf7rraQtAqjW9Tpt19dMghRK/QZBTtQ+e3byaR0eTc6m7h4AOrfKPxDz+A==
X-Received: by 2002:a05:6000:1449:b0:429:d6dc:ae0f with SMTP id ffacd0b85a97d-42ae5adf3bcmr2632448f8f.49.1762527722837;
        Fri, 07 Nov 2025 07:02:02 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675ca52sm5777830f8f.25.2025.11.07.07.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 07:02:02 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 0/2] add WQ_PERCPU to alloc_workqueue
Date: Fri,  7 Nov 2025 16:01:53 +0100
Message-ID: <20251107150155.267651-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.1
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

1) [P 1-2] WQ_PERCPU added to alloc_workqueue()

    This adds a new WQ_PERCPU flag to explicitly request alloc_workqueue()
    to be per-cpu when WQ_UNBOUND has not been specified.

Thanks!

Marco Crivellari (2):
  scsi: bnx2fc: add WQ_PERCPU to alloc_workqueue users
  scsi: qedf: add WQ_PERCPU to alloc_workqueue users

 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |  2 +-
 drivers/scsi/qedf/qedf_main.c     | 15 ++++++++++-----
 2 files changed, 11 insertions(+), 6 deletions(-)

-- 
2.51.1

