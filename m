Received: from mail-05.mail-europe.com (mail-05.mail-europe.com [85.9.206.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A54191F94;
	Tue, 17 Mar 2026 17:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.9.206.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767891; cv=none; b=IfbZ4N9H89wAJZKI0ufHw6otxh6K4Jm1MeVrzlfPF25PGcgb8jJLKjtXUU+hfrUdnpFJBB2vsAq0OfYVCP2hl8gcqw0M6jVSDlhlL0oP//PgbJX+yTDXdYlksRm1n6pAt6SKLejHnbXIvvD4BI4wcZ6x2xT7FKxlTsUB6fNhuDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767891; c=relaxed/simple;
	bh=vX1kx7VM5hkljShUyb582SJ3E0ltV+g/Ivrd5dmpxBU=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=ZMHeSDpHAn7sWXZ96CodTAd3RqaYGqS9vuOVtFEoH7iKVtJeCSySZwusPhLik8NSb28qRcWK1KOO/nbUgaF5jG9adgmP3dGr3sJ3N/7ehdgPdRIS64lEIMRssYcqVPaAKEEhByE5kFYyxlaUbOgrXfWexl+x/neOh1RpV+hRYeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=cwCSE0dw; arc=none smtp.client-ip=85.9.206.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="cwCSE0dw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=dzntp2wu7ncnxeiiq4xjs6gciu.protonmail; t=1773767872; x=1774027072;
	bh=ormOhq7y7cFOvw2DX0AmoKb1gOKEJgoMDD9goXSLiok=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=cwCSE0dwVwv3Q05AB7BH8CTHMJ4OIE4UwDYw60tifBrbsW8ivI33caY8yCEzuE01E
	 l5wBktdKrSenY2P3ynVz0QxvLqzC8iCPq07oI4D9hOXWVRNXZvC+tVh7a43T6ezgiJ
	 MsdbV+y5i5+WgTng/jVNwuRrfkFVf5c2kfnOSihA0A4VvlM8SFI6qeu3mCRFId8YRv
	 D+wf8XzCbrykZzm/lkrWAIwbB3SDKVTRn9OfjjCs9MBW5EqsM7SKjRX9qGEQNGBdTn
	 dKLo8jRIjJT9Cs6uBGDYW2WTcbkIgLgSGpTkTUHvc6CQ/qbJe9LRcY219M6WCj7jAE
	 w1Pm0Lv7xnxXA==
Date: Tue, 17 Mar 2026 17:17:46 +0000
To: Peter Wang <peter.wang@mediatek.com>, linux-next@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
From: Tj <tj.iam.tj@proton.me>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Regression: scsi: ufs: core: Avoid IRQ thread wakeup during active UIC command
Message-ID: <abmMptgPR581bPUS@mail.iam.tj>
Feedback-ID: 113488376:user:proton
X-Pm-Message-ID: d5894582a53cf692f29abc81b7ac3b999d1bd876
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

#regzbot ^introduced: 6475cfb81fc4f6175b6d15d1c205a5168dc10b46

I've had to revert this commit because it breaks UFS on Samsung Book2
W737 sdm850. Below is transcribed from a blurry video so apologies if it
is not exact:

| BUG: Invalid wait context |
ufshcd-qcom 1d84000.ufshc: uic cmd 0x1 with arg3 0x0 completion timeout
7.0.0-rc3-next-202603110sdm845 #103 Not tainted
-----------------------------
ufshcd-qcom 1d84000.ufshc: dme-get: attr-id 0x41 failed 0 retries
swapper/0/0 is trying to lock:
ffff000087ba4048 (shost->host_lock)(....)-(3:3). at: ufshcd_sl_intr+0x3dc/0=
x7a0
other info that might help us debug this:
ufshcd-qcom 1d84000.ufshc: uic cmd 0x1 with arg3 0x0 completion timeout
context-(2:2)
ufshcd-qcom 1d84000.ufshc: dme-get: sttr-id 0x41 failed 0 retries
no locks held by swapper/0/0.
ufshcd-qcom 1d84000.ufshc: ufs_wcom_check_hibern8: unable to get TX_FSM_STA=
TE, err -110
stack backtrace:
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.0.0-rc3-next-20260311-sd=
m845 #103 PREEMPTLAZY ...${unclear}
Hardware name: SAMSUNG ELECTRONICS CO,. LTD. Galaxy Book2/SM-W737YZSBTEL, B=
IOS P02AHG.005.190624.WY.1359 06/24/2019
Call trace:
  show_stack+
  dump_stack_lvl
  dump_stack
ufshcd-qcom 1d84000.ufshc: uic cmd 0x1 with arg3 0x0 completion timeout
  __lock_acquire
  lock_acquire
  _raw_spin_lock_irqsave
  ufshcd_sl_intr
  ufshcd_intr
  __handle_irq_event_percpu
  handle_irq_event
  handle_fast???_irq
ufshcd-qcom 1d84000.ufshc: dme-get: attr-id 0xa00b failed 0 retries
  handle_irq_desc
  generic_handle_domain_irq
  gic_handle_irq
  do_interrupt_handler
ufshcd-qcom 1d84000.ufshc: hw clk gating enabled failed
  el1_interrupt
  el1h_64_irq_handler
  el1h_64_irq
scsi host0: ufshcd
  handle_softirqs
  __do_softirq
  ___do_softirq
  do_softirq_own_stack
  __irq_exit_rcn
  irq_exit_rcn
ufshcd-qcom 1d84000.ufshc: uic cmd 0x1 with arg3 0x0 completion timeout
  el1_interrupt
  el1h_64_irq_handler
  el1h_64_irq
  cpuidle_enter_state
  cpuidle_enter
  do_idle
  cpu_startup_entry
  rest_init
  start_kernel
  __primary_switched
ufshcd-qcom 1d84000.ufshc: cfg core clk ctrl failed
ufshcd-qcom 1d84000.ufshc: No active UIC command. Maybe a timeout occurred?
ufshcd-qcom 1d84000.ufshc: No active UIC command. Maybe a timeout occurred?
ufshcd-qcom 1d84000.ufshc: ufshcd_threaded_intr: Unhadled interrupt 0x00000=
000 (0x00000400, 0x00000400)

