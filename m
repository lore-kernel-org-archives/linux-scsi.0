From: Edward Goggin <egoggin@vmware.com>
Subject: initialize max_target_blocked in scsi_alloc_target
Date: Thu, 9 Apr 2009 10:02:22 -0700
Message-ID: <B1FD1A0C73AC4E46A4F95BADC77079D351A9E032@PA-EXMBX02.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:45822 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759361AbZDIRCX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Apr 2009 13:02:23 -0400
Received: from mailhost2.vmware.com (mailhost2.vmware.com [10.16.67.167])
	by smtp-outbound-1.vmware.com (Postfix) with ESMTP id D768DF007
	for <linux-scsi@vger.kernel.org>; Thu,  9 Apr 2009 10:02:22 -0700 (PDT)
Received: from pa-exht01.vmware.com (pa-exht01.vmware.com [10.113.81.167])
	by mailhost2.vmware.com (Postfix) with ESMTP id B38F58E54B
	for <linux-scsi@vger.kernel.org>; Thu,  9 Apr 2009 10:02:22 -0700 (PDT)
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>


Patch 1 of 1

This patch initializes the max_target_blocked field of a scsi target structure
so that a queuecommand return value of SCSI_MLQUEUE_TARGET_BUSY will actually
result in having the scsi_queue_insert blocking the device queue before requeuing
the command and running the queue.  Otherwise, can and does cause livelock on
single CPU configurations if/when open-iSCSI software initiator's command PDU
window fills.

Signed-off-by: Ed Goggin <egoggin@vmware.com>

--- linux-2.6.29/drivers/scsi/scsi_scan.c	2009-03-23 19:12:14.000000000 -0400
+++ linux-2.6.29-fix/drivers/scsi/scsi_scan.c	2009-04-09 11:11:01.000000000 -0400
@@ -427,6 +427,7 @@ static struct scsi_target *scsi_alloc_ta
 	INIT_LIST_HEAD(&starget->devices);
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
+	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);

