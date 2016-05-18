From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: BLKZEROOUT not zeroing md dev on VMDK
Date: Wed, 18 May 2016 23:39:30 +0100
Message-ID: <20160518223616.GA409@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36668 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbcERWjh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2016 18:39:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Arvind Kumar <arvindkumar@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

With Ubuntu's 4.4.0-22-generic kernel and a Fedora 23
4.6.0-1.vanilla.knurd.1.fc23.x86_64 kernel I've found that the
BLKZEROOUT syscall can malfunction and not zero data.

When BLKZEROOUT is issued to an MD device atop a PVSCSI controller
supplied VMDK from ESXi 6.0 the call returns immediately and with a zero
return code. Unfortunately, inspecting the data on the MD device shows
that it has not been zeroed and is in fact untouched. The easiest way to
see this behaviour is to boot the VM, create an mdadm device atop
/dev/sd?, scribble some non-zero value on the disk and then use
blkdiscard --zeroout /dev/md??? . If you then inspect the MD disk (e.g.
with hexdump) you will still see the old data and using POSIX_FADV_DONTNEED
on the MD device doesn't change the outcome.

The only clue I've seen is that
/sys/block/sd?/queue/write_same_max_bytes starts out being 33553920 but
after a WRITE SAME is issued it becomes 0. If the MD device is created
after write_same_max_bytes has become 0 on the backing disk then
BLKZEROOUT seems to work correctly.

-- 
Sitsofe | http://sucs.org/~sits/
