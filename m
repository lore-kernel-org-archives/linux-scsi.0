Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7F534A767
	for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 07:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777016376; cv=pass; b=NyMNXNPQOi4/KitoIcODhKpZEYaIVaF/z44zPPV86ELIh9bEvEacFlnw/7nohZ02n9wQU3+47TcYo4zHRO8tqjDiBJmzDM0OF41Rm7PRqiAB690gXof9rAvTU7NoEgSNZ++H6ODAokrQrJWN2F3M9BQ1+X+C1Ky+xbyWABhyR6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777016376; c=relaxed/simple;
	bh=qDuYQzqb/cSu2m3WynZ6dgFZPBUfe4a5MWzL9PmgB5Q=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=IQXFBp45jafXhXROHns+Zk34GsFeBL8uJVBXgB8aOmRXWZhDorOplalmWO7aKjLneOZSdvmvlfDkmJ3rbEq9AEGxNQiwh7jjoY5sAzwniEXHhlRPwGJ+KtAVP8r2Q+i8rnKblWdPqVtvkbufaURhjE1dkavbcaJNNn6ndSJ7DXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LwALhCUH; arc=pass smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LwALhCUH"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-79495b1aaa7so75546787b3.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 00:39:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777016369; cv=none;
        d=google.com; s=arc-20240605;
        b=cl7yaSeTvaCJ9zYij5xO5LrX1LCPxFUlbkOl93S6hHwIPUjLBevWDj1Epv4Xw4n1iN
         edKaECjoP6/i572rpb3Hsrv1jDQHK3IT6+RzeoIgg7XBWXR31AI1qXNdOXCElzaOytfJ
         RpK08zCpwiANCuKEZ/ILeCWj1XZfZviZrztwuPFJDMLmUyDXK1zZozyVmM6c9OFuglOc
         88nIHURkPLHCiXEd27kQy5cEzpYqkOA4i4ntYKLzvz2b2MJeyhVjm6O2rVpF4IhsS8G3
         UN2vUD+w0R4gP2Pl7APF3tIGBIGH3phImmvuuUoERe+3kYHCLCgWTZNy7LtbbFjvGjSX
         nfQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=pH3vJyfUSUjMh69MtzR5ppjRqhjUf9sBN9iYzux6Aqg=;
        fh=oozdZYA9rwlXhLIET563mvtazbrnDJ0YfXw0DoPLoBs=;
        b=WnN3gc8LV3C8V2CVdt5xk4FS41V0AT9of4as6k6xSbaCmE9PgwnI75LQiV6JG11xZl
         1exz30TrP6e19mro2h7oDHKKWtH7nQZGWLxZSgrgnTy9h/gEUXE0I9KnKIEc48RXa9ik
         i89JqStBQmtp+rV/UGBl+WyIaX8SDvLU/9jzpff347+aBNLC/lcfhJu3vYnhby1n0eRh
         qrczB+4B0H3e0PglEdGXonBARMZfK8GoJlmpEn6Ia8YVAlaaAFCAMOeGDh2BFWEubb6l
         1c1TLHVI31B6dh+3tQtC4XOoDxdSA/Qve68S859iien8WI2eARnbR0vaemZaEKNsTMqH
         /YBQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777016369; x=1777621169; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pH3vJyfUSUjMh69MtzR5ppjRqhjUf9sBN9iYzux6Aqg=;
        b=LwALhCUH62EVMOJDxkbyyhH7IjYWek/Ssx8ldB1q+SCXzl0yco/3Hc2ulu6m/f5QfS
         vKaomOw7He6oG6CiJ8RAY4SwahWSeYqWit0BO26heZ7xsNlJGXrlZ/aSpMjoqavY8AdH
         559JZO2oNA+COeFNkj2t5CKvdL10x37Y2H00a5GGh10w+8Bx6hAnAUB7kr3DTebKF/U5
         b1xXc0rQK6GeXOs120X6VJfs61Dluv+c4u5UaL7DUV1janUjwvoNbQd0tdNRK+nMYRq9
         P/hwsFvtj4bglFhJTG2QwMYn5vwjFySGQAPvn2LO5ioFds0lvPTJv5GMjKzOeqrD7sde
         ydPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777016369; x=1777621169;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pH3vJyfUSUjMh69MtzR5ppjRqhjUf9sBN9iYzux6Aqg=;
        b=L48fFPGUVDHSuWa2JrXd1r5qMM/OUHMbYRewNHggZgAyBP0O70tDkkhc/Xw1qp1U8B
         kZN6K+8EKVrBB3M0WUlL4He5JOsjaV/za6zYrCIijBnzbd8TUDLihsxM9C1Qu5tVTrid
         q3QrHRhJghPqvzhn1ZOM+xJS6OTXWTw3YAdtglXOk5A8Ld8+FdfYbjv/hFZ12RPrDa/b
         QfudEATaEoIqYXoauJsskUvDgQE651wwctxDYvoo+WqoyelltntM3nWcmFiPWSRFPeHU
         mPzQZLLY9edqpg40cyzE63QSzmOGK5fKeQ61MaMUXL1Y9vrhD/XaqmqgyLq2l57Va7AN
         ugdg==
X-Gm-Message-State: AOJu0YwUt8HnipkG8x6hyxyNSoA+JCa4FE3s5Q4HPmQktTDGGM/yxm07
	WfnOZ2xu4MslQwuhTLjeI/xt2xAfijF+jzVTOXUzjfnxrTwHm3Dd+BbdgNLKSpXoOA8S/Z0I/4f
	mLr6FJYaf93P2Wa6WDC/56w6AuUEwNGrzqupUZug=
X-Gm-Gg: AeBDietPV0Zu2/ba2hGJqeNA+HXeJwmH2lWwYIqCnKdEe4Y7r9CvPkF9OJ0SZXAXauv
	tn6bskNv+M24HMlBXxCuIgp4+ewluee11Q60OeJkB81HUcjpD1ZMo07sSgQdx5nwmLSBMHjoXLQ
	cwq5tDTphJx7SJo1Ifrt8HtESpWKeiZGApymBjyRuPMZje2yh3N6xgPXWDiQ0NWqobxfJU6G+0Q
	OCKcvv5FItAwmRfXEXA2PqY7oNIEVV8WipXCC5rLdgrdAs1kb0WpjMhEuUtOqLXKOBCLXU8YP3r
	faC2q0jydQQ9nzmxJO8G
X-Received: by 2002:a05:690c:6987:b0:7ba:e113:9628 with SMTP id
 00721157ae682-7bae113a323mr238458667b3.30.1777016369500; Fri, 24 Apr 2026
 00:39:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Ginger <ginger.jzllee@gmail.com>
Date: Fri, 24 Apr 2026 15:39:19 +0800
X-Gm-Features: AQROBzBrz47Fek1AkJY5V_425WsRHOSRo6qcDVEvJyYSZEUoZOMfGXV8smqknSQ
Message-ID: <CAGp+u1YowPuP2HsAjnK0Q93tz9qcpVWU=OR2LtJWa+_uuz=zBQ@mail.gmail.com>
Subject: [bug report] potential deadlock bug in 'drivers/scsi/hisi_sas/hisi_sas_v1_hw.c',
 between 'cq_interrupt_v1_hw()' and 'hisi_sas_slot_index_alloc()'
To: liyihang9@h-partners.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Dear Linux kernel maintainers,

My research-based static analyzer found a potential deadlock bug
within the 'drivers/scsi/hisi_sas' subsystem, more specifically, in
'drivers/scsi/hisi_sas/hisi_sas_v1_hw.c' and
'drivers/scsi/hisi_sas/hisi_sas_main.c'.
This deadlock potentially occurs with the involvement of hard irq.

Kernel version: long-term kernel v6.18.9

Potential concurrent triggering executions:
T0:
cq_interrupt_v1_hw[t1]
        --> spin_lock(&hisi_hba->lock); [t2]

T1:
hisi_sas_slot_index_alloc
    --> spin_lock(&hisi_hba->lock); [t0]

T1 does not disable hardware irqs in acquiring the spin lock. If T0
(i.e., the hard irq context) occurs after T1 acquires the lock and
both happen within the same CPU, then T0 will not proceed because it
cannot hold the spin lock that has already been possessed by T1, yet
T1 cannot proceed because the hard irq runs disables preempts.

Thank you for your time and consideration.

Best regards,
Ginger
