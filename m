From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH scsi-misc-2.6 00/07] scsi: timer updates
Date: Mon, 11 Apr 2005 03:45:06 +0900 (KST)
Message-ID: <20050410184214.4AAD0992@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.196]:59946 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261557AbVDJSpT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Apr 2005 14:45:19 -0400
Received: by wproxy.gmail.com with SMTP id 68so1362683wri
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2005 11:45:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

 Hello, James, Jens and Christoph.

 This patchset removes misuses of scmd->eh_timeout and unexports SCSI
timer interface such that no one can misuse it anymore.  #02 assumes
that the preceding scsi_send_eh_cmnd() patch is applied.  Tested and
worked for me.

 The following bugs are fixed.

 * Race condition between eh and normal completion path for eh_timer
 * scsi_delete_timer() race in scsi_queue_insert()

[ Start of patch descriptions ]

01_scsi_timer_update_aic7xxx.patch
	: make aic7xxx use its own timer instead of scmd->eh_timeout

	aic7xxx used scmd->eh_timeout in its dv routines.  This kind
	of usage requires knowledge of and creates dependency into the
	SCSI midlayer unnecessarily.  This patch makes aic7xxx driver
	use its own timer instead of scmd->eh_timeout.
	Suggested by Christoph Hellwig.

02_scsi_timer_eh_timer_fix.patch
	: make scsi_send_eh_cmnd use its own timer instead of scmd->eh_timeout

	scmd->eh_timeout is used to resolve the race between command
	completion and timeout.  However, during error handling,
	scsi_send_eh_cmnd uses scmd->eh_timeout.  This creates a race
	condition between eh and normal completion for a request which
	has timed out and in the process of error handling.  If the
	request completes while scmd->eh_timeout is being used by eh,
	eh timeout is lost and the command will be handled by both eh
	and completion path.  This patch fixes the race by making
	scsi_send_eh_cmnd() use its own timer.

03_scsi_timer_dispatch_race_fix.patch
	: remove a timer race in scsi_queue_insert()

	scsi_queue_insert() has four callers.  Three callers call with
	timer disabled and one (the second invocation in
	scsi_dispatch_cmd()) calls with timer activated.
	scsi_queue_insert() used to always call scsi_delete_timer()
	and ignore the return value.  This results in race with timer
	expiration.  Remove scsi_delete_timer() call from
	scsi_queue_insert() and make the caller delete timer and check
	the return value.

04_scsi_timer_remove_delete_timer_from_reset_provider.patch
	: remove unnecessary scsi_delete_timer() call in scsi_reset_provider()

	scsi_reset_provider() calls scsi_delete_timer() on exit which
	isn't necessary.  Remove it.

05_scsi_timer_unexport_timer_functions.patch
	: unexport scsi_{add|delete}_timer()

	SCSI cmd timer has specific synchronization/semantic
	requirements and shouldn't be directly used outside SCSI
	midlayer.  With aic7xxx driver updated, there's no user left.
	This patch unexports scsi_{add|delete}_timer() routines and
	also removes @complete argument from scsi_add_timer().  The
	change makes the use of scsi_times_out() confined in
	scsi_error.c, so move it upward such that no prototype is
	needed and make it static.

06_scsi_timer_update_api_doc.patch
	: Delete scsi_{add|delete}_timer() from scsi_mid_low_api.txt

	As scsi_{add|delete}_timer() got unexported, remove them from
	the API doc.

07_scsi_timer_strict_reuse.patch
	: make reuse of SCSI cmd timer strict

	SCSI cmd timer shouldn't be reused while it's active.  Make
	sure that the unused condition is marked with
	eh_timeout->function = NULL and BUG() active reuse path.

[ End of patch descriptions ]

 Thanks a lot.

