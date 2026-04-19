Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B8B1AAE17
	for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2026 21:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776632734; cv=none; b=Ot3uIt1RfeS9sOIwxx2gJcnBNlNhsmHVhiTCGrk38HvTQz2lulCSEd1g0hBmpJ6lpWPxbiNo1Chw4k6esqB1VpwEFHf633770Xo1fcaXG8mJddnI19PAfgO2z/aft/WnynU6K8N7Idb2+4YfhqfbQaRpY0w8LgBthHQoqrtcSi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776632734; c=relaxed/simple;
	bh=wpXCRNBaCxqKlOaaC0MIsoVehwLDCC4R+YLVI5RpqWw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=puoZr6EiIAi5FIrLu/tB2biYzQRk+AvOCmn6dD424ANxeGHNIq03I9doB58ARwecghK6V3Uuuljlgpu+gTGsgBkJBU3osUPxq3Wnd7jhWMGhujL/urFqVif1TfB3w4wGArbmcd2P+5a5AkN+OxoU25QVFKsjhcJKZ5vWyZqao9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DrIG/H/G; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DrIG/H/G"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8d76492e51bso254102885a.0
        for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2026 14:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776632732; x=1777237532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JRbHwsbH2iz6+exYEiBRKjwyQU+quSGYfC3YY6YHYIU=;
        b=DrIG/H/Gf9exwcKC/67qtwxLm5CDGBdI86gmZcHSpSasWFttuODzuLN9+ydzg8LMwT
         z1uCA3MVHPs4EMEeFTAaUyMYkzXUhEtJU7aL/CfUk7Gn3AZZ+L8GIwvaPWoWmDPq26q5
         P4tpizM8KuHGfJiWyh0XzW6c+7df1xOHtd92slBKdWFLgoz256sdbyUdqnmN2j6WSeAx
         xczxM1C8FoVljurYQCn6XLGRRfCSsSfVDQj14BlX5iQDxpbdjS0xYkHsZUAaSy1d2sPt
         PHx8MTmAE4DrJCDHM8M3cbvCwHOfXfodVOsA9+0hkYD/uDeI4oxx02WyXRNTAK0rt4yp
         vjFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776632732; x=1777237532;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JRbHwsbH2iz6+exYEiBRKjwyQU+quSGYfC3YY6YHYIU=;
        b=rVVoLjHFl5juO4JOAhhHq2fLNkS1drvYSS4YYCm1B8865a97bPTcrxL+029cFxitMR
         ORqoofQdnXdEph8lmpSGB8PIxXXgt9gFC/jgRUyzL2ht78Cm8ZlxxQCdiyAe4hgq7wbR
         PEEQw4rVYEpPXx8wocDUpKYOE2z3DV1pbhgUfx9daH8B74Zc5j1b5EXmAQCJDPqRCtaL
         /S8yoF5tmjF6zPm2xkF4Eymzdd00NvEQtJ2f17f8otzmx3dGmA5y2GUsqn2+JXLZ8dKn
         pOSkWGNccq/U6ncTljw67S46GjbcHFF1ttIUat7E/k4q6WIvNHx+diJMdE8aikRP59DV
         /Ljw==
X-Forwarded-Encrypted: i=1; AFNElJ/wqKz2xfC2nAJ9+sJIpckC/sLwWiPw3+4SU/kQK4PWZvvkGgjnT3ce29Q7a1T37kcIkmj6S6i5w8T7@vger.kernel.org
X-Gm-Message-State: AOJu0YygiSC+p1jbytywKc7OwCu2Rhnu6Z6/IiuwhIDdbK4oVwGiUgzM
	pIugkK5rFvW5JaXZ0gcWYbeC22iz/VQcIjJ780jeUMDRPXJpH5LIFvPd
X-Gm-Gg: AeBDieuUMrrfBWo/43+fWa+NaBqrZ8+uuRcgKQdz1OfDwuIs9EFIrBpZrMTr5THHtCs
	n+uDBvkQM5mbRX9vtDDi74+tHzLePxS5LNwkujTZFhyv6saF1V6NclXjbYy+jIuccnw3R5RZsG1
	NyYH4wpNnY1erJ+E3GWQxce6ti8N1ddMe8xKmr3FPNnMFQj1+OSyZKRtB3LaLyLElLzyGVtU3Ht
	a/DxI25A+DkL9gaK+F2i+epQq3KujV2ohoHOe5JYVZxEKxRVzH095et3ACGJWMSMQRF2YqJdK76
	sOk2fXHH1uYHX78TseTg5SqGtrU0eRB2B4JuIi/bot0WsPvbnc86tSuy4v7rT4ldIltGRM8739v
	QwGQXqGosRcAqqAsh6jqG4Bil1X4c/ynHaG+rpFRCiYqsZuL9oYBTdQxL+roNd5/jQcLrxlqlPA
	A5BknGlaE6q98tHWXXdcfgLTygocnMVmRwQ5h4n7TKZEwIYnCytVsSJ0YgmksVaoZ1gN/C0UTUl
	FPHqwMERC/HrEf4ocwptzhbdNgzD6c=
X-Received: by 2002:a05:620a:7102:b0:8c6:a2f2:d874 with SMTP id af79cd13be357-8e791b9339cmr1542906585a.39.1776632732250;
        Sun, 19 Apr 2026 14:05:32 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8eb9becc72dsm7372385a.34.2026.04.19.14.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 14:05:31 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] scsi: isci: fix use-after-free in device removal path
Date: Sun, 19 Apr 2026 17:04:20 -0400
Message-ID: <20260419210420.2134639-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ISCI completion tasklet is initialized in isci_host_alloc()
(drivers/scsi/isci/init.c:496) and scheduled from both MSI-X and
legacy interrupt handlers (drivers/scsi/isci/host.c:223,613).

isci_host_deinit() stops the controller and waits for stop
completion, but it never kills completion_tasklet before teardown
continues. A top-of-function tasklet_kill() is not sufficient here:
interrupts are only disabled when isci_host_stop_complete() runs, so
until wait_for_stop() returns the IRQ handlers can still requeue the
tasklet. The tasklet callback also re-enables interrupts after
draining completions, so killing the tasklet before the source is
quiesced leaves the same race open.

Once wait_for_stop() returns, no further IRQ-driven scheduling can
occur. Kill completion_tasklet there so teardown cannot race a queued
tasklet running on a dead ihost. On remove or unload, the stale
callback can otherwise dereference ihost and touch ihost->smu_registers
after the host lifetime ends.

A UML + KASAN analogue reproduced the failure class both with no
tasklet_kill() and with tasklet_kill() placed before source quiesce,
and stayed clean once the kill happened after quiescing the scheduling
source.

This mirrors commit f6ab594672d4 ("scsi: aic94xx: fix use-after-free
in device removal path"), but ISCI needs the kill after
wait_for_stop().

Fixes: 6f231dda6808 ("isci: Intel(R) C600 Series Chipset Storage Control Unit Driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Assisted-by: Codex:gpt-5-4
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 drivers/scsi/isci/host.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 6d2f4c831df7..ff199bab5d1a 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1252,6 +1252,9 @@ void isci_host_deinit(struct isci_host *ihost)
 
 	wait_for_stop(ihost);
 
+	/* No further IRQ-driven scheduling can happen past wait_for_stop(). */
+	tasklet_kill(&ihost->completion_tasklet);
+
 	/* phy stop is after controller stop to allow port and device to
 	 * go idle before shutting down the phys, but the expectation is
 	 * that i/o has been shut off well before we reach this
-- 
2.53.0
