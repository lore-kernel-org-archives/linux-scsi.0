Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC285264A9D
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2026 13:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782913841; cv=none; b=COaJ3zXN23IlRNkkU7c5J87RqNGGZzFlMeBmNUrLfpPs9ZwiLMLHRTODIV98Nsc/yfwzp7TRZPMxgWJPE8crh/Oxsudke6E6vgwYfLdSvTgg56x4tPqNxfweVJY6xC//MA/nU4SR8GZ6kP2F+SKxq2+FJPH3X9fHNy+Dex7oh2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782913841; c=relaxed/simple;
	bh=dHu0yDEvlFpkS9qTbftJs4pE8wtPDp8WSwVutPs1f4I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iU3TbM7PUPkAIRx8rMZqRAYYpdMFaXMgAsaY/XGkdwqvI/ESgQrraNKX+Y4vMvAgmXIiLIkxSRWyLTlhtZ2o52hrMWtVccEFZgPdmfVS6Ntu1rWSbMMyvZyeiPo/7I/OdG01m5QDpjCa4Ly1hytLcs9NAQnmwvVEJr6rqF/qWUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hR8gLB8N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hR8gLB8N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782913839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fAeve0abFWQKmFbA38UTviwu1FD5ReocHzS/Zndesd8=;
	b=hR8gLB8Nd/lsOEotI6XRXCmIoUU3xbn0H0VVUGBGqvtvyLAX0fcVqoroiLp9qarxmwWBcZ
	bIQO6ZDqjUVroQG8SWvYB4/UFWh/PYjw71DAkVaVKo9lt7tg7fLiHbEuzyOcPVzbuLjjZl
	g881+a+eHNx+C2pQCUVUW82hNNX6+38=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-557-v-Dnipm5M5S3Dwi72n8B6w-1; Wed,
 01 Jul 2026 09:50:33 -0400
X-MC-Unique: v-Dnipm5M5S3Dwi72n8B6w-1
X-Mimecast-MFC-AGG-ID: v-Dnipm5M5S3Dwi72n8B6w_1782913830
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87A2418E6A56;
	Wed,  1 Jul 2026 13:50:29 +0000 (UTC)
Received: from djeffery-thinkpadp1gen3.rmtusga.csb (unknown [10.22.81.69])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 455A518007D2;
	Wed,  1 Jul 2026 13:50:23 +0000 (UTC)
From: David Jeffery <djeffery@redhat.com>
To: driver-core@lists.linux.dev,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Tarun Sahu <tarunsahu@google.com>,
	Pasha Tatashin <tatashin@google.com>,
	=?UTF-8?q?Micha=C5=82=20C=C5=82api=C5=84ski?= <mclapinski@google.com>,
	Jordan Richards <jordanrichards@google.com>,
	Ewan Milne <emilne@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>,
	"Lombardi, Maurizio" <mlombard@redhat.com>,
	Stuart Hayes <stuart.w.hayes@gmail.com>,
	Laurence Oberman <loberman@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bjorn Helgaas <helgaas@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	kexec@lists.infradead.org,
	David Jeffery <djeffery@redhat.com>
Subject: [PATCH v18 0/5] shut down devices asynchronously
Date: Wed,  1 Jul 2026 09:50:10 -0400
Message-ID: <20260701135015.81937-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

These patches are rebased against the driver-core tree's driver-core-next
branch and should also apply against recent linux-next. Changes for v18 are
contained in patch 3.

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


Stuart Hayes (2):
  driver core: separate function to shutdown one device
  driver core: do not always lock parent in shutdown

David Jeffery (3):
  driver core: async device shutdown infrastructure
  PCI: Enable async shutdown support
  scsi: Enable async shutdown support

 .../admin-guide/kernel-parameters.txt         |  10 +
 drivers/base/base.h                           |   2 +
 drivers/base/core.c                           | 221 +++++++++++++++---
 drivers/pci/probe.c                           |   2 +
 drivers/scsi/hosts.c                          |   2 +
 drivers/scsi/scsi_sysfs.c                     |   3 +
 include/linux/device.h                        |   2 +
 7 files changed, 206 insertions(+), 36 deletions(-)

-- 
2.53.0

