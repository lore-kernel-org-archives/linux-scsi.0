From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v3 0/6] scsi_debug: multiple queue support and cleanup
Date: Fri,  6 May 2016 00:40:23 -0400
Message-ID: <1462509629-24282-1-git-send-email-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55615 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbcEFEkk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2016 00:40:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com, bart.vanassche@sandisk.com

Changes since v2.5
  - rework the 'add multiple queue support' patch based on
    reviewers' comments to more closely follow the scsi/block mq
    template

Changes since original version:
  - reduce resp_report_luns to reporting 256 LUNs (0 to 255)
    using address_method=0 which is single level peripheral
    device addressing method. Reviewer would like further
    address_methods support which will be presented as a
    separate patch

Primary reason for this patch series is to add multi queue support
modelled on the null_blk driver. Incorporate REPORT LUNS patch from
Tomas Winkler sent in Febrary 2015; trim to a maximum of 256 LUNs
(0 to 255) per target. Add parameter that permits LU names to use
UUIDs (spc5r08.pdf).

The original patch set was made up of 12 patches, the first 7 of
which have already been accepted with minor edits. This patch set
(and "v2.5" before it) represent the second half of the original patch
set. So this patch set is based on the current SCSI maintainers'
repositories. For those who want to try this patch set on lk 4.5
or the linux-stable tree, this patch should be applied before
this series:
   http://sg.danny.cz/sg/p/sdebug_mq_1st_half.patch

Douglas Gilbert (6):
  scsi_debug: use pdt constants
  scsi_debug: rework resp_report_luns
  scsi_debug: add multiple queue support
  scsi_debug: vpd and mode page work
  scsi_debug: uuid for lu name
  scsi_debug: use locally assigned naa

 drivers/scsi/scsi_debug.c | 1156 ++++++++++++++++++++++++++++-----------------
 1 file changed, 730 insertions(+), 426 deletions(-)

-- 
2.7.4

