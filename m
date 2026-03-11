Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D89336EC9
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 17:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773249087; cv=none; b=EmKyjfVZ3T1yUuK/YTyVnrzVCUkoHJcj3BDbwwnZ5RdZYuLl4Gtx9lCltpT+FbcF4mClUBtcNkihn8KPwutkfEKNiUyc7VJ08418/424kdcGrZdlCxpByBnee5hB6uwJvWAFAXKTL7XgQ+BrW3aoJ++XqHNJnLpt5+yD+z7lnoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773249087; c=relaxed/simple;
	bh=qaDW1rlJwUjkIWcyl4+QVoiQZUR+OmKLv5OwmyNHK/0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zj92lt09AoK4IxuRUUMDZoNJOunv9Fv8ElW9DzZEEConagxOM6sEBmEsUYTzmw8LC0lzm4qxfZ2vZT7ucwY0oMZsD0P22kOuk7CE+mEkkEPoLVEbtfjSOTR95EKwinykPLxXu/hg1TcceSX76sNVufCCVWGH1Eg8rgeMqisCwn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I3IFYQwA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I3IFYQwA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773249085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wixjc/Swdulnd/bnCnUOttbqhkYwlaCgcb9KrQHl3zM=;
	b=I3IFYQwAh9nG7IrMRZumXwX9jS/SfrKGor8/yolfM9yke8D4oXHhWxfXrf8mRVo63jVDUZ
	f3W1ju9IqzWJEceU+4AwOdBdR+NTCyJrYQcrHkwIxjXs1yVnTfU5HniZEjwpeA5h6Xl9qo
	GHVnocQkedd9XD2l4JWbfmo+BE68eYk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-512-abupHt5QPWWU8NTQIUKzAA-1; Wed,
 11 Mar 2026 13:11:22 -0400
X-MC-Unique: abupHt5QPWWU8NTQIUKzAA-1
X-Mimecast-MFC-AGG-ID: abupHt5QPWWU8NTQIUKzAA_1773249080
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 624AB1956050;
	Wed, 11 Mar 2026 17:11:20 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.81.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 752EB30002D2;
	Wed, 11 Mar 2026 17:11:16 +0000 (UTC)
From: David Jeffery <djeffery@redhat.com>
To: linux-kernel@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-pci@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Cc: Tarun Sahu <tarunsahu@google.com>,
	Pasha Tatashin <tatashin@google.com>,
	=?UTF-8?q?Micha=C5=82=20C=C5=82api=C5=84ski?= <mclapinski@google.com>,
	Jordan Richards <jordanrichards@google.com>,
	Ewan Milne <emilne@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>,
	"Lombardi, Maurizio" <mlombard@redhat.com>,
	David Jeffery <djeffery@redhat.com>
Subject: [PATCH v11 0/5] shut down devices asynchronously
Date: Wed, 11 Mar 2026 13:09:51 -0400
Message-ID: <20260311170956.9146-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

This patchset allows the kernel to shutdown devices asynchronously and
unrelated async devices to be shut down in parallel to each other.

Only devices which explicitly enable it are shut down asynchronously. The
default is for a device to be shut down from the synchronous shutdown loop.

This can dramatically reduce system shutdown/reboot time on systems that
have multiple devices that take many seconds to shut down (like certain
NVMe drives). On one system tested, the shutdown time went from 11 minutes
without this patch to 55 seconds with the patch. And on another system from
80 seconds to 11.

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
  driver core: don't always lock parent in shutdown
  driver core: separate function to shutdown one device

David Jeffery (3):
  driver core: async device shutdown infrastructure
  pci: enable async shutdown support
  scsi: enable async shutdown support

 drivers/base/base.h       |   2 +
 drivers/base/core.c       | 165 +++++++++++++++++++++++++++++++-------
 drivers/pci/probe.c       |   1 +
 drivers/scsi/hosts.c      |   3 +
 drivers/scsi/scsi_scan.c  |   1 +
 drivers/scsi/scsi_sysfs.c |   4 +
 include/linux/device.h    |  13 +++
 7 files changed, 160 insertions(+), 29 deletions(-)

-- 
2.53.0

