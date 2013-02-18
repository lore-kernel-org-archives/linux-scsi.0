From: Rob Evers <revers@redhat.com>
Subject: [PATCH v2 0/3] Configure number of LUs reported by 'report-luns'
Date: Mon, 18 Feb 2013 14:15:49 -0500
Message-ID: <1361214952-28978-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350Ab3BRTPx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2013 14:15:53 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1IJFrAu030466
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2013 14:15:53 -0500
Received: from localhost (dhcp-186-142.bos.redhat.com [10.16.186.142])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r1IJFr2C028613
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2013 14:15:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set retrieves the number of LUs available on a target
using the report-luns command.  The initial size of the report-luns
command is 512 entries, as the previous default initial number was.
If more LUs than 511 are present on a target, the report-luns is
re-issued with the size indicated in the result of the original
report-luns, up to max_report_luns.

The default value of max_report_luns is increased to 16k-1 from 512-1.

2nd version changes from first posting:

 - Minor tweak added in 2nd patch to use the number of luns
   reported in the 2nd report-luns command, if it is executed.
   There is a chance that the number changed between the
   1st and 2nd report-luns.

 - Add 3rd patch changing kmalloc flag in report luns from
   GFP_ATOMIC to GFP_KERNEL, as this is more consistent with
   the allocation flag in blk_alloc_queue_node()

Rob Evers (3):
  Encapsulate scsi_do_report_luns
  Configure reported luns
  Change kmallocs in report_luns to use GFP_KERNEL

 drivers/scsi/scsi_scan.c | 196 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 126 insertions(+), 70 deletions(-)

-- 
1.7.11.7

