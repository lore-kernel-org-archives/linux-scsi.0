Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3987156CB
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2024 12:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ULE+O0hi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5550FC433C7;
	Thu, 11 Jan 2024 12:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704974741;
	bh=o8BXPeDziH3uPRxHHQ3V/Hn6bK4Vombwcjp0QA7Cu1o=;
	h=From:To:Cc:Subject:Date:From;
	b=ULE+O0hi6ppHjXIYAHjKN5SI2z1td6fhrke9ksIOZ06I2wOubukOXAJ8LvdZAoGtE
	 j0IUU1fUtqof6NvD+PfLM7EF8T+sMgArKoP5QU4IEI2qumfh+zPxqGVL9M2zFn1Dnk
	 baG1CkVbGWSGFhkCD+n0Fh9HE9T32FNLTZyxYGrs77tkse6/cUIwPxnrxd8dOhSylQ
	 Gc2UqN54THpx+OxBzpQXwr+fUkCJSOndx3kAC9ml3rwzeV3Q1ux36peT5zR1L4SWTw
	 ct6MZXBBplkhqe5gf1aDY8b4f0xptJomZaJ+CApAeK9HUKfj/E1oYzuewucX87OnRi
	 L4AO5kyYLb0Vw==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Kevin Locke <kevin@kevinlocke.name>,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: core: Kick the requeue list after inserting when flushing
Date: Thu, 11 Jan 2024 13:05:32 +0100
Message-ID: <20240111120533.3612509-1-cassel@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When libata calls ata_link_abort() to abort all ata queued commands,
it calls blk_abort_request() on the SCSI command representing each QC.

This causes scsi_timeout() to be called, which calls scsi_eh_scmd_add()
for each SCSI command.

scsi_eh_scmd_add() sets the SCSI host to state recovery, and then adds
the command to shost->eh_cmd_q.

This will wake up the SCSI EH, and eventually the libata EH strategy
handler will be called, which calls scsi_eh_flush_done_q() to either
flush retry or flush finish each failed command.

The commands that are flush retried by scsi_eh_flush_done_q() are
done so using scsi_queue_insert().

Before commit 8b566edbdbfb ("scsi: core: Only kick the requeue list if
necessary"), __scsi_queue_insert() called blk_mq_requeue_request() with
the second argument set to true, indicating that it should always
kick/run the requeue list after inserting.

After commit 8b566edbdbfb ("scsi: core: Only kick the requeue list if
necessary"), __scsi_queue_insert() does not kick/run the requeue list
after inserting, if the current SCSI host state is recovery (which is
the case in the libata example above).

This optimization is probably fine in most cases, as I can only assume
that most often someone will eventually kick/run the queues.

However, that is not the case for scsi_eh_flush_done_q(), where we can
see that the request gets inserted to the requeue list, but the queue is
never started after the request has been inserted, leading to the block
layer waiting for the completion of command that never gets to run.

Since scsi_eh_flush_done_q() is called by SCSI EH context, the SCSI host
state is most likely always in recovery when this function is called.

Thus, let scsi_eh_flush_done_q() explicitly kick the requeue list after
inserting a flush retry command, so that scsi_eh_flush_done_q() keeps
the same behavior as before commit 8b566edbdbfb ("scsi: core: Only kick
the requeue list if necessary").

Simple reproducer for the libata example above:
$ hdparm -Y /dev/sda
$ echo 1 > /sys/class/scsi_device/0\:0\:0\:0/device/delete

Fixes: 8b566edbdbfb ("scsi: core: Only kick the requeue list if necessary")
Reported-by: Kevin Locke <kevin@kevinlocke.name>
Closes: https://lore.kernel.org/linux-scsi/ZZw3Th70wUUvCiCY@kevinlocke.name/
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/scsi/scsi_error.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1223d34c04da..d983f4a0e9f1 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2196,15 +2196,18 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 	struct scsi_cmnd *scmd, *next;
 
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
+		struct scsi_device *sdev = scmd->device;
+
 		list_del_init(&scmd->eh_entry);
-		if (scsi_device_online(scmd->device) &&
-		    !scsi_noretry_cmd(scmd) && scsi_cmd_retry_allowed(scmd) &&
-			scsi_eh_should_retry_cmd(scmd)) {
+		if (scsi_device_online(sdev) && !scsi_noretry_cmd(scmd) &&
+		    scsi_cmd_retry_allowed(scmd) &&
+		    scsi_eh_should_retry_cmd(scmd)) {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
 					     "%s: flush retry cmd\n",
 					     current->comm));
 				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
+				blk_mq_kick_requeue_list(sdev->request_queue);
 		} else {
 			/*
 			 * If just we got sense for the device (called
-- 
2.43.0

