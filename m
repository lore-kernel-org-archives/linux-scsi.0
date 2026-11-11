Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794422314;
	b=YJ+ZTOMQy8d1la64iDxqqT7YpinEKeEb/jWnWIz5n391HIPVLmVIV1V8v7GtwJWNULrl
	 MIKlazhMEKKyUg4P+YKsG1gpuJnIlAhEq456ONfZl83siUXdntsCHmsByz1oUJncKbfe/
	 B1E/0ebQDeRN8nsxfU6Om0fKEktFKutCM81lT9ml3lmbTdQnQ87Xzw98sat7MEomidkTP
	 +YnL/fcpQbkKSYBKDYUkptxWHpS/EDLsfCE2hXcErIX3aOmfwsyJUDuBEsSUOFGdADhts
	 3A4NJjS2GBxuEmyzEjIY/NlK2kQz4XwQgUkByL9nRblfUs/ed8Ztz6nPn45BGlyEubQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422314;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=AiJQ+tdBeIaoecFK8n6veCk/731fFPU/ceE9mKomLH8=;
	b=eH5cEKY2HslQgHinjLNw8TVmFUG6oVMPD1i5jv7vjm4tayU+qVK4n+pOZPYQAmTlANpP
	 v4FzA7JHxDkS0MKtY1ONB1LtkQhrJTTsD66MuaYK0VHPOAhRXdACwFytEhnqCOcpJazhl
	 6IcNehe7p3cD6I9tztHHfatpr59JGfzZHX3/qOw6OUHh7NxP9frWOqm5U0doKPcQ9SWTc
	 JNZnCkyjhoDETrL49Bk/+u6L7Subb3kYBKvHIyXUa9+IUiALw0mOPbYxPlLAg6qLuQGEK
	 ps7NkYVE288n7OeGemG0JE3PysA6MxMZnWWnxvPh+6EaKw+ccYyMnN2LB7ZZq7rIXew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MhAyqMJ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFDB606A324
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 18:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MhAyqMJ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1982B1F00A05;
	Wed, 11 Nov 2026 18:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794422314;
	bh=AiJQ+tdBeIaoecFK8n6veCk/731fFPU/ceE9mKomLH8=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=MhAyqMJ6NClRc22pQLk0eod9prwsNsaEoril2bgmM1EFcwJc/hwf4pBM/o47S6oe4
	 2A2MvF3lTUt5A4GivsMkGtrqYIsPqGKK+iGfpkmwQqr7RSOlvuisYRa/RIPTuA/0Oo
	 7dnchWJf5SI3G9Szzb1tB7BOq7MKS/dfTEF/mydEky82eQ1A0zq9hZrdZKgzfr8AF3
	 Z4irbj56dcUhhkJ11vpL74PUlqsvZxepu8dhikgaML7gHor0Qte2JfD6v4W9ul/dXY
	 OGrTJUzMcdxzxGntovyOSS/yxP82qUk6Z2EAMgU42ruOkwBNdGkreFUMBlyXGaWnaU
	 54hfjoxAq7aQA==
Message-ID: <sashiko-outbox-209465@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] scsi: lpfc: Fix race conditions in ELS retry
 handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kyle Mahlkuch" <kmahlkuc@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <dcea48dd-f76c-4bb0-9275-c12ef9bd78a2@linux.ibm.com>
References: <dcea48dd-f76c-4bb0-9275-c12ef9bd78a2@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 18:38:33 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] scsi: lpfc: missing Fixes trailer and stale race description in
  changelog
--

commit c4e00459dde635d0b5ecc529a001464e7b80a848
Author: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>

> scsi: lpfc: Fix race conditions in ELS retry handling
>
> This patch addresses a race condition in the lpfc driver's ELS retry
> event handling that can lead to a use-after-free in the
> lpfc_cancel_retry_delay_tmo(), where the NLP_DELAY_TMO flag is cleared
> before acquiring the lock to check if the retry event is queued. This
> creates a window where the timer can be rescheduled and fire, causing
> both the cancel path and the worker thread to release the same reference,
> resulting in a double-put and use-after-free.
>
> Moved capture ndlp and clear evt_arg1 under hbalock while dequeuing
> LPFC_EVT_ELS_RETRY in lpfc_work_list_done().
>
> Signed-off-by: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>

[Severity: Low]
This fixes the unlocked els_retry_evt removal and lpfc_nlp_put() in
lpfc_cancel_retry_delay_tmo(). Should the commit message include:

  Fixes: e47c9093531d ("[SCSI] lpfc 8.2.5 : Correct ndlp referencing issues=
")

Also, is the first paragraph of the commit message still accurate? The code
still clears NLP_DELAY_TMO and calls timer_delete_sync() before taking
phba->hbalock, and fixes the double-put race by serializing els_retry_evt
dequeue and evt_arg1 consumption under phba->hbalock.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/dcea48dd-f76c-4bb0-=
9275-c12ef9bd78a2@linux.ibm.com?part=3D1
