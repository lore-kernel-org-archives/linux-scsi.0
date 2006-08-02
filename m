From: Brian King <brking@us.ibm.com>
Subject: [PATCH 4/5] ipr: Auto sense handling fix
Date: Wed, 02 Aug 2006 14:57:58 -0500
Message-ID: <200608021957.k72JvxMO026611@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:44230 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S932203AbWHBT6D
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Aug 2006 15:58:03 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k72Jw3kE019474
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Wed, 2 Aug 2006 15:58:03 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k72Jw06F141752
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 2 Aug 2006 13:58:00 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k72Jvxt4026676
	for <linux-scsi@vger.kernel.org>; Wed, 2 Aug 2006 13:57:59 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Fix up a logic error in the checking for valid sense data.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_autosense_fix drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_autosense_fix	2006-08-02 13:54:26.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2006-08-02 13:54:26.000000000 -0500
@@ -4127,8 +4127,7 @@ static int ipr_get_autosense(struct ipr_
 {
 	struct ipr_ioasa *ioasa = &ipr_cmd->ioasa;
 
-	if ((be32_to_cpu(ioasa->ioasc_specific) &
-	     (IPR_ADDITIONAL_STATUS_FMT | IPR_AUTOSENSE_VALID)) == 0)
+	if ((be32_to_cpu(ioasa->ioasc_specific) & IPR_AUTOSENSE_VALID) == 0)
 		return 0;
 
 	memcpy(ipr_cmd->scsi_cmd->sense_buffer, ioasa->auto_sense.data,
_
