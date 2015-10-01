From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v5 25/34] cxlflash: Fix to prevent EEH recovery failure
Date: Thu,  1 Oct 2015 10:58:08 -0500
Message-ID: <1443715088-21200-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1443714773-9176-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:48719 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbbJAP7D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2015 11:59:03 -0400
Received: from localhost
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 1 Oct 2015 09:59:02 -0600
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 734586E8045
	for <linux-scsi@vger.kernel.org>; Thu,  1 Oct 2015 11:47:12 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t91Fx0fo49152254
	for <linux-scsi@vger.kernel.org>; Thu, 1 Oct 2015 15:59:00 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t91FwuFq024461
	for <linux-scsi@vger.kernel.org>; Thu, 1 Oct 2015 11:58:59 -0400
In-Reply-To: <1443714773-9176-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

The process_sense() routine can perform a read capacity which
can take some time to complete. If an EEH occurs while waiting
on the read capacity, the EEH handler will wait to obtain the
context's mutex in order to put the context in an error state.
The EEH handler will sit and wait until the context is free,
but this wait can potentially last forever (deadlock) if the
scsi_execute() that performs the read capacity experiences a
timeout and calls into the reset callback. When that occurs,
the reset callback sees that the device is already being reset
and waits for the reset to complete. This leaves two threads
waiting on the other.

To address this issue, make the context unavailable to new,
non-system owned threads and release the context while calling
into process_sense(). After returning from process_sense() the
context mutex is reacquired and the context is made available
again. The context can be safely moved to the error state if
needed during the unavailable window as no other threads will
hold its reference.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Reviewed-by: Daniel Axtens <dja@axtens.net>
---
 drivers/scsi/cxlflash/superpipe.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index a6316f5..7283e83 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -1787,12 +1787,21 @@ static int cxlflash_disk_verify(struct scsi_device *sdev,
 	 * inquiry (i.e. the Unit attention is due to the WWN changing).
 	 */
 	if (verify->hint & DK_CXLFLASH_VERIFY_HINT_SENSE) {
+		/* Can't hold mutex across process_sense/read_cap16,
+		 * since we could have an intervening EEH event.
+		 */
+		ctxi->unavail = true;
+		mutex_unlock(&ctxi->mutex);
 		rc = process_sense(sdev, verify);
 		if (unlikely(rc)) {
 			dev_err(dev, "%s: Failed to validate sense data (%d)\n",
 				__func__, rc);
+			mutex_lock(&ctxi->mutex);
+			ctxi->unavail = false;
 			goto out;
 		}
+		mutex_lock(&ctxi->mutex);
+		ctxi->unavail = false;
 	}
 
 	switch (gli->mode) {
-- 
2.1.0

