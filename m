From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v3 25/32] cxlflash: Fix to prevent EEH recovery failure
Date: Thu, 24 Sep 2015 14:41:53 -0500
Message-ID: <1443123713-17622-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1443123193-16498-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:59417 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbbIXTmh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2015 15:42:37 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 24 Sep 2015 15:42:36 -0400
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id ABC7538C8046
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2015 15:42:33 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8OJgXV359179252
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2015 19:42:33 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8OJgV6T031970
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2015 15:42:33 -0400
In-Reply-To: <1443123193-16498-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

The process_sense() routine can perform a read capacity which
can take some time to complete. If an EEH occurs while waiting
on the read capacity, the EEH handler is unable to obtain the
context's mutex in order to put the context in an error state.
The EEH handler will sit and wait until the context is free,
but this wait can last longer than the EEH handler tolerates,
leading to a failed recovery.

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
---
 drivers/scsi/cxlflash/superpipe.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 329b27e..e2b28ea 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -1789,12 +1789,21 @@ static int cxlflash_disk_verify(struct scsi_device *sdev,
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

