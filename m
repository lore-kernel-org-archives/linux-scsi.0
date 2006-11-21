From: Brian King <brking@us.ibm.com>
Subject: [PATCH 02/10] ipr: Stop issuing cancel all to disk arrays
Date: Tue, 21 Nov 2006 10:28:04 -0600
Message-ID: <200611211628.kALGS5te025400@d01av03.pok.ibm.com>
References: <11641264771784-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:2950 "EHLO e36.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1031158AbWKUQp3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 11:45:29 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e36.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kALGhc60026114
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 11:45:28 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kALGS67p052392
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 11:28:06 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kALGS5Ik025420
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 11:28:06 -0500
In-Reply-To: <11641264771784-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


The ipr disk array devices do not support a cancel all
requests primitive, so change the ipr driver to never
send it.

---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_vset_no_cancel drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_vset_no_cancel	2006-11-15 14:29:39.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2006-11-15 14:30:18.000000000 -0600
@@ -3776,7 +3776,7 @@ static int ipr_cancel_op(struct scsi_cmn
 	 */
 	if (ioa_cfg->in_reset_reload || ioa_cfg->ioa_is_dead)
 		return FAILED;
-	if (!res || (!ipr_is_gscsi(res) && !ipr_is_vset_device(res)))
+	if (!res || !ipr_is_gscsi(res))
 		return FAILED;
 
 	list_for_each_entry(ipr_cmd, &ioa_cfg->pending_q, queue) {
_
