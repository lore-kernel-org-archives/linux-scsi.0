From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] mptbase: Reset ioc initiator after PCI resume
Date: Thu, 11 Jan 2007 13:25:57 -0800
Message-ID: <45A6AB65.1000002@us.ibm.com>
References: <452D7E8B.6000907@us.ibm.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:58527 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbXAKV0A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jan 2007 16:26:00 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BLOlMa005627
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 16:24:47 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BLPwCK554892
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 14:25:58 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BLPwXX025809
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 14:25:58 -0700
In-Reply-To: <452D7E8B.6000907@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Eric Moore <eric.moore@lsil.com>

It appears that the LSI SAS 1064E chip needs to be reset after a
suspend/resume cycle before the driver attempts further communications with
the chip.  This patch gets rid of these error messages:

mptbase: ioc0: ERROR - Invalid IOC facts reply, msgLength=0 offsetof=6!

after a system wakes up from sleep.  I've also tested it on a 53c1030 chip
with no observable regressions.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/message/fusion/mptbase.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index b3f28a0..b228e4c 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1545,6 +1545,12 @@ mpt_resume(struct pci_dev *pdev)
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

