From: Rob Evers <revers@redhat.com>
Subject: [PATCH V4 0/5] scsi: Configure number of LUs reported by 'report-luns'
Date: Mon, 17 Nov 2014 10:22:05 -0500
Message-ID: <1416237730-1862-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbaKQPWK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2014 10:22:10 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sAHFMAKr026828
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2014 10:22:10 -0500
Received: from localhost ([10.18.25.106])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id sAHFMANX017060
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2014 10:22:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set retrieves the number of LUs available on a target
using the report-luns command.  The initial size of the report-luns
command is 512 entries, as the previous default initial number was.
If more LUs than 511 are present on a target, the report-luns is
re-issued with the size indicated in the result of the original
report-luns, up to max_report_luns.

A few minor bug fixes and enhancements are included as well.

The default value of max_report_luns is increased to 16k-1 from 512-1.

4rth version changes from 3rd posting:

 - Fix return value on first kmalloc failing in scsi_report_lun_scan

 - Fix bug in put_unaligned_be32 usage

 - Re-order patches to put bug fixes in first

 - Enhance comments

 - Fix checkpatch warnings

3rd version changes from 2nd posting:

 - Add a patch to use get/put_unaligned_be32() in report-luns code

2nd version changes from first posting:

 - Minor tweak added in 2nd patch to use the number of luns
   reported in the 2nd report-luns command, if it is executed.
   There is a chance that the number changed between the
   1st and 2nd report-luns.

 - Add 3rd patch changing kmalloc flag in report luns from
   GFP_ATOMIC to GFP_KERNEL, as this is more consistent with
   the allocation flag in blk_alloc_queue_node()

Rob Evers (5):
  scsi: Fix scsi_report_lun_scan kmalloc flag
  scsi: Fix scsi_report_lun_scan return when kmalloc fails
  scsi: Encapsulate scsi_do_report_luns
  scsi: Change default value of max_report_luns to 16k-1
  scsi: Use set/get_unaligned_be32 in report_luns

 drivers/scsi/scsi_scan.c | 202 +++++++++++++++++++++++++++++------------------
 1 file changed, 125 insertions(+), 77 deletions(-)

-- 
1.8.3.1

