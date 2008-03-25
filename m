From: "Ed Lin" <ed.lin@promise.com>
Subject: RE: [PATCH v2 4/5] stex: use scsi_build_sense_buffer
Date: Tue, 25 Mar 2008 15:44:14 -0700
Message-ID: <85ABFDC4641C4847BA6088F2982EFD8FB06579@nonamew.ptu.promise.com>
References: <1206404816-21710-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:52898 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753851AbYCYWoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Mar 2008 18:44:16 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1206404816-21710-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org
Cc: tomof@acm.org, James Bottomley <James.Bottomley@SteelEye.com>



>-----Original Message-----
>From: fujita [mailto:tomof@acm.org] On Behalf Of FUJITA Tomonori
>Sent: Monday, March 24, 2008 5:27 PM
>To: linux-scsi@vger.kernel.org
>Cc: tomof@acm.org; FUJITA Tomonori; Ed Lin; James Bottomley
>Subject: [PATCH v2 4/5] stex: use scsi_build_sense_buffer
>
>
>Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>Cc: Ed Lin <ed.lin@promise.com>
>Cc: James Bottomley <James.Bottomley@SteelEye.com>
>---
> drivers/scsi/stex.c |   17 +++++------------
> 1 files changed, 5 insertions(+), 12 deletions(-)
>
>diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
>index 8c7b183..f308a03 100644
>--- a/drivers/scsi/stex.c
>+++ b/drivers/scsi/stex.c
>@@ -33,6 +33,7 @@
> #include <scsi/scsi_host.h>
> #include <scsi/scsi_tcq.h>
> #include <scsi/scsi_dbg.h>
>+#include <scsi/scsi_eh.h>
> 
> #define DRV_NAME "stex"
> #define ST_DRIVER_VERSION "3.6.0000.1"
>@@ -362,22 +363,14 @@ static struct status_msg 
>*stex_get_status(struct st_hba *hba)
> 	return status;
> }
> 
>-static void stex_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 
>asc, u8 ascq)
>-{
>-	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
>-
>-	cmd->sense_buffer[0] = 0x70;    /* fixed format, current */
>-	cmd->sense_buffer[2] = sk;
>-	cmd->sense_buffer[7] = 18 - 8;  /* additional sense length */
>-	cmd->sense_buffer[12] = asc;
>-	cmd->sense_buffer[13] = ascq;
>-}
>-
> static void stex_invalid_field(struct scsi_cmnd *cmd,
> 			       void (*done)(struct scsi_cmnd *))
> {
>+	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
>+
> 	/* "Invalid field in cbd" */
>-	stex_set_sense(cmd, ILLEGAL_REQUEST, 0x24, 0x0);
>+	scsi_build_sense_buffer(0, cmd->sense_buffer, 
>ILLEGAL_REQUEST, 0x24,
>+				0x0);
> 	done(cmd);
> }
> 
>-- 
>1.5.3.7
>
>

ACK patch 4.

Ed Lin
