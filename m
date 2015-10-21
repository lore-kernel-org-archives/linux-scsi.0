From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 21/37] cxlflash: Correct behavior in device reset handler following EEH
Date: Wed, 21 Oct 2015 15:14:24 -0500
Message-ID: <1445458464-40183-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:44330 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406AbbJUUPu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:15:50 -0400
Received: from localhost
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 14:15:50 -0600
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 85624C90048
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:03:58 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LKFl3p61210728
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 20:15:47 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKFhOQ006201
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:15:47 -0400
In-Reply-To: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

When the device reset handler is entered while a reset operation
is taking place, the handler exits without actually sending a
reset (TMF) to the targeted device. This behavior is incorrect
as the device is not reset. Further complicating matters is the
fact that a success is returned even when the TMF was not sent.

To fix, the state is rechecked after coming out of the reset
state. When the state is normal, a TMF will be sent out.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index d0b9972..89bd4c3 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1920,6 +1920,7 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
 		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
 		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
 
+retry:
 	switch (cfg->state) {
 	case STATE_NORMAL:
 		rcr = send_tmf(afu, scp, TMF_LUN_RESET);
@@ -1928,9 +1929,7 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
 		break;
 	case STATE_RESET:
 		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
-		if (cfg->state == STATE_NORMAL)
-			break;
-		/* fall through */
+		goto retry;
 	default:
 		rc = FAILED;
 		break;
-- 
2.1.0

