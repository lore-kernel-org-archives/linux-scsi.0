From: Robert Love <robert.w.love@intel.com>
Subject: Retrying cmd when SNS Key is "Unit Attention" and the device is
 not removable
Date: Tue, 13 Jan 2009 16:26:34 -0800
Message-ID: <1231892794.7870.54.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13642 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805AbZANA0f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2009 19:26:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

I'm not seeing commands retried when the target returns "Check
Condition / Unit Attention" for SNS data.

I narrowed it down to commit id:
b60af5b0adf0da24c673598c8d3fb4d4189a15ce which makes changes to the
scsi_io_completion() function. In particular it is now calling
scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY) instead of
scsi_requeue_command() when the sense_key is UNIT_ATTENTION and the
device is not removable. I don't fully understand the differences in
these functions, and I'm continuing to investigate, but something is
causing the command to not be retried.

I came across this when I was testing Open-FCoE's reset functionality.
We logout of targets and then re-login to them. The binding persists and
the target is shown as "Online" after the re-login. After that, if I run
'fdisk -l' the SCSI-ml sends a "Read(10)" command and the target replies
with "Status: Check Condition (0x02)" and fdisk hangs. Before the above
mentioned patch the SCSI-ml would retry and the response would be good
(w/ payload). I'm not sure why the target/lun replies with "Check
Condition."

Was it intentional that this patch changed the retry function for
(sense_key == UNIT_ATTENTION && !cmd->device->removable)? I imagine so
because the commit message talks about the various retry scenarios. Does
anyone have any leads as to why this doesn't retry?

Thanks,

//Rob

