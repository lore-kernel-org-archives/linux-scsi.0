From: Rob Evers <revers@redhat.com>
Subject: [PATCH V5 0/3] scsi: Configure number of LUs reported by 'report-luns'
Date: Fri,  5 Dec 2014 14:37:40 -0500
Message-ID: <1417808263-5632-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaLETho (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2014 14:37:44 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sB5JbiIt002911
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2014 14:37:44 -0500
Received: from localhost ([10.18.25.106])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id sB5Jbhbm005500
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2014 14:37:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set retrieves the number of LUs available on a target
using the report-luns command by re-sizing the returned data
buffer and retrying report luns.

A minor bug fix is included.

scsi_mod parameter max_report_luns is no longer used and is removed.

Changes from previous posting:

 - simplify implementation by removing max_report_luns parameter and
   removing 2nd kmalloc failure handling

 - remove patch to fix return value on first kmalloc failing

 - drop do_scsi_report_luns encapsulation as it isn't required
   with new implementation

Rob Evers (3):
  scsi: Avoid unnecessary GFP_ATOMIC allocation in scsi_report_lun_scan
  scsi: Use set/get_unaligned_be32 in report_luns
  scsi: Retry report-luns when reported LU count requres more memory

 drivers/scsi/scsi_scan.c | 54 ++++++++++++++----------------------------------
 1 file changed, 15 insertions(+), 39 deletions(-)

-- 
1.8.3.1

