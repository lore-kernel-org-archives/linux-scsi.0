From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 1/10] scsi: megaraid_sas - tape drive support fix
Date: Tue, 5 May 2009 17:55:24 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C354F61C22@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C33A07FB03@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og118.obsmtp.com ([64.18.2.8]:39561 "EHLO
	exprod7og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbZEFAKp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2009 20:10:45 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C33A07FB03@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>

Add the Tape drive fix to the megaraid_sas driver: If the command is for the tape device, set the FW pthru timeout to the os layer timeout value.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-05-04 20:06:29.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-05-04 20:08:26.000000000 -0400
@@ -687,6 +687,17 @@ megasas_build_dcdb(struct megasas_instan
        memcpy(pthru->cdb, scp->cmnd, scp->cmd_len);

        /*
+       * If the command is for the tape device, set the
+       * pthru timeout to the os layer timeout value.
+       */
+       if (scp->device->type == TYPE_TAPE) {
+               if ((scp->request->timeout / HZ) > 0xFFFF)
+                       pthru->timeout = 0xFFFF;
+               else
+                       pthru->timeout = scp->request->timeout / HZ;
+       }
+
+       /*
         * Construct SGL
         */
        if (IS_DMA64) {
