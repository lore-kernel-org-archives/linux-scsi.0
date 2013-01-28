From: Rob Evers <revers@redhat.com>
Subject: [PATCH 0/2] configure number of LUs reported by 'report-luns'
Date: Mon, 28 Jan 2013 15:27:52 -0500
Message-ID: <1359404874-30871-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab3A1U1z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jan 2013 15:27:55 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0SKRttm027204
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jan 2013 15:27:55 -0500
Received: from localhost (dhcp-185-85.bos.redhat.com [10.16.185.85])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r0SKRs4h017926
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jan 2013 15:27:55 -0500
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

Some warnings were detected by checkpatch.pl.  Requested feedback
from the maintainer but none provided.

Rob Evers (2):
  Encapsulate scsi_do_report_luns
  Configure reported luns

 drivers/scsi/scsi_scan.c | 186 +++++++++++++++++++++++++++++------------------
 1 file changed, 116 insertions(+), 70 deletions(-)

-- 
1.7.11.7

