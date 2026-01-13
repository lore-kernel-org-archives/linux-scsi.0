Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06AA2D738F
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 14:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768316244; cv=none; b=OHM898yupMd3b/WXHIMChe9Vobo36kM71+WeDhOuT/6rm8ZHbBVww4VUM/xvSGWDaKFAYyZW9UokdPM+s7KRY1R7o7q0aBP2wJViwd3axPFdFeWyLMkjaaDY0r1K8opKrwH8mw6rY+0UxVyIvnY3tS9pOSTY4JUZzpb8Roy3Ovg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768316244; c=relaxed/simple;
	bh=ij+ppg2mm/pfutEHWsg53F+pwthk7twNCTiwkL2gDSc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZNf3vI78/IrUvBANI7lF1ISc0HSMgmLX2RxOdSJ50NQa261cXVq/sUwKi3ZrjMcbiyiXypp/1jDFBa424yQoNpcKN7PG2VEDg/F5W5GMsno2D1gmIN7BUoWi9VxXjJzTX6qiCEm4iNO+bzL6AyDpbm+3zGz7LRDB1J4rCx2kLXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=F64DlZmH; arc=none smtp.client-ip=209.85.128.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="F64DlZmH"
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-47edd6111b4so5282275e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 06:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768316240; x=1768921040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5ttQLtQcwVZvUKwDumSGF4Pkp5UAkEp5jFrbAxTiU0Y=;
        b=F64DlZmH5Z950YlZRDL/75YOzpgk4TZQGC2Fu9tyb1pWhB6eL/Ole4ZTxmuDBPbzrv
         3I8YiJRuZTXoPA8m8yXcbmmHyboya8v3io0KV3+8Z6E9AM2QqgTNzOc0IDurxRaJm77V
         gjKX4RPJwKOl3WCfMSsOxk/scE/bNCcp0SEN5jmxHvCda35AGVCpFHPBKHaW6uEkhH2m
         Afjs0vh/cmH3yg3EuBFt9mUW5zMzSBPfUP2EYDuMupE+FIniFQMG62lIyX6mU8N1QWRn
         PysXdULIA2Rs0LzZcmJEpmT3KgdLwtoyO/55pez314Q/XhDlpcTabwKYYkWJP8IxY9Fd
         ixkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768316240; x=1768921040;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5ttQLtQcwVZvUKwDumSGF4Pkp5UAkEp5jFrbAxTiU0Y=;
        b=oo/LrA7GN0PYI6u2HVcLaZbqA8BKsRIF/z/X/GJ5aarEgS3KYFLfRZbHIivb6M54SM
         zF008dImXDco9pS4U1lnZ45VsQl76NSd6L04Z/flSh6P3imUd3y3JZ2N1whaYM67FsdZ
         U6x+gcHCvoP0OStFqnCsVkNJ0UIO3edEpX+uq8SRh6A8CVoz57MtQgrdZOVL1lHbfzZq
         WI2bjvnedwahf69wDPRoCNcFmJRlS4sICOE3t87aHGN9JuiBn6BvLGbSCONTddUjo8V0
         872c/pCpsmisMN0plm8vaVO6kD8jU6hk/1v7HubZPjZSBSHDHHYQY9EBBLMDHf6gK4hp
         Uldw==
X-Forwarded-Encrypted: i=1; AJvYcCUPbZ/m9vREbs4Xdpnjria72x+sVdxXYwgl2nFxOHJuiQptDYEUmrVKRJ4MzF6fgEALpUDBeHJ95W0H@vger.kernel.org
X-Gm-Message-State: AOJu0YwODq0wTnA3O0d7aF70MpfwxaLnSsHvD+JjMa7YTRuZ9UpOot01
	R1lIepQh6LNzt6VC6Qn9OdLVhW6P0T+cdftTWUYRHKlm9RwasK2kp1g/s08hU6gUAuz5HEHcl5A
	vEkt/
X-Gm-Gg: AY/fxX4SOhYMlNIMJtJE8R9B6981bOySiHTVj16EIB/ru9eT8025NPlGpkLqIet86Vc
	Wi2Qjer1dl5JKHbz2RcYT0t7rPgAQSE2YGsYCZgJ7APXzo4ksFsRYntnT/zJfwgEYjy0zC90Tnq
	6o92biMyHF55GFG/BQROHBHcEOAsxfgA0jEkhesvYgQddBJ2YbzQW0BkabvhB3XA8ExRmU1HK3Y
	urouoEjD3XUvKsfsKU/NZEvVb/0y4S5j61VAEHaw6P9bI4FhaCRZv6hjbL0fUslK9uzhGspxJPQ
	nD6bk+M9DzSBCMFZvBaGnAmvt5zIwiEWMNJRwebBjG6j+4MsKTRSqF8PXm7vxfByXA9R7aPjIz5
	9bhEd7/tSYcfqK+gO+MPEsPJFxyugDpYUvgiT/7OLY2YN9O2htJvwTmK/3ajRMJ5Fcfv6HOs5HZ
	GWFzYBqcP+dAujUz+oeyfvGc/fPX/Pn93MEOE=
X-Google-Smtp-Source: AGHT+IEbgaKDpYuL+i9nNIko/G0+sz3mNth+avy8K8Ojs2Ml5q8MT/djbnI/ZVp+lLFyW3onG7QZSQ==
X-Received: by 2002:a05:600c:4747:b0:47b:da85:b9ef with SMTP id 5b1f17b1804b1-47d84b18a7dmr309322825e9.16.1768316240137;
        Tue, 13 Jan 2026 06:57:20 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ecf6a5466sm128498565e9.11.2026.01.13.06.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 06:57:19 -0800 (PST)
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
Subject: [PATCH 0/3] Add WQ_PERCPU to alloc_workqueue() users
Date: Tue, 13 Jan 2026 15:57:08 +0100
Message-ID: <20260113145711.242316-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This series continues the effort to refactor the Workqueue API.
No behavior changes are introduced by this series.

=== Recent changes to the WQ API ===

The following, address the recent changes in the Workqueue API:

- commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
- commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

The old workqueues will be removed in a future release cycle and
unbound will become the implicit default.

=== Introduced Changes by this series ===

1) [P 1-2-3] add WQ_PERCPU to  alloc_workqueue() users

    With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
    any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
    must now use WQ_PERCPU.

    WQ_UNBOUND will be removed in future.


For more information:
    https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/


Thanks!

Marco Crivellari (3):
  scsi: qla4xxx: add WQ_PERCPU to alloc_workqueue users
  scsi: qla2xxx: add WQ_PERCPU to alloc_workqueue users
  scsi: qla2xxx: target: add WQ_PERCPU to alloc_workqueue users

 drivers/scsi/qla2xxx/qla_target.c  | 2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2 +-
 drivers/scsi/qla4xxx/ql4_os.c      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.52.0

