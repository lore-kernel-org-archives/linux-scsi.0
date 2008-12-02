From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [PATCH 3/7] megaraid_sas: switch to block timeout
Date: Tue, 2 Dec 2008 06:58:18 -0700
Message-ID: <4B6A08C587958942AA3002690DD4F8C32D641DB6@cosmail02.lsi.com>
References: <1228062471.4115.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og113.obsmtp.com ([64.18.2.179]:57603 "EHLO
	exprod7og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbYLBOMn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2008 09:12:43 -0500
In-Reply-To: <1228062471.4115.30.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Jens Axboe <Jens.Axboe@oracle.com>

ACK.

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
Sent: Sunday, November 30, 2008 11:28 AM
To: linux-scsi
Cc: Mike Anderson; Jens Axboe; Yang, Bo
Subject: [PATCH 3/7] megaraid_sas: switch to block timeout

megaraid_sas sets the timeout in its slave configure routine for devices
on special channels.  This now needs to update the request queue timeout
in block.

Cc: "Yang, Bo" <Bo.Yang@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index a454f94..17ce7ab 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -1016,7 +1016,8 @@ static int megasas_slave_configure(struct scsi_device *sdev)
         * The RAID firmware may require extended timeouts.
         */
        if (sdev->channel >= MEGASAS_MAX_PD_CHANNELS)
-               sdev->timeout = MEGASAS_DEFAULT_CMD_TIMEOUT * HZ;
+               blk_queue_rq_timeout(sdev->request_queue,
+                                    MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
        return 0;
 }



