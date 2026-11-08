Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.223
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170873;
	b=X707sW3yi4KOCqkmKgWYZR5AyctLR9IZ7iL3e66UIDbTG5hsyUi7hrcnafCebMZiV4Ab
	 +85dndm89vWrO9PNRuvcse1UISimsbKmMtaVkQXn9Q8XlU47AdiVKugdx/uPkhKADGFWF
	 tZhghfTCTuSK2UNGPIBOh3JhSkZsrNM7dDV69yG4LGHYoRrWHGJ2w9pKXpGWLBzq9kvEs
	 mi7fdvz+IYJKhuYHBbX0ewnzHcTr2skY6DNo6ncWVt8lbyoOaK54qZTgIwUAaXFc/iFY0
	 p/+e4m7juokvTLl82Nlmov3Zh3DmXgXE13lvZmvxCuJOjw1GTfU03552ulwvnRXSprA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170873;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=xjhWBUZih10V7YJdGXZxprUPzNAlZFyeQN11ftb+jJ0=;
	b=Of8TmZUqhgWnMXXlEvSL9SbYVLQcECKesc/0GVfNQadzEqPkPpalbsiQIVYq9ry5PR0Y
	 UoETKGM+SkPKfByCzo0QTxG2Fy/vho9hT08bJzY7E/jrjoPuNbu0M4ZfV6MW/9eqtm7Uc
	 X4WvwqQrjlX9iayay+3qajVrbXAJVJ1KDLio1SEEmlzqyKAz//ECOylaq0qngs/sEwdfw
	 5LO225WWc6UwY8n96aIPYfJeKp03CbjyrZjaR3Rej57zZgw+W7V5COt0P/NxR6B3jYxpO
	 k0+afWr1xxN1Z0SSUzbQYn50gFtdIYhNqNdg/kzqmhGg99z3RuU40Qev+yt3MqXHBfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=W52V0x6q;
	arc=none smtp.remote-ip=91.218.175.223
Received: from mta0.migadu.com (out-223.mta0.migadu.com [91.218.175.223])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B4B606A31C
	for <linux-scsi@vger.kernel.org>; Sun,  8 Nov 2026 20:47:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30B4B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=W52V0x6q
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=2rsZwfjFMq/a1Kzo/urx8D8cn0WOpZhxUsbpq63LXSg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170869; v=1; x=1794775669;
 b=W52V0x6qMUBB5Rr/auBLIUKg0y/4UxEcPe1QEZLpfuZ/70uD7UwyLxNTNEoAJkbGQh/SeEhp
 X2qsFbphdp/sOHw81JonEDdNxcPOP2TLYjQVVwXb0G6A9FUFmFM8Om5dMbSS8Dx6Q9EKKxTC2/B
 mQ+kbZ6LgAVcAKGEudEiiJdE=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id dd57490ad9f8d74e;
	Sun, 08 Nov 2026 20:47:49 +0000
X-Mizu-Trace-ID: dd57490ad9f8d74e
X-Migadu-Flow: FLOW_OUT
From: John Garry <john.garry@linux.dev>
To: james.bottomley@hansenpartnership.com,
	mkp@kernel.org
Cc: hare@suse.com,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	snitzer@kernel.org,
	jmeneghi@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	hch@lst.de,
	michael.christie@oracle.com,
	John Garry <john.garry@linux.dev>
Subject: [PATCH v9 00/29] Native SCSI Multipath support
Date: Sun,  8 Nov 2026 20:47:04 +0000
Message-ID: <20261108204733.557995-1-john.garry@linux.dev>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

NATIVE SCSI MULTIPATH:

This series introduces native SCSI multipath support. It is intended as
an alternative to dm-mpath.

This support aims to provide a multipath-enabled SCSI block device/
gendisk.

For a SCSI device to support native multipath, either of the following
conditions must be satisfied:
a. unique ID in VPD page 83 and ALUA support and scsi_multipath modparam
   enabled
b. unique ID in VPD page 83 and scsi_multipath_always modparam enabled

This series relies on reading sdev->access_state to get path information.
This path information would be provided by ALUA. ALUA support which does
not rely on device handlers has already been discussed at
https://lore.kernel.org/linux-scsi/7755e98f-5619-48ba-bcfc-b64eec930c40@oracle.com/
and support will be added in the next phase.

New classes of devices are added:
- scsi_mpath_device
- scsi_mpath_disk

These are required since a multipath scsi_device has no common scsi host.
An example of the sysfs files and directories for these new classes is as
follows:

$ ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/
total 0
-rw-r--r--    1 root     root          4096 Feb 25 11:59 iopolicy
drwxr-xr-x    2 root     root             0 Feb 25 11:59 multipath
drwxr-xr-x    2 root     root             0 Feb 25 11:59 power
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 subsystem ->
../../../../class/scsi_mpath_device
-rw-r--r--    1 root     root          4096 Feb 25 11:58 uevent
-r--r--r--    1 root     root          4096 Feb 25 11:59 vpd_id
$ ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 8:0:0:0 ->
../../../../platform/host8/session1/target8:0:0/8:0:0:0
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 9:0:0:0 ->
../../../../platform/host9/session2/target9:0:0/9:0:0:0
$ cat /sys/class/scsi_mpath_device/scsi_mpath_device0/vpd_id
naa.600140505200a986f0043c9afa1fd077
$ cat /sys/class/scsi_mpath_device/scsi_mpath_device0/iopolicy
numa
$

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/
total 0
drwxr-xr-x    2 root     root             0 Feb 25 12:00 power
drwxr-xr-x   11 root     root             0 Feb 25 11:58 sdc
lrwxrwxrwx    1 root     root             0 Feb 25 11:58 subsystem ->
../../../../class/scsi_mpath_disk
-rw-r--r--    1 root     root          4096 Feb 25 11:58 uevent
$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 25 12:00 sdc:0 ->
../../../../../platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 25 12:00 sdc:1 ->
../../../../../platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1

$ ls -l /dev/sdc
brw-rw----    1 root     disk        8,  32 Feb 25 11:58 /dev/sdc

The scsi_device and scsi_disk classes otherwise remain unmodified.
However, the per-path block device is hidden in /dev/. Furthermore,
multipathed block devices have a new naming scheme, sdX:Y, where
X is the scsi multipath device index and Y is the path index.

No multipath sg support is added. We still have a per-path sg device.
Since the SCSI block device is multipath enabled, we can access
multipathed scsi_ioctl() through that block device.

For failover, we take the approach of cloning bio's and re-submitting them
in full (for failover errors).

LIBMULTIPATH:

This series introduces also libmultipath. It is essentially a refactoring
of NVME multipath support, so we can have a common library to also support
native SCSI multipath.

Much of the code is taken directly from the NVMe multipath code. However,
NVMe specifics are removed. A template structure is provided so the driver
-may provide callbacks for driver specifics, like ANA support for NVMe.

Important new structures introduced include:

- mpath_head
These contain much of the multipath-specific functionality from
nvme_ns_head, including a pointer to the gendisk structure and
a path SRCU-based array.

- mpath_device
This is the per-path structure, and contains much the same
multipath-specific functionality in nvme_ns

libmultipath provides functionality for path management, path selection,
data path, and failover handling.

Full series also available at
https://github.com/johnpgarry/linux/tree/scsi-multipath-v7.4-v9

Differences to v8:
- Rebase
- Hardening changes advised by sashiko, including "Clear cmd->flags"
  change

Differences to v7:
- rebase
- simplify scsi_mpath_clone_end_io() (sashiko)
- rename bio_list_add_clone() -> bio_list_add_master()
- rework checks in mpath_alloc_disk_head() (sashiko)

John Garry (29):
  scsi: core: Clear cmd->flags for terminal queuing error
  libmultipath: Add initial framework
  libmultipath: Add basic gendisk support
  libmultipath: Add path selection support
  libmultipath: Add bio handling
  libmultipath: Add support for mpath_device management
  libmultipath: Add delayed removal support
  libmultipath: Add sysfs helpers
  libmultipath: Add support for block device IOCTL
  libmultipath: Add mpath_bdev_getgeo()
  libmultipath: Add mpath_bdev_get_unique_id()
  scsi-multipath: introduce basic SCSI device support
  scsi-multipath: introduce scsi_device head structure
  scsi-multipath: provide sysfs link from to scsi_device
  scsi-multipath: support iopolicy
  scsi-multipath: clone each bio
  scsi-multipath: clear path when device is blocked
  scsi-multipath: revalidate paths upon device unblock
  scsi-multipath: failover handling
  scsi-multipath: provide callbacks for path state
  scsi-multipath: add scsi_mpath_{start,end}_request()
  scsi-multipath: update request for terminal request queuing error
  scsi-multipath: add delayed disk removal support
  scsi: sd: add multipath disk class
  scsi: sd: add multipath disk attr groups
  scsi: sd: support multipath disk
  scsi: sd: add mpath_dev file
  scsi: sd: add mpath_numa_nodes dev attribute
  scsi: sd: add mpath_queue_depth dev attribute

 drivers/scsi/Kconfig          |  10 +
 drivers/scsi/Makefile         |   1 +
 drivers/scsi/scsi.c           |   8 +-
 drivers/scsi/scsi_lib.c       |  20 +-
 drivers/scsi/scsi_multipath.c | 691 +++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c      |   4 +
 drivers/scsi/scsi_sysfs.c     |  10 +
 drivers/scsi/sd.c             | 611 +++++++++++++++++++++-
 drivers/scsi/sd.h             |   3 +
 include/linux/multipath.h     | 156 ++++++
 include/scsi/scsi_cmnd.h      |   9 +-
 include/scsi/scsi_device.h    |   2 +
 include/scsi/scsi_driver.h    |   4 +
 include/scsi/scsi_host.h      |   4 +
 include/scsi/scsi_multipath.h | 129 +++++
 lib/Kconfig                   |   6 +
 lib/Makefile                  |   2 +
 lib/multipath.c               | 948 ++++++++++++++++++++++++++++++++++
 18 files changed, 2592 insertions(+), 26 deletions(-)
 create mode 100644 drivers/scsi/scsi_multipath.c
 create mode 100644 include/linux/multipath.h
 create mode 100644 include/scsi/scsi_multipath.h
 create mode 100644 lib/multipath.c

-- 
2.43.0

