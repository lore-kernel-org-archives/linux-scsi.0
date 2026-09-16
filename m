Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A914D6C52
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 18:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789584466; cv=none; b=Gf9d3TeXS32LOalIV09T3U6zi3burt9BM8A/e7QajQjXmC73I4OfhJGGHraC71+YOuQmR+pUp5mVK0NBp39wwbEUx2adN2yEzt0a3EY5Jg4gipr0Kw2N0gO6bgOoePrdxbrkQWt5qESudPSrL5b6vCI7PzH3SNCbPmDvPqmnQ+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789584466; c=relaxed/simple;
	bh=Dl2mOkWxuEJmH6efH0xuQ0K5VoLefb/xYo6CedeIICc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lrypkk+EvP9NXRnh3rxOu6kpELdm8Ju4j9xWTbxlZ6iVxDQ6wgWRzVtQGx9MuWsve+vtRY3oLOAjYK3b7k1a8wo9JU1ahYtbAP6lTqI9TfL74LRTNk+pG8cGn2JLRJ05iNJDJdy5IcTd5mEfh13xXKVt5faroQMQf8o00hTVe14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E3Onb8w/; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E3Onb8w/"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b965f447cso462975e9.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 11:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789584437; x=1790189237; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kIpgcpjulhrzjmnC5wF0dcase85PBIaYQH7p3PkSuY4=;
        b=E3Onb8w/Nm72mNKr5Cvk0URbzhfIWgJCzBuhgrTz3b40gWj6O3ejHpK5fX2P8Q6Q4J
         hsinOPf6uvyd64HCN+Qfjg1hffKvG6MjkhWt7jkMDZzlKCSQKeFiY9VW39soLCvhNXVT
         rj/lbWvhgzQ1/maDsSPoX16EzQuZlqM2AC86BMQ3/qabSJ7LW29zQ2aKmQ3i4cMFmgpF
         GeMyyxtlsOhUjZXQVxBnTaK4iJSS7P21pXHKSbXR0rpriLu5OUmZBYEffAsdlMt6YRQ+
         Zz5Rtr9xbFFbK5l/fAhN6QHLoN0bgkl4gf22JEg1WYzj3qIhBF/fbbSa+BcBFDUK6P/e
         12sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789584437; x=1790189237;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kIpgcpjulhrzjmnC5wF0dcase85PBIaYQH7p3PkSuY4=;
        b=u/p5YuVWYBmqNpXzumaEqwQSDgB68uPA0LN0Jz3UVUxhg1WlkPtf5usRH/tL0V0RNk
         uaWvbzVyvtz2Op0JNXZjox/pfru3T8C5yKEk4PweoMvUdEceYsyeSRFmdlqMvBhFt0sC
         bceNoSjoQ+Q+Yu/D1xJnipRBF4z3404zamDUjwJrOIEhU7dFwix/EQuXP/pBJ8GUbl7E
         iyVZR+ifUrYTBm/Oub9+4c+6yIFRbFe8JOc38N3QTXwkDStTATYVeNhaFWTgCn28vyVM
         Afb0gfpOYytTF0Em016lP/g2p3LaRXXLW7kJu6Y2PZuqIsvh1oBBoZA+QKoCXozSJdL5
         qNTg==
X-Forwarded-Encrypted: i=1; AKwUvByg8fsslzy+lnuN7EvPG22/LL1EMul+C+6vk9OGJDli07Fb069j5m5+XxNlrUc8om8zdApSzBzGe8Pd@vger.kernel.org
X-Gm-Message-State: AFuF++kmOndtcDxtvmv65rTDaYKr0FUk9ZN4nfPZLVzdOVEUZYfbzXvj
	quhGze6b23/Z5sIIW7TkiyKyVQsCrdQBUx3bTB3BhmloJTobQo6EfVhbRkBSBA==
X-Gm-Gg: AYBFou0jnQFfhivKjrYxBdVb8Z14kDhZG3y1r8t3zQAhp6Lo/gDVDpDLO6tTk1eTTWb
	l2YcB6HkQNRtqR1+e+CcGXGrn8H++cFG6naCYpmkHqcXxlfYITZGW/42YVotHHB0rgWAupzbTzp
	6XOxqIAsXGA8FZIegBedgHqzsiB0RkewCjxBdfiuBTtJyLHmIT5CCLEh4O+N4+Ad+aXqD8qiCmO
	04xwYOb2uXDmOjwgDjtosciDKq+Ku5aco/N+lYOEUxj9fR3yr7Ah4ytxNcCoDhI/MRiCXnyEFDU
	Z6aF/rIhQg3ju1ITIdVShtGSuT1UQgpVoseJQi0NMH7MZwiCgwSz7sM/+Y0YiJbXAYDoVbXD0QX
	Cr2uc0r1nyEyLxBjizNc4v1U3ix9rfppKAN7zn8IUDfp82ttp/sqwgif+HYKXh+hmkXOVNEuFfa
	D8AIBFgsAz4OiPHZDi7nfckbyXoCYhXcqklAiEftc1JCJF3bGE4NtP2IHg+Jy6xYIwzZcgDV2k8
	WwvBP3hbxR8PneIM1LRLw==
X-Received: by 2002:a05:600c:350d:b0:49c:fa20:cbfd with SMTP id 5b1f17b1804b1-49eb73253ebmr43138425e9.20.1789584437531;
        Wed, 16 Sep 2026 11:47:17 -0700 (PDT)
Received: from foxbook (bfh234.neoplus.adsl.tpnet.pl. [83.28.45.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbda77d6fsm316845e9.0.2026.09.16.11.47.16
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 16 Sep 2026 11:47:17 -0700 (PDT)
Date: Wed, 16 Sep 2026 20:47:13 +0200
From: Michal Pecio <michal.pecio@gmail.com>
To: djraszit <djraszit@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern
 <stern@rowland.harvard.edu>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] uas: JMS578 returns reproducibly incorrect data after
 host reboot
Message-ID: <20260916204713.22c4f575.michal.pecio@gmail.com>
In-Reply-To: <CAFKhL9fL++S1xh+aUCuYbk6EkLQnfUn95y7TBoWaGnPAVP1gYA@mail.gmail.com>
References: <CAFKhL9eUM91rtywaz_7Mz+4mJH2b2csmOmc3+86ii3a0Ka3Q6g@mail.gmail.com>
	<c335085d-a824-4632-ad3a-c06715258c81@suse.com>
	<CAFKhL9f6aLZgerw_7bohbQWvzMxSfd-m-LFcuNP1_p1vWkN4=Q@mail.gmail.com>
	<1320caa3-85b5-47dc-aa2d-56d3b003c6ef@neukum.org>
	<CAFKhL9eTD7DxtxMSMuUVP9cDG7Nq4jvrkTCjYfwr9puZfuC4Gg@mail.gmail.com>
	<20260915233818.5881ad97.michal.pecio@gmail.com>
	<CAFKhL9fL++S1xh+aUCuYbk6EkLQnfUn95y7TBoWaGnPAVP1gYA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 16 Sep 2026 19:56:25 +0200, djraszit wrote:
> First, I tested the original enclosure (0080:a001, apparently JMS578)
> connected to a USB 2.0 port of the Raspberry Pi 4.
> 
> Interestingly, it still uses UAS

Yes, UAS can run on USB 2.0. It uses a custom protocol to multiplex
requests over ordinary bulk pipes, without USB 3.0 "streams".

So it's yet another different protocol and a different speed.

> RPi4 + USB3/SuperSpeed + UAS  -> BAD after reboot
> RPi4 + USB3/SuperSpeed + BOT  -> GOOD
> RPi4 + USB2/480M       + UAS  -> GOOD

> As a control test, while the original enclosure was in a known-good
> state I manually disconnected its USB cable for approximately three
> seconds and reconnected it. This did NOT trigger the bad state.

> enclosure in GOOD state
> -> shutdown Raspberry Pi 4
> -> remove Raspberry Pi power completely
> -> wait several seconds
> -> apply Raspberry Pi power
> -> wait for complete boot
> -> test data  
> 
> The enclosure remained powered and physically connected to the
> Raspberry Pi during this test.
> 
> The result was BAD.

> enclosure in GOOD state
> -> disconnect USB
> -> reboot Raspberry Pi 4
> -> wait until the Pi has completely booted
> -> reconnect USB  
> 
> The result was GOOD.

Looks like JMS578 doesn't like being connected to a booting Pi 4.

Or maybe it's shutdown? What happens if you:

- disconnect, shutdown, connect, boot
- shutdown, disconnect, boot, connect

If the problem is boot (second case works, first case fails), then
I wonder if it's the firmware or the kernel. Maybe you could plug
the disk after the kernel beigns booting, but before xhci_hcd loads?
You could blacklist it if it's a module, or bind pci-stub to VL805
to prevent automatic xhci_hcd activation and widen the time window.

> With the original enclosure, after the bad state had been triggered by
> a Raspberry Pi 4 reboot, I disconnected its USB cable and connected it
> to another Linux computer without power-cycling the enclosure. The
> device could still be accessed there, but it returned the same
> incorrect data.
> 
> For both JMicron devices there is also an interesting recovery behaviour.
> 
> Simply disconnecting and reconnecting USB does not recover them.
> 
> Switching the enclosure/dock off and on while the USB cable remains
> connected does not recover them either.
> 
> Recovery requires both

Clearly the persistent breakage occurs inside JMS578. Looks like
either external PSU or VBUS suffices to maintain this state.

So the chip is somewhat dodgy and the only hope is that maybe we
could avoid triggering this failure.

And it seems to be the chip, not the disk, because only USB 3.0
UAS is broken. Though no harm in trying other HDD to be sure.

> Finally, I also tested the original enclosure on a Raspberry Pi 5. I
> performed several reboots with it connected and could not reproduce
> the corruption.

That was USB 3.0? What's the USB controller on this board?

Regards,
Michal
