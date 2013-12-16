From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 0/6] Let sleeping disks lie
Date: Mon, 16 Dec 2013 18:30:51 -0500
Message-ID: <1387236657-4852-1-git-send-email-psusi@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:63298 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab3LPXbA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 18:31:00 -0500
In-Reply-To: <cover.1384030893.git.psusi@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: todd.e.brandt@linux.intel.com
Cc: tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

This is the set I currently have.  I fixed libata to implement the
REQUEST SENSE scsi command, and set up sd to use blk_pre_runtime_suspend
to force the queue to the RPM_SUSPENDING state while issuing the
REQUEST SENSE command to make sure other requests are blocked, then
if REQUEST SENSE indicates that the drive does not need started,
then complete suspending the device, otherwise cancel the suspend
by passing an error value to blk_post_runtime_suspend.

For some reason, the system hangs on resume if I issue the REQUEST SENSE
command after blk_pre_runtime_suspend.  My understanding is that the
REQ_PM flag should make the command process even though the queue is
RPM_SUSPENDING, but it doesn't seem to work.  Anyone have any idea why?

Phillip Susi (6):
  libata: use sleep instead of standby command
  libata: avoid waking disk for several commands
  libata: resume in the background
  libata: don't start disks on resume
  sd: don't start disks on system resume
  libata: return power status in REQUEST SENSE command

 drivers/ata/libata-core.c | 38 +++++++++++++++----
 drivers/ata/libata-eh.c   | 10 ++++-
 drivers/ata/libata-scsi.c | 44 ++++++++++++++++++----
 drivers/ata/libata.h      |  1 +
 drivers/scsi/sd.c         | 94 ++++++++++++++++++++++++++++++++++++++++++-----
 drivers/scsi/sd.h         |  1 +
 include/linux/libata.h    |  1 +
 7 files changed, 162 insertions(+), 27 deletions(-)

-- 
1.8.3.2

