Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02D131985D
	for <linux-scsi@vger.kernel.org>; Sun, 25 Jan 2026 12:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769343534; cv=none; b=H+W6anETje1DYCLdxiViQzABUQf4nTXGCYhr9vghv76J3MbV8aacKmYkYRKCo2r23oRE5m1ODZrWz5iXWcD/dpW9QJ5Eu+F3Jgjm1wUqnMo0+2mfmC7aaxyjGlkwEz1fPyhykk827nMi0p8/tkUxe1IYCCSIHn0U9IPRwjGPA9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769343534; c=relaxed/simple;
	bh=KQP4yBm9Z+zvXXpSXMSUzyw7caH5FYZUnnmnFyBIuYw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PoW3hlscOMBt9o3zNZrzeeS50nFzFLqkbmqQ4G6oIKx0gGeV4DZe2P/GZGmVDqY5V+wQre2huQjRzVfPs0ZtIo1bSIzAbK8sMIdyBYRlyuS8D9iFsQ4IdryPqhogUOy7ve++gWknbAUEVlekuOsget27Lcj5jyaLvbT2QbHeOOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CXKRt7TS; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CXKRt7TS"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-29f2676bb21so37714245ad.0
        for <linux-scsi@vger.kernel.org>; Sun, 25 Jan 2026 04:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769343531; x=1769948331; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oXfRamd6fsg72ILTJTgDUDn0ttsheLvgNZJiy7avqbw=;
        b=CXKRt7TSFsNMcJLKKsGgYo8Ug4h5yNvaO1sVwSovRPXb0PmmEVUIS4tuT8SNoU7X5R
         tiriKwecfWz1K2YHqLwO2z84f6Uonb4QjYd6mslg+YhFSpQKVfBKuuL4R88KWrMl1ne1
         JWcWaHHA4oi2hXMpWwIxg9gYAdvjbVxcv+czeaKcHZNVILGf9X7OlwSxkg3Z/v0fUXu9
         F2VHMJy5MkD8p89kx4f6DQXe+xnTLuqbSvLKButKyccwRZdZBtBUB0u8jjhr2ehVlnt6
         yWmni05g0ujlcECyd4fmUWXCatpTM6a6M1MupQutMQh07klwn2WJgPZlYwIwIVRu7mIq
         U1Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769343531; x=1769948331;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oXfRamd6fsg72ILTJTgDUDn0ttsheLvgNZJiy7avqbw=;
        b=ugZuj1Z+2C5RfTxrkgr0JIZX5qMk52+4J6VpoPBWlTdlTEu30epqHh7MfrCLbcb/uR
         x7c49GLCMSfdbjfGsSo/7a4J2cOHFUCf0+BbhXpS3D1RXb6u1PLFjWHkm6WGrv1uKcex
         cKuZbp/GlfkDtzHTH3n5bW1oOh9/CKZFQywJr0QH6zFFFOZiEj89ssmUzWr5LEz+TQHZ
         zGviK/PSLtQwqU6h8y8fGbLqoVC+S+jU9QrphcOf1LYrA9l1Was6Z2rp46Jhzxz9C03h
         Q2VI0IWaa1Pe/bIOjcjEDGi6UOqZRjEThg9iWWXfF554SwLxNEfwDgGS8eNmciZBhjrW
         tX+A==
X-Forwarded-Encrypted: i=1; AJvYcCWibIk0/sNj8SfqCTS7BuPwIg8g7ffw2OYQHDi2XepbmIvGNvxysv+ihcQNFsADn4C1NdCVCgadMwC3@vger.kernel.org
X-Gm-Message-State: AOJu0YwaqwNTXlHqRZsuV6AaUMeAq0BNeRZij2swUoPKnJ0ZVNIXvDhH
	tBT8X33gVS6n0C8DpPb8N/9vW33x+bKu4T61hQr9ZZymCTWc+tEZPzWq
X-Gm-Gg: AZuq6aIztZ89KYgKYt6owfZuYokFoRajIfP94IEJfnpEI/qpwkD03BEranWOkUVHBc0
	xBJllPctklLczsFTUMos4ys58sA1VLgaVDZr86Wn9EknqgFok0DzeJjo97QPC9R4QickCMkYBh2
	MylLtLUJQzNH0QJYtjs1ht1tA63sHaBQlrD7YRa7mnkC7Ol7sjOIic0fAwoDAoMAkXVfFYTMEvt
	THEtp4mvPt2bfrwj8SjlbdagNpIIObL0Y9c1VZafmGdaRBR7eFXShv3ETWa55x2XN3ZMgW9xwMJ
	Cr6bELj2bheZ6w2Htz1nlqPosDLMMDo7Q6T447AS+JWfcQkff0KkZuHU7YEb+FMsYbhIkAq5qv3
	HHmFEUgaTV4s2RhuLBHIzJ52DHT4KqYBqjtaxLqybPwS0h27lYzDhJOoHg6ttQy0j0rDXZpTYwN
	kJEPt5WalVSTWDoJmSt/Z76mj8AmuzCZkVLP9KeW5E
X-Received: by 2002:a17:903:fab:b0:297:e3c4:b2b0 with SMTP id d9443c01a7336-2a8453409a1mr10777035ad.54.1769343530990;
        Sun, 25 Jan 2026 04:18:50 -0800 (PST)
Received: from localhost.localdomain ([113.218.252.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802f974d8sm66774625ad.63.2026.01.25.04.18.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 25 Jan 2026 04:18:50 -0800 (PST)
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
Subject: [RFC 0/2] megaraid: fix illegal pointer dereference in complete_cmd_fusion
Date: Sun, 25 Jan 2026 20:18:40 +0800
Message-ID: <20260125121842.79839-1-pilgrimtao@gmail.com>
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

