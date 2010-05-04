From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 0/9] blk: scsi: blk abort queue updates
Date: Mon,  3 May 2010 20:36:59 -0700
Message-ID: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50321 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab0EDDhh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 May 2010 23:37:37 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e3.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o443P32u005617
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:25:03 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o443bacZ1421402
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:37:36 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o443bZcj018771
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:37:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axobe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com

  This patch series has three sections explained below. The patches are
  presented as a series as they hit some common functions and may need to
  be applied in order to avoid conflicts.

  1.) Avoid possibly waking up the error handler on a queue that it stopped.
  blk: Do not abort requests if queue is stopped

  2.) It is possible to have a request on the elevator that is already
  prepped. The prepped resources should be released also. This was seen under
  heavy IO load while a lot of requeue activity as going occurring.

  blk: In elv_abort_queue skip requests with REQ_DONTPREP set
  blk: Add a unprep_rq_fn
  blk: Call unprep_fn from elv_abort_queue is available
  scsi: Add a scsi_unprep_fn

  3.) These four patches add a flag to a request indicating that a block
  abort has been called on the request. It also adds a common
  scsi_requeue_request so that the flag can be checked in only one location
  on a attempt to requeue.
  
  Currently we may abort a request and post error recovery the request can
  be requeued. We may also try to abort a request that is in the process of
  completing that we would like to prevent a requeue on. 
  
  The abort flag is different than a fast fail flag in that it is provides a
  hint that the request should be returned as soon as possible (i.e. do not
  requeue even if disposition indicates that it would be allowed). 
  
  The change allowed failovers that where exceeding (SD_MAX_RETRIES * IO
  TIMEOUT) to be able to failover in less than a single timeout (the less
  than case depended on the type of event that triggered the path failure).

  blk: Add request atomic flag for abort
  blk: Mark requests aborted
  scsi: Add scsi_requeue_request function
  scsi: Add blk_request_aborted check

  I tested the patches on a IBM,2105800 connected through a zfcp adapter,
  a IBM,1815 through a qlogic adapter, and scsi_debug.


 block/blk-settings.c    |   17 +++++++++++
 block/blk-timeout.c     |   19 +++++++++++-
 block/blk.h             |   14 +++++++++
 block/elevator.c        |   25 ++++++++++++++--
 drivers/scsi/scsi_lib.c |   73 +++++++++++++++++++++++++++++++---------------
 include/linux/blkdev.h  |    4 ++
 6 files changed, 123 insertions(+), 29 deletions(-)

