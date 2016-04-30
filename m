From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2 00/12] scsi_debug: multiple queue support and cleanup
Date: Fri, 29 Apr 2016 21:39:07 -0400
Message-ID: <1461980359-4320-1-git-send-email-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:46696 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbcD3Bja (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2016 21:39:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com, bart.vanassche@sandisk.com

Changes since original version:
  - reduce resp_report_luns to reporting 256 LUNs (0 to 255)
    using address_method=0 which is single level peripheral
    device addressing method. Reviewer would like further
    address_methods support which will be presented as a
    separate patch
  - various formatting changes as requested by reviewers and
    a recent version of checkpatch.pl

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

 drivers/scsi/scsi_debug.c | 2779 +++++++++++++++++++++++----------------------
 1 file changed, 1424 insertions(+), 1355 deletions(-)

-- 
2.7.4

