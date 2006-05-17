From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH] fusion - mptspi - reset handler shouldn't be called for other bus protocals
Date: Wed, 17 May 2006 16:17:24 -0600
Message-ID: <20060517221724.GA8700@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:41638 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750974AbWEQWV6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 18:21:58 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com

All registered reset callback handlers are called during reset processing.
The mptspi modules has its own reset callback handler, just recently
added for issuing domain validation after host reset.  If either the mptsas or
mptfc driver are loaded, this callback could be called. Thus resulting
in domain validation being issued for sas or fibre end devices.
This patch insures domain validation is only occuring on spi end devices

This is urgent bug fix. Pls apply this to scsi-rc-fixes-2.6,
as well as this patch posted yesterday:
http://marc.theaimsgroup.com/?l=linux-scsi&m=114782261719616&w=2


Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

--- rc4u/drivers/message/fusion/mptspi.c	2006-05-12 00:14:15.000000000 -0500
+++ rc4/drivers/message/fusion/mptspi.c	2006-05-17 12:23:08.924423654 -0500
@@ -825,6 +825,9 @@
 
 	rc = mptscsih_ioc_reset(ioc, reset_phase);
 
+	if (rc == 0 || ioc->bus_type != SPI)
+		return rc;
+
 	if (reset_phase == MPT_IOC_POST_RESET)
 		mptspi_dv_renegotiate(hd);
 
