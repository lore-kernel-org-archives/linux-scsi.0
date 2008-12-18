From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] scsi_lib: don't decrement busy counters when inserting
	commands
Date: Thu, 18 Dec 2008 01:03:41 -0800
Message-ID: <20081218090341.GA1765@plap4-2.local>
References: <1229493343215-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:12042 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYLRJDo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Dec 2008 04:03:44 -0500
Content-Disposition: inline
In-Reply-To: <1229493343215-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 16 Dec 2008, michaelc@cs.wisc.edu wrote:

> This patch fixes a regression in scsi-misc introduced with:
> 312efe5efcdb02d604ea37a41d965f32ca276d6a
> [SCSI] simplify scsi_io_completion().
> 
> The problem is that in previous kernels scsi_io_completion would call
> scsi_requeue_command, but now it can call scsi_queue_insert for
> something like a UNIT_ATTENTION (for netapp targets we get
> UNIT_ATTENTION when restarting a iscsi session). And scsi_queue_insert
> will call scsi_device_unbusy, but in the scsi_io_completion code path
> scsi_finish_command has already called this so we now end up
> with invalid host, target and device busy values.

Thanks for finding this, as we've run into this problem ourselves.
After applying your fix, at least I/O appears to continue...  But
there's still some residual problems left over with the changes from
scsi_requeue_command() -> scsi_queue_insert() in
312efe5efcdb02d604ea37a41d965f32ca276d6a that are causing commands
returned by the LLD with a DID_RESET status to be reissued with
cleared cmd->sdb data which in our tests are manifesting in firmware
detected overruns.  Here's a snippet of a READ_10 scsi_cmnd upon
completion by the storage:

	[  107.083085] scsi(4:0:0): OVERRUN status detected 0x7-0x400
	[  107.087081] CDB: 0x28 0x0 0x0 0x0 0x28 0x0
	[  107.087081] CDB: 0x0 0x4 0x0 0x0 0x0 0x0
	[  107.087081] PID=0x82d req=0x0 xtra=0x80000 -- returning DID_ERROR status!
	[  107.087081] cmd: serial=82d scsi_bufflen=0 retries=0 allowed=5 sc_data_direction=2
	[  107.087081] cmd->sdb: length=0 resid=0
	[  107.087081] cmd->sdb.table: sgl=0000000000000000 nents=0 orig_nents=0
	[  107.087081] req: cmd_flags=83c60 hard_nr_sections=0x400 nr_sectors=0x400 data_len=0x80000

the CDB in question contains a valid transfer-length of 400h blocks,
but the scsi_bufflen() of the scsi_cmnd is set to 0.

With the new 'simplify' code, what appears to be happening is the
scsi_cmnd->sdb structure is never being re-populated within
scsi_io_completion() after the scsi_release_buffers() call as
scsi_queue_insert() simply reissues the request with the previously
allocated scsi_cmnd and the request's REQ_DONTPREP bit set...

The original 'pre-simplified' code, as Mike C. notes, would call
scsi_requeue_command() which tore-down the request's scsi_cmnd prior
to retry.

I've tried this small patch:

	--- a/drivers/scsi/scsi_lib.c
	+++ b/drivers/scsi/scsi_lib.c
	@@ -970,7 +973,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
			 * reasons.  Just retry the command and see what
			 * happens.
			 */
	-		action = ACTION_RETRY;
	+		action = ACTION_REPREP;
		} else if (sense_valid && !sense_deferred) {
			switch (sshdr.sense_key) {
			case UNIT_ATTENTION:

but, it doesn't appear to solve the problem either.  Additionally,
it's not going to cover any other cases which ultimately result in
scsi_queue_insert() being used for retries...

Any thoughts on how to handle this???
