Received: from mta0.migadu.com (out-167.mta0.migadu.com [91.218.175.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526501E5B88
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 17:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790183796; cv=none; b=qvolcZx3ZmVTXRpVawU8uimu6kzMTCas0yr0BApE0AMgTT44QdCPLl7wW0XEzxZDTcrDYtSn7GbV1Qd+MVIVRDalgipKRTYy4m+BJMPiHZVILTDhfDHmpCbIsbwSighOisMk9MwubT5qR0J6kLFNuEyFXIr+hsUDO2C7fflbxnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790183796; c=relaxed/simple;
	bh=OZWCIjfQvJGYe9SmrpS0lHhTXSEFx29Lz36+6DEDDE0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MeIfL/uq6sl5V7gw3t97kPod2RFNSsQpb8vK04nVDII2oYsvq0oRztyQ7rAhSES6AQ5K47WpWhS5eOo3hbZBWBpUHk1hAOHB3CXdmTwRLVL3P2tKpcD/2TTHKi38iySL548fnYzVOREyYx1aAsrA/LDIh9qhsY5yDhDxDuvcrGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TWL4hcvw; arc=none smtp.client-ip=91.218.175.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TWL4hcvw"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OZWCIjfQvJGYe9SmrpS0lHhTXSEFx29Lz36+6DEDDE0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790183792; v=1; x=1790788592;
 b=TWL4hcvw4LU9ylfwV8bL0yNFy5DJkoI+5KqwK+mBfH4kvKZJ0ew5pPTKA95IEWd92d3FpjOc
 7ys8MkTJ5vtAKTWhhfCwInPhIIR10Eq3KYDeMWS15jGpDnPornS52zJhJgOQoycjMnKsLfYKKC/
 6e5qAnQ1/rE03mnv1RVKtwzQ=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 12e675c5567fe32c;
	Wed, 23 Sep 2026 17:16:21 +0000
X-Mizu-Trace-ID: 12e675c5567fe32c
X-Migadu-Flow: FLOW_OUT
Message-ID: <94253b72-0c93-4560-8a96-b2ec1e8b1fa3@linux.dev>
Date: Wed, 23 Sep 2026 18:16:17 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/27] Native SCSI Multipath support
To: John Garry <john.g.garry@oracle.com>,
 james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, michael.christie@oracle.com, snitzer@kernel.org,
 bmarzins@redhat.com, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 nilay@linux.ibm.com, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/7/26 11:49, John Garry wrote:
> NATIVE SCSI MULTIPATH:
> 

JFYI, this passes a sanity test on mkp scsi 7.4 queue after all the 
recent sense codes changes, as would be expected.

> This series introduces native SCSI multipath support. It is intended as
> an alternative to dm-mpath.
> 
> This support aims to provide a multipath-enabled SCSI block device/
> gendisk.
> 
> For a SCSI device to support native multipath, either of the following
> conditions must be satisfied:
> a. unique ID in VPD page 83 and ALUA support and scsi_multipath modparam
>     enabled
> b. unique ID in VPD page 83 and scsi_multipath_always modparam enabled
> 
> This series relies on reading sdev->access_state to get path information.
> This path information would be provided by ALUA. ALUA support which does
> not rely on device handlers has already been discussed at
> https://lore.kernel.org/linux-scsi/7755e98f-5619-48ba-bcfc-b64eec930c40@oracle.com/
> and support will be added in the next phase.
> 
> New classes of devices are added:
> - scsi_mpath_device
> - scsi_mpath_disk
> 
> These are required since a multipath scsi_device has no common scsi host.
> An example of the sysfs files and directories for these new classes is as
> follows:
> 
> $ ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/
> total 0
> -rw-r--r--    1 root     root          4096 Feb 25 11:59 iopolicy
> drwxr-xr-x    2 root     root             0 Feb 25 11:59 multipath
> drwxr-xr-x    2 root     root             0 Feb 25 11:59 power
> lrwxrwxrwx    1 root     root             0 Feb 25 11:59 subsystem ->
> ../../../../class/scsi_mpath_device
> -rw-r--r--    1 root     root          4096 Feb 25 11:58 uevent
> -r--r--r--    1 root     root          4096 Feb 25 11:59 vpd_id
> $ ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/multipath/
> total 0
> lrwxrwxrwx    1 root     root             0 Feb 25 11:59 8:0:0:0 ->
> ../../../../platform/host8/session1/target8:0:0/8:0:0:0
> lrwxrwxrwx    1 root     root             0 Feb 25 11:59 9:0:0:0 ->
> ../../../../platform/host9/session2/target9:0:0/9:0:0:0
> $ cat /sys/class/scsi_mpath_device/scsi_mpath_device0/vpd_id
> naa.600140505200a986f0043c9afa1fd077
> $ cat /sys/class/scsi_mpath_device/scsi_mpath_device0/iopolicy
> numa
> $
> 
> $ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/
> total 0
> drwxr-xr-x    2 root     root             0 Feb 25 12:00 power
> drwxr-xr-x   11 root     root             0 Feb 25 11:58 sdc
> lrwxrwxrwx    1 root     root             0 Feb 25 11:58 subsystem ->
> ../../../../class/scsi_mpath_disk
> -rw-r--r--    1 root     root          4096 Feb 25 11:58 uevent
> $ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/
> total 0
> lrwxrwxrwx    1 root     root             0 Feb 25 12:00 sdc:0 ->
> ../../../../../platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
> lrwxrwxrwx    1 root     root             0 Feb 25 12:00 sdc:1 ->
> ../../../../../platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1
> 
> $ ls -l /dev/sdc
> brw-rw----    1 root     disk        8,  32 Feb 25 11:58 /dev/sdc
> 
> The scsi_device and scsi_disk classes otherwise remain unmodified.
> However, the per-path block device is hidden in /dev/. Furthermore,
> multipathed block devices have a new naming scheme, sdX:Y, where
> X is the scsi multipath device index and Y is the path index.
> 
> No multipath sg support is added. We still have a per-path sg device.
> Since the SCSI block device is multipath enabled, we can access
> multipathed scsi_ioctl() through that block device.
> 
> For failover, we take the approach of cloning bio's and re-submitting them
> in full (for failover errors).
> 
> LIBMULTIPATH:
> 
> This series introduces also libmultipath. It is essentially a refactoring
> of NVME multipath support, so we can have a common library to also support
> native SCSI multipath.
> 
> Much of the code is taken directly from the NVMe multipath code. However,
> NVMe specifics are removed. A template structure is provided so the driver
> -may provide callbacks for driver specifics, like ANA support for NVMe.
> 
> Important new structures introduced include:
> 
> - mpath_head
> These contain much of the multipath-specific functionality from
> nvme_ns_head, including a pointer to the gendisk structure and
> a path SRCU-based array.
> 
> - mpath_device
> This is the per-path structure, and contains much the same
> multipath-specific functionality in nvme_ns
> 
> libmultipath provides functionality for path management, path selection,
> data path, and failover handling.
> 
> Full series also available at
> https://github.com/johnpgarry/linux/commits/scsi-multipath-v7.3-v8/
> 
> Differences to v7:
> - rebase
> - simplify scsi_mpath_clone_end_io() (sashiko)
> - rename bio_list_add_clone() -> bio_list_add_master()
> - rework checks in mpath_alloc_disk_head() (sashiko)
> 
> Differences to v6:
> - rebase
> - add scsi_mpath_get_head()
> 
> Differences to v5:
> - deal with issues sashiko found in libmultipath:
>   - include wait_bit.h
>   - don't store error in mpath_head->disk
>   - use check_mul_overflow() in mpath_can_remove_head()
>   - use -ENOTTY in mpath_bdev_ioctl()
> - deal with issues sashiko found in scsi mpath support:
>   - check 0 returned from scsi_vpd_lun_id()
>   - call flush_work() in scsi_mpath_device_iopolicy_store()
>   - clear SCMD_MPATH_IO_STATS for !bio in scsi_mpath_start_request()
>   - add checks for calling scsi_mpath_{start,end}_request()
>   - tweak sd_mpath_dev_show()
> 
> John Garry (27):
>    libmultipath: Add initial framework
>    libmultipath: Add basic gendisk support
>    libmultipath: Add path selection support
>    libmultipath: Add bio handling
>    libmultipath: Add support for mpath_device management
>    libmultipath: Add delayed removal support
>    libmultipath: Add sysfs helpers
>    libmultipath: Add support for block device IOCTL
>    libmultipath: Add mpath_bdev_getgeo()
>    libmultipath: Add mpath_bdev_get_unique_id()
>    scsi-multipath: introduce basic SCSI device support
>    scsi-multipath: introduce scsi_device head structure
>    scsi-multipath: provide sysfs link from to scsi_device
>    scsi-multipath: support iopolicy
>    scsi-multipath: clone each bio
>    scsi-multipath: clear path when device is blocked
>    scsi-multipath: revalidate paths upon device unblock
>    scsi-multipath: failover handling
>    scsi-multipath: provide callbacks for path state
>    scsi-multipath: add scsi_mpath_{start,end}_request()
>    scsi-multipath: add delayed disk removal support
>    scsi: sd: add multipath disk class
>    scsi: sd: add multipath disk attr groups
>    scsi: sd: support multipath disk
>    scsi: sd: add mpath_dev file
>    scsi: sd: add mpath_numa_nodes dev attribute
>    scsi: sd: add mpath_queue_depth dev attribute
> 
>   drivers/scsi/Kconfig          |  10 +
>   drivers/scsi/Makefile         |   1 +
>   drivers/scsi/scsi.c           |   8 +-
>   drivers/scsi/scsi_lib.c       |  13 +-
>   drivers/scsi/scsi_multipath.c | 664 ++++++++++++++++++++++++
>   drivers/scsi/scsi_scan.c      |   4 +
>   drivers/scsi/scsi_sysfs.c     |  10 +
>   drivers/scsi/sd.c             | 611 +++++++++++++++++++++-
>   drivers/scsi/sd.h             |   3 +
>   include/linux/multipath.h     | 156 ++++++
>   include/scsi/scsi_cmnd.h      |   9 +-
>   include/scsi/scsi_device.h    |   2 +
>   include/scsi/scsi_driver.h    |   4 +
>   include/scsi/scsi_host.h      |   4 +
>   include/scsi/scsi_multipath.h | 124 +++++
>   lib/Kconfig                   |   6 +
>   lib/Makefile                  |   2 +
>   lib/multipath.c               | 947 ++++++++++++++++++++++++++++++++++
>   18 files changed, 2554 insertions(+), 24 deletions(-)
>   create mode 100644 drivers/scsi/scsi_multipath.c
>   create mode 100644 include/linux/multipath.h
>   create mode 100644 include/scsi/scsi_multipath.h
>   create mode 100644 lib/multipath.c
> 

