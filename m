Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018067;
	b=M0xR59UOG4VI+Su2gHgtLKYlxz7aJFvwxQJQmKKNMlZRxmirVTekC11p5nuryNuBAk96
	 B260vp2VZxYKsD7IVyhIRQ11J/sHHbII7k5zK1z3p5kk3r5+aCECDdVnB46Fdjr7FbtGo
	 q9JBUL/uSFeJvKf+0Y3YntTEXrvvNo1dCPJVjLVWnr24UY2HB2/T/pIlIeNmDAhU1NhiV
	 lkYVeFCyZUs7PKHNNDGXT+8ow3VUpiXfnNjIfvjdA0pal3V1rAddk5jY4l3abC60Cj+MF
	 9nCfCA9b+0pBs5jCYF6pe5QtHzt7ORbTck2oNSkVVq42dwhGJ5QirCukUc/ECkjPXKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018067;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Mailer;
	bh=miZOpsXXWqTDg4brI3XNa3nMkTf1a4j0jITu5ECiOM0=;
	b=lhSN+xTvut5nAIZvo8M/6+A4sSS1xOzc8iuRt+AlMTyZFC59PcGMcFDqodzKoMopL4l+
	 X2Qn0zcPCkGhYLpnrjMyOjVfw8FgSjiHWLe84vl7z7XDL4WdZx0/I9lPJqojpSeGSUH/Z
	 kaQPZ4p8Wkyf0r69+61wngQQ6bCxBUqwvmTEoaFiOK/AjHS97eoH+iz2cfoiSQuLLpRn3
	 NGYL4DkAcOOCdb8ZCZ04LJriG9mDqBpu6/csepEGLbWZ51ElpdPZfumrO42NFWYpgf7Bj
	 y0Hw90NHceJliV8Z/t8pPXpa8LFjoHzfN7MSchyb1Dwpl29vsxGbZMFfvSGCAo1CwSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=pass smtp.mailfrom=kernel.dk;
	dkim=pass header.d=kernel-dk.20260707.gappssmtp.com header.i=@kernel-dk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=rfERdRut;
	arc=none smtp.remote-ip=209.85.160.48
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFBC60A381F
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 16:07:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BFBC60A381F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20260707.gappssmtp.com header.i=@kernel-dk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=rfERdRut
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-4ad4072943dso450153fac.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 08:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20260707.gappssmtp.com; s=20260707; t=1795018066; x=1795622866; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=miZOpsXXWqTDg4brI3XNa3nMkTf1a4j0jITu5ECiOM0=;
        b=rfERdRutCiY1Lz5trk/rT3JitdkQbyeRpy92SAEBTr0SmwHHW7GjbVlsL6xi4GLvlA
         eIy6I8HWFFPJEAko7lPdUqZJ0ASfQs39uGsb2kxFW41b1JV5vmuNw7JyeQ7RyefPZ0K/
         9xQMAXHoHzpNH4wuyizF2fSFPUA4p28V42dt2F4Kqw0BLpetMDyzdYPIEpOPJPmRoJPR
         CA0R4B7acExX6CwARQsZdifC0Die7wBlG1RRQSCl2BNtFRelYwu0NbJSKXPCQplp7vXG
         14ey5H5NU8zd6o0RiLfoiNrrbcb/neM2Pssr4bC/1VTI7DlntKS58QKULJCOW7HRil/c
         C9OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795018066; x=1795622866;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=miZOpsXXWqTDg4brI3XNa3nMkTf1a4j0jITu5ECiOM0=;
        b=ymIRXM+siRkmNdFhkjibQ/BAaON4eW/2q2rWgYk5LPYy/W+dJOiXI2TqrysqiTi15M
         IUvnmkvMt0xcHebwkphrWPXMd4vP3zVrbh4vzDidxpv800RaK8rUvnHTwCJLoKATrMnt
         mIz3yF/JEmkChya07zcBb7YyrXA0WFTvOUZ7QWJ0jKPJL+qtCxvttfmYTrk7CMv4ElpE
         J0vbSKDE0oKouRABoaOqbrJ4ZMX11PWk3/zdnPrtewjKH5TKXCGlEKmicqpRIaAvHQQv
         LP/TzynWn1JRA1oDSwA0/jGcAnzklu7Ido1lgQqGNoCiN6WZyFuL6IqETFiwCI4HpIze
         fWxQ==
X-Forwarded-Encrypted: i=1; AL+hErH3vqeivwY0b7wHUY/hgYFtSDXNPpr74lDfxz5XNOEdMgMAt9uj2gGQ9Ee71AH1DtxyJHmdDbE7Mywi@vger.kernel.org
X-Gm-Message-State: APuU4Z8IVxeXZwjpWJPAvDXFMbijKBQK3j7K7KQothQe6sKBTZG0ivyo
	rDmP5KsAWy3NzLXg/PKtCnMgZXK+Q9rF1rRb0pASgLiJbV+dJnsfBE1NGlDJkzRqS64=
X-Gm-Gg: AYBFou25W+8ZPgrpqff6yQI0C62W0N8KrHRNYt12rUayMUmT9Iwxn0ayNO3VhCi1Xt0
	X/ZIdkG3c7E1NAbW58GEq0r7RsCcuI7WLbzllqGSt6kKqkspdDnTwZO0ToFdQKbKuJWWcETZuM1
	67gWR+s6TNy9vBoKQZ9jtztbutUEjEQhdNiLuUCMLyRjtixPVFQNQOkXBU5x9kzaVke6T7mqFmP
	tyne9cb0T34l0RCIzCdtakhZNVctUOEhIyzvRXDgJjyKEA1pgeP0hzeARxzI+XEcuwz+mRvR9dp
	YGg6wctV0Ver1JoWrLRN8w0fnJas5WpQ0WmQuMYux02Y8CmuYiBEWlXiHDhqp6KH4lQ8fjYFfqg
	3ht7qxuMPIMhgVQS+NptPXKj73V2Tzyy/uXM8vVgcrRLbJ4GhI0f4Ob5WRdaH8cTeowlDUtE/xn
	igLKjRdZrCM2RSqtC+6s2fvs221y8XwdwLSAizuMvQ0um5+BYayDYiupRkP2XahOkV3zYLSwSty
	nFJMCU6LSMORUvxqmJzJnbAkq+SYRoxjEsamAL0Degbhutd4mRwTN4z8ni+XXjEZ1UaXPtJVjzx
	2N68H0WKD9t/Dva4yl+nNWtrXjGg/DxYhJYGeeu+rBI1KtzFNKzckxt34Gq8eVtatMEMJdDb9b8
	C9liW2jzpWExZD/v4u7PlibhklsG65hOmz6P+3Egwqw6Sz8x8gGbdMGBMWXzPKky2qg9mV8Pm
X-Received: by 2002:a05:6870:8920:b0:49d:c8ab:967b with SMTP id 586e51a60fabf-4b7620acf02mr2521246fac.47.1795018065606;
        Wed, 18 Nov 2026 08:07:45 -0800 (PST)
Received: from [192.168.11.112] ([96.43.243.130])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4b743721fe9sm2624231fac.6.2026.11.18.08.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 08:07:44 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Stanley Jhu <stanleyjhu@google.com>
Cc: Bart Van Assche <bvanassche@acm.org>, 
 Brian Norris <briannorris@chromium.org>, 
 "Rafael J . Wysocki" <rafael@kernel.org>, 
 Praveen Talari <praveen.talari@oss.qualcomm.com>, 
 Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org, 
 linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20261104112744.1630864-1-stanleyjhu@google.com>
References: <20261104112744.1630864-1-stanleyjhu@google.com>
Subject: Re: [PATCH v2] block: Keep RPM_ACTIVE in blk_pre_runtime_resume()
 when already active
Message-Id: <179501806424.17649.9429091372346585775.b4-ty@b4>
Date: Wed, 18 Nov 2026 09:07:44 -0700
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Wed, 04 Nov 2026 19:27:44 +0800, Stanley Jhu wrote:
> Since commit eef1d74bf88f ("PM: runtime: Only set runtime_error on
> suspend callback failures"), a failed runtime resume leaves
> dev->power.runtime_error at 0 with runtime_status set to RPM_SUSPENDED,
> so later runtime resume requests run sdev_runtime_resume() again:
> 
> 1. A runtime suspend increments q->pm_only from 0 to 1 and sets
>    q->rpm_status to RPM_SUSPENDED.
> 2. The first runtime resume fails in the driver callback, and
>    blk_post_runtime_resume() sets q->rpm_status to RPM_ACTIVE and calls
>    blk_clear_pm_only(), decrementing q->pm_only from 1 to 0 so recovery
>    commands can enter the queue (intended since
>    commit 6e1fcab00a23 ("scsi: block: pm: Always set request queue
>    runtime active in blk_post_runtime_resume()")).
> 3. A retried runtime resume calls blk_pre_runtime_resume(), which
>    overwrites q->rpm_status from RPM_ACTIVE to RPM_RESUMING, so
>    blk_post_runtime_resume() sees old_status != RPM_ACTIVE and calls
>    blk_clear_pm_only() a second time without a matching
>    blk_set_pm_only().
> 4. q->pm_only underflows from 0 to -1 (triggering WARN_ON_ONCE in
>    blk_clear_pm_only()), blocking non-PM requests in blk_queue_enter()
>    and __bio_queue_enter() while the device is RPM_ACTIVE, and the next
>    runtime suspend increments q->pm_only from -1 to 0, letting non-PM
>    requests dispatch while RPM_SUSPENDED. This hits the UFS device
>    well-known LUN by default and SCSI disks with
>    manage_runtime_start_stop enabled (ATA and FireWire sbp2 defaults).
> 
> [...]

Applied, thanks!

[1/1] block: Keep RPM_ACTIVE in blk_pre_runtime_resume() when already active
      commit: 657d7c48b84f2ef0bf885b47cf2318823bc72970

Best regards,
-- 
Jens Axboe



