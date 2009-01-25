From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] Remove SUGGEST flags
Date: Sun, 25 Jan 2009 15:09:42 -0600
Message-ID: <1232917782.4586.13.camel@localhost.localdomain>
References: <yq1iqov4hf0.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51907 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410AbZAYVJo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jan 2009 16:09:44 -0500
In-Reply-To: <yq1iqov4hf0.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Sun, 2009-01-04 at 03:14 -0500, Martin K. Petersen wrote:
> The SUGGEST_* flags in the SCSI command result have been out of fashion
> for a while and we don't actually use them in the error handling.
> Remove the remaining occurrences.

You forgot osst.c

I think this fixes it.

James

---

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 0ea78d9..8f21cbb 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -280,8 +280,8 @@ static int osst_chk_result(struct osst_tape * STp, struct osst_request * SRpnt)
 			static	int	notyetprinted = 1;
 
 			printk(KERN_WARNING
-			     "%s:W: Warning %x (sugg. bt 0x%x, driver bt 0x%x, host bt 0x%x).\n",
-			     name, result, suggestion(result), driver_byte(result) & DRIVER_MASK,
+			     "%s:W: Warning %x (driver bt 0x%x, host bt 0x%x).\n",
+			     name, result, driver_byte(result),
 			     host_byte(result));
 			if (notyetprinted) {
 				notyetprinted = 0;


