From: Rob Evers <revers@redhat.com>
Subject: [PATCH V3 0/4] Configure number of LUs reported by 'report-luns'
Date: Thu,  7 Mar 2013 08:38:31 -0500
Message-ID: <1362663515-3476-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932872Ab3CGNil (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Mar 2013 08:38:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: revers@redhat.com, michaelc@cs.wisc.edu, bvanassche@acm.org, emilne@redhat.com

This patch set retrieves the number of LUs available on a target
using the report-luns command.  The initial size of the report-luns
command is 512 entries, as the previous default initial number was.
If more LUs than 511 are present on a target, the report-luns is
re-issued with the size indicated in the result of the original
report-luns, up to max_report_luns.

The default value of max_report_luns is increased to 16k-1 from 512-1.

3rd version changes from 2nd posting:

 - add a patch to use get/put_unaligned_be32() in report-luns code

2nd version changes from first posting:

 - Minor tweak added in 2nd patch to use the number of luns
   reported in the 2nd report-luns command, if it is executed.
   There is a chance that the number changed between the
   1st and 2nd report-luns.

 - Add 3rd patch changing kmalloc flag in report luns from
   GFP_ATOMIC to GFP_KERNEL, as this is more consistent with
   the allocation flag in blk_alloc_queue_node()

Rob Evers (4):
  Encapsulate scsi_do_report_luns
  Configure reported luns
  Change kmallocs in report_luns to use GFP_KERNEL
  Use set/get_unaligned_be32 in report_luns

 drivers/scsi/scsi_scan.c | 192 +++++++++++++++++++++++++++++------------------
 1 file changed, 120 insertions(+), 72 deletions(-)

-- 
1.7.11.7

