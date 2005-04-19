From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH scsi-misc-2.6 00/05] scsi: change REQ_SPECIAL/REQ_SOFTBARRIER usages
Date: Wed, 20 Apr 2005 08:15:39 +0900 (KST)
Message-ID: <20050419231435.D85F89C0@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.206]:19072 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261186AbVDSXPo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 19:15:44 -0400
Received: by rproxy.gmail.com with SMTP id a41so67336rng
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2005 16:15:44 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

 Hello, James, Jens and Christoph.

 This patchset is reworked version of the previous REQ_SPECIAL update
patchset.  Patches #01 and #05 update blk layer.  The other patches
update SCSI midlayer.

 I've opted for automatically setting REQ_SOFTBARRIER together with
REQ_STARTED in elv_next_request().  Reordering prep-deferred or
requeued requests doesn't have any real benefit and actually both as
and cfq don't reorder requeued requests.  The only behavior change is
that prep-deferred requests can't be passed by others.  I think the
change is a good thing.  The only affected driver other than SCSI is
i2o_block.  So, Jens, please let me know what you think.

 This patchset does the following things.

 #01	: make elv_next_request() set REQ_SOFTBARRIER in addition to
	  REQ_STARTED.
 #02-04	: decouple REQ_SPECIAL from scsi_cmnd->special and make it
	  mean special requests (non-fs/pc).
 #05	: remove requeue feature from blk_insert_request().

 Previously, REQ_SPECIAL duplicately meant the request has been
prepp'ed by SCSI midlayer and/or the request is a special request.
This left special requests handling in the midlayer subtley
inconsistent.

 Also, the setting of REQ_SPECIAL was done by the block layer using
blk_insert_request() mostly but sometimes by the SCSI midlayer (when
returning BLK_PREP_DEFER from scsi_prep_fn()).  blk_insert_request()
was used for two different purposes.

 * enqueue special requests
 * turn on REQ_SPECIAL|REQ_SOFTBARRIER and call blk_requeue_request().

 The second somewhat unobvious feature of blk_insert_request() is used
only by SCSI midlayer and SCSI midlayer depended on it to set
REQ_SOFTBARRIER.  Unfortunately, when the SCSI midlayer sets
REQ_SPECIAL explicitly (sg allocation failure path) it didn't set
REQ_SOFTBARRIER, creating a *highly* unlikely but still existing dead
lock condition caused by allowing reorder of a request which has its
cmd allocated.  IMHO, this proves the subtlety of current situation.

 This patchset makes blk layer set REQ_SOFTBARRIER automatically when
a request is dispatched from its request queue and SCSI midlayer use
blk_requeue_request() for requeueing.

 To prevent more misuses, the requeue feature of blk_insert_request()
is removed.  Requeueing should be done with blk_requeue_request() not
blk_insert_request().

[ Start of patch descriptions ]

01_scsi_blk_make_started_requests_ordered.patch
	: make blk layer set REQ_SOFTBARRIER when a request is dispatched

	Reordering already started requests is without any real
	benefit and causes problems if the request has its
	driver-specific resources allocated (as in SCSI).  This patch
	makes elv_next_request() set REQ_SOFTBARRIER automatically
	when a request is dispatched.

	As both as and cfq schedulers don't allow passing requeued
	requests, the only behavior change is that requests deferred
	by prep_fn won't be passed by other requests.  This change
	shouldn't cause any problem.  The only affected driver other
	than SCSI is i2o_block.

02_scsi_REQ_SPECIAL_semantic_scsi_init_io.patch
	: remove REQ_SPECIAL in scsi_init_io()

	scsi_init_io() used to set REQ_SPECIAL when it fails sg
	allocation before requeueing the request by returning
	BLKPREP_DEFER.  REQ_SPECIAL is being updated to mean special
	requests.  So, remove REQ_SPECIAL setting.

03_scsi_REQ_SPECIAL_semantic_scsi_queue_insert.patch
	: make scsi_queue_insert() use blk_requeue_request()

	scsi_queue_insert() used to use blk_insert_request() for
	requeueing requests.  This depends on the unobvious behavior
	of blk_insert_request() setting REQ_SPECIAL and
	REQ_SOFTBARRIER when requeueing.  This patch makes
	scsi_queue_insert() use blk_requeue_request().  As REQ_SPECIAL
	means special requests and REQ_SOFTBARRIER is automatically
	handled by blk layer now, no flag needs to be set.

	Note that scsi_queue_insert() now calls scsi_run_queue()
	itself, and the prototype of the function is added right above
	scsi_queue_insert().  This is temporary, as later requeue path
	consolidation patchset removes scsi_queue_insert().  By adding
	temporary prototype, we can do away with unnecessarily moving
	functions.

04_scsi_REQ_SPECIAL_semantic_scsi_requeue_command.patch
	: make scsi_requeue_request() use blk_requeue_request()

	scsi_requeue_request() used to use blk_insert_request() for
	requeueing requests.  This depends on the unobvious behavior
	of blk_insert_request() setting REQ_SPECIAL and
	REQ_SOFTBARRIER when requeueing.  This patch makes
	scsi_queue_insert() use blk_requeue_request().  As REQ_SPECIAL
	means special requests and REQ_SOFTBARRIER is automatically
	handled by blk layer now, no flag needs to be set.

05_scsi_blk_insert_request_no_requeue.patch
	: remove requeue feature from blk_insert_request()

	blk_insert_request() has a unobivous feature of requeuing a
	request setting REQ_SPECIAL|REQ_SOFTBARRIER.  SCSI midlayer
	was the only user and as previous patches removed the usage,
	remove the feature from blk_insert_request().  Only special
	requests should be queued with blk_insert_request().  All
	requeueing should go through blk_requeue_request().

[ End of patch descriptions ]

 Thanks.

