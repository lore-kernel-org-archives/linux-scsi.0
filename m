Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A60925A35E
	for <linux-scsi@vger.kernel.org>; Tue, 21 Oct 2025 02:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761012507; cv=none; b=d5DrWONdpINrBCtn7DQHaSijQFg/5CsXbpIxPU5DJL+Py6SM5Y0vynu/cpkvu3zbfe7b4dmi8zm8cof9pyOVy0TnBtuJzzwQYTck/XkWIAw/+90fVEIdHPCDgzoXhl+bc61Ci9/xr3EYigdLfJAWZZIQhfodkPVpQOPEaFZKA40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761012507; c=relaxed/simple;
	bh=lMDSCfXDFAAsG+lJ4/PlhyxArZIcaelWaaU9/c3MB38=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gJ9mDiDBS9dgHv0AvnXs7tAWpu44buYgwc1B1peZVqQIC13PDSd/pNrykwNw6C1zTcfjhG/mefAcS8/84QrM3qNhu6A4Q/Kt4v6/VlgqjyWU/tPARYXI3shzkjMuFYTzTpHXhxMd312+oy4A7LqyP1jkkFX3RP0c5dbzwfmWbCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gtX9FdGO; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gtX9FdGO"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-940e06b4184so112771139f.1
        for <linux-scsi@vger.kernel.org>; Mon, 20 Oct 2025 19:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761012505; x=1761617305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SOPZINqJ1ZYn4I38TToVeVJycFqUKIHAHcONMbNzpkE=;
        b=gtX9FdGOS19dGYoNZoNHibe9hbAxWl9rAFyhotY/7l1eKeWZyyIc42LUzOmtNwef2J
         jGeQVmiHKjaboCdJGfmv12VM8sodRZvKLwWpMSTQiUpwHp7ICWK7+2Up06ummDt2+ppB
         rsjhhUYIgrLpeFxnV3bBGzYXnS+ZDUghFRsPhuhu9YewrwMuiwtN7v4DNuuAu0SJqkgw
         JYsigoxmJl5BumP+QiSwu4DPIPrZFk2T5OgL/2MvPPZCBp4O0elnQgXvSmMhAhPx1HSk
         kRsXEcyfq9rc44xdKjmgdBPFEMkyVlD3E9oNU/mBMg1adOmScNaGWzXlbnm8BHXhT2Cj
         4QkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761012505; x=1761617305;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SOPZINqJ1ZYn4I38TToVeVJycFqUKIHAHcONMbNzpkE=;
        b=r8xUIE9i1ZhIJfckFA/rlNj3fLNZK4rcMUTGuGqcZIOdnc9euJILFkj9bbRKhUgNwG
         wpPnMbVqFSek3f0cM49UX1CMsXJGo4JtJIpB7xqGeMkrLmIda6lk5MR92Cv29vG6m9wl
         LBB4naR53z2NlDX+Sw1MJW7CcvoelZObAIqFwcJzFpLs1qdTN4VUUjtDjfM2iiXItUWc
         3ntMXD1bl93nxMEMoAOIIwMyTHMgs8XJhjWaV4Il/g2ELi5H4e4+hhOHpL2ebx+TzLWX
         iI+ACfY33JeWtvu3ftvUdYATjBmfGD/FyzkEti5HrkMbEvyWCORmNBCxc6cYaoOb/8hS
         ecOw==
X-Gm-Message-State: AOJu0YwMhM6ZOmUQJDyXzJgAvL9Jh2qJ+gF52ID/Yqrm9MTEYrp2athL
	xqEQGATkkf3cyDwrwaAzEE4WuB4l0baN7ld7r6lsCB+VeJdMnQSaf7dHiJXCNjn0GM0=
X-Gm-Gg: ASbGncu2R1nDJySxt4em0tYiutY5BipnwDzkN1nbNzPteZ4zlkr2QsTbXoB3G+rt+KO
	GnlURCjkuJQpLmh+k0o5x8Ggd5NUN9R/DIgBL6tTs6/br2U+f3APMaTAmrk+jo4cxUFXZg+SouD
	PrtJknh498pQDHWkPd4nYjvg1zaxj48O40T8Erx0L1XvUYsuaRkNQEw7sMX6AqxSmsNJLh7Suf7
	YSWOS/5CSP7LzAMGaYp9mkFXTxia/+mo/S2gls2VS6onE+QCYKslCi0YRnpTIe4GMFi8UMXX2cV
	PnI6pQpkyAi3udzO7MEfVqKMYWPahuNtetEqYT0iavHQ/ThwwvhCikCzh07MQC+4EoV3xfxX6Wz
	IoHKAkatxMlyIRFx6rGamj4iyFVygyef+k5ThlquU5/uPElBcNjW3h6u9ZjyTEM0iwnLdnFQ+7J
	31jPtmWYQz/oY2QjoqK0tmiQWe42IKP4wJPf0RfJjwJDQvELctnfbc/qQCLd9CTuc/KLn3QnR8g
	4fg
X-Google-Smtp-Source: AGHT+IHxMaRrHMYn6K2NMgEXSDVxYWRsu+Ax0RcX2EKq6KdEsQ4xITeLkd7KXFChEkdLb65yRzCBzw==
X-Received: by 2002:a05:6e02:148a:b0:430:a013:b523 with SMTP id e9e14a558f8ab-430c52aa249mr247916055ab.25.1761012505291;
        Mon, 20 Oct 2025 19:08:25 -0700 (PDT)
Received: from abc-virtual-machine.localdomain (c-76-150-86-52.hsd1.il.comcast.net. [76.150.86.52])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a97699f4sm3556852173.51.2025.10.20.19.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 19:08:24 -0700 (PDT)
From: Yuhao Jiang <danisjiang@gmail.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuhao Jiang <danisjiang@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: wd33c93: fix buffer overflow in SCSI message-in handling
Date: Mon, 20 Oct 2025 21:08:04 -0500
Message-Id: <20251021020804.3248930-1-danisjiang@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A buffer overflow vulnerability exists in the wd33c93 SCSI driver's
message handling where missing bounds checking allows a malicious
SCSI device to overflow the incoming_msg[] buffer and corrupt kernel
memory.

The issue occurs because:
- incoming_msg[] is a fixed 8-byte buffer (line 235 in wd33c93.h)
- wd33c93_intr() writes to incoming_msg[incoming_ptr] without
  validating incoming_ptr is within bounds (line 935)
- For EXTENDED_MESSAGE, incoming_ptr increments based on the device-
  supplied length field (line 1085) with no maximum check
- The validation at line 1001 only checks if the message is complete,
  not if it exceeds buffer size

This allows an attacker controlling a SCSI device to craft an extended
message with length field 0xFF, causing the driver to write 256 bytes
into an 8-byte buffer. This can corrupt adjacent fields in the
WD33C93_hostdata structure including function pointers, potentially
leading to arbitrary code execution.

Add bounds checking in the MESSAGE_IN handler to ensure incoming_ptr
does not exceed buffer capacity before writing. Reject oversized
messages per SCSI protocol by sending MESSAGE_REJECT.

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Yuhao Jiang <danisjiang@gmail.com>
---
 drivers/scsi/wd33c93.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index dd1fef9226f2..2d50a0a01726 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -932,6 +932,19 @@ wd33c93_intr(struct Scsi_Host *instance)
 		sr = read_wd33c93(regs, WD_SCSI_STATUS);	/* clear interrupt */
 		udelay(7);
 
+		/* Prevent buffer overflow from malicious extended messages */
+		if (hostdata->incoming_ptr >= sizeof(hostdata->incoming_msg)) {
+			printk("wd33c93: Incoming message too long, rejecting\n");
+			hostdata->incoming_ptr = 0;
+			write_wd33c93_cmd(regs, WD_CMD_ASSERT_ATN);
+			hostdata->outgoing_msg[0] = MESSAGE_REJECT;
+			hostdata->outgoing_len = 1;
+			write_wd33c93_cmd(regs, WD_CMD_NEGATE_ACK);
+			hostdata->state = S_CONNECTED;
+			spin_unlock_irqrestore(&hostdata->lock, flags);
+			break;
+		}
+
 		hostdata->incoming_msg[hostdata->incoming_ptr] = msg;
 		if (hostdata->incoming_msg[0] == EXTENDED_MESSAGE)
 			msg = EXTENDED_MESSAGE;
-- 
2.34.1

