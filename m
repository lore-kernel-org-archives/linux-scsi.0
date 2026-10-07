Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CFD36197F
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 03:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791343081; cv=none; b=nxWv26NaxaOg9O+pEA5qTo6EpdmTTYvnjpmIorRykQ+ciqBtH3INGeRfeJ//9TkhYaWiUu+gmcxhNaks6X6rs7p4oGtB97ETYZ2JSYth9WYO1LwPLZ9MQnPwBbwnZk0ldfmrUv7vuKMgDP11lGghvIXsXhGgHxcMjC/xd2UuoKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791343081; c=relaxed/simple;
	bh=8L9AMwgw9QqRi5hDNZ+LhrvvUXJjrxerO0IBNK3glXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lm1jjUgR4BOR2zCXOcVXyokXewZWqzhSdFKRazDmAwiLewk5+tJ8AYkjPXeer7rziV4ULeIeAMQqFwOc5uswkiHwzIMLCiv+iAmI485OGkK0Bwx1667EVX+Cfg6QESIUBxFtuScyJ1d+5D/8p6cuWpgPLRZEKlkz4YwUdKR12Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=eAExJeM2; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="eAExJeM2"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3a7fecf8440so813249a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 20:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791343079; x=1791947879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3nUOoyD/0fhR41WYyphW7g8WBCossckUJ9W2mK+9QEE=;
        b=eAExJeM2p6C/H1B2mFlswDRN14GTdKynraTieSoOWu+mqka8dcEChLhXvyq3r83ewI
         D3WjHQEHxnVMo2YyYHi6Fb0ixoLCD04nUP0jhqh94klh4fLs3d7CHAI2A/tYtOd2ppdO
         p88zC2DySvZs3+PyvcGizkjI8OdjuSw7DS6m1jr8XVOEn/hlOG+4bMQnFyYTnAw4tQIU
         ExcIVWG+b/8yP/hMjj/UYnCVzAxVwMH5jgrHV5j+YtXYqV5hAtMfGlGAOYFSR4WNgaiM
         0EShirfH6VmawBQIG9f6gaWL6f8KTre4BeekcQQNrWqrp47hbulQ8Jn13VZAxo/l3EIO
         d4FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791343079; x=1791947879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3nUOoyD/0fhR41WYyphW7g8WBCossckUJ9W2mK+9QEE=;
        b=Icq21OR+z7SX5ISUzDawP5qNGHViqZO/x7u/YANmJahmAL9xAU5Z6UAWQ1V+9Q5R5U
         RvI/8aF6v25aqFI0qY86/5f0UWIDe6YzzSjKupJo+otVl6wrWuatGVj+JLae9T9OJv+x
         DkwgTpuMp1KEQHKvF6fgmLLzRFp6/qV4HKyIRR0ohhApz9T7EztKB5aoix02yR6JoYyK
         ac+YPtC6tTOnZcEwf9j24JMUlBvfWj3GyMgrRcUbzkFk5iOt6h+LHLKY4+ibZOHBX5+E
         EinJDJNOvngfpWp4vgVoZ0pAVrfsPXwTL+hU4oEiIrpUJrrx2dMRJEztgQfX92TUTfCK
         I+cQ==
X-Gm-Message-State: AFq9FYK2WufJfvDVaG9M71/pLlntgcv/Zc16FR8LNSirSQbcHrnBuy9n
	Hn5bcO/niLgW3VIEQUHShPQWL3Y8N/f2M98831W1XF3giWc/lehmC7EL3hIEYS1+fAE=
X-Gm-Gg: AYBFou2xsCm5+HsKv1/1cvrN73CH3QnrWNafMI3qMNK6ZcyP9N9BdGywBQu+V0Yvex1
	t6jpBfi7mWwfqhxWeCmdvWuQmHJdfZHKhVA0IUk/PLKVQvYKR2m6hcyHp5IgyoXlXfUXL88Y9hq
	epv99aKjjzNVebnTH29f0nRs6KVOmjCjSurIen2jfkb6zoCMgAiF+ddy0kIGADmQt3zRTsnWVxp
	1heWmZyjw3ps+mbWkxuyBYnIclXUsK4Vez9tEz6WQYSVlmLfFGbsDLvfha9BTMLrRZOSUfJJr8u
	mRrV9qDD9FCDg+PNL0oDfQ6Pf66YsRW/5dsvr3Hmh1Ow6oL7Vq2alUlE2esj3hZhHMuHwecqDFw
	RlBs/rVXXw6GGlSmaB//bKuXNoJUH0cCmDNdtzDTxEuyegs0Z1Nx/bXk72DR7R5/OwW7zRsGDoc
	f256eAfdiXn2Wl1fWthnDpFmlqiztJwsgNmoyz8OSUws5BDr8FMuKLh/hGvL5CVyrpPumoB5WVD
	LDe4A==
X-Received: by 2002:a17:90b:52d0:b0:3a0:c0f0:9a97 with SMTP id 98e67ed59e1d1-3a8a04db3a8mr846970a91.9.1791343078978;
        Tue, 06 Oct 2026 20:17:58 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a89b17bc5esm2363382a91.7.2026.10.06.20.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 20:17:58 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com,
	martin.petersen@oracle.com,
	lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v3 3/3] scsi: libiscsi: validate the task named by a management response
Date: Wed,  7 Oct 2026 12:17:37 +0900
Message-ID: <20261007031737.639431-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007015842.634893-4-yhlee@isslab.korea.ac.kr>
References: <20261007015842.634893-1-yhlee@isslab.korea.ac.kr> <20261007015842.634893-4-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for looking at this.

The management-response ITT is resolved with iscsi_itt_to_task(),
which returns a fixed slot in the static command pool
(session->cmds[i]) and is non-NULL for any in-range index. The
previous check was "if (!task)", so a valid-range ITT was never
rejected: before this change a management response could already
drive any pool slot to completion, in any state. This patch rejects
slots that are free or carry an active SCSI command, which strictly
reduces that set.

On the two paths you raise:

- The allocation window -- a slot briefly ISCSI_TASK_PENDING with
  task->sc not yet assigned in iscsi_alloc_task() (freed slots are
  cleared to sc == NULL), allocation under frwd_lock and this check
  under back_lock -- is unchanged by this patch; it pre-exists and
  sits outside the NULL task->conn dereference and the
  ISCSI_TASK_FREE refcount underflow fixed here.
- Completing a still-queued PENDING task was likewise already
  reachable under the old "if (!task)"; this patch does not widen it.

Fully closing the allocation window is a separate change -- e.g.
assigning task->state last in iscsi_alloc_task(), after task->sc, so a
findable slot is never PENDING with a NULL sc. Happy to send that as a
follow-up.
