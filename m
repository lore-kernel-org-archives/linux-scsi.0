From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 0/4] scsi_debug: add write scattered support
Date: Mon, 11 Dec 2017 20:10:04 -0500
Message-ID: <20171212011008.27689-1-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:59783 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751234AbdLLBKJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Dec 2017 20:10:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, bart.vanassche@sandisk.com, hare@suse.de

While testing the WRITE SCATTERED command support in a new sg3_utils
utility (sg_write_x) it was helpful to have a target that supported
this command. This command might be attractive to other kernel
subsystems. Even if end devices don't support this command yet, it
would most likely be a performance win if SCSI LLDs supported it (by
breaking it down to a series of WRITE commands), as that would cut
down the overhead of the block layer, the ULD (e.g. sd) and the SCSI
midlevel.

Douglas Gilbert (4):
  tab, kstrto changes, requested by checkpatch.pl
  fix group_number mask 0x1f->0x3f
  expand do_device_access to take sg offset
  add resp_write_scat function

 drivers/scsi/scsi_debug.c | 504 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 382 insertions(+), 122 deletions(-)

-- 
2.14.1
