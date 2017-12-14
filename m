From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2 0/5] scsi_debug: add write scattered support
Date: Wed, 13 Dec 2017 20:40:11 -0500
Message-ID: <20171214014016.13142-1-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:40145 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751029AbdLNBkW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Dec 2017 20:40:22 -0500
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

Changes since original version:
  - fix problem when fake_rw=1, identify media access commands
    better with following rename
  - rename FF_DIRECT_IO to FF_MEDIA_IO
  - apply reviewer suggestions (Bart Van Assche)
  - expand in-code comments

Douglas Gilbert (5):
  scsi_debug: tab, kstrto changes
  scsi_debug: fix group_number mask
  scsi_debug: do_device_access, add sg offset argument
  scsi_debug: ARRAY_SIZE() and FF_MEDIA_IO
  scsi_debug: add resp_write_scat function

 drivers/scsi/scsi_debug.c | 544 +++++++++++++++++++++++++++++++---------------
 1 file changed, 369 insertions(+), 175 deletions(-)

-- 
2.14.1
