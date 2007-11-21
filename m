From: akpm@linux-foundation.org
Subject: [patch 04/23] mptbase: reset ioc initiator during PCI resume
Date: Wed, 21 Nov 2007 15:12:17 -0800
Message-ID: <200711212312.lALNCHPj014115@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59508 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753292AbXKUXSa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2007 18:18:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, djwong@us.ibm.com

From: "Darrick J. Wong" <djwong@us.ibm.com>

It appears that the LSI SAS 1064E chip needs to be reset after a
suspend/resume cycle before the driver attempts further communications with
the chip.  Without this patch, resuming the chip results in this error
message being printed repeatedly and no more disk I/O.

mptbase: ioc0: ERROR - Invalid IOC facts reply, msgLength=0 offsetof=6!

So far it seems to fix suspend/resume on all the MPT Fusion cards I have
(SAS and U320 SCSI) but since I don't know the internals of that chip I
can't say for sure if this is a proper fix.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/message/fusion/mptbase.c~mptbase-reset-ioc-initiator-during-pci-resume drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~mptbase-reset-ioc-initiator-during-pci-resume
+++ a/drivers/message/fusion/mptbase.c
@@ -1829,6 +1829,12 @@ mpt_resume(struct pci_dev *pdev)
 		(mpt_GetIocState(ioc, 1) >> MPI_IOC_STATE_SHIFT),
 		CHIPREG_READ32(&ioc->chip->Doorbell));
 
+	/* put ioc into READY_STATE */
+	if(SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, CAN_SLEEP)) {
+		printk(MYIOC_s_ERR_FMT
+		"pci-resume:  IOC msg unit reset failed!\n", ioc->name);
+	}
+
 	/* bring ioc to operational state */
 	if ((recovery_state = mpt_do_ioc_recovery(ioc,
 	    MPT_HOSTEVENT_IOC_RECOVER, CAN_SLEEP)) != 0) {
_
