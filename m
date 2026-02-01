Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB68725D208
	for <linux-scsi@vger.kernel.org>; Sun,  1 Feb 2026 03:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769916680; cv=none; b=OnPsbazGUce6Xq35twf0Oj7baI0YQFwvblB5//p6AQNq6oDqTuOhcVZ33ZVVvuGhMswPqGSYP5xdRQa+bkiAQOMYLi/QJ1LYwHyWXqPt33hjc5ABDtb/5mhttL9sW6NPZ9pTMLs0lqwkX5RZ1/mVmH+QyAGtwoCaj/Tg0KJVSg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769916680; c=relaxed/simple;
	bh=KQP4yBm9Z+zvXXpSXMSUzyw7caH5FYZUnnmnFyBIuYw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=juQM6MRLll477PLHZgJ+5os7TE+qbir7WhdOfRbrt7KGIkIiniQDJ+qPVoiTKbbof06K1hvR1ZFF2iPLn2V178H1CCbpSxNLPc1iFraRl/XME1ML1qJZ/4UXYvLxD4ebjaJiiOQaQXM2yW8rV4o54Tbd2yjpmjjNOJ7zOHhdySY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UyJptweU; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UyJptweU"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-81f4f4d4822so1701967b3a.3
        for <linux-scsi@vger.kernel.org>; Sat, 31 Jan 2026 19:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769916678; x=1770521478; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oXfRamd6fsg72ILTJTgDUDn0ttsheLvgNZJiy7avqbw=;
        b=UyJptweU9dIUjpnRONtwqG7LAL7gNCDrjaqSJLG1/4qIhzOJHxqBIuzE85xqrtEDYV
         5KNnc8PCkF6RO/KKJGb6AFna0PTeI5a9TrmTod+A2s0graiyxwhw27uyQE+LU8EDQM1s
         CmMEO6G8Emt8jslZ6wi9lnCvS2zxOlU/i2YIv9NbQC2TBZhjm1kecfT7O0SHMDnddqkV
         IFlSVmBS47wXFTZURigzgqhn1i08/hkQqE7P4XO4KBE205T+mR6K3cVgVlIXCqktKZK5
         yuuERWPZCz6PQZr6nuWYHSmPP8qxwR978i3NiXeQtLtnq5gQwcDGzfRWVU0kJBkJ6y6l
         AxAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769916678; x=1770521478;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oXfRamd6fsg72ILTJTgDUDn0ttsheLvgNZJiy7avqbw=;
        b=cAE8CJbitoW/bXwUEnbMLYBAEzQ6ltSg7c9u6AI1rOECXm+2qT5odySyNsdPBEKUi6
         gGUIQsqQ/pWo/cMmbZLVCC1SKFfQeKiSmgCP45I6slxMl6/aWZt4GrXusKBFE6+N5tB8
         uR2Ri7b7SdaDaozsRJ3iLHzMgzJ4KRmwY0u9dnaEQtitG26lB2WRQ5plEqPcK6k660WS
         1AriadrljI7JmzeqGOwkIOsNMn4pebYA6qr90tAUQegmQApUQajLq8SP8ewF2rMLer4n
         hlkOCFRGVNWbGJL38grRzCTXdH57huGQsRInVa0q4uyOJVF06NDlaG6RTUGPm2hFaF1c
         9pJA==
X-Forwarded-Encrypted: i=1; AJvYcCVQyk77eJ7NDqppzK91ZwFwYk3D9K5ttiL7OW1XjeiZpfsuNYpiv1Q8UPHoYKRcC3lqKXWb3EuFJ3Xy@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+mP3bLw8nkK3/vu4Ks2GRe2p2tX4xX0/wfagEqMGuuiR5aiP+
	cxMYRyavDkrEliTUNIujp58pjAoB5kPy6cP/ZH1EQTADq7osFhWz2c8T
X-Gm-Gg: AZuq6aIuV5zKdXKfImvGEo/u8+UlEZFo8KWh3Y8EDnszPF/C1olAZT8L3a0B/ERXQR9
	eq27NdURLAaHpXp4ZcNvyinbnqpg/os4eSbZGHglRwlhvB0sO9FnnfiTZ1PmlpykIeog3quS2he
	mK15I0voY4o9LoAzDlOvONVbbral+Dv4VNv+GrgfCnrq8d6nfspOW+basRUWy18efEtR9yLCmG7
	nUIRvYgrnMF/hXhnkTQ52cK3UI29//0geDNJQdBwKS1FUtgb+cMKZcG2/WLA7aJZETXOYYy0CFQ
	7IXthyVjBANpBfVP0jmyEj30tjOaGjfHQGhbuOVQlMzDWqgQSDe5udKfWGx0QG9/w4e23dyRrFt
	/s6x1RGENwWMJrC4+1iGjqtp8s1wpXKCNdGICfaOU1bgh4xChhWvCLwrOD+jwMrl43fqUsmoMF6
	hG39iZkqfHsI51FZXhxW5iuXfuANPtJgWUT+uc3jXu0w==
X-Received: by 2002:a05:6a00:3989:b0:81f:3eda:9d69 with SMTP id d2e1a72fcca58-823aa6ac899mr7855224b3a.22.1769916678183;
        Sat, 31 Jan 2026 19:31:18 -0800 (PST)
Received: from localhost.localdomain ([113.218.252.120])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379b6b2bdsm11831817b3a.30.2026.01.31.19.31.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 31 Jan 2026 19:31:16 -0800 (PST)
From: chengkaitao <pilgrimtao@gmail.com>
To: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chengkaitao <chengkaitao@kylinos.cn>
Subject: [RFC RESEND 0/2] megaraid: fix illegal pointer dereference in complete_cmd_fusion
Date: Sun,  1 Feb 2026 11:31:08 +0800
Message-ID: <20260201033110.34297-1-pilgrimtao@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chengkaitao <chengkaitao@kylinos.cn>

We have encountered several instances of null pointer dereferences
in the complete_cmd_fusion function. The root cause was consistently
the reply_desc->SMID being erroneously set to 0xffff, resulting in
an invalid cmd_fusion pointer retrieval.

After code review, I suspect synchronization issues in complete_cmd-
_fusion. However, due to the low reproducibility rate of this problem,
I could not perform effective validation. I propose the patch for
kernel community discussion to explore better solutions.

Chengkaitao (2):
  megaraid: Fix the issue of erroneous reset of Words in reply_desc
  megaraid: replacing fusion->busy_mq_poll[*] with irq_context->in_used
    in megasas_blk_mq_poll

 drivers/scsi/megaraid/megaraid_sas_fusion.c | 18 ++++++++++--------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  2 --
 2 files changed, 10 insertions(+), 10 deletions(-)

-- 
2.50.1 (Apple Git-155)

