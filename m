From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] 0/7 per scsi_device queue lock patches
Date: Mon, 24 Mar 2003 17:53:37 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030324175337.A14957@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay04.boulder.ibm.com (westrelay04.boulder.ibm.com [9.17.193.32])
	by e32.co.us.ibm.com (8.12.8/8.12.2) with ESMTP id h2P1u9Tr043768
	for <linux-scsi@vger.kernel.org>; Mon, 24 Mar 2003 20:56:09 -0500
Received: from localhost.localdomain (d03av02.boulder.ibm.com [9.17.193.82])
	by westrelay04.boulder.ibm.com (8.12.8/NCO/VER6.5) with ESMTP id h2P1vAVR161182
	for <linux-scsi@vger.kernel.org>; Mon, 24 Mar 2003 18:57:10 -0700
Received: (from patman@localhost)
	by localhost.localdomain (8.11.2/8.11.6) id h2P1rbW14993
	for linux-scsi@vger.kernel.org; Mon, 24 Mar 2003 17:53:37 -0800
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches against recent 2.5.x bk (pulled on march 24, should
apply fine on top of 2.5.66) leads to splitting the scsi queue_lock into a
pre-scsi_device lock rather than the current per-scsi_host lock.

The first 2 patches were already posted and discussed, and include changes
based on that discussion.

Hopefully there are no major issues with the first 4 patches - I would
like to have them pushed for inclusion in 2.5.

Patches are incremental (they overlap).

Patch descriptions:

patch 1: starved changes - use a list_head for starved queue's
patch 2: add missing scsi_queue_next_request calls
patch 3: consolidate single_lun code (this code goes away with patch 7)
patch 4: cleanup/consolidate code in scsi_request_fn
patch 5: alloc a request_queue on each scsi_alloc_sdev call
patch 6: add and use a per-scsi_device queue_lock
patch 7: fix single_lun code for per-scsi_device queue_lock.

If you run with all patches applied let me know your results.

I've run tests across 20 drives and 2 qla 2300 adapters on an 8 CPU NUMAQ
system, using the feral driver with can_queue set to 50 and queue_depth
set to 16.

I ran with 20 processes, each process just continuously re-reads the first
block of a different disk (using O_DIRECT). Not much of a benchmark.

With all the patches applied (20 processes each reading 20000 times), I got:

1.03user 81.91system 0:28.46elapsed

Without patches:

1.09user 153.36system 0:34.61elapsed

If anyone wants, I can get vmstat or oprofile before/after results.

I ran some write-fsync tests (on file systems mounted across 20 drives),
but hitting can_queue without the starved changes causes variations in
performance numbers, and I'm getting IO hangs (with and without the above
patches, but more so without the patches). I haven't figured out what is
wrong. I'm also getting occasional hangs on boot (with or without patches,
NUMAQ + feral + isp 1020 + qla 2300). I have not had any problems on a
netfinity (more standard x86) box with an aic adapter.

Thanks.

-- Patrick Mansfield
