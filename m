Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240EE1898FB
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 02:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784256106; cv=none; b=WkIQ/eImyhEoA8jHoby3UGlRooY3/F9i3eT4GZDKZHMYCWzped9xgPY6r4vrCiEfOZ38lY3J/vaiE46LaZfRq6f4cgsXR4MnXLDyrM/36y8Engt8zkIBBu7difVMbSMOoXrp0L4ur31PgMRlTf4cnpSNIc8n4xgiEggX2TkfCxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784256106; c=relaxed/simple;
	bh=lJv4IRI5XiZYUh3IyUwsclAolkzA5BnMYwS9GoPeusU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=aCJ31rx4PAs5I+jKlguJ6e0nbeBpMUnlPCeCGk2/qB2GedlQ0F6JxupaVQ6gxy8cIH0ppnX8d9SioYHotq8h2L/3MQ93zkL2+AKFwOgxOtlK+qPth0duEKDJMKSkYQ5qX+7VRxV4nK4d8bKNuaL5AP68HJ/33+TIs5c8C9oqNa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UH1d6Rij; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UH1d6Rij"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-69848bef5c7so6224278a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 19:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784256102; x=1784860902; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=u7CTWM7sdjLtp6WbHOEsIPC/O4fOD6uj/vimbKs1R/U=;
        b=UH1d6Rij+IXO+vqzKYvUW3uYDe1zIp6pA/X8tYknSy9rX78pZwLlaWxAsFaVqiX47c
         Zs7cJINo9L9rAvvOEYHslRnJOM10ZF6rcuuJ+iJ/DBa4JatrKNszNI4RObFW/2gxvOZx
         k/KWGJDwc6QKRkFaaHicTNiOCNEjVu422NrpaU+c0Vptq61rsdjnam2+xUtfUOqe2D0p
         R8zjS8qkmhmgvsho7/TGHHsFB8LwGQM1SPCOMph2gOY0inuLvFAP6nSA4J93p4OHwk35
         /TnbakS0RSNkA6zv93jwG2oEwBvjkbMvb3UPkirJQD7s9jWHEQMC8yKGGNAAmDezCLJX
         YXEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784256102; x=1784860902;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u7CTWM7sdjLtp6WbHOEsIPC/O4fOD6uj/vimbKs1R/U=;
        b=omohpgqhrmV6boO6TDmVV8dts7zsrjBQmLywgQcmhbKx3YfnkIG1tnKY6wMxKjEtUb
         wFTRYQua6YJ1geu+a9h+FNEtFGLrSoiMTAm4FWttCz/1fWYG32h9wESk2ZLxVkZ7X+pS
         5c9UEIGwHCIIv+1uylsZsl/XI6IzmBbJVyOV+PGJX97FINa28fUAiGGzAdfwL6scXHzS
         kXRYKjX4IBgUH/qlJ5Mf1aiqfr1DrLyeIA+flWnwZXznUK7vBNWyZt4jMmL2ZJQDoNPP
         S9FxJP5BDODgXnk2Ezlc1DfLPoj9SjOGwSmsEESNPvlK3eKHunoB0JSUla8yC8Ka40Yx
         VVTg==
X-Forwarded-Encrypted: i=1; AHgh+RrIm+VrVlJIP6GedV0FtE9qBZY68qwjIZwU0IPXXiUBVg51orzD1/27EKU+f/mUaezu5GOEVrBEo7x0@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5EN7f1iTfGYWw0JWPztrn15vzsbvhFIX+He2Ka5MMqd7wWWpJ
	gPmfAM1qnUA77w14vGGay79aN8yiTtV+amOWfRebUrZvHFRmc8dDsfnwB9yYOu4h1O9Rs1tC6Q0
	KdWBOPixMoGpdxE62vQ==
X-Received: from edyn5.prod.google.com ([2002:a05:6402:6c5:b0:69c:7a06:8c86])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5288:b0:69a:f82:ccdc with SMTP id 4fb4d7f45d1cf-69e652ed727mr118048a12.19.1784256101944;
 Thu, 16 Jul 2026 19:41:41 -0700 (PDT)
Date: Thu, 16 Jul 2026 23:04:04 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260716230411.2767394-1-tarunsahu@google.com>
Subject: [PATCH v19 0/7] shut down devices asynchronously
From: Tarun Sahu <tarunsahu@google.com>
To: Shuah Khan <skhan@linuxfoundation.org>, Danilo Krummrich <dakr@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Rafael J. Wysocki" <rafael@kernel.org>
Cc: bvanassche@acm.org, john.g.garry@oracle.com, mlombard@redhat.com, 
	loberman@redhat.com, mclapinski@google.com, dmatlack@google.com, 
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, jordanrichards@google.com, souravsgl@google.com, 
	stuart.w.hayes@gmail.com, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, emilne@redhat.com, jmeneghi@redhat.com, 
	linux-scsi@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"

This is rebased on top of device-core/driver-core-next. And can also
be applied easily against linux-next/master

This patchset allows the kernel to shutdown devices asynchronously and
unrelated async devices to be shut down in parallel to each other.

Only devices which explicitly enable it are shut down asynchronously. The
default is for a device to be shut down from the synchronous shutdown loop.

This can dramatically reduce system shutdown/reboot time on systems that
have multiple devices that take many seconds to shut down (like certain
NVMe drives). On one system tested, the shutdown time went from 11 minutes
without this patch to 55 seconds with the patch. And on another system from
80 seconds to 11.

And thank you to everyone who has spent some of their valuable time
providing reviews, suggestions, criticisms, or tests on the various
iterations of this patchset.

Changes from V18:
- Fix deadlock and race condition on concurrent device_add
- Use local variable to device_shutdown for caching async_shutdown
- Added dev->p check to avoid NULL pointer deference and tell if the
  device is not registered so no need to be shutdown. This is to handle
  the cases when devices consumers list might have devices that are not
  yet registered.

Changes from V17:

Fix mangled text in kernel parameter description
Re-protect the list removal with the spinlock
  * Hold a device reference to ensure the device cannot be freed before
    attempting list removal

Changes from V16:

Drop spinlock before async subsystem call which uses GFP_KERNEL
Handle that async shutdown can widen races between device shutdown and deletion
  * __shutdown_one_device will immediately return if a device is dead
  * Set shutdown device completion to complete when marking a device dead to
      prevent waiting on a dead device
  * Only late-access a parent pointer if device is in a non-dead state to
      ensure the pointer is still valid

Changes from V15:

The async_shutdown bit field is converted to a device flags bit
Convert all patches to use the flag bit accessor macros to set or check if
  async shutdown should be used
Added documentation on the kernel parameter to control use of async shutdown

Changes from V14:

Remove unneeded use of '!!' with boolean type

Changes from V13:

Remove duplicate flagging of async shutdown on scsi hosts/targets/devices

Changes from V12:

Only acquire a parent reference if acquiring the parent's lock
device_enable_async_shutdown should return void
Minor comment and description cleanups

Changes from V11:

  * Swap the order of the first two patches
  * Rework conditional parent locking so that lock and unlock no longer use
    separate conditional checks
  * Remove an used variable
  * Comment and description text cleanups

Changes from V10:

Reworked to more closely match the design used for async suspend
  * No longer uses async subsystem cookies for synchronization
  * Minimized changes to struct device
  * Enable async shutdown for pci and scsi devices which support async suspend

Changes from V9:

Address resource and timing issues when spawning a unique async thread
for every device during shutdown:
  * Make the asynchronous threads able to shut down multiple devices,
    instead of spawning a unique thread for every device.
  * Modify core kernel async code with a custom wake function so it
    doesn't wake up a thread waiting to synchronize on a cookie until
    the cookie has reached the desired value, instead of waking up
    every waiting thread to check the cookie every time an async thread
    ends.

Changes from V8:

Deal with shutdown hangs resulting when a parent/supplier device is
  later in the devices_kset list than its children/consumers:
  * Ignore sync_state_only devlinks for shutdown dependencies
  * Ignore shutdown_after for devices that don't want async shutdown
  * Add a sanity check to revert to sync shutdown for any device that
    would otherwise wait for a child/consumer shutdown that hasn't
    already been scheduled

Changes from V7:

Do not expose driver async_shutdown_enable in sysfs.
Wrapped a long line.

Changes from V6:

Removed a sysfs attribute that allowed the async device shutdown to be
"on" (with driver opt-out), "safe" (driver opt-in), or "off"... what was
previously "safe" is now the only behavior, so drivers now only need to
have the option to enable or disable async shutdown.

Changes from V5:

Separated into multiple patches to make review easier.
Reworked some code to make it more readable
Made devices wait for consumers to shut down, not just children
  (suggested by David Jeffery)

Changes from V4:

Change code to use cookies for synchronization rather than async domains
Allow async shutdown to be disabled via sysfs, and allow driver opt-in or
  opt-out of async shutdown (when not disabled), with ability to control
  driver opt-in/opt-out via sysfs

Changes from V3:

Bug fix (used "parent" not "dev->parent" in device_shutdown)

Changes from V2:

Removed recursive functions to schedule children to be shutdown before
  parents, since existing device_shutdown loop will already do this

Changes from V1:

Rewritten using kernel async code (suggested by Lukas Wunner)

David Jeffery (5):
  driver core: separate function to shutdown one device
  driver core: do not always lock parent in shutdown
  driver core: async device shutdown infrastructure
  PCI: Enable async shutdown support
  scsi: Enable async shutdown support

Tarun Sahu (2):
  device_core: rely on put_device to free dev->p
  driver core: Prevent device_add() during system shutdown

 .../admin-guide/kernel-parameters.txt         |  10 +
 drivers/base/base.h                           |   2 +
 drivers/base/core.c                           | 265 +++++++++++++++---
 drivers/pci/probe.c                           |   2 +
 drivers/scsi/hosts.c                          |   2 +
 drivers/scsi/scsi_sysfs.c                     |   3 +
 include/linux/device.h                        |   2 +
 7 files changed, 248 insertions(+), 38 deletions(-)

-- 
2.55.0.229.g6434b31f56-goog

