From: akpm@linux-foundation.org
Subject: [patch 01/17] mptbase: reset ioc initiator during PCI resume
Date: Fri, 28 Mar 2008 14:48:31 -0700
Message-ID: <200803282148.m2SLmVkL012216@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754704AbYC1VtE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 17:49:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, djwong@us.ibm.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

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
Cc: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: <Sathya.Prakash@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/message/fusion/mptbase.c~mptbase-reset-ioc-initiator-during-pci-resume drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~mptbase-reset-ioc-initiator-during-pci-resume
+++ a/drivers/message/fusion/mptbase.c
@@ -1892,6 +1892,12 @@ mpt_resume(struct pci_dev *pdev)
 		}
 	}
 
+	/* put ioc into READY_STATE */
+	if(SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, CAN_SLEEP)) {
+		printk(MYIOC_s_ERR_FMT
+		"pci-resume:  IOC msg unit reset failed!\n", ioc->name);
+	}
+
 	/* bring ioc to operational state */
 	printk(MYIOC_s_INFO_FMT "Sending mpt_do_ioc_recovery\n", ioc->name);
 	recovery_state = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
_
