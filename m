Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF1C3B993F
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2026 16:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778602910; cv=none; b=AkKtvUk+bxEx7rYA7y3fFHZUphd9I7BTwgCYYoojoWN5iyTm9JSvu3sQHfUL4YZixEfYl9Uasi59aDSTPZEfOWPNY1/W6jIaPTChNHO8wp5pX22DKaZhGY86tgTFY5/c7u821IJjDD3TMrkh5ED06r2qH1QpDnjgxKnRDxkn+mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778602910; c=relaxed/simple;
	bh=Oph/YYZUN1eVVob1hwraR+iR6aig1Z0jrnNZaGi31r0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ds/eq8ARra37wad5gwbktCg2jwI+qHD8b9kXnWKFdqvOgyCXSLi+f+h4xc6Yqx9pp0M97CsXaR7J8Nio2Ps4rwQpX3m6VSmO+uroLuvPTd4l0CelIMrO7jnwaDiw6fqWqp9xkFdBbHmG+NNp5xPD4LqfNH5bCphIm9+AF2jB9H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mFD3POVC; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mFD3POVC"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6749e8562a7so4874694a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 May 2026 09:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778602906; x=1779207706; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J0Ccv1UfqMOOxOflEQc2h7d3MsFikd1q1lwa5Y7ivPA=;
        b=mFD3POVC9qY/ic6ZJ+BkpohBgk7qXAJYvBh4LkRWTzE9UwLeT8JAQUPLrULIyzb5f5
         gF6E07xDy0UUKPoATYOOAiPqSxaE8eNlGAP384xZwLAkRcrKnpCLvOexAmYNTzJbDuma
         Ty/Aixp2nIfKRcia21wnRfmo9y19c34c+00xJkzsf/u+pJCKISfjmGuX3QdjV2JPftiu
         P1Eer5wlEvbCE4Ywhbvze2xiY6u+LT6qG9ywa8KIMkZ20MOCyCnea22WWiHENlp8a5CL
         0UjLCa9jTwavJHfiQqzctzlZcJJXZoQ6ZiUAC12BcRG1KkzjaeOzFR2cVVr3MTr6kWcm
         O9OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778602906; x=1779207706;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J0Ccv1UfqMOOxOflEQc2h7d3MsFikd1q1lwa5Y7ivPA=;
        b=IEAdgb6MDaS+Z+AdCKJfVJdfW1EPpKwvskKxa8QPx/gWKQIITmug1V+1BZQTsc9XVn
         eCFf15+0h8W3VGk87TJKWueq0yF6VvyClizNiZxO8zYY0FfxQhZ7H7iLi4CpWN1Qct3M
         f+2kN4PHbvM7ggtR+fvOQUCjx4dKQKeSWPQ1vPVl0BzP5bMdUpGz2d5d8pJY73lbwWji
         KjQWSK8ytvMa1oIWKREeM0hcCK9CDPcOeAsWunDvqFQCtyBxvwuYqRkFBcmjU5g2Zklp
         xjHDSo6UXcY1sfQiY4MTY9nN+j8Oc/GEAKOGn1FwyysGqbzKsiDcE5IbIm28jyHVgCdP
         oYxg==
X-Forwarded-Encrypted: i=1; AFNElJ9pFFyNofHh2/VJxKstROa9QgxHHhhOG6iBYlXmoKgTw7TZhazbYt3gy1MUGf5AaA814pcElSf70YNW@vger.kernel.org
X-Gm-Message-State: AOJu0YxbaU2MVMUR5NY/AeH8aBEUIBoVJS2zD4vz8eydA2ZcxK4hFNrM
	HxEf3YxiqXAKLzp+LiR9OA65XkbB4sTNSYBs4gBQhyC6EzBLCJJeQNfGJOncvYV0Fy6j0PMu/Et
	Ep7JeNdTFELhSEGKbwA==
X-Received: from edbij16.prod.google.com ([2002:a05:6402:1590:b0:672:29ae:9a33])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:158d:b0:677:15b6:4d6b with SMTP id 4fb4d7f45d1cf-680d02f613cmr2154738a12.26.1778602905910;
 Tue, 12 May 2026 09:21:45 -0700 (PDT)
Date: Tue, 12 May 2026 16:21:44 +0000
In-Reply-To: <20260429175016.7915-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260429175016.7915-1-djeffery@redhat.com>
Message-ID: <9huzh5ocmwdj.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v15 0/5] shut down devices asynchronously
From: tarunsahu@google.com
To: David Jeffery <djeffery@redhat.com>, linux-kernel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: Pasha Tatashin <tatashin@google.com>, 
	"=?utf-8?B?TWljaGHFgiBDxYJhcGk=?= =?utf-8?B?xYRza2k=?=" <mclapinski@google.com>, Jordan Richards <jordanrichards@google.com>, 
	Ewan Milne <emilne@redhat.com>, John Meneghini <jmeneghi@redhat.com>, 
	"Lombardi, Maurizio" <mlombard@redhat.com>, Stuart Hayes <stuart.w.hayes@gmail.com>, 
	Laurence Oberman <loberman@redhat.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bjorn Helgaas <helgaas@kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	John Garry <john.g.garry@oracle.com>, kexec@lists.infradead.org, 
	David Jeffery <djeffery@redhat.com>
Content-Type: text/plain; charset="UTF-8"

David Jeffery <djeffery@redhat.com> writes:

FWIW,
I have tested this series by opting it for NVMe devices and observed
significant performance benefit (from 9 sec to 2 sec).

Please feel free to use
Tested-by: Tarun Sahu <tarunsahu@google.com>

> This patchset allows the kernel to shutdown devices asynchronously and
> unrelated async devices to be shut down in parallel to each other.
>
> Only devices which explicitly enable it are shut down asynchronously. The
> default is for a device to be shut down from the synchronous shutdown loop.
>
> This can dramatically reduce system shutdown/reboot time on systems that
> have multiple devices that take many seconds to shut down (like certain
> NVMe drives). On one system tested, the shutdown time went from 11 minutes
> without this patch to 55 seconds with the patch. And on another system from
> 80 seconds to 11.
>
> And thank you to everyone who has spent some of their valuable time
> providing reviews, suggestions, criticisms, or tests on the various
> iterations of this patchset.
>
>
> Changes from V14:
>
> Remove unneeded use of '!!' with boolean type
>
> Changes from V13:
>
> Remove duplicate flagging of async shutdown on scsi hosts/targets/devices
>
> Changes from V12:
>
> Only acquire a parent reference if acquiring the parent's lock
> device_enable_async_shutdown should return void
> Minor comment and description cleanups
>
> Changes from V11:
>
>   * Swap the order of the first two patches
>   * Rework conditional parent locking so that lock and unlock no longer use
>     separate conditional checks
>   * Remove an used variable
>   * Comment and description text cleanups
>
> Changes from V10:
>
> Reworked to more closely match the design used for async suspend
>   * No longer uses async subsystem cookies for synchronization
>   * Minimized changes to struct device
>   * Enable async shutdown for pci and scsi devices which support async suspend
>
> Changes from V9:
>
> Address resource and timing issues when spawning a unique async thread
> for every device during shutdown:
>   * Make the asynchronous threads able to shut down multiple devices,
>     instead of spawning a unique thread for every device.
>   * Modify core kernel async code with a custom wake function so it
>     doesn't wake up a thread waiting to synchronize on a cookie until
>     the cookie has reached the desired value, instead of waking up
>     every waiting thread to check the cookie every time an async thread
>     ends.
>
> Changes from V8:
>
> Deal with shutdown hangs resulting when a parent/supplier device is
>   later in the devices_kset list than its children/consumers:
>   * Ignore sync_state_only devlinks for shutdown dependencies
>   * Ignore shutdown_after for devices that don't want async shutdown
>   * Add a sanity check to revert to sync shutdown for any device that
>     would otherwise wait for a child/consumer shutdown that hasn't
>     already been scheduled
>
> Changes from V7:
>
> Do not expose driver async_shutdown_enable in sysfs.
> Wrapped a long line.
>
> Changes from V6:
>
> Removed a sysfs attribute that allowed the async device shutdown to be
> "on" (with driver opt-out), "safe" (driver opt-in), or "off"... what was
> previously "safe" is now the only behavior, so drivers now only need to
> have the option to enable or disable async shutdown.
>
> Changes from V5:
>
> Separated into multiple patches to make review easier.
> Reworked some code to make it more readable
> Made devices wait for consumers to shut down, not just children
>   (suggested by David Jeffery)
>
> Changes from V4:
>
> Change code to use cookies for synchronization rather than async domains
> Allow async shutdown to be disabled via sysfs, and allow driver opt-in or
>   opt-out of async shutdown (when not disabled), with ability to control
>   driver opt-in/opt-out via sysfs
>   
> Changes from V3:
>
> Bug fix (used "parent" not "dev->parent" in device_shutdown)
>  
> Changes from V2:
>  
> Removed recursive functions to schedule children to be shutdown before
>   parents, since existing device_shutdown loop will already do this
>  
> Changes from V1:
>
> Rewritten using kernel async code (suggested by Lukas Wunner)
>
>
> Stuart Hayes (2):
>   driver core: separate function to shutdown one device
>   driver core: do not always lock parent in shutdown
>
> David Jeffery (3):
>   driver core: async device shutdown infrastructure
>   PCI: Enable async shutdown support
>   scsi: Enable async shutdown support
>
>  drivers/base/base.h       |   2 +
>  drivers/base/core.c       | 180 ++++++++++++++++++++++++++++++--------
>  drivers/pci/probe.c       |   2 +
>  drivers/scsi/hosts.c      |   2 +
>  drivers/scsi/scsi_sysfs.c |   3 +
>  include/linux/device.h    |  14 ++-
>  6 files changed, 166 insertions(+), 37 deletions(-)
>
> -- 
> 2.53.0
