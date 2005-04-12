From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH scsi-misc-2.6 00/07] scsi: requeue path consolidation
Date: Tue, 12 Apr 2005 21:52:21 +0900 (KST)
Message-ID: <20050412125219.88E5C1F6@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.197]:50247 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262424AbVDLMwg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2005 08:52:36 -0400
Received: by rproxy.gmail.com with SMTP id a41so1506865rng
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2005 05:52:31 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

 Hello again, guys.

 This is the last patchset and assumes that all previous patchsets are
applied.  This patchset conolidates requeue paths such that all
requeue after command issue goes through scsi_requeue_command().
Requeueing due to unifinished bytes goes through
scsi_requeue_command_reprep() and due to error through
scsi_retry_command().

 This is the last patchset before the new implementation of scsi
device state model.  New state model is complete now and ready to be
splitted & submitted.  As soon as these patchsets are settled, I'll
post the new device model patchset.

[ Start of patch descriptions ]

01_scsi_requeue_make_requeue_command_public.patch
	: update and make public scsi_requeue_command()

	This patch makes the following changes to
	scsi_requeue_command() and make the function public.

	* remove redundant argument @q
	* remove REQ_DONTPREP clearing
	* add state/owner setting

	A new inline function scsi_requeue_command_reprep() is defined
	and used for the original users of scsi_requeue_command().

	Using a wrapper function for reprep cases is suggested by
	Christoph Hellwig.

02_scsi_requeue_use_scsi_requeue_command_in_scsi_retry_command.patch
	: make scsi_retry_command() use scsi_requeue_command()

	scsi_retry_command() orignally used scsi_queue_insert() for
	requeueing.  This patch makes it use scsi_retry_command()
	instead.  Adding a call to scsi_device_unbusy() is sufficient
	and the change also makes scsi_retry_command() symmetric with
	scsi_finish_command() in how it unbusies the command.  Also as
	there's nothing to return, make the function void.

03_scsi_requeue_use_scsi_retry_command_instead_of_scsi_queue_insert.patch
	: replace scsi_queue_insert() usages with scsi_retry_command()

	There are two users of scsi_queue_insert() left now.  One in
	scsi_softirq() and the other in scsi_eh_flush_done_q().  The
	only additional functionality of scsi_queue_insert() used is
	setting device_blocked on ADD_TO_MLQUEUE case in
	scsi_softirq().

	Open code device_blocked setting and replace
	scsi_queue_insert() with scsi_retry_command() in both cases.

04_scsi_requeue_remove_scsi_queue_insert.patch
	: remove scsi_queue_insert()

	scsi_queue_insert() now has no user left.  Kill it.

05_scsi_requeue_move_init_cmd_errh.patch
	: move scsi_init_cmd_errh() from request_fn to prep_fn.

	As now all non-reprepped requeue goes through
	scsi_retry_command() which clears sense buffer, there's no
	need to call scsi_init_cmd_errh() in scsi_request_fn().  Move
	scsi_init_cmd_errh() to scsi_prep_fn().

06_scsi_requeue_reset_result.patch
	: add cmd->result clearing

	cmd->result wasn't cleared on requeue or reprep.  Clear it.

07_scsi_requeue_consolidate_setup_cmd_retry_calls_in_eh.patch
	: consolidate scsi_cmd_retry() calls

	scsi_setup_cmd_retry() is needed because scsi eh may alter
	scsi_cmnd to issue eh commands.  Consolidate calls to
	scsi_setup_cmd_retry() to one place in scsi_eh_flush_done_q().
	This change makes scsi_retry_command() more symmetrical with
	scsi_finish_command().

[ End of patch descriptions ]

 Thanks a lot.

