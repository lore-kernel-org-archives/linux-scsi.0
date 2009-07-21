From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 2 0/4] cciss rmmod/scan-thread fixes
Date: Tue, 21 Jul 2009 13:55:17 -0600
Message-ID: <20090721195517.20740.18994.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:2126 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbZGUTzT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2009 15:55:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, mike.miller@hp.com, jens.axboe@oracle.com

The following series fixes several problems causing hangs while
rmmoding the cciss driver. In the process of fixing these hangs, I
also reworked the the logical drive scanning kernel thread to use one
thread per driver rather than one thread per controller. I also added
a sysfs attribute to kick off a controller scan.

Changelog

v2

Staticially initialize scan_mutex and scan_q.
Remove unneeded function declarations.
Added a patch that uses a mutex to indicate we are busy initializing
rather than a integer flag.
Remove a possible scan race by moving the busy_initializing unlock after
the call to rebuild_luntable in cciss_init_one.
Reworked the scan thread to use a more traditional loop with a
set_current_state(TASK_INTERRUPTIBLE); schedule() at the top of the
loop.

 .../ABI/testing/sysfs-bus-pci-devices-cciss        |    7 +
 drivers/block/cciss.c                              |  204 +++++++++++++++++---
 drivers/block/cciss.h                              |    9 +
 3 files changed, 191 insertions(+), 29 deletions(-)

Andrew Patterson (4):
      cciss: remove logical drive sysfs entries during driver cleanup.
      cciss: use mutex instead of flag to indicate busy initializing
      cciss: use only one scan thread
      cciss: kick off logical drive topology rescan through sysfs



-- 
Andrew Patterson
