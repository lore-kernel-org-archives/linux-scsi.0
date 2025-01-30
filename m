Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDAF199223
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 22:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738276002; cv=none; b=PWYKagu0JmgJngzaqkOuTqSKIb/6b1L3koE8GXUo8HjQTqrrMAbTwlCN54v9JGWo/Qf8qEayOXthlsPvx5qOP1bH+sZTKpp8damet/vDT1viSGTwEMhCtnYyEGhk/YTr60kM4eiP/25h3H8AAXer+SGUwcBWyBYt6yCzQnwnufc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738276002; c=relaxed/simple;
	bh=/IKT+yepxHpw3FUdTOo0EZ0qxAvIfIXVH6sHUFA2SA0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=UxWK9IYdChV9aNW8q04GjMAAfagCXwH1H5jkAosZSkA0ra4sDpabRxNWS7QOUH5eWwIiradgQ9mCbRwBotCW1CJtZ4bMGA5EgPAR+tGQFkW4ZIOC5gBA/d7pmssM2E0bKYmB8KCDIM8I8iLXLiL1B4rGKhDge7SKIMTRxZVoh8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k+q892sx; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k+q892sx"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee9f66cb12so2609303a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 14:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738276000; x=1738880800; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7Vn5xvnNabtpVvJcGhVJ5cQ/Nehi1UgqdDUDznPExT0=;
        b=k+q892sx8u5uy6qmyoYZaoqQPDlGFPkSYW+hRIqToj3CQ4RGn0p89XUvV2uFLk9PBi
         /2ifhCpJI25D3olVIWP4DyRYKT72mmXWJ0EKr3D+TZ11OzTSgACg7YHHC/ompMTbwqKX
         /NcRSIlfW4itk6FVpi4w2r69podA5vgML3RHW0HH+zkNDpNhjjQDDzj39VOQqnW5SVjN
         8nEJg/M5vkZC2/+8jbpek2XtRORLA8xVi6T4+77uk4FYLKo/CPjg+agkh0cb5ZULHNb2
         3ekFVhVxPiJUnRpLGZPidkz5q6Yh0qygPDnM3IAe8F11okHEhbpWZ1ev7znbfYmyJXnO
         ziwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738276000; x=1738880800;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7Vn5xvnNabtpVvJcGhVJ5cQ/Nehi1UgqdDUDznPExT0=;
        b=OUa54RNymi0L976ihuPnljcbF3RfFVY8Eh1HFMzDoI3mQ8nBxbDkkKTl/k04+18uXK
         gmVkEEYYIiPqTFiwyHWQsiK4W5pA0qNfkssFgNV6aOgmq9zXnHEExTg9JjzFDjfwFRj2
         N0ScoSwTwK9gQH7beaMhD5OM2h4yE5oOaqUrux5YmujM5+CeNHFsXtOTBthTWNXKWOSy
         dPMt5psw6yZM012uaXRKk/cS7jIx71OWUHEzBuuLB+yFm+VkqAcQ3A3PXu4ugMSgbfsD
         I9itZxJ2kIzuMvX1dqLyBfWyCbaStyRgYG0ZVqdAdxLcx45BceV9eYKq1rC3md3TBJAZ
         cq+A==
X-Forwarded-Encrypted: i=1; AJvYcCWT9GKpSAJrdxx1mluRdD6s/e632vp78SW4EtAArcq5oF0P6vJcGgVGyyFd1bNm7J9sz4JzjYYjA59+@vger.kernel.org
X-Gm-Message-State: AOJu0YznlVtSa3uUN2lhB5PJ8TZyXOUc3bvkhbmhiuWdOqesiJlKEXOA
	RaCqAEmZe5Vjv5Y6nGYp85eyBcN7KXNX5hOPtc3wCKBihSW9lBuEd3oOryU0KLl0dQ1/cEPUtkW
	TucR6imvwkg==
X-Google-Smtp-Source: AGHT+IEhIfk3j2i6VmvDwKe28X9qilZk698oRuesLeDpuFZFzUV6xO38uLPNkF2hD6iHeXD6hJTcANO0VJ3OmQ==
X-Received: from pfxa32.prod.google.com ([2002:a05:6a00:1d20:b0:72d:261f:af23])
 (user=ipylypiv job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1396:b0:72d:710d:611c with SMTP id d2e1a72fcca58-72fd0c7c142mr10819644b3a.20.1738275999973;
 Thu, 30 Jan 2025 14:26:39 -0800 (PST)
Date: Thu, 30 Jan 2025 14:26:31 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250130222632.1462218-1-ipylypiv@google.com>
Subject: [PATCH] scsi: core: Do not retry I/Os during depopulation
From: Igor Pylypiv <ipylypiv@google.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"

Fail I/Os instead of retry to prevent user space processes from being
blocked on the I/O completion for several minutes.

Retrying I/Os during "depopulation in progress" or "depopulation restore
in progress" results in a continuous retry loop until the depopulation
completes or until the I/O retry loop is aborted due to a timeout by
the scsi_cmd_runtime_exceeced().

Depopulation is slow and can take 24+ hours to complete on 20+ TB HDDs.
Most I/Os in the depopulation retry loop end up taking several minutes
before returning the failure to user space.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/scsi_lib.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e7ea1f04164a..3ab4c958da45 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -872,13 +872,18 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 				case 0x1a: /* start stop unit in progress */
 				case 0x1b: /* sanitize in progress */
 				case 0x1d: /* configuration in progress */
-				case 0x24: /* depopulation in progress */
-				case 0x25: /* depopulation restore in progress */
 					action = ACTION_DELAYED_RETRY;
 					break;
 				case 0x0a: /* ALUA state transition */
 					action = ACTION_DELAYED_REPREP;
 					break;
+				/*
+				 * Depopulation might take many hours,
+				 * thus it is not worthwhile to retry.
+				 */
+				case 0x24: /* depopulation in progress */
+				case 0x25: /* depopulation restore in progress */
+					fallthrough;
 				default:
 					action = ACTION_FAIL;
 					break;
-- 
2.48.1.362.g079036d154-goog

