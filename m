From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Patch from Fujitsu for a weird DVD
Date: Thu, 2 Mar 2006 10:03:33 -0800
Message-ID: <20060302100333.24b7ad21.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:5096 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1751639AbWCBSDr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2006 13:03:47 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11/8.12.11) with ESMTP id k22I3klb028015
	for <linux-scsi@vger.kernel.org>; Thu, 2 Mar 2006 13:03:46 -0500
Received: from devserv.devel.redhat.com (devserv.devel.redhat.com [172.16.58.1])
	by int-mx1.corp.redhat.com (8.11.6/8.11.6) with ESMTP id k22I3k116209
	for <linux-scsi@vger.kernel.org>; Thu, 2 Mar 2006 13:03:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: zaitcev@redhat.com

Clear expecting_cc_ua in case a device went from a reset into operation
without posting any unit attention.

Signed-off-By: Pete Zaitcev <zaitcev@redhat.com>

---

Hi, All:

This bug was reported by someone anonymous at Fujitsu. They have a DVD
drive with USB interface, which fails data transfers after a power-up
(it accepts and processes commands which involve no data block, such
as TEST UNIT READY). This causes us to go through useless reset cycles
while the device gathers its wits. After a while, the drive suddenly
starts working without reporting any sense and everything is fine.

However, since no sense was reported, expecting_cc_ua gets stuck,
perhaps for hundreds of commands. When a real check condition occurs,
we discard it and clear expecting_cc_ua. This usually happens when
someone changes the disc, and so the sr.c fails to sense that the media
has changed and continues to use the old media size. This wreaks havoc
with RHEL 4 installs by causing reads beyond the end of the device,
because CD #2 is larger than CD #1.

The patch seems safe to me. If a command issued by upper levels (not EH)
completes normally, we do not expect CC or UA anymore, right?

-- Pete

diff -urp -X dontdiff linux-2.6.16-rc5/drivers/scsi/scsi_error.c linux-2.6.16-rc5-lem/drivers/scsi/scsi_error.c
--- linux-2.6.16-rc5/drivers/scsi/scsi_error.c	2006-02-26 23:04:27.000000000 -0800
+++ linux-2.6.16-rc5-lem/drivers/scsi/scsi_error.c	2006-03-02 09:48:31.000000000 -0800
@@ -1273,6 +1273,8 @@ int scsi_decide_disposition(struct scsi_
 		return ADD_TO_MLQUEUE;
 	case GOOD:
 	case COMMAND_TERMINATED:
+		scmd->device->expecting_cc_ua = 0;
+		return SUCCESS;
 	case TASK_ABORTED:
 		return SUCCESS;
 	case CHECK_CONDITION:
