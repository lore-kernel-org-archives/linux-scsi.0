From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 00/12] scsi_debug: multiple queue support and cleanup
Date: Mon, 25 Apr 2016 12:16:27 -0400
Message-ID: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:36939 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932866AbcDYQQs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2016 12:16:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

Primary reason for this patch series is to add multi queue support
modelled on the null_blk driver. Ignore host_lock option but
keep parameter for backward compatibility. Use high resolution
timers to implement both the jiffy and nanosecond delay
parameters. Replace the tasklets with work items. Incorporate
REPORT LUNS patch from Tomas Winkler sent in Febrary 2015. Add
parameter that permits LU names to use UUIDs (spc5r08.pdf).

Douglas Gilbert (12):
  scsi_debug: cleanup naming and bit crunching
  scsi_debug: ignore host lock option
  scsi_debug: replace jiffy timers with hr timers
  scsi_debug: make jiffy delay name clearer
  scsi_debug: replace tasklet with work queue
  scsi_debug: re-order file scope declarations
  scsi_debug: use likely hints on fast path
  scsi_debug: rework resp_report_luns
  scsi_debug: add multiple queue support
  scsi_debug: vpd and mode page work
  scsi_debug: uuid for lu name
  scsi_debug: use locally assigned naa

 drivers/scsi/scsi_debug.c | 2744 +++++++++++++++++++++++----------------------
 1 file changed, 1405 insertions(+), 1339 deletions(-)

-- 
2.7.4

