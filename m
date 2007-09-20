From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] mptbase: Reset ioc initiator during PCI resume
Date: Thu, 20 Sep 2007 14:10:15 -0700
Message-ID: <20070920211014.GA24047@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57594 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbXITVKK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2007 17:10:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, mpt_linux_developer@lsi.com, Eric.Moore@lsi.com, support@lsi.com
Cc: linux-kernel@vger.kernel.org

It appears that the LSI SAS 1064E chip needs to be reset after a
suspend/resume cycle before the driver attempts further communications with
the chip.  Without this patch, resuming the chip results in this error
message being printed repeatedly and no more disk I/O.

mptbase: ioc0: ERROR - Invalid IOC facts reply, msgLength=0 offsetof=6!

So far it seems to fix suspend/resume on all the MPT Fusion cards I have
(SAS and U320 SCSI) but since I don't know the internals of that chip I
can't say for sure if this is a proper fix.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/message/fusion/mptbase.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 414c109..97895bd 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1772,6 +1772,12 @@ mpt_resume(struct pci_dev *pdev)
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
