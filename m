From: Brian King <brking@us.ibm.com>
Subject: [PATCH 3/5] ipr: Properly handle IOA recovered errors
Date: Wed, 02 Aug 2006 14:57:51 -0500
Message-ID: <200608021957.k72JvqVc022239@d01av02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58584 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932199AbWHBT5x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2006 15:57:53 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k72JvrJC016756
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Wed, 2 Aug 2006 15:57:53 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k72JvrGY246416
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 2 Aug 2006 15:57:53 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k72JvqEV022307
	for <linux-scsi@vger.kernel.org>; Wed, 2 Aug 2006 15:57:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


The ipr driver currently translates adapter recovered errors
to DID_ERROR. This patch fixes this to translate these
errors to success instead.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_recovered_errors drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_recovered_errors	2006-08-02 13:54:21.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2006-08-02 13:54:21.000000000 -0500
@@ -4218,7 +4218,8 @@ static void ipr_erp_start(struct ipr_ioa
 	case IPR_IOASC_NR_INIT_CMD_REQUIRED:
 		break;
 	default:
-		scsi_cmd->result |= (DID_ERROR << 16);
+		if (IPR_IOASC_SENSE_KEY(ioasc) > RECOVERED_ERROR)
+			scsi_cmd->result |= (DID_ERROR << 16);
 		if (!ipr_is_vset_device(res) && !ipr_is_naca_model(res))
 			res->needs_sync_complete = 1;
 		break;
_
