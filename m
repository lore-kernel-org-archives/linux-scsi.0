From: Liu Ping Fan <kernelfans@gmail.com>
Subject: [RFC 0/9] fix for the race issue between scsi timer and in-flight scmd
Date: Fri, 30 May 2014 16:15:38 +0800
Message-ID: <1401437747-2097-1-git-send-email-pingfank@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:35338 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaE3IMq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 May 2014 04:12:46 -0400
Received: by mail-yh0-f46.google.com with SMTP id 29so1287371yhl.19
        for <linux-scsi@vger.kernel.org>; Fri, 30 May 2014 01:12:45 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Jeff Moyer <jmoyer@redhat.com>

When running io stress test on large latency scsi-disk, e.g guest with virtscsi
on a nfs image. It can trigger the BUG_ON(test_bit(REQ_ATOM_COMPLETE, &req->atomic_flags));
in blk_start_request().
Since there is a race between latency "finishing" scmd and the re-allocated scmd.
I.e a request is still referred by a scmd, but we had turn it back to
slab. 

This series introduces the ref on scmd to exclude this issue, and the following is ref rules.

  inc ref rules is like the following:
    When setup a scmd, inited as 1. When add a timer inc 1.
  
  dec ref rules is like the following:
    -for the normal ref
       scsi_done() will drop the ref when fail to acquire REQ_ATOM_COMPLETE immediately
       or drop the ref by scsi_end_request()
       or drop by return SUCCESS_REMOVE
    -for a timer ref
       when deleting timer, if !list_empty(timeout_list), then there is a timer ref, and
       drop it.


patch1-2: fix the current potential bug 
patch3~6: prepare for the mechanism for the ref
patch7:   the ref rules core
patch8-9:  e.g and test-issue for the new mechanism. Since lack of many virtscsi background,
           patch8 may be poor and need to be improved :)


Note: all the patches are based on rhel7, whose kernel version is linux-3.10.
      I will rebase them onto the latest commit if my method is practical.


Liu Ping Fan (9):
  block: make timeout_list protectd by REQ_ATOM_COMPLETE bit
  scsi: ensure request is dequeue when finishing scmd
  scsi: introduce new internal flag SUCCESS_REMOVE
  blk: change the prototype of blk_complete_request()
  blk: change funcs' prototype to expose the ref of timer
  blk: split the reclaim of req from blk_finish_request()
  scsi: adopt ref on scsi_cmnd to avoid a race on request
  scsi: virtscsi: work around to abort a scmd
  scsi: ibmvscsi: return SUCCESS_REMOVE when finding a abort cmd

 block/blk-core.c                 | 67 ++++++++++++++++++++++++++++++-----
 block/blk-softirq.c              | 13 +++++--
 block/blk-timeout.c              | 15 +++++---
 block/blk.h                      |  3 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c |  2 +-
 drivers/scsi/scsi.c              | 33 ++++++++++++-----
 drivers/scsi/scsi_error.c        | 10 +++++-
 drivers/scsi/scsi_lib.c          | 76 +++++++++++++++++++++++++++++++---------
 drivers/scsi/scsi_priv.h         |  4 +++
 drivers/scsi/virtio_scsi.c       | 61 ++++++++++++++++++++++++++++++--
 include/linux/blkdev.h           |  9 +++--
 include/scsi/scsi.h              |  1 +
 include/scsi/scsi_cmnd.h         |  1 +
 13 files changed, 246 insertions(+), 49 deletions(-)

-- 
1.8.1.4

